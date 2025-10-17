// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breeding_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BreedingModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'male_id')
  int get maleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'female_id')
  int get femaleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'breeding_date')
  String get breedingDate => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // planned, completed, failed, cancelled
  @JsonKey(name: 'palpation_date')
  String? get palpationDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_pregnant')
  bool? get isPregnant => throw _privateConstructorUsedError;
  @JsonKey(name: 'expected_birth_date')
  String? get expectedBirthDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError; // Связанные объекты (если включены в ответ)
  RabbitModel? get male => throw _privateConstructorUsedError;
  RabbitModel? get female =>
      throw _privateConstructorUsedError; // Информация об инбридинге
  @JsonKey(name: 'inbreeding_coefficient')
  double? get inbreedingCoefficient => throw _privateConstructorUsedError;
  @JsonKey(name: 'common_ancestors')
  List<String>? get commonAncestors => throw _privateConstructorUsedError;

  /// Create a copy of BreedingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreedingModelCopyWith<BreedingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreedingModelCopyWith<$Res> {
  factory $BreedingModelCopyWith(
    BreedingModel value,
    $Res Function(BreedingModel) then,
  ) = _$BreedingModelCopyWithImpl<$Res, BreedingModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'male_id') int maleId,
    @JsonKey(name: 'female_id') int femaleId,
    @JsonKey(name: 'breeding_date') String breedingDate,
    String status,
    @JsonKey(name: 'palpation_date') String? palpationDate,
    @JsonKey(name: 'is_pregnant') bool? isPregnant,
    @JsonKey(name: 'expected_birth_date') String? expectedBirthDate,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    RabbitModel? male,
    RabbitModel? female,
    @JsonKey(name: 'inbreeding_coefficient') double? inbreedingCoefficient,
    @JsonKey(name: 'common_ancestors') List<String>? commonAncestors,
  });

  $RabbitModelCopyWith<$Res>? get male;
  $RabbitModelCopyWith<$Res>? get female;
}

