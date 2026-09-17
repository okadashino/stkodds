// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_League _$LeagueFromJson(Map<String, dynamic> json) => _League(
  id: json['id'] as String,
  name: json['name'] as String,
  inviteCode: json['inviteCode'] as String,
  members: (json['members'] as List<dynamic>).map((e) => e as String).toList(),
  createdBy: json['createdBy'] as String,
  seasonPoints: const SeasonPointsConverter().fromJson(
    json['seasonPoints'] as Object,
  ),
);

Map<String, dynamic> _$LeagueToJson(_League instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'inviteCode': instance.inviteCode,
  'members': instance.members,
  'createdBy': instance.createdBy,
  'seasonPoints': const SeasonPointsConverter().toJson(instance.seasonPoints),
};
