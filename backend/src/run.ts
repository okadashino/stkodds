import "dotenv/config";
import { getFirestore } from "firebase-admin/firestore";
import { ALLOWED_COMPETITIONS } from "./footballData/competitions";
import { FootballDataClient } from "./footballData/client";
import { dateRangeChunks, utcDateOffset } from "./footballData/dateRange";
import type { FootballMatchDto } from "./footballData/mapMatch";
import { MinuteThrottle, type Throttle } from "./footballData/throttle";
import { initFirebaseAdmin } from "./firebase/admin";
import { scorePrediction } from "./scoring/points";
import { utcYearMonth } from "./scoring/months";
import { rankStandings } from "./scoring/standings";
import { createFirestoreStore } from "./sync/firestoreStore";
import type {
  BackendStore,
  FixtureDocument,
  FixtureRecord,
  LeagueRecord,
  PredictionRecord,
  RunSummary,
  SyncLogger,
} from "./sync/types";

export const PALINSESTO_DAYS = 14;
export const MATCHDAY_MAX_DAYS = 3;
export const FINISHED_LOOKBACK_DAYS = MATCHDAY_MAX_DAYS;

export async function run(options: {
  store: BackendStore;
  client: FootballDataClient;
  logger: SyncLogger;
  now?: Date;
  throttle?: Throttle;
}): Promise<RunSummary> {
  const { store, client, logger } = options;
  const now = options.now ?? new Date();
  const throttle = options.throttle ?? new MinuteThrottle(10);
  const today = utcDateOffset(now, 0);
  const dateFrom = utcDateOffset(now, -FINISHED_LOOKBACK_DAYS);
  const dateTo = utcDateOffset(now, PALINSESTO_DAYS);

  const matchesByApiId = new Map<number, FootballMatchDto>();
  for (const competition of ALLOWED_COMPETITIONS) {
    for (const [chunkFrom, chunkTo] of dateRangeChunks(dateFrom, dateTo)) {
      await throttle.acquire();
      for (const match of await client.getMatches(competition, chunkFrom, chunkTo)) {
        matchesByApiId.set(match.apiId, match);
      }
    }
  }
  const matches = [...matchesByApiId.values()];

  const summary: RunSummary = {
    fixturesUpdated: 0,
    fixturesFinished: 0,
    predictionsScored: 0,
    roundStandingsUpdated: 0,
    seasonStandingsUpdated: 0,
    monthStandingsUpdated: 0,
  };

  // (1) Palinsesto: today through the next ~2 weeks.
  const palinsesto = uniqueByApiId(
    matches.filter((match) => {
      const day = kickoffDate(match);
      return day >= today && day <= dateTo;
    }),
  );
  const upsertedByCompetition = new Map<string, Set<number>>();
  for (const match of palinsesto) {
    await store.upsertFixture(toFixtureDocument(match));
    summary.fixturesUpdated += 1;
    trackUpsert(upsertedByCompetition, match);
  }

  // (2) Past matches that finished: full upsert so status + scores land on a complete doc.
  const finished = matches.filter(isScorableFinished);
  const fixturesById = new Map<string, FixtureRecord>();
  for (const match of finished) {
    const fixture = toFixtureDocument(match);
    fixturesById.set(fixture.id, fixture);
    await store.upsertFixture(fixture);
    await store.updateFixture(fixture.id, {
      status: match.status,
      homeScore: match.homeScore,
      awayScore: match.awayScore,
    });
    if (!palinsesto.some((item) => item.apiId === match.apiId)) {
      summary.fixturesUpdated += 1;
      trackUpsert(upsertedByCompetition, match);
    }
    summary.fixturesFinished += 1;
  }

  // (3) Idempotent points on those finished fixtures.
  if (finished.length > 0) {
    const predictions = await store.getPredictionsByFixtureIds([...fixturesById.keys()]);
    summary.predictionsScored = await scoreFinishedPredictions(store, predictions, fixturesById);
  }

  // (4) Every league: round, season, and month tables from each member's global pick.
  const leagues = await store.getLeagues();
  const rounds = await store.getRoundsByLeagueIds(leagues.map((league) => league.id));
  const seasonFixtureIds = [...new Set(rounds.flatMap((round) => round.fixtureIds))];
  const seasonPredictions = await store.getPredictionsByFixtureIds(seasonFixtureIds);
  const leagueFixturesById = new Map(
    (await store.getFixturesByIds(seasonFixtureIds)).map((fixture) => [fixture.id, fixture]),
  );
  const leaguesById = new Map(leagues.map((league) => [league.id, league]));

  for (const round of rounds) {
    const league = leaguesById.get(round.leagueId);
    const members = new Set(league?.members ?? []);
    const points = pointsByUser(
      predictionsForFixtures(seasonPredictions, round.fixtureIds, members),
    );
    fillMissingMembers(points, league?.members ?? []);
    await store.replaceRoundStandings(round.id, rankStandings(points, nicknamesFor(league)));
    summary.roundStandingsUpdated += 1;
  }

  for (const league of leagues) {
    const fixtureIdsForLeague = [
      ...new Set(
        rounds.filter((round) => round.leagueId === league.id).flatMap((round) => round.fixtureIds),
      ),
    ];
    const members = new Set(league.members);
    const points = pointsByUser(
      predictionsForFixtures(seasonPredictions, fixtureIdsForLeague, members),
    );
    fillMissingMembers(points, league.members);
    const entries = rankStandings(points, nicknamesFor(league));
    await store.replaceSeasonStandings(league.id, entries, Object.fromEntries(points));
    summary.seasonStandingsUpdated += 1;

    const fixtureIdsByMonth = new Map<string, string[]>();
    for (const fixtureId of fixtureIdsForLeague) {
      const fixture = leagueFixturesById.get(fixtureId);
      const yearMonth = fixture ? utcYearMonth(fixture.kickoff) : "";
      if (!yearMonth) {
        continue;
      }
      const monthIds = fixtureIdsByMonth.get(yearMonth) ?? [];
      monthIds.push(fixtureId);
      fixtureIdsByMonth.set(yearMonth, monthIds);
    }
    for (const [yearMonth, monthFixtureIds] of fixtureIdsByMonth) {
      const monthPoints = pointsByUser(
        predictionsForFixtures(seasonPredictions, monthFixtureIds, members),
      );
      fillMissingMembers(monthPoints, league.members);
      await store.replaceMonthStandings(
        league.id,
        yearMonth,
        rankStandings(monthPoints, nicknamesFor(league)),
      );
      summary.monthStandingsUpdated += 1;
    }
  }

  for (const competition of ALLOWED_COMPETITIONS) {
    logger.info(
      `Palinsesto ${competition}: upserted ${upsertedByCompetition.get(competition)?.size ?? 0} unique fixtures`,
    );
  }

  logSummary(logger, summary);
  return summary;
}

