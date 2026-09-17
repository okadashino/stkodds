import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/firestore_json.dart';

part 'standing_entry.freezed.dart';
part 'standing_entry.g.dart';

@freezed
abstract class StandingEntry with _$StandingEntry {
  const StandingEntry._();

  const factory StandingEntry({
    required String userId,
    required String nickname,
    required int points,
    required int rank,
  }) = _StandingEntry;

  factory StandingEntry.fromJson(Map<String, dynamic> json) =>
      _$StandingEntryFromJson(json);

  factory StandingEntry.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = FirestoreJson.fromSnapshot(snapshot);
    data.putIfAbsent('userId', () => snapshot.id);
    return StandingEntry.fromJson(data);
  }

  Map<String, dynamic> toFirestore() => FirestoreJson.toDocument(toJson());
}
