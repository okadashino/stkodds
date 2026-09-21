import { describe, expect, it, vi } from "vitest";
import { ALLOWED_COMPETITIONS } from "./footballData/competitions";
import type { FootballDataClient } from "./footballData/client";
import type { FootballMatchDto } from "./footballData/mapMatch";
import { run } from "./run";
import type {
  BackendStore,
  FixtureDocument,
  LeagueRecord,
  PredictionRecord,
  RoundRecord,
  StandingEntry,
} from "./sync/types";

const NOW = new Date("2026-09-18T12:00:00.000Z");

function match(overrides: Partial<FootballMatchDto> = {}): FootballMatchDto {
  return {
    apiId: 200,
    competition: "SA",
    matchday: 4,
    homeTeam: "Roma",
    awayTeam: "Lazio",
    kickoff: "2026-09-20T18:45:00Z",
    status: "scheduled",
    homeScore: null,
    awayScore: null,
    ...overrides,
  };
}

function roundRecord(overrides: Partial<RoundRecord> = {}): RoundRecord {
  return {
    id: "r1",
    leagueId: "lg1",
    type: "matchday",
    competitionCodes: ["SA"],
    matchday: 3,
    dateFrom: new Date("2026-09-16T00:00:00Z"),
    dateTo: new Date("2026-09-18T00:00:00Z"),
    fixtureIds: ["10"],
    status: "locked",
    ...overrides,
  };
}

