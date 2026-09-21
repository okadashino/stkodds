import { describe, expect, it } from "vitest";
import { dateRangeChunks, FOOTBALL_DATA_CHUNK_DAYS, utcDateOffset } from "./dateRange";

describe("dateRangeChunks", () => {
  it("splits a 3-day matchday lookback through today+14 into two 9-day football-data chunks", () => {
    expect(FOOTBALL_DATA_CHUNK_DAYS).toBe(9);
    expect(dateRangeChunks("2026-09-15", "2026-10-02")).toEqual([
      ["2026-09-15", "2026-09-23"],
      ["2026-09-24", "2026-10-02"],
    ]);
  });

  it("keeps a short range as a single chunk", () => {
    expect(dateRangeChunks("2026-09-21", "2026-09-28")).toEqual([["2026-09-21", "2026-09-28"]]);
  });
});

describe("utcDateOffset", () => {
  it("formats a UTC calendar day offset", () => {
    expect(utcDateOffset(new Date("2026-09-21T12:00:00.000Z"), 14)).toBe("2026-10-05");
    expect(utcDateOffset(new Date("2026-09-21T12:00:00.000Z"), -3)).toBe("2026-09-18");
  });
});
