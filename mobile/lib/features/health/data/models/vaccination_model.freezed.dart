// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vaccination_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Vaccination _$VaccinationFromJson(Map<String, dynamic> json) {
  return _Vaccination.fromJson(json);
}

/// @nodoc
mixin _$Vaccination {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int get rabbitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vaccine_name')
  String get vaccineName => throw _privateConstructorUsedError;
  @JsonKey(name: 'vaccine_type')
  VaccineType get vaccineType => throw _privateConstructorUsedError;
  @JsonKey(name: 'vaccination_date')
  DateTime get vaccinationDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_vaccination_date')
  DateTime? get nextVaccinationDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'batch_number')
  String? get batchNumber => throw _privateConstructorUsedError;
  String? get veterinarian => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Related rabbit info (from API) - не сериализуем, создаем вручную
  @JsonKey(includeFromJson: false, includeToJson: false)
  Rabbit? get rabbit => throw _privateConstructorUsedError; // Calculated fields
  @JsonKey(name: 'days_until')
  int? get daysUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'days_overdue')
  int? get daysOverdue => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_overdue')
  bool? get isOverdue => throw _privateConstructorUsedError;

  /// Serializes this Vaccination to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Vaccination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaccinationCopyWith<Vaccination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaccinationCopyWith<$Res> {
  factory $VaccinationCopyWith(
    Vaccination value,
    $Res Function(Vaccination) then,
  ) = _$VaccinationCopyWithImpl<$Res, Vaccination>;
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int rabbitId,
    @JsonKey(name: 'vaccine_name') String vaccineName,
    @JsonKey(name: 'vaccine_type') VaccineType vaccineType,
    @JsonKey(name: 'vaccination_date') DateTime vaccinationDate,
    @JsonKey(name: 'next_vaccination_date') DateTime? nextVaccinationDate,
    @JsonKey(name: 'batch_number') String? batchNumber,
    String? veterinarian,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) Rabbit? rabbit,
    @JsonKey(name: 'days_until') int? daysUntil,
    @JsonKey(name: 'days_overdue') int? daysOverdue,
    @JsonKey(name: 'is_overdue') bool? isOverdue,
  });
}

/// @nodoc
class _$VaccinationCopyWithImpl<$Res, $Val extends Vaccination>
    implements $VaccinationCopyWith<$Res> {
  _$VaccinationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vaccination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = null,
    Object? vaccineName = null,
    Object? vaccineType = null,
    Object? vaccinationDate = null,
    Object? nextVaccinationDate = freezed,
    Object? batchNumber = freezed,
    Object? veterinarian = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? rabbit = freezed,
    Object? daysUntil = freezed,
    Object? daysOverdue = freezed,
    Object? isOverdue = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            rabbitId: null == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int,
            vaccineName: null == vaccineName
                ? _value.vaccineName
                : vaccineName // ignore: cast_nullable_to_non_nullable
                      as String,
            vaccineType: null == vaccineType
                ? _value.vaccineType
                : vaccineType // ignore: cast_nullable_to_non_nullable
                      as VaccineType,
            vaccinationDate: null == vaccinationDate
                ? _value.vaccinationDate
                : vaccinationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            nextVaccinationDate: freezed == nextVaccinationDate
                ? _value.nextVaccinationDate
                : nextVaccinationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            batchNumber: freezed == batchNumber
                ? _value.batchNumber
                : batchNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            veterinarian: freezed == veterinarian
                ? _value.veterinarian
                : veterinarian // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rabbit: freezed == rabbit
                ? _value.rabbit
                : rabbit // ignore: cast_nullable_to_non_nullable
                      as Rabbit?,
            daysUntil: freezed == daysUntil
                ? _value.daysUntil
                : daysUntil // ignore: cast_nullable_to_non_nullable
                      as int?,
            daysOverdue: freezed == daysOverdue
                ? _value.daysOverdue
                : daysOverdue // ignore: cast_nullable_to_non_nullable
                      as int?,
            isOverdue: freezed == isOverdue
                ? _value.isOverdue
                : isOverdue // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VaccinationImplCopyWith<$Res>
    implements $VaccinationCopyWith<$Res> {
  factory _$$VaccinationImplCopyWith(
    _$VaccinationImpl value,
    $Res Function(_$VaccinationImpl) then,
  ) = __$$VaccinationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int rabbitId,
    @JsonKey(name: 'vaccine_name') String vaccineName,
    @JsonKey(name: 'vaccine_type') VaccineType vaccineType,
    @JsonKey(name: 'vaccination_date') DateTime vaccinationDate,
    @JsonKey(name: 'next_vaccination_date') DateTime? nextVaccinationDate,
    @JsonKey(name: 'batch_number') String? batchNumber,
    String? veterinarian,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) Rabbit? rabbit,
    @JsonKey(name: 'days_until') int? daysUntil,
    @JsonKey(name: 'days_overdue') int? daysOverdue,
    @JsonKey(name: 'is_overdue') bool? isOverdue,
  });
}

