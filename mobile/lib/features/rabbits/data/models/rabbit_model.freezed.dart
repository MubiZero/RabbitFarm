// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rabbit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RabbitModel {

@IntConverter() int get id;/// Клеймо и кличка необязательны: в базе оба столбца допускают пустоту,
/// и сервер прямо разрешает завести кролика без них
/// (`rabbitValidator.js`: `.allow(null, '')`). Пока модель требовала обе,
/// один такой кролик ронял разбор всей страницы списка — вместе со
/// «Стадом», выпадающими полями форм и подбором пар.
@JsonKey(name: 'tag_id') String? get tagId; String? get name;@JsonKey(name: 'breed_id')@IntConverter() int get breedId; String get sex;@JsonKey(name: 'birth_date')@DateOnlyConverter() DateTime get birthDate; String? get color;@JsonKey(name: 'cage_id')@NullableIntConverter() int? get cageId;@JsonKey(name: 'father_id')@NullableIntConverter() int? get fatherId;@JsonKey(name: 'mother_id')@NullableIntConverter() int? get motherId; String get status; String get purpose;@JsonKey(name: 'acquired_date')@NullableDateOnlyConverter() DateTime? get acquiredDate;@JsonKey(name: 'sold_date')@NullableDateOnlyConverter() DateTime? get soldDate;@JsonKey(name: 'death_date')@NullableDateOnlyConverter() DateTime? get deathDate;@JsonKey(name: 'death_reason') String? get deathReason;@JsonKey(name: 'current_weight') double? get currentWeight; String? get temperament; String? get notes;@JsonKey(name: 'photo_url') String? get photoUrl;@JsonKey(name: 'created_at')@DateTimeConverter() DateTime get createdAt;@JsonKey(name: 'updated_at')@DateTimeConverter() DateTime get updatedAt;@JsonKey(name: 'breed') BreedModel? get breed;@JsonKey(name: 'Cage') CageInfo? get cage;@JsonKey(name: 'father') RabbitRef? get father;@JsonKey(name: 'mother') RabbitRef? get mother;
/// Create a copy of RabbitModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RabbitModelCopyWith<RabbitModel> get copyWith => _$RabbitModelCopyWithImpl<RabbitModel>(this as RabbitModel, _$identity);

  /// Serializes this RabbitModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RabbitModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RabbitModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.tagId, _this.tagId) || other.tagId == _this.tagId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.breedId, _this.breedId) || other.breedId == _this.breedId)&&(identical(other.sex, _this.sex) || other.sex == _this.sex)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.cageId, _this.cageId) || other.cageId == _this.cageId)&&(identical(other.fatherId, _this.fatherId) || other.fatherId == _this.fatherId)&&(identical(other.motherId, _this.motherId) || other.motherId == _this.motherId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.purpose, _this.purpose) || other.purpose == _this.purpose)&&(identical(other.acquiredDate, _this.acquiredDate) || other.acquiredDate == _this.acquiredDate)&&(identical(other.soldDate, _this.soldDate) || other.soldDate == _this.soldDate)&&(identical(other.deathDate, _this.deathDate) || other.deathDate == _this.deathDate)&&(identical(other.deathReason, _this.deathReason) || other.deathReason == _this.deathReason)&&(identical(other.currentWeight, _this.currentWeight) || other.currentWeight == _this.currentWeight)&&(identical(other.temperament, _this.temperament) || other.temperament == _this.temperament)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.photoUrl, _this.photoUrl) || other.photoUrl == _this.photoUrl)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.breed, _this.breed) || other.breed == _this.breed)&&(identical(other.cage, _this.cage) || other.cage == _this.cage)&&(identical(other.father, _this.father) || other.father == _this.father)&&(identical(other.mother, _this.mother) || other.mother == _this.mother));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RabbitModel;
  return Object.hashAll([runtimeType,_this.id,_this.tagId,_this.name,_this.breedId,_this.sex,_this.birthDate,_this.color,_this.cageId,_this.fatherId,_this.motherId,_this.status,_this.purpose,_this.acquiredDate,_this.soldDate,_this.deathDate,_this.deathReason,_this.currentWeight,_this.temperament,_this.notes,_this.photoUrl,_this.createdAt,_this.updatedAt,_this.breed,_this.cage,_this.father,_this.mother]);
}

