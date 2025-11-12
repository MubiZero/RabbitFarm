// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medical_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MedicalRecord _$MedicalRecordFromJson(Map<String, dynamic> json) {
  return _MedicalRecord.fromJson(json);
}

/// @nodoc
mixin _$MedicalRecord {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int get rabbitId => throw _privateConstructorUsedError;
  String get symptoms => throw _privateConstructorUsedError;
  String? get diagnosis => throw _privateConstructorUsedError;
  String? get treatment => throw _privateConstructorUsedError;
  String? get medication => throw _privateConstructorUsedError;
  String? get dosage => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: MedicalOutcome.ongoing)
  MedicalOutcome get outcome => throw _privateConstructorUsedError;
  @DoubleConverter()
  double? get cost => throw _privateConstructorUsedError;
  String? get veterinarian => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  RabbitModel? get rabbit => throw _privateConstructorUsedError;

  /// Serializes this MedicalRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalRecordCopyWith<MedicalRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalRecordCopyWith<$Res> {
  factory $MedicalRecordCopyWith(
    MedicalRecord value,
    $Res Function(MedicalRecord) then,
  ) = _$MedicalRecordCopyWithImpl<$Res, MedicalRecord>;
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int rabbitId,
    String symptoms,
    String? diagnosis,
    String? treatment,
    String? medication,
    String? dosage,
    @JsonKey(name: 'started_at') DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(defaultValue: MedicalOutcome.ongoing) MedicalOutcome outcome,
    @DoubleConverter() double? cost,
    String? veterinarian,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
  });

  $RabbitModelCopyWith<$Res>? get rabbit;
}

/// @nodoc
class _$MedicalRecordCopyWithImpl<$Res, $Val extends MedicalRecord>
    implements $MedicalRecordCopyWith<$Res> {
  _$MedicalRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = null,
    Object? symptoms = null,
    Object? diagnosis = freezed,
    Object? treatment = freezed,
    Object? medication = freezed,
    Object? dosage = freezed,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? outcome = null,
    Object? cost = freezed,
    Object? veterinarian = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? rabbit = freezed,
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
            symptoms: null == symptoms
                ? _value.symptoms
                : symptoms // ignore: cast_nullable_to_non_nullable
                      as String,
            diagnosis: freezed == diagnosis
                ? _value.diagnosis
                : diagnosis // ignore: cast_nullable_to_non_nullable
                      as String?,
            treatment: freezed == treatment
                ? _value.treatment
                : treatment // ignore: cast_nullable_to_non_nullable
                      as String?,
            medication: freezed == medication
                ? _value.medication
                : medication // ignore: cast_nullable_to_non_nullable
                      as String?,
            dosage: freezed == dosage
                ? _value.dosage
                : dosage // ignore: cast_nullable_to_non_nullable
                      as String?,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endedAt: freezed == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            outcome: null == outcome
                ? _value.outcome
                : outcome // ignore: cast_nullable_to_non_nullable
                      as MedicalOutcome,
            cost: freezed == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as double?,
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
                      as RabbitModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RabbitModelCopyWith<$Res>? get rabbit {
    if (_value.rabbit == null) {
      return null;
    }

    return $RabbitModelCopyWith<$Res>(_value.rabbit!, (value) {
      return _then(_value.copyWith(rabbit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MedicalRecordImplCopyWith<$Res>
    implements $MedicalRecordCopyWith<$Res> {
  factory _$$MedicalRecordImplCopyWith(
    _$MedicalRecordImpl value,
    $Res Function(_$MedicalRecordImpl) then,
  ) = __$$MedicalRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int rabbitId,
    String symptoms,
    String? diagnosis,
    String? treatment,
    String? medication,
    String? dosage,
    @JsonKey(name: 'started_at') DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(defaultValue: MedicalOutcome.ongoing) MedicalOutcome outcome,
    @DoubleConverter() double? cost,
    String? veterinarian,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
  });

  @override
  $RabbitModelCopyWith<$Res>? get rabbit;
}

/// @nodoc
class __$$MedicalRecordImplCopyWithImpl<$Res>
    extends _$MedicalRecordCopyWithImpl<$Res, _$MedicalRecordImpl>
    implements _$$MedicalRecordImplCopyWith<$Res> {
  __$$MedicalRecordImplCopyWithImpl(
    _$MedicalRecordImpl _value,
    $Res Function(_$MedicalRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = null,
    Object? symptoms = null,
    Object? diagnosis = freezed,
    Object? treatment = freezed,
    Object? medication = freezed,
    Object? dosage = freezed,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? outcome = null,
    Object? cost = freezed,
    Object? veterinarian = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? rabbit = freezed,
  }) {
    return _then(
      _$MedicalRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        rabbitId: null == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int,
        symptoms: null == symptoms
            ? _value.symptoms
            : symptoms // ignore: cast_nullable_to_non_nullable
                  as String,
        diagnosis: freezed == diagnosis
            ? _value.diagnosis
            : diagnosis // ignore: cast_nullable_to_non_nullable
                  as String?,
        treatment: freezed == treatment
            ? _value.treatment
            : treatment // ignore: cast_nullable_to_non_nullable
                  as String?,
        medication: freezed == medication
            ? _value.medication
            : medication // ignore: cast_nullable_to_non_nullable
                  as String?,
        dosage: freezed == dosage
            ? _value.dosage
            : dosage // ignore: cast_nullable_to_non_nullable
                  as String?,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endedAt: freezed == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        outcome: null == outcome
            ? _value.outcome
            : outcome // ignore: cast_nullable_to_non_nullable
                  as MedicalOutcome,
        cost: freezed == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as double?,
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
                  as RabbitModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalRecordImpl implements _MedicalRecord {
  const _$MedicalRecordImpl({
    @IntConverter() required this.id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required this.rabbitId,
    required this.symptoms,
    this.diagnosis,
    this.treatment,
    this.medication,
    this.dosage,
    @JsonKey(name: 'started_at') required this.startedAt,
    @JsonKey(name: 'ended_at') this.endedAt,
    @JsonKey(defaultValue: MedicalOutcome.ongoing) required this.outcome,
    @DoubleConverter() this.cost,
    this.veterinarian,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) this.rabbit,
  });

  factory _$MedicalRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalRecordImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  final int rabbitId;
  @override
  final String symptoms;
  @override
  final String? diagnosis;
  @override
  final String? treatment;
  @override
  final String? medication;
  @override
  final String? dosage;
  @override
  @JsonKey(name: 'started_at')
  final DateTime startedAt;
  @override
  @JsonKey(name: 'ended_at')
  final DateTime? endedAt;
  @override
  @JsonKey(defaultValue: MedicalOutcome.ongoing)
  final MedicalOutcome outcome;
  @override
  @DoubleConverter()
  final double? cost;
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
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final RabbitModel? rabbit;

  @override
  String toString() {
    return 'MedicalRecord(id: $id, rabbitId: $rabbitId, symptoms: $symptoms, diagnosis: $diagnosis, treatment: $treatment, medication: $medication, dosage: $dosage, startedAt: $startedAt, endedAt: $endedAt, outcome: $outcome, cost: $cost, veterinarian: $veterinarian, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, rabbit: $rabbit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.symptoms, symptoms) ||
                other.symptoms == symptoms) &&
            (identical(other.diagnosis, diagnosis) ||
                other.diagnosis == diagnosis) &&
            (identical(other.treatment, treatment) ||
                other.treatment == treatment) &&
            (identical(other.medication, medication) ||
                other.medication == medication) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.outcome, outcome) || other.outcome == outcome) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.veterinarian, veterinarian) ||
                other.veterinarian == veterinarian) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.rabbit, rabbit) || other.rabbit == rabbit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    rabbitId,
    symptoms,
    diagnosis,
    treatment,
    medication,
    dosage,
    startedAt,
    endedAt,
    outcome,
    cost,
    veterinarian,
    notes,
    createdAt,
    updatedAt,
    rabbit,
  );

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalRecordImplCopyWith<_$MedicalRecordImpl> get copyWith =>
      __$$MedicalRecordImplCopyWithImpl<_$MedicalRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalRecordImplToJson(this);
  }
}

