import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/firestore_json.dart';
import '../converters/season_points_converter.dart';

part 'league.freezed.dart';
part 'league.g.dart';

@freezed
abstract class League with _$League {
  const League._();

  const factory League({
    required String id,
    required String name,
    required String inviteCode,
    required List<String> members,
    required String createdBy,
    @SeasonPointsConverter() required Map<String, int> seasonPoints,
  }) = _League;

  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);

  factory League.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return League.fromJson(FirestoreJson.fromSnapshot(snapshot));
  }

  Map<String, dynamic> toFirestore() => FirestoreJson.toDocument(toJson());
}