@override
String toString() {
  final _this = this as RabbitModel;
  return 'RabbitModel(id: ${_this.id}, tagId: ${_this.tagId}, name: ${_this.name}, breedId: ${_this.breedId}, sex: ${_this.sex}, birthDate: ${_this.birthDate}, color: ${_this.color}, cageId: ${_this.cageId}, fatherId: ${_this.fatherId}, motherId: ${_this.motherId}, status: ${_this.status}, purpose: ${_this.purpose}, acquiredDate: ${_this.acquiredDate}, soldDate: ${_this.soldDate}, deathDate: ${_this.deathDate}, deathReason: ${_this.deathReason}, currentWeight: ${_this.currentWeight}, temperament: ${_this.temperament}, notes: ${_this.notes}, photoUrl: ${_this.photoUrl}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, breed: ${_this.breed}, cage: ${_this.cage}, father: ${_this.father}, mother: ${_this.mother})';
}


}

/// @nodoc
abstract mixin class $RabbitModelCopyWith<$Res>  {
  factory $RabbitModelCopyWith(RabbitModel value, $Res Function(RabbitModel) _then) = _$RabbitModelCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'tag_id') String? tagId, String? name,@JsonKey(name: 'breed_id')@IntConverter() int breedId, String sex,@JsonKey(name: 'birth_date')@DateOnlyConverter() DateTime birthDate, String? color,@JsonKey(name: 'cage_id')@NullableIntConverter() int? cageId,@JsonKey(name: 'father_id')@NullableIntConverter() int? fatherId,@JsonKey(name: 'mother_id')@NullableIntConverter() int? motherId, String status, String purpose,@JsonKey(name: 'acquired_date')@NullableDateOnlyConverter() DateTime? acquiredDate,@JsonKey(name: 'sold_date')@NullableDateOnlyConverter() DateTime? soldDate,@JsonKey(name: 'death_date')@NullableDateOnlyConverter() DateTime? deathDate,@JsonKey(name: 'death_reason') String? deathReason,@JsonKey(name: 'current_weight') double? currentWeight, String? temperament, String? notes,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt,@JsonKey(name: 'updated_at')@DateTimeConverter() DateTime updatedAt,@JsonKey(name: 'breed') BreedModel? breed,@JsonKey(name: 'Cage') CageInfo? cage,@JsonKey(name: 'father') RabbitRef? father,@JsonKey(name: 'mother') RabbitRef? mother
});


$BreedModelCopyWith<$Res>? get breed;$CageInfoCopyWith<$Res>? get cage;$RabbitRefCopyWith<$Res>? get father;$RabbitRefCopyWith<$Res>? get mother;

}
/// @nodoc
class _$RabbitModelCopyWithImpl<$Res>
    implements $RabbitModelCopyWith<$Res> {
  _$RabbitModelCopyWithImpl(this._self, this._then);

  final RabbitModel _self;
  final $Res Function(RabbitModel) _then;

/// Create a copy of RabbitModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tagId = freezed,Object? name = freezed,Object? breedId = null,Object? sex = null,Object? birthDate = null,Object? color = freezed,Object? cageId = freezed,Object? fatherId = freezed,Object? motherId = freezed,Object? status = null,Object? purpose = null,Object? acquiredDate = freezed,Object? soldDate = freezed,Object? deathDate = freezed,Object? deathReason = freezed,Object? currentWeight = freezed,Object? temperament = freezed,Object? notes = freezed,Object? photoUrl = freezed,Object? createdAt = null,Object? updatedAt = null,Object? breed = freezed,Object? cage = freezed,Object? father = freezed,Object? mother = freezed,}) {
  return _then(RabbitModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tagId: freezed == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,breedId: null == breedId ? _self.breedId : breedId // ignore: cast_nullable_to_non_nullable
as int,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,fatherId: freezed == fatherId ? _self.fatherId : fatherId // ignore: cast_nullable_to_non_nullable
as int?,motherId: freezed == motherId ? _self.motherId : motherId // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,acquiredDate: freezed == acquiredDate ? _self.acquiredDate : acquiredDate // ignore: cast_nullable_to_non_nullable
as DateTime?,soldDate: freezed == soldDate ? _self.soldDate : soldDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deathDate: freezed == deathDate ? _self.deathDate : deathDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deathReason: freezed == deathReason ? _self.deathReason : deathReason // ignore: cast_nullable_to_non_nullable
as String?,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,temperament: freezed == temperament ? _self.temperament : temperament // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,breed: freezed == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as BreedModel?,cage: freezed == cage ? _self.cage : cage // ignore: cast_nullable_to_non_nullable
as CageInfo?,father: freezed == father ? _self.father : father // ignore: cast_nullable_to_non_nullable
as RabbitRef?,mother: freezed == mother ? _self.mother : mother // ignore: cast_nullable_to_non_nullable
as RabbitRef?,
  ));
}
/// Create a copy of RabbitModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BreedModelCopyWith<$Res>? get breed {
    if (_self.breed == null) {
    return null;
  }

  return $BreedModelCopyWith<$Res>(_self.breed!, (value) {
    return _then(_self.copyWith(breed: value));
  });
}/// Create a copy of RabbitModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageInfoCopyWith<$Res>? get cage {
    if (_self.cage == null) {
    return null;
  }

  return $CageInfoCopyWith<$Res>(_self.cage!, (value) {
    return _then(_self.copyWith(cage: value));
  });
}/// Create a copy of RabbitModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitRefCopyWith<$Res>? get father {
    if (_self.father == null) {
    return null;
  }

  return $RabbitRefCopyWith<$Res>(_self.father!, (value) {
    return _then(_self.copyWith(father: value));
  });
}/// Create a copy of RabbitModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitRefCopyWith<$Res>? get mother {
    if (_self.mother == null) {
    return null;
  }

  return $RabbitRefCopyWith<$Res>(_self.mother!, (value) {
    return _then(_self.copyWith(mother: value));
  });
}
}


