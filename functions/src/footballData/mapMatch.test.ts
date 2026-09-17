import { describe, expect, it } from "vitest";
import { mapFootballMatch } from "./mapMatch";

describe("mapFootballMatch", () => {
  it("maps v4 match fields onto the fixture shape", () => {
    const mapped = mapFootballMatch({
      id: 327117,
      utcDate: "2026-09-20T16:30:00Z",
      status: "FINISHED",
      matchday: 5,
      competition: { code: "PL" },
      homeTeam: { name: "Manchester City FC", shortName: "Man City" },
      awayTeam: { name: "Arsenal FC", shortName: "Arsenal" },
      score: { fullTime: { home: 2, away: 1 } },
    });

    expect(mapped).toEqual({
      apiId: 327117,
      competition: "PL",
      matchday: 5,
      homeTeam: "Man City",
      awayTeam: "Arsenal",
      kickoff: "2026-09-20T16:30:00Z",
      status: "finished",
      homeScore: 2,
      awayScore: 1,
    });
  });

  it("keeps scores null before kickoff", () => {
    const mapped = mapFootballMatch({
      id: 1,
      utcDate: "2026-09-21T14:00:00Z",
      status: "TIMED",
      matchday: 6,
      competition: { code: "SA" },
      homeTeam: { name: "AC Milan" },
      awayTeam: { name: "Inter" },
      score: { fullTime: { home: null, away: null } },
    });

    expect(mapped.status).toBe("scheduled");
    expect(mapped.homeScore).toBeNull();
    expect(mapped.awayScore).toBeNull();
    expect(mapped.homeTeam).toBe("AC Milan");
  });
});