/// @nodoc
class _$BreedingModelCopyWithImpl<$Res, $Val extends BreedingModel>
    implements $BreedingModelCopyWith<$Res> {
  _$BreedingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreedingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? maleId = null,
    Object? femaleId = null,
    Object? breedingDate = null,
    Object? status = null,
    Object? palpationDate = freezed,
    Object? isPregnant = freezed,
    Object? expectedBirthDate = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? male = freezed,
    Object? female = freezed,
    Object? inbreedingCoefficient = freezed,
    Object? commonAncestors = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            maleId: null == maleId
                ? _value.maleId
                : maleId // ignore: cast_nullable_to_non_nullable
                      as int,
            femaleId: null == femaleId
                ? _value.femaleId
                : femaleId // ignore: cast_nullable_to_non_nullable
                      as int,
            breedingDate: null == breedingDate
                ? _value.breedingDate
                : breedingDate // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            palpationDate: freezed == palpationDate
                ? _value.palpationDate
                : palpationDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPregnant: freezed == isPregnant
                ? _value.isPregnant
                : isPregnant // ignore: cast_nullable_to_non_nullable
                      as bool?,
            expectedBirthDate: freezed == expectedBirthDate
                ? _value.expectedBirthDate
                : expectedBirthDate // ignore: cast_nullable_to_non_nullable
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
            male: freezed == male
                ? _value.male
                : male // ignore: cast_nullable_to_non_nullable
                      as RabbitModel?,
            female: freezed == female
                ? _value.female
                : female // ignore: cast_nullable_to_non_nullable
                      as RabbitModel?,
            inbreedingCoefficient: freezed == inbreedingCoefficient
                ? _value.inbreedingCoefficient
                : inbreedingCoefficient // ignore: cast_nullable_to_non_nullable
                      as double?,
            commonAncestors: freezed == commonAncestors
                ? _value.commonAncestors
                : commonAncestors // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }

  /// Create a copy of BreedingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RabbitModelCopyWith<$Res>? get male {
    if (_value.male == null) {
      return null;
    }

    return $RabbitModelCopyWith<$Res>(_value.male!, (value) {
      return _then(_value.copyWith(male: value) as $Val);
    });
  }

  /// Create a copy of BreedingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RabbitModelCopyWith<$Res>? get female {
    if (_value.female == null) {
      return null;
    }

    return $RabbitModelCopyWith<$Res>(_value.female!, (value) {
      return _then(_value.copyWith(female: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BreedingModelImplCopyWith<$Res>
    implements $BreedingModelCopyWith<$Res> {
  factory _$$BreedingModelImplCopyWith(
    _$BreedingModelImpl value,
    $Res Function(_$BreedingModelImpl) then,
  ) = __$$BreedingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'male_id') int maleId,
    @JsonKey(name: 'female_id') int femaleId,
    @JsonKey(name: 'breeding_date') String breedingDate,
    String status,
    @JsonKey(name: 'palpation_date') String? palpationDate,
    @JsonKey(name: 'is_pregnant') bool? isPregnant,
    @JsonKey(name: 'expected_birth_date') String? expectedBirthDate,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    RabbitModel? male,
    RabbitModel? female,
    @JsonKey(name: 'inbreeding_coefficient') double? inbreedingCoefficient,
    @JsonKey(name: 'common_ancestors') List<String>? commonAncestors,
  });

  @override
  $RabbitModelCopyWith<$Res>? get male;
  @override
  $RabbitModelCopyWith<$Res>? get female;
}

/// @nodoc
class __$$BreedingModelImplCopyWithImpl<$Res>
    extends _$BreedingModelCopyWithImpl<$Res, _$BreedingModelImpl>
    implements _$$BreedingModelImplCopyWith<$Res> {
  __$$BreedingModelImplCopyWithImpl(
    _$BreedingModelImpl _value,
    $Res Function(_$BreedingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreedingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? maleId = null,
    Object? femaleId = null,
    Object? breedingDate = null,
    Object? status = null,
    Object? palpationDate = freezed,
    Object? isPregnant = freezed,
    Object? expectedBirthDate = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? male = freezed,
    Object? female = freezed,
    Object? inbreedingCoefficient = freezed,
    Object? commonAncestors = freezed,
  }) {
    return _then(
      _$BreedingModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        maleId: null == maleId
            ? _value.maleId
            : maleId // ignore: cast_nullable_to_non_nullable
                  as int,
        femaleId: null == femaleId
            ? _value.femaleId
            : femaleId // ignore: cast_nullable_to_non_nullable
                  as int,
        breedingDate: null == breedingDate
            ? _value.breedingDate
            : breedingDate // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        palpationDate: freezed == palpationDate
            ? _value.palpationDate
            : palpationDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPregnant: freezed == isPregnant
            ? _value.isPregnant
            : isPregnant // ignore: cast_nullable_to_non_nullable
                  as bool?,
        expectedBirthDate: freezed == expectedBirthDate
            ? _value.expectedBirthDate
            : expectedBirthDate // ignore: cast_nullable_to_non_nullable
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
        male: freezed == male
            ? _value.male
            : male // ignore: cast_nullable_to_non_nullable
                  as RabbitModel?,
        female: freezed == female
            ? _value.female
            : female // ignore: cast_nullable_to_non_nullable
                  as RabbitModel?,
        inbreedingCoefficient: freezed == inbreedingCoefficient
            ? _value.inbreedingCoefficient
            : inbreedingCoefficient // ignore: cast_nullable_to_non_nullable
                  as double?,
        commonAncestors: freezed == commonAncestors
            ? _value._commonAncestors
            : commonAncestors // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc

class _$BreedingModelImpl implements _BreedingModel {
  const _$BreedingModelImpl({
    required this.id,
    @JsonKey(name: 'male_id') required this.maleId,
    @JsonKey(name: 'female_id') required this.femaleId,
    @JsonKey(name: 'breeding_date') required this.breedingDate,
    required this.status,
    @JsonKey(name: 'palpation_date') this.palpationDate,
    @JsonKey(name: 'is_pregnant') this.isPregnant,
    @JsonKey(name: 'expected_birth_date') this.expectedBirthDate,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    this.male,
    this.female,
    @JsonKey(name: 'inbreeding_coefficient') this.inbreedingCoefficient,
    @JsonKey(name: 'common_ancestors') final List<String>? commonAncestors,
  }) : _commonAncestors = commonAncestors;

  @override
  final int id;
  @override
  @JsonKey(name: 'male_id')
  final int maleId;
  @override
  @JsonKey(name: 'female_id')
  final int femaleId;
  @override
  @JsonKey(name: 'breeding_date')
  final String breedingDate;
  @override
  final String status;
  // planned, completed, failed, cancelled
  @override
  @JsonKey(name: 'palpation_date')
  final String? palpationDate;
  @override
  @JsonKey(name: 'is_pregnant')
  final bool? isPregnant;
  @override
  @JsonKey(name: 'expected_birth_date')
  final String? expectedBirthDate;
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
  final RabbitModel? male;
  @override
  final RabbitModel? female;
  // Информация об инбридинге
  @override
  @JsonKey(name: 'inbreeding_coefficient')
  final double? inbreedingCoefficient;
  final List<String>? _commonAncestors;
  @override
  @JsonKey(name: 'common_ancestors')
  List<String>? get commonAncestors {
    final value = _commonAncestors;
    if (value == null) return null;
    if (_commonAncestors is EqualUnmodifiableListView) return _commonAncestors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BreedingModel(id: $id, maleId: $maleId, femaleId: $femaleId, breedingDate: $breedingDate, status: $status, palpationDate: $palpationDate, isPregnant: $isPregnant, expectedBirthDate: $expectedBirthDate, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, male: $male, female: $female, inbreedingCoefficient: $inbreedingCoefficient, commonAncestors: $commonAncestors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreedingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.maleId, maleId) || other.maleId == maleId) &&
            (identical(other.femaleId, femaleId) ||
                other.femaleId == femaleId) &&
            (identical(other.breedingDate, breedingDate) ||
                other.breedingDate == breedingDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.palpationDate, palpationDate) ||
                other.palpationDate == palpationDate) &&
            (identical(other.isPregnant, isPregnant) ||
                other.isPregnant == isPregnant) &&
            (identical(other.expectedBirthDate, expectedBirthDate) ||
                other.expectedBirthDate == expectedBirthDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.male, male) || other.male == male) &&
            (identical(other.female, female) || other.female == female) &&
            (identical(other.inbreedingCoefficient, inbreedingCoefficient) ||
                other.inbreedingCoefficient == inbreedingCoefficient) &&
            const DeepCollectionEquality().equals(
              other._commonAncestors,
              _commonAncestors,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    maleId,
    femaleId,
    breedingDate,
    status,
    palpationDate,
    isPregnant,
    expectedBirthDate,
    notes,
    createdAt,
    updatedAt,
    male,
    female,
    inbreedingCoefficient,
    const DeepCollectionEquality().hash(_commonAncestors),
  );

  /// Create a copy of BreedingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreedingModelImplCopyWith<_$BreedingModelImpl> get copyWith =>
      __$$BreedingModelImplCopyWithImpl<_$BreedingModelImpl>(this, _$identity);
}

abstract class _BreedingModel implements BreedingModel {
  const factory _BreedingModel({
    required final int id,
    @JsonKey(name: 'male_id') required final int maleId,
    @JsonKey(name: 'female_id') required final int femaleId,
    @JsonKey(name: 'breeding_date') required final String breedingDate,
    required final String status,
    @JsonKey(name: 'palpation_date') final String? palpationDate,
    @JsonKey(name: 'is_pregnant') final bool? isPregnant,
    @JsonKey(name: 'expected_birth_date') final String? expectedBirthDate,
    final String? notes,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    final RabbitModel? male,
    final RabbitModel? female,
    @JsonKey(name: 'inbreeding_coefficient')
    final double? inbreedingCoefficient,
    @JsonKey(name: 'common_ancestors') final List<String>? commonAncestors,
  }) = _$BreedingModelImpl;

  @override
  int get id;
  @override
  @JsonKey(name: 'male_id')
  int get maleId;
  @override
  @JsonKey(name: 'female_id')
  int get femaleId;
  @override
  @JsonKey(name: 'breeding_date')
  String get breedingDate;
  @override
  String get status; // planned, completed, failed, cancelled
  @override
  @JsonKey(name: 'palpation_date')
  String? get palpationDate;
  @override
  @JsonKey(name: 'is_pregnant')
  bool? get isPregnant;
  @override
  @JsonKey(name: 'expected_birth_date')
  String? get expectedBirthDate;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt; // Связанные объекты (если включены в ответ)
  @override
  RabbitModel? get male;
  @override
  RabbitModel? get female; // Информация об инбридинге
  @override
  @JsonKey(name: 'inbreeding_coefficient')
  double? get inbreedingCoefficient;
  @override
  @JsonKey(name: 'common_ancestors')
  List<String>? get commonAncestors;

  /// Create a copy of BreedingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreedingModelImplCopyWith<_$BreedingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
