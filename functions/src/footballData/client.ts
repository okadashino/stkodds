import { isAllowedCompetition } from "./competitions";
import { mapFootballMatch, type FootballDataMatch, type FootballMatchDto } from "./mapMatch";
import { delay, MinuteThrottle, type Throttle } from "./throttle";

const BASE_URL = "https://api.football-data.org/v4";
const API_KEY_ENV = "FOOTBALL_DATA_API_KEY";
const MAX_RETRIES = 3;

export class MissingApiKeyError extends Error {
  constructor() {
    super(`${API_KEY_ENV} is not set`);
    this.name = "MissingApiKeyError";
  }
}

export class UnsupportedCompetitionError extends Error {
  constructor(code: string) {
    super(`Competition ${code} is not allowed`);
    this.name = "UnsupportedCompetitionError";
  }
}

export class FootballDataHttpError extends Error {
  constructor(
    readonly status: number,
    message: string,
  ) {
    super(message);
    this.name = "FootballDataHttpError";
  }
}

export interface FootballDataClientOptions {
  apiKey?: string;
  fetch?: typeof fetch;
  throttle?: Throttle;
  sleep?: (ms: number) => Promise<void>;
}

export class FootballDataClient {
  private readonly apiKey: string;
  private readonly fetchImpl: typeof fetch;
  private readonly throttle: Throttle;
  private readonly sleep: (ms: number) => Promise<void>;

  constructor(options: FootballDataClientOptions = {}) {
    this.apiKey = options.apiKey ?? process.env[API_KEY_ENV] ?? "";
    this.fetchImpl = options.fetch ?? fetch;
    this.sleep = options.sleep ?? delay;
    this.throttle = options.throttle ?? new MinuteThrottle(10, 60_000, this.sleep);
  }

  async getMatches(
    competition: string,
    dateFrom: string,
    dateTo: string,
  ): Promise<FootballMatchDto[]> {
    const query = new URLSearchParams({ dateFrom, dateTo });
    return this.requestMatches(competition, query);
  }

  async getMatchday(competition: string, matchday: number): Promise<FootballMatchDto[]> {
    const query = new URLSearchParams({ matchday: String(matchday) });
    return this.requestMatches(competition, query);
  }

  private async requestMatches(
    competition: string,
    query: URLSearchParams,
  ): Promise<FootballMatchDto[]> {
    this.assertCompetition(competition);
    const url = `${BASE_URL}/competitions/${competition}/matches?${query.toString()}`;
    const payload = await this.getJson<{ matches?: FootballDataMatch[] }>(url);
    return (payload.matches ?? []).map((match) => mapFootballMatch(match, competition));
  }

  private assertCompetition(competition: string): void {
    if (!isAllowedCompetition(competition)) {
      throw new UnsupportedCompetitionError(competition);
    }
  }

  private async getJson<T>(url: string): Promise<T> {
    if (!this.apiKey) {
      throw new MissingApiKeyError();
    }

    let lastError: unknown;
    for (let attempt = 0; attempt <= MAX_RETRIES; attempt += 1) {
      await this.throttle.acquire();
      const response = await this.fetchImpl(url, {
        method: "GET",
        headers: {
          "X-Auth-Token": this.apiKey,
          Accept: "application/json",
        },
      });

      if (response.status === 429) {
        const retryAfterMs = parseRetryAfter(response.headers.get("Retry-After"));
        await this.sleep(retryAfterMs);
        lastError = new FootballDataHttpError(429, "Rate limited by football-data.org");
        continue;
      }

      if (!response.ok) {
        throw new FootballDataHttpError(
          response.status,
          `football-data.org request failed with ${response.status}`,
        );
      }

      return (await response.json()) as T;
    }

    throw lastError instanceof Error
      ? lastError
      : new FootballDataHttpError(429, "Rate limited by football-data.org");
  }
}

function parseRetryAfter(header: string | null): number {
  if (!header) {
    return 60_000;
  }
  const seconds = Number(header);
  if (Number.isFinite(seconds) && seconds >= 0) {
    return Math.round(seconds * 1000);
  }
  const dateMs = Date.parse(header);
  if (Number.isFinite(dateMs)) {
    return Math.max(dateMs - Date.now(), 0);
  }
  return 60_000;
}
