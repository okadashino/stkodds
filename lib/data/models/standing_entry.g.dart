// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standing_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StandingEntry _$StandingEntryFromJson(Map<String, dynamic> json) =>
    _StandingEntry(
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      points: (json['points'] as num).toInt(),
      rank: (json['rank'] as num).toInt(),
    );

Map<String, dynamic> _$StandingEntryToJson(_StandingEntry instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'points': instance.points,
      'rank': instance.rank,
    };