/// Adds pattern-matching-related methods to [RabbitModel].
extension RabbitModelPatterns on RabbitModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RabbitModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RabbitModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RabbitModel value)  $default,){
final _that = this;
switch (_that) {
case _RabbitModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RabbitModel value)?  $default,){
final _that = this;
switch (_that) {
case _RabbitModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'tag_id')  String? tagId,  String? name, @JsonKey(name: 'breed_id')@IntConverter()  int breedId,  String sex, @JsonKey(name: 'birth_date')@DateOnlyConverter()  DateTime birthDate,  String? color, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'father_id')@NullableIntConverter()  int? fatherId, @JsonKey(name: 'mother_id')@NullableIntConverter()  int? motherId,  String status,  String purpose, @JsonKey(name: 'acquired_date')@NullableDateOnlyConverter()  DateTime? acquiredDate, @JsonKey(name: 'sold_date')@NullableDateOnlyConverter()  DateTime? soldDate, @JsonKey(name: 'death_date')@NullableDateOnlyConverter()  DateTime? deathDate, @JsonKey(name: 'death_reason')  String? deathReason, @JsonKey(name: 'current_weight')  double? currentWeight,  String? temperament,  String? notes, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateTimeConverter()  DateTime updatedAt, @JsonKey(name: 'breed')  BreedModel? breed, @JsonKey(name: 'Cage')  CageInfo? cage, @JsonKey(name: 'father')  RabbitRef? father, @JsonKey(name: 'mother')  RabbitRef? mother)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RabbitModel() when $default != null:
return $default(_that.id,_that.tagId,_that.name,_that.breedId,_that.sex,_that.birthDate,_that.color,_that.cageId,_that.fatherId,_that.motherId,_that.status,_that.purpose,_that.acquiredDate,_that.soldDate,_that.deathDate,_that.deathReason,_that.currentWeight,_that.temperament,_that.notes,_that.photoUrl,_that.createdAt,_that.updatedAt,_that.breed,_that.cage,_that.father,_that.mother);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'tag_id')  String? tagId,  String? name, @JsonKey(name: 'breed_id')@IntConverter()  int breedId,  String sex, @JsonKey(name: 'birth_date')@DateOnlyConverter()  DateTime birthDate,  String? color, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'father_id')@NullableIntConverter()  int? fatherId, @JsonKey(name: 'mother_id')@NullableIntConverter()  int? motherId,  String status,  String purpose, @JsonKey(name: 'acquired_date')@NullableDateOnlyConverter()  DateTime? acquiredDate, @JsonKey(name: 'sold_date')@NullableDateOnlyConverter()  DateTime? soldDate, @JsonKey(name: 'death_date')@NullableDateOnlyConverter()  DateTime? deathDate, @JsonKey(name: 'death_reason')  String? deathReason, @JsonKey(name: 'current_weight')  double? currentWeight,  String? temperament,  String? notes, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateTimeConverter()  DateTime updatedAt, @JsonKey(name: 'breed')  BreedModel? breed, @JsonKey(name: 'Cage')  CageInfo? cage, @JsonKey(name: 'father')  RabbitRef? father, @JsonKey(name: 'mother')  RabbitRef? mother)  $default,) {final _that = this;
switch (_that) {
case _RabbitModel():
return $default(_that.id,_that.tagId,_that.name,_that.breedId,_that.sex,_that.birthDate,_that.color,_that.cageId,_that.fatherId,_that.motherId,_that.status,_that.purpose,_that.acquiredDate,_that.soldDate,_that.deathDate,_that.deathReason,_that.currentWeight,_that.temperament,_that.notes,_that.photoUrl,_that.createdAt,_that.updatedAt,_that.breed,_that.cage,_that.father,_that.mother);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id, @JsonKey(name: 'tag_id')  String? tagId,  String? name, @JsonKey(name: 'breed_id')@IntConverter()  int breedId,  String sex, @JsonKey(name: 'birth_date')@DateOnlyConverter()  DateTime birthDate,  String? color, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'father_id')@NullableIntConverter()  int? fatherId, @JsonKey(name: 'mother_id')@NullableIntConverter()  int? motherId,  String status,  String purpose, @JsonKey(name: 'acquired_date')@NullableDateOnlyConverter()  DateTime? acquiredDate, @JsonKey(name: 'sold_date')@NullableDateOnlyConverter()  DateTime? soldDate, @JsonKey(name: 'death_date')@NullableDateOnlyConverter()  DateTime? deathDate, @JsonKey(name: 'death_reason')  String? deathReason, @JsonKey(name: 'current_weight')  double? currentWeight,  String? temperament,  String? notes, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateTimeConverter()  DateTime updatedAt, @JsonKey(name: 'breed')  BreedModel? breed, @JsonKey(name: 'Cage')  CageInfo? cage, @JsonKey(name: 'father')  RabbitRef? father, @JsonKey(name: 'mother')  RabbitRef? mother)?  $default,) {final _that = this;
switch (_that) {
case _RabbitModel() when $default != null:
return $default(_that.id,_that.tagId,_that.name,_that.breedId,_that.sex,_that.birthDate,_that.color,_that.cageId,_that.fatherId,_that.motherId,_that.status,_that.purpose,_that.acquiredDate,_that.soldDate,_that.deathDate,_that.deathReason,_that.currentWeight,_that.temperament,_that.notes,_that.photoUrl,_that.createdAt,_that.updatedAt,_that.breed,_that.cage,_that.father,_that.mother);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RabbitModel extends RabbitModel {
  const _RabbitModel({@IntConverter() required this.id, @JsonKey(name: 'tag_id') this.tagId, this.name, @JsonKey(name: 'breed_id')@IntConverter() required this.breedId, required this.sex, @JsonKey(name: 'birth_date')@DateOnlyConverter() required this.birthDate, this.color, @JsonKey(name: 'cage_id')@NullableIntConverter() this.cageId, @JsonKey(name: 'father_id')@NullableIntConverter() this.fatherId, @JsonKey(name: 'mother_id')@NullableIntConverter() this.motherId, required this.status, required this.purpose, @JsonKey(name: 'acquired_date')@NullableDateOnlyConverter() this.acquiredDate, @JsonKey(name: 'sold_date')@NullableDateOnlyConverter() this.soldDate, @JsonKey(name: 'death_date')@NullableDateOnlyConverter() this.deathDate, @JsonKey(name: 'death_reason') this.deathReason, @JsonKey(name: 'current_weight') this.currentWeight, this.temperament, this.notes, @JsonKey(name: 'photo_url') this.photoUrl, @JsonKey(name: 'created_at')@DateTimeConverter() required this.createdAt, @JsonKey(name: 'updated_at')@DateTimeConverter() required this.updatedAt, @JsonKey(name: 'breed') this.breed, @JsonKey(name: 'Cage') this.cage, @JsonKey(name: 'father') this.father, @JsonKey(name: 'mother') this.mother}): super._();
  factory _RabbitModel.fromJson(Map<String, dynamic> json) => _$RabbitModelFromJson(json);

@override@IntConverter() final  int id;
/// Клеймо и кличка необязательны: в базе оба столбца допускают пустоту,
/// и сервер прямо разрешает завести кролика без них
/// (`rabbitValidator.js`: `.allow(null, '')`). Пока модель требовала обе,
/// один такой кролик ронял разбор всей страницы списка — вместе со
/// «Стадом», выпадающими полями форм и подбором пар.
@override@JsonKey(name: 'tag_id') final  String? tagId;
@override final  String? name;
@override@JsonKey(name: 'breed_id')@IntConverter() final  int breedId;
@override final  String sex;
@override@JsonKey(name: 'birth_date')@DateOnlyConverter() final  DateTime birthDate;
@override final  String? color;
@override@JsonKey(name: 'cage_id')@NullableIntConverter() final  int? cageId;
@override@JsonKey(name: 'father_id')@NullableIntConverter() final  int? fatherId;
@override@JsonKey(name: 'mother_id')@NullableIntConverter() final  int? motherId;
@override final  String status;
@override final  String purpose;
@override@JsonKey(name: 'acquired_date')@NullableDateOnlyConverter() final  DateTime? acquiredDate;
@override@JsonKey(name: 'sold_date')@NullableDateOnlyConverter() final  DateTime? soldDate;
@override@JsonKey(name: 'death_date')@NullableDateOnlyConverter() final  DateTime? deathDate;
@override@JsonKey(name: 'death_reason') final  String? deathReason;
@override@JsonKey(name: 'current_weight') final  double? currentWeight;
@override final  String? temperament;
@override final  String? notes;
@override@JsonKey(name: 'photo_url') final  String? photoUrl;
@override@JsonKey(name: 'created_at')@DateTimeConverter() final  DateTime createdAt;
@override@JsonKey(name: 'updated_at')@DateTimeConverter() final  DateTime updatedAt;
@override@JsonKey(name: 'breed') final  BreedModel? breed;
@override@JsonKey(name: 'Cage') final  CageInfo? cage;
@override@JsonKey(name: 'father') final  RabbitRef? father;
@override@JsonKey(name: 'mother') final  RabbitRef? mother;

/// Create a copy of RabbitModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RabbitModelCopyWith<_RabbitModel> get copyWith => __$RabbitModelCopyWithImpl<_RabbitModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RabbitModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RabbitModel&&(identical(other.id, id) || other.id == id)&&(identical(other.tagId, tagId) || other.tagId == tagId)&&(identical(other.name, name) || other.name == name)&&(identical(other.breedId, breedId) || other.breedId == breedId)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.color, color) || other.color == color)&&(identical(other.cageId, cageId) || other.cageId == cageId)&&(identical(other.fatherId, fatherId) || other.fatherId == fatherId)&&(identical(other.motherId, motherId) || other.motherId == motherId)&&(identical(other.status, status) || other.status == status)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.acquiredDate, acquiredDate) || other.acquiredDate == acquiredDate)&&(identical(other.soldDate, soldDate) || other.soldDate == soldDate)&&(identical(other.deathDate, deathDate) || other.deathDate == deathDate)&&(identical(other.deathReason, deathReason) || other.deathReason == deathReason)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.temperament, temperament) || other.temperament == temperament)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.cage, cage) || other.cage == cage)&&(identical(other.father, father) || other.father == father)&&(identical(other.mother, mother) || other.mother == mother));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,tagId,name,breedId,sex,birthDate,color,cageId,fatherId,motherId,status,purpose,acquiredDate,soldDate,deathDate,deathReason,currentWeight,temperament,notes,photoUrl,createdAt,updatedAt,breed,cage,father,mother]);
}

@override
String toString() {
    return 'RabbitModel(id: $id, tagId: $tagId, name: $name, breedId: $breedId, sex: $sex, birthDate: $birthDate, color: $color, cageId: $cageId, fatherId: $fatherId, motherId: $motherId, status: $status, purpose: $purpose, acquiredDate: $acquiredDate, soldDate: $soldDate, deathDate: $deathDate, deathReason: $deathReason, currentWeight: $currentWeight, temperament: $temperament, notes: $notes, photoUrl: $photoUrl, createdAt: $createdAt, updatedAt: $updatedAt, breed: $breed, cage: $cage, father: $father, mother: $mother)';
}


}

/// @nodoc
abstract mixin class _$RabbitModelCopyWith<$Res> implements $RabbitModelCopyWith<$Res> {
  factory _$RabbitModelCopyWith(_RabbitModel value, $Res Function(_RabbitModel) _then) = __$RabbitModelCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'tag_id') String? tagId, String? name,@JsonKey(name: 'breed_id')@IntConverter() int breedId, String sex,@JsonKey(name: 'birth_date')@DateOnlyConverter() DateTime birthDate, String? color,@JsonKey(name: 'cage_id')@NullableIntConverter() int? cageId,@JsonKey(name: 'father_id')@NullableIntConverter() int? fatherId,@JsonKey(name: 'mother_id')@NullableIntConverter() int? motherId, String status, String purpose,@JsonKey(name: 'acquired_date')@NullableDateOnlyConverter() DateTime? acquiredDate,@JsonKey(name: 'sold_date')@NullableDateOnlyConverter() DateTime? soldDate,@JsonKey(name: 'death_date')@NullableDateOnlyConverter() DateTime? deathDate,@JsonKey(name: 'death_reason') String? deathReason,@JsonKey(name: 'current_weight') double? currentWeight, String? temperament, String? notes,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt,@JsonKey(name: 'updated_at')@DateTimeConverter() DateTime updatedAt,@JsonKey(name: 'breed') BreedModel? breed,@JsonKey(name: 'Cage') CageInfo? cage,@JsonKey(name: 'father') RabbitRef? father,@JsonKey(name: 'mother') RabbitRef? mother
});