abstract class _MedicalRecord implements MedicalRecord {
  const factory _MedicalRecord({
    @IntConverter() required final int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required final int rabbitId,
    required final String symptoms,
    final String? diagnosis,
    final String? treatment,
    final String? medication,
    final String? dosage,
    @JsonKey(name: 'started_at') required final DateTime startedAt,
    @JsonKey(name: 'ended_at') final DateTime? endedAt,
    @JsonKey(defaultValue: MedicalOutcome.ongoing)
    required final MedicalOutcome outcome,
    @DoubleConverter() final double? cost,
    final String? veterinarian,
    final String? notes,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final RabbitModel? rabbit,
  }) = _$MedicalRecordImpl;

  factory _MedicalRecord.fromJson(Map<String, dynamic> json) =
      _$MedicalRecordImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int get rabbitId;
  @override
  String get symptoms;
  @override
  String? get diagnosis;
  @override
  String? get treatment;
  @override
  String? get medication;
  @override
  String? get dosage;
  @override
  @JsonKey(name: 'started_at')
  DateTime get startedAt;
  @override
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt;
  @override
  @JsonKey(defaultValue: MedicalOutcome.ongoing)
  MedicalOutcome get outcome;
  @override
  @DoubleConverter()
  double? get cost;
  @override
  String? get veterinarian;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  RabbitModel? get rabbit;

  /// Create a copy of MedicalRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalRecordImplCopyWith<_$MedicalRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MedicalRecordCreate _$MedicalRecordCreateFromJson(Map<String, dynamic> json) {
  return _MedicalRecordCreate.fromJson(json);
}

/// @nodoc
mixin _$MedicalRecordCreate {
  @JsonKey(name: 'rabbit_id')
  int get rabbitId => throw _privateConstructorUsedError;
  String get symptoms => throw _privateConstructorUsedError;
  String? get diagnosis => throw _privateConstructorUsedError;
  String? get treatment => throw _privateConstructorUsedError;
  String? get medication => throw _privateConstructorUsedError;
  String? get dosage => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 'ongoing')
  String? get outcome => throw _privateConstructorUsedError;
  double? get cost => throw _privateConstructorUsedError;
  String? get veterinarian => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this MedicalRecordCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalRecordCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalRecordCreateCopyWith<MedicalRecordCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalRecordCreateCopyWith<$Res> {
  factory $MedicalRecordCreateCopyWith(
    MedicalRecordCreate value,
    $Res Function(MedicalRecordCreate) then,
  ) = _$MedicalRecordCreateCopyWithImpl<$Res, MedicalRecordCreate>;
  @useResult
  $Res call({
    @JsonKey(name: 'rabbit_id') int rabbitId,
    String symptoms,
    String? diagnosis,
    String? treatment,
    String? medication,
    String? dosage,
    @JsonKey(name: 'started_at') DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(defaultValue: 'ongoing') String? outcome,
    double? cost,
    String? veterinarian,
    String? notes,
  });
}

/// @nodoc
class _$MedicalRecordCreateCopyWithImpl<$Res, $Val extends MedicalRecordCreate>
    implements $MedicalRecordCreateCopyWith<$Res> {
  _$MedicalRecordCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalRecordCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rabbitId = null,
    Object? symptoms = null,
    Object? diagnosis = freezed,
    Object? treatment = freezed,
    Object? medication = freezed,
    Object? dosage = freezed,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? outcome = freezed,
    Object? cost = freezed,
    Object? veterinarian = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            rabbitId: null == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int,
            symptoms: null == symptoms
                ? _value.symptoms
                : symptoms // ignore: cast_nullable_to_non_nullable
                      as String,
            diagnosis: freezed == diagnosis
                ? _value.diagnosis
                : diagnosis // ignore: cast_nullable_to_non_nullable
                      as String?,
            treatment: freezed == treatment
                ? _value.treatment
                : treatment // ignore: cast_nullable_to_non_nullable
                      as String?,
            medication: freezed == medication
                ? _value.medication
                : medication // ignore: cast_nullable_to_non_nullable
                      as String?,
            dosage: freezed == dosage
                ? _value.dosage
                : dosage // ignore: cast_nullable_to_non_nullable
                      as String?,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endedAt: freezed == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            outcome: freezed == outcome
                ? _value.outcome
                : outcome // ignore: cast_nullable_to_non_nullable
                      as String?,
            cost: freezed == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as double?,
            veterinarian: freezed == veterinarian
                ? _value.veterinarian
                : veterinarian // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MedicalRecordCreateImplCopyWith<$Res>
    implements $MedicalRecordCreateCopyWith<$Res> {
  factory _$$MedicalRecordCreateImplCopyWith(
    _$MedicalRecordCreateImpl value,
    $Res Function(_$MedicalRecordCreateImpl) then,
  ) = __$$MedicalRecordCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'rabbit_id') int rabbitId,
    String symptoms,
    String? diagnosis,
    String? treatment,
    String? medication,
    String? dosage,
    @JsonKey(name: 'started_at') DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(defaultValue: 'ongoing') String? outcome,
    double? cost,
    String? veterinarian,
    String? notes,
  });
}

/// @nodoc
class __$$MedicalRecordCreateImplCopyWithImpl<$Res>
    extends _$MedicalRecordCreateCopyWithImpl<$Res, _$MedicalRecordCreateImpl>
    implements _$$MedicalRecordCreateImplCopyWith<$Res> {
  __$$MedicalRecordCreateImplCopyWithImpl(
    _$MedicalRecordCreateImpl _value,
    $Res Function(_$MedicalRecordCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MedicalRecordCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rabbitId = null,
    Object? symptoms = null,
    Object? diagnosis = freezed,
    Object? treatment = freezed,
    Object? medication = freezed,
    Object? dosage = freezed,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? outcome = freezed,
    Object? cost = freezed,
    Object? veterinarian = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$MedicalRecordCreateImpl(
        rabbitId: null == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int,
        symptoms: null == symptoms
            ? _value.symptoms
            : symptoms // ignore: cast_nullable_to_non_nullable
                  as String,
        diagnosis: freezed == diagnosis
            ? _value.diagnosis
            : diagnosis // ignore: cast_nullable_to_non_nullable
                  as String?,
        treatment: freezed == treatment
            ? _value.treatment
            : treatment // ignore: cast_nullable_to_non_nullable
                  as String?,
        medication: freezed == medication
            ? _value.medication
            : medication // ignore: cast_nullable_to_non_nullable
                  as String?,
        dosage: freezed == dosage
            ? _value.dosage
            : dosage // ignore: cast_nullable_to_non_nullable
                  as String?,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endedAt: freezed == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        outcome: freezed == outcome
            ? _value.outcome
            : outcome // ignore: cast_nullable_to_non_nullable
                  as String?,
        cost: freezed == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as double?,
        veterinarian: freezed == veterinarian
            ? _value.veterinarian
            : veterinarian // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalRecordCreateImpl implements _MedicalRecordCreate {
  const _$MedicalRecordCreateImpl({
    @JsonKey(name: 'rabbit_id') required this.rabbitId,
    required this.symptoms,
    this.diagnosis,
    this.treatment,
    this.medication,
    this.dosage,
    @JsonKey(name: 'started_at') required this.startedAt,
    @JsonKey(name: 'ended_at') this.endedAt,
    @JsonKey(defaultValue: 'ongoing') this.outcome,
    this.cost,
    this.veterinarian,
    this.notes,
  });

  factory _$MedicalRecordCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalRecordCreateImplFromJson(json);

  @override
  @JsonKey(name: 'rabbit_id')
  final int rabbitId;
  @override
  final String symptoms;
  @override
  final String? diagnosis;
  @override
  final String? treatment;
  @override
  final String? medication;
  @override
  final String? dosage;
  @override
  @JsonKey(name: 'started_at')
  final DateTime startedAt;
  @override
  @JsonKey(name: 'ended_at')
  final DateTime? endedAt;
  @override
  @JsonKey(defaultValue: 'ongoing')
  final String? outcome;
  @override
  final double? cost;
  @override
  final String? veterinarian;
  @override
  final String? notes;

  @override
  String toString() {
    return 'MedicalRecordCreate(rabbitId: $rabbitId, symptoms: $symptoms, diagnosis: $diagnosis, treatment: $treatment, medication: $medication, dosage: $dosage, startedAt: $startedAt, endedAt: $endedAt, outcome: $outcome, cost: $cost, veterinarian: $veterinarian, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalRecordCreateImpl &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.symptoms, symptoms) ||
                other.symptoms == symptoms) &&
            (identical(other.diagnosis, diagnosis) ||
                other.diagnosis == diagnosis) &&
            (identical(other.treatment, treatment) ||
                other.treatment == treatment) &&
            (identical(other.medication, medication) ||
                other.medication == medication) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.outcome, outcome) || other.outcome == outcome) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.veterinarian, veterinarian) ||
                other.veterinarian == veterinarian) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rabbitId,
    symptoms,
    diagnosis,
    treatment,
    medication,
    dosage,
    startedAt,
    endedAt,
    outcome,
    cost,
    veterinarian,
    notes,
  );

  /// Create a copy of MedicalRecordCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalRecordCreateImplCopyWith<_$MedicalRecordCreateImpl> get copyWith =>
      __$$MedicalRecordCreateImplCopyWithImpl<_$MedicalRecordCreateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalRecordCreateImplToJson(this);
  }
}

