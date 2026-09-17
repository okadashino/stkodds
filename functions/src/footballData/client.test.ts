import { describe, expect, it, vi } from "vitest";
import { FootballDataClient, UnsupportedCompetitionError } from "./client";

function jsonResponse(body: unknown, status = 200, headers: Record<string, string> = {}): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...headers },
  });
}

describe("FootballDataClient", () => {
  it("reads the API key from env and never requires a hardcoded token", async () => {
    const fetchMock = vi.fn().mockResolvedValue(
      jsonResponse({ matches: [] }),
    );
    vi.stubEnv("FOOTBALL_DATA_API_KEY", "env-secret");

    const client = new FootballDataClient({
      fetch: fetchMock,
      sleep: async () => undefined,
    });
    await client.getMatchday("PL", 1);

    expect(fetchMock).toHaveBeenCalledWith(
      "https://api.football-data.org/v4/competitions/PL/matches?matchday=1",
      expect.objectContaining({
        headers: expect.objectContaining({ "X-Auth-Token": "env-secret" }),
      }),
    );

    vi.unstubAllEnvs();
  });

  it("rejects competitions outside the allowed set", async () => {
    const client = new FootballDataClient({
      apiKey: "test-key",
      fetch: vi.fn(),
    });

    await expect(client.getMatches("DED", "2026-01-01", "2026-01-07")).rejects.toBeInstanceOf(
      UnsupportedCompetitionError,
    );
  });

  it("retries after a 429 using Retry-After", async () => {
    const sleep = vi.fn().mockResolvedValue(undefined);
    const fetchMock = vi
      .fn()
      .mockResolvedValueOnce(jsonResponse({ message: "limit" }, 429, { "Retry-After": "2" }))
      .mockResolvedValueOnce(jsonResponse({ matches: [] }));

    const client = new FootballDataClient({
      apiKey: "test-key",
      fetch: fetchMock,
      sleep,
      throttle: { acquire: async () => undefined },
    });

    await client.getMatches("SA", "2026-09-19", "2026-09-21");

    expect(fetchMock).toHaveBeenCalledTimes(2);
    expect(sleep).toHaveBeenCalledWith(2000);
  });
});