/// @nodoc
class __$$VaccinationImplCopyWithImpl<$Res>
    extends _$VaccinationCopyWithImpl<$Res, _$VaccinationImpl>
    implements _$$VaccinationImplCopyWith<$Res> {
  __$$VaccinationImplCopyWithImpl(
    _$VaccinationImpl _value,
    $Res Function(_$VaccinationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Vaccination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = null,
    Object? vaccineName = null,
    Object? vaccineType = null,
    Object? vaccinationDate = null,
    Object? nextVaccinationDate = freezed,
    Object? batchNumber = freezed,
    Object? veterinarian = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? rabbit = freezed,
    Object? daysUntil = freezed,
    Object? daysOverdue = freezed,
    Object? isOverdue = freezed,
  }) {
    return _then(
      _$VaccinationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        rabbitId: null == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int,
        vaccineName: null == vaccineName
            ? _value.vaccineName
            : vaccineName // ignore: cast_nullable_to_non_nullable
                  as String,
        vaccineType: null == vaccineType
            ? _value.vaccineType
            : vaccineType // ignore: cast_nullable_to_non_nullable
                  as VaccineType,
        vaccinationDate: null == vaccinationDate
            ? _value.vaccinationDate
            : vaccinationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        nextVaccinationDate: freezed == nextVaccinationDate
            ? _value.nextVaccinationDate
            : nextVaccinationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        batchNumber: freezed == batchNumber
            ? _value.batchNumber
            : batchNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        veterinarian: freezed == veterinarian
            ? _value.veterinarian
            : veterinarian // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rabbit: freezed == rabbit
            ? _value.rabbit
            : rabbit // ignore: cast_nullable_to_non_nullable
                  as Rabbit?,
        daysUntil: freezed == daysUntil
            ? _value.daysUntil
            : daysUntil // ignore: cast_nullable_to_non_nullable
                  as int?,
        daysOverdue: freezed == daysOverdue
            ? _value.daysOverdue
            : daysOverdue // ignore: cast_nullable_to_non_nullable
                  as int?,
        isOverdue: freezed == isOverdue
            ? _value.isOverdue
            : isOverdue // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VaccinationImpl implements _Vaccination {
  const _$VaccinationImpl({
    @IntConverter() required this.id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required this.rabbitId,
    @JsonKey(name: 'vaccine_name') required this.vaccineName,
    @JsonKey(name: 'vaccine_type') required this.vaccineType,
    @JsonKey(name: 'vaccination_date') required this.vaccinationDate,
    @JsonKey(name: 'next_vaccination_date') this.nextVaccinationDate,
    @JsonKey(name: 'batch_number') this.batchNumber,
    this.veterinarian,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) this.rabbit,
    @JsonKey(name: 'days_until') this.daysUntil,
    @JsonKey(name: 'days_overdue') this.daysOverdue,
    @JsonKey(name: 'is_overdue') this.isOverdue,
  });

  factory _$VaccinationImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaccinationImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  final int rabbitId;
  @override
  @JsonKey(name: 'vaccine_name')
  final String vaccineName;
  @override
  @JsonKey(name: 'vaccine_type')
  final VaccineType vaccineType;
  @override
  @JsonKey(name: 'vaccination_date')
  final DateTime vaccinationDate;
  @override
  @JsonKey(name: 'next_vaccination_date')
  final DateTime? nextVaccinationDate;
  @override
  @JsonKey(name: 'batch_number')
  final String? batchNumber;
  @override
  final String? veterinarian;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  // Related rabbit info (from API) - не сериализуем, создаем вручную
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Rabbit? rabbit;
  // Calculated fields
  @override
  @JsonKey(name: 'days_until')
  final int? daysUntil;
  @override
  @JsonKey(name: 'days_overdue')
  final int? daysOverdue;
  @override
  @JsonKey(name: 'is_overdue')
  final bool? isOverdue;

  @override
  String toString() {
    return 'Vaccination(id: $id, rabbitId: $rabbitId, vaccineName: $vaccineName, vaccineType: $vaccineType, vaccinationDate: $vaccinationDate, nextVaccinationDate: $nextVaccinationDate, batchNumber: $batchNumber, veterinarian: $veterinarian, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, rabbit: $rabbit, daysUntil: $daysUntil, daysOverdue: $daysOverdue, isOverdue: $isOverdue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaccinationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.vaccineName, vaccineName) ||
                other.vaccineName == vaccineName) &&
            (identical(other.vaccineType, vaccineType) ||
                other.vaccineType == vaccineType) &&
            (identical(other.vaccinationDate, vaccinationDate) ||
                other.vaccinationDate == vaccinationDate) &&
            (identical(other.nextVaccinationDate, nextVaccinationDate) ||
                other.nextVaccinationDate == nextVaccinationDate) &&
            (identical(other.batchNumber, batchNumber) ||
                other.batchNumber == batchNumber) &&
            (identical(other.veterinarian, veterinarian) ||
                other.veterinarian == veterinarian) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.rabbit, rabbit) &&
            (identical(other.daysUntil, daysUntil) ||
                other.daysUntil == daysUntil) &&
            (identical(other.daysOverdue, daysOverdue) ||
                other.daysOverdue == daysOverdue) &&
            (identical(other.isOverdue, isOverdue) ||
                other.isOverdue == isOverdue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    rabbitId,
    vaccineName,
    vaccineType,
    vaccinationDate,
    nextVaccinationDate,
    batchNumber,
    veterinarian,
    notes,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(rabbit),
    daysUntil,
    daysOverdue,
    isOverdue,
  );

  /// Create a copy of Vaccination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaccinationImplCopyWith<_$VaccinationImpl> get copyWith =>
      __$$VaccinationImplCopyWithImpl<_$VaccinationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VaccinationImplToJson(this);
  }
}