abstract class _MedicalRecordCreate implements MedicalRecordCreate {
  const factory _MedicalRecordCreate({
    @JsonKey(name: 'rabbit_id') required final int rabbitId,
    required final String symptoms,
    final String? diagnosis,
    final String? treatment,
    final String? medication,
    final String? dosage,
    @JsonKey(name: 'started_at') required final DateTime startedAt,
    @JsonKey(name: 'ended_at') final DateTime? endedAt,
    @JsonKey(defaultValue: 'ongoing') final String? outcome,
    final double? cost,
    final String? veterinarian,
    final String? notes,
  }) = _$MedicalRecordCreateImpl;

  factory _MedicalRecordCreate.fromJson(Map<String, dynamic> json) =
      _$MedicalRecordCreateImpl.fromJson;

  @override
  @JsonKey(name: 'rabbit_id')
  int get rabbitId;
  @override
  String get symptoms;
  @override
  String? get diagnosis;
  @override
  String? get treatment;
  @override
  String? get medication;
  @override
  String? get dosage;
  @override
  @JsonKey(name: 'started_at')
  DateTime get startedAt;
  @override
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt;
  @override
  @JsonKey(defaultValue: 'ongoing')
  String? get outcome;
  @override
  double? get cost;
  @override
  String? get veterinarian;
  @override
  String? get notes;

  /// Create a copy of MedicalRecordCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalRecordCreateImplCopyWith<_$MedicalRecordCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MedicalRecordUpdate _$MedicalRecordUpdateFromJson(Map<String, dynamic> json) {
  return _MedicalRecordUpdate.fromJson(json);
}

/// @nodoc
mixin _$MedicalRecordUpdate {
  @JsonKey(name: 'rabbit_id')
  int? get rabbitId => throw _privateConstructorUsedError;
  String? get symptoms => throw _privateConstructorUsedError;
  String? get diagnosis => throw _privateConstructorUsedError;
  String? get treatment => throw _privateConstructorUsedError;
  String? get medication => throw _privateConstructorUsedError;
  String? get dosage => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime? get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt => throw _privateConstructorUsedError;
  String? get outcome => throw _privateConstructorUsedError;
  double? get cost => throw _privateConstructorUsedError;
  String? get veterinarian => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this MedicalRecordUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalRecordUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalRecordUpdateCopyWith<MedicalRecordUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalRecordUpdateCopyWith<$Res> {
  factory $MedicalRecordUpdateCopyWith(
    MedicalRecordUpdate value,
    $Res Function(MedicalRecordUpdate) then,
  ) = _$MedicalRecordUpdateCopyWithImpl<$Res, MedicalRecordUpdate>;
  @useResult
  $Res call({
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    String? symptoms,
    String? diagnosis,
    String? treatment,
    String? medication,
    String? dosage,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    String? outcome,
    double? cost,
    String? veterinarian,
    String? notes,
  });
}

/// @nodoc
class _$MedicalRecordUpdateCopyWithImpl<$Res, $Val extends MedicalRecordUpdate>
    implements $MedicalRecordUpdateCopyWith<$Res> {
  _$MedicalRecordUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalRecordUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rabbitId = freezed,
    Object? symptoms = freezed,
    Object? diagnosis = freezed,
    Object? treatment = freezed,
    Object? medication = freezed,
    Object? dosage = freezed,
    Object? startedAt = freezed,
    Object? endedAt = freezed,
    Object? outcome = freezed,
    Object? cost = freezed,
    Object? veterinarian = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            symptoms: freezed == symptoms
                ? _value.symptoms
                : symptoms // ignore: cast_nullable_to_non_nullable
                      as String?,
            diagnosis: freezed == diagnosis
                ? _value.diagnosis
                : diagnosis // ignore: cast_nullable_to_non_nullable
                      as String?,
            treatment: freezed == treatment
                ? _value.treatment
                : treatment // ignore: cast_nullable_to_non_nullable
                      as String?,
            medication: freezed == medication
                ? _value.medication
                : medication // ignore: cast_nullable_to_non_nullable
                      as String?,
            dosage: freezed == dosage
                ? _value.dosage
                : dosage // ignore: cast_nullable_to_non_nullable
                      as String?,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endedAt: freezed == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            outcome: freezed == outcome
                ? _value.outcome
                : outcome // ignore: cast_nullable_to_non_nullable
                      as String?,
            cost: freezed == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as double?,
            veterinarian: freezed == veterinarian
                ? _value.veterinarian
                : veterinarian // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MedicalRecordUpdateImplCopyWith<$Res>
    implements $MedicalRecordUpdateCopyWith<$Res> {
  factory _$$MedicalRecordUpdateImplCopyWith(
    _$MedicalRecordUpdateImpl value,
    $Res Function(_$MedicalRecordUpdateImpl) then,
  ) = __$$MedicalRecordUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    String? symptoms,
    String? diagnosis,
    String? treatment,
    String? medication,
    String? dosage,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    String? outcome,
    double? cost,
    String? veterinarian,
    String? notes,
  });
}

/// @nodoc
class __$$MedicalRecordUpdateImplCopyWithImpl<$Res>
    extends _$MedicalRecordUpdateCopyWithImpl<$Res, _$MedicalRecordUpdateImpl>
    implements _$$MedicalRecordUpdateImplCopyWith<$Res> {
  __$$MedicalRecordUpdateImplCopyWithImpl(
    _$MedicalRecordUpdateImpl _value,
    $Res Function(_$MedicalRecordUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MedicalRecordUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rabbitId = freezed,
    Object? symptoms = freezed,
    Object? diagnosis = freezed,
    Object? treatment = freezed,
    Object? medication = freezed,
    Object? dosage = freezed,
    Object? startedAt = freezed,
    Object? endedAt = freezed,
    Object? outcome = freezed,
    Object? cost = freezed,
    Object? veterinarian = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$MedicalRecordUpdateImpl(
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        symptoms: freezed == symptoms
            ? _value.symptoms
            : symptoms // ignore: cast_nullable_to_non_nullable
                  as String?,
        diagnosis: freezed == diagnosis
            ? _value.diagnosis
            : diagnosis // ignore: cast_nullable_to_non_nullable
                  as String?,
        treatment: freezed == treatment
            ? _value.treatment
            : treatment // ignore: cast_nullable_to_non_nullable
                  as String?,
        medication: freezed == medication
            ? _value.medication
            : medication // ignore: cast_nullable_to_non_nullable
                  as String?,
        dosage: freezed == dosage
            ? _value.dosage
            : dosage // ignore: cast_nullable_to_non_nullable
                  as String?,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endedAt: freezed == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        outcome: freezed == outcome
            ? _value.outcome
            : outcome // ignore: cast_nullable_to_non_nullable
                  as String?,
        cost: freezed == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as double?,
        veterinarian: freezed == veterinarian
            ? _value.veterinarian
            : veterinarian // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalRecordUpdateImpl implements _MedicalRecordUpdate {
  const _$MedicalRecordUpdateImpl({
    @JsonKey(name: 'rabbit_id') this.rabbitId,
    this.symptoms,
    this.diagnosis,
    this.treatment,
    this.medication,
    this.dosage,
    @JsonKey(name: 'started_at') this.startedAt,
    @JsonKey(name: 'ended_at') this.endedAt,
    this.outcome,
    this.cost,
    this.veterinarian,
    this.notes,
  });

  factory _$MedicalRecordUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalRecordUpdateImplFromJson(json);

  @override
  @JsonKey(name: 'rabbit_id')
  final int? rabbitId;
  @override
  final String? symptoms;
  @override
  final String? diagnosis;
  @override
  final String? treatment;
  @override
  final String? medication;
  @override
  final String? dosage;
  @override
  @JsonKey(name: 'started_at')
  final DateTime? startedAt;
  @override
  @JsonKey(name: 'ended_at')
  final DateTime? endedAt;
  @override
  final String? outcome;
  @override
  final double? cost;
  @override
  final String? veterinarian;
  @override
  final String? notes;

  @override
  String toString() {
    return 'MedicalRecordUpdate(rabbitId: $rabbitId, symptoms: $symptoms, diagnosis: $diagnosis, treatment: $treatment, medication: $medication, dosage: $dosage, startedAt: $startedAt, endedAt: $endedAt, outcome: $outcome, cost: $cost, veterinarian: $veterinarian, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalRecordUpdateImpl &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.symptoms, symptoms) ||
                other.symptoms == symptoms) &&
            (identical(other.diagnosis, diagnosis) ||
                other.diagnosis == diagnosis) &&
            (identical(other.treatment, treatment) ||
                other.treatment == treatment) &&
            (identical(other.medication, medication) ||
                other.medication == medication) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.outcome, outcome) || other.outcome == outcome) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.veterinarian, veterinarian) ||
                other.veterinarian == veterinarian) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rabbitId,
    symptoms,
    diagnosis,
    treatment,
    medication,
    dosage,
    startedAt,
    endedAt,
    outcome,
    cost,
    veterinarian,
    notes,
  );

  /// Create a copy of MedicalRecordUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalRecordUpdateImplCopyWith<_$MedicalRecordUpdateImpl> get copyWith =>
      __$$MedicalRecordUpdateImplCopyWithImpl<_$MedicalRecordUpdateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalRecordUpdateImplToJson(this);
  }
}