describe("run", () => {
  it("syncs the palinsesto, updates finished scores, scores global picks, and rebuilds every league table", async () => {
    const upserts: FixtureDocument[] = [];
    const fixtureUpdates: Array<{ id: string; patch: Record<string, unknown> }> = [];
    const predictionWrites: Array<{ id: string; points: number }> = [];
    const roundStandings: Record<string, StandingEntry[]> = {};
    const seasonStandings: Record<string, StandingEntry[]> = {};
    const monthStandings: Record<string, StandingEntry[]> = {};
    const seasonPointsWrites: Record<string, Record<string, number>> = {};
    const requestedPredictionIds: string[][] = [];

    const tooOld = match({
      apiId: 9,
      matchday: 2,
      homeTeam: "Atalanta",
      awayTeam: "Bologna",
      kickoff: "2026-09-14T18:45:00Z",
      status: "finished",
      homeScore: 1,
      awayScore: 0,
    });
    const finished = match({
      apiId: 10,
      matchday: 3,
      homeTeam: "Milan",
      awayTeam: "Inter",
      kickoff: "2026-09-15T18:45:00Z",
      status: "finished",
      homeScore: 2,
      awayScore: 1,
    });
    const upcoming = match({ apiId: 200, kickoff: "2026-09-20T18:45:00Z" });
    const border = match({
      apiId: 250,
      matchday: 4,
      homeTeam: "Torino",
      awayTeam: "Lecce",
      kickoff: "2026-09-24T18:45:00Z",
    });
    const nextWeek = match({
      apiId: 300,
      matchday: 5,
      homeTeam: "Napoli",
      awayTeam: "Milan",
      kickoff: "2026-09-27T18:45:00Z",
    });

    const predictions: PredictionRecord[] = [
      {
        id: "u1_10",
        userId: "u1",
        fixtureId: "10",
        outcome: "home",
        homeGoals: 2,
        awayGoals: 1,
        points: null,
      },
      {
        id: "u2_10",
        userId: "u2",
        fixtureId: "10",
        outcome: "home",
        homeGoals: 3,
        awayGoals: 2,
        points: 2,
      },
    ];

    const leagues = new Map<string, LeagueRecord>([
      [
        "lg1",
        {
          id: "lg1",
          members: ["u1", "u2", "u3"],
          seasonPoints: { u1: 0, u2: 0, u3: 0 },
          nicknames: { u1: "Ana", u2: "Bo", u3: "Cy" },
        },
      ],
      [
        "lg2",
        {
          id: "lg2",
          members: ["u9"],
          seasonPoints: { u9: 0 },
          nicknames: { u9: "Jo" },
        },
      ],
    ]);

    const rounds: RoundRecord[] = [
      roundRecord(),
      roundRecord({
        id: "r2",
        leagueId: "lg2",
        fixtureIds: ["99"],
        status: "open",
      }),
    ];

    const store: BackendStore = {
      getActiveRounds: async () => {
        throw new Error("palinsesto sync must not depend on active rounds");
      },
      getLeagues: async () => [...leagues.values()],
      getRoundsByLeagueIds: async (ids) =>
        rounds.filter((round) => ids.includes(round.leagueId)),
      getFixturesByIds: async (ids) => {
        const wanted = new Set(ids);
        return upserts.filter((fixture) => wanted.has(fixture.id));
      },
      upsertFixture: async (fixture) => {
        upserts.push(fixture);
      },
      updateFixture: async (id, patch) => {
        fixtureUpdates.push({ id, patch });
      },
      getPredictionsByFixtureIds: async (fixtureIds) => {
        requestedPredictionIds.push([...fixtureIds].sort());
        const wanted = new Set(fixtureIds);
        return predictions.filter((prediction) => wanted.has(prediction.fixtureId));
      },
      updatePredictionPoints: async (id, points) => {
        predictionWrites.push({ id, points });
        const prediction = predictions.find((item) => item.id === id);
        if (prediction) {
          prediction.points = points;
        }
      },
      getLeaguesByIds: async (ids) =>
        ids
          .map((id) => leagues.get(id))
          .filter((league): league is LeagueRecord => Boolean(league)),
      replaceRoundStandings: async (roundId, entries) => {
        roundStandings[roundId] = entries;
      },
      replaceSeasonStandings: async (leagueId, entries, seasonPoints) => {
        seasonStandings[leagueId] = entries;
        seasonPointsWrites[leagueId] = seasonPoints;
      },
      replaceMonthStandings: async (leagueId, yearMonth, entries) => {
        monthStandings[`${leagueId}:${yearMonth}`] = entries;
      },
    };

    const getMatches = vi.fn(async (competition: string, from: string, to: string) => {
      if (competition !== "SA") {
        return [];
      }
      const inRange = [tooOld, finished, upcoming, border, nextWeek].filter((item) => {
        const day = item.kickoff.slice(0, 10);
        return day >= from && day <= to;
      });
      // Simulate a match returned on both sides of a chunk boundary.
      if (from === "2026-09-24") {
        return [...inRange, border];
      }
      return inRange;
    });
    const getMatchday = vi.fn();
    const acquire = vi.fn(async () => undefined);
    const logger = { info: vi.fn(), warn: vi.fn() };

    const summary = await run({
      store,
      client: { getMatches, getMatchday } as unknown as FootballDataClient,
      logger,
      now: NOW,
      throttle: { acquire },
    });

    expect(getMatchday).not.toHaveBeenCalled();
    expect(acquire).toHaveBeenCalledTimes(ALLOWED_COMPETITIONS.length * 3);
    expect(getMatches.mock.calls.map((call) => call[0])).toEqual(
      ALLOWED_COMPETITIONS.flatMap((code) => [code, code, code]),
    );
    for (const code of ALLOWED_COMPETITIONS) {
      expect(getMatches).toHaveBeenCalledWith(code, "2026-09-15", "2026-09-23");
      expect(getMatches).toHaveBeenCalledWith(code, "2026-09-24", "2026-10-02");
      expect(getMatches).toHaveBeenCalledWith(code, "2026-10-03", "2026-10-09");
    }

    expect(upserts.some((fixture) => fixture.apiId === 9)).toBe(false);
    expect(upserts).toEqual([
      {
        id: "200",
        apiId: 200,
        competition: "SA",
        matchday: 4,
        homeTeam: "Roma",
        awayTeam: "Lazio",
        kickoff: "2026-09-20T18:45:00Z",
        status: "scheduled",
        homeScore: null,
        awayScore: null,
      },
      {
        id: "250",
        apiId: 250,
        competition: "SA",
        matchday: 4,
        homeTeam: "Torino",
        awayTeam: "Lecce",
        kickoff: "2026-09-24T18:45:00Z",
        status: "scheduled",
        homeScore: null,
        awayScore: null,
      },
      {
        id: "300",
        apiId: 300,
        competition: "SA",
        matchday: 5,
        homeTeam: "Napoli",
        awayTeam: "Milan",
        kickoff: "2026-09-27T18:45:00Z",
        status: "scheduled",
        homeScore: null,
        awayScore: null,
      },
      {
        id: "10",
        apiId: 10,
        competition: "SA",
        matchday: 3,
        homeTeam: "Milan",
        awayTeam: "Inter",
        kickoff: "2026-09-15T18:45:00Z",
        status: "finished",
        homeScore: 2,
        awayScore: 1,
      },
    ]);
    expect(fixtureUpdates).toEqual([
      { id: "10", patch: { status: "finished", homeScore: 2, awayScore: 1 } },
    ]);

    expect(predictionWrites).toEqual([{ id: "u1_10", points: 3 }]);
    expect(requestedPredictionIds.some((ids) => ids.includes("10"))).toBe(true);

    expect(roundStandings.r1).toEqual([
      { userId: "u1", nickname: "Ana", points: 3, rank: 1 },
      { userId: "u2", nickname: "Bo", points: 2, rank: 2 },
      { userId: "u3", nickname: "Cy", points: 0, rank: 3 },
    ]);
    expect(roundStandings.r2).toEqual([{ userId: "u9", nickname: "Jo", points: 0, rank: 1 }]);
    expect(seasonStandings.lg1?.map((entry) => entry.userId)).toEqual(["u1", "u2", "u3"]);
    expect(seasonPointsWrites).toEqual({
      lg1: { u1: 3, u2: 2, u3: 0 },
      lg2: { u9: 0 },
    });
    expect(monthStandings["lg1:2026-09"]).toEqual([
      { userId: "u1", nickname: "Ana", points: 3, rank: 1 },
      { userId: "u2", nickname: "Bo", points: 2, rank: 2 },
      { userId: "u3", nickname: "Cy", points: 0, rank: 3 },
    ]);
    expect(monthStandings["lg2:2026-09"]).toBeUndefined();

    expect(summary).toEqual({
      fixturesUpdated: 4,
      fixturesFinished: 1,
      predictionsScored: 1,
      roundStandingsUpdated: 2,
      seasonStandingsUpdated: 2,
      monthStandingsUpdated: 1,
    });
    expect(logger.info).toHaveBeenCalledWith("Palinsesto PL: upserted 0 unique fixtures");
    expect(logger.info).toHaveBeenCalledWith("Palinsesto PD: upserted 0 unique fixtures");
    expect(logger.info).toHaveBeenCalledWith("Palinsesto BL1: upserted 0 unique fixtures");
    expect(logger.info).toHaveBeenCalledWith("Palinsesto SA: upserted 4 unique fixtures");
    expect(logger.info).toHaveBeenCalledWith("Palinsesto FL1: upserted 0 unique fixtures");
    expect(logger.info).toHaveBeenCalledWith("Palinsesto CL: upserted 0 unique fixtures");
    expect(logger.info).toHaveBeenCalledWith(
      "Sync summary: fixturesUpdated=4 fixturesFinished=1 predictionsScored=1 roundStandings=2 seasonStandings=2 monthStandings=1",
    );
  });

  it("keeps 10 October in the palinsesto from 21 September", async () => {
    const upserts: FixtureDocument[] = [];
    const october = match({
      apiId: 400,
      competition: "PL",
      matchday: 8,
      homeTeam: "Arsenal",
      awayTeam: "Chelsea",
      kickoff: "2026-10-10T14:00:00Z",
    });
    const tooFar = match({
      apiId: 401,
      competition: "PL",
      matchday: 8,
      homeTeam: "Liverpool",
      awayTeam: "Everton",
      kickoff: "2026-10-13T19:00:00Z",
    });

    const store: BackendStore = {
      getActiveRounds: async () => [],
      getLeagues: async () => [],
      getRoundsByLeagueIds: async () => [],
      getFixturesByIds: async () => [],
      upsertFixture: async (fixture) => {
        upserts.push(fixture);
      },
      updateFixture: async () => undefined,
      getPredictionsByFixtureIds: async () => [],
      updatePredictionPoints: async () => undefined,
      getLeaguesByIds: async () => [],
      replaceRoundStandings: async () => undefined,
      replaceSeasonStandings: async () => undefined,
      replaceMonthStandings: async () => undefined,
    };

    const getMatches = vi.fn(async (competition: string, from: string, to: string) => {
      if (competition !== "PL") {
        return [];
      }
      return [october, tooFar].filter((item) => {
        const day = item.kickoff.slice(0, 10);
        return day >= from && day <= to;
      });
    });

    await run({
      store,
      client: { getMatches, getMatchday: vi.fn() } as unknown as FootballDataClient,
      logger: { info: vi.fn(), warn: vi.fn() },
      now: new Date("2026-09-21T12:00:00.000Z"),
      throttle: { acquire: async () => undefined },
    });

    for (const code of ALLOWED_COMPETITIONS) {
      expect(getMatches).toHaveBeenCalledWith(code, "2026-09-18", "2026-09-26");
      expect(getMatches).toHaveBeenCalledWith(code, "2026-09-27", "2026-10-05");
      expect(getMatches).toHaveBeenCalledWith(code, "2026-10-06", "2026-10-12");
    }
    expect(upserts.map((fixture) => fixture.apiId)).toEqual([400]);
  });
});
