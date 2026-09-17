import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/firestore_json.dart';
import 'enums.dart';

part 'round.freezed.dart';
part 'round.g.dart';

@freezed
abstract class Round with _$Round {
  const Round._();

  const factory Round({
    required String id,
    required String leagueId,
    required RoundType type,
    required List<String> competitionCodes,
    int? matchday,
    required DateTime dateFrom,
    required DateTime dateTo,
    required List<String> fixtureIds,
    required RoundStatus status,
  }) = _Round;

  factory Round.fromJson(Map<String, dynamic> json) => _$RoundFromJson(json);

  factory Round.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return Round.fromJson(FirestoreJson.fromSnapshot(snapshot));
  }

  Map<String, dynamic> toFirestore() {
    return FirestoreJson.toDocument(
      toJson(),
      dateKeys: const ['dateFrom', 'dateTo'],
    );
  }
}