abstract class _MedicalRecordUpdate implements MedicalRecordUpdate {
  const factory _MedicalRecordUpdate({
    @JsonKey(name: 'rabbit_id') final int? rabbitId,
    final String? symptoms,
    final String? diagnosis,
    final String? treatment,
    final String? medication,
    final String? dosage,
    @JsonKey(name: 'started_at') final DateTime? startedAt,
    @JsonKey(name: 'ended_at') final DateTime? endedAt,
    final String? outcome,
    final double? cost,
    final String? veterinarian,
    final String? notes,
  }) = _$MedicalRecordUpdateImpl;

  factory _MedicalRecordUpdate.fromJson(Map<String, dynamic> json) =
      _$MedicalRecordUpdateImpl.fromJson;

  @override
  @JsonKey(name: 'rabbit_id')
  int? get rabbitId;
  @override
  String? get symptoms;
  @override
  String? get diagnosis;
  @override
  String? get treatment;
  @override
  String? get medication;
  @override
  String? get dosage;
  @override
  @JsonKey(name: 'started_at')
  DateTime? get startedAt;
  @override
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt;
  @override
  String? get outcome;
  @override
  double? get cost;
  @override
  String? get veterinarian;
  @override
  String? get notes;

  /// Create a copy of MedicalRecordUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalRecordUpdateImplCopyWith<_$MedicalRecordUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MedicalStatistics _$MedicalStatisticsFromJson(Map<String, dynamic> json) {
  return _MedicalStatistics.fromJson(json);
}

/// @nodoc
mixin _$MedicalStatistics {
  @JsonKey(name: 'total_records')
  int get totalRecords => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_outcome')
  MedicalOutcomeStats get byOutcome => throw _privateConstructorUsedError;
  @JsonKey(name: 'ongoing_treatments')
  List<OngoingTreatment> get ongoingTreatments =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'total_cost')
  double get totalCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'this_year')
  int get thisYear => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_month')
  int get lastMonth => throw _privateConstructorUsedError;

  /// Serializes this MedicalStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalStatisticsCopyWith<MedicalStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalStatisticsCopyWith<$Res> {
  factory $MedicalStatisticsCopyWith(
    MedicalStatistics value,
    $Res Function(MedicalStatistics) then,
  ) = _$MedicalStatisticsCopyWithImpl<$Res, MedicalStatistics>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_records') int totalRecords,
    @JsonKey(name: 'by_outcome') MedicalOutcomeStats byOutcome,
    @JsonKey(name: 'ongoing_treatments')
    List<OngoingTreatment> ongoingTreatments,
    @JsonKey(name: 'total_cost') double totalCost,
    @JsonKey(name: 'this_year') int thisYear,
    @JsonKey(name: 'last_month') int lastMonth,
  });

  $MedicalOutcomeStatsCopyWith<$Res> get byOutcome;
}

