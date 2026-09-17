// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fixture.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Fixture {

 String get id; int get apiId; String get competition; int get matchday; String get homeTeam; String get awayTeam; DateTime get kickoff; FixtureStatus get status; int? get homeScore; int? get awayScore;
/// Create a copy of Fixture
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FixtureCopyWith<Fixture> get copyWith => _$FixtureCopyWithImpl<Fixture>(this as Fixture, _$identity);

  /// Serializes this Fixture to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Fixture;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Fixture&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.apiId, _this.apiId) || other.apiId == _this.apiId)&&(identical(other.competition, _this.competition) || other.competition == _this.competition)&&(identical(other.matchday, _this.matchday) || other.matchday == _this.matchday)&&(identical(other.homeTeam, _this.homeTeam) || other.homeTeam == _this.homeTeam)&&(identical(other.awayTeam, _this.awayTeam) || other.awayTeam == _this.awayTeam)&&(identical(other.kickoff, _this.kickoff) || other.kickoff == _this.kickoff)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.homeScore, _this.homeScore) || other.homeScore == _this.homeScore)&&(identical(other.awayScore, _this.awayScore) || other.awayScore == _this.awayScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Fixture;
  return Object.hash(runtimeType,_this.id,_this.apiId,_this.competition,_this.matchday,_this.homeTeam,_this.awayTeam,_this.kickoff,_this.status,_this.homeScore,_this.awayScore);
}

@override
String toString() {
  final _this = this as Fixture;
  return 'Fixture(id: ${_this.id}, apiId: ${_this.apiId}, competition: ${_this.competition}, matchday: ${_this.matchday}, homeTeam: ${_this.homeTeam}, awayTeam: ${_this.awayTeam}, kickoff: ${_this.kickoff}, status: ${_this.status}, homeScore: ${_this.homeScore}, awayScore: ${_this.awayScore})';
}


}

