import "dotenv/config";
import { getFirestore } from "firebase-admin/firestore";
import { FootballDataClient } from "./footballData/client";
import { initFirebaseAdmin } from "./firebase/admin";
import { scorePrediction } from "./scoring/points";
import { rankStandings } from "./scoring/standings";
import { createFirestoreStore } from "./sync/firestoreStore";
import { syncActiveRoundFixtures } from "./sync/syncFixtures";
import type {
  BackendStore,
  FixtureRecord,
  LeagueRecord,
  PredictionRecord,
  RunSummary,
  SyncLogger,
} from "./sync/types";

export async function run(options: {
  store: BackendStore;
  client: FootballDataClient;
  logger: SyncLogger;
}): Promise<RunSummary> {
  const { store, client, logger } = options;
  const rounds = await store.getActiveRounds();
  const fixtureIds = [...new Set(rounds.flatMap((round) => round.fixtureIds))];
  const loadedFixtures = await store.getFixturesByIds(fixtureIds);
  const { updated: fixturesUpdated, fixtures } = await syncActiveRoundFixtures({
    store,
    client,
    logger,
    rounds,
    fixtures: loadedFixtures,
  });

  const fixturesById = new Map(fixtures.map((fixture) => [fixture.id, fixture]));
  const finishedFixtures = fixtures.filter(isScorableFinished);
  const finishedIds = new Set(finishedFixtures.map((fixture) => fixture.id));

  const summary: RunSummary = {
    fixturesUpdated,
    fixturesFinished: finishedFixtures.length,
    predictionsScored: 0,
    roundStandingsUpdated: 0,
    seasonStandingsUpdated: 0,
  };

  if (finishedFixtures.length === 0) {
    logSummary(logger, summary);
    return summary;
  }

  const activePredictions = await store.getPredictionsByRoundIds(rounds.map((round) => round.id));
  summary.predictionsScored = await scoreFinishedPredictions(
    store,
    activePredictions,
    fixturesById,
    finishedIds,
  );

  const affectedRounds = rounds.filter((round) =>
    round.fixtureIds.some((id) => finishedIds.has(id)),
  );
  const leagueIds = [...new Set(affectedRounds.map((round) => round.leagueId).filter(Boolean))];
  const leagueRounds = await store.getRoundsByLeagueIds(leagueIds);
  const seasonPredictions = await store.getPredictionsByRoundIds(
    leagueRounds.map((round) => round.id),
  );
  const leagues = await store.getLeaguesByIds(leagueIds);
  const leaguesById = new Map(leagues.map((league) => [league.id, league]));

  for (const round of affectedRounds) {
    const entries = rankStandings(
      pointsByUser(
        seasonPredictions.filter((prediction) => prediction.roundId === round.id),
      ),
      nicknamesFor(leaguesById.get(round.leagueId)),
    );
    await store.replaceRoundStandings(round.id, entries);
    summary.roundStandingsUpdated += 1;
  }

  for (const league of leagues) {
    const roundIds = new Set(
      leagueRounds.filter((round) => round.leagueId === league.id).map((round) => round.id),
    );
    const points = pointsByUser(
      seasonPredictions.filter((prediction) => roundIds.has(prediction.roundId)),
    );
    for (const member of league.members) {
      if (!points.has(member)) {
        points.set(member, 0);
      }
    }
    const entries = rankStandings(points, nicknamesFor(league));
    const seasonPoints = Object.fromEntries(points);
    await store.replaceSeasonStandings(league.id, entries, seasonPoints);
    summary.seasonStandingsUpdated += 1;
  }

  logSummary(logger, summary);
  return summary;
}

function isScorableFinished(fixture: FixtureRecord): boolean {
  return fixture.status === "finished" && fixture.homeScore != null && fixture.awayScore != null;
}

async function scoreFinishedPredictions(
  store: BackendStore,
  predictions: PredictionRecord[],
  fixturesById: Map<string, FixtureRecord>,
  finishedIds: Set<string>,
): Promise<number> {
  let scored = 0;
  for (const prediction of predictions) {
    if (!finishedIds.has(prediction.fixtureId)) {
      continue;
    }
    const fixture = fixturesById.get(prediction.fixtureId);
    if (!fixture || !isScorableFinished(fixture)) {
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

function pointsByUser(predictions: PredictionRecord[]): Map<string, number> {
  const totals = new Map<string, number>();
  for (const prediction of predictions) {
    const points = prediction.points ?? 0;
    totals.set(prediction.userId, (totals.get(prediction.userId) ?? 0) + points);
  }
  return totals;
}

function nicknamesFor(league?: LeagueRecord): Record<string, string> {
  return league?.nicknames ?? {};
}

function logSummary(logger: SyncLogger, summary: RunSummary): void {
  logger.info(
    `Sync summary: fixturesUpdated=${summary.fixturesUpdated} fixturesFinished=${summary.fixturesFinished} predictionsScored=${summary.predictionsScored} roundStandings=${summary.roundStandingsUpdated} seasonStandings=${summary.seasonStandingsUpdated}`,
  );
}

export async function main(): Promise<void> {
  initFirebaseAdmin();
  await run({
    store: createFirestoreStore(getFirestore()),
    client: new FootballDataClient(),
    logger: console,
  });
}

if (require.main === module) {
  main().catch((error: unknown) => {
    console.error(error);
    process.exitCode = 1;
  });
}
