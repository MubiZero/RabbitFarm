// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rabbit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RabbitModel _$RabbitModelFromJson(Map<String, dynamic> json) {
  return _RabbitModel.fromJson(json);
}

/// @nodoc
mixin _$RabbitModel {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;

  /// Клеймо и кличка необязательны: в базе оба столбца допускают пустоту,
  /// и сервер прямо разрешает завести кролика без них
  /// (`rabbitValidator.js`: `.allow(null, '')`). Пока модель требовала обе,
  /// один такой кролик ронял разбор всей страницы списка — вместе со
  /// «Стадом», выпадающими полями форм и подбором пар.
  @JsonKey(name: 'tag_id')
  String? get tagId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'breed_id')
  @IntConverter()
  int get breedId => throw _privateConstructorUsedError;
  String get sex => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  @DateOnlyConverter()
  DateTime get birthDate => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  int? get cageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'father_id')
  @NullableIntConverter()
  int? get fatherId => throw _privateConstructorUsedError;
  @JsonKey(name: 'mother_id')
  @NullableIntConverter()
  int? get motherId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get purpose => throw _privateConstructorUsedError;
  @JsonKey(name: 'acquired_date')
  @NullableDateOnlyConverter()
  DateTime? get acquiredDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'sold_date')
  @NullableDateOnlyConverter()
  DateTime? get soldDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'death_date')
  @NullableDateOnlyConverter()
  DateTime? get deathDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'death_reason')
  String? get deathReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_weight')
  double? get currentWeight => throw _privateConstructorUsedError;
  String? get temperament => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  @DateTimeConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError; // Relations
  @JsonKey(name: 'breed')
  BreedModel? get breed => throw _privateConstructorUsedError;
  @JsonKey(name: 'Cage')
  CageInfo? get cage => throw _privateConstructorUsedError;
  @JsonKey(name: 'father')
  RabbitRef? get father => throw _privateConstructorUsedError;
  @JsonKey(name: 'mother')
  RabbitRef? get mother => throw _privateConstructorUsedError;

  /// Serializes this RabbitModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RabbitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RabbitModelCopyWith<RabbitModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RabbitModelCopyWith<$Res> {
  factory $RabbitModelCopyWith(
    RabbitModel value,
    $Res Function(RabbitModel) then,
  ) = _$RabbitModelCopyWithImpl<$Res, RabbitModel>;
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'tag_id') String? tagId,
    String? name,
    @JsonKey(name: 'breed_id') @IntConverter() int breedId,
    String sex,
    @JsonKey(name: 'birth_date') @DateOnlyConverter() DateTime birthDate,
    String? color,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'father_id') @NullableIntConverter() int? fatherId,
    @JsonKey(name: 'mother_id') @NullableIntConverter() int? motherId,
    String status,
    String purpose,
    @JsonKey(name: 'acquired_date')
    @NullableDateOnlyConverter()
    DateTime? acquiredDate,
    @JsonKey(name: 'sold_date') @NullableDateOnlyConverter() DateTime? soldDate,
    @JsonKey(name: 'death_date')
    @NullableDateOnlyConverter()
    DateTime? deathDate,
    @JsonKey(name: 'death_reason') String? deathReason,
    @JsonKey(name: 'current_weight') double? currentWeight,
    String? temperament,
    String? notes,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'created_at') @DateTimeConverter() DateTime createdAt,
    @JsonKey(name: 'updated_at') @DateTimeConverter() DateTime updatedAt,
    @JsonKey(name: 'breed') BreedModel? breed,
    @JsonKey(name: 'Cage') CageInfo? cage,
    @JsonKey(name: 'father') RabbitRef? father,
    @JsonKey(name: 'mother') RabbitRef? mother,
  });

  $BreedModelCopyWith<$Res>? get breed;
  $CageInfoCopyWith<$Res>? get cage;
  $RabbitRefCopyWith<$Res>? get father;
  $RabbitRefCopyWith<$Res>? get mother;
}

