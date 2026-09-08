// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cage_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CageModel {

@IntConverter() int get id; String get number; String get type; String? get size;@IntConverter() int get capacity; String? get location; String get condition;@JsonKey(name: 'last_cleaned_at')@NullableDateTimeConverter() DateTime? get lastCleanedAt; String? get notes;@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? get updatedAt; List<RabbitModel>? get rabbits;@JsonKey(name: 'current_occupancy')@NullableIntConverter() int? get currentOccupancy;@JsonKey(name: 'is_full') bool? get isFull;@JsonKey(name: 'is_available') bool? get isAvailable;
/// Create a copy of CageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CageModelCopyWith<CageModel> get copyWith => _$CageModelCopyWithImpl<CageModel>(this as CageModel, _$identity);

  /// Serializes this CageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CageModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CageModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.condition, _this.condition) || other.condition == _this.condition)&&(identical(other.lastCleanedAt, _this.lastCleanedAt) || other.lastCleanedAt == _this.lastCleanedAt)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.rabbits, _this.rabbits)&&(identical(other.currentOccupancy, _this.currentOccupancy) || other.currentOccupancy == _this.currentOccupancy)&&(identical(other.isFull, _this.isFull) || other.isFull == _this.isFull)&&(identical(other.isAvailable, _this.isAvailable) || other.isAvailable == _this.isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CageModel;
  return Object.hash(runtimeType,_this.id,_this.number,_this.type,_this.size,_this.capacity,_this.location,_this.condition,_this.lastCleanedAt,_this.notes,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.rabbits),_this.currentOccupancy,_this.isFull,_this.isAvailable);
}

@override
String toString() {
  final _this = this as CageModel;
  return 'CageModel(id: ${_this.id}, number: ${_this.number}, type: ${_this.type}, size: ${_this.size}, capacity: ${_this.capacity}, location: ${_this.location}, condition: ${_this.condition}, lastCleanedAt: ${_this.lastCleanedAt}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, rabbits: ${_this.rabbits}, currentOccupancy: ${_this.currentOccupancy}, isFull: ${_this.isFull}, isAvailable: ${_this.isAvailable})';
}


}

