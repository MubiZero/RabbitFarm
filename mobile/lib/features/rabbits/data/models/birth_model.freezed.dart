// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'birth_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BirthModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'breeding_id')
  int? get breedingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'mother_id')
  int get motherId => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  String get birthDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'kits_born_alive')
  int get kitsBornAlive => throw _privateConstructorUsedError;
  @JsonKey(name: 'kits_born_dead')
  int get kitsBornDead => throw _privateConstructorUsedError;
  @JsonKey(name: 'kits_weaned')
  int? get kitsWeaned => throw _privateConstructorUsedError;
  @JsonKey(name: 'weaning_date')
  String? get weaningDate => throw _privateConstructorUsedError;
  String? get complications => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError; // Связанные объекты (если включены в ответ)
  RabbitModel? get mother => throw _privateConstructorUsedError;
  BreedingModel? get breeding =>
      throw _privateConstructorUsedError; // Список рожденных крольчат (если созданы в системе)
  List<RabbitModel>? get kits => throw _privateConstructorUsedError;

  /// Create a copy of BirthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BirthModelCopyWith<BirthModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BirthModelCopyWith<$Res> {
  factory $BirthModelCopyWith(
    BirthModel value,
    $Res Function(BirthModel) then,
  ) = _$BirthModelCopyWithImpl<$Res, BirthModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'breeding_id') int? breedingId,
    @JsonKey(name: 'mother_id') int motherId,
    @JsonKey(name: 'birth_date') String birthDate,
    @JsonKey(name: 'kits_born_alive') int kitsBornAlive,
    @JsonKey(name: 'kits_born_dead') int kitsBornDead,
    @JsonKey(name: 'kits_weaned') int? kitsWeaned,
    @JsonKey(name: 'weaning_date') String? weaningDate,
    String? complications,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    RabbitModel? mother,
    BreedingModel? breeding,
    List<RabbitModel>? kits,
  });

  $RabbitModelCopyWith<$Res>? get mother;
  $BreedingModelCopyWith<$Res>? get breeding;
}