/// @nodoc
class _$RabbitModelCopyWithImpl<$Res, $Val extends RabbitModel>
    implements $RabbitModelCopyWith<$Res> {
  _$RabbitModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RabbitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tagId = freezed,
    Object? name = freezed,
    Object? breedId = null,
    Object? sex = null,
    Object? birthDate = null,
    Object? color = freezed,
    Object? cageId = freezed,
    Object? fatherId = freezed,
    Object? motherId = freezed,
    Object? status = null,
    Object? purpose = null,
    Object? acquiredDate = freezed,
    Object? soldDate = freezed,
    Object? deathDate = freezed,
    Object? deathReason = freezed,
    Object? currentWeight = freezed,
    Object? temperament = freezed,
    Object? notes = freezed,
    Object? photoUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? breed = freezed,
    Object? cage = freezed,
    Object? father = freezed,
    Object? mother = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            tagId: freezed == tagId
                ? _value.tagId
                : tagId // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            breedId: null == breedId
                ? _value.breedId
                : breedId // ignore: cast_nullable_to_non_nullable
                      as int,
            sex: null == sex
                ? _value.sex
                : sex // ignore: cast_nullable_to_non_nullable
                      as String,
            birthDate: null == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            cageId: freezed == cageId
                ? _value.cageId
                : cageId // ignore: cast_nullable_to_non_nullable
                      as int?,
            fatherId: freezed == fatherId
                ? _value.fatherId
                : fatherId // ignore: cast_nullable_to_non_nullable
                      as int?,
            motherId: freezed == motherId
                ? _value.motherId
                : motherId // ignore: cast_nullable_to_non_nullable
                      as int?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            purpose: null == purpose
                ? _value.purpose
                : purpose // ignore: cast_nullable_to_non_nullable
                      as String,
            acquiredDate: freezed == acquiredDate
                ? _value.acquiredDate
                : acquiredDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            soldDate: freezed == soldDate
                ? _value.soldDate
                : soldDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deathDate: freezed == deathDate
                ? _value.deathDate
                : deathDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deathReason: freezed == deathReason
                ? _value.deathReason
                : deathReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentWeight: freezed == currentWeight
                ? _value.currentWeight
                : currentWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            temperament: freezed == temperament
                ? _value.temperament
                : temperament // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            breed: freezed == breed
                ? _value.breed
                : breed // ignore: cast_nullable_to_non_nullable
                      as BreedModel?,
            cage: freezed == cage
                ? _value.cage
                : cage // ignore: cast_nullable_to_non_nullable
                      as CageInfo?,
            father: freezed == father
                ? _value.father
                : father // ignore: cast_nullable_to_non_nullable
                      as RabbitRef?,
            mother: freezed == mother
                ? _value.mother
                : mother // ignore: cast_nullable_to_non_nullable
                      as RabbitRef?,
          )
          as $Val,
    );
  }

  /// Create a copy of RabbitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BreedModelCopyWith<$Res>? get breed {
    if (_value.breed == null) {
      return null;
    }

    return $BreedModelCopyWith<$Res>(_value.breed!, (value) {
      return _then(_value.copyWith(breed: value) as $Val);
    });
  }

  /// Create a copy of RabbitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CageInfoCopyWith<$Res>? get cage {
    if (_value.cage == null) {
      return null;
    }

    return $CageInfoCopyWith<$Res>(_value.cage!, (value) {
      return _then(_value.copyWith(cage: value) as $Val);
    });
  }

  /// Create a copy of RabbitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RabbitRefCopyWith<$Res>? get father {
    if (_value.father == null) {
      return null;
    }

    return $RabbitRefCopyWith<$Res>(_value.father!, (value) {
      return _then(_value.copyWith(father: value) as $Val);
    });
  }

  /// Create a copy of RabbitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RabbitRefCopyWith<$Res>? get mother {
    if (_value.mother == null) {
      return null;
    }

    return $RabbitRefCopyWith<$Res>(_value.mother!, (value) {
      return _then(_value.copyWith(mother: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RabbitModelImplCopyWith<$Res>
    implements $RabbitModelCopyWith<$Res> {
  factory _$$RabbitModelImplCopyWith(
    _$RabbitModelImpl value,
    $Res Function(_$RabbitModelImpl) then,
  ) = __$$RabbitModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'tag_id') String? tagId,
    String? name,
    @JsonKey(name: 'breed_id') @IntConverter() int breedId,
    String sex,
    @JsonKey(name: 'birth_date') @DateOnlyConverter() DateTime birthDate,
    String? color,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'father_id') @NullableIntConverter() int? fatherId,
    @JsonKey(name: 'mother_id') @NullableIntConverter() int? motherId,
    String status,
    String purpose,
    @JsonKey(name: 'acquired_date')
    @NullableDateOnlyConverter()
    DateTime? acquiredDate,
    @JsonKey(name: 'sold_date') @NullableDateOnlyConverter() DateTime? soldDate,
    @JsonKey(name: 'death_date')
    @NullableDateOnlyConverter()
    DateTime? deathDate,
    @JsonKey(name: 'death_reason') String? deathReason,
    @JsonKey(name: 'current_weight') double? currentWeight,
    String? temperament,
    String? notes,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'created_at') @DateTimeConverter() DateTime createdAt,
    @JsonKey(name: 'updated_at') @DateTimeConverter() DateTime updatedAt,
    @JsonKey(name: 'breed') BreedModel? breed,
    @JsonKey(name: 'Cage') CageInfo? cage,
    @JsonKey(name: 'father') RabbitRef? father,
    @JsonKey(name: 'mother') RabbitRef? mother,
  });

  @override
  $BreedModelCopyWith<$Res>? get breed;
  @override
  $CageInfoCopyWith<$Res>? get cage;
  @override
  $RabbitRefCopyWith<$Res>? get father;
  @override
  $RabbitRefCopyWith<$Res>? get mother;
}