/// @nodoc
abstract mixin class $CageModelCopyWith<$Res>  {
  factory $CageModelCopyWith(CageModel value, $Res Function(CageModel) _then) = _$CageModelCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String number, String type, String? size,@IntConverter() int capacity, String? location, String condition,@JsonKey(name: 'last_cleaned_at')@NullableDateTimeConverter() DateTime? lastCleanedAt, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt, List<RabbitModel>? rabbits,@JsonKey(name: 'current_occupancy')@NullableIntConverter() int? currentOccupancy,@JsonKey(name: 'is_full') bool? isFull,@JsonKey(name: 'is_available') bool? isAvailable
});




}
/// @nodoc
class _$CageModelCopyWithImpl<$Res>
    implements $CageModelCopyWith<$Res> {
  _$CageModelCopyWithImpl(this._self, this._then);

  final CageModel _self;
  final $Res Function(CageModel) _then;

/// Create a copy of CageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? type = null,Object? size = freezed,Object? capacity = null,Object? location = freezed,Object? condition = null,Object? lastCleanedAt = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rabbits = freezed,Object? currentOccupancy = freezed,Object? isFull = freezed,Object? isAvailable = freezed,}) {
  return _then(CageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String?,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,lastCleanedAt: freezed == lastCleanedAt ? _self.lastCleanedAt : lastCleanedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbits: freezed == rabbits ? _self.rabbits : rabbits // ignore: cast_nullable_to_non_nullable
as List<RabbitModel>?,currentOccupancy: freezed == currentOccupancy ? _self.currentOccupancy : currentOccupancy // ignore: cast_nullable_to_non_nullable
as int?,isFull: freezed == isFull ? _self.isFull : isFull // ignore: cast_nullable_to_non_nullable
as bool?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CageModel].
extension CageModelPatterns on CageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CageModel value)  $default,){
final _that = this;
switch (_that) {
case _CageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CageModel value)?  $default,){
final _that = this;
switch (_that) {
case _CageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String number,  String type,  String? size, @IntConverter()  int capacity,  String? location,  String condition, @JsonKey(name: 'last_cleaned_at')@NullableDateTimeConverter()  DateTime? lastCleanedAt,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt,  List<RabbitModel>? rabbits, @JsonKey(name: 'current_occupancy')@NullableIntConverter()  int? currentOccupancy, @JsonKey(name: 'is_full')  bool? isFull, @JsonKey(name: 'is_available')  bool? isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CageModel() when $default != null:
return $default(_that.id,_that.number,_that.type,_that.size,_that.capacity,_that.location,_that.condition,_that.lastCleanedAt,_that.notes,_that.createdAt,_that.updatedAt,_that.rabbits,_that.currentOccupancy,_that.isFull,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String number,  String type,  String? size, @IntConverter()  int capacity,  String? location,  String condition, @JsonKey(name: 'last_cleaned_at')@NullableDateTimeConverter()  DateTime? lastCleanedAt,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt,  List<RabbitModel>? rabbits, @JsonKey(name: 'current_occupancy')@NullableIntConverter()  int? currentOccupancy, @JsonKey(name: 'is_full')  bool? isFull, @JsonKey(name: 'is_available')  bool? isAvailable)  $default,) {final _that = this;
switch (_that) {
case _CageModel():
return $default(_that.id,_that.number,_that.type,_that.size,_that.capacity,_that.location,_that.condition,_that.lastCleanedAt,_that.notes,_that.createdAt,_that.updatedAt,_that.rabbits,_that.currentOccupancy,_that.isFull,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String number,  String type,  String? size, @IntConverter()  int capacity,  String? location,  String condition, @JsonKey(name: 'last_cleaned_at')@NullableDateTimeConverter()  DateTime? lastCleanedAt,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt,  List<RabbitModel>? rabbits, @JsonKey(name: 'current_occupancy')@NullableIntConverter()  int? currentOccupancy, @JsonKey(name: 'is_full')  bool? isFull, @JsonKey(name: 'is_available')  bool? isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _CageModel() when $default != null:
return $default(_that.id,_that.number,_that.type,_that.size,_that.capacity,_that.location,_that.condition,_that.lastCleanedAt,_that.notes,_that.createdAt,_that.updatedAt,_that.rabbits,_that.currentOccupancy,_that.isFull,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CageModel implements CageModel {
  const _CageModel({@IntConverter() required this.id, required this.number, required this.type, this.size, @IntConverter() required this.capacity, this.location, required this.condition, @JsonKey(name: 'last_cleaned_at')@NullableDateTimeConverter() this.lastCleanedAt, this.notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter() this.updatedAt,  List<RabbitModel>? rabbits, @JsonKey(name: 'current_occupancy')@NullableIntConverter() this.currentOccupancy, @JsonKey(name: 'is_full') this.isFull, @JsonKey(name: 'is_available') this.isAvailable}): _rabbits = rabbits;
  factory _CageModel.fromJson(Map<String, dynamic> json) => _$CageModelFromJson(json);

@override@IntConverter() final  int id;
@override final  String number;
@override final  String type;
@override final  String? size;
@override@IntConverter() final  int capacity;
@override final  String? location;
@override final  String condition;
@override@JsonKey(name: 'last_cleaned_at')@NullableDateTimeConverter() final  DateTime? lastCleanedAt;
@override final  String? notes;
@override@JsonKey(name: 'created_at')@NullableDateTimeConverter() final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at')@NullableDateTimeConverter() final  DateTime? updatedAt;
 final  List<RabbitModel>? _rabbits;
@override List<RabbitModel>? get rabbits {
  final value = _rabbits;
  if (value == null) return null;
  if (_rabbits is EqualUnmodifiableListView) return _rabbits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'current_occupancy')@NullableIntConverter() final  int? currentOccupancy;
@override@JsonKey(name: 'is_full') final  bool? isFull;
@override@JsonKey(name: 'is_available') final  bool? isAvailable;

/// Create a copy of CageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CageModelCopyWith<_CageModel> get copyWith => __$CageModelCopyWithImpl<_CageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CageModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.type, type) || other.type == type)&&(identical(other.size, size) || other.size == size)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.location, location) || other.location == location)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.lastCleanedAt, lastCleanedAt) || other.lastCleanedAt == lastCleanedAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.rabbits, _rabbits)&&(identical(other.currentOccupancy, currentOccupancy) || other.currentOccupancy == currentOccupancy)&&(identical(other.isFull, isFull) || other.isFull == isFull)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,number,type,size,capacity,location,condition,lastCleanedAt,notes,createdAt,updatedAt,const DeepCollectionEquality().hash(_rabbits),currentOccupancy,isFull,isAvailable);
}

@override
String toString() {
    return 'CageModel(id: $id, number: $number, type: $type, size: $size, capacity: $capacity, location: $location, condition: $condition, lastCleanedAt: $lastCleanedAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, rabbits: $rabbits, currentOccupancy: $currentOccupancy, isFull: $isFull, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$CageModelCopyWith<$Res> implements $CageModelCopyWith<$Res> {
  factory _$CageModelCopyWith(_CageModel value, $Res Function(_CageModel) _then) = __$CageModelCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String number, String type, String? size,@IntConverter() int capacity, String? location, String condition,@JsonKey(name: 'last_cleaned_at')@NullableDateTimeConverter() DateTime? lastCleanedAt, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt, List<RabbitModel>? rabbits,@JsonKey(name: 'current_occupancy')@NullableIntConverter() int? currentOccupancy,@JsonKey(name: 'is_full') bool? isFull,@JsonKey(name: 'is_available') bool? isAvailable
});




}
/// @nodoc
class __$CageModelCopyWithImpl<$Res>
    implements _$CageModelCopyWith<$Res> {
  __$CageModelCopyWithImpl(this._self, this._then);

  final _CageModel _self;
  final $Res Function(_CageModel) _then;

/// Create a copy of CageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? type = null,Object? size = freezed,Object? capacity = null,Object? location = freezed,Object? condition = null,Object? lastCleanedAt = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rabbits = freezed,Object? currentOccupancy = freezed,Object? isFull = freezed,Object? isAvailable = freezed,}) {
  return _then(_CageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String?,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,lastCleanedAt: freezed == lastCleanedAt ? _self.lastCleanedAt : lastCleanedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbits: freezed == rabbits ? _self._rabbits : rabbits // ignore: cast_nullable_to_non_nullable
as List<RabbitModel>?,currentOccupancy: freezed == currentOccupancy ? _self.currentOccupancy : currentOccupancy // ignore: cast_nullable_to_non_nullable
as int?,isFull: freezed == isFull ? _self.isFull : isFull // ignore: cast_nullable_to_non_nullable
as bool?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$CageStatistics {

@JsonKey(name: 'total_cages')@IntConverter() int get totalCages;@JsonKey(name: 'by_type') CageTypeStats get byType;@JsonKey(name: 'by_condition') CageConditionStats get byCondition; CageOccupancyStats get occupancy;
/// Create a copy of CageStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CageStatisticsCopyWith<CageStatistics> get copyWith => _$CageStatisticsCopyWithImpl<CageStatistics>(this as CageStatistics, _$identity);

  /// Serializes this CageStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CageStatistics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CageStatistics&&(identical(other.totalCages, _this.totalCages) || other.totalCages == _this.totalCages)&&(identical(other.byType, _this.byType) || other.byType == _this.byType)&&(identical(other.byCondition, _this.byCondition) || other.byCondition == _this.byCondition)&&(identical(other.occupancy, _this.occupancy) || other.occupancy == _this.occupancy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CageStatistics;
  return Object.hash(runtimeType,_this.totalCages,_this.byType,_this.byCondition,_this.occupancy);
}

@override
String toString() {
  final _this = this as CageStatistics;
  return 'CageStatistics(totalCages: ${_this.totalCages}, byType: ${_this.byType}, byCondition: ${_this.byCondition}, occupancy: ${_this.occupancy})';
}


}

/// @nodoc
abstract mixin class $CageStatisticsCopyWith<$Res>  {
  factory $CageStatisticsCopyWith(CageStatistics value, $Res Function(CageStatistics) _then) = _$CageStatisticsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_cages')@IntConverter() int totalCages,@JsonKey(name: 'by_type') CageTypeStats byType,@JsonKey(name: 'by_condition') CageConditionStats byCondition, CageOccupancyStats occupancy
});


$CageTypeStatsCopyWith<$Res> get byType;$CageConditionStatsCopyWith<$Res> get byCondition;$CageOccupancyStatsCopyWith<$Res> get occupancy;

}
/// @nodoc
class _$CageStatisticsCopyWithImpl<$Res>
    implements $CageStatisticsCopyWith<$Res> {
  _$CageStatisticsCopyWithImpl(this._self, this._then);

  final CageStatistics _self;
  final $Res Function(CageStatistics) _then;

/// Create a copy of CageStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCages = null,Object? byType = null,Object? byCondition = null,Object? occupancy = null,}) {
  return _then(CageStatistics(
totalCages: null == totalCages ? _self.totalCages : totalCages // ignore: cast_nullable_to_non_nullable
as int,byType: null == byType ? _self.byType : byType // ignore: cast_nullable_to_non_nullable
as CageTypeStats,byCondition: null == byCondition ? _self.byCondition : byCondition // ignore: cast_nullable_to_non_nullable
as CageConditionStats,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as CageOccupancyStats,
  ));
}
/// Create a copy of CageStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageTypeStatsCopyWith<$Res> get byType {
  
  return $CageTypeStatsCopyWith<$Res>(_self.byType, (value) {
    return _then(_self.copyWith(byType: value));
  });
}/// Create a copy of CageStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageConditionStatsCopyWith<$Res> get byCondition {
  
  return $CageConditionStatsCopyWith<$Res>(_self.byCondition, (value) {
    return _then(_self.copyWith(byCondition: value));
  });
}/// Create a copy of CageStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageOccupancyStatsCopyWith<$Res> get occupancy {
  
  return $CageOccupancyStatsCopyWith<$Res>(_self.occupancy, (value) {
    return _then(_self.copyWith(occupancy: value));
  });
}
}


