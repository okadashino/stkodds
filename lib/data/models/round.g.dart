// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Round _$RoundFromJson(Map<String, dynamic> json) => _Round(
  id: json['id'] as String,
  leagueId: json['leagueId'] as String,
  type: $enumDecode(_$RoundTypeEnumMap, json['type']),
  competitionCodes: (json['competitionCodes'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  matchday: (json['matchday'] as num?)?.toInt(),
  dateFrom: DateTime.parse(json['dateFrom'] as String),
  dateTo: DateTime.parse(json['dateTo'] as String),
  fixtureIds: (json['fixtureIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  status: $enumDecode(_$RoundStatusEnumMap, json['status']),
);

Map<String, dynamic> _$RoundToJson(_Round instance) => <String, dynamic>{
  'id': instance.id,
  'leagueId': instance.leagueId,
  'type': _$RoundTypeEnumMap[instance.type]!,
  'competitionCodes': instance.competitionCodes,
  'matchday': ?instance.matchday,
  'dateFrom': instance.dateFrom.toIso8601String(),
  'dateTo': instance.dateTo.toIso8601String(),
  'fixtureIds': instance.fixtureIds,
  'status': _$RoundStatusEnumMap[instance.status]!,
};

const _$RoundTypeEnumMap = {
  RoundType.day: 'day',
  RoundType.matchday: 'matchday',
  RoundType.weekend: 'weekend',
};

const _$RoundStatusEnumMap = {
  RoundStatus.upcoming: 'upcoming',
  RoundStatus.open: 'open',
  RoundStatus.locked: 'locked',
  RoundStatus.completed: 'completed',
};