/// @nodoc
class __$$RabbitModelImplCopyWithImpl<$Res>
    extends _$RabbitModelCopyWithImpl<$Res, _$RabbitModelImpl>
    implements _$$RabbitModelImplCopyWith<$Res> {
  __$$RabbitModelImplCopyWithImpl(
    _$RabbitModelImpl _value,
    $Res Function(_$RabbitModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RabbitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tagId = freezed,
    Object? name = freezed,
    Object? breedId = null,
    Object? sex = null,
    Object? birthDate = null,
    Object? color = freezed,
    Object? cageId = freezed,
    Object? fatherId = freezed,
    Object? motherId = freezed,
    Object? status = null,
    Object? purpose = null,
    Object? acquiredDate = freezed,
    Object? soldDate = freezed,
    Object? deathDate = freezed,
    Object? deathReason = freezed,
    Object? currentWeight = freezed,
    Object? temperament = freezed,
    Object? notes = freezed,
    Object? photoUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? breed = freezed,
    Object? cage = freezed,
    Object? father = freezed,
    Object? mother = freezed,
  }) {
    return _then(
      _$RabbitModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        tagId: freezed == tagId
            ? _value.tagId
            : tagId // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        breedId: null == breedId
            ? _value.breedId
            : breedId // ignore: cast_nullable_to_non_nullable
                  as int,
        sex: null == sex
            ? _value.sex
            : sex // ignore: cast_nullable_to_non_nullable
                  as String,
        birthDate: null == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        cageId: freezed == cageId
            ? _value.cageId
            : cageId // ignore: cast_nullable_to_non_nullable
                  as int?,
        fatherId: freezed == fatherId
            ? _value.fatherId
            : fatherId // ignore: cast_nullable_to_non_nullable
                  as int?,
        motherId: freezed == motherId
            ? _value.motherId
            : motherId // ignore: cast_nullable_to_non_nullable
                  as int?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        purpose: null == purpose
            ? _value.purpose
            : purpose // ignore: cast_nullable_to_non_nullable
                  as String,
        acquiredDate: freezed == acquiredDate
            ? _value.acquiredDate
            : acquiredDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        soldDate: freezed == soldDate
            ? _value.soldDate
            : soldDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deathDate: freezed == deathDate
            ? _value.deathDate
            : deathDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deathReason: freezed == deathReason
            ? _value.deathReason
            : deathReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentWeight: freezed == currentWeight
            ? _value.currentWeight
            : currentWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        temperament: freezed == temperament
            ? _value.temperament
            : temperament // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        breed: freezed == breed
            ? _value.breed
            : breed // ignore: cast_nullable_to_non_nullable
                  as BreedModel?,
        cage: freezed == cage
            ? _value.cage
            : cage // ignore: cast_nullable_to_non_nullable
                  as CageInfo?,
        father: freezed == father
            ? _value.father
            : father // ignore: cast_nullable_to_non_nullable
                  as RabbitRef?,
        mother: freezed == mother
            ? _value.mother
            : mother // ignore: cast_nullable_to_non_nullable
                  as RabbitRef?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RabbitModelImpl extends _RabbitModel {
  const _$RabbitModelImpl({
    @IntConverter() required this.id,
    @JsonKey(name: 'tag_id') this.tagId,
    this.name,
    @JsonKey(name: 'breed_id') @IntConverter() required this.breedId,
    required this.sex,
    @JsonKey(name: 'birth_date') @DateOnlyConverter() required this.birthDate,
    this.color,
    @JsonKey(name: 'cage_id') @NullableIntConverter() this.cageId,
    @JsonKey(name: 'father_id') @NullableIntConverter() this.fatherId,
    @JsonKey(name: 'mother_id') @NullableIntConverter() this.motherId,
    required this.status,
    required this.purpose,
    @JsonKey(name: 'acquired_date')
    @NullableDateOnlyConverter()
    this.acquiredDate,
    @JsonKey(name: 'sold_date') @NullableDateOnlyConverter() this.soldDate,
    @JsonKey(name: 'death_date') @NullableDateOnlyConverter() this.deathDate,
    @JsonKey(name: 'death_reason') this.deathReason,
    @JsonKey(name: 'current_weight') this.currentWeight,
    this.temperament,
    this.notes,
    @JsonKey(name: 'photo_url') this.photoUrl,
    @JsonKey(name: 'created_at') @DateTimeConverter() required this.createdAt,
    @JsonKey(name: 'updated_at') @DateTimeConverter() required this.updatedAt,
    @JsonKey(name: 'breed') this.breed,
    @JsonKey(name: 'Cage') this.cage,
    @JsonKey(name: 'father') this.father,
    @JsonKey(name: 'mother') this.mother,
  }) : super._();

  factory _$RabbitModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RabbitModelImplFromJson(json);

  @override
  @IntConverter()
  final int id;

  /// Клеймо и кличка необязательны: в базе оба столбца допускают пустоту,
  /// и сервер прямо разрешает завести кролика без них
  /// (`rabbitValidator.js`: `.allow(null, '')`). Пока модель требовала обе,
  /// один такой кролик ронял разбор всей страницы списка — вместе со
  /// «Стадом», выпадающими полями форм и подбором пар.
  @override
  @JsonKey(name: 'tag_id')
  final String? tagId;
  @override
  final String? name;
  @override
  @JsonKey(name: 'breed_id')
  @IntConverter()
  final int breedId;
  @override
  final String sex;
  @override
  @JsonKey(name: 'birth_date')
  @DateOnlyConverter()
  final DateTime birthDate;
  @override
  final String? color;
  @override
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  final int? cageId;
  @override
  @JsonKey(name: 'father_id')
  @NullableIntConverter()
  final int? fatherId;
  @override
  @JsonKey(name: 'mother_id')
  @NullableIntConverter()
  final int? motherId;
  @override
  final String status;
  @override
  final String purpose;
  @override
  @JsonKey(name: 'acquired_date')
  @NullableDateOnlyConverter()
  final DateTime? acquiredDate;
  @override
  @JsonKey(name: 'sold_date')
  @NullableDateOnlyConverter()
  final DateTime? soldDate;
  @override
  @JsonKey(name: 'death_date')
  @NullableDateOnlyConverter()
  final DateTime? deathDate;
  @override
  @JsonKey(name: 'death_reason')
  final String? deathReason;
  @override
  @JsonKey(name: 'current_weight')
  final double? currentWeight;
  @override
  final String? temperament;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @override
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  @DateTimeConverter()
  final DateTime updatedAt;
  // Relations
  @override
  @JsonKey(name: 'breed')
  final BreedModel? breed;
  @override
  @JsonKey(name: 'Cage')
  final CageInfo? cage;
  @override
  @JsonKey(name: 'father')
  final RabbitRef? father;
  @override
  @JsonKey(name: 'mother')
  final RabbitRef? mother;

  @override
  String toString() {
    return 'RabbitModel(id: $id, tagId: $tagId, name: $name, breedId: $breedId, sex: $sex, birthDate: $birthDate, color: $color, cageId: $cageId, fatherId: $fatherId, motherId: $motherId, status: $status, purpose: $purpose, acquiredDate: $acquiredDate, soldDate: $soldDate, deathDate: $deathDate, deathReason: $deathReason, currentWeight: $currentWeight, temperament: $temperament, notes: $notes, photoUrl: $photoUrl, createdAt: $createdAt, updatedAt: $updatedAt, breed: $breed, cage: $cage, father: $father, mother: $mother)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RabbitModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tagId, tagId) || other.tagId == tagId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.breedId, breedId) || other.breedId == breedId) &&
            (identical(other.sex, sex) || other.sex == sex) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.cageId, cageId) || other.cageId == cageId) &&
            (identical(other.fatherId, fatherId) ||
                other.fatherId == fatherId) &&
            (identical(other.motherId, motherId) ||
                other.motherId == motherId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.purpose, purpose) || other.purpose == purpose) &&
            (identical(other.acquiredDate, acquiredDate) ||
                other.acquiredDate == acquiredDate) &&
            (identical(other.soldDate, soldDate) ||
                other.soldDate == soldDate) &&
            (identical(other.deathDate, deathDate) ||
                other.deathDate == deathDate) &&
            (identical(other.deathReason, deathReason) ||
                other.deathReason == deathReason) &&
            (identical(other.currentWeight, currentWeight) ||
                other.currentWeight == currentWeight) &&
            (identical(other.temperament, temperament) ||
                other.temperament == temperament) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.breed, breed) || other.breed == breed) &&
            (identical(other.cage, cage) || other.cage == cage) &&
            (identical(other.father, father) || other.father == father) &&
            (identical(other.mother, mother) || other.mother == mother));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    tagId,
    name,
    breedId,
    sex,
    birthDate,
    color,
    cageId,
    fatherId,
    motherId,
    status,
    purpose,
    acquiredDate,
    soldDate,
    deathDate,
    deathReason,
    currentWeight,
    temperament,
    notes,
    photoUrl,
    createdAt,
    updatedAt,
    breed,
    cage,
    father,
    mother,
  ]);

  /// Create a copy of RabbitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RabbitModelImplCopyWith<_$RabbitModelImpl> get copyWith =>
      __$$RabbitModelImplCopyWithImpl<_$RabbitModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RabbitModelImplToJson(this);
  }
}

