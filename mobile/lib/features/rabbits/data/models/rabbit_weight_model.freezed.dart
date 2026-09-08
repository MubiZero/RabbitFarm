// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rabbit_weight_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RabbitWeight {

@IntConverter() int get id;@JsonKey(name: 'rabbit_id')@IntConverter() int get rabbitId;@DoubleConverter() double get weight;@JsonKey(name: 'measured_at')@DateTimeConverter() DateTime get measuredAt; String? get notes;@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? get createdAt;
/// Create a copy of RabbitWeight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RabbitWeightCopyWith<RabbitWeight> get copyWith => _$RabbitWeightCopyWithImpl<RabbitWeight>(this as RabbitWeight, _$identity);

  /// Serializes this RabbitWeight to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RabbitWeight;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RabbitWeight&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.weight, _this.weight) || other.weight == _this.weight)&&(identical(other.measuredAt, _this.measuredAt) || other.measuredAt == _this.measuredAt)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RabbitWeight;
  return Object.hash(runtimeType,_this.id,_this.rabbitId,_this.weight,_this.measuredAt,_this.notes,_this.createdAt);
}

@override
String toString() {
  final _this = this as RabbitWeight;
  return 'RabbitWeight(id: ${_this.id}, rabbitId: ${_this.rabbitId}, weight: ${_this.weight}, measuredAt: ${_this.measuredAt}, notes: ${_this.notes}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $RabbitWeightCopyWith<$Res>  {
  factory $RabbitWeightCopyWith(RabbitWeight value, $Res Function(RabbitWeight) _then) = _$RabbitWeightCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@IntConverter() int rabbitId,@DoubleConverter() double weight,@JsonKey(name: 'measured_at')@DateTimeConverter() DateTime measuredAt, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt
});




}
/// @nodoc
class _$RabbitWeightCopyWithImpl<$Res>
    implements $RabbitWeightCopyWith<$Res> {
  _$RabbitWeightCopyWithImpl(this._self, this._then);

  final RabbitWeight _self;
  final $Res Function(RabbitWeight) _then;

/// Create a copy of RabbitWeight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rabbitId = null,Object? weight = null,Object? measuredAt = null,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(RabbitWeight(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RabbitWeight].
extension RabbitWeightPatterns on RabbitWeight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RabbitWeight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RabbitWeight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RabbitWeight value)  $default,){
final _that = this;
switch (_that) {
case _RabbitWeight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RabbitWeight value)?  $default,){
final _that = this;
switch (_that) {
case _RabbitWeight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId, @DoubleConverter()  double weight, @JsonKey(name: 'measured_at')@DateTimeConverter()  DateTime measuredAt,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RabbitWeight() when $default != null:
return $default(_that.id,_that.rabbitId,_that.weight,_that.measuredAt,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId, @DoubleConverter()  double weight, @JsonKey(name: 'measured_at')@DateTimeConverter()  DateTime measuredAt,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _RabbitWeight():
return $default(_that.id,_that.rabbitId,_that.weight,_that.measuredAt,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId, @DoubleConverter()  double weight, @JsonKey(name: 'measured_at')@DateTimeConverter()  DateTime measuredAt,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RabbitWeight() when $default != null:
return $default(_that.id,_that.rabbitId,_that.weight,_that.measuredAt,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RabbitWeight implements RabbitWeight {
  const _RabbitWeight({@IntConverter() required this.id, @JsonKey(name: 'rabbit_id')@IntConverter() required this.rabbitId, @DoubleConverter() required this.weight, @JsonKey(name: 'measured_at')@DateTimeConverter() required this.measuredAt, this.notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter() this.createdAt});
  factory _RabbitWeight.fromJson(Map<String, dynamic> json) => _$RabbitWeightFromJson(json);

@override@IntConverter() final  int id;
@override@JsonKey(name: 'rabbit_id')@IntConverter() final  int rabbitId;
@override@DoubleConverter() final  double weight;
@override@JsonKey(name: 'measured_at')@DateTimeConverter() final  DateTime measuredAt;
@override final  String? notes;
@override@JsonKey(name: 'created_at')@NullableDateTimeConverter() final  DateTime? createdAt;

/// Create a copy of RabbitWeight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RabbitWeightCopyWith<_RabbitWeight> get copyWith => __$RabbitWeightCopyWithImpl<_RabbitWeight>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RabbitWeightToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RabbitWeight&&(identical(other.id, id) || other.id == id)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,rabbitId,weight,measuredAt,notes,createdAt);
}

@override
String toString() {
    return 'RabbitWeight(id: $id, rabbitId: $rabbitId, weight: $weight, measuredAt: $measuredAt, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RabbitWeightCopyWith<$Res> implements $RabbitWeightCopyWith<$Res> {
  factory _$RabbitWeightCopyWith(_RabbitWeight value, $Res Function(_RabbitWeight) _then) = __$RabbitWeightCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@IntConverter() int rabbitId,@DoubleConverter() double weight,@JsonKey(name: 'measured_at')@DateTimeConverter() DateTime measuredAt, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt
});




}
/// @nodoc
class __$RabbitWeightCopyWithImpl<$Res>
    implements _$RabbitWeightCopyWith<$Res> {
  __$RabbitWeightCopyWithImpl(this._self, this._then);

  final _RabbitWeight _self;
  final $Res Function(_RabbitWeight) _then;

/// Create a copy of RabbitWeight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rabbitId = null,Object? weight = null,Object? measuredAt = null,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(_RabbitWeight(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
