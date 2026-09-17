// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'standing_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StandingEntry {

 String get userId; String get nickname; int get points; int get rank;
/// Create a copy of StandingEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StandingEntryCopyWith<StandingEntry> get copyWith => _$StandingEntryCopyWithImpl<StandingEntry>(this as StandingEntry, _$identity);

  /// Serializes this StandingEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StandingEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StandingEntry&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.nickname, _this.nickname) || other.nickname == _this.nickname)&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.rank, _this.rank) || other.rank == _this.rank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StandingEntry;
  return Object.hash(runtimeType,_this.userId,_this.nickname,_this.points,_this.rank);
}

@override
String toString() {
  final _this = this as StandingEntry;
  return 'StandingEntry(userId: ${_this.userId}, nickname: ${_this.nickname}, points: ${_this.points}, rank: ${_this.rank})';
}


}

/// @nodoc
abstract mixin class $StandingEntryCopyWith<$Res>  {
  factory $StandingEntryCopyWith(StandingEntry value, $Res Function(StandingEntry) _then) = _$StandingEntryCopyWithImpl;
@useResult
$Res call({
 String userId, String nickname, int points, int rank
});




}
/// @nodoc
class _$StandingEntryCopyWithImpl<$Res>
    implements $StandingEntryCopyWith<$Res> {
  _$StandingEntryCopyWithImpl(this._self, this._then);

  final StandingEntry _self;
  final $Res Function(StandingEntry) _then;

/// Create a copy of StandingEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? nickname = null,Object? points = null,Object? rank = null,}) {
  return _then(StandingEntry(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StandingEntry].
extension StandingEntryPatterns on StandingEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StandingEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StandingEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StandingEntry value)  $default,){
final _that = this;
switch (_that) {
case _StandingEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StandingEntry value)?  $default,){
final _that = this;
switch (_that) {
case _StandingEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String nickname,  int points,  int rank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StandingEntry() when $default != null:
return $default(_that.userId,_that.nickname,_that.points,_that.rank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String nickname,  int points,  int rank)  $default,) {final _that = this;
switch (_that) {
case _StandingEntry():
return $default(_that.userId,_that.nickname,_that.points,_that.rank);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String nickname,  int points,  int rank)?  $default,) {final _that = this;
switch (_that) {
case _StandingEntry() when $default != null:
return $default(_that.userId,_that.nickname,_that.points,_that.rank);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StandingEntry extends StandingEntry {
  const _StandingEntry({required this.userId, required this.nickname, required this.points, required this.rank}): super._();
  factory _StandingEntry.fromJson(Map<String, dynamic> json) => _$StandingEntryFromJson(json);

@override final  String userId;
@override final  String nickname;
@override final  int points;
@override final  int rank;

/// Create a copy of StandingEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StandingEntryCopyWith<_StandingEntry> get copyWith => __$StandingEntryCopyWithImpl<_StandingEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StandingEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StandingEntry&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.points, points) || other.points == points)&&(identical(other.rank, rank) || other.rank == rank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,nickname,points,rank);
}

@override
String toString() {
    return 'StandingEntry(userId: $userId, nickname: $nickname, points: $points, rank: $rank)';
}


}

/// @nodoc
abstract mixin class _$StandingEntryCopyWith<$Res> implements $StandingEntryCopyWith<$Res> {
  factory _$StandingEntryCopyWith(_StandingEntry value, $Res Function(_StandingEntry) _then) = __$StandingEntryCopyWithImpl;
@override @useResult
$Res call({
 String userId, String nickname, int points, int rank
});




}
/// @nodoc
class __$StandingEntryCopyWithImpl<$Res>
    implements _$StandingEntryCopyWith<$Res> {
  __$StandingEntryCopyWithImpl(this._self, this._then);

  final _StandingEntry _self;
  final $Res Function(_StandingEntry) _then;

/// Create a copy of StandingEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? nickname = null,Object? points = null,Object? rank = null,}) {
  return _then(_StandingEntry(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