abstract class _RabbitModel extends RabbitModel {
  const factory _RabbitModel({
    @IntConverter() required final int id,
    @JsonKey(name: 'tag_id') final String? tagId,
    final String? name,
    @JsonKey(name: 'breed_id') @IntConverter() required final int breedId,
    required final String sex,
    @JsonKey(name: 'birth_date')
    @DateOnlyConverter()
    required final DateTime birthDate,
    final String? color,
    @JsonKey(name: 'cage_id') @NullableIntConverter() final int? cageId,
    @JsonKey(name: 'father_id') @NullableIntConverter() final int? fatherId,
    @JsonKey(name: 'mother_id') @NullableIntConverter() final int? motherId,
    required final String status,
    required final String purpose,
    @JsonKey(name: 'acquired_date')
    @NullableDateOnlyConverter()
    final DateTime? acquiredDate,
    @JsonKey(name: 'sold_date')
    @NullableDateOnlyConverter()
    final DateTime? soldDate,
    @JsonKey(name: 'death_date')
    @NullableDateOnlyConverter()
    final DateTime? deathDate,
    @JsonKey(name: 'death_reason') final String? deathReason,
    @JsonKey(name: 'current_weight') final double? currentWeight,
    final String? temperament,
    final String? notes,
    @JsonKey(name: 'photo_url') final String? photoUrl,
    @JsonKey(name: 'created_at')
    @DateTimeConverter()
    required final DateTime createdAt,
    @JsonKey(name: 'updated_at')
    @DateTimeConverter()
    required final DateTime updatedAt,
    @JsonKey(name: 'breed') final BreedModel? breed,
    @JsonKey(name: 'Cage') final CageInfo? cage,
    @JsonKey(name: 'father') final RabbitRef? father,
    @JsonKey(name: 'mother') final RabbitRef? mother,
  }) = _$RabbitModelImpl;
  const _RabbitModel._() : super._();

