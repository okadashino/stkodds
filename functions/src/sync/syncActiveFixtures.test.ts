import { describe, expect, it, vi } from "vitest";
import type { FootballDataClient } from "../footballData/client";
import type { FootballMatchDto } from "../footballData/mapMatch";
import { fixtureNeedsUpdate, syncActiveRoundFixtures } from "./syncActiveFixtures";
import type { FixtureRecord, RoundRecord } from "./types";

function match(overrides: Partial<FootballMatchDto> = {}): FootballMatchDto {
  return {
    apiId: 10,
    competition: "SA",
    matchday: 3,
    homeTeam: "Milan",
    awayTeam: "Inter",
    kickoff: "2026-09-20T16:30:00Z",
    status: "live",
    homeScore: 1,
    awayScore: 0,
    ...overrides,
  };
}

function fixture(overrides: Partial<FixtureRecord> = {}): FixtureRecord {
  return {
    id: "f1",
    apiId: 10,
    status: "scheduled",
    homeScore: null,
    awayScore: null,
    ...overrides,
  };
}

function round(overrides: Partial<RoundRecord> = {}): RoundRecord {
  return {
    id: "r1",
    type: "matchday",
    competitionCodes: ["SA"],
    matchday: 3,
    dateFrom: new Date("2026-09-19T00:00:00Z"),
    dateTo: new Date("2026-09-21T00:00:00Z"),
    fixtureIds: ["f1"],
    status: "open",
    ...overrides,
  };
}

describe("fixtureNeedsUpdate", () => {
  it("is false when status and scores are unchanged", () => {
    expect(
      fixtureNeedsUpdate(
        fixture({ status: "live", homeScore: 1, awayScore: 0 }),
        match(),
      ),
    ).toBe(false);
  });

  it("is true when status or a score changed", () => {
    expect(fixtureNeedsUpdate(fixture(), match())).toBe(true);
    expect(
      fixtureNeedsUpdate(
        fixture({ status: "live", homeScore: 1, awayScore: 0 }),
        match({ awayScore: 1 }),
      ),
    ).toBe(true);
  });
});

describe("syncActiveRoundFixtures", () => {
  it("updates a fixture only when live data changed and logs the count", async () => {
    const updates: Array<{ id: string; patch: Record<string, unknown> }> = [];
    const getMatchday = vi.fn().mockResolvedValue([
      match(),
      match({ apiId: 99, homeTeam: "Ignored" }),
    ]);
    const logger = { info: vi.fn(), warn: vi.fn() };

    const updated = await syncActiveRoundFixtures({
      store: {
        getActiveRounds: async () => [round(), round({ id: "r2", status: "locked" })],
        getFixturesByIds: async () => [fixture()],
        updateFixture: async (id, patch) => {
          updates.push({ id, patch });
        },
      },
      client: { getMatchday, getMatches: vi.fn() } as unknown as FootballDataClient,
      logger,
    });

    expect(getMatchday).toHaveBeenCalledTimes(1);
    expect(getMatchday).toHaveBeenCalledWith("SA", 3);
    expect(updates).toEqual([
      { id: "f1", patch: { status: "live", homeScore: 1, awayScore: 0 } },
    ]);
    expect(updated).toBe(1);
    expect(logger.info).toHaveBeenCalledWith("Updated 1 fixtures");
  });

  it("skips the API when every tracked fixture is already finished", async () => {
    const getMatchday = vi.fn();
    const updated = await syncActiveRoundFixtures({
      store: {
        getActiveRounds: async () => [round()],
        getFixturesByIds: async () => [
          fixture({ status: "finished", homeScore: 2, awayScore: 1 }),
        ],
        updateFixture: async () => {
          throw new Error("should not write");
        },
      },
      client: { getMatchday, getMatches: vi.fn() } as unknown as FootballDataClient,
      logger: { info: vi.fn(), warn: vi.fn() },
    });

    expect(getMatchday).not.toHaveBeenCalled();
    expect(updated).toBe(0);
  });

  it("uses date range fetches for non-matchday rounds", async () => {
    const getMatches = vi.fn().mockResolvedValue([match({ status: "scheduled" })]);
    await syncActiveRoundFixtures({
      store: {
        getActiveRounds: async () => [
          round({ type: "weekend", matchday: undefined, fixtureIds: ["f1"] }),
        ],
        getFixturesByIds: async () => [fixture()],
        updateFixture: async () => undefined,
      },
      client: { getMatchday: vi.fn(), getMatches } as unknown as FootballDataClient,
      logger: { info: vi.fn(), warn: vi.fn() },
    });

    expect(getMatches).toHaveBeenCalledWith("SA", "2026-09-19", "2026-09-21");
  });
});