/// @nodoc
class _$MedicalStatisticsCopyWithImpl<$Res, $Val extends MedicalStatistics>
    implements $MedicalStatisticsCopyWith<$Res> {
  _$MedicalStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRecords = null,
    Object? byOutcome = null,
    Object? ongoingTreatments = null,
    Object? totalCost = null,
    Object? thisYear = null,
    Object? lastMonth = null,
  }) {
    return _then(
      _value.copyWith(
            totalRecords: null == totalRecords
                ? _value.totalRecords
                : totalRecords // ignore: cast_nullable_to_non_nullable
                      as int,
            byOutcome: null == byOutcome
                ? _value.byOutcome
                : byOutcome // ignore: cast_nullable_to_non_nullable
                      as MedicalOutcomeStats,
            ongoingTreatments: null == ongoingTreatments
                ? _value.ongoingTreatments
                : ongoingTreatments // ignore: cast_nullable_to_non_nullable
                      as List<OngoingTreatment>,
            totalCost: null == totalCost
                ? _value.totalCost
                : totalCost // ignore: cast_nullable_to_non_nullable
                      as double,
            thisYear: null == thisYear
                ? _value.thisYear
                : thisYear // ignore: cast_nullable_to_non_nullable
                      as int,
            lastMonth: null == lastMonth
                ? _value.lastMonth
                : lastMonth // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of MedicalStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicalOutcomeStatsCopyWith<$Res> get byOutcome {
    return $MedicalOutcomeStatsCopyWith<$Res>(_value.byOutcome, (value) {
      return _then(_value.copyWith(byOutcome: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MedicalStatisticsImplCopyWith<$Res>
    implements $MedicalStatisticsCopyWith<$Res> {
  factory _$$MedicalStatisticsImplCopyWith(
    _$MedicalStatisticsImpl value,
    $Res Function(_$MedicalStatisticsImpl) then,
  ) = __$$MedicalStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_records') int totalRecords,
    @JsonKey(name: 'by_outcome') MedicalOutcomeStats byOutcome,
    @JsonKey(name: 'ongoing_treatments')
    List<OngoingTreatment> ongoingTreatments,
    @JsonKey(name: 'total_cost') double totalCost,
    @JsonKey(name: 'this_year') int thisYear,
    @JsonKey(name: 'last_month') int lastMonth,
  });

  @override
  $MedicalOutcomeStatsCopyWith<$Res> get byOutcome;
}

/// @nodoc
class __$$MedicalStatisticsImplCopyWithImpl<$Res>
    extends _$MedicalStatisticsCopyWithImpl<$Res, _$MedicalStatisticsImpl>
    implements _$$MedicalStatisticsImplCopyWith<$Res> {
  __$$MedicalStatisticsImplCopyWithImpl(
    _$MedicalStatisticsImpl _value,
    $Res Function(_$MedicalStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MedicalStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRecords = null,
    Object? byOutcome = null,
    Object? ongoingTreatments = null,
    Object? totalCost = null,
    Object? thisYear = null,
    Object? lastMonth = null,
  }) {
    return _then(
      _$MedicalStatisticsImpl(
        totalRecords: null == totalRecords
            ? _value.totalRecords
            : totalRecords // ignore: cast_nullable_to_non_nullable
                  as int,
        byOutcome: null == byOutcome
            ? _value.byOutcome
            : byOutcome // ignore: cast_nullable_to_non_nullable
                  as MedicalOutcomeStats,
        ongoingTreatments: null == ongoingTreatments
            ? _value._ongoingTreatments
            : ongoingTreatments // ignore: cast_nullable_to_non_nullable
                  as List<OngoingTreatment>,
        totalCost: null == totalCost
            ? _value.totalCost
            : totalCost // ignore: cast_nullable_to_non_nullable
                  as double,
        thisYear: null == thisYear
            ? _value.thisYear
            : thisYear // ignore: cast_nullable_to_non_nullable
                  as int,
        lastMonth: null == lastMonth
            ? _value.lastMonth
            : lastMonth // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalStatisticsImpl implements _MedicalStatistics {
  const _$MedicalStatisticsImpl({
    @JsonKey(name: 'total_records') required this.totalRecords,
    @JsonKey(name: 'by_outcome') required this.byOutcome,
    @JsonKey(name: 'ongoing_treatments')
    required final List<OngoingTreatment> ongoingTreatments,
    @JsonKey(name: 'total_cost') required this.totalCost,
    @JsonKey(name: 'this_year') required this.thisYear,
    @JsonKey(name: 'last_month') required this.lastMonth,
  }) : _ongoingTreatments = ongoingTreatments;

  factory _$MedicalStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalStatisticsImplFromJson(json);

  @override
  @JsonKey(name: 'total_records')
  final int totalRecords;
  @override
  @JsonKey(name: 'by_outcome')
  final MedicalOutcomeStats byOutcome;
  final List<OngoingTreatment> _ongoingTreatments;
  @override
  @JsonKey(name: 'ongoing_treatments')
  List<OngoingTreatment> get ongoingTreatments {
    if (_ongoingTreatments is EqualUnmodifiableListView)
      return _ongoingTreatments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ongoingTreatments);
  }

  @override
  @JsonKey(name: 'total_cost')
  final double totalCost;
  @override
  @JsonKey(name: 'this_year')
  final int thisYear;
  @override
  @JsonKey(name: 'last_month')
  final int lastMonth;

  @override
  String toString() {
    return 'MedicalStatistics(totalRecords: $totalRecords, byOutcome: $byOutcome, ongoingTreatments: $ongoingTreatments, totalCost: $totalCost, thisYear: $thisYear, lastMonth: $lastMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalStatisticsImpl &&
            (identical(other.totalRecords, totalRecords) ||
                other.totalRecords == totalRecords) &&
            (identical(other.byOutcome, byOutcome) ||
                other.byOutcome == byOutcome) &&
            const DeepCollectionEquality().equals(
              other._ongoingTreatments,
              _ongoingTreatments,
            ) &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost) &&
            (identical(other.thisYear, thisYear) ||
                other.thisYear == thisYear) &&
            (identical(other.lastMonth, lastMonth) ||
                other.lastMonth == lastMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalRecords,
    byOutcome,
    const DeepCollectionEquality().hash(_ongoingTreatments),
    totalCost,
    thisYear,
    lastMonth,
  );

  /// Create a copy of MedicalStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalStatisticsImplCopyWith<_$MedicalStatisticsImpl> get copyWith =>
      __$$MedicalStatisticsImplCopyWithImpl<_$MedicalStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalStatisticsImplToJson(this);
  }
}

abstract class _MedicalStatistics implements MedicalStatistics {
  const factory _MedicalStatistics({
    @JsonKey(name: 'total_records') required final int totalRecords,
    @JsonKey(name: 'by_outcome') required final MedicalOutcomeStats byOutcome,
    @JsonKey(name: 'ongoing_treatments')
    required final List<OngoingTreatment> ongoingTreatments,
    @JsonKey(name: 'total_cost') required final double totalCost,
    @JsonKey(name: 'this_year') required final int thisYear,
    @JsonKey(name: 'last_month') required final int lastMonth,
  }) = _$MedicalStatisticsImpl;

  factory _MedicalStatistics.fromJson(Map<String, dynamic> json) =
      _$MedicalStatisticsImpl.fromJson;

  @override
  @JsonKey(name: 'total_records')
  int get totalRecords;
  @override
  @JsonKey(name: 'by_outcome')
  MedicalOutcomeStats get byOutcome;
  @override
  @JsonKey(name: 'ongoing_treatments')
  List<OngoingTreatment> get ongoingTreatments;
  @override
  @JsonKey(name: 'total_cost')
  double get totalCost;
  @override
  @JsonKey(name: 'this_year')
  int get thisYear;
  @override
  @JsonKey(name: 'last_month')
  int get lastMonth;

  /// Create a copy of MedicalStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalStatisticsImplCopyWith<_$MedicalStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MedicalOutcomeStats _$MedicalOutcomeStatsFromJson(Map<String, dynamic> json) {
  return _MedicalOutcomeStats.fromJson(json);
}

/// @nodoc
mixin _$MedicalOutcomeStats {
  @JsonKey(defaultValue: 0)
  int get recovered => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0)
  int get ongoing => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0)
  int get died => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0)
  int get euthanized => throw _privateConstructorUsedError;

  /// Serializes this MedicalOutcomeStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalOutcomeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalOutcomeStatsCopyWith<MedicalOutcomeStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalOutcomeStatsCopyWith<$Res> {
  factory $MedicalOutcomeStatsCopyWith(
    MedicalOutcomeStats value,
    $Res Function(MedicalOutcomeStats) then,
  ) = _$MedicalOutcomeStatsCopyWithImpl<$Res, MedicalOutcomeStats>;
  @useResult
  $Res call({
    @JsonKey(defaultValue: 0) int recovered,
    @JsonKey(defaultValue: 0) int ongoing,
    @JsonKey(defaultValue: 0) int died,
    @JsonKey(defaultValue: 0) int euthanized,
  });
}

/// @nodoc
class _$MedicalOutcomeStatsCopyWithImpl<$Res, $Val extends MedicalOutcomeStats>
    implements $MedicalOutcomeStatsCopyWith<$Res> {
  _$MedicalOutcomeStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalOutcomeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recovered = null,
    Object? ongoing = null,
    Object? died = null,
    Object? euthanized = null,
  }) {
    return _then(
      _value.copyWith(
            recovered: null == recovered
                ? _value.recovered
                : recovered // ignore: cast_nullable_to_non_nullable
                      as int,
            ongoing: null == ongoing
                ? _value.ongoing
                : ongoing // ignore: cast_nullable_to_non_nullable
                      as int,
            died: null == died
                ? _value.died
                : died // ignore: cast_nullable_to_non_nullable
                      as int,
            euthanized: null == euthanized
                ? _value.euthanized
                : euthanized // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MedicalOutcomeStatsImplCopyWith<$Res>
    implements $MedicalOutcomeStatsCopyWith<$Res> {
  factory _$$MedicalOutcomeStatsImplCopyWith(
    _$MedicalOutcomeStatsImpl value,
    $Res Function(_$MedicalOutcomeStatsImpl) then,
  ) = __$$MedicalOutcomeStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(defaultValue: 0) int recovered,
    @JsonKey(defaultValue: 0) int ongoing,
    @JsonKey(defaultValue: 0) int died,
    @JsonKey(defaultValue: 0) int euthanized,
  });
}

/// @nodoc
class __$$MedicalOutcomeStatsImplCopyWithImpl<$Res>
    extends _$MedicalOutcomeStatsCopyWithImpl<$Res, _$MedicalOutcomeStatsImpl>
    implements _$$MedicalOutcomeStatsImplCopyWith<$Res> {
  __$$MedicalOutcomeStatsImplCopyWithImpl(
    _$MedicalOutcomeStatsImpl _value,
    $Res Function(_$MedicalOutcomeStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MedicalOutcomeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recovered = null,
    Object? ongoing = null,
    Object? died = null,
    Object? euthanized = null,
  }) {
    return _then(
      _$MedicalOutcomeStatsImpl(
        recovered: null == recovered
            ? _value.recovered
            : recovered // ignore: cast_nullable_to_non_nullable
                  as int,
        ongoing: null == ongoing
            ? _value.ongoing
            : ongoing // ignore: cast_nullable_to_non_nullable
                  as int,
        died: null == died
            ? _value.died
            : died // ignore: cast_nullable_to_non_nullable
                  as int,
        euthanized: null == euthanized
            ? _value.euthanized
            : euthanized // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalOutcomeStatsImpl implements _MedicalOutcomeStats {
  const _$MedicalOutcomeStatsImpl({
    @JsonKey(defaultValue: 0) required this.recovered,
    @JsonKey(defaultValue: 0) required this.ongoing,
    @JsonKey(defaultValue: 0) required this.died,
    @JsonKey(defaultValue: 0) required this.euthanized,
  });

  factory _$MedicalOutcomeStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalOutcomeStatsImplFromJson(json);

  @override
  @JsonKey(defaultValue: 0)
  final int recovered;
  @override
  @JsonKey(defaultValue: 0)
  final int ongoing;
  @override
  @JsonKey(defaultValue: 0)
  final int died;
  @override
  @JsonKey(defaultValue: 0)
  final int euthanized;

  @override
  String toString() {
    return 'MedicalOutcomeStats(recovered: $recovered, ongoing: $ongoing, died: $died, euthanized: $euthanized)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalOutcomeStatsImpl &&
            (identical(other.recovered, recovered) ||
                other.recovered == recovered) &&
            (identical(other.ongoing, ongoing) || other.ongoing == ongoing) &&
            (identical(other.died, died) || other.died == died) &&
            (identical(other.euthanized, euthanized) ||
                other.euthanized == euthanized));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, recovered, ongoing, died, euthanized);

  /// Create a copy of MedicalOutcomeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalOutcomeStatsImplCopyWith<_$MedicalOutcomeStatsImpl> get copyWith =>
      __$$MedicalOutcomeStatsImplCopyWithImpl<_$MedicalOutcomeStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalOutcomeStatsImplToJson(this);
  }
}

abstract class _MedicalOutcomeStats implements MedicalOutcomeStats {
  const factory _MedicalOutcomeStats({
    @JsonKey(defaultValue: 0) required final int recovered,
    @JsonKey(defaultValue: 0) required final int ongoing,
    @JsonKey(defaultValue: 0) required final int died,
    @JsonKey(defaultValue: 0) required final int euthanized,
  }) = _$MedicalOutcomeStatsImpl;

  factory _MedicalOutcomeStats.fromJson(Map<String, dynamic> json) =
      _$MedicalOutcomeStatsImpl.fromJson;

  @override
  @JsonKey(defaultValue: 0)
  int get recovered;
  @override
  @JsonKey(defaultValue: 0)
  int get ongoing;
  @override
  @JsonKey(defaultValue: 0)
  int get died;
  @override
  @JsonKey(defaultValue: 0)
  int get euthanized;

  /// Create a copy of MedicalOutcomeStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalOutcomeStatsImplCopyWith<_$MedicalOutcomeStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OngoingTreatment _$OngoingTreatmentFromJson(Map<String, dynamic> json) {
  return _OngoingTreatment.fromJson(json);
}

/// @nodoc
mixin _$OngoingTreatment {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int get rabbitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_name')
  String? get rabbitName => throw _privateConstructorUsedError;
  String? get diagnosis => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'days_ongoing')
  int get daysOngoing => throw _privateConstructorUsedError;
  String? get symptoms => throw _privateConstructorUsedError;

  /// Serializes this OngoingTreatment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OngoingTreatment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OngoingTreatmentCopyWith<OngoingTreatment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OngoingTreatmentCopyWith<$Res> {
  factory $OngoingTreatmentCopyWith(
    OngoingTreatment value,
    $Res Function(OngoingTreatment) then,
  ) = _$OngoingTreatmentCopyWithImpl<$Res, OngoingTreatment>;
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int rabbitId,
    @JsonKey(name: 'rabbit_name') String? rabbitName,
    String? diagnosis,
    @JsonKey(name: 'started_at') DateTime startedAt,
    @JsonKey(name: 'days_ongoing') int daysOngoing,
    String? symptoms,
  });
}

/// @nodoc
class _$OngoingTreatmentCopyWithImpl<$Res, $Val extends OngoingTreatment>
    implements $OngoingTreatmentCopyWith<$Res> {
  _$OngoingTreatmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OngoingTreatment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = null,
    Object? rabbitName = freezed,
    Object? diagnosis = freezed,
    Object? startedAt = null,
    Object? daysOngoing = null,
    Object? symptoms = freezed,
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
            diagnosis: freezed == diagnosis
                ? _value.diagnosis
                : diagnosis // ignore: cast_nullable_to_non_nullable
                      as String?,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            daysOngoing: null == daysOngoing
                ? _value.daysOngoing
                : daysOngoing // ignore: cast_nullable_to_non_nullable
                      as int,
            symptoms: freezed == symptoms
                ? _value.symptoms
                : symptoms // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OngoingTreatmentImplCopyWith<$Res>
    implements $OngoingTreatmentCopyWith<$Res> {
  factory _$$OngoingTreatmentImplCopyWith(
    _$OngoingTreatmentImpl value,
    $Res Function(_$OngoingTreatmentImpl) then,
  ) = __$$OngoingTreatmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int rabbitId,
    @JsonKey(name: 'rabbit_name') String? rabbitName,
    String? diagnosis,
    @JsonKey(name: 'started_at') DateTime startedAt,
    @JsonKey(name: 'days_ongoing') int daysOngoing,
    String? symptoms,
  });
}