/// @nodoc
abstract mixin class $FixtureCopyWith<$Res>  {
  factory $FixtureCopyWith(Fixture value, $Res Function(Fixture) _then) = _$FixtureCopyWithImpl;
@useResult
$Res call({
 String id, int apiId, String competition, int matchday, String homeTeam, String awayTeam, DateTime kickoff, FixtureStatus status, int? homeScore, int? awayScore
});




}
/// @nodoc
class _$FixtureCopyWithImpl<$Res>
    implements $FixtureCopyWith<$Res> {
  _$FixtureCopyWithImpl(this._self, this._then);

  final Fixture _self;
  final $Res Function(Fixture) _then;

/// Create a copy of Fixture
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? apiId = null,Object? competition = null,Object? matchday = null,Object? homeTeam = null,Object? awayTeam = null,Object? kickoff = null,Object? status = null,Object? homeScore = freezed,Object? awayScore = freezed,}) {
  return _then(Fixture(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,apiId: null == apiId ? _self.apiId : apiId // ignore: cast_nullable_to_non_nullable
as int,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as String,matchday: null == matchday ? _self.matchday : matchday // ignore: cast_nullable_to_non_nullable
as int,homeTeam: null == homeTeam ? _self.homeTeam : homeTeam // ignore: cast_nullable_to_non_nullable
as String,awayTeam: null == awayTeam ? _self.awayTeam : awayTeam // ignore: cast_nullable_to_non_nullable
as String,kickoff: null == kickoff ? _self.kickoff : kickoff // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FixtureStatus,homeScore: freezed == homeScore ? _self.homeScore : homeScore // ignore: cast_nullable_to_non_nullable
as int?,awayScore: freezed == awayScore ? _self.awayScore : awayScore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Fixture].
extension FixturePatterns on Fixture {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Fixture value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Fixture() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Fixture value)  $default,){
final _that = this;
switch (_that) {
case _Fixture():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Fixture value)?  $default,){
final _that = this;
switch (_that) {
case _Fixture() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int apiId,  String competition,  int matchday,  String homeTeam,  String awayTeam,  DateTime kickoff,  FixtureStatus status,  int? homeScore,  int? awayScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Fixture() when $default != null:
return $default(_that.id,_that.apiId,_that.competition,_that.matchday,_that.homeTeam,_that.awayTeam,_that.kickoff,_that.status,_that.homeScore,_that.awayScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int apiId,  String competition,  int matchday,  String homeTeam,  String awayTeam,  DateTime kickoff,  FixtureStatus status,  int? homeScore,  int? awayScore)  $default,) {final _that = this;
switch (_that) {
case _Fixture():
return $default(_that.id,_that.apiId,_that.competition,_that.matchday,_that.homeTeam,_that.awayTeam,_that.kickoff,_that.status,_that.homeScore,_that.awayScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int apiId,  String competition,  int matchday,  String homeTeam,  String awayTeam,  DateTime kickoff,  FixtureStatus status,  int? homeScore,  int? awayScore)?  $default,) {final _that = this;
switch (_that) {
case _Fixture() when $default != null:
return $default(_that.id,_that.apiId,_that.competition,_that.matchday,_that.homeTeam,_that.awayTeam,_that.kickoff,_that.status,_that.homeScore,_that.awayScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Fixture extends Fixture {
  const _Fixture({required this.id, required this.apiId, required this.competition, required this.matchday, required this.homeTeam, required this.awayTeam, required this.kickoff, required this.status, this.homeScore, this.awayScore}): super._();
  factory _Fixture.fromJson(Map<String, dynamic> json) => _$FixtureFromJson(json);

@override final  String id;
@override final  int apiId;
@override final  String competition;
@override final  int matchday;
@override final  String homeTeam;
@override final  String awayTeam;
@override final  DateTime kickoff;
@override final  FixtureStatus status;
@override final  int? homeScore;
@override final  int? awayScore;

/// Create a copy of Fixture
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FixtureCopyWith<_Fixture> get copyWith => __$FixtureCopyWithImpl<_Fixture>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FixtureToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Fixture&&(identical(other.id, id) || other.id == id)&&(identical(other.apiId, apiId) || other.apiId == apiId)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.matchday, matchday) || other.matchday == matchday)&&(identical(other.homeTeam, homeTeam) || other.homeTeam == homeTeam)&&(identical(other.awayTeam, awayTeam) || other.awayTeam == awayTeam)&&(identical(other.kickoff, kickoff) || other.kickoff == kickoff)&&(identical(other.status, status) || other.status == status)&&(identical(other.homeScore, homeScore) || other.homeScore == homeScore)&&(identical(other.awayScore, awayScore) || other.awayScore == awayScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,apiId,competition,matchday,homeTeam,awayTeam,kickoff,status,homeScore,awayScore);
}

@override
String toString() {
    return 'Fixture(id: $id, apiId: $apiId, competition: $competition, matchday: $matchday, homeTeam: $homeTeam, awayTeam: $awayTeam, kickoff: $kickoff, status: $status, homeScore: $homeScore, awayScore: $awayScore)';
}


}

/// @nodoc
abstract mixin class _$FixtureCopyWith<$Res> implements $FixtureCopyWith<$Res> {
  factory _$FixtureCopyWith(_Fixture value, $Res Function(_Fixture) _then) = __$FixtureCopyWithImpl;
@override @useResult
$Res call({
 String id, int apiId, String competition, int matchday, String homeTeam, String awayTeam, DateTime kickoff, FixtureStatus status, int? homeScore, int? awayScore
});




}
/// @nodoc
class __$FixtureCopyWithImpl<$Res>
    implements _$FixtureCopyWith<$Res> {
  __$FixtureCopyWithImpl(this._self, this._then);

  final _Fixture _self;
  final $Res Function(_Fixture) _then;

/// Create a copy of Fixture
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? apiId = null,Object? competition = null,Object? matchday = null,Object? homeTeam = null,Object? awayTeam = null,Object? kickoff = null,Object? status = null,Object? homeScore = freezed,Object? awayScore = freezed,}) {
  return _then(_Fixture(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,apiId: null == apiId ? _self.apiId : apiId // ignore: cast_nullable_to_non_nullable
as int,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as String,matchday: null == matchday ? _self.matchday : matchday // ignore: cast_nullable_to_non_nullable
as int,homeTeam: null == homeTeam ? _self.homeTeam : homeTeam // ignore: cast_nullable_to_non_nullable
as String,awayTeam: null == awayTeam ? _self.awayTeam : awayTeam // ignore: cast_nullable_to_non_nullable
as String,kickoff: null == kickoff ? _self.kickoff : kickoff // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FixtureStatus,homeScore: freezed == homeScore ? _self.homeScore : homeScore // ignore: cast_nullable_to_non_nullable
as int?,awayScore: freezed == awayScore ? _self.awayScore : awayScore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
