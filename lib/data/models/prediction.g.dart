// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Prediction _$PredictionFromJson(Map<String, dynamic> json) => _Prediction(
  id: json['id'] as String,
  userId: json['userId'] as String,
  roundId: json['roundId'] as String,
  fixtureId: json['fixtureId'] as String,
  outcome: $enumDecode(_$PredictionOutcomeEnumMap, json['outcome']),
  homeGoals: (json['homeGoals'] as num).toInt(),
  awayGoals: (json['awayGoals'] as num).toInt(),
  points: (json['points'] as num?)?.toInt(),
  lockedAt: json['lockedAt'] == null
      ? null
      : DateTime.parse(json['lockedAt'] as String),
);

Map<String, dynamic> _$PredictionToJson(_Prediction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'roundId': instance.roundId,
      'fixtureId': instance.fixtureId,
      'outcome': _$PredictionOutcomeEnumMap[instance.outcome]!,
      'homeGoals': instance.homeGoals,
      'awayGoals': instance.awayGoals,
      'points': ?instance.points,
      'lockedAt': ?instance.lockedAt?.toIso8601String(),
    };

const _$PredictionOutcomeEnumMap = {
  PredictionOutcome.home: 'home',
  PredictionOutcome.draw: 'draw',
  PredictionOutcome.away: 'away',
};
