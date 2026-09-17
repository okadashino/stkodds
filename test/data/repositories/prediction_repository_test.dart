import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:stkodds/core/errors/prediction_locked_exception.dart';
import 'package:stkodds/core/time/clock.dart';
import 'package:stkodds/data/models/models.dart';
import 'package:stkodds/data/repositories/fixture_repository.dart';
import 'package:stkodds/data/repositories/prediction_repository.dart';

class _MutableClock implements Clock {
  _MutableClock(this.current);

  DateTime current;

  @override
  DateTime now() => current;
}

void main() {
  late FakeFirebaseFirestore firestore;
  late Box<Fixture> fixturesCache;
  late Box<Prediction> predictionsCache;
  late FixtureRepository fixtures;
  late PredictionRepository predictions;
  late _MutableClock clock;

  final kickoff = DateTime.utc(2026, 9, 20, 18, 45);
  final fixture = Fixture(
    id: 'f1',
    apiId: 10,
    competition: 'SA',
    matchday: 1,
    homeTeam: 'Milan',
    awayTeam: 'Inter',
    kickoff: kickoff,
    status: FixtureStatus.scheduled,
  );
  const prediction = Prediction(
    id: 'p1',
    userId: 'u1',
    roundId: 'r1',
    fixtureId: 'f1',
    outcome: PredictionOutcome.home,
    homeGoals: 2,
    awayGoals: 1,
  );

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    clock = _MutableClock(kickoff.subtract(const Duration(minutes: 5)));
    Hive.init('.dart_tool/hive_repo_test');
    if (!Hive.isAdapterRegistered(HiveTypeIds.fixture)) {
      Hive.registerAdapter(FixtureAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTypeIds.prediction)) {
      Hive.registerAdapter(PredictionAdapter());
    }
    fixturesCache = await Hive.openBox<Fixture>('repo_fixtures');
    predictionsCache = await Hive.openBox<Prediction>('repo_predictions');
    await fixturesCache.clear();
    await predictionsCache.clear();

    fixtures = FixtureRepository(
      firestore: firestore,
      cache: fixturesCache,
    );
    predictions = PredictionRepository(
      firestore: firestore,
      cache: predictionsCache,
      fixtureRepository: fixtures,
      clock: clock,
    );
  });

  tearDown(() async {
    await fixturesCache.clear();
    await predictionsCache.clear();
    await fixturesCache.close();
    await predictionsCache.close();
  });

  test('allows a prediction before kickoff and caches it', () async {
    await fixtures.create(fixture);

    final saved = await predictions.create(prediction);

    expect(saved, prediction);
    expect(predictionsCache.get('p1'), prediction);
    expect(await predictions.getById('p1'), prediction);
  });

  test('throws a handled error when kickoff has started', () async {
    await fixtures.create(fixture);
    clock.current = kickoff;

    expect(
      () => predictions.create(prediction),
      throwsA(isA<PredictionLockedException>()),
    );
  });

  test('reads fixtures from Hive when Firestore has no document', () async {
    await fixturesCache.put(fixture.id, fixture);

    expect(await fixtures.getById(fixture.id), fixture);
  });
}
