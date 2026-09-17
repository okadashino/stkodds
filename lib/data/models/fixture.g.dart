// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Fixture _$FixtureFromJson(Map<String, dynamic> json) => _Fixture(
  id: json['id'] as String,
  apiId: (json['apiId'] as num).toInt(),
  competition: json['competition'] as String,
  matchday: (json['matchday'] as num).toInt(),
  homeTeam: json['homeTeam'] as String,
  awayTeam: json['awayTeam'] as String,
  kickoff: DateTime.parse(json['kickoff'] as String),
  status: $enumDecode(_$FixtureStatusEnumMap, json['status']),
  homeScore: (json['homeScore'] as num?)?.toInt(),
  awayScore: (json['awayScore'] as num?)?.toInt(),
);

Map<String, dynamic> _$FixtureToJson(_Fixture instance) => <String, dynamic>{
  'id': instance.id,
  'apiId': instance.apiId,
  'competition': instance.competition,
  'matchday': instance.matchday,
  'homeTeam': instance.homeTeam,
  'awayTeam': instance.awayTeam,
  'kickoff': instance.kickoff.toIso8601String(),
  'status': _$FixtureStatusEnumMap[instance.status]!,
  'homeScore': ?instance.homeScore,
  'awayScore': ?instance.awayScore,
};

const _$FixtureStatusEnumMap = {
  FixtureStatus.scheduled: 'scheduled',
  FixtureStatus.live: 'live',
  FixtureStatus.finished: 'finished',
  FixtureStatus.postponed: 'postponed',
  FixtureStatus.cancelled: 'cancelled',
};