abstract class _Vaccination implements Vaccination {
  const factory _Vaccination({
    @IntConverter() required final int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required final int rabbitId,
    @JsonKey(name: 'vaccine_name') required final String vaccineName,
    @JsonKey(name: 'vaccine_type') required final VaccineType vaccineType,
    @JsonKey(name: 'vaccination_date') required final DateTime vaccinationDate,
    @JsonKey(name: 'next_vaccination_date') final DateTime? nextVaccinationDate,
    @JsonKey(name: 'batch_number') final String? batchNumber,
    final String? veterinarian,
    final String? notes,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) final Rabbit? rabbit,
    @JsonKey(name: 'days_until') final int? daysUntil,
    @JsonKey(name: 'days_overdue') final int? daysOverdue,
    @JsonKey(name: 'is_overdue') final bool? isOverdue,
  }) = _$VaccinationImpl;

  factory _Vaccination.fromJson(Map<String, dynamic> json) =
      _$VaccinationImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int get rabbitId;
  @override
  @JsonKey(name: 'vaccine_name')
  String get vaccineName;
  @override
  @JsonKey(name: 'vaccine_type')
  VaccineType get vaccineType;
  @override
  @JsonKey(name: 'vaccination_date')
  DateTime get vaccinationDate;
  @override
  @JsonKey(name: 'next_vaccination_date')
  DateTime? get nextVaccinationDate;
  @override
  @JsonKey(name: 'batch_number')
  String? get batchNumber;
  @override
  String? get veterinarian;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt; // Related rabbit info (from API) - не сериализуем, создаем вручную
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Rabbit? get rabbit; // Calculated fields
  @override
  @JsonKey(name: 'days_until')
  int? get daysUntil;
  @override
  @JsonKey(name: 'days_overdue')
  int? get daysOverdue;
  @override
  @JsonKey(name: 'is_overdue')
  bool? get isOverdue;

  /// Create a copy of Vaccination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaccinationImplCopyWith<_$VaccinationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VaccinationStatistics _$VaccinationStatisticsFromJson(
  Map<String, dynamic> json,
) {
  return _VaccinationStatistics.fromJson(json);
}

/// @nodoc
mixin _$VaccinationStatistics {
  @JsonKey(name: 'total_vaccinations')
  int get totalVaccinations => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_vaccine_type')
  Map<String, int> get byVaccineType => throw _privateConstructorUsedError;
  VaccinationUpcoming get upcoming => throw _privateConstructorUsedError;
  @JsonKey(name: 'this_year')
  int get thisYear => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_30_days')
  int get last30Days => throw _privateConstructorUsedError;

  /// Serializes this VaccinationStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VaccinationStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaccinationStatisticsCopyWith<VaccinationStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaccinationStatisticsCopyWith<$Res> {
  factory $VaccinationStatisticsCopyWith(
    VaccinationStatistics value,
    $Res Function(VaccinationStatistics) then,
  ) = _$VaccinationStatisticsCopyWithImpl<$Res, VaccinationStatistics>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_vaccinations') int totalVaccinations,
    @JsonKey(name: 'by_vaccine_type') Map<String, int> byVaccineType,
    VaccinationUpcoming upcoming,
    @JsonKey(name: 'this_year') int thisYear,
    @JsonKey(name: 'last_30_days') int last30Days,
  });

  $VaccinationUpcomingCopyWith<$Res> get upcoming;
}