  factory _RabbitModel.fromJson(Map<String, dynamic> json) =
      _$RabbitModelImpl.fromJson;

  @override
  @IntConverter()
  int get id;

  /// Клеймо и кличка необязательны: в базе оба столбца допускают пустоту,
  /// и сервер прямо разрешает завести кролика без них
  /// (`rabbitValidator.js`: `.allow(null, '')`). Пока модель требовала обе,
  /// один такой кролик ронял разбор всей страницы списка — вместе со
  /// «Стадом», выпадающими полями форм и подбором пар.
  @override
  @JsonKey(name: 'tag_id')
  String? get tagId;
  @override
  String? get name;
  @override
  @JsonKey(name: 'breed_id')
  @IntConverter()
  int get breedId;
  @override
  String get sex;
  @override
  @JsonKey(name: 'birth_date')
  @DateOnlyConverter()
  DateTime get birthDate;
  @override
  String? get color;
  @override
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  int? get cageId;
  @override
  @JsonKey(name: 'father_id')
  @NullableIntConverter()
  int? get fatherId;
  @override
  @JsonKey(name: 'mother_id')
  @NullableIntConverter()
  int? get motherId;
  @override
  String get status;
  @override
  String get purpose;
  @override
  @JsonKey(name: 'acquired_date')
  @NullableDateOnlyConverter()
  DateTime? get acquiredDate;
  @override
  @JsonKey(name: 'sold_date')
  @NullableDateOnlyConverter()
  DateTime? get soldDate;
  @override
  @JsonKey(name: 'death_date')
  @NullableDateOnlyConverter()
  DateTime? get deathDate;
  @override
  @JsonKey(name: 'death_reason')
  String? get deathReason;
  @override
  @JsonKey(name: 'current_weight')
  double? get currentWeight;
  @override
  String? get temperament;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  @DateTimeConverter()
  DateTime get updatedAt; // Relations
  @override
  @JsonKey(name: 'breed')
  BreedModel? get breed;
  @override
  @JsonKey(name: 'Cage')
  CageInfo? get cage;
  @override
  @JsonKey(name: 'father')
  RabbitRef? get father;
  @override
  @JsonKey(name: 'mother')
  RabbitRef? get mother;

