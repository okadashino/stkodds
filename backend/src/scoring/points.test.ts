import { describe, expect, it } from "vitest";
import { scorePrediction } from "./points";

describe("scorePrediction", () => {
  it("awards 3 for the exact score", () => {
    expect(
      scorePrediction(
        { outcome: "home", homeGoals: 2, awayGoals: 1 },
        { homeScore: 2, awayScore: 1 },
      ),
    ).toBe(3);
  });

  it("awards 2 for correct 1X2 and goal difference", () => {
    expect(
      scorePrediction(
        { outcome: "home", homeGoals: 2, awayGoals: 1 },
        { homeScore: 3, awayScore: 2 },
      ),
    ).toBe(2);
  });

  it("awards 1 for correct 1X2 only", () => {
    expect(
      scorePrediction(
        { outcome: "home", homeGoals: 3, awayGoals: 0 },
        { homeScore: 2, awayScore: 1 },
      ),
    ).toBe(1);
    expect(
      scorePrediction(
        { outcome: "away", homeGoals: 0, awayGoals: 2 },
        { homeScore: 0, awayScore: 1 },
      ),
    ).toBe(1);
  });

  it("awards 0 when the 1X2 is wrong", () => {
    expect(
      scorePrediction(
        { outcome: "home", homeGoals: 2, awayGoals: 0 },
        { homeScore: 0, awayScore: 1 },
      ),
    ).toBe(0);
  });
});
