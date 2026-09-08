// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BreedModel {

@IntConverter() int get id; String get name; String? get description;@JsonKey(name: 'average_weight') double? get averageWeight;@JsonKey(name: 'average_litter_size')@IntConverter() int? get averageLitterSize; String? get purpose;@JsonKey(name: 'photo_url') String? get photoUrl;@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? get updatedAt;
/// Create a copy of BreedModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedModelCopyWith<BreedModel> get copyWith => _$BreedModelCopyWithImpl<BreedModel>(this as BreedModel, _$identity);

  /// Serializes this BreedModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BreedModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.averageWeight, _this.averageWeight) || other.averageWeight == _this.averageWeight)&&(identical(other.averageLitterSize, _this.averageLitterSize) || other.averageLitterSize == _this.averageLitterSize)&&(identical(other.purpose, _this.purpose) || other.purpose == _this.purpose)&&(identical(other.photoUrl, _this.photoUrl) || other.photoUrl == _this.photoUrl)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BreedModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.averageWeight,_this.averageLitterSize,_this.purpose,_this.photoUrl,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as BreedModel;
  return 'BreedModel(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, averageWeight: ${_this.averageWeight}, averageLitterSize: ${_this.averageLitterSize}, purpose: ${_this.purpose}, photoUrl: ${_this.photoUrl}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $BreedModelCopyWith<$Res>  {
  factory $BreedModelCopyWith(BreedModel value, $Res Function(BreedModel) _then) = _$BreedModelCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String name, String? description,@JsonKey(name: 'average_weight') double? averageWeight,@JsonKey(name: 'average_litter_size')@IntConverter() int? averageLitterSize, String? purpose,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$BreedModelCopyWithImpl<$Res>
    implements $BreedModelCopyWith<$Res> {
  _$BreedModelCopyWithImpl(this._self, this._then);

  final BreedModel _self;
  final $Res Function(BreedModel) _then;

/// Create a copy of BreedModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? averageWeight = freezed,Object? averageLitterSize = freezed,Object? purpose = freezed,Object? photoUrl = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(BreedModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,averageWeight: freezed == averageWeight ? _self.averageWeight : averageWeight // ignore: cast_nullable_to_non_nullable
as double?,averageLitterSize: freezed == averageLitterSize ? _self.averageLitterSize : averageLitterSize // ignore: cast_nullable_to_non_nullable
as int?,purpose: freezed == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BreedModel].
extension BreedModelPatterns on BreedModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreedModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreedModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreedModel value)  $default,){
final _that = this;
switch (_that) {
case _BreedModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreedModel value)?  $default,){
final _that = this;
switch (_that) {
case _BreedModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name,  String? description, @JsonKey(name: 'average_weight')  double? averageWeight, @JsonKey(name: 'average_litter_size')@IntConverter()  int? averageLitterSize,  String? purpose, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreedModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.averageWeight,_that.averageLitterSize,_that.purpose,_that.photoUrl,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name,  String? description, @JsonKey(name: 'average_weight')  double? averageWeight, @JsonKey(name: 'average_litter_size')@IntConverter()  int? averageLitterSize,  String? purpose, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BreedModel():
return $default(_that.id,_that.name,_that.description,_that.averageWeight,_that.averageLitterSize,_that.purpose,_that.photoUrl,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String name,  String? description, @JsonKey(name: 'average_weight')  double? averageWeight, @JsonKey(name: 'average_litter_size')@IntConverter()  int? averageLitterSize,  String? purpose, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BreedModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.averageWeight,_that.averageLitterSize,_that.purpose,_that.photoUrl,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BreedModel implements BreedModel {
  const _BreedModel({@IntConverter() required this.id, required this.name, this.description, @JsonKey(name: 'average_weight') this.averageWeight, @JsonKey(name: 'average_litter_size')@IntConverter() this.averageLitterSize, this.purpose, @JsonKey(name: 'photo_url') this.photoUrl, @JsonKey(name: 'created_at')@NullableDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter() this.updatedAt});
  factory _BreedModel.fromJson(Map<String, dynamic> json) => _$BreedModelFromJson(json);

@override@IntConverter() final  int id;
@override final  String name;
@override final  String? description;
@override@JsonKey(name: 'average_weight') final  double? averageWeight;
@override@JsonKey(name: 'average_litter_size')@IntConverter() final  int? averageLitterSize;
@override final  String? purpose;
@override@JsonKey(name: 'photo_url') final  String? photoUrl;
@override@JsonKey(name: 'created_at')@NullableDateTimeConverter() final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at')@NullableDateTimeConverter() final  DateTime? updatedAt;

/// Create a copy of BreedModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedModelCopyWith<_BreedModel> get copyWith => __$BreedModelCopyWithImpl<_BreedModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreedModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.averageWeight, averageWeight) || other.averageWeight == averageWeight)&&(identical(other.averageLitterSize, averageLitterSize) || other.averageLitterSize == averageLitterSize)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,averageWeight,averageLitterSize,purpose,photoUrl,createdAt,updatedAt);
}

@override
String toString() {
    return 'BreedModel(id: $id, name: $name, description: $description, averageWeight: $averageWeight, averageLitterSize: $averageLitterSize, purpose: $purpose, photoUrl: $photoUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BreedModelCopyWith<$Res> implements $BreedModelCopyWith<$Res> {
  factory _$BreedModelCopyWith(_BreedModel value, $Res Function(_BreedModel) _then) = __$BreedModelCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String name, String? description,@JsonKey(name: 'average_weight') double? averageWeight,@JsonKey(name: 'average_litter_size')@IntConverter() int? averageLitterSize, String? purpose,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$BreedModelCopyWithImpl<$Res>
    implements _$BreedModelCopyWith<$Res> {
  __$BreedModelCopyWithImpl(this._self, this._then);

  final _BreedModel _self;
  final $Res Function(_BreedModel) _then;

/// Create a copy of BreedModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? averageWeight = freezed,Object? averageLitterSize = freezed,Object? purpose = freezed,Object? photoUrl = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_BreedModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,averageWeight: freezed == averageWeight ? _self.averageWeight : averageWeight // ignore: cast_nullable_to_non_nullable
as double?,averageLitterSize: freezed == averageLitterSize ? _self.averageLitterSize : averageLitterSize // ignore: cast_nullable_to_non_nullable
as int?,purpose: freezed == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