@override $BreedModelCopyWith<$Res>? get breed;@override $CageInfoCopyWith<$Res>? get cage;@override $RabbitRefCopyWith<$Res>? get father;@override $RabbitRefCopyWith<$Res>? get mother;

}
/// @nodoc
class __$RabbitModelCopyWithImpl<$Res>
    implements _$RabbitModelCopyWith<$Res> {
  __$RabbitModelCopyWithImpl(this._self, this._then);

  final _RabbitModel _self;
  final $Res Function(_RabbitModel) _then;

/// Create a copy of RabbitModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tagId = freezed,Object? name = freezed,Object? breedId = null,Object? sex = null,Object? birthDate = null,Object? color = freezed,Object? cageId = freezed,Object? fatherId = freezed,Object? motherId = freezed,Object? status = null,Object? purpose = null,Object? acquiredDate = freezed,Object? soldDate = freezed,Object? deathDate = freezed,Object? deathReason = freezed,Object? currentWeight = freezed,Object? temperament = freezed,Object? notes = freezed,Object? photoUrl = freezed,Object? createdAt = null,Object? updatedAt = null,Object? breed = freezed,Object? cage = freezed,Object? father = freezed,Object? mother = freezed,}) {
  return _then(_RabbitModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tagId: freezed == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,breedId: null == breedId ? _self.breedId : breedId // ignore: cast_nullable_to_non_nullable
as int,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,fatherId: freezed == fatherId ? _self.fatherId : fatherId // ignore: cast_nullable_to_non_nullable
as int?,motherId: freezed == motherId ? _self.motherId : motherId // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,acquiredDate: freezed == acquiredDate ? _self.acquiredDate : acquiredDate // ignore: cast_nullable_to_non_nullable
as DateTime?,soldDate: freezed == soldDate ? _self.soldDate : soldDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deathDate: freezed == deathDate ? _self.deathDate : deathDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deathReason: freezed == deathReason ? _self.deathReason : deathReason // ignore: cast_nullable_to_non_nullable
as String?,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,temperament: freezed == temperament ? _self.temperament : temperament // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,breed: freezed == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as BreedModel?,cage: freezed == cage ? _self.cage : cage // ignore: cast_nullable_to_non_nullable
as CageInfo?,father: freezed == father ? _self.father : father // ignore: cast_nullable_to_non_nullable
as RabbitRef?,mother: freezed == mother ? _self.mother : mother // ignore: cast_nullable_to_non_nullable
as RabbitRef?,
  ));
}

