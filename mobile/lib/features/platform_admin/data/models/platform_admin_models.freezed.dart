// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_admin_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Plan {

@IntConverter() int get id; String get name;@JsonKey(name: 'max_rabbits')@NullableIntConverter() int? get maxRabbits;@JsonKey(name: 'max_staff')@NullableIntConverter() int? get maxStaff;@DoubleConverter() double? get price;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'is_default') bool get isDefault;
/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanCopyWith<Plan> get copyWith => _$PlanCopyWithImpl<Plan>(this as Plan, _$identity);

  /// Serializes this Plan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Plan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Plan&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.maxRabbits, _this.maxRabbits) || other.maxRabbits == _this.maxRabbits)&&(identical(other.maxStaff, _this.maxStaff) || other.maxStaff == _this.maxStaff)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Plan;
  return Object.hash(runtimeType,_this.id,_this.name,_this.maxRabbits,_this.maxStaff,_this.price,_this.isActive,_this.isDefault);
}

@override
String toString() {
  final _this = this as Plan;
  return 'Plan(id: ${_this.id}, name: ${_this.name}, maxRabbits: ${_this.maxRabbits}, maxStaff: ${_this.maxStaff}, price: ${_this.price}, isActive: ${_this.isActive}, isDefault: ${_this.isDefault})';
}


}

/// @nodoc
abstract mixin class $PlanCopyWith<$Res>  {
  factory $PlanCopyWith(Plan value, $Res Function(Plan) _then) = _$PlanCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String name,@JsonKey(name: 'max_rabbits')@NullableIntConverter() int? maxRabbits,@JsonKey(name: 'max_staff')@NullableIntConverter() int? maxStaff,@DoubleConverter() double? price,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_default') bool isDefault
});




}
/// @nodoc
class _$PlanCopyWithImpl<$Res>
    implements $PlanCopyWith<$Res> {
  _$PlanCopyWithImpl(this._self, this._then);

  final Plan _self;
  final $Res Function(Plan) _then;

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? maxRabbits = freezed,Object? maxStaff = freezed,Object? price = freezed,Object? isActive = null,Object? isDefault = null,}) {
  return _then(Plan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,maxRabbits: freezed == maxRabbits ? _self.maxRabbits : maxRabbits // ignore: cast_nullable_to_non_nullable
as int?,maxStaff: freezed == maxStaff ? _self.maxStaff : maxStaff // ignore: cast_nullable_to_non_nullable
as int?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Plan].
extension PlanPatterns on Plan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Plan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Plan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Plan value)  $default,){
final _that = this;
switch (_that) {
case _Plan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Plan value)?  $default,){
final _that = this;
switch (_that) {
case _Plan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name, @JsonKey(name: 'max_rabbits')@NullableIntConverter()  int? maxRabbits, @JsonKey(name: 'max_staff')@NullableIntConverter()  int? maxStaff, @DoubleConverter()  double? price, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_default')  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Plan() when $default != null:
return $default(_that.id,_that.name,_that.maxRabbits,_that.maxStaff,_that.price,_that.isActive,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name, @JsonKey(name: 'max_rabbits')@NullableIntConverter()  int? maxRabbits, @JsonKey(name: 'max_staff')@NullableIntConverter()  int? maxStaff, @DoubleConverter()  double? price, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_default')  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _Plan():
return $default(_that.id,_that.name,_that.maxRabbits,_that.maxStaff,_that.price,_that.isActive,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String name, @JsonKey(name: 'max_rabbits')@NullableIntConverter()  int? maxRabbits, @JsonKey(name: 'max_staff')@NullableIntConverter()  int? maxStaff, @DoubleConverter()  double? price, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_default')  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _Plan() when $default != null:
return $default(_that.id,_that.name,_that.maxRabbits,_that.maxStaff,_that.price,_that.isActive,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Plan extends Plan {
  const _Plan({@IntConverter() required this.id, required this.name, @JsonKey(name: 'max_rabbits')@NullableIntConverter() this.maxRabbits, @JsonKey(name: 'max_staff')@NullableIntConverter() this.maxStaff, @DoubleConverter() this.price, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'is_default') this.isDefault = false}): super._();
  factory _Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

@override@IntConverter() final  int id;
@override final  String name;
@override@JsonKey(name: 'max_rabbits')@NullableIntConverter() final  int? maxRabbits;
@override@JsonKey(name: 'max_staff')@NullableIntConverter() final  int? maxStaff;
@override@DoubleConverter() final  double? price;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'is_default') final  bool isDefault;

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanCopyWith<_Plan> get copyWith => __$PlanCopyWithImpl<_Plan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Plan&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.maxRabbits, maxRabbits) || other.maxRabbits == maxRabbits)&&(identical(other.maxStaff, maxStaff) || other.maxStaff == maxStaff)&&(identical(other.price, price) || other.price == price)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,maxRabbits,maxStaff,price,isActive,isDefault);
}

@override
String toString() {
    return 'Plan(id: $id, name: $name, maxRabbits: $maxRabbits, maxStaff: $maxStaff, price: $price, isActive: $isActive, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$PlanCopyWith<$Res> implements $PlanCopyWith<$Res> {
  factory _$PlanCopyWith(_Plan value, $Res Function(_Plan) _then) = __$PlanCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String name,@JsonKey(name: 'max_rabbits')@NullableIntConverter() int? maxRabbits,@JsonKey(name: 'max_staff')@NullableIntConverter() int? maxStaff,@DoubleConverter() double? price,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_default') bool isDefault
});




}
/// @nodoc
class __$PlanCopyWithImpl<$Res>
    implements _$PlanCopyWith<$Res> {
  __$PlanCopyWithImpl(this._self, this._then);

  final _Plan _self;
  final $Res Function(_Plan) _then;

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? maxRabbits = freezed,Object? maxStaff = freezed,Object? price = freezed,Object? isActive = null,Object? isDefault = null,}) {
  return _then(_Plan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,maxRabbits: freezed == maxRabbits ? _self.maxRabbits : maxRabbits // ignore: cast_nullable_to_non_nullable
as int?,maxStaff: freezed == maxStaff ? _self.maxStaff : maxStaff // ignore: cast_nullable_to_non_nullable
as int?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PlanDraft {

 String get name;@JsonKey(name: 'max_rabbits') int? get maxRabbits;@JsonKey(name: 'max_staff') int? get maxStaff; double? get price;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'is_default') bool get isDefault;
/// Create a copy of PlanDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanDraftCopyWith<PlanDraft> get copyWith => _$PlanDraftCopyWithImpl<PlanDraft>(this as PlanDraft, _$identity);

  /// Serializes this PlanDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlanDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanDraft&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.maxRabbits, _this.maxRabbits) || other.maxRabbits == _this.maxRabbits)&&(identical(other.maxStaff, _this.maxStaff) || other.maxStaff == _this.maxStaff)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlanDraft;
  return Object.hash(runtimeType,_this.name,_this.maxRabbits,_this.maxStaff,_this.price,_this.isActive,_this.isDefault);
}

@override
String toString() {
  final _this = this as PlanDraft;
  return 'PlanDraft(name: ${_this.name}, maxRabbits: ${_this.maxRabbits}, maxStaff: ${_this.maxStaff}, price: ${_this.price}, isActive: ${_this.isActive}, isDefault: ${_this.isDefault})';
}


}

