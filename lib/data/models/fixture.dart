import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/firestore_json.dart';
import 'enums.dart';

part 'fixture.freezed.dart';
part 'fixture.g.dart';

@freezed
abstract class Fixture with _$Fixture {
  const Fixture._();

  const factory Fixture({
    required String id,
    required int apiId,
    required String competition,
    required int matchday,
    required String homeTeam,
    required String awayTeam,
    required DateTime kickoff,
    required FixtureStatus status,
    int? homeScore,
    int? awayScore,
  }) = _Fixture;

  factory Fixture.fromJson(Map<String, dynamic> json) =>
      _$FixtureFromJson(json);

  factory Fixture.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return Fixture.fromJson(FirestoreJson.fromSnapshot(snapshot));
  }

  Map<String, dynamic> toFirestore() {
    return FirestoreJson.toDocument(
      toJson(),
      dateKeys: const ['kickoff'],
    );
  }
}
