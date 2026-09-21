import { describe, expect, it } from "vitest";
import { monthScopeId, utcYearMonth } from "./months";

describe("months", () => {
  it("formats a UTC year-month from an ISO kickoff", () => {
    expect(utcYearMonth("2026-09-16T18:45:00Z")).toBe("2026-09");
    expect(utcYearMonth("2026-10-01T00:00:00Z")).toBe("2026-10");
    expect(utcYearMonth(new Date("2026-01-31T23:00:00Z"))).toBe("2026-01");
  });

  it("builds a month scope id", () => {
    expect(monthScopeId("2026-09")).toBe("month_2026-09");
    expect(monthScopeId("month_2026-09")).toBe("month_2026-09");
  });
});
