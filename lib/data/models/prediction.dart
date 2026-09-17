import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/firestore_json.dart';
import 'enums.dart';

part 'prediction.freezed.dart';
part 'prediction.g.dart';

@freezed
abstract class Prediction with _$Prediction {
  const Prediction._();

  const factory Prediction({
    required String id,
    required String userId,
    required String roundId,
    required String fixtureId,
    required PredictionOutcome outcome,
    required int homeGoals,
    required int awayGoals,
    int? points,
    DateTime? lockedAt,
  }) = _Prediction;

  factory Prediction.fromJson(Map<String, dynamic> json) =>
      _$PredictionFromJson(json);

  factory Prediction.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return Prediction.fromJson(FirestoreJson.fromSnapshot(snapshot));
  }

  Map<String, dynamic> toFirestore() {
    return FirestoreJson.toDocument(
      toJson(),
      dateKeys: const ['lockedAt'],
    );
  }
}