/// Create a copy of RabbitModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BreedModelCopyWith<$Res>? get breed {
    if (_self.breed == null) {
    return null;
  }

  return $BreedModelCopyWith<$Res>(_self.breed!, (value) {
    return _then(_self.copyWith(breed: value));
  });
}/// Create a copy of RabbitModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageInfoCopyWith<$Res>? get cage {
    if (_self.cage == null) {
    return null;
  }

  return $CageInfoCopyWith<$Res>(_self.cage!, (value) {
    return _then(_self.copyWith(cage: value));
  });
}/// Create a copy of RabbitModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitRefCopyWith<$Res>? get father {
    if (_self.father == null) {
    return null;
  }

  return $RabbitRefCopyWith<$Res>(_self.father!, (value) {
    return _then(_self.copyWith(father: value));
  });
}/// Create a copy of RabbitModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitRefCopyWith<$Res>? get mother {
    if (_self.mother == null) {
    return null;
  }

  return $RabbitRefCopyWith<$Res>(_self.mother!, (value) {
    return _then(_self.copyWith(mother: value));
  });
}
}


/// @nodoc
mixin _$CageInfo {

@IntConverter() int get id; String get number; String? get type; String? get location;
/// Create a copy of CageInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CageInfoCopyWith<CageInfo> get copyWith => _$CageInfoCopyWithImpl<CageInfo>(this as CageInfo, _$identity);

  /// Serializes this CageInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CageInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CageInfo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.location, _this.location) || other.location == _this.location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CageInfo;
  return Object.hash(runtimeType,_this.id,_this.number,_this.type,_this.location);
}

