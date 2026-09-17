import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:stkodds/data/converters/firestore_json.dart';
import 'package:stkodds/data/models/models.dart';

void main() {
  group('League', () {
    test('json roundtrip keeps members and season points', () {
      const league = League(
        id: 'lg1',
        name: 'Serie A Friends',
        inviteCode: 'ABCD',
        members: ['u1', 'u2'],
        createdBy: 'u1',
        seasonPoints: {'u1': 12, 'u2': 7},
      );

      expect(League.fromJson(league.toJson()), league);
    });
  });

  group('Round', () {
    test('encodes type as day|matchday|weekend', () {
      final round = Round(
        id: 'r1',
        leagueId: 'lg1',
        type: RoundType.matchday,
        competitionCodes: const ['SA'],
        matchday: 3,
        dateFrom: DateTime.utc(2026, 9, 19),
        dateTo: DateTime.utc(2026, 9, 21),
        fixtureIds: const ['f1', 'f2'],
        status: RoundStatus.open,
      );

      final json = round.toJson();
      expect(json['type'], 'matchday');
      expect(Round.fromJson(json), round);
    });
  });

  group('Fixture', () {
    test('json roundtrip keeps optional scores', () {
      final fixture = Fixture(
        id: 'f1',
        apiId: 123,
        competition: 'SA',
        matchday: 3,
        homeTeam: 'Milan',
        awayTeam: 'Inter',
        kickoff: DateTime.utc(2026, 9, 20, 18, 45),
        status: FixtureStatus.scheduled,
      );

      expect(Fixture.fromJson(fixture.toJson()), fixture);
    });

    test('reads kickoff from a Firestore Timestamp', () {
      final kickoff = DateTime.utc(2026, 9, 20, 18, 45);
      final json = FirestoreJson.normalize({
        'id': 'f1',
        'apiId': 123,
        'competition': 'SA',
        'matchday': 3,
        'homeTeam': 'Milan',
        'awayTeam': 'Inter',
        'kickoff': Timestamp.fromDate(kickoff),
        'status': 'live',
        'homeScore': 1,
        'awayScore': 0,
      });

      final fixture = Fixture.fromJson(json);
      expect(fixture.kickoff.toUtc(), kickoff);
      expect(fixture.status, FixtureStatus.live);
      expect(fixture.homeScore, 1);
    });
  });

  group('Prediction', () {
    test('encodes outcome as home|draw|away', () {
      const prediction = Prediction(
        id: 'p1',
        userId: 'u1',
        roundId: 'r1',
        fixtureId: 'f1',
        outcome: PredictionOutcome.draw,
        homeGoals: 1,
        awayGoals: 1,
      );

      final json = prediction.toJson();
      expect(json['outcome'], 'draw');
      expect(Prediction.fromJson(json), prediction);
    });
  });

  group('StandingEntry', () {
    test('json roundtrip keeps rank and points', () {
      const entry = StandingEntry(
        userId: 'u1',
        nickname: 'Alex',
        points: 21,
        rank: 2,
      );

      expect(StandingEntry.fromJson(entry.toJson()), entry);
    });
  });

  group('Hive adapters', () {
    late Box<Fixture> fixtures;
    late Box<Prediction> predictions;

    setUp(() async {
      Hive.init('.dart_tool/hive_test');
      if (!Hive.isAdapterRegistered(HiveTypeIds.fixture)) {
        Hive.registerAdapter(FixtureAdapter());
      }
      if (!Hive.isAdapterRegistered(HiveTypeIds.prediction)) {
        Hive.registerAdapter(PredictionAdapter());
      }
      fixtures = await Hive.openBox<Fixture>('fixtures');
      predictions = await Hive.openBox<Prediction>('predictions');
    });

    tearDown(() async {
      await fixtures.close();
      await predictions.close();
      await Hive.deleteBoxFromDisk('fixtures');
      await Hive.deleteBoxFromDisk('predictions');
    });

    test('persists Fixture and Prediction', () async {
      final fixture = Fixture(
        id: 'f1',
        apiId: 123,
        competition: 'SA',
        matchday: 3,
        homeTeam: 'Milan',
        awayTeam: 'Inter',
        kickoff: DateTime.utc(2026, 9, 20, 18, 45),
        status: FixtureStatus.finished,
        homeScore: 2,
        awayScore: 1,
      );
      const prediction = Prediction(
        id: 'p1',
        userId: 'u1',
        roundId: 'r1',
        fixtureId: 'f1',
        outcome: PredictionOutcome.home,
        homeGoals: 2,
        awayGoals: 1,
        points: 5,
      );

      await fixtures.put(fixture.id, fixture);
      await predictions.put(prediction.id, prediction);

      expect(fixtures.get('f1'), fixture);
      expect(predictions.get('p1'), prediction);
    });
  });
}