/// @nodoc
class __$$OngoingTreatmentImplCopyWithImpl<$Res>
    extends _$OngoingTreatmentCopyWithImpl<$Res, _$OngoingTreatmentImpl>
    implements _$$OngoingTreatmentImplCopyWith<$Res> {
  __$$OngoingTreatmentImplCopyWithImpl(
    _$OngoingTreatmentImpl _value,
    $Res Function(_$OngoingTreatmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OngoingTreatment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = null,
    Object? rabbitName = freezed,
    Object? diagnosis = freezed,
    Object? startedAt = null,
    Object? daysOngoing = null,
    Object? symptoms = freezed,
  }) {
    return _then(
      _$OngoingTreatmentImpl(
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
        diagnosis: freezed == diagnosis
            ? _value.diagnosis
            : diagnosis // ignore: cast_nullable_to_non_nullable
                  as String?,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        daysOngoing: null == daysOngoing
            ? _value.daysOngoing
            : daysOngoing // ignore: cast_nullable_to_non_nullable
                  as int,
        symptoms: freezed == symptoms
            ? _value.symptoms
            : symptoms // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OngoingTreatmentImpl implements _OngoingTreatment {
  const _$OngoingTreatmentImpl({
    @IntConverter() required this.id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required this.rabbitId,
    @JsonKey(name: 'rabbit_name') this.rabbitName,
    this.diagnosis,
    @JsonKey(name: 'started_at') required this.startedAt,
    @JsonKey(name: 'days_ongoing') required this.daysOngoing,
    this.symptoms,
  });

  factory _$OngoingTreatmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$OngoingTreatmentImplFromJson(json);

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
  final String? diagnosis;
  @override
  @JsonKey(name: 'started_at')
  final DateTime startedAt;
  @override
  @JsonKey(name: 'days_ongoing')
  final int daysOngoing;
  @override
  final String? symptoms;

  @override
  String toString() {
    return 'OngoingTreatment(id: $id, rabbitId: $rabbitId, rabbitName: $rabbitName, diagnosis: $diagnosis, startedAt: $startedAt, daysOngoing: $daysOngoing, symptoms: $symptoms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OngoingTreatmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.rabbitName, rabbitName) ||
                other.rabbitName == rabbitName) &&
            (identical(other.diagnosis, diagnosis) ||
                other.diagnosis == diagnosis) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.daysOngoing, daysOngoing) ||
                other.daysOngoing == daysOngoing) &&
            (identical(other.symptoms, symptoms) ||
                other.symptoms == symptoms));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    rabbitId,
    rabbitName,
    diagnosis,
    startedAt,
    daysOngoing,
    symptoms,
  );

  /// Create a copy of OngoingTreatment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OngoingTreatmentImplCopyWith<_$OngoingTreatmentImpl> get copyWith =>
      __$$OngoingTreatmentImplCopyWithImpl<_$OngoingTreatmentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OngoingTreatmentImplToJson(this);
  }
}

abstract class _OngoingTreatment implements OngoingTreatment {
  const factory _OngoingTreatment({
    @IntConverter() required final int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required final int rabbitId,
    @JsonKey(name: 'rabbit_name') final String? rabbitName,
    final String? diagnosis,
    @JsonKey(name: 'started_at') required final DateTime startedAt,
    @JsonKey(name: 'days_ongoing') required final int daysOngoing,
    final String? symptoms,
  }) = _$OngoingTreatmentImpl;