/// Adds pattern-matching-related methods to [CageStatistics].
extension CageStatisticsPatterns on CageStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CageStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CageStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CageStatistics value)  $default,){
final _that = this;
switch (_that) {
case _CageStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CageStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _CageStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_cages')@IntConverter()  int totalCages, @JsonKey(name: 'by_type')  CageTypeStats byType, @JsonKey(name: 'by_condition')  CageConditionStats byCondition,  CageOccupancyStats occupancy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CageStatistics() when $default != null:
return $default(_that.totalCages,_that.byType,_that.byCondition,_that.occupancy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_cages')@IntConverter()  int totalCages, @JsonKey(name: 'by_type')  CageTypeStats byType, @JsonKey(name: 'by_condition')  CageConditionStats byCondition,  CageOccupancyStats occupancy)  $default,) {final _that = this;
switch (_that) {
case _CageStatistics():
return $default(_that.totalCages,_that.byType,_that.byCondition,_that.occupancy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_cages')@IntConverter()  int totalCages, @JsonKey(name: 'by_type')  CageTypeStats byType, @JsonKey(name: 'by_condition')  CageConditionStats byCondition,  CageOccupancyStats occupancy)?  $default,) {final _that = this;
switch (_that) {
case _CageStatistics() when $default != null:
return $default(_that.totalCages,_that.byType,_that.byCondition,_that.occupancy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CageStatistics implements CageStatistics {
  const _CageStatistics({@JsonKey(name: 'total_cages')@IntConverter() required this.totalCages, @JsonKey(name: 'by_type') required this.byType, @JsonKey(name: 'by_condition') required this.byCondition, required this.occupancy});
  factory _CageStatistics.fromJson(Map<String, dynamic> json) => _$CageStatisticsFromJson(json);

@override@JsonKey(name: 'total_cages')@IntConverter() final  int totalCages;
@override@JsonKey(name: 'by_type') final  CageTypeStats byType;
@override@JsonKey(name: 'by_condition') final  CageConditionStats byCondition;
@override final  CageOccupancyStats occupancy;

/// Create a copy of CageStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CageStatisticsCopyWith<_CageStatistics> get copyWith => __$CageStatisticsCopyWithImpl<_CageStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CageStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CageStatistics&&(identical(other.totalCages, totalCages) || other.totalCages == totalCages)&&(identical(other.byType, byType) || other.byType == byType)&&(identical(other.byCondition, byCondition) || other.byCondition == byCondition)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalCages,byType,byCondition,occupancy);
}

@override
String toString() {
    return 'CageStatistics(totalCages: $totalCages, byType: $byType, byCondition: $byCondition, occupancy: $occupancy)';
}


}

/// @nodoc
abstract mixin class _$CageStatisticsCopyWith<$Res> implements $CageStatisticsCopyWith<$Res> {
  factory _$CageStatisticsCopyWith(_CageStatistics value, $Res Function(_CageStatistics) _then) = __$CageStatisticsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_cages')@IntConverter() int totalCages,@JsonKey(name: 'by_type') CageTypeStats byType,@JsonKey(name: 'by_condition') CageConditionStats byCondition, CageOccupancyStats occupancy
});


@override $CageTypeStatsCopyWith<$Res> get byType;@override $CageConditionStatsCopyWith<$Res> get byCondition;@override $CageOccupancyStatsCopyWith<$Res> get occupancy;

}
/// @nodoc
class __$CageStatisticsCopyWithImpl<$Res>
    implements _$CageStatisticsCopyWith<$Res> {
  __$CageStatisticsCopyWithImpl(this._self, this._then);

  final _CageStatistics _self;
  final $Res Function(_CageStatistics) _then;

/// Create a copy of CageStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCages = null,Object? byType = null,Object? byCondition = null,Object? occupancy = null,}) {
  return _then(_CageStatistics(
totalCages: null == totalCages ? _self.totalCages : totalCages // ignore: cast_nullable_to_non_nullable
as int,byType: null == byType ? _self.byType : byType // ignore: cast_nullable_to_non_nullable
as CageTypeStats,byCondition: null == byCondition ? _self.byCondition : byCondition // ignore: cast_nullable_to_non_nullable
as CageConditionStats,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as CageOccupancyStats,
  ));
}

/// Create a copy of CageStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageTypeStatsCopyWith<$Res> get byType {
  
  return $CageTypeStatsCopyWith<$Res>(_self.byType, (value) {
    return _then(_self.copyWith(byType: value));
  });
}/// Create a copy of CageStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageConditionStatsCopyWith<$Res> get byCondition {
  
  return $CageConditionStatsCopyWith<$Res>(_self.byCondition, (value) {
    return _then(_self.copyWith(byCondition: value));
  });
}/// Create a copy of CageStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageOccupancyStatsCopyWith<$Res> get occupancy {
  
  return $CageOccupancyStatsCopyWith<$Res>(_self.occupancy, (value) {
    return _then(_self.copyWith(occupancy: value));
  });
}
}