  /// Create a copy of RabbitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RabbitModelImplCopyWith<_$RabbitModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CageInfo _$CageInfoFromJson(Map<String, dynamic> json) {
  return _CageInfo.fromJson(json);
}

/// @nodoc
mixin _$CageInfo {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get number => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;

  /// Serializes this CageInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CageInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CageInfoCopyWith<CageInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CageInfoCopyWith<$Res> {
  factory $CageInfoCopyWith(CageInfo value, $Res Function(CageInfo) then) =
      _$CageInfoCopyWithImpl<$Res, CageInfo>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String number,
    String? type,
    String? location,
  });
}

/// @nodoc
class _$CageInfoCopyWithImpl<$Res, $Val extends CageInfo>
    implements $CageInfoCopyWith<$Res> {
  _$CageInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CageInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? type = freezed,
    Object? location = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as String,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CageInfoImplCopyWith<$Res>
    implements $CageInfoCopyWith<$Res> {
  factory _$$CageInfoImplCopyWith(
    _$CageInfoImpl value,
    $Res Function(_$CageInfoImpl) then,
  ) = __$$CageInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String number,
    String? type,
    String? location,
  });
}

/// @nodoc
class __$$CageInfoImplCopyWithImpl<$Res>
    extends _$CageInfoCopyWithImpl<$Res, _$CageInfoImpl>
    implements _$$CageInfoImplCopyWith<$Res> {
  __$$CageInfoImplCopyWithImpl(
    _$CageInfoImpl _value,
    $Res Function(_$CageInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CageInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? type = freezed,
    Object? location = freezed,
  }) {
    return _then(
      _$CageInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as String,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CageInfoImpl implements _CageInfo {
  const _$CageInfoImpl({
    @IntConverter() required this.id,
    required this.number,
    this.type,
    this.location,
  });

  factory _$CageInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CageInfoImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String number;
  @override
  final String? type;
  @override
  final String? location;

  @override
  String toString() {
    return 'CageInfo(id: $id, number: $number, type: $type, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CageInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, number, type, location);

  /// Create a copy of CageInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CageInfoImplCopyWith<_$CageInfoImpl> get copyWith =>
      __$$CageInfoImplCopyWithImpl<_$CageInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CageInfoImplToJson(this);
  }
}

abstract class _CageInfo implements CageInfo {
  const factory _CageInfo({
    @IntConverter() required final int id,
    required final String number,
    final String? type,
    final String? location,
  }) = _$CageInfoImpl;

  factory _CageInfo.fromJson(Map<String, dynamic> json) =
      _$CageInfoImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get number;
  @override
  String? get type;
  @override
  String? get location;

  /// Create a copy of CageInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CageInfoImplCopyWith<_$CageInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RabbitRef _$RabbitRefFromJson(Map<String, dynamic> json) {
  return _RabbitRef.fromJson(json);
}

/// @nodoc
mixin _$RabbitRef {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'tag_id')
  String? get tagId => throw _privateConstructorUsedError;

  /// Serializes this RabbitRef to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RabbitRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RabbitRefCopyWith<RabbitRef> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RabbitRefCopyWith<$Res> {
  factory $RabbitRefCopyWith(RabbitRef value, $Res Function(RabbitRef) then) =
      _$RabbitRefCopyWithImpl<$Res, RabbitRef>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String? name,
    @JsonKey(name: 'tag_id') String? tagId,
  });
}