  factory _OngoingTreatment.fromJson(Map<String, dynamic> json) =
      _$OngoingTreatmentImpl.fromJson;

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
  String? get diagnosis;
  @override
  @JsonKey(name: 'started_at')
  DateTime get startedAt;
  @override
  @JsonKey(name: 'days_ongoing')
  int get daysOngoing;
  @override
  String? get symptoms;

  /// Create a copy of OngoingTreatment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OngoingTreatmentImplCopyWith<_$OngoingTreatmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MedicalRecordWithDays _$MedicalRecordWithDaysFromJson(
  Map<String, dynamic> json,
) {
  return _MedicalRecordWithDays.fromJson(json);
}

/// @nodoc
mixin _$MedicalRecordWithDays {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int get rabbitId => throw _privateConstructorUsedError;
  String get symptoms => throw _privateConstructorUsedError;
  String? get diagnosis => throw _privateConstructorUsedError;
  String? get treatment => throw _privateConstructorUsedError;
  String? get medication => throw _privateConstructorUsedError;
  String? get dosage => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: MedicalOutcome.ongoing)
  MedicalOutcome get outcome => throw _privateConstructorUsedError;
  @DoubleConverter()
  double? get cost => throw _privateConstructorUsedError;
  String? get veterinarian => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'days_ongoing')
  int get daysOngoing => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  RabbitModel? get rabbit => throw _privateConstructorUsedError;

  /// Serializes this MedicalRecordWithDays to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalRecordWithDays
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalRecordWithDaysCopyWith<MedicalRecordWithDays> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalRecordWithDaysCopyWith<$Res> {
  factory $MedicalRecordWithDaysCopyWith(
    MedicalRecordWithDays value,
    $Res Function(MedicalRecordWithDays) then,
  ) = _$MedicalRecordWithDaysCopyWithImpl<$Res, MedicalRecordWithDays>;
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int rabbitId,
    String symptoms,
    String? diagnosis,
    String? treatment,
    String? medication,
    String? dosage,
    @JsonKey(name: 'started_at') DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(defaultValue: MedicalOutcome.ongoing) MedicalOutcome outcome,
    @DoubleConverter() double? cost,
    String? veterinarian,
    String? notes,
    @JsonKey(name: 'days_ongoing') int daysOngoing,
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
  });

  $RabbitModelCopyWith<$Res>? get rabbit;
}

/// @nodoc
class _$MedicalRecordWithDaysCopyWithImpl<
  $Res,
  $Val extends MedicalRecordWithDays
>
    implements $MedicalRecordWithDaysCopyWith<$Res> {
  _$MedicalRecordWithDaysCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalRecordWithDays
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = null,
    Object? symptoms = null,
    Object? diagnosis = freezed,
    Object? treatment = freezed,
    Object? medication = freezed,
    Object? dosage = freezed,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? outcome = null,
    Object? cost = freezed,
    Object? veterinarian = freezed,
    Object? notes = freezed,
    Object? daysOngoing = null,
    Object? rabbit = freezed,
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
            symptoms: null == symptoms
                ? _value.symptoms
                : symptoms // ignore: cast_nullable_to_non_nullable
                      as String,
            diagnosis: freezed == diagnosis
                ? _value.diagnosis
                : diagnosis // ignore: cast_nullable_to_non_nullable
                      as String?,
            treatment: freezed == treatment
                ? _value.treatment
                : treatment // ignore: cast_nullable_to_non_nullable
                      as String?,
            medication: freezed == medication
                ? _value.medication
                : medication // ignore: cast_nullable_to_non_nullable
                      as String?,
            dosage: freezed == dosage
                ? _value.dosage
                : dosage // ignore: cast_nullable_to_non_nullable
                      as String?,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endedAt: freezed == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            outcome: null == outcome
                ? _value.outcome
                : outcome // ignore: cast_nullable_to_non_nullable
                      as MedicalOutcome,
            cost: freezed == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as double?,
            veterinarian: freezed == veterinarian
                ? _value.veterinarian
                : veterinarian // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            daysOngoing: null == daysOngoing
                ? _value.daysOngoing
                : daysOngoing // ignore: cast_nullable_to_non_nullable
                      as int,
            rabbit: freezed == rabbit
                ? _value.rabbit
                : rabbit // ignore: cast_nullable_to_non_nullable
                      as RabbitModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of MedicalRecordWithDays
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RabbitModelCopyWith<$Res>? get rabbit {
    if (_value.rabbit == null) {
      return null;
    }

    return $RabbitModelCopyWith<$Res>(_value.rabbit!, (value) {
      return _then(_value.copyWith(rabbit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MedicalRecordWithDaysImplCopyWith<$Res>
    implements $MedicalRecordWithDaysCopyWith<$Res> {
  factory _$$MedicalRecordWithDaysImplCopyWith(
    _$MedicalRecordWithDaysImpl value,
    $Res Function(_$MedicalRecordWithDaysImpl) then,
  ) = __$$MedicalRecordWithDaysImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int rabbitId,
    String symptoms,
    String? diagnosis,
    String? treatment,
    String? medication,
    String? dosage,
    @JsonKey(name: 'started_at') DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(defaultValue: MedicalOutcome.ongoing) MedicalOutcome outcome,
    @DoubleConverter() double? cost,
    String? veterinarian,
    String? notes,
    @JsonKey(name: 'days_ongoing') int daysOngoing,
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
  });

  @override
  $RabbitModelCopyWith<$Res>? get rabbit;
}

/// @nodoc
class __$$MedicalRecordWithDaysImplCopyWithImpl<$Res>
    extends
        _$MedicalRecordWithDaysCopyWithImpl<$Res, _$MedicalRecordWithDaysImpl>
    implements _$$MedicalRecordWithDaysImplCopyWith<$Res> {
  __$$MedicalRecordWithDaysImplCopyWithImpl(
    _$MedicalRecordWithDaysImpl _value,
    $Res Function(_$MedicalRecordWithDaysImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MedicalRecordWithDays
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = null,
    Object? symptoms = null,
    Object? diagnosis = freezed,
    Object? treatment = freezed,
    Object? medication = freezed,
    Object? dosage = freezed,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? outcome = null,
    Object? cost = freezed,
    Object? veterinarian = freezed,
    Object? notes = freezed,
    Object? daysOngoing = null,
    Object? rabbit = freezed,
  }) {
    return _then(
      _$MedicalRecordWithDaysImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        rabbitId: null == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int,
        symptoms: null == symptoms
            ? _value.symptoms
            : symptoms // ignore: cast_nullable_to_non_nullable
                  as String,
        diagnosis: freezed == diagnosis
            ? _value.diagnosis
            : diagnosis // ignore: cast_nullable_to_non_nullable
                  as String?,
        treatment: freezed == treatment
            ? _value.treatment
            : treatment // ignore: cast_nullable_to_non_nullable
                  as String?,
        medication: freezed == medication
            ? _value.medication
            : medication // ignore: cast_nullable_to_non_nullable
                  as String?,
        dosage: freezed == dosage
            ? _value.dosage
            : dosage // ignore: cast_nullable_to_non_nullable
                  as String?,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endedAt: freezed == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        outcome: null == outcome
            ? _value.outcome
            : outcome // ignore: cast_nullable_to_non_nullable
                  as MedicalOutcome,
        cost: freezed == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as double?,
        veterinarian: freezed == veterinarian
            ? _value.veterinarian
            : veterinarian // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        daysOngoing: null == daysOngoing
            ? _value.daysOngoing
            : daysOngoing // ignore: cast_nullable_to_non_nullable
                  as int,
        rabbit: freezed == rabbit
            ? _value.rabbit
            : rabbit // ignore: cast_nullable_to_non_nullable
                  as RabbitModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalRecordWithDaysImpl implements _MedicalRecordWithDays {
  const _$MedicalRecordWithDaysImpl({
    @IntConverter() required this.id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required this.rabbitId,
    required this.symptoms,
    this.diagnosis,
    this.treatment,
    this.medication,
    this.dosage,
    @JsonKey(name: 'started_at') required this.startedAt,
    @JsonKey(name: 'ended_at') this.endedAt,
    @JsonKey(defaultValue: MedicalOutcome.ongoing) required this.outcome,
    @DoubleConverter() this.cost,
    this.veterinarian,
    this.notes,
    @JsonKey(name: 'days_ongoing') required this.daysOngoing,
    @JsonKey(includeFromJson: false, includeToJson: false) this.rabbit,
  });

  factory _$MedicalRecordWithDaysImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalRecordWithDaysImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  final int rabbitId;
  @override
  final String symptoms;
  @override
  final String? diagnosis;
  @override
  final String? treatment;
  @override
  final String? medication;
  @override
  final String? dosage;
  @override
  @JsonKey(name: 'started_at')
  final DateTime startedAt;
  @override
  @JsonKey(name: 'ended_at')
  final DateTime? endedAt;
  @override
  @JsonKey(defaultValue: MedicalOutcome.ongoing)
  final MedicalOutcome outcome;
  @override
  @DoubleConverter()
  final double? cost;
  @override
  final String? veterinarian;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'days_ongoing')
  final int daysOngoing;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final RabbitModel? rabbit;

  @override
  String toString() {
    return 'MedicalRecordWithDays(id: $id, rabbitId: $rabbitId, symptoms: $symptoms, diagnosis: $diagnosis, treatment: $treatment, medication: $medication, dosage: $dosage, startedAt: $startedAt, endedAt: $endedAt, outcome: $outcome, cost: $cost, veterinarian: $veterinarian, notes: $notes, daysOngoing: $daysOngoing, rabbit: $rabbit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalRecordWithDaysImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.symptoms, symptoms) ||
                other.symptoms == symptoms) &&
            (identical(other.diagnosis, diagnosis) ||
                other.diagnosis == diagnosis) &&
            (identical(other.treatment, treatment) ||
                other.treatment == treatment) &&
            (identical(other.medication, medication) ||
                other.medication == medication) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.outcome, outcome) || other.outcome == outcome) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.veterinarian, veterinarian) ||
                other.veterinarian == veterinarian) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.daysOngoing, daysOngoing) ||
                other.daysOngoing == daysOngoing) &&
            (identical(other.rabbit, rabbit) || other.rabbit == rabbit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    rabbitId,
    symptoms,
    diagnosis,
    treatment,
    medication,
    dosage,
    startedAt,
    endedAt,
    outcome,
    cost,
    veterinarian,
    notes,
    daysOngoing,
    rabbit,
  );

  /// Create a copy of MedicalRecordWithDays
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalRecordWithDaysImplCopyWith<_$MedicalRecordWithDaysImpl>
  get copyWith =>
      __$$MedicalRecordWithDaysImplCopyWithImpl<_$MedicalRecordWithDaysImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalRecordWithDaysImplToJson(this);
  }
}