/// @nodoc
abstract mixin class $PlanDraftCopyWith<$Res>  {
  factory $PlanDraftCopyWith(PlanDraft value, $Res Function(PlanDraft) _then) = _$PlanDraftCopyWithImpl;
@useResult
$Res call({
 String name,@JsonKey(name: 'max_rabbits') int? maxRabbits,@JsonKey(name: 'max_staff') int? maxStaff, double? price,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_default') bool isDefault
});




}
/// @nodoc
class _$PlanDraftCopyWithImpl<$Res>
    implements $PlanDraftCopyWith<$Res> {
  _$PlanDraftCopyWithImpl(this._self, this._then);

  final PlanDraft _self;
  final $Res Function(PlanDraft) _then;

/// Create a copy of PlanDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? maxRabbits = freezed,Object? maxStaff = freezed,Object? price = freezed,Object? isActive = null,Object? isDefault = null,}) {
  return _then(PlanDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,maxRabbits: freezed == maxRabbits ? _self.maxRabbits : maxRabbits // ignore: cast_nullable_to_non_nullable
as int?,maxStaff: freezed == maxStaff ? _self.maxStaff : maxStaff // ignore: cast_nullable_to_non_nullable
as int?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanDraft].
extension PlanDraftPatterns on PlanDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanDraft value)  $default,){
final _that = this;
switch (_that) {
case _PlanDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanDraft value)?  $default,){
final _that = this;
switch (_that) {
case _PlanDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'max_rabbits')  int? maxRabbits, @JsonKey(name: 'max_staff')  int? maxStaff,  double? price, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_default')  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanDraft() when $default != null:
return $default(_that.name,_that.maxRabbits,_that.maxStaff,_that.price,_that.isActive,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'max_rabbits')  int? maxRabbits, @JsonKey(name: 'max_staff')  int? maxStaff,  double? price, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_default')  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _PlanDraft():
return $default(_that.name,_that.maxRabbits,_that.maxStaff,_that.price,_that.isActive,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name, @JsonKey(name: 'max_rabbits')  int? maxRabbits, @JsonKey(name: 'max_staff')  int? maxStaff,  double? price, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_default')  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _PlanDraft() when $default != null:
return $default(_that.name,_that.maxRabbits,_that.maxStaff,_that.price,_that.isActive,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanDraft implements PlanDraft {
  const _PlanDraft({required this.name, @JsonKey(name: 'max_rabbits') this.maxRabbits, @JsonKey(name: 'max_staff') this.maxStaff, this.price, @JsonKey(name: 'is_active') required this.isActive, @JsonKey(name: 'is_default') this.isDefault = false});
  factory _PlanDraft.fromJson(Map<String, dynamic> json) => _$PlanDraftFromJson(json);

@override final  String name;
@override@JsonKey(name: 'max_rabbits') final  int? maxRabbits;
@override@JsonKey(name: 'max_staff') final  int? maxStaff;
@override final  double? price;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'is_default') final  bool isDefault;

/// Create a copy of PlanDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanDraftCopyWith<_PlanDraft> get copyWith => __$PlanDraftCopyWithImpl<_PlanDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanDraftToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.maxRabbits, maxRabbits) || other.maxRabbits == maxRabbits)&&(identical(other.maxStaff, maxStaff) || other.maxStaff == maxStaff)&&(identical(other.price, price) || other.price == price)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,maxRabbits,maxStaff,price,isActive,isDefault);
}

@override
String toString() {
    return 'PlanDraft(name: $name, maxRabbits: $maxRabbits, maxStaff: $maxStaff, price: $price, isActive: $isActive, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$PlanDraftCopyWith<$Res> implements $PlanDraftCopyWith<$Res> {
  factory _$PlanDraftCopyWith(_PlanDraft value, $Res Function(_PlanDraft) _then) = __$PlanDraftCopyWithImpl;
@override @useResult
$Res call({
 String name,@JsonKey(name: 'max_rabbits') int? maxRabbits,@JsonKey(name: 'max_staff') int? maxStaff, double? price,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_default') bool isDefault
});




}
/// @nodoc
class __$PlanDraftCopyWithImpl<$Res>
    implements _$PlanDraftCopyWith<$Res> {
  __$PlanDraftCopyWithImpl(this._self, this._then);

  final _PlanDraft _self;
  final $Res Function(_PlanDraft) _then;

/// Create a copy of PlanDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? maxRabbits = freezed,Object? maxStaff = freezed,Object? price = freezed,Object? isActive = null,Object? isDefault = null,}) {
  return _then(_PlanDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,maxRabbits: freezed == maxRabbits ? _self.maxRabbits : maxRabbits // ignore: cast_nullable_to_non_nullable
as int?,maxStaff: freezed == maxStaff ? _self.maxStaff : maxStaff // ignore: cast_nullable_to_non_nullable
as int?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PlatformFarm {

@IntConverter() int get id; String get name; UserRef? get owner; Plan? get plan;@JsonKey(name: 'rabbits_count')@IntConverter() int get rabbitsCount;@JsonKey(name: 'staff_count')@IntConverter() int get staffCount;@JsonKey(name: 'created_at')@DateTimeConverter() DateTime get createdAt;@JsonKey(name: 'last_active')@NullableDateTimeConverter() DateTime? get lastActiveAt;
/// Create a copy of PlatformFarm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformFarmCopyWith<PlatformFarm> get copyWith => _$PlatformFarmCopyWithImpl<PlatformFarm>(this as PlatformFarm, _$identity);

  /// Serializes this PlatformFarm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlatformFarm;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformFarm&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.owner, _this.owner) || other.owner == _this.owner)&&(identical(other.plan, _this.plan) || other.plan == _this.plan)&&(identical(other.rabbitsCount, _this.rabbitsCount) || other.rabbitsCount == _this.rabbitsCount)&&(identical(other.staffCount, _this.staffCount) || other.staffCount == _this.staffCount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.lastActiveAt, _this.lastActiveAt) || other.lastActiveAt == _this.lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlatformFarm;
  return Object.hash(runtimeType,_this.id,_this.name,_this.owner,_this.plan,_this.rabbitsCount,_this.staffCount,_this.createdAt,_this.lastActiveAt);
}

@override
String toString() {
  final _this = this as PlatformFarm;
  return 'PlatformFarm(id: ${_this.id}, name: ${_this.name}, owner: ${_this.owner}, plan: ${_this.plan}, rabbitsCount: ${_this.rabbitsCount}, staffCount: ${_this.staffCount}, createdAt: ${_this.createdAt}, lastActiveAt: ${_this.lastActiveAt})';
}


}

/// @nodoc
abstract mixin class $PlatformFarmCopyWith<$Res>  {
  factory $PlatformFarmCopyWith(PlatformFarm value, $Res Function(PlatformFarm) _then) = _$PlatformFarmCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String name, UserRef? owner, Plan? plan,@JsonKey(name: 'rabbits_count')@IntConverter() int rabbitsCount,@JsonKey(name: 'staff_count')@IntConverter() int staffCount,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt,@JsonKey(name: 'last_active')@NullableDateTimeConverter() DateTime? lastActiveAt
});


$UserRefCopyWith<$Res>? get owner;$PlanCopyWith<$Res>? get plan;

}
/// @nodoc
class _$PlatformFarmCopyWithImpl<$Res>
    implements $PlatformFarmCopyWith<$Res> {
  _$PlatformFarmCopyWithImpl(this._self, this._then);

  final PlatformFarm _self;
  final $Res Function(PlatformFarm) _then;

/// Create a copy of PlatformFarm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? owner = freezed,Object? plan = freezed,Object? rabbitsCount = null,Object? staffCount = null,Object? createdAt = null,Object? lastActiveAt = freezed,}) {
  return _then(PlatformFarm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as UserRef?,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as Plan?,rabbitsCount: null == rabbitsCount ? _self.rabbitsCount : rabbitsCount // ignore: cast_nullable_to_non_nullable
as int,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of PlatformFarm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $UserRefCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of PlatformFarm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanCopyWith<$Res>? get plan {
    if (_self.plan == null) {
    return null;
  }

  return $PlanCopyWith<$Res>(_self.plan!, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlatformFarm].
extension PlatformFarmPatterns on PlatformFarm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformFarm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformFarm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformFarm value)  $default,){
final _that = this;
switch (_that) {
case _PlatformFarm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformFarm value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformFarm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name,  UserRef? owner,  Plan? plan, @JsonKey(name: 'rabbits_count')@IntConverter()  int rabbitsCount, @JsonKey(name: 'staff_count')@IntConverter()  int staffCount, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt, @JsonKey(name: 'last_active')@NullableDateTimeConverter()  DateTime? lastActiveAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformFarm() when $default != null:
return $default(_that.id,_that.name,_that.owner,_that.plan,_that.rabbitsCount,_that.staffCount,_that.createdAt,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name,  UserRef? owner,  Plan? plan, @JsonKey(name: 'rabbits_count')@IntConverter()  int rabbitsCount, @JsonKey(name: 'staff_count')@IntConverter()  int staffCount, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt, @JsonKey(name: 'last_active')@NullableDateTimeConverter()  DateTime? lastActiveAt)  $default,) {final _that = this;
switch (_that) {
case _PlatformFarm():
return $default(_that.id,_that.name,_that.owner,_that.plan,_that.rabbitsCount,_that.staffCount,_that.createdAt,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String name,  UserRef? owner,  Plan? plan, @JsonKey(name: 'rabbits_count')@IntConverter()  int rabbitsCount, @JsonKey(name: 'staff_count')@IntConverter()  int staffCount, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt, @JsonKey(name: 'last_active')@NullableDateTimeConverter()  DateTime? lastActiveAt)?  $default,) {final _that = this;
switch (_that) {
case _PlatformFarm() when $default != null:
return $default(_that.id,_that.name,_that.owner,_that.plan,_that.rabbitsCount,_that.staffCount,_that.createdAt,_that.lastActiveAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlatformFarm extends PlatformFarm {
  const _PlatformFarm({@IntConverter() required this.id, required this.name, this.owner, this.plan, @JsonKey(name: 'rabbits_count')@IntConverter() this.rabbitsCount = 0, @JsonKey(name: 'staff_count')@IntConverter() this.staffCount = 0, @JsonKey(name: 'created_at')@DateTimeConverter() required this.createdAt, @JsonKey(name: 'last_active')@NullableDateTimeConverter() this.lastActiveAt}): super._();
  factory _PlatformFarm.fromJson(Map<String, dynamic> json) => _$PlatformFarmFromJson(json);

@override@IntConverter() final  int id;
@override final  String name;
@override final  UserRef? owner;
@override final  Plan? plan;
@override@JsonKey(name: 'rabbits_count')@IntConverter() final  int rabbitsCount;
@override@JsonKey(name: 'staff_count')@IntConverter() final  int staffCount;
@override@JsonKey(name: 'created_at')@DateTimeConverter() final  DateTime createdAt;
@override@JsonKey(name: 'last_active')@NullableDateTimeConverter() final  DateTime? lastActiveAt;

/// Create a copy of PlatformFarm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformFarmCopyWith<_PlatformFarm> get copyWith => __$PlatformFarmCopyWithImpl<_PlatformFarm>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformFarmToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformFarm&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.rabbitsCount, rabbitsCount) || other.rabbitsCount == rabbitsCount)&&(identical(other.staffCount, staffCount) || other.staffCount == staffCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,owner,plan,rabbitsCount,staffCount,createdAt,lastActiveAt);
}

@override
String toString() {
    return 'PlatformFarm(id: $id, name: $name, owner: $owner, plan: $plan, rabbitsCount: $rabbitsCount, staffCount: $staffCount, createdAt: $createdAt, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class _$PlatformFarmCopyWith<$Res> implements $PlatformFarmCopyWith<$Res> {
  factory _$PlatformFarmCopyWith(_PlatformFarm value, $Res Function(_PlatformFarm) _then) = __$PlatformFarmCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String name, UserRef? owner, Plan? plan,@JsonKey(name: 'rabbits_count')@IntConverter() int rabbitsCount,@JsonKey(name: 'staff_count')@IntConverter() int staffCount,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt,@JsonKey(name: 'last_active')@NullableDateTimeConverter() DateTime? lastActiveAt
});


@override $UserRefCopyWith<$Res>? get owner;@override $PlanCopyWith<$Res>? get plan;

}
/// @nodoc
class __$PlatformFarmCopyWithImpl<$Res>
    implements _$PlatformFarmCopyWith<$Res> {
  __$PlatformFarmCopyWithImpl(this._self, this._then);

  final _PlatformFarm _self;
  final $Res Function(_PlatformFarm) _then;

/// Create a copy of PlatformFarm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? owner = freezed,Object? plan = freezed,Object? rabbitsCount = null,Object? staffCount = null,Object? createdAt = null,Object? lastActiveAt = freezed,}) {
  return _then(_PlatformFarm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as UserRef?,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as Plan?,rabbitsCount: null == rabbitsCount ? _self.rabbitsCount : rabbitsCount // ignore: cast_nullable_to_non_nullable
as int,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of PlatformFarm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $UserRefCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of PlatformFarm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanCopyWith<$Res>? get plan {
    if (_self.plan == null) {
    return null;
  }

  return $PlanCopyWith<$Res>(_self.plan!, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}


/// @nodoc
mixin _$FarmStaffMember {

@IntConverter() int get id;@JsonKey(name: 'full_name') String get fullName; String? get email; String? get phone; String get role;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'last_login_at')@NullableDateTimeConverter() DateTime? get lastLoginAt;
/// Create a copy of FarmStaffMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmStaffMemberCopyWith<FarmStaffMember> get copyWith => _$FarmStaffMemberCopyWithImpl<FarmStaffMember>(this as FarmStaffMember, _$identity);

  /// Serializes this FarmStaffMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FarmStaffMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmStaffMember&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.lastLoginAt, _this.lastLoginAt) || other.lastLoginAt == _this.lastLoginAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FarmStaffMember;
  return Object.hash(runtimeType,_this.id,_this.fullName,_this.email,_this.phone,_this.role,_this.isActive,_this.lastLoginAt);
}

@override
String toString() {
  final _this = this as FarmStaffMember;
  return 'FarmStaffMember(id: ${_this.id}, fullName: ${_this.fullName}, email: ${_this.email}, phone: ${_this.phone}, role: ${_this.role}, isActive: ${_this.isActive}, lastLoginAt: ${_this.lastLoginAt})';
}


}

/// @nodoc
abstract mixin class $FarmStaffMemberCopyWith<$Res>  {
  factory $FarmStaffMemberCopyWith(FarmStaffMember value, $Res Function(FarmStaffMember) _then) = _$FarmStaffMemberCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'full_name') String fullName, String? email, String? phone, String role,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_login_at')@NullableDateTimeConverter() DateTime? lastLoginAt
});




}
/// @nodoc
class _$FarmStaffMemberCopyWithImpl<$Res>
    implements $FarmStaffMemberCopyWith<$Res> {
  _$FarmStaffMemberCopyWithImpl(this._self, this._then);

  final FarmStaffMember _self;
  final $Res Function(FarmStaffMember) _then;

/// Create a copy of FarmStaffMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? email = freezed,Object? phone = freezed,Object? role = null,Object? isActive = null,Object? lastLoginAt = freezed,}) {
  return _then(FarmStaffMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FarmStaffMember].
extension FarmStaffMemberPatterns on FarmStaffMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmStaffMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmStaffMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmStaffMember value)  $default,){
final _that = this;
switch (_that) {
case _FarmStaffMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmStaffMember value)?  $default,){
final _that = this;
switch (_that) {
case _FarmStaffMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'full_name')  String fullName,  String? email,  String? phone,  String role, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_login_at')@NullableDateTimeConverter()  DateTime? lastLoginAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmStaffMember() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.role,_that.isActive,_that.lastLoginAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'full_name')  String fullName,  String? email,  String? phone,  String role, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_login_at')@NullableDateTimeConverter()  DateTime? lastLoginAt)  $default,) {final _that = this;
switch (_that) {
case _FarmStaffMember():
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.role,_that.isActive,_that.lastLoginAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id, @JsonKey(name: 'full_name')  String fullName,  String? email,  String? phone,  String role, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_login_at')@NullableDateTimeConverter()  DateTime? lastLoginAt)?  $default,) {final _that = this;
switch (_that) {
case _FarmStaffMember() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.role,_that.isActive,_that.lastLoginAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FarmStaffMember implements FarmStaffMember {
  const _FarmStaffMember({@IntConverter() required this.id, @JsonKey(name: 'full_name') required this.fullName, this.email, this.phone, required this.role, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'last_login_at')@NullableDateTimeConverter() this.lastLoginAt});
  factory _FarmStaffMember.fromJson(Map<String, dynamic> json) => _$FarmStaffMemberFromJson(json);

@override@IntConverter() final  int id;
@override@JsonKey(name: 'full_name') final  String fullName;
@override final  String? email;
@override final  String? phone;
@override final  String role;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'last_login_at')@NullableDateTimeConverter() final  DateTime? lastLoginAt;

/// Create a copy of FarmStaffMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmStaffMemberCopyWith<_FarmStaffMember> get copyWith => __$FarmStaffMemberCopyWithImpl<_FarmStaffMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmStaffMemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmStaffMember&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,email,phone,role,isActive,lastLoginAt);
}

@override
String toString() {
    return 'FarmStaffMember(id: $id, fullName: $fullName, email: $email, phone: $phone, role: $role, isActive: $isActive, lastLoginAt: $lastLoginAt)';
}


}

