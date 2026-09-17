import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../core/firebase/firebase_providers.dart';
import '../../core/time/clock.dart';
import '../local/hive_boxes.dart';
import '../models/fixture.dart';
import '../models/league.dart';
import '../models/prediction.dart';
import '../models/round.dart';
import '../models/standing_entry.dart';
import 'fixture_repository.dart';
import 'league_repository.dart';
import 'prediction_repository.dart';
import 'round_repository.dart';
import 'standing_repository.dart';

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final fixturesCacheProvider = Provider<Box<Fixture>>((ref) {
  return Hive.box<Fixture>(HiveBoxes.fixtures);
});

final predictionsCacheProvider = Provider<Box<Prediction>>((ref) {
  return Hive.box<Prediction>(HiveBoxes.predictions);
});

final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  return LeagueRepository(ref.watch(firestoreProvider));
});

final roundRepositoryProvider = Provider<RoundRepository>((ref) {
  return RoundRepository(ref.watch(firestoreProvider));
});

final fixtureRepositoryProvider = Provider<FixtureRepository>((ref) {
  return FixtureRepository(
    firestore: ref.watch(firestoreProvider),
    cache: ref.watch(fixturesCacheProvider),
  );
});

final predictionRepositoryProvider = Provider<PredictionRepository>((ref) {
  return PredictionRepository(
    firestore: ref.watch(firestoreProvider),
    cache: ref.watch(predictionsCacheProvider),
    fixtureRepository: ref.watch(fixtureRepositoryProvider),
    clock: ref.watch(clockProvider),
  );
});

final standingRepositoryProvider = Provider<StandingRepository>((ref) {
  return StandingRepository(ref.watch(firestoreProvider));
});

final leaguesStreamProvider = StreamProvider<List<League>>((ref) {
  return ref.watch(leagueRepositoryProvider).watchAll();
});

final leagueStreamProvider = StreamProvider.family<League?, String>((
  ref,
  leagueId,
) {
  return ref.watch(leagueRepositoryProvider).watchById(leagueId);
});

final roundsByLeagueProvider = StreamProvider.family<List<Round>, String>((
  ref,
  leagueId,
) {
  return ref.watch(roundRepositoryProvider).watchByLeague(leagueId);
});

final fixturesStreamProvider = StreamProvider<List<Fixture>>((ref) {
  return ref.watch(fixtureRepositoryProvider).watchAll();
});

final fixtureStreamProvider = StreamProvider.family<Fixture?, String>((
  ref,
  fixtureId,
) {
  return ref.watch(fixtureRepositoryProvider).watchById(fixtureId);
});

final predictionsByUserProvider =
    StreamProvider.family<List<Prediction>, String>((ref, userId) {
      return ref.watch(predictionRepositoryProvider).watchByUser(userId);
    });

final predictionsByRoundProvider =
    StreamProvider.family<List<Prediction>, String>((ref, roundId) {
      return ref.watch(predictionRepositoryProvider).watchByRound(roundId);
    });

final standingsByLeagueProvider =
    StreamProvider.family<List<StandingEntry>, String>((ref, leagueId) {
      return ref.watch(standingRepositoryProvider).watchByLeague(leagueId);
    });
