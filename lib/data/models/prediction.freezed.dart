// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prediction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Prediction {

 String get id; String get userId; String get roundId; String get fixtureId; PredictionOutcome get outcome; int get homeGoals; int get awayGoals; int? get points; DateTime? get lockedAt;
/// Create a copy of Prediction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PredictionCopyWith<Prediction> get copyWith => _$PredictionCopyWithImpl<Prediction>(this as Prediction, _$identity);

  /// Serializes this Prediction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Prediction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Prediction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.roundId, _this.roundId) || other.roundId == _this.roundId)&&(identical(other.fixtureId, _this.fixtureId) || other.fixtureId == _this.fixtureId)&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.homeGoals, _this.homeGoals) || other.homeGoals == _this.homeGoals)&&(identical(other.awayGoals, _this.awayGoals) || other.awayGoals == _this.awayGoals)&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.lockedAt, _this.lockedAt) || other.lockedAt == _this.lockedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Prediction;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.roundId,_this.fixtureId,_this.outcome,_this.homeGoals,_this.awayGoals,_this.points,_this.lockedAt);
}

@override
String toString() {
  final _this = this as Prediction;
  return 'Prediction(id: ${_this.id}, userId: ${_this.userId}, roundId: ${_this.roundId}, fixtureId: ${_this.fixtureId}, outcome: ${_this.outcome}, homeGoals: ${_this.homeGoals}, awayGoals: ${_this.awayGoals}, points: ${_this.points}, lockedAt: ${_this.lockedAt})';
}


}

/// @nodoc
abstract mixin class $PredictionCopyWith<$Res>  {
  factory $PredictionCopyWith(Prediction value, $Res Function(Prediction) _then) = _$PredictionCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String roundId, String fixtureId, PredictionOutcome outcome, int homeGoals, int awayGoals, int? points, DateTime? lockedAt
});




}
/// @nodoc
class _$PredictionCopyWithImpl<$Res>
    implements $PredictionCopyWith<$Res> {
  _$PredictionCopyWithImpl(this._self, this._then);

  final Prediction _self;
  final $Res Function(Prediction) _then;

/// Create a copy of Prediction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? roundId = null,Object? fixtureId = null,Object? outcome = null,Object? homeGoals = null,Object? awayGoals = null,Object? points = freezed,Object? lockedAt = freezed,}) {
  return _then(Prediction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,roundId: null == roundId ? _self.roundId : roundId // ignore: cast_nullable_to_non_nullable
as String,fixtureId: null == fixtureId ? _self.fixtureId : fixtureId // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as PredictionOutcome,homeGoals: null == homeGoals ? _self.homeGoals : homeGoals // ignore: cast_nullable_to_non_nullable
as int,awayGoals: null == awayGoals ? _self.awayGoals : awayGoals // ignore: cast_nullable_to_non_nullable
as int,points: freezed == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int?,lockedAt: freezed == lockedAt ? _self.lockedAt : lockedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Prediction].
extension PredictionPatterns on Prediction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Prediction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Prediction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Prediction value)  $default,){
final _that = this;
switch (_that) {
case _Prediction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Prediction value)?  $default,){
final _that = this;
switch (_that) {
case _Prediction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String roundId,  String fixtureId,  PredictionOutcome outcome,  int homeGoals,  int awayGoals,  int? points,  DateTime? lockedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Prediction() when $default != null:
return $default(_that.id,_that.userId,_that.roundId,_that.fixtureId,_that.outcome,_that.homeGoals,_that.awayGoals,_that.points,_that.lockedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String roundId,  String fixtureId,  PredictionOutcome outcome,  int homeGoals,  int awayGoals,  int? points,  DateTime? lockedAt)  $default,) {final _that = this;
switch (_that) {
case _Prediction():
return $default(_that.id,_that.userId,_that.roundId,_that.fixtureId,_that.outcome,_that.homeGoals,_that.awayGoals,_that.points,_that.lockedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String roundId,  String fixtureId,  PredictionOutcome outcome,  int homeGoals,  int awayGoals,  int? points,  DateTime? lockedAt)?  $default,) {final _that = this;
switch (_that) {
case _Prediction() when $default != null:
return $default(_that.id,_that.userId,_that.roundId,_that.fixtureId,_that.outcome,_that.homeGoals,_that.awayGoals,_that.points,_that.lockedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Prediction extends Prediction {
  const _Prediction({required this.id, required this.userId, required this.roundId, required this.fixtureId, required this.outcome, required this.homeGoals, required this.awayGoals, this.points, this.lockedAt}): super._();
  factory _Prediction.fromJson(Map<String, dynamic> json) => _$PredictionFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String roundId;
@override final  String fixtureId;
@override final  PredictionOutcome outcome;
@override final  int homeGoals;
@override final  int awayGoals;
@override final  int? points;
@override final  DateTime? lockedAt;

/// Create a copy of Prediction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PredictionCopyWith<_Prediction> get copyWith => __$PredictionCopyWithImpl<_Prediction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PredictionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Prediction&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.roundId, roundId) || other.roundId == roundId)&&(identical(other.fixtureId, fixtureId) || other.fixtureId == fixtureId)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.homeGoals, homeGoals) || other.homeGoals == homeGoals)&&(identical(other.awayGoals, awayGoals) || other.awayGoals == awayGoals)&&(identical(other.points, points) || other.points == points)&&(identical(other.lockedAt, lockedAt) || other.lockedAt == lockedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,roundId,fixtureId,outcome,homeGoals,awayGoals,points,lockedAt);
}

@override
String toString() {
    return 'Prediction(id: $id, userId: $userId, roundId: $roundId, fixtureId: $fixtureId, outcome: $outcome, homeGoals: $homeGoals, awayGoals: $awayGoals, points: $points, lockedAt: $lockedAt)';
}


}

/// @nodoc
abstract mixin class _$PredictionCopyWith<$Res> implements $PredictionCopyWith<$Res> {
  factory _$PredictionCopyWith(_Prediction value, $Res Function(_Prediction) _then) = __$PredictionCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String roundId, String fixtureId, PredictionOutcome outcome, int homeGoals, int awayGoals, int? points, DateTime? lockedAt
});




}
/// @nodoc
class __$PredictionCopyWithImpl<$Res>
    implements _$PredictionCopyWith<$Res> {
  __$PredictionCopyWithImpl(this._self, this._then);

  final _Prediction _self;
  final $Res Function(_Prediction) _then;

/// Create a copy of Prediction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? roundId = null,Object? fixtureId = null,Object? outcome = null,Object? homeGoals = null,Object? awayGoals = null,Object? points = freezed,Object? lockedAt = freezed,}) {
  return _then(_Prediction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,roundId: null == roundId ? _self.roundId : roundId // ignore: cast_nullable_to_non_nullable
as String,fixtureId: null == fixtureId ? _self.fixtureId : fixtureId // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as PredictionOutcome,homeGoals: null == homeGoals ? _self.homeGoals : homeGoals // ignore: cast_nullable_to_non_nullable
as int,awayGoals: null == awayGoals ? _self.awayGoals : awayGoals // ignore: cast_nullable_to_non_nullable
as int,points: freezed == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int?,lockedAt: freezed == lockedAt ? _self.lockedAt : lockedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