/// @nodoc
mixin _$CageTypeStats {

@IntConverter() int get single;@IntConverter() int get group;@IntConverter() int get maternity;
/// Create a copy of CageTypeStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CageTypeStatsCopyWith<CageTypeStats> get copyWith => _$CageTypeStatsCopyWithImpl<CageTypeStats>(this as CageTypeStats, _$identity);

  /// Serializes this CageTypeStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CageTypeStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CageTypeStats&&(identical(other.single, _this.single) || other.single == _this.single)&&(identical(other.group, _this.group) || other.group == _this.group)&&(identical(other.maternity, _this.maternity) || other.maternity == _this.maternity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CageTypeStats;
  return Object.hash(runtimeType,_this.single,_this.group,_this.maternity);
}

@override
String toString() {
  final _this = this as CageTypeStats;
  return 'CageTypeStats(single: ${_this.single}, group: ${_this.group}, maternity: ${_this.maternity})';
}


}

/// @nodoc
abstract mixin class $CageTypeStatsCopyWith<$Res>  {
  factory $CageTypeStatsCopyWith(CageTypeStats value, $Res Function(CageTypeStats) _then) = _$CageTypeStatsCopyWithImpl;
@useResult
$Res call({
@IntConverter() int single,@IntConverter() int group,@IntConverter() int maternity
});




}
/// @nodoc
class _$CageTypeStatsCopyWithImpl<$Res>
    implements $CageTypeStatsCopyWith<$Res> {
  _$CageTypeStatsCopyWithImpl(this._self, this._then);

  final CageTypeStats _self;
  final $Res Function(CageTypeStats) _then;

/// Create a copy of CageTypeStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? single = null,Object? group = null,Object? maternity = null,}) {
  return _then(CageTypeStats(
single: null == single ? _self.single : single // ignore: cast_nullable_to_non_nullable
as int,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as int,maternity: null == maternity ? _self.maternity : maternity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CageTypeStats].
extension CageTypeStatsPatterns on CageTypeStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CageTypeStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CageTypeStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CageTypeStats value)  $default,){
final _that = this;
switch (_that) {
case _CageTypeStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CageTypeStats value)?  $default,){
final _that = this;
switch (_that) {
case _CageTypeStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int single, @IntConverter()  int group, @IntConverter()  int maternity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CageTypeStats() when $default != null:
return $default(_that.single,_that.group,_that.maternity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int single, @IntConverter()  int group, @IntConverter()  int maternity)  $default,) {final _that = this;
switch (_that) {
case _CageTypeStats():
return $default(_that.single,_that.group,_that.maternity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int single, @IntConverter()  int group, @IntConverter()  int maternity)?  $default,) {final _that = this;
switch (_that) {
case _CageTypeStats() when $default != null:
return $default(_that.single,_that.group,_that.maternity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CageTypeStats implements CageTypeStats {
  const _CageTypeStats({@IntConverter() required this.single, @IntConverter() required this.group, @IntConverter() required this.maternity});
  factory _CageTypeStats.fromJson(Map<String, dynamic> json) => _$CageTypeStatsFromJson(json);

@override@IntConverter() final  int single;
@override@IntConverter() final  int group;
@override@IntConverter() final  int maternity;

/// Create a copy of CageTypeStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CageTypeStatsCopyWith<_CageTypeStats> get copyWith => __$CageTypeStatsCopyWithImpl<_CageTypeStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CageTypeStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CageTypeStats&&(identical(other.single, single) || other.single == single)&&(identical(other.group, group) || other.group == group)&&(identical(other.maternity, maternity) || other.maternity == maternity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,single,group,maternity);
}

@override
String toString() {
    return 'CageTypeStats(single: $single, group: $group, maternity: $maternity)';
}


}

/// @nodoc
abstract mixin class _$CageTypeStatsCopyWith<$Res> implements $CageTypeStatsCopyWith<$Res> {
  factory _$CageTypeStatsCopyWith(_CageTypeStats value, $Res Function(_CageTypeStats) _then) = __$CageTypeStatsCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int single,@IntConverter() int group,@IntConverter() int maternity
});




}
/// @nodoc
class __$CageTypeStatsCopyWithImpl<$Res>
    implements _$CageTypeStatsCopyWith<$Res> {
  __$CageTypeStatsCopyWithImpl(this._self, this._then);

  final _CageTypeStats _self;
  final $Res Function(_CageTypeStats) _then;

/// Create a copy of CageTypeStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? single = null,Object? group = null,Object? maternity = null,}) {
  return _then(_CageTypeStats(
single: null == single ? _self.single : single // ignore: cast_nullable_to_non_nullable
as int,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as int,maternity: null == maternity ? _self.maternity : maternity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CageConditionStats {

@IntConverter() int get good;@JsonKey(name: 'needs_repair')@IntConverter() int get needsRepair;@IntConverter() int get broken;
/// Create a copy of CageConditionStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CageConditionStatsCopyWith<CageConditionStats> get copyWith => _$CageConditionStatsCopyWithImpl<CageConditionStats>(this as CageConditionStats, _$identity);

  /// Serializes this CageConditionStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CageConditionStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CageConditionStats&&(identical(other.good, _this.good) || other.good == _this.good)&&(identical(other.needsRepair, _this.needsRepair) || other.needsRepair == _this.needsRepair)&&(identical(other.broken, _this.broken) || other.broken == _this.broken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CageConditionStats;
  return Object.hash(runtimeType,_this.good,_this.needsRepair,_this.broken);
}

@override
String toString() {
  final _this = this as CageConditionStats;
  return 'CageConditionStats(good: ${_this.good}, needsRepair: ${_this.needsRepair}, broken: ${_this.broken})';
}


}

/// @nodoc
abstract mixin class $CageConditionStatsCopyWith<$Res>  {
  factory $CageConditionStatsCopyWith(CageConditionStats value, $Res Function(CageConditionStats) _then) = _$CageConditionStatsCopyWithImpl;
@useResult
$Res call({
@IntConverter() int good,@JsonKey(name: 'needs_repair')@IntConverter() int needsRepair,@IntConverter() int broken
});




}
/// @nodoc
class _$CageConditionStatsCopyWithImpl<$Res>
    implements $CageConditionStatsCopyWith<$Res> {
  _$CageConditionStatsCopyWithImpl(this._self, this._then);

  final CageConditionStats _self;
  final $Res Function(CageConditionStats) _then;

/// Create a copy of CageConditionStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? good = null,Object? needsRepair = null,Object? broken = null,}) {
  return _then(CageConditionStats(
good: null == good ? _self.good : good // ignore: cast_nullable_to_non_nullable
as int,needsRepair: null == needsRepair ? _self.needsRepair : needsRepair // ignore: cast_nullable_to_non_nullable
as int,broken: null == broken ? _self.broken : broken // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CageConditionStats].
extension CageConditionStatsPatterns on CageConditionStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CageConditionStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CageConditionStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CageConditionStats value)  $default,){
final _that = this;
switch (_that) {
case _CageConditionStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CageConditionStats value)?  $default,){
final _that = this;
switch (_that) {
case _CageConditionStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int good, @JsonKey(name: 'needs_repair')@IntConverter()  int needsRepair, @IntConverter()  int broken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CageConditionStats() when $default != null:
return $default(_that.good,_that.needsRepair,_that.broken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int good, @JsonKey(name: 'needs_repair')@IntConverter()  int needsRepair, @IntConverter()  int broken)  $default,) {final _that = this;
switch (_that) {
case _CageConditionStats():
return $default(_that.good,_that.needsRepair,_that.broken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int good, @JsonKey(name: 'needs_repair')@IntConverter()  int needsRepair, @IntConverter()  int broken)?  $default,) {final _that = this;
switch (_that) {
case _CageConditionStats() when $default != null:
return $default(_that.good,_that.needsRepair,_that.broken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CageConditionStats implements CageConditionStats {
  const _CageConditionStats({@IntConverter() required this.good, @JsonKey(name: 'needs_repair')@IntConverter() required this.needsRepair, @IntConverter() required this.broken});
  factory _CageConditionStats.fromJson(Map<String, dynamic> json) => _$CageConditionStatsFromJson(json);

@override@IntConverter() final  int good;
@override@JsonKey(name: 'needs_repair')@IntConverter() final  int needsRepair;
@override@IntConverter() final  int broken;

/// Create a copy of CageConditionStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CageConditionStatsCopyWith<_CageConditionStats> get copyWith => __$CageConditionStatsCopyWithImpl<_CageConditionStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CageConditionStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CageConditionStats&&(identical(other.good, good) || other.good == good)&&(identical(other.needsRepair, needsRepair) || other.needsRepair == needsRepair)&&(identical(other.broken, broken) || other.broken == broken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,good,needsRepair,broken);
}

@override
String toString() {
    return 'CageConditionStats(good: $good, needsRepair: $needsRepair, broken: $broken)';
}


}

/// @nodoc
abstract mixin class _$CageConditionStatsCopyWith<$Res> implements $CageConditionStatsCopyWith<$Res> {
  factory _$CageConditionStatsCopyWith(_CageConditionStats value, $Res Function(_CageConditionStats) _then) = __$CageConditionStatsCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int good,@JsonKey(name: 'needs_repair')@IntConverter() int needsRepair,@IntConverter() int broken
});




}
/// @nodoc
class __$CageConditionStatsCopyWithImpl<$Res>
    implements _$CageConditionStatsCopyWith<$Res> {
  __$CageConditionStatsCopyWithImpl(this._self, this._then);

  final _CageConditionStats _self;
  final $Res Function(_CageConditionStats) _then;

/// Create a copy of CageConditionStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? good = null,Object? needsRepair = null,Object? broken = null,}) {
  return _then(_CageConditionStats(
good: null == good ? _self.good : good // ignore: cast_nullable_to_non_nullable
as int,needsRepair: null == needsRepair ? _self.needsRepair : needsRepair // ignore: cast_nullable_to_non_nullable
as int,broken: null == broken ? _self.broken : broken // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CageOccupancyStats {

@JsonKey(name: 'total_capacity')@IntConverter() int get totalCapacity;@JsonKey(name: 'current_occupancy')@IntConverter() int get currentOccupancy;@JsonKey(name: 'available_spaces')@IntConverter() int get availableSpaces;@JsonKey(name: 'occupancy_rate')@IntConverter() int get occupancyRate;@JsonKey(name: 'full_cages')@IntConverter() int get fullCages;@JsonKey(name: 'empty_cages')@IntConverter() int get emptyCages;
/// Create a copy of CageOccupancyStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CageOccupancyStatsCopyWith<CageOccupancyStats> get copyWith => _$CageOccupancyStatsCopyWithImpl<CageOccupancyStats>(this as CageOccupancyStats, _$identity);

  /// Serializes this CageOccupancyStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CageOccupancyStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CageOccupancyStats&&(identical(other.totalCapacity, _this.totalCapacity) || other.totalCapacity == _this.totalCapacity)&&(identical(other.currentOccupancy, _this.currentOccupancy) || other.currentOccupancy == _this.currentOccupancy)&&(identical(other.availableSpaces, _this.availableSpaces) || other.availableSpaces == _this.availableSpaces)&&(identical(other.occupancyRate, _this.occupancyRate) || other.occupancyRate == _this.occupancyRate)&&(identical(other.fullCages, _this.fullCages) || other.fullCages == _this.fullCages)&&(identical(other.emptyCages, _this.emptyCages) || other.emptyCages == _this.emptyCages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CageOccupancyStats;
  return Object.hash(runtimeType,_this.totalCapacity,_this.currentOccupancy,_this.availableSpaces,_this.occupancyRate,_this.fullCages,_this.emptyCages);
}

@override
String toString() {
  final _this = this as CageOccupancyStats;
  return 'CageOccupancyStats(totalCapacity: ${_this.totalCapacity}, currentOccupancy: ${_this.currentOccupancy}, availableSpaces: ${_this.availableSpaces}, occupancyRate: ${_this.occupancyRate}, fullCages: ${_this.fullCages}, emptyCages: ${_this.emptyCages})';
}


}

/// @nodoc
abstract mixin class $CageOccupancyStatsCopyWith<$Res>  {
  factory $CageOccupancyStatsCopyWith(CageOccupancyStats value, $Res Function(CageOccupancyStats) _then) = _$CageOccupancyStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_capacity')@IntConverter() int totalCapacity,@JsonKey(name: 'current_occupancy')@IntConverter() int currentOccupancy,@JsonKey(name: 'available_spaces')@IntConverter() int availableSpaces,@JsonKey(name: 'occupancy_rate')@IntConverter() int occupancyRate,@JsonKey(name: 'full_cages')@IntConverter() int fullCages,@JsonKey(name: 'empty_cages')@IntConverter() int emptyCages
});




}
/// @nodoc
class _$CageOccupancyStatsCopyWithImpl<$Res>
    implements $CageOccupancyStatsCopyWith<$Res> {
  _$CageOccupancyStatsCopyWithImpl(this._self, this._then);

  final CageOccupancyStats _self;
  final $Res Function(CageOccupancyStats) _then;

/// Create a copy of CageOccupancyStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCapacity = null,Object? currentOccupancy = null,Object? availableSpaces = null,Object? occupancyRate = null,Object? fullCages = null,Object? emptyCages = null,}) {
  return _then(CageOccupancyStats(
totalCapacity: null == totalCapacity ? _self.totalCapacity : totalCapacity // ignore: cast_nullable_to_non_nullable
as int,currentOccupancy: null == currentOccupancy ? _self.currentOccupancy : currentOccupancy // ignore: cast_nullable_to_non_nullable
as int,availableSpaces: null == availableSpaces ? _self.availableSpaces : availableSpaces // ignore: cast_nullable_to_non_nullable
as int,occupancyRate: null == occupancyRate ? _self.occupancyRate : occupancyRate // ignore: cast_nullable_to_non_nullable
as int,fullCages: null == fullCages ? _self.fullCages : fullCages // ignore: cast_nullable_to_non_nullable
as int,emptyCages: null == emptyCages ? _self.emptyCages : emptyCages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CageOccupancyStats].
extension CageOccupancyStatsPatterns on CageOccupancyStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CageOccupancyStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CageOccupancyStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CageOccupancyStats value)  $default,){
final _that = this;
switch (_that) {
case _CageOccupancyStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CageOccupancyStats value)?  $default,){
final _that = this;
switch (_that) {
case _CageOccupancyStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_capacity')@IntConverter()  int totalCapacity, @JsonKey(name: 'current_occupancy')@IntConverter()  int currentOccupancy, @JsonKey(name: 'available_spaces')@IntConverter()  int availableSpaces, @JsonKey(name: 'occupancy_rate')@IntConverter()  int occupancyRate, @JsonKey(name: 'full_cages')@IntConverter()  int fullCages, @JsonKey(name: 'empty_cages')@IntConverter()  int emptyCages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CageOccupancyStats() when $default != null:
return $default(_that.totalCapacity,_that.currentOccupancy,_that.availableSpaces,_that.occupancyRate,_that.fullCages,_that.emptyCages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_capacity')@IntConverter()  int totalCapacity, @JsonKey(name: 'current_occupancy')@IntConverter()  int currentOccupancy, @JsonKey(name: 'available_spaces')@IntConverter()  int availableSpaces, @JsonKey(name: 'occupancy_rate')@IntConverter()  int occupancyRate, @JsonKey(name: 'full_cages')@IntConverter()  int fullCages, @JsonKey(name: 'empty_cages')@IntConverter()  int emptyCages)  $default,) {final _that = this;
switch (_that) {
case _CageOccupancyStats():
return $default(_that.totalCapacity,_that.currentOccupancy,_that.availableSpaces,_that.occupancyRate,_that.fullCages,_that.emptyCages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_capacity')@IntConverter()  int totalCapacity, @JsonKey(name: 'current_occupancy')@IntConverter()  int currentOccupancy, @JsonKey(name: 'available_spaces')@IntConverter()  int availableSpaces, @JsonKey(name: 'occupancy_rate')@IntConverter()  int occupancyRate, @JsonKey(name: 'full_cages')@IntConverter()  int fullCages, @JsonKey(name: 'empty_cages')@IntConverter()  int emptyCages)?  $default,) {final _that = this;
switch (_that) {
case _CageOccupancyStats() when $default != null:
return $default(_that.totalCapacity,_that.currentOccupancy,_that.availableSpaces,_that.occupancyRate,_that.fullCages,_that.emptyCages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CageOccupancyStats implements CageOccupancyStats {
  const _CageOccupancyStats({@JsonKey(name: 'total_capacity')@IntConverter() required this.totalCapacity, @JsonKey(name: 'current_occupancy')@IntConverter() required this.currentOccupancy, @JsonKey(name: 'available_spaces')@IntConverter() required this.availableSpaces, @JsonKey(name: 'occupancy_rate')@IntConverter() required this.occupancyRate, @JsonKey(name: 'full_cages')@IntConverter() required this.fullCages, @JsonKey(name: 'empty_cages')@IntConverter() required this.emptyCages});
  factory _CageOccupancyStats.fromJson(Map<String, dynamic> json) => _$CageOccupancyStatsFromJson(json);

@override@JsonKey(name: 'total_capacity')@IntConverter() final  int totalCapacity;
@override@JsonKey(name: 'current_occupancy')@IntConverter() final  int currentOccupancy;
@override@JsonKey(name: 'available_spaces')@IntConverter() final  int availableSpaces;
@override@JsonKey(name: 'occupancy_rate')@IntConverter() final  int occupancyRate;
@override@JsonKey(name: 'full_cages')@IntConverter() final  int fullCages;
@override@JsonKey(name: 'empty_cages')@IntConverter() final  int emptyCages;

/// Create a copy of CageOccupancyStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CageOccupancyStatsCopyWith<_CageOccupancyStats> get copyWith => __$CageOccupancyStatsCopyWithImpl<_CageOccupancyStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CageOccupancyStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CageOccupancyStats&&(identical(other.totalCapacity, totalCapacity) || other.totalCapacity == totalCapacity)&&(identical(other.currentOccupancy, currentOccupancy) || other.currentOccupancy == currentOccupancy)&&(identical(other.availableSpaces, availableSpaces) || other.availableSpaces == availableSpaces)&&(identical(other.occupancyRate, occupancyRate) || other.occupancyRate == occupancyRate)&&(identical(other.fullCages, fullCages) || other.fullCages == fullCages)&&(identical(other.emptyCages, emptyCages) || other.emptyCages == emptyCages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalCapacity,currentOccupancy,availableSpaces,occupancyRate,fullCages,emptyCages);
}

@override
String toString() {
    return 'CageOccupancyStats(totalCapacity: $totalCapacity, currentOccupancy: $currentOccupancy, availableSpaces: $availableSpaces, occupancyRate: $occupancyRate, fullCages: $fullCages, emptyCages: $emptyCages)';
}


}

/// @nodoc
abstract mixin class _$CageOccupancyStatsCopyWith<$Res> implements $CageOccupancyStatsCopyWith<$Res> {
  factory _$CageOccupancyStatsCopyWith(_CageOccupancyStats value, $Res Function(_CageOccupancyStats) _then) = __$CageOccupancyStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_capacity')@IntConverter() int totalCapacity,@JsonKey(name: 'current_occupancy')@IntConverter() int currentOccupancy,@JsonKey(name: 'available_spaces')@IntConverter() int availableSpaces,@JsonKey(name: 'occupancy_rate')@IntConverter() int occupancyRate,@JsonKey(name: 'full_cages')@IntConverter() int fullCages,@JsonKey(name: 'empty_cages')@IntConverter() int emptyCages
});




}
/// @nodoc
class __$CageOccupancyStatsCopyWithImpl<$Res>
    implements _$CageOccupancyStatsCopyWith<$Res> {
  __$CageOccupancyStatsCopyWithImpl(this._self, this._then);

  final _CageOccupancyStats _self;
  final $Res Function(_CageOccupancyStats) _then;

/// Create a copy of CageOccupancyStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCapacity = null,Object? currentOccupancy = null,Object? availableSpaces = null,Object? occupancyRate = null,Object? fullCages = null,Object? emptyCages = null,}) {
  return _then(_CageOccupancyStats(
totalCapacity: null == totalCapacity ? _self.totalCapacity : totalCapacity // ignore: cast_nullable_to_non_nullable
as int,currentOccupancy: null == currentOccupancy ? _self.currentOccupancy : currentOccupancy // ignore: cast_nullable_to_non_nullable
as int,availableSpaces: null == availableSpaces ? _self.availableSpaces : availableSpaces // ignore: cast_nullable_to_non_nullable
as int,occupancyRate: null == occupancyRate ? _self.occupancyRate : occupancyRate // ignore: cast_nullable_to_non_nullable
as int,fullCages: null == fullCages ? _self.fullCages : fullCages // ignore: cast_nullable_to_non_nullable
as int,emptyCages: null == emptyCages ? _self.emptyCages : emptyCages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
