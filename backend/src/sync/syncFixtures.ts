import { isAllowedCompetition } from "../footballData/competitions";
import type { FootballDataClient } from "../footballData/client";
import type { FootballMatchDto } from "../footballData/mapMatch";
import type { BackendStore, FixtureRecord, RoundRecord, SyncLogger } from "./types";

const TERMINAL_STATUSES = new Set(["finished", "cancelled"]);

export function fixtureNeedsUpdate(
  current: FixtureRecord,
  incoming: FootballMatchDto,
): boolean {
  return (
    current.status !== incoming.status ||
    current.homeScore !== incoming.homeScore ||
    current.awayScore !== incoming.awayScore
  );
}

export async function syncActiveRoundFixtures(options: {
  store: BackendStore;
  client: FootballDataClient;
  logger: SyncLogger;
  rounds: RoundRecord[];
  fixtures: FixtureRecord[];
}): Promise<{ updated: number; fixtures: FixtureRecord[] }> {
  const { store, client, logger, rounds } = options;
  const fixturesById = new Map(options.fixtures.map((fixture) => [fixture.id, fixture]));
  const fixturesByApiId = new Map(options.fixtures.map((fixture) => [fixture.apiId, fixture]));
  const jobs = collectApiJobs(rounds, logger);
  let updated = 0;

  for (const job of jobs) {
    const tracked = [...job.fixtureIds]
      .map((id) => fixturesById.get(id))
      .filter((fixture): fixture is FixtureRecord => fixture != null);

    if (tracked.length === 0 || tracked.every((fixture) => TERMINAL_STATUSES.has(fixture.status))) {
      continue;
    }

    const matches =
      job.kind === "matchday"
        ? await client.getMatchday(job.competition, job.matchday)
        : await client.getMatches(job.competition, job.dateFrom, job.dateTo);

    const wantedApiIds = new Set(tracked.map((fixture) => fixture.apiId));
    for (const incoming of matches) {
      if (!wantedApiIds.has(incoming.apiId)) {
        continue;
      }
      const current = fixturesByApiId.get(incoming.apiId);
      if (!current || !fixtureNeedsUpdate(current, incoming)) {
        continue;
      }
      await store.updateFixture(current.id, {
        status: incoming.status,
        homeScore: incoming.homeScore,
        awayScore: incoming.awayScore,
      });
      current.status = incoming.status;
      current.homeScore = incoming.homeScore;
      current.awayScore = incoming.awayScore;
      updated += 1;
    }
  }

  return { updated, fixtures: [...fixturesById.values()] };
}

interface MatchdayJob {
  kind: "matchday";
  key: string;
  competition: string;
  matchday: number;
  fixtureIds: Set<string>;
}

interface RangeJob {
  kind: "range";
  key: string;
  competition: string;
  dateFrom: string;
  dateTo: string;
  fixtureIds: Set<string>;
}

type ApiJob = MatchdayJob | RangeJob;

function collectApiJobs(rounds: RoundRecord[], logger: SyncLogger): ApiJob[] {
  const jobs = new Map<string, ApiJob>();

  for (const round of rounds) {
    for (const competition of round.competitionCodes) {
      if (!isAllowedCompetition(competition)) {
        logger.warn(`Skipping unsupported competition ${competition}`);
        continue;
      }

      const job = buildJob(round, competition);
      const existing = jobs.get(job.key);
      if (existing) {
        for (const id of round.fixtureIds) {
          existing.fixtureIds.add(id);
        }
        continue;
      }
      for (const id of round.fixtureIds) {
        job.fixtureIds.add(id);
      }
      jobs.set(job.key, job);
    }
  }

  return [...jobs.values()];
}

function buildJob(round: RoundRecord, competition: string): ApiJob {
  if (round.type === "matchday" && round.matchday != null) {
    return {
      kind: "matchday",
      key: `matchday:${competition}:${round.matchday}`,
      competition,
      matchday: round.matchday,
      fixtureIds: new Set<string>(),
    };
  }

  const dateFrom = toIsoDate(round.dateFrom);
  const dateTo = toIsoDate(round.dateTo);
  return {
    kind: "range",
    key: `range:${competition}:${dateFrom}:${dateTo}`,
    competition,
    dateFrom,
    dateTo,
    fixtureIds: new Set<string>(),
  };
}

function toIsoDate(date: Date): string {
  return date.toISOString().slice(0, 10);
}