@override
String toString() {
  final _this = this as CageInfo;
  return 'CageInfo(id: ${_this.id}, number: ${_this.number}, type: ${_this.type}, location: ${_this.location})';
}


}

/// @nodoc
abstract mixin class $CageInfoCopyWith<$Res>  {
  factory $CageInfoCopyWith(CageInfo value, $Res Function(CageInfo) _then) = _$CageInfoCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String number, String? type, String? location
});




}
/// @nodoc
class _$CageInfoCopyWithImpl<$Res>
    implements $CageInfoCopyWith<$Res> {
  _$CageInfoCopyWithImpl(this._self, this._then);

  final CageInfo _self;
  final $Res Function(CageInfo) _then;

/// Create a copy of CageInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? type = freezed,Object? location = freezed,}) {
  return _then(CageInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CageInfo].
extension CageInfoPatterns on CageInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CageInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CageInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CageInfo value)  $default,){
final _that = this;
switch (_that) {
case _CageInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CageInfo value)?  $default,){
final _that = this;
switch (_that) {
case _CageInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String number,  String? type,  String? location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CageInfo() when $default != null:
return $default(_that.id,_that.number,_that.type,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String number,  String? type,  String? location)  $default,) {final _that = this;
switch (_that) {
case _CageInfo():
return $default(_that.id,_that.number,_that.type,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String number,  String? type,  String? location)?  $default,) {final _that = this;
switch (_that) {
case _CageInfo() when $default != null:
return $default(_that.id,_that.number,_that.type,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CageInfo implements CageInfo {
  const _CageInfo({@IntConverter() required this.id, required this.number, this.type, this.location});
  factory _CageInfo.fromJson(Map<String, dynamic> json) => _$CageInfoFromJson(json);

@override@IntConverter() final  int id;
@override final  String number;
@override final  String? type;
@override final  String? location;

/// Create a copy of CageInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CageInfoCopyWith<_CageInfo> get copyWith => __$CageInfoCopyWithImpl<_CageInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CageInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CageInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.type, type) || other.type == type)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,number,type,location);
}

@override
String toString() {
    return 'CageInfo(id: $id, number: $number, type: $type, location: $location)';
}


}

/// @nodoc
abstract mixin class _$CageInfoCopyWith<$Res> implements $CageInfoCopyWith<$Res> {
  factory _$CageInfoCopyWith(_CageInfo value, $Res Function(_CageInfo) _then) = __$CageInfoCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String number, String? type, String? location
});




}
/// @nodoc
class __$CageInfoCopyWithImpl<$Res>
    implements _$CageInfoCopyWith<$Res> {
  __$CageInfoCopyWithImpl(this._self, this._then);

  final _CageInfo _self;
  final $Res Function(_CageInfo) _then;

/// Create a copy of CageInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? type = freezed,Object? location = freezed,}) {
  return _then(_CageInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RabbitRef {

@IntConverter() int get id; String? get name;@JsonKey(name: 'tag_id') String? get tagId;
/// Create a copy of RabbitRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RabbitRefCopyWith<RabbitRef> get copyWith => _$RabbitRefCopyWithImpl<RabbitRef>(this as RabbitRef, _$identity);

  /// Serializes this RabbitRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RabbitRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RabbitRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.tagId, _this.tagId) || other.tagId == _this.tagId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RabbitRef;
  return Object.hash(runtimeType,_this.id,_this.name,_this.tagId);
}

@override
String toString() {
  final _this = this as RabbitRef;
  return 'RabbitRef(id: ${_this.id}, name: ${_this.name}, tagId: ${_this.tagId})';
}


}

/// @nodoc
abstract mixin class $RabbitRefCopyWith<$Res>  {
  factory $RabbitRefCopyWith(RabbitRef value, $Res Function(RabbitRef) _then) = _$RabbitRefCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String? name,@JsonKey(name: 'tag_id') String? tagId
});




}
/// @nodoc
class _$RabbitRefCopyWithImpl<$Res>
    implements $RabbitRefCopyWith<$Res> {
  _$RabbitRefCopyWithImpl(this._self, this._then);

  final RabbitRef _self;
  final $Res Function(RabbitRef) _then;

/// Create a copy of RabbitRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? tagId = freezed,}) {
  return _then(RabbitRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,tagId: freezed == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RabbitRef].
extension RabbitRefPatterns on RabbitRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RabbitRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RabbitRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RabbitRef value)  $default,){
final _that = this;
switch (_that) {
case _RabbitRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RabbitRef value)?  $default,){
final _that = this;
switch (_that) {
case _RabbitRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String? name, @JsonKey(name: 'tag_id')  String? tagId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RabbitRef() when $default != null:
return $default(_that.id,_that.name,_that.tagId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String? name, @JsonKey(name: 'tag_id')  String? tagId)  $default,) {final _that = this;
switch (_that) {
case _RabbitRef():
return $default(_that.id,_that.name,_that.tagId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String? name, @JsonKey(name: 'tag_id')  String? tagId)?  $default,) {final _that = this;
switch (_that) {
case _RabbitRef() when $default != null:
return $default(_that.id,_that.name,_that.tagId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RabbitRef extends RabbitRef {
  const _RabbitRef({@IntConverter() required this.id, this.name, @JsonKey(name: 'tag_id') this.tagId}): super._();
  factory _RabbitRef.fromJson(Map<String, dynamic> json) => _$RabbitRefFromJson(json);

@override@IntConverter() final  int id;
@override final  String? name;
@override@JsonKey(name: 'tag_id') final  String? tagId;

/// Create a copy of RabbitRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RabbitRefCopyWith<_RabbitRef> get copyWith => __$RabbitRefCopyWithImpl<_RabbitRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RabbitRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RabbitRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.tagId, tagId) || other.tagId == tagId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,tagId);
}

@override
String toString() {
    return 'RabbitRef(id: $id, name: $name, tagId: $tagId)';
}


}

/// @nodoc
abstract mixin class _$RabbitRefCopyWith<$Res> implements $RabbitRefCopyWith<$Res> {
  factory _$RabbitRefCopyWith(_RabbitRef value, $Res Function(_RabbitRef) _then) = __$RabbitRefCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String? name,@JsonKey(name: 'tag_id') String? tagId
});




}
/// @nodoc
class __$RabbitRefCopyWithImpl<$Res>
    implements _$RabbitRefCopyWith<$Res> {
  __$RabbitRefCopyWithImpl(this._self, this._then);

  final _RabbitRef _self;
  final $Res Function(_RabbitRef) _then;

/// Create a copy of RabbitRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? tagId = freezed,}) {
  return _then(_RabbitRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,tagId: freezed == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