abstract class _MedicalRecordWithDays implements MedicalRecordWithDays {
  const factory _MedicalRecordWithDays({
    @IntConverter() required final int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required final int rabbitId,
    required final String symptoms,
    final String? diagnosis,
    final String? treatment,
    final String? medication,
    final String? dosage,
    @JsonKey(name: 'started_at') required final DateTime startedAt,
    @JsonKey(name: 'ended_at') final DateTime? endedAt,
    @JsonKey(defaultValue: MedicalOutcome.ongoing)
    required final MedicalOutcome outcome,
    @DoubleConverter() final double? cost,
    final String? veterinarian,
    final String? notes,
    @JsonKey(name: 'days_ongoing') required final int daysOngoing,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final RabbitModel? rabbit,
  }) = _$MedicalRecordWithDaysImpl;

  factory _MedicalRecordWithDays.fromJson(Map<String, dynamic> json) =
      _$MedicalRecordWithDaysImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int get rabbitId;
  @override
  String get symptoms;
  @override
  String? get diagnosis;
  @override
  String? get treatment;
  @override
  String? get medication;
  @override
  String? get dosage;
  @override
  @JsonKey(name: 'started_at')
  DateTime get startedAt;
  @override
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt;
  @override
  @JsonKey(defaultValue: MedicalOutcome.ongoing)
  MedicalOutcome get outcome;
  @override
  @DoubleConverter()
  double? get cost;
  @override
  String? get veterinarian;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'days_ongoing')
  int get daysOngoing;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  RabbitModel? get rabbit;

  /// Create a copy of MedicalRecordWithDays
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalRecordWithDaysImplCopyWith<_$MedicalRecordWithDaysImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CostReport _$CostReportFromJson(Map<String, dynamic> json) {
  return _CostReport.fromJson(json);
}

/// @nodoc
mixin _$CostReport {
  List<MedicalRecord> get records => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_cost')
  double get totalCost => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this CostReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CostReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CostReportCopyWith<CostReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CostReportCopyWith<$Res> {
  factory $CostReportCopyWith(
    CostReport value,
    $Res Function(CostReport) then,
  ) = _$CostReportCopyWithImpl<$Res, CostReport>;
  @useResult
  $Res call({
    List<MedicalRecord> records,
    @JsonKey(name: 'total_cost') double totalCost,
    int count,
  });
}

/// @nodoc
class _$CostReportCopyWithImpl<$Res, $Val extends CostReport>
    implements $CostReportCopyWith<$Res> {
  _$CostReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CostReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? records = null,
    Object? totalCost = null,
    Object? count = null,
  }) {
    return _then(
      _value.copyWith(
            records: null == records
                ? _value.records
                : records // ignore: cast_nullable_to_non_nullable
                      as List<MedicalRecord>,
            totalCost: null == totalCost
                ? _value.totalCost
                : totalCost // ignore: cast_nullable_to_non_nullable
                      as double,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CostReportImplCopyWith<$Res>
    implements $CostReportCopyWith<$Res> {
  factory _$$CostReportImplCopyWith(
    _$CostReportImpl value,
    $Res Function(_$CostReportImpl) then,
  ) = __$$CostReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<MedicalRecord> records,
    @JsonKey(name: 'total_cost') double totalCost,
    int count,
  });
}

/// @nodoc
class __$$CostReportImplCopyWithImpl<$Res>
    extends _$CostReportCopyWithImpl<$Res, _$CostReportImpl>
    implements _$$CostReportImplCopyWith<$Res> {
  __$$CostReportImplCopyWithImpl(
    _$CostReportImpl _value,
    $Res Function(_$CostReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CostReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? records = null,
    Object? totalCost = null,
    Object? count = null,
  }) {
    return _then(
      _$CostReportImpl(
        records: null == records
            ? _value._records
            : records // ignore: cast_nullable_to_non_nullable
                  as List<MedicalRecord>,
        totalCost: null == totalCost
            ? _value.totalCost
            : totalCost // ignore: cast_nullable_to_non_nullable
                  as double,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CostReportImpl implements _CostReport {
  const _$CostReportImpl({
    required final List<MedicalRecord> records,
    @JsonKey(name: 'total_cost') required this.totalCost,
    required this.count,
  }) : _records = records;

  factory _$CostReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$CostReportImplFromJson(json);

  final List<MedicalRecord> _records;
  @override
  List<MedicalRecord> get records {
    if (_records is EqualUnmodifiableListView) return _records;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_records);
  }

  @override
  @JsonKey(name: 'total_cost')
  final double totalCost;
  @override
  final int count;

  @override
  String toString() {
    return 'CostReport(records: $records, totalCost: $totalCost, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CostReportImpl &&
            const DeepCollectionEquality().equals(other._records, _records) &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_records),
    totalCost,
    count,
  );

  /// Create a copy of CostReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CostReportImplCopyWith<_$CostReportImpl> get copyWith =>
      __$$CostReportImplCopyWithImpl<_$CostReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CostReportImplToJson(this);
  }
}

abstract class _CostReport implements CostReport {
  const factory _CostReport({
    required final List<MedicalRecord> records,
    @JsonKey(name: 'total_cost') required final double totalCost,
    required final int count,
  }) = _$CostReportImpl;

  factory _CostReport.fromJson(Map<String, dynamic> json) =
      _$CostReportImpl.fromJson;

  @override
  List<MedicalRecord> get records;
  @override
  @JsonKey(name: 'total_cost')
  double get totalCost;
  @override
  int get count;

  /// Create a copy of CostReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CostReportImplCopyWith<_$CostReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
