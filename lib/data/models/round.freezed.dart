// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'round.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Round {

 String get id; String get leagueId; RoundType get type; List<String> get competitionCodes; int? get matchday; DateTime get dateFrom; DateTime get dateTo; List<String> get fixtureIds; RoundStatus get status;
/// Create a copy of Round
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoundCopyWith<Round> get copyWith => _$RoundCopyWithImpl<Round>(this as Round, _$identity);

  /// Serializes this Round to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Round;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Round&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.leagueId, _this.leagueId) || other.leagueId == _this.leagueId)&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.competitionCodes, _this.competitionCodes)&&(identical(other.matchday, _this.matchday) || other.matchday == _this.matchday)&&(identical(other.dateFrom, _this.dateFrom) || other.dateFrom == _this.dateFrom)&&(identical(other.dateTo, _this.dateTo) || other.dateTo == _this.dateTo)&&const DeepCollectionEquality().equals(other.fixtureIds, _this.fixtureIds)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Round;
  return Object.hash(runtimeType,_this.id,_this.leagueId,_this.type,const DeepCollectionEquality().hash(_this.competitionCodes),_this.matchday,_this.dateFrom,_this.dateTo,const DeepCollectionEquality().hash(_this.fixtureIds),_this.status);
}

@override
String toString() {
  final _this = this as Round;
  return 'Round(id: ${_this.id}, leagueId: ${_this.leagueId}, type: ${_this.type}, competitionCodes: ${_this.competitionCodes}, matchday: ${_this.matchday}, dateFrom: ${_this.dateFrom}, dateTo: ${_this.dateTo}, fixtureIds: ${_this.fixtureIds}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $RoundCopyWith<$Res>  {
  factory $RoundCopyWith(Round value, $Res Function(Round) _then) = _$RoundCopyWithImpl;
@useResult
$Res call({
 String id, String leagueId, RoundType type, List<String> competitionCodes, int? matchday, DateTime dateFrom, DateTime dateTo, List<String> fixtureIds, RoundStatus status
});




}
/// @nodoc
class _$RoundCopyWithImpl<$Res>
    implements $RoundCopyWith<$Res> {
  _$RoundCopyWithImpl(this._self, this._then);

  final Round _self;
  final $Res Function(Round) _then;

/// Create a copy of Round
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? leagueId = null,Object? type = null,Object? competitionCodes = null,Object? matchday = freezed,Object? dateFrom = null,Object? dateTo = null,Object? fixtureIds = null,Object? status = null,}) {
  return _then(Round(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RoundType,competitionCodes: null == competitionCodes ? _self.competitionCodes : competitionCodes // ignore: cast_nullable_to_non_nullable
as List<String>,matchday: freezed == matchday ? _self.matchday : matchday // ignore: cast_nullable_to_non_nullable
as int?,dateFrom: null == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime,dateTo: null == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime,fixtureIds: null == fixtureIds ? _self.fixtureIds : fixtureIds // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoundStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Round].
extension RoundPatterns on Round {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Round value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Round() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Round value)  $default,){
final _that = this;
switch (_that) {
case _Round():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Round value)?  $default,){
final _that = this;
switch (_that) {
case _Round() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String leagueId,  RoundType type,  List<String> competitionCodes,  int? matchday,  DateTime dateFrom,  DateTime dateTo,  List<String> fixtureIds,  RoundStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Round() when $default != null:
return $default(_that.id,_that.leagueId,_that.type,_that.competitionCodes,_that.matchday,_that.dateFrom,_that.dateTo,_that.fixtureIds,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String leagueId,  RoundType type,  List<String> competitionCodes,  int? matchday,  DateTime dateFrom,  DateTime dateTo,  List<String> fixtureIds,  RoundStatus status)  $default,) {final _that = this;
switch (_that) {
case _Round():
return $default(_that.id,_that.leagueId,_that.type,_that.competitionCodes,_that.matchday,_that.dateFrom,_that.dateTo,_that.fixtureIds,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String leagueId,  RoundType type,  List<String> competitionCodes,  int? matchday,  DateTime dateFrom,  DateTime dateTo,  List<String> fixtureIds,  RoundStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Round() when $default != null:
return $default(_that.id,_that.leagueId,_that.type,_that.competitionCodes,_that.matchday,_that.dateFrom,_that.dateTo,_that.fixtureIds,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Round extends Round {
  const _Round({required this.id, required this.leagueId, required this.type, required  List<String> competitionCodes, this.matchday, required this.dateFrom, required this.dateTo, required  List<String> fixtureIds, required this.status}): _competitionCodes = competitionCodes,_fixtureIds = fixtureIds,super._();
  factory _Round.fromJson(Map<String, dynamic> json) => _$RoundFromJson(json);

@override final  String id;
@override final  String leagueId;
@override final  RoundType type;
 final  List<String> _competitionCodes;
@override List<String> get competitionCodes {
  if (_competitionCodes is EqualUnmodifiableListView) return _competitionCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_competitionCodes);
}

@override final  int? matchday;
@override final  DateTime dateFrom;
@override final  DateTime dateTo;
 final  List<String> _fixtureIds;
@override List<String> get fixtureIds {
  if (_fixtureIds is EqualUnmodifiableListView) return _fixtureIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fixtureIds);
}

@override final  RoundStatus status;

/// Create a copy of Round
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoundCopyWith<_Round> get copyWith => __$RoundCopyWithImpl<_Round>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoundToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Round&&(identical(other.id, id) || other.id == id)&&(identical(other.leagueId, leagueId) || other.leagueId == leagueId)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.competitionCodes, _competitionCodes)&&(identical(other.matchday, matchday) || other.matchday == matchday)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&const DeepCollectionEquality().equals(other.fixtureIds, _fixtureIds)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,leagueId,type,const DeepCollectionEquality().hash(_competitionCodes),matchday,dateFrom,dateTo,const DeepCollectionEquality().hash(_fixtureIds),status);
}

@override
String toString() {
    return 'Round(id: $id, leagueId: $leagueId, type: $type, competitionCodes: $competitionCodes, matchday: $matchday, dateFrom: $dateFrom, dateTo: $dateTo, fixtureIds: $fixtureIds, status: $status)';
}


}

/// @nodoc
abstract mixin class _$RoundCopyWith<$Res> implements $RoundCopyWith<$Res> {
  factory _$RoundCopyWith(_Round value, $Res Function(_Round) _then) = __$RoundCopyWithImpl;
@override @useResult
$Res call({
 String id, String leagueId, RoundType type, List<String> competitionCodes, int? matchday, DateTime dateFrom, DateTime dateTo, List<String> fixtureIds, RoundStatus status
});




}
/// @nodoc
class __$RoundCopyWithImpl<$Res>
    implements _$RoundCopyWith<$Res> {
  __$RoundCopyWithImpl(this._self, this._then);

  final _Round _self;
  final $Res Function(_Round) _then;

/// Create a copy of Round
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? leagueId = null,Object? type = null,Object? competitionCodes = null,Object? matchday = freezed,Object? dateFrom = null,Object? dateTo = null,Object? fixtureIds = null,Object? status = null,}) {
  return _then(_Round(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RoundType,competitionCodes: null == competitionCodes ? _self._competitionCodes : competitionCodes // ignore: cast_nullable_to_non_nullable
as List<String>,matchday: freezed == matchday ? _self.matchday : matchday // ignore: cast_nullable_to_non_nullable
as int?,dateFrom: null == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime,dateTo: null == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime,fixtureIds: null == fixtureIds ? _self._fixtureIds : fixtureIds // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoundStatus,
  ));
}


}

// dart format on