/// @nodoc
class _$BirthModelCopyWithImpl<$Res, $Val extends BirthModel>
    implements $BirthModelCopyWith<$Res> {
  _$BirthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BirthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? breedingId = freezed,
    Object? motherId = null,
    Object? birthDate = null,
    Object? kitsBornAlive = null,
    Object? kitsBornDead = null,
    Object? kitsWeaned = freezed,
    Object? weaningDate = freezed,
    Object? complications = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? mother = freezed,
    Object? breeding = freezed,
    Object? kits = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            breedingId: freezed == breedingId
                ? _value.breedingId
                : breedingId // ignore: cast_nullable_to_non_nullable
                      as int?,
            motherId: null == motherId
                ? _value.motherId
                : motherId // ignore: cast_nullable_to_non_nullable
                      as int,
            birthDate: null == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as String,
            kitsBornAlive: null == kitsBornAlive
                ? _value.kitsBornAlive
                : kitsBornAlive // ignore: cast_nullable_to_non_nullable
                      as int,
            kitsBornDead: null == kitsBornDead
                ? _value.kitsBornDead
                : kitsBornDead // ignore: cast_nullable_to_non_nullable
                      as int,
            kitsWeaned: freezed == kitsWeaned
                ? _value.kitsWeaned
                : kitsWeaned // ignore: cast_nullable_to_non_nullable
                      as int?,
            weaningDate: freezed == weaningDate
                ? _value.weaningDate
                : weaningDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            complications: freezed == complications
                ? _value.complications
                : complications // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            mother: freezed == mother
                ? _value.mother
                : mother // ignore: cast_nullable_to_non_nullable
                      as RabbitModel?,
            breeding: freezed == breeding
                ? _value.breeding
                : breeding // ignore: cast_nullable_to_non_nullable
                      as BreedingModel?,
            kits: freezed == kits
                ? _value.kits
                : kits // ignore: cast_nullable_to_non_nullable
                      as List<RabbitModel>?,
          )
          as $Val,
    );
  }

  /// Create a copy of BirthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RabbitModelCopyWith<$Res>? get mother {
    if (_value.mother == null) {
      return null;
    }

    return $RabbitModelCopyWith<$Res>(_value.mother!, (value) {
      return _then(_value.copyWith(mother: value) as $Val);
    });
  }

  /// Create a copy of BirthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BreedingModelCopyWith<$Res>? get breeding {
    if (_value.breeding == null) {
      return null;
    }

    return $BreedingModelCopyWith<$Res>(_value.breeding!, (value) {
      return _then(_value.copyWith(breeding: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BirthModelImplCopyWith<$Res>
    implements $BirthModelCopyWith<$Res> {
  factory _$$BirthModelImplCopyWith(
    _$BirthModelImpl value,
    $Res Function(_$BirthModelImpl) then,
  ) = __$$BirthModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'breeding_id') int? breedingId,
    @JsonKey(name: 'mother_id') int motherId,
    @JsonKey(name: 'birth_date') String birthDate,
    @JsonKey(name: 'kits_born_alive') int kitsBornAlive,
    @JsonKey(name: 'kits_born_dead') int kitsBornDead,
    @JsonKey(name: 'kits_weaned') int? kitsWeaned,
    @JsonKey(name: 'weaning_date') String? weaningDate,
    String? complications,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    RabbitModel? mother,
    BreedingModel? breeding,
    List<RabbitModel>? kits,
  });

  @override
  $RabbitModelCopyWith<$Res>? get mother;
  @override
  $BreedingModelCopyWith<$Res>? get breeding;
}

/// @nodoc
class __$$BirthModelImplCopyWithImpl<$Res>
    extends _$BirthModelCopyWithImpl<$Res, _$BirthModelImpl>
    implements _$$BirthModelImplCopyWith<$Res> {
  __$$BirthModelImplCopyWithImpl(
    _$BirthModelImpl _value,
    $Res Function(_$BirthModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BirthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? breedingId = freezed,
    Object? motherId = null,
    Object? birthDate = null,
    Object? kitsBornAlive = null,
    Object? kitsBornDead = null,
    Object? kitsWeaned = freezed,
    Object? weaningDate = freezed,
    Object? complications = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? mother = freezed,
    Object? breeding = freezed,
    Object? kits = freezed,
  }) {
    return _then(
      _$BirthModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        breedingId: freezed == breedingId
            ? _value.breedingId
            : breedingId // ignore: cast_nullable_to_non_nullable
                  as int?,
        motherId: null == motherId
            ? _value.motherId
            : motherId // ignore: cast_nullable_to_non_nullable
                  as int,
        birthDate: null == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as String,
        kitsBornAlive: null == kitsBornAlive
            ? _value.kitsBornAlive
            : kitsBornAlive // ignore: cast_nullable_to_non_nullable
                  as int,
        kitsBornDead: null == kitsBornDead
            ? _value.kitsBornDead
            : kitsBornDead // ignore: cast_nullable_to_non_nullable
                  as int,
        kitsWeaned: freezed == kitsWeaned
            ? _value.kitsWeaned
            : kitsWeaned // ignore: cast_nullable_to_non_nullable
                  as int?,
        weaningDate: freezed == weaningDate
            ? _value.weaningDate
            : weaningDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        complications: freezed == complications
            ? _value.complications
            : complications // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        mother: freezed == mother
            ? _value.mother
            : mother // ignore: cast_nullable_to_non_nullable
                  as RabbitModel?,
        breeding: freezed == breeding
            ? _value.breeding
            : breeding // ignore: cast_nullable_to_non_nullable
                  as BreedingModel?,
        kits: freezed == kits
            ? _value._kits
            : kits // ignore: cast_nullable_to_non_nullable
                  as List<RabbitModel>?,
      ),
    );
  }
}

/// @nodoc

class _$BirthModelImpl implements _BirthModel {
  const _$BirthModelImpl({
    required this.id,
    @JsonKey(name: 'breeding_id') this.breedingId,
    @JsonKey(name: 'mother_id') required this.motherId,
    @JsonKey(name: 'birth_date') required this.birthDate,
    @JsonKey(name: 'kits_born_alive') required this.kitsBornAlive,
    @JsonKey(name: 'kits_born_dead') required this.kitsBornDead,
    @JsonKey(name: 'kits_weaned') this.kitsWeaned,
    @JsonKey(name: 'weaning_date') this.weaningDate,
    this.complications,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    this.mother,
    this.breeding,
    final List<RabbitModel>? kits,
  }) : _kits = kits;

