// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Feed {

@IntConverter() int get id; String get name; FeedType get type; String? get brand;@JsonKey(defaultValue: FeedUnit.kg) FeedUnit get unit;@JsonKey(name: 'current_stock')@DoubleConverter() double get currentStock;@JsonKey(name: 'min_stock')@DoubleConverter() double get minStock;@JsonKey(name: 'cost_per_unit')@DoubleConverter() double? get costPerUnit; String? get notes;@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? get updatedAt;
/// Create a copy of Feed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedCopyWith<Feed> get copyWith => _$FeedCopyWithImpl<Feed>(this as Feed, _$identity);

  /// Serializes this Feed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Feed;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Feed&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.currentStock, _this.currentStock) || other.currentStock == _this.currentStock)&&(identical(other.minStock, _this.minStock) || other.minStock == _this.minStock)&&(identical(other.costPerUnit, _this.costPerUnit) || other.costPerUnit == _this.costPerUnit)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Feed;
  return Object.hash(runtimeType,_this.id,_this.name,_this.type,_this.brand,_this.unit,_this.currentStock,_this.minStock,_this.costPerUnit,_this.notes,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Feed;
  return 'Feed(id: ${_this.id}, name: ${_this.name}, type: ${_this.type}, brand: ${_this.brand}, unit: ${_this.unit}, currentStock: ${_this.currentStock}, minStock: ${_this.minStock}, costPerUnit: ${_this.costPerUnit}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $FeedCopyWith<$Res>  {
  factory $FeedCopyWith(Feed value, $Res Function(Feed) _then) = _$FeedCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String name, FeedType type, String? brand,@JsonKey(defaultValue: FeedUnit.kg) FeedUnit unit,@JsonKey(name: 'current_stock')@DoubleConverter() double currentStock,@JsonKey(name: 'min_stock')@DoubleConverter() double minStock,@JsonKey(name: 'cost_per_unit')@DoubleConverter() double? costPerUnit, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$FeedCopyWithImpl<$Res>
    implements $FeedCopyWith<$Res> {
  _$FeedCopyWithImpl(this._self, this._then);

  final Feed _self;
  final $Res Function(Feed) _then;

/// Create a copy of Feed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? brand = freezed,Object? unit = null,Object? currentStock = null,Object? minStock = null,Object? costPerUnit = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(Feed(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FeedType,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as FeedUnit,currentStock: null == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as double,minStock: null == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as double,costPerUnit: freezed == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Feed].
extension FeedPatterns on Feed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Feed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Feed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Feed value)  $default,){
final _that = this;
switch (_that) {
case _Feed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Feed value)?  $default,){
final _that = this;
switch (_that) {
case _Feed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name,  FeedType type,  String? brand, @JsonKey(defaultValue: FeedUnit.kg)  FeedUnit unit, @JsonKey(name: 'current_stock')@DoubleConverter()  double currentStock, @JsonKey(name: 'min_stock')@DoubleConverter()  double minStock, @JsonKey(name: 'cost_per_unit')@DoubleConverter()  double? costPerUnit,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Feed() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.brand,_that.unit,_that.currentStock,_that.minStock,_that.costPerUnit,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name,  FeedType type,  String? brand, @JsonKey(defaultValue: FeedUnit.kg)  FeedUnit unit, @JsonKey(name: 'current_stock')@DoubleConverter()  double currentStock, @JsonKey(name: 'min_stock')@DoubleConverter()  double minStock, @JsonKey(name: 'cost_per_unit')@DoubleConverter()  double? costPerUnit,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Feed():
return $default(_that.id,_that.name,_that.type,_that.brand,_that.unit,_that.currentStock,_that.minStock,_that.costPerUnit,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String name,  FeedType type,  String? brand, @JsonKey(defaultValue: FeedUnit.kg)  FeedUnit unit, @JsonKey(name: 'current_stock')@DoubleConverter()  double currentStock, @JsonKey(name: 'min_stock')@DoubleConverter()  double minStock, @JsonKey(name: 'cost_per_unit')@DoubleConverter()  double? costPerUnit,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Feed() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.brand,_that.unit,_that.currentStock,_that.minStock,_that.costPerUnit,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Feed implements Feed {
  const _Feed({@IntConverter() required this.id, required this.name, required this.type, this.brand, @JsonKey(defaultValue: FeedUnit.kg) required this.unit, @JsonKey(name: 'current_stock')@DoubleConverter() required this.currentStock, @JsonKey(name: 'min_stock')@DoubleConverter() required this.minStock, @JsonKey(name: 'cost_per_unit')@DoubleConverter() this.costPerUnit, this.notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter() this.updatedAt});
  factory _Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);

@override@IntConverter() final  int id;
@override final  String name;
@override final  FeedType type;
@override final  String? brand;
@override@JsonKey(defaultValue: FeedUnit.kg) final  FeedUnit unit;
@override@JsonKey(name: 'current_stock')@DoubleConverter() final  double currentStock;
@override@JsonKey(name: 'min_stock')@DoubleConverter() final  double minStock;
@override@JsonKey(name: 'cost_per_unit')@DoubleConverter() final  double? costPerUnit;
@override final  String? notes;
@override@JsonKey(name: 'created_at')@NullableDateTimeConverter() final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at')@NullableDateTimeConverter() final  DateTime? updatedAt;

/// Create a copy of Feed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedCopyWith<_Feed> get copyWith => __$FeedCopyWithImpl<_Feed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Feed&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.costPerUnit, costPerUnit) || other.costPerUnit == costPerUnit)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,type,brand,unit,currentStock,minStock,costPerUnit,notes,createdAt,updatedAt);
}

@override
String toString() {
    return 'Feed(id: $id, name: $name, type: $type, brand: $brand, unit: $unit, currentStock: $currentStock, minStock: $minStock, costPerUnit: $costPerUnit, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FeedCopyWith<$Res> implements $FeedCopyWith<$Res> {
  factory _$FeedCopyWith(_Feed value, $Res Function(_Feed) _then) = __$FeedCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String name, FeedType type, String? brand,@JsonKey(defaultValue: FeedUnit.kg) FeedUnit unit,@JsonKey(name: 'current_stock')@DoubleConverter() double currentStock,@JsonKey(name: 'min_stock')@DoubleConverter() double minStock,@JsonKey(name: 'cost_per_unit')@DoubleConverter() double? costPerUnit, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$FeedCopyWithImpl<$Res>
    implements _$FeedCopyWith<$Res> {
  __$FeedCopyWithImpl(this._self, this._then);

  final _Feed _self;
  final $Res Function(_Feed) _then;

/// Create a copy of Feed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? brand = freezed,Object? unit = null,Object? currentStock = null,Object? minStock = null,Object? costPerUnit = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Feed(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FeedType,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as FeedUnit,currentStock: null == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as double,minStock: null == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as double,costPerUnit: freezed == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$FeedCreate {

 String get name; String get type; String? get brand;@JsonKey(defaultValue: 'kg') String? get unit;@JsonKey(name: 'current_stock') double? get currentStock;@JsonKey(name: 'min_stock') double? get minStock;@JsonKey(name: 'cost_per_unit') double? get costPerUnit; String? get notes;
/// Create a copy of FeedCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedCreateCopyWith<FeedCreate> get copyWith => _$FeedCreateCopyWithImpl<FeedCreate>(this as FeedCreate, _$identity);

  /// Serializes this FeedCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedCreate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedCreate&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.currentStock, _this.currentStock) || other.currentStock == _this.currentStock)&&(identical(other.minStock, _this.minStock) || other.minStock == _this.minStock)&&(identical(other.costPerUnit, _this.costPerUnit) || other.costPerUnit == _this.costPerUnit)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedCreate;
  return Object.hash(runtimeType,_this.name,_this.type,_this.brand,_this.unit,_this.currentStock,_this.minStock,_this.costPerUnit,_this.notes);
}

@override
String toString() {
  final _this = this as FeedCreate;
  return 'FeedCreate(name: ${_this.name}, type: ${_this.type}, brand: ${_this.brand}, unit: ${_this.unit}, currentStock: ${_this.currentStock}, minStock: ${_this.minStock}, costPerUnit: ${_this.costPerUnit}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $FeedCreateCopyWith<$Res>  {
  factory $FeedCreateCopyWith(FeedCreate value, $Res Function(FeedCreate) _then) = _$FeedCreateCopyWithImpl;
@useResult
$Res call({
 String name, String type, String? brand,@JsonKey(defaultValue: 'kg') String? unit,@JsonKey(name: 'current_stock') double? currentStock,@JsonKey(name: 'min_stock') double? minStock,@JsonKey(name: 'cost_per_unit') double? costPerUnit, String? notes
});




}
/// @nodoc
class _$FeedCreateCopyWithImpl<$Res>
    implements $FeedCreateCopyWith<$Res> {
  _$FeedCreateCopyWithImpl(this._self, this._then);

  final FeedCreate _self;
  final $Res Function(FeedCreate) _then;

/// Create a copy of FeedCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? brand = freezed,Object? unit = freezed,Object? currentStock = freezed,Object? minStock = freezed,Object? costPerUnit = freezed,Object? notes = freezed,}) {
  return _then(FeedCreate(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as double?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as double?,costPerUnit: freezed == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedCreate].
extension FeedCreatePatterns on FeedCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedCreate value)  $default,){
final _that = this;
switch (_that) {
case _FeedCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedCreate value)?  $default,){
final _that = this;
switch (_that) {
case _FeedCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String type,  String? brand, @JsonKey(defaultValue: 'kg')  String? unit, @JsonKey(name: 'current_stock')  double? currentStock, @JsonKey(name: 'min_stock')  double? minStock, @JsonKey(name: 'cost_per_unit')  double? costPerUnit,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedCreate() when $default != null:
return $default(_that.name,_that.type,_that.brand,_that.unit,_that.currentStock,_that.minStock,_that.costPerUnit,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String type,  String? brand, @JsonKey(defaultValue: 'kg')  String? unit, @JsonKey(name: 'current_stock')  double? currentStock, @JsonKey(name: 'min_stock')  double? minStock, @JsonKey(name: 'cost_per_unit')  double? costPerUnit,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _FeedCreate():
return $default(_that.name,_that.type,_that.brand,_that.unit,_that.currentStock,_that.minStock,_that.costPerUnit,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String type,  String? brand, @JsonKey(defaultValue: 'kg')  String? unit, @JsonKey(name: 'current_stock')  double? currentStock, @JsonKey(name: 'min_stock')  double? minStock, @JsonKey(name: 'cost_per_unit')  double? costPerUnit,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _FeedCreate() when $default != null:
return $default(_that.name,_that.type,_that.brand,_that.unit,_that.currentStock,_that.minStock,_that.costPerUnit,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedCreate implements FeedCreate {
  const _FeedCreate({required this.name, required this.type, this.brand, @JsonKey(defaultValue: 'kg') this.unit, @JsonKey(name: 'current_stock') this.currentStock, @JsonKey(name: 'min_stock') this.minStock, @JsonKey(name: 'cost_per_unit') this.costPerUnit, this.notes});
  factory _FeedCreate.fromJson(Map<String, dynamic> json) => _$FeedCreateFromJson(json);

@override final  String name;
@override final  String type;
@override final  String? brand;
@override@JsonKey(defaultValue: 'kg') final  String? unit;
@override@JsonKey(name: 'current_stock') final  double? currentStock;
@override@JsonKey(name: 'min_stock') final  double? minStock;
@override@JsonKey(name: 'cost_per_unit') final  double? costPerUnit;
@override final  String? notes;

/// Create a copy of FeedCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedCreateCopyWith<_FeedCreate> get copyWith => __$FeedCreateCopyWithImpl<_FeedCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedCreateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedCreate&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.costPerUnit, costPerUnit) || other.costPerUnit == costPerUnit)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,type,brand,unit,currentStock,minStock,costPerUnit,notes);
}

@override
String toString() {
    return 'FeedCreate(name: $name, type: $type, brand: $brand, unit: $unit, currentStock: $currentStock, minStock: $minStock, costPerUnit: $costPerUnit, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$FeedCreateCopyWith<$Res> implements $FeedCreateCopyWith<$Res> {
  factory _$FeedCreateCopyWith(_FeedCreate value, $Res Function(_FeedCreate) _then) = __$FeedCreateCopyWithImpl;
@override @useResult
$Res call({
 String name, String type, String? brand,@JsonKey(defaultValue: 'kg') String? unit,@JsonKey(name: 'current_stock') double? currentStock,@JsonKey(name: 'min_stock') double? minStock,@JsonKey(name: 'cost_per_unit') double? costPerUnit, String? notes
});




}
/// @nodoc
class __$FeedCreateCopyWithImpl<$Res>
    implements _$FeedCreateCopyWith<$Res> {
  __$FeedCreateCopyWithImpl(this._self, this._then);

  final _FeedCreate _self;
  final $Res Function(_FeedCreate) _then;

/// Create a copy of FeedCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? brand = freezed,Object? unit = freezed,Object? currentStock = freezed,Object? minStock = freezed,Object? costPerUnit = freezed,Object? notes = freezed,}) {
  return _then(_FeedCreate(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as double?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as double?,costPerUnit: freezed == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FeedUpdate {

 String? get name; String? get type; String? get brand; String? get unit;@JsonKey(name: 'current_stock') double? get currentStock;@JsonKey(name: 'min_stock') double? get minStock;@JsonKey(name: 'cost_per_unit') double? get costPerUnit; String? get notes;
/// Create a copy of FeedUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedUpdateCopyWith<FeedUpdate> get copyWith => _$FeedUpdateCopyWithImpl<FeedUpdate>(this as FeedUpdate, _$identity);

  /// Serializes this FeedUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedUpdate&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.currentStock, _this.currentStock) || other.currentStock == _this.currentStock)&&(identical(other.minStock, _this.minStock) || other.minStock == _this.minStock)&&(identical(other.costPerUnit, _this.costPerUnit) || other.costPerUnit == _this.costPerUnit)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedUpdate;
  return Object.hash(runtimeType,_this.name,_this.type,_this.brand,_this.unit,_this.currentStock,_this.minStock,_this.costPerUnit,_this.notes);
}

@override
String toString() {
  final _this = this as FeedUpdate;
  return 'FeedUpdate(name: ${_this.name}, type: ${_this.type}, brand: ${_this.brand}, unit: ${_this.unit}, currentStock: ${_this.currentStock}, minStock: ${_this.minStock}, costPerUnit: ${_this.costPerUnit}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $FeedUpdateCopyWith<$Res>  {
  factory $FeedUpdateCopyWith(FeedUpdate value, $Res Function(FeedUpdate) _then) = _$FeedUpdateCopyWithImpl;
@useResult
$Res call({
 String? name, String? type, String? brand, String? unit,@JsonKey(name: 'current_stock') double? currentStock,@JsonKey(name: 'min_stock') double? minStock,@JsonKey(name: 'cost_per_unit') double? costPerUnit, String? notes
});




}
/// @nodoc
class _$FeedUpdateCopyWithImpl<$Res>
    implements $FeedUpdateCopyWith<$Res> {
  _$FeedUpdateCopyWithImpl(this._self, this._then);

  final FeedUpdate _self;
  final $Res Function(FeedUpdate) _then;

/// Create a copy of FeedUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? type = freezed,Object? brand = freezed,Object? unit = freezed,Object? currentStock = freezed,Object? minStock = freezed,Object? costPerUnit = freezed,Object? notes = freezed,}) {
  return _then(FeedUpdate(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as double?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as double?,costPerUnit: freezed == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedUpdate].
extension FeedUpdatePatterns on FeedUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedUpdate value)  $default,){
final _that = this;
switch (_that) {
case _FeedUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _FeedUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? type,  String? brand,  String? unit, @JsonKey(name: 'current_stock')  double? currentStock, @JsonKey(name: 'min_stock')  double? minStock, @JsonKey(name: 'cost_per_unit')  double? costPerUnit,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedUpdate() when $default != null:
return $default(_that.name,_that.type,_that.brand,_that.unit,_that.currentStock,_that.minStock,_that.costPerUnit,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? type,  String? brand,  String? unit, @JsonKey(name: 'current_stock')  double? currentStock, @JsonKey(name: 'min_stock')  double? minStock, @JsonKey(name: 'cost_per_unit')  double? costPerUnit,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _FeedUpdate():
return $default(_that.name,_that.type,_that.brand,_that.unit,_that.currentStock,_that.minStock,_that.costPerUnit,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? type,  String? brand,  String? unit, @JsonKey(name: 'current_stock')  double? currentStock, @JsonKey(name: 'min_stock')  double? minStock, @JsonKey(name: 'cost_per_unit')  double? costPerUnit,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _FeedUpdate() when $default != null:
return $default(_that.name,_that.type,_that.brand,_that.unit,_that.currentStock,_that.minStock,_that.costPerUnit,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedUpdate implements FeedUpdate {
  const _FeedUpdate({this.name, this.type, this.brand, this.unit, @JsonKey(name: 'current_stock') this.currentStock, @JsonKey(name: 'min_stock') this.minStock, @JsonKey(name: 'cost_per_unit') this.costPerUnit, this.notes});
  factory _FeedUpdate.fromJson(Map<String, dynamic> json) => _$FeedUpdateFromJson(json);

@override final  String? name;
@override final  String? type;
@override final  String? brand;
@override final  String? unit;
@override@JsonKey(name: 'current_stock') final  double? currentStock;
@override@JsonKey(name: 'min_stock') final  double? minStock;
@override@JsonKey(name: 'cost_per_unit') final  double? costPerUnit;
@override final  String? notes;

/// Create a copy of FeedUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedUpdateCopyWith<_FeedUpdate> get copyWith => __$FeedUpdateCopyWithImpl<_FeedUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedUpdate&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.costPerUnit, costPerUnit) || other.costPerUnit == costPerUnit)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,type,brand,unit,currentStock,minStock,costPerUnit,notes);
}

@override
String toString() {
    return 'FeedUpdate(name: $name, type: $type, brand: $brand, unit: $unit, currentStock: $currentStock, minStock: $minStock, costPerUnit: $costPerUnit, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$FeedUpdateCopyWith<$Res> implements $FeedUpdateCopyWith<$Res> {
  factory _$FeedUpdateCopyWith(_FeedUpdate value, $Res Function(_FeedUpdate) _then) = __$FeedUpdateCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? type, String? brand, String? unit,@JsonKey(name: 'current_stock') double? currentStock,@JsonKey(name: 'min_stock') double? minStock,@JsonKey(name: 'cost_per_unit') double? costPerUnit, String? notes
});




}
/// @nodoc
class __$FeedUpdateCopyWithImpl<$Res>
    implements _$FeedUpdateCopyWith<$Res> {
  __$FeedUpdateCopyWithImpl(this._self, this._then);

  final _FeedUpdate _self;
  final $Res Function(_FeedUpdate) _then;

/// Create a copy of FeedUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? type = freezed,Object? brand = freezed,Object? unit = freezed,Object? currentStock = freezed,Object? minStock = freezed,Object? costPerUnit = freezed,Object? notes = freezed,}) {
  return _then(_FeedUpdate(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as double?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as double?,costPerUnit: freezed == costPerUnit ? _self.costPerUnit : costPerUnit // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StockAdjustment {

 double get quantity; String get operation;
/// Create a copy of StockAdjustment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockAdjustmentCopyWith<StockAdjustment> get copyWith => _$StockAdjustmentCopyWithImpl<StockAdjustment>(this as StockAdjustment, _$identity);

  /// Serializes this StockAdjustment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockAdjustment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockAdjustment&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.operation, _this.operation) || other.operation == _this.operation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockAdjustment;
  return Object.hash(runtimeType,_this.quantity,_this.operation);
}

@override
String toString() {
  final _this = this as StockAdjustment;
  return 'StockAdjustment(quantity: ${_this.quantity}, operation: ${_this.operation})';
}


}

/// @nodoc
abstract mixin class $StockAdjustmentCopyWith<$Res>  {
  factory $StockAdjustmentCopyWith(StockAdjustment value, $Res Function(StockAdjustment) _then) = _$StockAdjustmentCopyWithImpl;
@useResult
$Res call({
 double quantity, String operation
});




}
/// @nodoc
class _$StockAdjustmentCopyWithImpl<$Res>
    implements $StockAdjustmentCopyWith<$Res> {
  _$StockAdjustmentCopyWithImpl(this._self, this._then);

  final StockAdjustment _self;
  final $Res Function(StockAdjustment) _then;

/// Create a copy of StockAdjustment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quantity = null,Object? operation = null,}) {
  return _then(StockAdjustment(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StockAdjustment].
extension StockAdjustmentPatterns on StockAdjustment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockAdjustment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockAdjustment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockAdjustment value)  $default,){
final _that = this;
switch (_that) {
case _StockAdjustment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockAdjustment value)?  $default,){
final _that = this;
switch (_that) {
case _StockAdjustment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double quantity,  String operation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockAdjustment() when $default != null:
return $default(_that.quantity,_that.operation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double quantity,  String operation)  $default,) {final _that = this;
switch (_that) {
case _StockAdjustment():
return $default(_that.quantity,_that.operation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double quantity,  String operation)?  $default,) {final _that = this;
switch (_that) {
case _StockAdjustment() when $default != null:
return $default(_that.quantity,_that.operation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockAdjustment implements StockAdjustment {
  const _StockAdjustment({required this.quantity, required this.operation});
  factory _StockAdjustment.fromJson(Map<String, dynamic> json) => _$StockAdjustmentFromJson(json);

@override final  double quantity;
@override final  String operation;

/// Create a copy of StockAdjustment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockAdjustmentCopyWith<_StockAdjustment> get copyWith => __$StockAdjustmentCopyWithImpl<_StockAdjustment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockAdjustmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockAdjustment&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.operation, operation) || other.operation == operation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,quantity,operation);
}

@override
String toString() {
    return 'StockAdjustment(quantity: $quantity, operation: $operation)';
}


}

/// @nodoc
abstract mixin class _$StockAdjustmentCopyWith<$Res> implements $StockAdjustmentCopyWith<$Res> {
  factory _$StockAdjustmentCopyWith(_StockAdjustment value, $Res Function(_StockAdjustment) _then) = __$StockAdjustmentCopyWithImpl;
@override @useResult
$Res call({
 double quantity, String operation
});




}
/// @nodoc
class __$StockAdjustmentCopyWithImpl<$Res>
    implements _$StockAdjustmentCopyWith<$Res> {
  __$StockAdjustmentCopyWithImpl(this._self, this._then);

  final _StockAdjustment _self;
  final $Res Function(_StockAdjustment) _then;

/// Create a copy of StockAdjustment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quantity = null,Object? operation = null,}) {
  return _then(_StockAdjustment(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FeedStatistics {

@JsonKey(name: 'total_feeds') int get totalFeeds;@JsonKey(name: 'by_type') FeedTypeStats get byType;@JsonKey(name: 'low_stock_count') int get lowStockCount;@JsonKey(name: 'low_stock_items') List<LowStockItem> get lowStockItems;@JsonKey(name: 'total_stock_value') double get totalStockValue;
/// Create a copy of FeedStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedStatisticsCopyWith<FeedStatistics> get copyWith => _$FeedStatisticsCopyWithImpl<FeedStatistics>(this as FeedStatistics, _$identity);

  /// Serializes this FeedStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedStatistics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedStatistics&&(identical(other.totalFeeds, _this.totalFeeds) || other.totalFeeds == _this.totalFeeds)&&(identical(other.byType, _this.byType) || other.byType == _this.byType)&&(identical(other.lowStockCount, _this.lowStockCount) || other.lowStockCount == _this.lowStockCount)&&const DeepCollectionEquality().equals(other.lowStockItems, _this.lowStockItems)&&(identical(other.totalStockValue, _this.totalStockValue) || other.totalStockValue == _this.totalStockValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedStatistics;
  return Object.hash(runtimeType,_this.totalFeeds,_this.byType,_this.lowStockCount,const DeepCollectionEquality().hash(_this.lowStockItems),_this.totalStockValue);
}

@override
String toString() {
  final _this = this as FeedStatistics;
  return 'FeedStatistics(totalFeeds: ${_this.totalFeeds}, byType: ${_this.byType}, lowStockCount: ${_this.lowStockCount}, lowStockItems: ${_this.lowStockItems}, totalStockValue: ${_this.totalStockValue})';
}


}

/// @nodoc
abstract mixin class $FeedStatisticsCopyWith<$Res>  {
  factory $FeedStatisticsCopyWith(FeedStatistics value, $Res Function(FeedStatistics) _then) = _$FeedStatisticsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_feeds') int totalFeeds,@JsonKey(name: 'by_type') FeedTypeStats byType,@JsonKey(name: 'low_stock_count') int lowStockCount,@JsonKey(name: 'low_stock_items') List<LowStockItem> lowStockItems,@JsonKey(name: 'total_stock_value') double totalStockValue
});


$FeedTypeStatsCopyWith<$Res> get byType;

}
/// @nodoc
class _$FeedStatisticsCopyWithImpl<$Res>
    implements $FeedStatisticsCopyWith<$Res> {
  _$FeedStatisticsCopyWithImpl(this._self, this._then);

  final FeedStatistics _self;
  final $Res Function(FeedStatistics) _then;

/// Create a copy of FeedStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalFeeds = null,Object? byType = null,Object? lowStockCount = null,Object? lowStockItems = null,Object? totalStockValue = null,}) {
  return _then(FeedStatistics(
totalFeeds: null == totalFeeds ? _self.totalFeeds : totalFeeds // ignore: cast_nullable_to_non_nullable
as int,byType: null == byType ? _self.byType : byType // ignore: cast_nullable_to_non_nullable
as FeedTypeStats,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,lowStockItems: null == lowStockItems ? _self.lowStockItems : lowStockItems // ignore: cast_nullable_to_non_nullable
as List<LowStockItem>,totalStockValue: null == totalStockValue ? _self.totalStockValue : totalStockValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of FeedStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedTypeStatsCopyWith<$Res> get byType {
  
  return $FeedTypeStatsCopyWith<$Res>(_self.byType, (value) {
    return _then(_self.copyWith(byType: value));
  });
}
}


/// Adds pattern-matching-related methods to [FeedStatistics].
extension FeedStatisticsPatterns on FeedStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedStatistics value)  $default,){
final _that = this;
switch (_that) {
case _FeedStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _FeedStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_feeds')  int totalFeeds, @JsonKey(name: 'by_type')  FeedTypeStats byType, @JsonKey(name: 'low_stock_count')  int lowStockCount, @JsonKey(name: 'low_stock_items')  List<LowStockItem> lowStockItems, @JsonKey(name: 'total_stock_value')  double totalStockValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedStatistics() when $default != null:
return $default(_that.totalFeeds,_that.byType,_that.lowStockCount,_that.lowStockItems,_that.totalStockValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_feeds')  int totalFeeds, @JsonKey(name: 'by_type')  FeedTypeStats byType, @JsonKey(name: 'low_stock_count')  int lowStockCount, @JsonKey(name: 'low_stock_items')  List<LowStockItem> lowStockItems, @JsonKey(name: 'total_stock_value')  double totalStockValue)  $default,) {final _that = this;
switch (_that) {
case _FeedStatistics():
return $default(_that.totalFeeds,_that.byType,_that.lowStockCount,_that.lowStockItems,_that.totalStockValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_feeds')  int totalFeeds, @JsonKey(name: 'by_type')  FeedTypeStats byType, @JsonKey(name: 'low_stock_count')  int lowStockCount, @JsonKey(name: 'low_stock_items')  List<LowStockItem> lowStockItems, @JsonKey(name: 'total_stock_value')  double totalStockValue)?  $default,) {final _that = this;
switch (_that) {
case _FeedStatistics() when $default != null:
return $default(_that.totalFeeds,_that.byType,_that.lowStockCount,_that.lowStockItems,_that.totalStockValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedStatistics implements FeedStatistics {
  const _FeedStatistics({@JsonKey(name: 'total_feeds') required this.totalFeeds, @JsonKey(name: 'by_type') required this.byType, @JsonKey(name: 'low_stock_count') required this.lowStockCount, @JsonKey(name: 'low_stock_items') required  List<LowStockItem> lowStockItems, @JsonKey(name: 'total_stock_value') required this.totalStockValue}): _lowStockItems = lowStockItems;
  factory _FeedStatistics.fromJson(Map<String, dynamic> json) => _$FeedStatisticsFromJson(json);

@override@JsonKey(name: 'total_feeds') final  int totalFeeds;
@override@JsonKey(name: 'by_type') final  FeedTypeStats byType;
@override@JsonKey(name: 'low_stock_count') final  int lowStockCount;
 final  List<LowStockItem> _lowStockItems;
@override@JsonKey(name: 'low_stock_items') List<LowStockItem> get lowStockItems {
  if (_lowStockItems is EqualUnmodifiableListView) return _lowStockItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lowStockItems);
}

@override@JsonKey(name: 'total_stock_value') final  double totalStockValue;

/// Create a copy of FeedStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedStatisticsCopyWith<_FeedStatistics> get copyWith => __$FeedStatisticsCopyWithImpl<_FeedStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedStatistics&&(identical(other.totalFeeds, totalFeeds) || other.totalFeeds == totalFeeds)&&(identical(other.byType, byType) || other.byType == byType)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount)&&const DeepCollectionEquality().equals(other.lowStockItems, _lowStockItems)&&(identical(other.totalStockValue, totalStockValue) || other.totalStockValue == totalStockValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalFeeds,byType,lowStockCount,const DeepCollectionEquality().hash(_lowStockItems),totalStockValue);
}

@override
String toString() {
    return 'FeedStatistics(totalFeeds: $totalFeeds, byType: $byType, lowStockCount: $lowStockCount, lowStockItems: $lowStockItems, totalStockValue: $totalStockValue)';
}


}

/// @nodoc
abstract mixin class _$FeedStatisticsCopyWith<$Res> implements $FeedStatisticsCopyWith<$Res> {
  factory _$FeedStatisticsCopyWith(_FeedStatistics value, $Res Function(_FeedStatistics) _then) = __$FeedStatisticsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_feeds') int totalFeeds,@JsonKey(name: 'by_type') FeedTypeStats byType,@JsonKey(name: 'low_stock_count') int lowStockCount,@JsonKey(name: 'low_stock_items') List<LowStockItem> lowStockItems,@JsonKey(name: 'total_stock_value') double totalStockValue
});


@override $FeedTypeStatsCopyWith<$Res> get byType;

}
/// @nodoc
class __$FeedStatisticsCopyWithImpl<$Res>
    implements _$FeedStatisticsCopyWith<$Res> {
  __$FeedStatisticsCopyWithImpl(this._self, this._then);

  final _FeedStatistics _self;
  final $Res Function(_FeedStatistics) _then;

/// Create a copy of FeedStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalFeeds = null,Object? byType = null,Object? lowStockCount = null,Object? lowStockItems = null,Object? totalStockValue = null,}) {
  return _then(_FeedStatistics(
totalFeeds: null == totalFeeds ? _self.totalFeeds : totalFeeds // ignore: cast_nullable_to_non_nullable
as int,byType: null == byType ? _self.byType : byType // ignore: cast_nullable_to_non_nullable
as FeedTypeStats,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,lowStockItems: null == lowStockItems ? _self._lowStockItems : lowStockItems // ignore: cast_nullable_to_non_nullable
as List<LowStockItem>,totalStockValue: null == totalStockValue ? _self.totalStockValue : totalStockValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of FeedStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedTypeStatsCopyWith<$Res> get byType {
  
  return $FeedTypeStatsCopyWith<$Res>(_self.byType, (value) {
    return _then(_self.copyWith(byType: value));
  });
}
}


/// @nodoc
mixin _$FeedTypeStats {

@JsonKey(defaultValue: 0) int get pellets;@JsonKey(defaultValue: 0) int get hay;@JsonKey(defaultValue: 0) int get vegetables;@JsonKey(defaultValue: 0) int get grain;@JsonKey(defaultValue: 0) int get supplements;@JsonKey(defaultValue: 0) int get other;
/// Create a copy of FeedTypeStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedTypeStatsCopyWith<FeedTypeStats> get copyWith => _$FeedTypeStatsCopyWithImpl<FeedTypeStats>(this as FeedTypeStats, _$identity);

  /// Serializes this FeedTypeStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedTypeStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedTypeStats&&(identical(other.pellets, _this.pellets) || other.pellets == _this.pellets)&&(identical(other.hay, _this.hay) || other.hay == _this.hay)&&(identical(other.vegetables, _this.vegetables) || other.vegetables == _this.vegetables)&&(identical(other.grain, _this.grain) || other.grain == _this.grain)&&(identical(other.supplements, _this.supplements) || other.supplements == _this.supplements)&&(identical(other.other, _this.other) || other.other == _this.other));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedTypeStats;
  return Object.hash(runtimeType,_this.pellets,_this.hay,_this.vegetables,_this.grain,_this.supplements,_this.other);
}

@override
String toString() {
  final _this = this as FeedTypeStats;
  return 'FeedTypeStats(pellets: ${_this.pellets}, hay: ${_this.hay}, vegetables: ${_this.vegetables}, grain: ${_this.grain}, supplements: ${_this.supplements}, other: ${_this.other})';
}


}

/// @nodoc
abstract mixin class $FeedTypeStatsCopyWith<$Res>  {
  factory $FeedTypeStatsCopyWith(FeedTypeStats value, $Res Function(FeedTypeStats) _then) = _$FeedTypeStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: 0) int pellets,@JsonKey(defaultValue: 0) int hay,@JsonKey(defaultValue: 0) int vegetables,@JsonKey(defaultValue: 0) int grain,@JsonKey(defaultValue: 0) int supplements,@JsonKey(defaultValue: 0) int other
});




}
/// @nodoc
class _$FeedTypeStatsCopyWithImpl<$Res>
    implements $FeedTypeStatsCopyWith<$Res> {
  _$FeedTypeStatsCopyWithImpl(this._self, this._then);

  final FeedTypeStats _self;
  final $Res Function(FeedTypeStats) _then;

/// Create a copy of FeedTypeStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pellets = null,Object? hay = null,Object? vegetables = null,Object? grain = null,Object? supplements = null,Object? other = null,}) {
  return _then(FeedTypeStats(
pellets: null == pellets ? _self.pellets : pellets // ignore: cast_nullable_to_non_nullable
as int,hay: null == hay ? _self.hay : hay // ignore: cast_nullable_to_non_nullable
as int,vegetables: null == vegetables ? _self.vegetables : vegetables // ignore: cast_nullable_to_non_nullable
as int,grain: null == grain ? _self.grain : grain // ignore: cast_nullable_to_non_nullable
as int,supplements: null == supplements ? _self.supplements : supplements // ignore: cast_nullable_to_non_nullable
as int,other: null == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedTypeStats].
extension FeedTypeStatsPatterns on FeedTypeStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedTypeStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedTypeStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedTypeStats value)  $default,){
final _that = this;
switch (_that) {
case _FeedTypeStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedTypeStats value)?  $default,){
final _that = this;
switch (_that) {
case _FeedTypeStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: 0)  int pellets, @JsonKey(defaultValue: 0)  int hay, @JsonKey(defaultValue: 0)  int vegetables, @JsonKey(defaultValue: 0)  int grain, @JsonKey(defaultValue: 0)  int supplements, @JsonKey(defaultValue: 0)  int other)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedTypeStats() when $default != null:
return $default(_that.pellets,_that.hay,_that.vegetables,_that.grain,_that.supplements,_that.other);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: 0)  int pellets, @JsonKey(defaultValue: 0)  int hay, @JsonKey(defaultValue: 0)  int vegetables, @JsonKey(defaultValue: 0)  int grain, @JsonKey(defaultValue: 0)  int supplements, @JsonKey(defaultValue: 0)  int other)  $default,) {final _that = this;
switch (_that) {
case _FeedTypeStats():
return $default(_that.pellets,_that.hay,_that.vegetables,_that.grain,_that.supplements,_that.other);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: 0)  int pellets, @JsonKey(defaultValue: 0)  int hay, @JsonKey(defaultValue: 0)  int vegetables, @JsonKey(defaultValue: 0)  int grain, @JsonKey(defaultValue: 0)  int supplements, @JsonKey(defaultValue: 0)  int other)?  $default,) {final _that = this;
switch (_that) {
case _FeedTypeStats() when $default != null:
return $default(_that.pellets,_that.hay,_that.vegetables,_that.grain,_that.supplements,_that.other);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedTypeStats implements FeedTypeStats {
  const _FeedTypeStats({@JsonKey(defaultValue: 0) required this.pellets, @JsonKey(defaultValue: 0) required this.hay, @JsonKey(defaultValue: 0) required this.vegetables, @JsonKey(defaultValue: 0) required this.grain, @JsonKey(defaultValue: 0) required this.supplements, @JsonKey(defaultValue: 0) required this.other});
  factory _FeedTypeStats.fromJson(Map<String, dynamic> json) => _$FeedTypeStatsFromJson(json);

@override@JsonKey(defaultValue: 0) final  int pellets;
@override@JsonKey(defaultValue: 0) final  int hay;
@override@JsonKey(defaultValue: 0) final  int vegetables;
@override@JsonKey(defaultValue: 0) final  int grain;
@override@JsonKey(defaultValue: 0) final  int supplements;
@override@JsonKey(defaultValue: 0) final  int other;

/// Create a copy of FeedTypeStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedTypeStatsCopyWith<_FeedTypeStats> get copyWith => __$FeedTypeStatsCopyWithImpl<_FeedTypeStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedTypeStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedTypeStats&&(identical(other.pellets, pellets) || other.pellets == pellets)&&(identical(other.hay, hay) || other.hay == hay)&&(identical(other.vegetables, vegetables) || other.vegetables == vegetables)&&(identical(other.grain, grain) || other.grain == grain)&&(identical(other.supplements, supplements) || other.supplements == supplements)&&(identical(other.other, this.other) || other.other == this.other));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,pellets,hay,vegetables,grain,supplements,other);
}

@override
String toString() {
    return 'FeedTypeStats(pellets: $pellets, hay: $hay, vegetables: $vegetables, grain: $grain, supplements: $supplements, other: $other)';
}


}

/// @nodoc
abstract mixin class _$FeedTypeStatsCopyWith<$Res> implements $FeedTypeStatsCopyWith<$Res> {
  factory _$FeedTypeStatsCopyWith(_FeedTypeStats value, $Res Function(_FeedTypeStats) _then) = __$FeedTypeStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: 0) int pellets,@JsonKey(defaultValue: 0) int hay,@JsonKey(defaultValue: 0) int vegetables,@JsonKey(defaultValue: 0) int grain,@JsonKey(defaultValue: 0) int supplements,@JsonKey(defaultValue: 0) int other
});




}
/// @nodoc
class __$FeedTypeStatsCopyWithImpl<$Res>
    implements _$FeedTypeStatsCopyWith<$Res> {
  __$FeedTypeStatsCopyWithImpl(this._self, this._then);

  final _FeedTypeStats _self;
  final $Res Function(_FeedTypeStats) _then;

/// Create a copy of FeedTypeStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pellets = null,Object? hay = null,Object? vegetables = null,Object? grain = null,Object? supplements = null,Object? other = null,}) {
  return _then(_FeedTypeStats(
pellets: null == pellets ? _self.pellets : pellets // ignore: cast_nullable_to_non_nullable
as int,hay: null == hay ? _self.hay : hay // ignore: cast_nullable_to_non_nullable
as int,vegetables: null == vegetables ? _self.vegetables : vegetables // ignore: cast_nullable_to_non_nullable
as int,grain: null == grain ? _self.grain : grain // ignore: cast_nullable_to_non_nullable
as int,supplements: null == supplements ? _self.supplements : supplements // ignore: cast_nullable_to_non_nullable
as int,other: null == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LowStockItem {

@IntConverter() int get id; String get name;@JsonKey(name: 'current_stock')@DoubleConverter() double get currentStock;@JsonKey(name: 'min_stock')@DoubleConverter() double get minStock; String get unit;
/// Create a copy of LowStockItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LowStockItemCopyWith<LowStockItem> get copyWith => _$LowStockItemCopyWithImpl<LowStockItem>(this as LowStockItem, _$identity);

  /// Serializes this LowStockItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LowStockItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LowStockItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.currentStock, _this.currentStock) || other.currentStock == _this.currentStock)&&(identical(other.minStock, _this.minStock) || other.minStock == _this.minStock)&&(identical(other.unit, _this.unit) || other.unit == _this.unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LowStockItem;
  return Object.hash(runtimeType,_this.id,_this.name,_this.currentStock,_this.minStock,_this.unit);
}

@override
String toString() {
  final _this = this as LowStockItem;
  return 'LowStockItem(id: ${_this.id}, name: ${_this.name}, currentStock: ${_this.currentStock}, minStock: ${_this.minStock}, unit: ${_this.unit})';
}


}

/// @nodoc
abstract mixin class $LowStockItemCopyWith<$Res>  {
  factory $LowStockItemCopyWith(LowStockItem value, $Res Function(LowStockItem) _then) = _$LowStockItemCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String name,@JsonKey(name: 'current_stock')@DoubleConverter() double currentStock,@JsonKey(name: 'min_stock')@DoubleConverter() double minStock, String unit
});




}
/// @nodoc
class _$LowStockItemCopyWithImpl<$Res>
    implements $LowStockItemCopyWith<$Res> {
  _$LowStockItemCopyWithImpl(this._self, this._then);

  final LowStockItem _self;
  final $Res Function(LowStockItem) _then;

/// Create a copy of LowStockItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? currentStock = null,Object? minStock = null,Object? unit = null,}) {
  return _then(LowStockItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currentStock: null == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as double,minStock: null == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LowStockItem].
extension LowStockItemPatterns on LowStockItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LowStockItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LowStockItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LowStockItem value)  $default,){
final _that = this;
switch (_that) {
case _LowStockItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LowStockItem value)?  $default,){
final _that = this;
switch (_that) {
case _LowStockItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name, @JsonKey(name: 'current_stock')@DoubleConverter()  double currentStock, @JsonKey(name: 'min_stock')@DoubleConverter()  double minStock,  String unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LowStockItem() when $default != null:
return $default(_that.id,_that.name,_that.currentStock,_that.minStock,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name, @JsonKey(name: 'current_stock')@DoubleConverter()  double currentStock, @JsonKey(name: 'min_stock')@DoubleConverter()  double minStock,  String unit)  $default,) {final _that = this;
switch (_that) {
case _LowStockItem():
return $default(_that.id,_that.name,_that.currentStock,_that.minStock,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String name, @JsonKey(name: 'current_stock')@DoubleConverter()  double currentStock, @JsonKey(name: 'min_stock')@DoubleConverter()  double minStock,  String unit)?  $default,) {final _that = this;
switch (_that) {
case _LowStockItem() when $default != null:
return $default(_that.id,_that.name,_that.currentStock,_that.minStock,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LowStockItem implements LowStockItem {
  const _LowStockItem({@IntConverter() required this.id, required this.name, @JsonKey(name: 'current_stock')@DoubleConverter() required this.currentStock, @JsonKey(name: 'min_stock')@DoubleConverter() required this.minStock, required this.unit});
  factory _LowStockItem.fromJson(Map<String, dynamic> json) => _$LowStockItemFromJson(json);

@override@IntConverter() final  int id;
@override final  String name;
@override@JsonKey(name: 'current_stock')@DoubleConverter() final  double currentStock;
@override@JsonKey(name: 'min_stock')@DoubleConverter() final  double minStock;
@override final  String unit;

/// Create a copy of LowStockItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LowStockItemCopyWith<_LowStockItem> get copyWith => __$LowStockItemCopyWithImpl<_LowStockItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LowStockItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LowStockItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,currentStock,minStock,unit);
}

@override
String toString() {
    return 'LowStockItem(id: $id, name: $name, currentStock: $currentStock, minStock: $minStock, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$LowStockItemCopyWith<$Res> implements $LowStockItemCopyWith<$Res> {
  factory _$LowStockItemCopyWith(_LowStockItem value, $Res Function(_LowStockItem) _then) = __$LowStockItemCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String name,@JsonKey(name: 'current_stock')@DoubleConverter() double currentStock,@JsonKey(name: 'min_stock')@DoubleConverter() double minStock, String unit
});




}
/// @nodoc
class __$LowStockItemCopyWithImpl<$Res>
    implements _$LowStockItemCopyWith<$Res> {
  __$LowStockItemCopyWithImpl(this._self, this._then);

  final _LowStockItem _self;
  final $Res Function(_LowStockItem) _then;

/// Create a copy of LowStockItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? currentStock = null,Object? minStock = null,Object? unit = null,}) {
  return _then(_LowStockItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currentStock: null == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as double,minStock: null == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
