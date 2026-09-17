import { describe, expect, it, vi } from "vitest";
import type { FootballDataClient } from "./footballData/client";
import { run } from "./run";
import type { BackendStore, LeagueRecord, PredictionRecord, StandingEntry } from "./sync/types";

function jsonMatch(overrides: Record<string, unknown> = {}) {
  return {
    apiId: 10,
    competition: "SA",
    matchday: 3,
    homeTeam: "Milan",
    awayTeam: "Inter",
    kickoff: "2026-09-20T16:30:00Z",
    status: "finished" as const,
    homeScore: 2,
    awayScore: 1,
    ...overrides,
  };
}

describe("run", () => {
  it("updates changed fixtures, scores finished predictions idempotently, and rebuilds standings", async () => {
    const fixtureUpdates: Array<{ id: string; patch: Record<string, unknown> }> = [];
    const predictionWrites: Array<{ id: string; points: number }> = [];
    const roundStandings: StandingEntry[][] = [];
    const seasonStandings: StandingEntry[][] = [];
    const seasonPointsWrites: Array<Record<string, number>> = [];

    const predictions: PredictionRecord[] = [
      {
        id: "p-exact",
        userId: "u1",
        roundId: "r1",
        fixtureId: "f1",
        outcome: "home",
        homeGoals: 2,
        awayGoals: 1,
        points: null,
      },
      {
        id: "p-gd",
        userId: "u2",
        roundId: "r1",
        fixtureId: "f1",
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
    ]);

    const store: BackendStore = {
      getActiveRounds: async () => [
        {
          id: "r1",
          leagueId: "lg1",
          type: "matchday",
          competitionCodes: ["SA"],
          matchday: 3,
          dateFrom: new Date("2026-09-19T00:00:00Z"),
          dateTo: new Date("2026-09-21T00:00:00Z"),
          fixtureIds: ["f1"],
          status: "locked",
        },
      ],
      getRoundsByLeagueIds: async () => [
        {
          id: "r1",
          leagueId: "lg1",
          type: "matchday",
          competitionCodes: ["SA"],
          matchday: 3,
          dateFrom: new Date("2026-09-19T00:00:00Z"),
          dateTo: new Date("2026-09-21T00:00:00Z"),
          fixtureIds: ["f1"],
          status: "locked",
        },
      ],
      getFixturesByIds: async () => [
        { id: "f1", apiId: 10, status: "live", homeScore: 1, awayScore: 0 },
      ],
      updateFixture: async (id, patch) => {
        fixtureUpdates.push({ id, patch });
      },
      getPredictionsByRoundIds: async () => predictions,
      updatePredictionPoints: async (id, points) => {
        predictionWrites.push({ id, points });
        const prediction = predictions.find((item) => item.id === id);
        if (prediction) {
          prediction.points = points;
        }
      },
      getLeaguesByIds: async (ids) => ids.map((id) => leagues.get(id)).filter((league): league is LeagueRecord => Boolean(league)),
      replaceRoundStandings: async (_roundId, entries) => {
        roundStandings.push(entries);
      },
      replaceSeasonStandings: async (_leagueId, entries, seasonPoints) => {
        seasonStandings.push(entries);
        seasonPointsWrites.push(seasonPoints);
      },
    };

    const getMatchday = vi.fn().mockResolvedValue([jsonMatch()]);
    const logger = { info: vi.fn(), warn: vi.fn() };

    const summary = await run({
      store,
      client: { getMatchday, getMatches: vi.fn() } as unknown as FootballDataClient,
      logger,
    });

    expect(fixtureUpdates).toEqual([
      { id: "f1", patch: { status: "finished", homeScore: 2, awayScore: 1 } },
    ]);
    expect(predictionWrites).toEqual([{ id: "p-exact", points: 3 }]);
    expect(roundStandings[0]).toEqual([
      { userId: "u1", nickname: "Ana", points: 3, rank: 1 },
      { userId: "u2", nickname: "Bo", points: 2, rank: 2 },
    ]);
    expect(seasonStandings[0]?.map((entry) => entry.userId)).toEqual(["u1", "u2", "u3"]);
    expect(seasonPointsWrites[0]).toEqual({ u1: 3, u2: 2, u3: 0 });
    expect(summary).toEqual({
      fixturesUpdated: 1,
      fixturesFinished: 1,
      predictionsScored: 1,
      roundStandingsUpdated: 1,
      seasonStandingsUpdated: 1,
    });
    expect(logger.info).toHaveBeenCalledWith(
      "Sync summary: fixturesUpdated=1 fixturesFinished=1 predictionsScored=1 roundStandings=1 seasonStandings=1",
    );
  });
});
