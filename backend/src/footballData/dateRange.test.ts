import { describe, expect, it } from "vitest";
import { dateRangeChunks, FOOTBALL_DATA_CHUNK_DAYS, utcDateOffset } from "./dateRange";

describe("dateRangeChunks", () => {
  it("splits a 3-day matchday lookback through today+21 into three 9-day football-data chunks", () => {
    expect(FOOTBALL_DATA_CHUNK_DAYS).toBe(9);
    expect(dateRangeChunks("2026-09-18", "2026-10-12")).toEqual([
      ["2026-09-18", "2026-09-26"],
      ["2026-09-27", "2026-10-05"],
      ["2026-10-06", "2026-10-12"],
    ]);
  });

  it("keeps a short range as a single chunk", () => {
    expect(dateRangeChunks("2026-09-21", "2026-09-28")).toEqual([["2026-09-21", "2026-09-28"]]);
  });
});

describe("utcDateOffset", () => {
  it("formats a UTC calendar day offset", () => {
    expect(utcDateOffset(new Date("2026-09-21T12:00:00.000Z"), 21)).toBe("2026-10-12");
    expect(utcDateOffset(new Date("2026-09-21T12:00:00.000Z"), -3)).toBe("2026-09-18");
  });
});