/// @nodoc
abstract mixin class _$FarmStaffMemberCopyWith<$Res> implements $FarmStaffMemberCopyWith<$Res> {
  factory _$FarmStaffMemberCopyWith(_FarmStaffMember value, $Res Function(_FarmStaffMember) _then) = __$FarmStaffMemberCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'full_name') String fullName, String? email, String? phone, String role,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_login_at')@NullableDateTimeConverter() DateTime? lastLoginAt
});




}
/// @nodoc
class __$FarmStaffMemberCopyWithImpl<$Res>
    implements _$FarmStaffMemberCopyWith<$Res> {
  __$FarmStaffMemberCopyWithImpl(this._self, this._then);

  final _FarmStaffMember _self;
  final $Res Function(_FarmStaffMember) _then;

/// Create a copy of FarmStaffMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? email = freezed,Object? phone = freezed,Object? role = null,Object? isActive = null,Object? lastLoginAt = freezed,}) {
  return _then(_FarmStaffMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$FarmPayment {

@IntConverter() int get id; String get amount; String get currency; String get status; String? get description;@JsonKey(name: 'created_at')@DateTimeConverter() DateTime get createdAt;
/// Create a copy of FarmPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmPaymentCopyWith<FarmPayment> get copyWith => _$FarmPaymentCopyWithImpl<FarmPayment>(this as FarmPayment, _$identity);

  /// Serializes this FarmPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FarmPayment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmPayment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FarmPayment;
  return Object.hash(runtimeType,_this.id,_this.amount,_this.currency,_this.status,_this.description,_this.createdAt);
}

@override
String toString() {
  final _this = this as FarmPayment;
  return 'FarmPayment(id: ${_this.id}, amount: ${_this.amount}, currency: ${_this.currency}, status: ${_this.status}, description: ${_this.description}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $FarmPaymentCopyWith<$Res>  {
  factory $FarmPaymentCopyWith(FarmPayment value, $Res Function(FarmPayment) _then) = _$FarmPaymentCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String amount, String currency, String status, String? description,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class _$FarmPaymentCopyWithImpl<$Res>
    implements $FarmPaymentCopyWith<$Res> {
  _$FarmPaymentCopyWithImpl(this._self, this._then);

  final FarmPayment _self;
  final $Res Function(FarmPayment) _then;

/// Create a copy of FarmPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? currency = null,Object? status = null,Object? description = freezed,Object? createdAt = null,}) {
  return _then(FarmPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FarmPayment].
extension FarmPaymentPatterns on FarmPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmPayment value)  $default,){
final _that = this;
switch (_that) {
case _FarmPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmPayment value)?  $default,){
final _that = this;
switch (_that) {
case _FarmPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String amount,  String currency,  String status,  String? description, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmPayment() when $default != null:
return $default(_that.id,_that.amount,_that.currency,_that.status,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String amount,  String currency,  String status,  String? description, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _FarmPayment():
return $default(_that.id,_that.amount,_that.currency,_that.status,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String amount,  String currency,  String status,  String? description, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FarmPayment() when $default != null:
return $default(_that.id,_that.amount,_that.currency,_that.status,_that.description,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FarmPayment implements FarmPayment {
  const _FarmPayment({@IntConverter() required this.id, required this.amount, required this.currency, required this.status, this.description, @JsonKey(name: 'created_at')@DateTimeConverter() required this.createdAt});
  factory _FarmPayment.fromJson(Map<String, dynamic> json) => _$FarmPaymentFromJson(json);

@override@IntConverter() final  int id;
@override final  String amount;
@override final  String currency;
@override final  String status;
@override final  String? description;
@override@JsonKey(name: 'created_at')@DateTimeConverter() final  DateTime createdAt;

/// Create a copy of FarmPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmPaymentCopyWith<_FarmPayment> get copyWith => __$FarmPaymentCopyWithImpl<_FarmPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,amount,currency,status,description,createdAt);
}

@override
String toString() {
    return 'FarmPayment(id: $id, amount: $amount, currency: $currency, status: $status, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FarmPaymentCopyWith<$Res> implements $FarmPaymentCopyWith<$Res> {
  factory _$FarmPaymentCopyWith(_FarmPayment value, $Res Function(_FarmPayment) _then) = __$FarmPaymentCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String amount, String currency, String status, String? description,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt
});




}
/// @nodoc
class __$FarmPaymentCopyWithImpl<$Res>
    implements _$FarmPaymentCopyWith<$Res> {
  __$FarmPaymentCopyWithImpl(this._self, this._then);

  final _FarmPayment _self;
  final $Res Function(_FarmPayment) _then;

/// Create a copy of FarmPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? currency = null,Object? status = null,Object? description = freezed,Object? createdAt = null,}) {
  return _then(_FarmPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PlatformFarmDetail {

@IntConverter() int get id; String get name; UserRef? get owner;@JsonKey(name: 'plan_id')@NullableIntConverter() int? get planId; Plan? get plan;@JsonKey(name: 'plan_expires_at')@NullableDateTimeConverter() DateTime? get planExpiresAt; String get status;@JsonKey(name: 'extra_rabbits')@NullableIntConverter() int? get extraRabbits;@JsonKey(name: 'extra_staff')@NullableIntConverter() int? get extraStaff;@JsonKey(name: 'extras_until')@NullableDateTimeConverter() DateTime? get extrasUntil;@JsonKey(name: 'rabbits_count')@IntConverter() int get rabbitsCount;@JsonKey(name: 'staff_count')@IntConverter() int get staffCount;@JsonKey(name: 'created_at')@DateTimeConverter() DateTime get createdAt;@JsonKey(name: 'last_active')@NullableDateTimeConverter() DateTime? get lastActiveAt; List<FarmStaffMember> get staff; List<FarmPayment> get payments;@JsonKey(name: 'storage_bytes')@IntConverter() int get storageBytes;@JsonKey(name: 'deleted_at')@NullableDateTimeConverter() DateTime? get deletedAt;
/// Create a copy of PlatformFarmDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformFarmDetailCopyWith<PlatformFarmDetail> get copyWith => _$PlatformFarmDetailCopyWithImpl<PlatformFarmDetail>(this as PlatformFarmDetail, _$identity);

  /// Serializes this PlatformFarmDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlatformFarmDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformFarmDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.owner, _this.owner) || other.owner == _this.owner)&&(identical(other.planId, _this.planId) || other.planId == _this.planId)&&(identical(other.plan, _this.plan) || other.plan == _this.plan)&&(identical(other.planExpiresAt, _this.planExpiresAt) || other.planExpiresAt == _this.planExpiresAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.extraRabbits, _this.extraRabbits) || other.extraRabbits == _this.extraRabbits)&&(identical(other.extraStaff, _this.extraStaff) || other.extraStaff == _this.extraStaff)&&(identical(other.extrasUntil, _this.extrasUntil) || other.extrasUntil == _this.extrasUntil)&&(identical(other.rabbitsCount, _this.rabbitsCount) || other.rabbitsCount == _this.rabbitsCount)&&(identical(other.staffCount, _this.staffCount) || other.staffCount == _this.staffCount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.lastActiveAt, _this.lastActiveAt) || other.lastActiveAt == _this.lastActiveAt)&&const DeepCollectionEquality().equals(other.staff, _this.staff)&&const DeepCollectionEquality().equals(other.payments, _this.payments)&&(identical(other.storageBytes, _this.storageBytes) || other.storageBytes == _this.storageBytes)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlatformFarmDetail;
  return Object.hash(runtimeType,_this.id,_this.name,_this.owner,_this.planId,_this.plan,_this.planExpiresAt,_this.status,_this.extraRabbits,_this.extraStaff,_this.extrasUntil,_this.rabbitsCount,_this.staffCount,_this.createdAt,_this.lastActiveAt,const DeepCollectionEquality().hash(_this.staff),const DeepCollectionEquality().hash(_this.payments),_this.storageBytes,_this.deletedAt);
}

@override
String toString() {
  final _this = this as PlatformFarmDetail;
  return 'PlatformFarmDetail(id: ${_this.id}, name: ${_this.name}, owner: ${_this.owner}, planId: ${_this.planId}, plan: ${_this.plan}, planExpiresAt: ${_this.planExpiresAt}, status: ${_this.status}, extraRabbits: ${_this.extraRabbits}, extraStaff: ${_this.extraStaff}, extrasUntil: ${_this.extrasUntil}, rabbitsCount: ${_this.rabbitsCount}, staffCount: ${_this.staffCount}, createdAt: ${_this.createdAt}, lastActiveAt: ${_this.lastActiveAt}, staff: ${_this.staff}, payments: ${_this.payments}, storageBytes: ${_this.storageBytes}, deletedAt: ${_this.deletedAt})';
}


}

/// @nodoc
abstract mixin class $PlatformFarmDetailCopyWith<$Res>  {
  factory $PlatformFarmDetailCopyWith(PlatformFarmDetail value, $Res Function(PlatformFarmDetail) _then) = _$PlatformFarmDetailCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String name, UserRef? owner,@JsonKey(name: 'plan_id')@NullableIntConverter() int? planId, Plan? plan,@JsonKey(name: 'plan_expires_at')@NullableDateTimeConverter() DateTime? planExpiresAt, String status,@JsonKey(name: 'extra_rabbits')@NullableIntConverter() int? extraRabbits,@JsonKey(name: 'extra_staff')@NullableIntConverter() int? extraStaff,@JsonKey(name: 'extras_until')@NullableDateTimeConverter() DateTime? extrasUntil,@JsonKey(name: 'rabbits_count')@IntConverter() int rabbitsCount,@JsonKey(name: 'staff_count')@IntConverter() int staffCount,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt,@JsonKey(name: 'last_active')@NullableDateTimeConverter() DateTime? lastActiveAt, List<FarmStaffMember> staff, List<FarmPayment> payments,@JsonKey(name: 'storage_bytes')@IntConverter() int storageBytes,@JsonKey(name: 'deleted_at')@NullableDateTimeConverter() DateTime? deletedAt
});


$UserRefCopyWith<$Res>? get owner;$PlanCopyWith<$Res>? get plan;

}
/// @nodoc
class _$PlatformFarmDetailCopyWithImpl<$Res>
    implements $PlatformFarmDetailCopyWith<$Res> {
  _$PlatformFarmDetailCopyWithImpl(this._self, this._then);

  final PlatformFarmDetail _self;
  final $Res Function(PlatformFarmDetail) _then;

/// Create a copy of PlatformFarmDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? owner = freezed,Object? planId = freezed,Object? plan = freezed,Object? planExpiresAt = freezed,Object? status = null,Object? extraRabbits = freezed,Object? extraStaff = freezed,Object? extrasUntil = freezed,Object? rabbitsCount = null,Object? staffCount = null,Object? createdAt = null,Object? lastActiveAt = freezed,Object? staff = null,Object? payments = null,Object? storageBytes = null,Object? deletedAt = freezed,}) {
  return _then(PlatformFarmDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as UserRef?,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as int?,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as Plan?,planExpiresAt: freezed == planExpiresAt ? _self.planExpiresAt : planExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,extraRabbits: freezed == extraRabbits ? _self.extraRabbits : extraRabbits // ignore: cast_nullable_to_non_nullable
as int?,extraStaff: freezed == extraStaff ? _self.extraStaff : extraStaff // ignore: cast_nullable_to_non_nullable
as int?,extrasUntil: freezed == extrasUntil ? _self.extrasUntil : extrasUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbitsCount: null == rabbitsCount ? _self.rabbitsCount : rabbitsCount // ignore: cast_nullable_to_non_nullable
as int,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as List<FarmStaffMember>,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<FarmPayment>,storageBytes: null == storageBytes ? _self.storageBytes : storageBytes // ignore: cast_nullable_to_non_nullable
as int,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of PlatformFarmDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $UserRefCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of PlatformFarmDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanCopyWith<$Res>? get plan {
    if (_self.plan == null) {
    return null;
  }

  return $PlanCopyWith<$Res>(_self.plan!, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlatformFarmDetail].
extension PlatformFarmDetailPatterns on PlatformFarmDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformFarmDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformFarmDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformFarmDetail value)  $default,){
final _that = this;
switch (_that) {
case _PlatformFarmDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformFarmDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformFarmDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name,  UserRef? owner, @JsonKey(name: 'plan_id')@NullableIntConverter()  int? planId,  Plan? plan, @JsonKey(name: 'plan_expires_at')@NullableDateTimeConverter()  DateTime? planExpiresAt,  String status, @JsonKey(name: 'extra_rabbits')@NullableIntConverter()  int? extraRabbits, @JsonKey(name: 'extra_staff')@NullableIntConverter()  int? extraStaff, @JsonKey(name: 'extras_until')@NullableDateTimeConverter()  DateTime? extrasUntil, @JsonKey(name: 'rabbits_count')@IntConverter()  int rabbitsCount, @JsonKey(name: 'staff_count')@IntConverter()  int staffCount, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt, @JsonKey(name: 'last_active')@NullableDateTimeConverter()  DateTime? lastActiveAt,  List<FarmStaffMember> staff,  List<FarmPayment> payments, @JsonKey(name: 'storage_bytes')@IntConverter()  int storageBytes, @JsonKey(name: 'deleted_at')@NullableDateTimeConverter()  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformFarmDetail() when $default != null:
return $default(_that.id,_that.name,_that.owner,_that.planId,_that.plan,_that.planExpiresAt,_that.status,_that.extraRabbits,_that.extraStaff,_that.extrasUntil,_that.rabbitsCount,_that.staffCount,_that.createdAt,_that.lastActiveAt,_that.staff,_that.payments,_that.storageBytes,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name,  UserRef? owner, @JsonKey(name: 'plan_id')@NullableIntConverter()  int? planId,  Plan? plan, @JsonKey(name: 'plan_expires_at')@NullableDateTimeConverter()  DateTime? planExpiresAt,  String status, @JsonKey(name: 'extra_rabbits')@NullableIntConverter()  int? extraRabbits, @JsonKey(name: 'extra_staff')@NullableIntConverter()  int? extraStaff, @JsonKey(name: 'extras_until')@NullableDateTimeConverter()  DateTime? extrasUntil, @JsonKey(name: 'rabbits_count')@IntConverter()  int rabbitsCount, @JsonKey(name: 'staff_count')@IntConverter()  int staffCount, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt, @JsonKey(name: 'last_active')@NullableDateTimeConverter()  DateTime? lastActiveAt,  List<FarmStaffMember> staff,  List<FarmPayment> payments, @JsonKey(name: 'storage_bytes')@IntConverter()  int storageBytes, @JsonKey(name: 'deleted_at')@NullableDateTimeConverter()  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _PlatformFarmDetail():
return $default(_that.id,_that.name,_that.owner,_that.planId,_that.plan,_that.planExpiresAt,_that.status,_that.extraRabbits,_that.extraStaff,_that.extrasUntil,_that.rabbitsCount,_that.staffCount,_that.createdAt,_that.lastActiveAt,_that.staff,_that.payments,_that.storageBytes,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String name,  UserRef? owner, @JsonKey(name: 'plan_id')@NullableIntConverter()  int? planId,  Plan? plan, @JsonKey(name: 'plan_expires_at')@NullableDateTimeConverter()  DateTime? planExpiresAt,  String status, @JsonKey(name: 'extra_rabbits')@NullableIntConverter()  int? extraRabbits, @JsonKey(name: 'extra_staff')@NullableIntConverter()  int? extraStaff, @JsonKey(name: 'extras_until')@NullableDateTimeConverter()  DateTime? extrasUntil, @JsonKey(name: 'rabbits_count')@IntConverter()  int rabbitsCount, @JsonKey(name: 'staff_count')@IntConverter()  int staffCount, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt, @JsonKey(name: 'last_active')@NullableDateTimeConverter()  DateTime? lastActiveAt,  List<FarmStaffMember> staff,  List<FarmPayment> payments, @JsonKey(name: 'storage_bytes')@IntConverter()  int storageBytes, @JsonKey(name: 'deleted_at')@NullableDateTimeConverter()  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _PlatformFarmDetail() when $default != null:
return $default(_that.id,_that.name,_that.owner,_that.planId,_that.plan,_that.planExpiresAt,_that.status,_that.extraRabbits,_that.extraStaff,_that.extrasUntil,_that.rabbitsCount,_that.staffCount,_that.createdAt,_that.lastActiveAt,_that.staff,_that.payments,_that.storageBytes,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlatformFarmDetail extends PlatformFarmDetail {
  const _PlatformFarmDetail({@IntConverter() required this.id, required this.name, this.owner, @JsonKey(name: 'plan_id')@NullableIntConverter() this.planId, this.plan, @JsonKey(name: 'plan_expires_at')@NullableDateTimeConverter() this.planExpiresAt, this.status = 'active', @JsonKey(name: 'extra_rabbits')@NullableIntConverter() this.extraRabbits, @JsonKey(name: 'extra_staff')@NullableIntConverter() this.extraStaff, @JsonKey(name: 'extras_until')@NullableDateTimeConverter() this.extrasUntil, @JsonKey(name: 'rabbits_count')@IntConverter() this.rabbitsCount = 0, @JsonKey(name: 'staff_count')@IntConverter() this.staffCount = 0, @JsonKey(name: 'created_at')@DateTimeConverter() required this.createdAt, @JsonKey(name: 'last_active')@NullableDateTimeConverter() this.lastActiveAt,  List<FarmStaffMember> staff = const [],  List<FarmPayment> payments = const [], @JsonKey(name: 'storage_bytes')@IntConverter() this.storageBytes = 0, @JsonKey(name: 'deleted_at')@NullableDateTimeConverter() this.deletedAt}): _staff = staff,_payments = payments,super._();
  factory _PlatformFarmDetail.fromJson(Map<String, dynamic> json) => _$PlatformFarmDetailFromJson(json);

@override@IntConverter() final  int id;
@override final  String name;
@override final  UserRef? owner;
@override@JsonKey(name: 'plan_id')@NullableIntConverter() final  int? planId;
@override final  Plan? plan;
@override@JsonKey(name: 'plan_expires_at')@NullableDateTimeConverter() final  DateTime? planExpiresAt;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'extra_rabbits')@NullableIntConverter() final  int? extraRabbits;
@override@JsonKey(name: 'extra_staff')@NullableIntConverter() final  int? extraStaff;
@override@JsonKey(name: 'extras_until')@NullableDateTimeConverter() final  DateTime? extrasUntil;
@override@JsonKey(name: 'rabbits_count')@IntConverter() final  int rabbitsCount;
@override@JsonKey(name: 'staff_count')@IntConverter() final  int staffCount;
@override@JsonKey(name: 'created_at')@DateTimeConverter() final  DateTime createdAt;
@override@JsonKey(name: 'last_active')@NullableDateTimeConverter() final  DateTime? lastActiveAt;
 final  List<FarmStaffMember> _staff;
@override@JsonKey() List<FarmStaffMember> get staff {
  if (_staff is EqualUnmodifiableListView) return _staff;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staff);
}

 final  List<FarmPayment> _payments;
@override@JsonKey() List<FarmPayment> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

@override@JsonKey(name: 'storage_bytes')@IntConverter() final  int storageBytes;
@override@JsonKey(name: 'deleted_at')@NullableDateTimeConverter() final  DateTime? deletedAt;

/// Create a copy of PlatformFarmDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformFarmDetailCopyWith<_PlatformFarmDetail> get copyWith => __$PlatformFarmDetailCopyWithImpl<_PlatformFarmDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformFarmDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformFarmDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.planExpiresAt, planExpiresAt) || other.planExpiresAt == planExpiresAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.extraRabbits, extraRabbits) || other.extraRabbits == extraRabbits)&&(identical(other.extraStaff, extraStaff) || other.extraStaff == extraStaff)&&(identical(other.extrasUntil, extrasUntil) || other.extrasUntil == extrasUntil)&&(identical(other.rabbitsCount, rabbitsCount) || other.rabbitsCount == rabbitsCount)&&(identical(other.staffCount, staffCount) || other.staffCount == staffCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&const DeepCollectionEquality().equals(other.staff, _staff)&&const DeepCollectionEquality().equals(other.payments, _payments)&&(identical(other.storageBytes, storageBytes) || other.storageBytes == storageBytes)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,owner,planId,plan,planExpiresAt,status,extraRabbits,extraStaff,extrasUntil,rabbitsCount,staffCount,createdAt,lastActiveAt,const DeepCollectionEquality().hash(_staff),const DeepCollectionEquality().hash(_payments),storageBytes,deletedAt);
}

@override
String toString() {
    return 'PlatformFarmDetail(id: $id, name: $name, owner: $owner, planId: $planId, plan: $plan, planExpiresAt: $planExpiresAt, status: $status, extraRabbits: $extraRabbits, extraStaff: $extraStaff, extrasUntil: $extrasUntil, rabbitsCount: $rabbitsCount, staffCount: $staffCount, createdAt: $createdAt, lastActiveAt: $lastActiveAt, staff: $staff, payments: $payments, storageBytes: $storageBytes, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$PlatformFarmDetailCopyWith<$Res> implements $PlatformFarmDetailCopyWith<$Res> {
  factory _$PlatformFarmDetailCopyWith(_PlatformFarmDetail value, $Res Function(_PlatformFarmDetail) _then) = __$PlatformFarmDetailCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String name, UserRef? owner,@JsonKey(name: 'plan_id')@NullableIntConverter() int? planId, Plan? plan,@JsonKey(name: 'plan_expires_at')@NullableDateTimeConverter() DateTime? planExpiresAt, String status,@JsonKey(name: 'extra_rabbits')@NullableIntConverter() int? extraRabbits,@JsonKey(name: 'extra_staff')@NullableIntConverter() int? extraStaff,@JsonKey(name: 'extras_until')@NullableDateTimeConverter() DateTime? extrasUntil,@JsonKey(name: 'rabbits_count')@IntConverter() int rabbitsCount,@JsonKey(name: 'staff_count')@IntConverter() int staffCount,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt,@JsonKey(name: 'last_active')@NullableDateTimeConverter() DateTime? lastActiveAt, List<FarmStaffMember> staff, List<FarmPayment> payments,@JsonKey(name: 'storage_bytes')@IntConverter() int storageBytes,@JsonKey(name: 'deleted_at')@NullableDateTimeConverter() DateTime? deletedAt
});


@override $UserRefCopyWith<$Res>? get owner;@override $PlanCopyWith<$Res>? get plan;

}
/// @nodoc
class __$PlatformFarmDetailCopyWithImpl<$Res>
    implements _$PlatformFarmDetailCopyWith<$Res> {
  __$PlatformFarmDetailCopyWithImpl(this._self, this._then);

  final _PlatformFarmDetail _self;
  final $Res Function(_PlatformFarmDetail) _then;

/// Create a copy of PlatformFarmDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? owner = freezed,Object? planId = freezed,Object? plan = freezed,Object? planExpiresAt = freezed,Object? status = null,Object? extraRabbits = freezed,Object? extraStaff = freezed,Object? extrasUntil = freezed,Object? rabbitsCount = null,Object? staffCount = null,Object? createdAt = null,Object? lastActiveAt = freezed,Object? staff = null,Object? payments = null,Object? storageBytes = null,Object? deletedAt = freezed,}) {
  return _then(_PlatformFarmDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as UserRef?,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as int?,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as Plan?,planExpiresAt: freezed == planExpiresAt ? _self.planExpiresAt : planExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,extraRabbits: freezed == extraRabbits ? _self.extraRabbits : extraRabbits // ignore: cast_nullable_to_non_nullable
as int?,extraStaff: freezed == extraStaff ? _self.extraStaff : extraStaff // ignore: cast_nullable_to_non_nullable
as int?,extrasUntil: freezed == extrasUntil ? _self.extrasUntil : extrasUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbitsCount: null == rabbitsCount ? _self.rabbitsCount : rabbitsCount // ignore: cast_nullable_to_non_nullable
as int,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,staff: null == staff ? _self._staff : staff // ignore: cast_nullable_to_non_nullable
as List<FarmStaffMember>,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<FarmPayment>,storageBytes: null == storageBytes ? _self.storageBytes : storageBytes // ignore: cast_nullable_to_non_nullable
as int,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of PlatformFarmDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $UserRefCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of PlatformFarmDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanCopyWith<$Res>? get plan {
    if (_self.plan == null) {
    return null;
  }

  return $PlanCopyWith<$Res>(_self.plan!, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}


/// @nodoc
mixin _$PlatformFarmsSummary {

@IntConverter() int get total;@IntConverter() int get free;@IntConverter() int get paid;@JsonKey(name: 'no_plan')@IntConverter() int get noPlan;@IntConverter() int get expired;@IntConverter() int get suspended;@JsonKey(name: 'at_limit')@IntConverter() int get atLimit;
/// Create a copy of PlatformFarmsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformFarmsSummaryCopyWith<PlatformFarmsSummary> get copyWith => _$PlatformFarmsSummaryCopyWithImpl<PlatformFarmsSummary>(this as PlatformFarmsSummary, _$identity);

  /// Serializes this PlatformFarmsSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlatformFarmsSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformFarmsSummary&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.free, _this.free) || other.free == _this.free)&&(identical(other.paid, _this.paid) || other.paid == _this.paid)&&(identical(other.noPlan, _this.noPlan) || other.noPlan == _this.noPlan)&&(identical(other.expired, _this.expired) || other.expired == _this.expired)&&(identical(other.suspended, _this.suspended) || other.suspended == _this.suspended)&&(identical(other.atLimit, _this.atLimit) || other.atLimit == _this.atLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlatformFarmsSummary;
  return Object.hash(runtimeType,_this.total,_this.free,_this.paid,_this.noPlan,_this.expired,_this.suspended,_this.atLimit);
}

@override
String toString() {
  final _this = this as PlatformFarmsSummary;
  return 'PlatformFarmsSummary(total: ${_this.total}, free: ${_this.free}, paid: ${_this.paid}, noPlan: ${_this.noPlan}, expired: ${_this.expired}, suspended: ${_this.suspended}, atLimit: ${_this.atLimit})';
}


}

/// @nodoc
abstract mixin class $PlatformFarmsSummaryCopyWith<$Res>  {
  factory $PlatformFarmsSummaryCopyWith(PlatformFarmsSummary value, $Res Function(PlatformFarmsSummary) _then) = _$PlatformFarmsSummaryCopyWithImpl;
@useResult
$Res call({
@IntConverter() int total,@IntConverter() int free,@IntConverter() int paid,@JsonKey(name: 'no_plan')@IntConverter() int noPlan,@IntConverter() int expired,@IntConverter() int suspended,@JsonKey(name: 'at_limit')@IntConverter() int atLimit
});




}
/// @nodoc
class _$PlatformFarmsSummaryCopyWithImpl<$Res>
    implements $PlatformFarmsSummaryCopyWith<$Res> {
  _$PlatformFarmsSummaryCopyWithImpl(this._self, this._then);

  final PlatformFarmsSummary _self;
  final $Res Function(PlatformFarmsSummary) _then;

/// Create a copy of PlatformFarmsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? free = null,Object? paid = null,Object? noPlan = null,Object? expired = null,Object? suspended = null,Object? atLimit = null,}) {
  return _then(PlatformFarmsSummary(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,free: null == free ? _self.free : free // ignore: cast_nullable_to_non_nullable
as int,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as int,noPlan: null == noPlan ? _self.noPlan : noPlan // ignore: cast_nullable_to_non_nullable
as int,expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as int,suspended: null == suspended ? _self.suspended : suspended // ignore: cast_nullable_to_non_nullable
as int,atLimit: null == atLimit ? _self.atLimit : atLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlatformFarmsSummary].
extension PlatformFarmsSummaryPatterns on PlatformFarmsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformFarmsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformFarmsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformFarmsSummary value)  $default,){
final _that = this;
switch (_that) {
case _PlatformFarmsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformFarmsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformFarmsSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int total, @IntConverter()  int free, @IntConverter()  int paid, @JsonKey(name: 'no_plan')@IntConverter()  int noPlan, @IntConverter()  int expired, @IntConverter()  int suspended, @JsonKey(name: 'at_limit')@IntConverter()  int atLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformFarmsSummary() when $default != null:
return $default(_that.total,_that.free,_that.paid,_that.noPlan,_that.expired,_that.suspended,_that.atLimit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int total, @IntConverter()  int free, @IntConverter()  int paid, @JsonKey(name: 'no_plan')@IntConverter()  int noPlan, @IntConverter()  int expired, @IntConverter()  int suspended, @JsonKey(name: 'at_limit')@IntConverter()  int atLimit)  $default,) {final _that = this;
switch (_that) {
case _PlatformFarmsSummary():
return $default(_that.total,_that.free,_that.paid,_that.noPlan,_that.expired,_that.suspended,_that.atLimit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int total, @IntConverter()  int free, @IntConverter()  int paid, @JsonKey(name: 'no_plan')@IntConverter()  int noPlan, @IntConverter()  int expired, @IntConverter()  int suspended, @JsonKey(name: 'at_limit')@IntConverter()  int atLimit)?  $default,) {final _that = this;
switch (_that) {
case _PlatformFarmsSummary() when $default != null:
return $default(_that.total,_that.free,_that.paid,_that.noPlan,_that.expired,_that.suspended,_that.atLimit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlatformFarmsSummary implements PlatformFarmsSummary {
  const _PlatformFarmsSummary({@IntConverter() this.total = 0, @IntConverter() this.free = 0, @IntConverter() this.paid = 0, @JsonKey(name: 'no_plan')@IntConverter() this.noPlan = 0, @IntConverter() this.expired = 0, @IntConverter() this.suspended = 0, @JsonKey(name: 'at_limit')@IntConverter() this.atLimit = 0});
  factory _PlatformFarmsSummary.fromJson(Map<String, dynamic> json) => _$PlatformFarmsSummaryFromJson(json);

@override@JsonKey()@IntConverter() final  int total;
@override@JsonKey()@IntConverter() final  int free;
@override@JsonKey()@IntConverter() final  int paid;
@override@JsonKey(name: 'no_plan')@IntConverter() final  int noPlan;
@override@JsonKey()@IntConverter() final  int expired;
@override@JsonKey()@IntConverter() final  int suspended;
@override@JsonKey(name: 'at_limit')@IntConverter() final  int atLimit;

/// Create a copy of PlatformFarmsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformFarmsSummaryCopyWith<_PlatformFarmsSummary> get copyWith => __$PlatformFarmsSummaryCopyWithImpl<_PlatformFarmsSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformFarmsSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformFarmsSummary&&(identical(other.total, total) || other.total == total)&&(identical(other.free, free) || other.free == free)&&(identical(other.paid, paid) || other.paid == paid)&&(identical(other.noPlan, noPlan) || other.noPlan == noPlan)&&(identical(other.expired, expired) || other.expired == expired)&&(identical(other.suspended, suspended) || other.suspended == suspended)&&(identical(other.atLimit, atLimit) || other.atLimit == atLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,free,paid,noPlan,expired,suspended,atLimit);
}

@override
String toString() {
    return 'PlatformFarmsSummary(total: $total, free: $free, paid: $paid, noPlan: $noPlan, expired: $expired, suspended: $suspended, atLimit: $atLimit)';
}


}

/// @nodoc
abstract mixin class _$PlatformFarmsSummaryCopyWith<$Res> implements $PlatformFarmsSummaryCopyWith<$Res> {
  factory _$PlatformFarmsSummaryCopyWith(_PlatformFarmsSummary value, $Res Function(_PlatformFarmsSummary) _then) = __$PlatformFarmsSummaryCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int total,@IntConverter() int free,@IntConverter() int paid,@JsonKey(name: 'no_plan')@IntConverter() int noPlan,@IntConverter() int expired,@IntConverter() int suspended,@JsonKey(name: 'at_limit')@IntConverter() int atLimit
});




}
/// @nodoc
class __$PlatformFarmsSummaryCopyWithImpl<$Res>
    implements _$PlatformFarmsSummaryCopyWith<$Res> {
  __$PlatformFarmsSummaryCopyWithImpl(this._self, this._then);

  final _PlatformFarmsSummary _self;
  final $Res Function(_PlatformFarmsSummary) _then;

/// Create a copy of PlatformFarmsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? free = null,Object? paid = null,Object? noPlan = null,Object? expired = null,Object? suspended = null,Object? atLimit = null,}) {
  return _then(_PlatformFarmsSummary(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,free: null == free ? _self.free : free // ignore: cast_nullable_to_non_nullable
as int,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as int,noPlan: null == noPlan ? _self.noPlan : noPlan // ignore: cast_nullable_to_non_nullable
as int,expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as int,suspended: null == suspended ? _self.suspended : suspended // ignore: cast_nullable_to_non_nullable
as int,atLimit: null == atLimit ? _self.atLimit : atLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PlatformSummary {

 PlatformFarmsSummary get farms;@JsonKey(name: 'registrations_30d')@IntConverter() int get registrations30d;@JsonKey(name: 'inactive_30d')@IntConverter() int get inactive30d;@JsonKey(name: 'rabbits_total')@IntConverter() int get rabbitsTotal;@JsonKey(name: 'storage_bytes')@IntConverter() int get storageBytes;
/// Create a copy of PlatformSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformSummaryCopyWith<PlatformSummary> get copyWith => _$PlatformSummaryCopyWithImpl<PlatformSummary>(this as PlatformSummary, _$identity);

  /// Serializes this PlatformSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlatformSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformSummary&&(identical(other.farms, _this.farms) || other.farms == _this.farms)&&(identical(other.registrations30d, _this.registrations30d) || other.registrations30d == _this.registrations30d)&&(identical(other.inactive30d, _this.inactive30d) || other.inactive30d == _this.inactive30d)&&(identical(other.rabbitsTotal, _this.rabbitsTotal) || other.rabbitsTotal == _this.rabbitsTotal)&&(identical(other.storageBytes, _this.storageBytes) || other.storageBytes == _this.storageBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlatformSummary;
  return Object.hash(runtimeType,_this.farms,_this.registrations30d,_this.inactive30d,_this.rabbitsTotal,_this.storageBytes);
}

@override
String toString() {
  final _this = this as PlatformSummary;
  return 'PlatformSummary(farms: ${_this.farms}, registrations30d: ${_this.registrations30d}, inactive30d: ${_this.inactive30d}, rabbitsTotal: ${_this.rabbitsTotal}, storageBytes: ${_this.storageBytes})';
}


}

/// @nodoc
abstract mixin class $PlatformSummaryCopyWith<$Res>  {
  factory $PlatformSummaryCopyWith(PlatformSummary value, $Res Function(PlatformSummary) _then) = _$PlatformSummaryCopyWithImpl;
@useResult
$Res call({
 PlatformFarmsSummary farms,@JsonKey(name: 'registrations_30d')@IntConverter() int registrations30d,@JsonKey(name: 'inactive_30d')@IntConverter() int inactive30d,@JsonKey(name: 'rabbits_total')@IntConverter() int rabbitsTotal,@JsonKey(name: 'storage_bytes')@IntConverter() int storageBytes
});


$PlatformFarmsSummaryCopyWith<$Res> get farms;

}
/// @nodoc
class _$PlatformSummaryCopyWithImpl<$Res>
    implements $PlatformSummaryCopyWith<$Res> {
  _$PlatformSummaryCopyWithImpl(this._self, this._then);

  final PlatformSummary _self;
  final $Res Function(PlatformSummary) _then;

/// Create a copy of PlatformSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? farms = null,Object? registrations30d = null,Object? inactive30d = null,Object? rabbitsTotal = null,Object? storageBytes = null,}) {
  return _then(PlatformSummary(
farms: null == farms ? _self.farms : farms // ignore: cast_nullable_to_non_nullable
as PlatformFarmsSummary,registrations30d: null == registrations30d ? _self.registrations30d : registrations30d // ignore: cast_nullable_to_non_nullable
as int,inactive30d: null == inactive30d ? _self.inactive30d : inactive30d // ignore: cast_nullable_to_non_nullable
as int,rabbitsTotal: null == rabbitsTotal ? _self.rabbitsTotal : rabbitsTotal // ignore: cast_nullable_to_non_nullable
as int,storageBytes: null == storageBytes ? _self.storageBytes : storageBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PlatformSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlatformFarmsSummaryCopyWith<$Res> get farms {
  
  return $PlatformFarmsSummaryCopyWith<$Res>(_self.farms, (value) {
    return _then(_self.copyWith(farms: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlatformSummary].
extension PlatformSummaryPatterns on PlatformSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformSummary value)  $default,){
final _that = this;
switch (_that) {
case _PlatformSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlatformFarmsSummary farms, @JsonKey(name: 'registrations_30d')@IntConverter()  int registrations30d, @JsonKey(name: 'inactive_30d')@IntConverter()  int inactive30d, @JsonKey(name: 'rabbits_total')@IntConverter()  int rabbitsTotal, @JsonKey(name: 'storage_bytes')@IntConverter()  int storageBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformSummary() when $default != null:
return $default(_that.farms,_that.registrations30d,_that.inactive30d,_that.rabbitsTotal,_that.storageBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlatformFarmsSummary farms, @JsonKey(name: 'registrations_30d')@IntConverter()  int registrations30d, @JsonKey(name: 'inactive_30d')@IntConverter()  int inactive30d, @JsonKey(name: 'rabbits_total')@IntConverter()  int rabbitsTotal, @JsonKey(name: 'storage_bytes')@IntConverter()  int storageBytes)  $default,) {final _that = this;
switch (_that) {
case _PlatformSummary():
return $default(_that.farms,_that.registrations30d,_that.inactive30d,_that.rabbitsTotal,_that.storageBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlatformFarmsSummary farms, @JsonKey(name: 'registrations_30d')@IntConverter()  int registrations30d, @JsonKey(name: 'inactive_30d')@IntConverter()  int inactive30d, @JsonKey(name: 'rabbits_total')@IntConverter()  int rabbitsTotal, @JsonKey(name: 'storage_bytes')@IntConverter()  int storageBytes)?  $default,) {final _that = this;
switch (_that) {
case _PlatformSummary() when $default != null:
return $default(_that.farms,_that.registrations30d,_that.inactive30d,_that.rabbitsTotal,_that.storageBytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlatformSummary implements PlatformSummary {
  const _PlatformSummary({this.farms = const PlatformFarmsSummary(), @JsonKey(name: 'registrations_30d')@IntConverter() this.registrations30d = 0, @JsonKey(name: 'inactive_30d')@IntConverter() this.inactive30d = 0, @JsonKey(name: 'rabbits_total')@IntConverter() this.rabbitsTotal = 0, @JsonKey(name: 'storage_bytes')@IntConverter() this.storageBytes = 0});
  factory _PlatformSummary.fromJson(Map<String, dynamic> json) => _$PlatformSummaryFromJson(json);

@override@JsonKey() final  PlatformFarmsSummary farms;
@override@JsonKey(name: 'registrations_30d')@IntConverter() final  int registrations30d;
@override@JsonKey(name: 'inactive_30d')@IntConverter() final  int inactive30d;
@override@JsonKey(name: 'rabbits_total')@IntConverter() final  int rabbitsTotal;
@override@JsonKey(name: 'storage_bytes')@IntConverter() final  int storageBytes;

/// Create a copy of PlatformSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformSummaryCopyWith<_PlatformSummary> get copyWith => __$PlatformSummaryCopyWithImpl<_PlatformSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformSummary&&(identical(other.farms, farms) || other.farms == farms)&&(identical(other.registrations30d, registrations30d) || other.registrations30d == registrations30d)&&(identical(other.inactive30d, inactive30d) || other.inactive30d == inactive30d)&&(identical(other.rabbitsTotal, rabbitsTotal) || other.rabbitsTotal == rabbitsTotal)&&(identical(other.storageBytes, storageBytes) || other.storageBytes == storageBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,farms,registrations30d,inactive30d,rabbitsTotal,storageBytes);
}

@override
String toString() {
    return 'PlatformSummary(farms: $farms, registrations30d: $registrations30d, inactive30d: $inactive30d, rabbitsTotal: $rabbitsTotal, storageBytes: $storageBytes)';
}


}

/// @nodoc
abstract mixin class _$PlatformSummaryCopyWith<$Res> implements $PlatformSummaryCopyWith<$Res> {
  factory _$PlatformSummaryCopyWith(_PlatformSummary value, $Res Function(_PlatformSummary) _then) = __$PlatformSummaryCopyWithImpl;
@override @useResult
$Res call({
 PlatformFarmsSummary farms,@JsonKey(name: 'registrations_30d')@IntConverter() int registrations30d,@JsonKey(name: 'inactive_30d')@IntConverter() int inactive30d,@JsonKey(name: 'rabbits_total')@IntConverter() int rabbitsTotal,@JsonKey(name: 'storage_bytes')@IntConverter() int storageBytes
});


@override $PlatformFarmsSummaryCopyWith<$Res> get farms;

}
/// @nodoc
class __$PlatformSummaryCopyWithImpl<$Res>
    implements _$PlatformSummaryCopyWith<$Res> {
  __$PlatformSummaryCopyWithImpl(this._self, this._then);

  final _PlatformSummary _self;
  final $Res Function(_PlatformSummary) _then;

/// Create a copy of PlatformSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? farms = null,Object? registrations30d = null,Object? inactive30d = null,Object? rabbitsTotal = null,Object? storageBytes = null,}) {
  return _then(_PlatformSummary(
farms: null == farms ? _self.farms : farms // ignore: cast_nullable_to_non_nullable
as PlatformFarmsSummary,registrations30d: null == registrations30d ? _self.registrations30d : registrations30d // ignore: cast_nullable_to_non_nullable
as int,inactive30d: null == inactive30d ? _self.inactive30d : inactive30d // ignore: cast_nullable_to_non_nullable
as int,rabbitsTotal: null == rabbitsTotal ? _self.rabbitsTotal : rabbitsTotal // ignore: cast_nullable_to_non_nullable
as int,storageBytes: null == storageBytes ? _self.storageBytes : storageBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PlatformSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlatformFarmsSummaryCopyWith<$Res> get farms {
  
  return $PlatformFarmsSummaryCopyWith<$Res>(_self.farms, (value) {
    return _then(_self.copyWith(farms: value));
  });
}
}


/// @nodoc
mixin _$ChannelDelivery {

@IntConverter() int get sent;@IntConverter() int get failed;
/// Create a copy of ChannelDelivery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelDeliveryCopyWith<ChannelDelivery> get copyWith => _$ChannelDeliveryCopyWithImpl<ChannelDelivery>(this as ChannelDelivery, _$identity);

  /// Serializes this ChannelDelivery to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChannelDelivery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelDelivery&&(identical(other.sent, _this.sent) || other.sent == _this.sent)&&(identical(other.failed, _this.failed) || other.failed == _this.failed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChannelDelivery;
  return Object.hash(runtimeType,_this.sent,_this.failed);
}

@override
String toString() {
  final _this = this as ChannelDelivery;
  return 'ChannelDelivery(sent: ${_this.sent}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $ChannelDeliveryCopyWith<$Res>  {
  factory $ChannelDeliveryCopyWith(ChannelDelivery value, $Res Function(ChannelDelivery) _then) = _$ChannelDeliveryCopyWithImpl;
@useResult
$Res call({
@IntConverter() int sent,@IntConverter() int failed
});




}
/// @nodoc
class _$ChannelDeliveryCopyWithImpl<$Res>
    implements $ChannelDeliveryCopyWith<$Res> {
  _$ChannelDeliveryCopyWithImpl(this._self, this._then);

  final ChannelDelivery _self;
  final $Res Function(ChannelDelivery) _then;

/// Create a copy of ChannelDelivery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sent = null,Object? failed = null,}) {
  return _then(ChannelDelivery(
sent: null == sent ? _self.sent : sent // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelDelivery].
extension ChannelDeliveryPatterns on ChannelDelivery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelDelivery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelDelivery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelDelivery value)  $default,){
final _that = this;
switch (_that) {
case _ChannelDelivery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelDelivery value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelDelivery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int sent, @IntConverter()  int failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelDelivery() when $default != null:
return $default(_that.sent,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int sent, @IntConverter()  int failed)  $default,) {final _that = this;
switch (_that) {
case _ChannelDelivery():
return $default(_that.sent,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int sent, @IntConverter()  int failed)?  $default,) {final _that = this;
switch (_that) {
case _ChannelDelivery() when $default != null:
return $default(_that.sent,_that.failed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChannelDelivery extends ChannelDelivery {
  const _ChannelDelivery({@IntConverter() this.sent = 0, @IntConverter() this.failed = 0}): super._();
  factory _ChannelDelivery.fromJson(Map<String, dynamic> json) => _$ChannelDeliveryFromJson(json);

@override@JsonKey()@IntConverter() final  int sent;
@override@JsonKey()@IntConverter() final  int failed;

/// Create a copy of ChannelDelivery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelDeliveryCopyWith<_ChannelDelivery> get copyWith => __$ChannelDeliveryCopyWithImpl<_ChannelDelivery>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChannelDeliveryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelDelivery&&(identical(other.sent, sent) || other.sent == sent)&&(identical(other.failed, failed) || other.failed == failed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sent,failed);
}

@override
String toString() {
    return 'ChannelDelivery(sent: $sent, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$ChannelDeliveryCopyWith<$Res> implements $ChannelDeliveryCopyWith<$Res> {
  factory _$ChannelDeliveryCopyWith(_ChannelDelivery value, $Res Function(_ChannelDelivery) _then) = __$ChannelDeliveryCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int sent,@IntConverter() int failed
});




}
/// @nodoc
class __$ChannelDeliveryCopyWithImpl<$Res>
    implements _$ChannelDeliveryCopyWith<$Res> {
  __$ChannelDeliveryCopyWithImpl(this._self, this._then);

  final _ChannelDelivery _self;
  final $Res Function(_ChannelDelivery) _then;

/// Create a copy of ChannelDelivery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sent = null,Object? failed = null,}) {
  return _then(_ChannelDelivery(
sent: null == sent ? _self.sent : sent // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AnnouncementStats {

 ChannelDelivery? get push; ChannelDelivery? get email;
/// Create a copy of AnnouncementStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementStatsCopyWith<AnnouncementStats> get copyWith => _$AnnouncementStatsCopyWithImpl<AnnouncementStats>(this as AnnouncementStats, _$identity);

  /// Serializes this AnnouncementStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AnnouncementStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementStats&&(identical(other.push, _this.push) || other.push == _this.push)&&(identical(other.email, _this.email) || other.email == _this.email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AnnouncementStats;
  return Object.hash(runtimeType,_this.push,_this.email);
}

@override
String toString() {
  final _this = this as AnnouncementStats;
  return 'AnnouncementStats(push: ${_this.push}, email: ${_this.email})';
}


}

/// @nodoc
abstract mixin class $AnnouncementStatsCopyWith<$Res>  {
  factory $AnnouncementStatsCopyWith(AnnouncementStats value, $Res Function(AnnouncementStats) _then) = _$AnnouncementStatsCopyWithImpl;
@useResult
$Res call({
 ChannelDelivery? push, ChannelDelivery? email
});


$ChannelDeliveryCopyWith<$Res>? get push;$ChannelDeliveryCopyWith<$Res>? get email;

}
/// @nodoc
class _$AnnouncementStatsCopyWithImpl<$Res>
    implements $AnnouncementStatsCopyWith<$Res> {
  _$AnnouncementStatsCopyWithImpl(this._self, this._then);

  final AnnouncementStats _self;
  final $Res Function(AnnouncementStats) _then;

/// Create a copy of AnnouncementStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? push = freezed,Object? email = freezed,}) {
  return _then(AnnouncementStats(
push: freezed == push ? _self.push : push // ignore: cast_nullable_to_non_nullable
as ChannelDelivery?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as ChannelDelivery?,
  ));
}
/// Create a copy of AnnouncementStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelDeliveryCopyWith<$Res>? get push {
    if (_self.push == null) {
    return null;
  }

  return $ChannelDeliveryCopyWith<$Res>(_self.push!, (value) {
    return _then(_self.copyWith(push: value));
  });
}/// Create a copy of AnnouncementStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelDeliveryCopyWith<$Res>? get email {
    if (_self.email == null) {
    return null;
  }

  return $ChannelDeliveryCopyWith<$Res>(_self.email!, (value) {
    return _then(_self.copyWith(email: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnnouncementStats].
extension AnnouncementStatsPatterns on AnnouncementStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnnouncementStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnnouncementStats value)  $default,){
final _that = this;
switch (_that) {
case _AnnouncementStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnnouncementStats value)?  $default,){
final _that = this;
switch (_that) {
case _AnnouncementStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChannelDelivery? push,  ChannelDelivery? email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementStats() when $default != null:
return $default(_that.push,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChannelDelivery? push,  ChannelDelivery? email)  $default,) {final _that = this;
switch (_that) {
case _AnnouncementStats():
return $default(_that.push,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChannelDelivery? push,  ChannelDelivery? email)?  $default,) {final _that = this;
switch (_that) {
case _AnnouncementStats() when $default != null:
return $default(_that.push,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnnouncementStats extends AnnouncementStats {
  const _AnnouncementStats({this.push, this.email}): super._();
  factory _AnnouncementStats.fromJson(Map<String, dynamic> json) => _$AnnouncementStatsFromJson(json);

@override final  ChannelDelivery? push;
@override final  ChannelDelivery? email;

/// Create a copy of AnnouncementStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementStatsCopyWith<_AnnouncementStats> get copyWith => __$AnnouncementStatsCopyWithImpl<_AnnouncementStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnnouncementStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementStats&&(identical(other.push, push) || other.push == push)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,push,email);
}

@override
String toString() {
    return 'AnnouncementStats(push: $push, email: $email)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementStatsCopyWith<$Res> implements $AnnouncementStatsCopyWith<$Res> {
  factory _$AnnouncementStatsCopyWith(_AnnouncementStats value, $Res Function(_AnnouncementStats) _then) = __$AnnouncementStatsCopyWithImpl;
@override @useResult
$Res call({
 ChannelDelivery? push, ChannelDelivery? email
});


@override $ChannelDeliveryCopyWith<$Res>? get push;@override $ChannelDeliveryCopyWith<$Res>? get email;

}
/// @nodoc
class __$AnnouncementStatsCopyWithImpl<$Res>
    implements _$AnnouncementStatsCopyWith<$Res> {
  __$AnnouncementStatsCopyWithImpl(this._self, this._then);

  final _AnnouncementStats _self;
  final $Res Function(_AnnouncementStats) _then;

/// Create a copy of AnnouncementStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? push = freezed,Object? email = freezed,}) {
  return _then(_AnnouncementStats(
push: freezed == push ? _self.push : push // ignore: cast_nullable_to_non_nullable
as ChannelDelivery?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as ChannelDelivery?,
  ));
}

/// Create a copy of AnnouncementStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelDeliveryCopyWith<$Res>? get push {
    if (_self.push == null) {
    return null;
  }

  return $ChannelDeliveryCopyWith<$Res>(_self.push!, (value) {
    return _then(_self.copyWith(push: value));
  });
}/// Create a copy of AnnouncementStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelDeliveryCopyWith<$Res>? get email {
    if (_self.email == null) {
    return null;
  }

  return $ChannelDeliveryCopyWith<$Res>(_self.email!, (value) {
    return _then(_self.copyWith(email: value));
  });
}
}


/// @nodoc
mixin _$AnnouncementTargetFarm {

@IntConverter() int get id; String get name;
/// Create a copy of AnnouncementTargetFarm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementTargetFarmCopyWith<AnnouncementTargetFarm> get copyWith => _$AnnouncementTargetFarmCopyWithImpl<AnnouncementTargetFarm>(this as AnnouncementTargetFarm, _$identity);

  /// Serializes this AnnouncementTargetFarm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AnnouncementTargetFarm;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementTargetFarm&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AnnouncementTargetFarm;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as AnnouncementTargetFarm;
  return 'AnnouncementTargetFarm(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $AnnouncementTargetFarmCopyWith<$Res>  {
  factory $AnnouncementTargetFarmCopyWith(AnnouncementTargetFarm value, $Res Function(AnnouncementTargetFarm) _then) = _$AnnouncementTargetFarmCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String name
});




}
/// @nodoc
class _$AnnouncementTargetFarmCopyWithImpl<$Res>
    implements $AnnouncementTargetFarmCopyWith<$Res> {
  _$AnnouncementTargetFarmCopyWithImpl(this._self, this._then);

  final AnnouncementTargetFarm _self;
  final $Res Function(AnnouncementTargetFarm) _then;

/// Create a copy of AnnouncementTargetFarm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(AnnouncementTargetFarm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnouncementTargetFarm].
extension AnnouncementTargetFarmPatterns on AnnouncementTargetFarm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnnouncementTargetFarm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementTargetFarm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnnouncementTargetFarm value)  $default,){
final _that = this;
switch (_that) {
case _AnnouncementTargetFarm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnnouncementTargetFarm value)?  $default,){
final _that = this;
switch (_that) {
case _AnnouncementTargetFarm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementTargetFarm() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _AnnouncementTargetFarm():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _AnnouncementTargetFarm() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnnouncementTargetFarm implements AnnouncementTargetFarm {
  const _AnnouncementTargetFarm({@IntConverter() required this.id, required this.name});
  factory _AnnouncementTargetFarm.fromJson(Map<String, dynamic> json) => _$AnnouncementTargetFarmFromJson(json);

@override@IntConverter() final  int id;
@override final  String name;

/// Create a copy of AnnouncementTargetFarm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementTargetFarmCopyWith<_AnnouncementTargetFarm> get copyWith => __$AnnouncementTargetFarmCopyWithImpl<_AnnouncementTargetFarm>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnnouncementTargetFarmToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementTargetFarm&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'AnnouncementTargetFarm(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementTargetFarmCopyWith<$Res> implements $AnnouncementTargetFarmCopyWith<$Res> {
  factory _$AnnouncementTargetFarmCopyWith(_AnnouncementTargetFarm value, $Res Function(_AnnouncementTargetFarm) _then) = __$AnnouncementTargetFarmCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String name
});




}
/// @nodoc
class __$AnnouncementTargetFarmCopyWithImpl<$Res>
    implements _$AnnouncementTargetFarmCopyWith<$Res> {
  __$AnnouncementTargetFarmCopyWithImpl(this._self, this._then);

  final _AnnouncementTargetFarm _self;
  final $Res Function(_AnnouncementTargetFarm) _then;

/// Create a copy of AnnouncementTargetFarm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_AnnouncementTargetFarm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Announcement {

@IntConverter() int get id; String get title; String get body; List<String> get channels;@JsonKey(name: 'target_type') String get targetType;@JsonKey(name: 'target_farm_id')@NullableIntConverter() int? get targetFarmId; AnnouncementTargetFarm? get targetFarm;@JsonKey(name: 'target_filter') String? get targetFilter;@JsonKey(name: 'farms_count')@IntConverter() int get farmsCount;@JsonKey(name: 'recipients_count')@IntConverter() int get recipientsCount; AnnouncementStats? get stats;@JsonKey(name: 'created_at')@DateTimeConverter() DateTime get createdAt;
/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementCopyWith<Announcement> get copyWith => _$AnnouncementCopyWithImpl<Announcement>(this as Announcement, _$identity);

  /// Serializes this Announcement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Announcement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Announcement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&const DeepCollectionEquality().equals(other.channels, _this.channels)&&(identical(other.targetType, _this.targetType) || other.targetType == _this.targetType)&&(identical(other.targetFarmId, _this.targetFarmId) || other.targetFarmId == _this.targetFarmId)&&(identical(other.targetFarm, _this.targetFarm) || other.targetFarm == _this.targetFarm)&&(identical(other.targetFilter, _this.targetFilter) || other.targetFilter == _this.targetFilter)&&(identical(other.farmsCount, _this.farmsCount) || other.farmsCount == _this.farmsCount)&&(identical(other.recipientsCount, _this.recipientsCount) || other.recipientsCount == _this.recipientsCount)&&(identical(other.stats, _this.stats) || other.stats == _this.stats)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Announcement;
  return Object.hash(runtimeType,_this.id,_this.title,_this.body,const DeepCollectionEquality().hash(_this.channels),_this.targetType,_this.targetFarmId,_this.targetFarm,_this.targetFilter,_this.farmsCount,_this.recipientsCount,_this.stats,_this.createdAt);
}

@override
String toString() {
  final _this = this as Announcement;
  return 'Announcement(id: ${_this.id}, title: ${_this.title}, body: ${_this.body}, channels: ${_this.channels}, targetType: ${_this.targetType}, targetFarmId: ${_this.targetFarmId}, targetFarm: ${_this.targetFarm}, targetFilter: ${_this.targetFilter}, farmsCount: ${_this.farmsCount}, recipientsCount: ${_this.recipientsCount}, stats: ${_this.stats}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AnnouncementCopyWith<$Res>  {
  factory $AnnouncementCopyWith(Announcement value, $Res Function(Announcement) _then) = _$AnnouncementCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String title, String body, List<String> channels,@JsonKey(name: 'target_type') String targetType,@JsonKey(name: 'target_farm_id')@NullableIntConverter() int? targetFarmId, AnnouncementTargetFarm? targetFarm,@JsonKey(name: 'target_filter') String? targetFilter,@JsonKey(name: 'farms_count')@IntConverter() int farmsCount,@JsonKey(name: 'recipients_count')@IntConverter() int recipientsCount, AnnouncementStats? stats,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt
});


$AnnouncementTargetFarmCopyWith<$Res>? get targetFarm;$AnnouncementStatsCopyWith<$Res>? get stats;

}
/// @nodoc
class _$AnnouncementCopyWithImpl<$Res>
    implements $AnnouncementCopyWith<$Res> {
  _$AnnouncementCopyWithImpl(this._self, this._then);

  final Announcement _self;
  final $Res Function(Announcement) _then;

/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = null,Object? channels = null,Object? targetType = null,Object? targetFarmId = freezed,Object? targetFarm = freezed,Object? targetFilter = freezed,Object? farmsCount = null,Object? recipientsCount = null,Object? stats = freezed,Object? createdAt = null,}) {
  return _then(Announcement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as List<String>,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,targetFarmId: freezed == targetFarmId ? _self.targetFarmId : targetFarmId // ignore: cast_nullable_to_non_nullable
as int?,targetFarm: freezed == targetFarm ? _self.targetFarm : targetFarm // ignore: cast_nullable_to_non_nullable
as AnnouncementTargetFarm?,targetFilter: freezed == targetFilter ? _self.targetFilter : targetFilter // ignore: cast_nullable_to_non_nullable
as String?,farmsCount: null == farmsCount ? _self.farmsCount : farmsCount // ignore: cast_nullable_to_non_nullable
as int,recipientsCount: null == recipientsCount ? _self.recipientsCount : recipientsCount // ignore: cast_nullable_to_non_nullable
as int,stats: freezed == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as AnnouncementStats?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnnouncementTargetFarmCopyWith<$Res>? get targetFarm {
    if (_self.targetFarm == null) {
    return null;
  }

  return $AnnouncementTargetFarmCopyWith<$Res>(_self.targetFarm!, (value) {
    return _then(_self.copyWith(targetFarm: value));
  });
}/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnnouncementStatsCopyWith<$Res>? get stats {
    if (_self.stats == null) {
    return null;
  }

  return $AnnouncementStatsCopyWith<$Res>(_self.stats!, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [Announcement].
extension AnnouncementPatterns on Announcement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Announcement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Announcement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Announcement value)  $default,){
final _that = this;
switch (_that) {
case _Announcement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Announcement value)?  $default,){
final _that = this;
switch (_that) {
case _Announcement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String title,  String body,  List<String> channels, @JsonKey(name: 'target_type')  String targetType, @JsonKey(name: 'target_farm_id')@NullableIntConverter()  int? targetFarmId,  AnnouncementTargetFarm? targetFarm, @JsonKey(name: 'target_filter')  String? targetFilter, @JsonKey(name: 'farms_count')@IntConverter()  int farmsCount, @JsonKey(name: 'recipients_count')@IntConverter()  int recipientsCount,  AnnouncementStats? stats, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Announcement() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.channels,_that.targetType,_that.targetFarmId,_that.targetFarm,_that.targetFilter,_that.farmsCount,_that.recipientsCount,_that.stats,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String title,  String body,  List<String> channels, @JsonKey(name: 'target_type')  String targetType, @JsonKey(name: 'target_farm_id')@NullableIntConverter()  int? targetFarmId,  AnnouncementTargetFarm? targetFarm, @JsonKey(name: 'target_filter')  String? targetFilter, @JsonKey(name: 'farms_count')@IntConverter()  int farmsCount, @JsonKey(name: 'recipients_count')@IntConverter()  int recipientsCount,  AnnouncementStats? stats, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Announcement():
return $default(_that.id,_that.title,_that.body,_that.channels,_that.targetType,_that.targetFarmId,_that.targetFarm,_that.targetFilter,_that.farmsCount,_that.recipientsCount,_that.stats,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String title,  String body,  List<String> channels, @JsonKey(name: 'target_type')  String targetType, @JsonKey(name: 'target_farm_id')@NullableIntConverter()  int? targetFarmId,  AnnouncementTargetFarm? targetFarm, @JsonKey(name: 'target_filter')  String? targetFilter, @JsonKey(name: 'farms_count')@IntConverter()  int farmsCount, @JsonKey(name: 'recipients_count')@IntConverter()  int recipientsCount,  AnnouncementStats? stats, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Announcement() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.channels,_that.targetType,_that.targetFarmId,_that.targetFarm,_that.targetFilter,_that.farmsCount,_that.recipientsCount,_that.stats,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Announcement extends Announcement {
  const _Announcement({@IntConverter() required this.id, required this.title, required this.body,  List<String> channels = const <String>[], @JsonKey(name: 'target_type') this.targetType = 'all', @JsonKey(name: 'target_farm_id')@NullableIntConverter() this.targetFarmId, this.targetFarm, @JsonKey(name: 'target_filter') this.targetFilter, @JsonKey(name: 'farms_count')@IntConverter() this.farmsCount = 0, @JsonKey(name: 'recipients_count')@IntConverter() this.recipientsCount = 0, this.stats, @JsonKey(name: 'created_at')@DateTimeConverter() required this.createdAt}): _channels = channels,super._();
  factory _Announcement.fromJson(Map<String, dynamic> json) => _$AnnouncementFromJson(json);

@override@IntConverter() final  int id;
@override final  String title;
@override final  String body;
 final  List<String> _channels;
@override@JsonKey() List<String> get channels {
  if (_channels is EqualUnmodifiableListView) return _channels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_channels);
}

@override@JsonKey(name: 'target_type') final  String targetType;
@override@JsonKey(name: 'target_farm_id')@NullableIntConverter() final  int? targetFarmId;
@override final  AnnouncementTargetFarm? targetFarm;
@override@JsonKey(name: 'target_filter') final  String? targetFilter;
@override@JsonKey(name: 'farms_count')@IntConverter() final  int farmsCount;
@override@JsonKey(name: 'recipients_count')@IntConverter() final  int recipientsCount;
@override final  AnnouncementStats? stats;
@override@JsonKey(name: 'created_at')@DateTimeConverter() final  DateTime createdAt;

/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementCopyWith<_Announcement> get copyWith => __$AnnouncementCopyWithImpl<_Announcement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnnouncementToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Announcement&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.channels, _channels)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetFarmId, targetFarmId) || other.targetFarmId == targetFarmId)&&(identical(other.targetFarm, targetFarm) || other.targetFarm == targetFarm)&&(identical(other.targetFilter, targetFilter) || other.targetFilter == targetFilter)&&(identical(other.farmsCount, farmsCount) || other.farmsCount == farmsCount)&&(identical(other.recipientsCount, recipientsCount) || other.recipientsCount == recipientsCount)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,body,const DeepCollectionEquality().hash(_channels),targetType,targetFarmId,targetFarm,targetFilter,farmsCount,recipientsCount,stats,createdAt);
}

@override
String toString() {
    return 'Announcement(id: $id, title: $title, body: $body, channels: $channels, targetType: $targetType, targetFarmId: $targetFarmId, targetFarm: $targetFarm, targetFilter: $targetFilter, farmsCount: $farmsCount, recipientsCount: $recipientsCount, stats: $stats, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementCopyWith<$Res> implements $AnnouncementCopyWith<$Res> {
  factory _$AnnouncementCopyWith(_Announcement value, $Res Function(_Announcement) _then) = __$AnnouncementCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String title, String body, List<String> channels,@JsonKey(name: 'target_type') String targetType,@JsonKey(name: 'target_farm_id')@NullableIntConverter() int? targetFarmId, AnnouncementTargetFarm? targetFarm,@JsonKey(name: 'target_filter') String? targetFilter,@JsonKey(name: 'farms_count')@IntConverter() int farmsCount,@JsonKey(name: 'recipients_count')@IntConverter() int recipientsCount, AnnouncementStats? stats,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt
});


@override $AnnouncementTargetFarmCopyWith<$Res>? get targetFarm;@override $AnnouncementStatsCopyWith<$Res>? get stats;

}
/// @nodoc
class __$AnnouncementCopyWithImpl<$Res>
    implements _$AnnouncementCopyWith<$Res> {
  __$AnnouncementCopyWithImpl(this._self, this._then);

  final _Announcement _self;
  final $Res Function(_Announcement) _then;

/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = null,Object? channels = null,Object? targetType = null,Object? targetFarmId = freezed,Object? targetFarm = freezed,Object? targetFilter = freezed,Object? farmsCount = null,Object? recipientsCount = null,Object? stats = freezed,Object? createdAt = null,}) {
  return _then(_Announcement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,channels: null == channels ? _self._channels : channels // ignore: cast_nullable_to_non_nullable
as List<String>,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,targetFarmId: freezed == targetFarmId ? _self.targetFarmId : targetFarmId // ignore: cast_nullable_to_non_nullable
as int?,targetFarm: freezed == targetFarm ? _self.targetFarm : targetFarm // ignore: cast_nullable_to_non_nullable
as AnnouncementTargetFarm?,targetFilter: freezed == targetFilter ? _self.targetFilter : targetFilter // ignore: cast_nullable_to_non_nullable
as String?,farmsCount: null == farmsCount ? _self.farmsCount : farmsCount // ignore: cast_nullable_to_non_nullable
as int,recipientsCount: null == recipientsCount ? _self.recipientsCount : recipientsCount // ignore: cast_nullable_to_non_nullable
as int,stats: freezed == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as AnnouncementStats?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnnouncementTargetFarmCopyWith<$Res>? get targetFarm {
    if (_self.targetFarm == null) {
    return null;
  }

  return $AnnouncementTargetFarmCopyWith<$Res>(_self.targetFarm!, (value) {
    return _then(_self.copyWith(targetFarm: value));
  });
}/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnnouncementStatsCopyWith<$Res>? get stats {
    if (_self.stats == null) {
    return null;
  }

  return $AnnouncementStatsCopyWith<$Res>(_self.stats!, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

/// @nodoc
mixin _$AnnouncementDraft {

 String get title; String get body; List<String> get channels; String get targetType; int? get targetFarmId; String? get targetFilter;
/// Create a copy of AnnouncementDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementDraftCopyWith<AnnouncementDraft> get copyWith => _$AnnouncementDraftCopyWithImpl<AnnouncementDraft>(this as AnnouncementDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AnnouncementDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementDraft&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&const DeepCollectionEquality().equals(other.channels, _this.channels)&&(identical(other.targetType, _this.targetType) || other.targetType == _this.targetType)&&(identical(other.targetFarmId, _this.targetFarmId) || other.targetFarmId == _this.targetFarmId)&&(identical(other.targetFilter, _this.targetFilter) || other.targetFilter == _this.targetFilter));
}


@override
int get hashCode {
  final _this = this as AnnouncementDraft;
  return Object.hash(runtimeType,_this.title,_this.body,const DeepCollectionEquality().hash(_this.channels),_this.targetType,_this.targetFarmId,_this.targetFilter);
}

@override
String toString() {
  final _this = this as AnnouncementDraft;
  return 'AnnouncementDraft(title: ${_this.title}, body: ${_this.body}, channels: ${_this.channels}, targetType: ${_this.targetType}, targetFarmId: ${_this.targetFarmId}, targetFilter: ${_this.targetFilter})';
}


}

/// @nodoc
abstract mixin class $AnnouncementDraftCopyWith<$Res>  {
  factory $AnnouncementDraftCopyWith(AnnouncementDraft value, $Res Function(AnnouncementDraft) _then) = _$AnnouncementDraftCopyWithImpl;
@useResult
$Res call({
 String title, String body, List<String> channels, String targetType, int? targetFarmId, String? targetFilter
});




}
/// @nodoc
class _$AnnouncementDraftCopyWithImpl<$Res>
    implements $AnnouncementDraftCopyWith<$Res> {
  _$AnnouncementDraftCopyWithImpl(this._self, this._then);

  final AnnouncementDraft _self;
  final $Res Function(AnnouncementDraft) _then;

/// Create a copy of AnnouncementDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? body = null,Object? channels = null,Object? targetType = null,Object? targetFarmId = freezed,Object? targetFilter = freezed,}) {
  return _then(AnnouncementDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as List<String>,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,targetFarmId: freezed == targetFarmId ? _self.targetFarmId : targetFarmId // ignore: cast_nullable_to_non_nullable
as int?,targetFilter: freezed == targetFilter ? _self.targetFilter : targetFilter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnouncementDraft].
extension AnnouncementDraftPatterns on AnnouncementDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnnouncementDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnnouncementDraft value)  $default,){
final _that = this;
switch (_that) {
case _AnnouncementDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnnouncementDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AnnouncementDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String body,  List<String> channels,  String targetType,  int? targetFarmId,  String? targetFilter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementDraft() when $default != null:
return $default(_that.title,_that.body,_that.channels,_that.targetType,_that.targetFarmId,_that.targetFilter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String body,  List<String> channels,  String targetType,  int? targetFarmId,  String? targetFilter)  $default,) {final _that = this;
switch (_that) {
case _AnnouncementDraft():
return $default(_that.title,_that.body,_that.channels,_that.targetType,_that.targetFarmId,_that.targetFilter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String body,  List<String> channels,  String targetType,  int? targetFarmId,  String? targetFilter)?  $default,) {final _that = this;
switch (_that) {
case _AnnouncementDraft() when $default != null:
return $default(_that.title,_that.body,_that.channels,_that.targetType,_that.targetFarmId,_that.targetFilter);case _:
  return null;

}
}

}

/// @nodoc


class _AnnouncementDraft extends AnnouncementDraft {
  const _AnnouncementDraft({required this.title, required this.body, required  List<String> channels, required this.targetType, this.targetFarmId, this.targetFilter}): _channels = channels,super._();
  

@override final  String title;
@override final  String body;
 final  List<String> _channels;
@override List<String> get channels {
  if (_channels is EqualUnmodifiableListView) return _channels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_channels);
}

@override final  String targetType;
@override final  int? targetFarmId;
@override final  String? targetFilter;

/// Create a copy of AnnouncementDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementDraftCopyWith<_AnnouncementDraft> get copyWith => __$AnnouncementDraftCopyWithImpl<_AnnouncementDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.channels, _channels)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetFarmId, targetFarmId) || other.targetFarmId == targetFarmId)&&(identical(other.targetFilter, targetFilter) || other.targetFilter == targetFilter));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,body,const DeepCollectionEquality().hash(_channels),targetType,targetFarmId,targetFilter);
}

@override
String toString() {
    return 'AnnouncementDraft(title: $title, body: $body, channels: $channels, targetType: $targetType, targetFarmId: $targetFarmId, targetFilter: $targetFilter)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementDraftCopyWith<$Res> implements $AnnouncementDraftCopyWith<$Res> {
  factory _$AnnouncementDraftCopyWith(_AnnouncementDraft value, $Res Function(_AnnouncementDraft) _then) = __$AnnouncementDraftCopyWithImpl;
@override @useResult
$Res call({
 String title, String body, List<String> channels, String targetType, int? targetFarmId, String? targetFilter
});




}
/// @nodoc
class __$AnnouncementDraftCopyWithImpl<$Res>
    implements _$AnnouncementDraftCopyWith<$Res> {
  __$AnnouncementDraftCopyWithImpl(this._self, this._then);

  final _AnnouncementDraft _self;
  final $Res Function(_AnnouncementDraft) _then;

/// Create a copy of AnnouncementDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? body = null,Object? channels = null,Object? targetType = null,Object? targetFarmId = freezed,Object? targetFilter = freezed,}) {
  return _then(_AnnouncementDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,channels: null == channels ? _self._channels : channels // ignore: cast_nullable_to_non_nullable
as List<String>,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,targetFarmId: freezed == targetFarmId ? _self.targetFarmId : targetFarmId // ignore: cast_nullable_to_non_nullable
as int?,targetFilter: freezed == targetFilter ? _self.targetFilter : targetFilter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