/// @nodoc
class _$VaccinationStatisticsCopyWithImpl<
  $Res,
  $Val extends VaccinationStatistics
>
    implements $VaccinationStatisticsCopyWith<$Res> {
  _$VaccinationStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaccinationStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalVaccinations = null,
    Object? byVaccineType = null,
    Object? upcoming = null,
    Object? thisYear = null,
    Object? last30Days = null,
  }) {
    return _then(
      _value.copyWith(
            totalVaccinations: null == totalVaccinations
                ? _value.totalVaccinations
                : totalVaccinations // ignore: cast_nullable_to_non_nullable
                      as int,
            byVaccineType: null == byVaccineType
                ? _value.byVaccineType
                : byVaccineType // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            upcoming: null == upcoming
                ? _value.upcoming
                : upcoming // ignore: cast_nullable_to_non_nullable
                      as VaccinationUpcoming,
            thisYear: null == thisYear
                ? _value.thisYear
                : thisYear // ignore: cast_nullable_to_non_nullable
                      as int,
            last30Days: null == last30Days
                ? _value.last30Days
                : last30Days // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of VaccinationStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VaccinationUpcomingCopyWith<$Res> get upcoming {
    return $VaccinationUpcomingCopyWith<$Res>(_value.upcoming, (value) {
      return _then(_value.copyWith(upcoming: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VaccinationStatisticsImplCopyWith<$Res>
    implements $VaccinationStatisticsCopyWith<$Res> {
  factory _$$VaccinationStatisticsImplCopyWith(
    _$VaccinationStatisticsImpl value,
    $Res Function(_$VaccinationStatisticsImpl) then,
  ) = __$$VaccinationStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_vaccinations') int totalVaccinations,
    @JsonKey(name: 'by_vaccine_type') Map<String, int> byVaccineType,
    VaccinationUpcoming upcoming,
    @JsonKey(name: 'this_year') int thisYear,
    @JsonKey(name: 'last_30_days') int last30Days,
  });

  @override
  $VaccinationUpcomingCopyWith<$Res> get upcoming;
}

/// @nodoc
class __$$VaccinationStatisticsImplCopyWithImpl<$Res>
    extends
        _$VaccinationStatisticsCopyWithImpl<$Res, _$VaccinationStatisticsImpl>
    implements _$$VaccinationStatisticsImplCopyWith<$Res> {
  __$$VaccinationStatisticsImplCopyWithImpl(
    _$VaccinationStatisticsImpl _value,
    $Res Function(_$VaccinationStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VaccinationStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalVaccinations = null,
    Object? byVaccineType = null,
    Object? upcoming = null,
    Object? thisYear = null,
    Object? last30Days = null,
  }) {
    return _then(
      _$VaccinationStatisticsImpl(
        totalVaccinations: null == totalVaccinations
            ? _value.totalVaccinations
            : totalVaccinations // ignore: cast_nullable_to_non_nullable
                  as int,
        byVaccineType: null == byVaccineType
            ? _value._byVaccineType
            : byVaccineType // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        upcoming: null == upcoming
            ? _value.upcoming
            : upcoming // ignore: cast_nullable_to_non_nullable
                  as VaccinationUpcoming,
        thisYear: null == thisYear
            ? _value.thisYear
            : thisYear // ignore: cast_nullable_to_non_nullable
                  as int,
        last30Days: null == last30Days
            ? _value.last30Days
            : last30Days // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VaccinationStatisticsImpl implements _VaccinationStatistics {
  const _$VaccinationStatisticsImpl({
    @JsonKey(name: 'total_vaccinations') required this.totalVaccinations,
    @JsonKey(name: 'by_vaccine_type')
    required final Map<String, int> byVaccineType,
    required this.upcoming,
    @JsonKey(name: 'this_year') required this.thisYear,
    @JsonKey(name: 'last_30_days') required this.last30Days,
  }) : _byVaccineType = byVaccineType;

  factory _$VaccinationStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaccinationStatisticsImplFromJson(json);

  @override
  @JsonKey(name: 'total_vaccinations')
  final int totalVaccinations;
  final Map<String, int> _byVaccineType;
  @override
  @JsonKey(name: 'by_vaccine_type')
  Map<String, int> get byVaccineType {
    if (_byVaccineType is EqualUnmodifiableMapView) return _byVaccineType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byVaccineType);
  }

  @override
  final VaccinationUpcoming upcoming;
  @override
  @JsonKey(name: 'this_year')
  final int thisYear;
  @override
  @JsonKey(name: 'last_30_days')
  final int last30Days;

  @override
  String toString() {
    return 'VaccinationStatistics(totalVaccinations: $totalVaccinations, byVaccineType: $byVaccineType, upcoming: $upcoming, thisYear: $thisYear, last30Days: $last30Days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaccinationStatisticsImpl &&
            (identical(other.totalVaccinations, totalVaccinations) ||
                other.totalVaccinations == totalVaccinations) &&
            const DeepCollectionEquality().equals(
              other._byVaccineType,
              _byVaccineType,
            ) &&
            (identical(other.upcoming, upcoming) ||
                other.upcoming == upcoming) &&
            (identical(other.thisYear, thisYear) ||
                other.thisYear == thisYear) &&
            (identical(other.last30Days, last30Days) ||
                other.last30Days == last30Days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalVaccinations,
    const DeepCollectionEquality().hash(_byVaccineType),
    upcoming,
    thisYear,
    last30Days,
  );

  /// Create a copy of VaccinationStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaccinationStatisticsImplCopyWith<_$VaccinationStatisticsImpl>
  get copyWith =>
      __$$VaccinationStatisticsImplCopyWithImpl<_$VaccinationStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VaccinationStatisticsImplToJson(this);
  }
}

abstract class _VaccinationStatistics implements VaccinationStatistics {
  const factory _VaccinationStatistics({
    @JsonKey(name: 'total_vaccinations') required final int totalVaccinations,
    @JsonKey(name: 'by_vaccine_type')
    required final Map<String, int> byVaccineType,
    required final VaccinationUpcoming upcoming,
    @JsonKey(name: 'this_year') required final int thisYear,
    @JsonKey(name: 'last_30_days') required final int last30Days,
  }) = _$VaccinationStatisticsImpl;

  factory _VaccinationStatistics.fromJson(Map<String, dynamic> json) =
      _$VaccinationStatisticsImpl.fromJson;

  @override
  @JsonKey(name: 'total_vaccinations')
  int get totalVaccinations;
  @override
  @JsonKey(name: 'by_vaccine_type')
  Map<String, int> get byVaccineType;
  @override
  VaccinationUpcoming get upcoming;
  @override
  @JsonKey(name: 'this_year')
  int get thisYear;
  @override
  @JsonKey(name: 'last_30_days')
  int get last30Days;

  /// Create a copy of VaccinationStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaccinationStatisticsImplCopyWith<_$VaccinationStatisticsImpl>
  get copyWith => throw _privateConstructorUsedError;
}

VaccinationUpcoming _$VaccinationUpcomingFromJson(Map<String, dynamic> json) {
  return _VaccinationUpcoming.fromJson(json);
}

/// @nodoc
mixin _$VaccinationUpcoming {
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_30_days')
  int get next30Days => throw _privateConstructorUsedError;
  int get overdue => throw _privateConstructorUsedError;
  List<UpcomingVaccinationItem> get list => throw _privateConstructorUsedError;

  /// Serializes this VaccinationUpcoming to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VaccinationUpcoming
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaccinationUpcomingCopyWith<VaccinationUpcoming> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaccinationUpcomingCopyWith<$Res> {
  factory $VaccinationUpcomingCopyWith(
    VaccinationUpcoming value,
    $Res Function(VaccinationUpcoming) then,
  ) = _$VaccinationUpcomingCopyWithImpl<$Res, VaccinationUpcoming>;
  @useResult
  $Res call({
    int total,
    @JsonKey(name: 'next_30_days') int next30Days,
    int overdue,
    List<UpcomingVaccinationItem> list,
  });
}

/// @nodoc
class _$VaccinationUpcomingCopyWithImpl<$Res, $Val extends VaccinationUpcoming>
    implements $VaccinationUpcomingCopyWith<$Res> {
  _$VaccinationUpcomingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaccinationUpcoming
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? next30Days = null,
    Object? overdue = null,
    Object? list = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            next30Days: null == next30Days
                ? _value.next30Days
                : next30Days // ignore: cast_nullable_to_non_nullable
                      as int,
            overdue: null == overdue
                ? _value.overdue
                : overdue // ignore: cast_nullable_to_non_nullable
                      as int,
            list: null == list
                ? _value.list
                : list // ignore: cast_nullable_to_non_nullable
                      as List<UpcomingVaccinationItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VaccinationUpcomingImplCopyWith<$Res>
    implements $VaccinationUpcomingCopyWith<$Res> {
  factory _$$VaccinationUpcomingImplCopyWith(
    _$VaccinationUpcomingImpl value,
    $Res Function(_$VaccinationUpcomingImpl) then,
  ) = __$$VaccinationUpcomingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int total,
    @JsonKey(name: 'next_30_days') int next30Days,
    int overdue,
    List<UpcomingVaccinationItem> list,
  });
}

/// @nodoc
class __$$VaccinationUpcomingImplCopyWithImpl<$Res>
    extends _$VaccinationUpcomingCopyWithImpl<$Res, _$VaccinationUpcomingImpl>
    implements _$$VaccinationUpcomingImplCopyWith<$Res> {
  __$$VaccinationUpcomingImplCopyWithImpl(
    _$VaccinationUpcomingImpl _value,
    $Res Function(_$VaccinationUpcomingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VaccinationUpcoming
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? next30Days = null,
    Object? overdue = null,
    Object? list = null,
  }) {
    return _then(
      _$VaccinationUpcomingImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        next30Days: null == next30Days
            ? _value.next30Days
            : next30Days // ignore: cast_nullable_to_non_nullable
                  as int,
        overdue: null == overdue
            ? _value.overdue
            : overdue // ignore: cast_nullable_to_non_nullable
                  as int,
        list: null == list
            ? _value._list
            : list // ignore: cast_nullable_to_non_nullable
                  as List<UpcomingVaccinationItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VaccinationUpcomingImpl implements _VaccinationUpcoming {
  const _$VaccinationUpcomingImpl({
    required this.total,
    @JsonKey(name: 'next_30_days') required this.next30Days,
    required this.overdue,
    required final List<UpcomingVaccinationItem> list,
  }) : _list = list;

  factory _$VaccinationUpcomingImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaccinationUpcomingImplFromJson(json);

  @override
  final int total;
  @override
  @JsonKey(name: 'next_30_days')
  final int next30Days;
  @override
  final int overdue;
  final List<UpcomingVaccinationItem> _list;
  @override
  List<UpcomingVaccinationItem> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'VaccinationUpcoming(total: $total, next30Days: $next30Days, overdue: $overdue, list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaccinationUpcomingImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.next30Days, next30Days) ||
                other.next30Days == next30Days) &&
            (identical(other.overdue, overdue) || other.overdue == overdue) &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    total,
    next30Days,
    overdue,
    const DeepCollectionEquality().hash(_list),
  );

  /// Create a copy of VaccinationUpcoming
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaccinationUpcomingImplCopyWith<_$VaccinationUpcomingImpl> get copyWith =>
      __$$VaccinationUpcomingImplCopyWithImpl<_$VaccinationUpcomingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VaccinationUpcomingImplToJson(this);
  }
}

abstract class _VaccinationUpcoming implements VaccinationUpcoming {
  const factory _VaccinationUpcoming({
    required final int total,
    @JsonKey(name: 'next_30_days') required final int next30Days,
    required final int overdue,
    required final List<UpcomingVaccinationItem> list,
  }) = _$VaccinationUpcomingImpl;

  factory _VaccinationUpcoming.fromJson(Map<String, dynamic> json) =
      _$VaccinationUpcomingImpl.fromJson;

  @override
  int get total;
  @override
  @JsonKey(name: 'next_30_days')
  int get next30Days;
  @override
  int get overdue;
  @override
  List<UpcomingVaccinationItem> get list;

  /// Create a copy of VaccinationUpcoming
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaccinationUpcomingImplCopyWith<_$VaccinationUpcomingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpcomingVaccinationItem _$UpcomingVaccinationItemFromJson(
  Map<String, dynamic> json,
) {
  return _UpcomingVaccinationItem.fromJson(json);
}

/// @nodoc
mixin _$UpcomingVaccinationItem {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int get rabbitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_name')
  String? get rabbitName => throw _privateConstructorUsedError;
  @JsonKey(name: 'vaccine_name')
  String get vaccineName => throw _privateConstructorUsedError;
  @JsonKey(name: 'vaccine_type')
  VaccineType get vaccineType => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_vaccination_date')
  DateTime get nextVaccinationDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'days_until')
  int get daysUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_overdue')
  bool? get isOverdue => throw _privateConstructorUsedError;

  /// Serializes this UpcomingVaccinationItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpcomingVaccinationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpcomingVaccinationItemCopyWith<UpcomingVaccinationItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpcomingVaccinationItemCopyWith<$Res> {
  factory $UpcomingVaccinationItemCopyWith(
    UpcomingVaccinationItem value,
    $Res Function(UpcomingVaccinationItem) then,
  ) = _$UpcomingVaccinationItemCopyWithImpl<$Res, UpcomingVaccinationItem>;
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int rabbitId,
    @JsonKey(name: 'rabbit_name') String? rabbitName,
    @JsonKey(name: 'vaccine_name') String vaccineName,
    @JsonKey(name: 'vaccine_type') VaccineType vaccineType,
    @JsonKey(name: 'next_vaccination_date') DateTime nextVaccinationDate,
    @JsonKey(name: 'days_until') int daysUntil,
    @JsonKey(name: 'is_overdue') bool? isOverdue,
  });
}

/// @nodoc
class _$UpcomingVaccinationItemCopyWithImpl<
  $Res,
  $Val extends UpcomingVaccinationItem
>
    implements $UpcomingVaccinationItemCopyWith<$Res> {
  _$UpcomingVaccinationItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpcomingVaccinationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = null,
    Object? rabbitName = freezed,
    Object? vaccineName = null,
    Object? vaccineType = null,
    Object? nextVaccinationDate = null,
    Object? daysUntil = null,
    Object? isOverdue = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            rabbitId: null == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int,
            rabbitName: freezed == rabbitName
                ? _value.rabbitName
                : rabbitName // ignore: cast_nullable_to_non_nullable
                      as String?,
            vaccineName: null == vaccineName
                ? _value.vaccineName
                : vaccineName // ignore: cast_nullable_to_non_nullable
                      as String,
            vaccineType: null == vaccineType
                ? _value.vaccineType
                : vaccineType // ignore: cast_nullable_to_non_nullable
                      as VaccineType,
            nextVaccinationDate: null == nextVaccinationDate
                ? _value.nextVaccinationDate
                : nextVaccinationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            daysUntil: null == daysUntil
                ? _value.daysUntil
                : daysUntil // ignore: cast_nullable_to_non_nullable
                      as int,
            isOverdue: freezed == isOverdue
                ? _value.isOverdue
                : isOverdue // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpcomingVaccinationItemImplCopyWith<$Res>
    implements $UpcomingVaccinationItemCopyWith<$Res> {
  factory _$$UpcomingVaccinationItemImplCopyWith(
    _$UpcomingVaccinationItemImpl value,
    $Res Function(_$UpcomingVaccinationItemImpl) then,
  ) = __$$UpcomingVaccinationItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int rabbitId,
    @JsonKey(name: 'rabbit_name') String? rabbitName,
    @JsonKey(name: 'vaccine_name') String vaccineName,
    @JsonKey(name: 'vaccine_type') VaccineType vaccineType,
    @JsonKey(name: 'next_vaccination_date') DateTime nextVaccinationDate,
    @JsonKey(name: 'days_until') int daysUntil,
    @JsonKey(name: 'is_overdue') bool? isOverdue,
  });
}

/// @nodoc
class __$$UpcomingVaccinationItemImplCopyWithImpl<$Res>
    extends
        _$UpcomingVaccinationItemCopyWithImpl<
          $Res,
          _$UpcomingVaccinationItemImpl
        >
    implements _$$UpcomingVaccinationItemImplCopyWith<$Res> {
  __$$UpcomingVaccinationItemImplCopyWithImpl(
    _$UpcomingVaccinationItemImpl _value,
    $Res Function(_$UpcomingVaccinationItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpcomingVaccinationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = null,
    Object? rabbitName = freezed,
    Object? vaccineName = null,
    Object? vaccineType = null,
    Object? nextVaccinationDate = null,
    Object? daysUntil = null,
    Object? isOverdue = freezed,
  }) {
    return _then(
      _$UpcomingVaccinationItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        rabbitId: null == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int,
        rabbitName: freezed == rabbitName
            ? _value.rabbitName
            : rabbitName // ignore: cast_nullable_to_non_nullable
                  as String?,
        vaccineName: null == vaccineName
            ? _value.vaccineName
            : vaccineName // ignore: cast_nullable_to_non_nullable
                  as String,
        vaccineType: null == vaccineType
            ? _value.vaccineType
            : vaccineType // ignore: cast_nullable_to_non_nullable
                  as VaccineType,
        nextVaccinationDate: null == nextVaccinationDate
            ? _value.nextVaccinationDate
            : nextVaccinationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        daysUntil: null == daysUntil
            ? _value.daysUntil
            : daysUntil // ignore: cast_nullable_to_non_nullable
                  as int,
        isOverdue: freezed == isOverdue
            ? _value.isOverdue
            : isOverdue // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpcomingVaccinationItemImpl implements _UpcomingVaccinationItem {
  const _$UpcomingVaccinationItemImpl({
    @IntConverter() required this.id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required this.rabbitId,
    @JsonKey(name: 'rabbit_name') this.rabbitName,
    @JsonKey(name: 'vaccine_name') required this.vaccineName,
    @JsonKey(name: 'vaccine_type') required this.vaccineType,
    @JsonKey(name: 'next_vaccination_date') required this.nextVaccinationDate,
    @JsonKey(name: 'days_until') required this.daysUntil,
    @JsonKey(name: 'is_overdue') this.isOverdue,
  });

  factory _$UpcomingVaccinationItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpcomingVaccinationItemImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  final int rabbitId;
  @override
  @JsonKey(name: 'rabbit_name')
  final String? rabbitName;
  @override
  @JsonKey(name: 'vaccine_name')
  final String vaccineName;
  @override
  @JsonKey(name: 'vaccine_type')
  final VaccineType vaccineType;
  @override
  @JsonKey(name: 'next_vaccination_date')
  final DateTime nextVaccinationDate;
  @override
  @JsonKey(name: 'days_until')
  final int daysUntil;
  @override
  @JsonKey(name: 'is_overdue')
  final bool? isOverdue;

  @override
  String toString() {
    return 'UpcomingVaccinationItem(id: $id, rabbitId: $rabbitId, rabbitName: $rabbitName, vaccineName: $vaccineName, vaccineType: $vaccineType, nextVaccinationDate: $nextVaccinationDate, daysUntil: $daysUntil, isOverdue: $isOverdue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpcomingVaccinationItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.rabbitName, rabbitName) ||
                other.rabbitName == rabbitName) &&
            (identical(other.vaccineName, vaccineName) ||
                other.vaccineName == vaccineName) &&
            (identical(other.vaccineType, vaccineType) ||
                other.vaccineType == vaccineType) &&
            (identical(other.nextVaccinationDate, nextVaccinationDate) ||
                other.nextVaccinationDate == nextVaccinationDate) &&
            (identical(other.daysUntil, daysUntil) ||
                other.daysUntil == daysUntil) &&
            (identical(other.isOverdue, isOverdue) ||
                other.isOverdue == isOverdue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    rabbitId,
    rabbitName,
    vaccineName,
    vaccineType,
    nextVaccinationDate,
    daysUntil,
    isOverdue,
  );

  /// Create a copy of UpcomingVaccinationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpcomingVaccinationItemImplCopyWith<_$UpcomingVaccinationItemImpl>
  get copyWith =>
      __$$UpcomingVaccinationItemImplCopyWithImpl<
        _$UpcomingVaccinationItemImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpcomingVaccinationItemImplToJson(this);
  }
}

abstract class _UpcomingVaccinationItem implements UpcomingVaccinationItem {
  const factory _UpcomingVaccinationItem({
    @IntConverter() required final int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required final int rabbitId,
    @JsonKey(name: 'rabbit_name') final String? rabbitName,
    @JsonKey(name: 'vaccine_name') required final String vaccineName,
    @JsonKey(name: 'vaccine_type') required final VaccineType vaccineType,
    @JsonKey(name: 'next_vaccination_date')
    required final DateTime nextVaccinationDate,
    @JsonKey(name: 'days_until') required final int daysUntil,
    @JsonKey(name: 'is_overdue') final bool? isOverdue,
  }) = _$UpcomingVaccinationItemImpl;

  factory _UpcomingVaccinationItem.fromJson(Map<String, dynamic> json) =
      _$UpcomingVaccinationItemImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int get rabbitId;
  @override
  @JsonKey(name: 'rabbit_name')
  String? get rabbitName;
  @override
  @JsonKey(name: 'vaccine_name')
  String get vaccineName;
  @override
  @JsonKey(name: 'vaccine_type')
  VaccineType get vaccineType;
  @override
  @JsonKey(name: 'next_vaccination_date')
  DateTime get nextVaccinationDate;
  @override
  @JsonKey(name: 'days_until')
  int get daysUntil;
  @override
  @JsonKey(name: 'is_overdue')
  bool? get isOverdue;

  /// Create a copy of UpcomingVaccinationItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpcomingVaccinationItemImplCopyWith<_$UpcomingVaccinationItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}