  @override
  final int id;
  @override
  @JsonKey(name: 'breeding_id')
  final int? breedingId;
  @override
  @JsonKey(name: 'mother_id')
  final int motherId;
  @override
  @JsonKey(name: 'birth_date')
  final String birthDate;
  @override
  @JsonKey(name: 'kits_born_alive')
  final int kitsBornAlive;
  @override
  @JsonKey(name: 'kits_born_dead')
  final int kitsBornDead;
  @override
  @JsonKey(name: 'kits_weaned')
  final int? kitsWeaned;
  @override
  @JsonKey(name: 'weaning_date')
  final String? weaningDate;
  @override
  final String? complications;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  // Связанные объекты (если включены в ответ)
  @override
  final RabbitModel? mother;
  @override
  final BreedingModel? breeding;
  // Список рожденных крольчат (если созданы в системе)
  final List<RabbitModel>? _kits;
  // Список рожденных крольчат (если созданы в системе)
  @override
  List<RabbitModel>? get kits {
    final value = _kits;
    if (value == null) return null;
    if (_kits is EqualUnmodifiableListView) return _kits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BirthModel(id: $id, breedingId: $breedingId, motherId: $motherId, birthDate: $birthDate, kitsBornAlive: $kitsBornAlive, kitsBornDead: $kitsBornDead, kitsWeaned: $kitsWeaned, weaningDate: $weaningDate, complications: $complications, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, mother: $mother, breeding: $breeding, kits: $kits)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BirthModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.breedingId, breedingId) ||
                other.breedingId == breedingId) &&
            (identical(other.motherId, motherId) ||
                other.motherId == motherId) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.kitsBornAlive, kitsBornAlive) ||
                other.kitsBornAlive == kitsBornAlive) &&
            (identical(other.kitsBornDead, kitsBornDead) ||
                other.kitsBornDead == kitsBornDead) &&
            (identical(other.kitsWeaned, kitsWeaned) ||
                other.kitsWeaned == kitsWeaned) &&
            (identical(other.weaningDate, weaningDate) ||
                other.weaningDate == weaningDate) &&
            (identical(other.complications, complications) ||
                other.complications == complications) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.mother, mother) || other.mother == mother) &&
            (identical(other.breeding, breeding) ||
                other.breeding == breeding) &&
            const DeepCollectionEquality().equals(other._kits, _kits));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    breedingId,
    motherId,
    birthDate,
    kitsBornAlive,
    kitsBornDead,
    kitsWeaned,
    weaningDate,
    complications,
    notes,
    createdAt,
    updatedAt,
    mother,
    breeding,
    const DeepCollectionEquality().hash(_kits),
  );

  /// Create a copy of BirthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BirthModelImplCopyWith<_$BirthModelImpl> get copyWith =>
      __$$BirthModelImplCopyWithImpl<_$BirthModelImpl>(this, _$identity);
}

abstract class _BirthModel implements BirthModel {
  const factory _BirthModel({
    required final int id,
    @JsonKey(name: 'breeding_id') final int? breedingId,
    @JsonKey(name: 'mother_id') required final int motherId,
    @JsonKey(name: 'birth_date') required final String birthDate,
    @JsonKey(name: 'kits_born_alive') required final int kitsBornAlive,
    @JsonKey(name: 'kits_born_dead') required final int kitsBornDead,
    @JsonKey(name: 'kits_weaned') final int? kitsWeaned,
    @JsonKey(name: 'weaning_date') final String? weaningDate,
    final String? complications,
    final String? notes,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    final RabbitModel? mother,
    final BreedingModel? breeding,
    final List<RabbitModel>? kits,
  }) = _$BirthModelImpl;

  @override
  int get id;
  @override
  @JsonKey(name: 'breeding_id')
  int? get breedingId;
  @override
  @JsonKey(name: 'mother_id')
  int get motherId;
  @override
  @JsonKey(name: 'birth_date')
  String get birthDate;
  @override
  @JsonKey(name: 'kits_born_alive')
  int get kitsBornAlive;
  @override
  @JsonKey(name: 'kits_born_dead')
  int get kitsBornDead;
  @override
  @JsonKey(name: 'kits_weaned')
  int? get kitsWeaned;
  @override
  @JsonKey(name: 'weaning_date')
  String? get weaningDate;
  @override
  String? get complications;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt; // Связанные объекты (если включены в ответ)
  @override
  RabbitModel? get mother;
  @override
  BreedingModel? get breeding; // Список рожденных крольчат (если созданы в системе)
  @override
  List<RabbitModel>? get kits;

  /// Create a copy of BirthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BirthModelImplCopyWith<_$BirthModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