/// @nodoc
class _$RabbitRefCopyWithImpl<$Res, $Val extends RabbitRef>
    implements $RabbitRefCopyWith<$Res> {
  _$RabbitRefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RabbitRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? tagId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            tagId: freezed == tagId
                ? _value.tagId
                : tagId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RabbitRefImplCopyWith<$Res>
    implements $RabbitRefCopyWith<$Res> {
  factory _$$RabbitRefImplCopyWith(
    _$RabbitRefImpl value,
    $Res Function(_$RabbitRefImpl) then,
  ) = __$$RabbitRefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String? name,
    @JsonKey(name: 'tag_id') String? tagId,
  });
}

/// @nodoc
class __$$RabbitRefImplCopyWithImpl<$Res>
    extends _$RabbitRefCopyWithImpl<$Res, _$RabbitRefImpl>
    implements _$$RabbitRefImplCopyWith<$Res> {
  __$$RabbitRefImplCopyWithImpl(
    _$RabbitRefImpl _value,
    $Res Function(_$RabbitRefImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RabbitRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? tagId = freezed,
  }) {
    return _then(
      _$RabbitRefImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        tagId: freezed == tagId
            ? _value.tagId
            : tagId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RabbitRefImpl extends _RabbitRef {
  const _$RabbitRefImpl({
    @IntConverter() required this.id,
    this.name,
    @JsonKey(name: 'tag_id') this.tagId,
  }) : super._();

  factory _$RabbitRefImpl.fromJson(Map<String, dynamic> json) =>
      _$$RabbitRefImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String? name;
  @override
  @JsonKey(name: 'tag_id')
  final String? tagId;

  @override
  String toString() {
    return 'RabbitRef(id: $id, name: $name, tagId: $tagId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RabbitRefImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.tagId, tagId) || other.tagId == tagId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, tagId);

  /// Create a copy of RabbitRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RabbitRefImplCopyWith<_$RabbitRefImpl> get copyWith =>
      __$$RabbitRefImplCopyWithImpl<_$RabbitRefImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RabbitRefImplToJson(this);
  }
}

abstract class _RabbitRef extends RabbitRef {
  const factory _RabbitRef({
    @IntConverter() required final int id,
    final String? name,
    @JsonKey(name: 'tag_id') final String? tagId,
  }) = _$RabbitRefImpl;
  const _RabbitRef._() : super._();

  factory _RabbitRef.fromJson(Map<String, dynamic> json) =
      _$RabbitRefImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String? get name;
  @override
  @JsonKey(name: 'tag_id')
  String? get tagId;

  /// Create a copy of RabbitRef
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RabbitRefImplCopyWith<_$RabbitRefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