function isScorableFinished(match: FootballMatchDto): boolean {
  return match.status === "finished" && match.homeScore != null && match.awayScore != null;
}

function toFixtureDocument(match: FootballMatchDto): FixtureDocument {
  return {
    id: String(match.apiId),
    apiId: match.apiId,
    competition: match.competition,
    matchday: match.matchday ?? 0,
    homeTeam: match.homeTeam,
    awayTeam: match.awayTeam,
    kickoff: match.kickoff,
    status: match.status,
    homeScore: match.homeScore,
    awayScore: match.awayScore,
  };
}

async function scoreFinishedPredictions(
  store: BackendStore,
  predictions: PredictionRecord[],
  fixturesById: Map<string, FixtureRecord>,
): Promise<number> {
  let scored = 0;
  for (const prediction of predictions) {
    const fixture = fixturesById.get(prediction.fixtureId);
    if (!fixture) {
      continue;
    }
    const points = scorePrediction(prediction, fixture);
    if (prediction.points === points) {
      continue;
    }
    await store.updatePredictionPoints(prediction.id, points);
    prediction.points = points;
    scored += 1;
  }
  return scored;
}

function predictionsForFixtures(
  predictions: PredictionRecord[],
  fixtureIds: string[],
  members: Set<string>,
): PredictionRecord[] {
  const fixtures = new Set(fixtureIds);
  const seen = new Set<string>();
  const matched: PredictionRecord[] = [];
  for (const prediction of predictions) {
    if (!fixtures.has(prediction.fixtureId) || !members.has(prediction.userId)) {
      continue;
    }
    const key = `${prediction.userId}_${prediction.fixtureId}`;
    if (seen.has(key)) {
      continue;
    }
    seen.add(key);
    matched.push(prediction);
  }
  return matched;
}

function pointsByUser(predictions: PredictionRecord[]): Map<string, number> {
  const totals = new Map<string, number>();
  for (const prediction of predictions) {
    const points = prediction.points ?? 0;
    totals.set(prediction.userId, (totals.get(prediction.userId) ?? 0) + points);
  }
  return totals;
}

function fillMissingMembers(points: Map<string, number>, members: string[]): void {
  for (const member of members) {
    if (!points.has(member)) {
      points.set(member, 0);
    }
  }
}

function nicknamesFor(league?: LeagueRecord): Record<string, string> {
  return league?.nicknames ?? {};
}

function kickoffDate(match: FootballMatchDto): string {
  return match.kickoff.slice(0, 10);
}

function uniqueByApiId(matches: FootballMatchDto[]): FootballMatchDto[] {
  return [...new Map(matches.map((match) => [match.apiId, match])).values()];
}

function trackUpsert(
  upsertedByCompetition: Map<string, Set<number>>,
  match: FootballMatchDto,
): void {
  const ids = upsertedByCompetition.get(match.competition) ?? new Set<number>();
  ids.add(match.apiId);
  upsertedByCompetition.set(match.competition, ids);
}

function logSummary(logger: SyncLogger, summary: RunSummary): void {
  logger.info(
    `Sync summary: fixturesUpdated=${summary.fixturesUpdated} fixturesFinished=${summary.fixturesFinished} predictionsScored=${summary.predictionsScored} roundStandings=${summary.roundStandingsUpdated} seasonStandings=${summary.seasonStandingsUpdated} monthStandings=${summary.monthStandingsUpdated}`,
  );
}

export async function main(): Promise<void> {
  initFirebaseAdmin();
  await run({
    store: createFirestoreStore(getFirestore()),
    client: new FootballDataClient({ throttle: { acquire: async () => undefined } }),
    logger: console,
  });
}

if (require.main === module) {
  main().catch((error: unknown) => {
    console.error(error);
    process.exitCode = 1;
  });
}
