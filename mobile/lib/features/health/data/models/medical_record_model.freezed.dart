// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medical_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicalRecord {

@IntConverter() int get id;@JsonKey(name: 'rabbit_id')@IntConverter() int get rabbitId; String get symptoms; String? get diagnosis; String? get treatment; String? get medication; String? get dosage;@JsonKey(name: 'started_at')@DateOnlyConverter() DateTime get startedAt;@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() DateTime? get endedAt;@JsonKey(defaultValue: MedicalOutcome.ongoing) MedicalOutcome get outcome;@DoubleConverter() double? get cost; String? get veterinarian; String? get notes;@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? get updatedAt;/// Кролик, которого лечили или прививали.
///
/// Сервер шлёт его урезанным — id, кличка, бирка, пол, дата рождения, —
/// и разбор в полную модель упал бы, поэтому связь просто выбрасывали.
/// В списках при этом стояла ветка «показать кличку», которая не
/// выполнялась никогда: данные приходили и не доезжали до экрана.
@JsonKey(name: 'rabbit') RabbitRef? get rabbit;
/// Create a copy of MedicalRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalRecordCopyWith<MedicalRecord> get copyWith => _$MedicalRecordCopyWithImpl<MedicalRecord>(this as MedicalRecord, _$identity);

  /// Serializes this MedicalRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MedicalRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.symptoms, _this.symptoms) || other.symptoms == _this.symptoms)&&(identical(other.diagnosis, _this.diagnosis) || other.diagnosis == _this.diagnosis)&&(identical(other.treatment, _this.treatment) || other.treatment == _this.treatment)&&(identical(other.medication, _this.medication) || other.medication == _this.medication)&&(identical(other.dosage, _this.dosage) || other.dosage == _this.dosage)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.cost, _this.cost) || other.cost == _this.cost)&&(identical(other.veterinarian, _this.veterinarian) || other.veterinarian == _this.veterinarian)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.rabbit, _this.rabbit) || other.rabbit == _this.rabbit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MedicalRecord;
  return Object.hash(runtimeType,_this.id,_this.rabbitId,_this.symptoms,_this.diagnosis,_this.treatment,_this.medication,_this.dosage,_this.startedAt,_this.endedAt,_this.outcome,_this.cost,_this.veterinarian,_this.notes,_this.createdAt,_this.updatedAt,_this.rabbit);
}

@override
String toString() {
  final _this = this as MedicalRecord;
  return 'MedicalRecord(id: ${_this.id}, rabbitId: ${_this.rabbitId}, symptoms: ${_this.symptoms}, diagnosis: ${_this.diagnosis}, treatment: ${_this.treatment}, medication: ${_this.medication}, dosage: ${_this.dosage}, startedAt: ${_this.startedAt}, endedAt: ${_this.endedAt}, outcome: ${_this.outcome}, cost: ${_this.cost}, veterinarian: ${_this.veterinarian}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, rabbit: ${_this.rabbit})';
}


}

/// @nodoc
abstract mixin class $MedicalRecordCopyWith<$Res>  {
  factory $MedicalRecordCopyWith(MedicalRecord value, $Res Function(MedicalRecord) _then) = _$MedicalRecordCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@IntConverter() int rabbitId, String symptoms, String? diagnosis, String? treatment, String? medication, String? dosage,@JsonKey(name: 'started_at')@DateOnlyConverter() DateTime startedAt,@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() DateTime? endedAt,@JsonKey(defaultValue: MedicalOutcome.ongoing) MedicalOutcome outcome,@DoubleConverter() double? cost, String? veterinarian, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt,@JsonKey(name: 'rabbit') RabbitRef? rabbit
});


$RabbitRefCopyWith<$Res>? get rabbit;

}
/// @nodoc
class _$MedicalRecordCopyWithImpl<$Res>
    implements $MedicalRecordCopyWith<$Res> {
  _$MedicalRecordCopyWithImpl(this._self, this._then);

  final MedicalRecord _self;
  final $Res Function(MedicalRecord) _then;

/// Create a copy of MedicalRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rabbitId = null,Object? symptoms = null,Object? diagnosis = freezed,Object? treatment = freezed,Object? medication = freezed,Object? dosage = freezed,Object? startedAt = null,Object? endedAt = freezed,Object? outcome = null,Object? cost = freezed,Object? veterinarian = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rabbit = freezed,}) {
  return _then(MedicalRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,symptoms: null == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as String,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,treatment: freezed == treatment ? _self.treatment : treatment // ignore: cast_nullable_to_non_nullable
as String?,medication: freezed == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as String?,dosage: freezed == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as MedicalOutcome,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,veterinarian: freezed == veterinarian ? _self.veterinarian : veterinarian // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,
  ));
}
/// Create a copy of MedicalRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitRefCopyWith<$Res>? get rabbit {
    if (_self.rabbit == null) {
    return null;
  }

  return $RabbitRefCopyWith<$Res>(_self.rabbit!, (value) {
    return _then(_self.copyWith(rabbit: value));
  });
}
}


/// Adds pattern-matching-related methods to [MedicalRecord].
extension MedicalRecordPatterns on MedicalRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalRecord value)  $default,){
final _that = this;
switch (_that) {
case _MedicalRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId,  String symptoms,  String? diagnosis,  String? treatment,  String? medication,  String? dosage, @JsonKey(name: 'started_at')@DateOnlyConverter()  DateTime startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter()  DateTime? endedAt, @JsonKey(defaultValue: MedicalOutcome.ongoing)  MedicalOutcome outcome, @DoubleConverter()  double? cost,  String? veterinarian,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt, @JsonKey(name: 'rabbit')  RabbitRef? rabbit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalRecord() when $default != null:
return $default(_that.id,_that.rabbitId,_that.symptoms,_that.diagnosis,_that.treatment,_that.medication,_that.dosage,_that.startedAt,_that.endedAt,_that.outcome,_that.cost,_that.veterinarian,_that.notes,_that.createdAt,_that.updatedAt,_that.rabbit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId,  String symptoms,  String? diagnosis,  String? treatment,  String? medication,  String? dosage, @JsonKey(name: 'started_at')@DateOnlyConverter()  DateTime startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter()  DateTime? endedAt, @JsonKey(defaultValue: MedicalOutcome.ongoing)  MedicalOutcome outcome, @DoubleConverter()  double? cost,  String? veterinarian,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt, @JsonKey(name: 'rabbit')  RabbitRef? rabbit)  $default,) {final _that = this;
switch (_that) {
case _MedicalRecord():
return $default(_that.id,_that.rabbitId,_that.symptoms,_that.diagnosis,_that.treatment,_that.medication,_that.dosage,_that.startedAt,_that.endedAt,_that.outcome,_that.cost,_that.veterinarian,_that.notes,_that.createdAt,_that.updatedAt,_that.rabbit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId,  String symptoms,  String? diagnosis,  String? treatment,  String? medication,  String? dosage, @JsonKey(name: 'started_at')@DateOnlyConverter()  DateTime startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter()  DateTime? endedAt, @JsonKey(defaultValue: MedicalOutcome.ongoing)  MedicalOutcome outcome, @DoubleConverter()  double? cost,  String? veterinarian,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt, @JsonKey(name: 'rabbit')  RabbitRef? rabbit)?  $default,) {final _that = this;
switch (_that) {
case _MedicalRecord() when $default != null:
return $default(_that.id,_that.rabbitId,_that.symptoms,_that.diagnosis,_that.treatment,_that.medication,_that.dosage,_that.startedAt,_that.endedAt,_that.outcome,_that.cost,_that.veterinarian,_that.notes,_that.createdAt,_that.updatedAt,_that.rabbit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicalRecord implements MedicalRecord {
  const _MedicalRecord({@IntConverter() required this.id, @JsonKey(name: 'rabbit_id')@IntConverter() required this.rabbitId, required this.symptoms, this.diagnosis, this.treatment, this.medication, this.dosage, @JsonKey(name: 'started_at')@DateOnlyConverter() required this.startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter() this.endedAt, @JsonKey(defaultValue: MedicalOutcome.ongoing) required this.outcome, @DoubleConverter() this.cost, this.veterinarian, this.notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter() this.updatedAt, @JsonKey(name: 'rabbit') this.rabbit});
  factory _MedicalRecord.fromJson(Map<String, dynamic> json) => _$MedicalRecordFromJson(json);

@override@IntConverter() final  int id;
@override@JsonKey(name: 'rabbit_id')@IntConverter() final  int rabbitId;
@override final  String symptoms;
@override final  String? diagnosis;
@override final  String? treatment;
@override final  String? medication;
@override final  String? dosage;
@override@JsonKey(name: 'started_at')@DateOnlyConverter() final  DateTime startedAt;
@override@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() final  DateTime? endedAt;
@override@JsonKey(defaultValue: MedicalOutcome.ongoing) final  MedicalOutcome outcome;
@override@DoubleConverter() final  double? cost;
@override final  String? veterinarian;
@override final  String? notes;
@override@JsonKey(name: 'created_at')@NullableDateTimeConverter() final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at')@NullableDateTimeConverter() final  DateTime? updatedAt;
/// Кролик, которого лечили или прививали.
///
/// Сервер шлёт его урезанным — id, кличка, бирка, пол, дата рождения, —
/// и разбор в полную модель упал бы, поэтому связь просто выбрасывали.
/// В списках при этом стояла ветка «показать кличку», которая не
/// выполнялась никогда: данные приходили и не доезжали до экрана.
@override@JsonKey(name: 'rabbit') final  RabbitRef? rabbit;

/// Create a copy of MedicalRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalRecordCopyWith<_MedicalRecord> get copyWith => __$MedicalRecordCopyWithImpl<_MedicalRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.symptoms, symptoms) || other.symptoms == symptoms)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.treatment, treatment) || other.treatment == treatment)&&(identical(other.medication, medication) || other.medication == medication)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.veterinarian, veterinarian) || other.veterinarian == veterinarian)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rabbit, rabbit) || other.rabbit == rabbit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,rabbitId,symptoms,diagnosis,treatment,medication,dosage,startedAt,endedAt,outcome,cost,veterinarian,notes,createdAt,updatedAt,rabbit);
}

@override
String toString() {
    return 'MedicalRecord(id: $id, rabbitId: $rabbitId, symptoms: $symptoms, diagnosis: $diagnosis, treatment: $treatment, medication: $medication, dosage: $dosage, startedAt: $startedAt, endedAt: $endedAt, outcome: $outcome, cost: $cost, veterinarian: $veterinarian, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, rabbit: $rabbit)';
}


}

/// @nodoc
abstract mixin class _$MedicalRecordCopyWith<$Res> implements $MedicalRecordCopyWith<$Res> {
  factory _$MedicalRecordCopyWith(_MedicalRecord value, $Res Function(_MedicalRecord) _then) = __$MedicalRecordCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@IntConverter() int rabbitId, String symptoms, String? diagnosis, String? treatment, String? medication, String? dosage,@JsonKey(name: 'started_at')@DateOnlyConverter() DateTime startedAt,@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() DateTime? endedAt,@JsonKey(defaultValue: MedicalOutcome.ongoing) MedicalOutcome outcome,@DoubleConverter() double? cost, String? veterinarian, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt,@JsonKey(name: 'rabbit') RabbitRef? rabbit
});


@override $RabbitRefCopyWith<$Res>? get rabbit;

}
/// @nodoc
class __$MedicalRecordCopyWithImpl<$Res>
    implements _$MedicalRecordCopyWith<$Res> {
  __$MedicalRecordCopyWithImpl(this._self, this._then);

  final _MedicalRecord _self;
  final $Res Function(_MedicalRecord) _then;

/// Create a copy of MedicalRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rabbitId = null,Object? symptoms = null,Object? diagnosis = freezed,Object? treatment = freezed,Object? medication = freezed,Object? dosage = freezed,Object? startedAt = null,Object? endedAt = freezed,Object? outcome = null,Object? cost = freezed,Object? veterinarian = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rabbit = freezed,}) {
  return _then(_MedicalRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,symptoms: null == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as String,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,treatment: freezed == treatment ? _self.treatment : treatment // ignore: cast_nullable_to_non_nullable
as String?,medication: freezed == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as String?,dosage: freezed == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as MedicalOutcome,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,veterinarian: freezed == veterinarian ? _self.veterinarian : veterinarian // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,
  ));
}

/// Create a copy of MedicalRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitRefCopyWith<$Res>? get rabbit {
    if (_self.rabbit == null) {
    return null;
  }

  return $RabbitRefCopyWith<$Res>(_self.rabbit!, (value) {
    return _then(_self.copyWith(rabbit: value));
  });
}
}


/// @nodoc
mixin _$MedicalRecordCreate {

@JsonKey(name: 'rabbit_id') int get rabbitId; String get symptoms; String? get diagnosis; String? get treatment; String? get medication; String? get dosage;@JsonKey(name: 'started_at')@DateOnlyConverter() DateTime get startedAt;@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() DateTime? get endedAt;@JsonKey(defaultValue: 'ongoing') String? get outcome; double? get cost; String? get veterinarian; String? get notes;
/// Create a copy of MedicalRecordCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalRecordCreateCopyWith<MedicalRecordCreate> get copyWith => _$MedicalRecordCreateCopyWithImpl<MedicalRecordCreate>(this as MedicalRecordCreate, _$identity);

  /// Serializes this MedicalRecordCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MedicalRecordCreate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalRecordCreate&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.symptoms, _this.symptoms) || other.symptoms == _this.symptoms)&&(identical(other.diagnosis, _this.diagnosis) || other.diagnosis == _this.diagnosis)&&(identical(other.treatment, _this.treatment) || other.treatment == _this.treatment)&&(identical(other.medication, _this.medication) || other.medication == _this.medication)&&(identical(other.dosage, _this.dosage) || other.dosage == _this.dosage)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.cost, _this.cost) || other.cost == _this.cost)&&(identical(other.veterinarian, _this.veterinarian) || other.veterinarian == _this.veterinarian)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MedicalRecordCreate;
  return Object.hash(runtimeType,_this.rabbitId,_this.symptoms,_this.diagnosis,_this.treatment,_this.medication,_this.dosage,_this.startedAt,_this.endedAt,_this.outcome,_this.cost,_this.veterinarian,_this.notes);
}

@override
String toString() {
  final _this = this as MedicalRecordCreate;
  return 'MedicalRecordCreate(rabbitId: ${_this.rabbitId}, symptoms: ${_this.symptoms}, diagnosis: ${_this.diagnosis}, treatment: ${_this.treatment}, medication: ${_this.medication}, dosage: ${_this.dosage}, startedAt: ${_this.startedAt}, endedAt: ${_this.endedAt}, outcome: ${_this.outcome}, cost: ${_this.cost}, veterinarian: ${_this.veterinarian}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $MedicalRecordCreateCopyWith<$Res>  {
  factory $MedicalRecordCreateCopyWith(MedicalRecordCreate value, $Res Function(MedicalRecordCreate) _then) = _$MedicalRecordCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'rabbit_id') int rabbitId, String symptoms, String? diagnosis, String? treatment, String? medication, String? dosage,@JsonKey(name: 'started_at')@DateOnlyConverter() DateTime startedAt,@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() DateTime? endedAt,@JsonKey(defaultValue: 'ongoing') String? outcome, double? cost, String? veterinarian, String? notes
});




}
/// @nodoc
class _$MedicalRecordCreateCopyWithImpl<$Res>
    implements $MedicalRecordCreateCopyWith<$Res> {
  _$MedicalRecordCreateCopyWithImpl(this._self, this._then);

  final MedicalRecordCreate _self;
  final $Res Function(MedicalRecordCreate) _then;

/// Create a copy of MedicalRecordCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rabbitId = null,Object? symptoms = null,Object? diagnosis = freezed,Object? treatment = freezed,Object? medication = freezed,Object? dosage = freezed,Object? startedAt = null,Object? endedAt = freezed,Object? outcome = freezed,Object? cost = freezed,Object? veterinarian = freezed,Object? notes = freezed,}) {
  return _then(MedicalRecordCreate(
rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,symptoms: null == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as String,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,treatment: freezed == treatment ? _self.treatment : treatment // ignore: cast_nullable_to_non_nullable
as String?,medication: freezed == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as String?,dosage: freezed == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,veterinarian: freezed == veterinarian ? _self.veterinarian : veterinarian // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicalRecordCreate].
extension MedicalRecordCreatePatterns on MedicalRecordCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalRecordCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalRecordCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalRecordCreate value)  $default,){
final _that = this;
switch (_that) {
case _MedicalRecordCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalRecordCreate value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalRecordCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'rabbit_id')  int rabbitId,  String symptoms,  String? diagnosis,  String? treatment,  String? medication,  String? dosage, @JsonKey(name: 'started_at')@DateOnlyConverter()  DateTime startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter()  DateTime? endedAt, @JsonKey(defaultValue: 'ongoing')  String? outcome,  double? cost,  String? veterinarian,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalRecordCreate() when $default != null:
return $default(_that.rabbitId,_that.symptoms,_that.diagnosis,_that.treatment,_that.medication,_that.dosage,_that.startedAt,_that.endedAt,_that.outcome,_that.cost,_that.veterinarian,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'rabbit_id')  int rabbitId,  String symptoms,  String? diagnosis,  String? treatment,  String? medication,  String? dosage, @JsonKey(name: 'started_at')@DateOnlyConverter()  DateTime startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter()  DateTime? endedAt, @JsonKey(defaultValue: 'ongoing')  String? outcome,  double? cost,  String? veterinarian,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _MedicalRecordCreate():
return $default(_that.rabbitId,_that.symptoms,_that.diagnosis,_that.treatment,_that.medication,_that.dosage,_that.startedAt,_that.endedAt,_that.outcome,_that.cost,_that.veterinarian,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'rabbit_id')  int rabbitId,  String symptoms,  String? diagnosis,  String? treatment,  String? medication,  String? dosage, @JsonKey(name: 'started_at')@DateOnlyConverter()  DateTime startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter()  DateTime? endedAt, @JsonKey(defaultValue: 'ongoing')  String? outcome,  double? cost,  String? veterinarian,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _MedicalRecordCreate() when $default != null:
return $default(_that.rabbitId,_that.symptoms,_that.diagnosis,_that.treatment,_that.medication,_that.dosage,_that.startedAt,_that.endedAt,_that.outcome,_that.cost,_that.veterinarian,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicalRecordCreate implements MedicalRecordCreate {
  const _MedicalRecordCreate({@JsonKey(name: 'rabbit_id') required this.rabbitId, required this.symptoms, this.diagnosis, this.treatment, this.medication, this.dosage, @JsonKey(name: 'started_at')@DateOnlyConverter() required this.startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter() this.endedAt, @JsonKey(defaultValue: 'ongoing') this.outcome, this.cost, this.veterinarian, this.notes});
  factory _MedicalRecordCreate.fromJson(Map<String, dynamic> json) => _$MedicalRecordCreateFromJson(json);

@override@JsonKey(name: 'rabbit_id') final  int rabbitId;
@override final  String symptoms;
@override final  String? diagnosis;
@override final  String? treatment;
@override final  String? medication;
@override final  String? dosage;
@override@JsonKey(name: 'started_at')@DateOnlyConverter() final  DateTime startedAt;
@override@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() final  DateTime? endedAt;
@override@JsonKey(defaultValue: 'ongoing') final  String? outcome;
@override final  double? cost;
@override final  String? veterinarian;
@override final  String? notes;

/// Create a copy of MedicalRecordCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalRecordCreateCopyWith<_MedicalRecordCreate> get copyWith => __$MedicalRecordCreateCopyWithImpl<_MedicalRecordCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalRecordCreateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalRecordCreate&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.symptoms, symptoms) || other.symptoms == symptoms)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.treatment, treatment) || other.treatment == treatment)&&(identical(other.medication, medication) || other.medication == medication)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.veterinarian, veterinarian) || other.veterinarian == veterinarian)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rabbitId,symptoms,diagnosis,treatment,medication,dosage,startedAt,endedAt,outcome,cost,veterinarian,notes);
}

@override
String toString() {
    return 'MedicalRecordCreate(rabbitId: $rabbitId, symptoms: $symptoms, diagnosis: $diagnosis, treatment: $treatment, medication: $medication, dosage: $dosage, startedAt: $startedAt, endedAt: $endedAt, outcome: $outcome, cost: $cost, veterinarian: $veterinarian, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$MedicalRecordCreateCopyWith<$Res> implements $MedicalRecordCreateCopyWith<$Res> {
  factory _$MedicalRecordCreateCopyWith(_MedicalRecordCreate value, $Res Function(_MedicalRecordCreate) _then) = __$MedicalRecordCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'rabbit_id') int rabbitId, String symptoms, String? diagnosis, String? treatment, String? medication, String? dosage,@JsonKey(name: 'started_at')@DateOnlyConverter() DateTime startedAt,@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() DateTime? endedAt,@JsonKey(defaultValue: 'ongoing') String? outcome, double? cost, String? veterinarian, String? notes
});




}
/// @nodoc
class __$MedicalRecordCreateCopyWithImpl<$Res>
    implements _$MedicalRecordCreateCopyWith<$Res> {
  __$MedicalRecordCreateCopyWithImpl(this._self, this._then);

  final _MedicalRecordCreate _self;
  final $Res Function(_MedicalRecordCreate) _then;

/// Create a copy of MedicalRecordCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rabbitId = null,Object? symptoms = null,Object? diagnosis = freezed,Object? treatment = freezed,Object? medication = freezed,Object? dosage = freezed,Object? startedAt = null,Object? endedAt = freezed,Object? outcome = freezed,Object? cost = freezed,Object? veterinarian = freezed,Object? notes = freezed,}) {
  return _then(_MedicalRecordCreate(
rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,symptoms: null == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as String,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,treatment: freezed == treatment ? _self.treatment : treatment // ignore: cast_nullable_to_non_nullable
as String?,medication: freezed == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as String?,dosage: freezed == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,veterinarian: freezed == veterinarian ? _self.veterinarian : veterinarian // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MedicalRecordUpdate {

@JsonKey(name: 'rabbit_id') int? get rabbitId; String? get symptoms; String? get diagnosis; String? get treatment; String? get medication; String? get dosage;@JsonKey(name: 'started_at')@NullableDateOnlyConverter() DateTime? get startedAt;@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() DateTime? get endedAt; String? get outcome; double? get cost; String? get veterinarian; String? get notes;
/// Create a copy of MedicalRecordUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalRecordUpdateCopyWith<MedicalRecordUpdate> get copyWith => _$MedicalRecordUpdateCopyWithImpl<MedicalRecordUpdate>(this as MedicalRecordUpdate, _$identity);

  /// Serializes this MedicalRecordUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MedicalRecordUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalRecordUpdate&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.symptoms, _this.symptoms) || other.symptoms == _this.symptoms)&&(identical(other.diagnosis, _this.diagnosis) || other.diagnosis == _this.diagnosis)&&(identical(other.treatment, _this.treatment) || other.treatment == _this.treatment)&&(identical(other.medication, _this.medication) || other.medication == _this.medication)&&(identical(other.dosage, _this.dosage) || other.dosage == _this.dosage)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.cost, _this.cost) || other.cost == _this.cost)&&(identical(other.veterinarian, _this.veterinarian) || other.veterinarian == _this.veterinarian)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MedicalRecordUpdate;
  return Object.hash(runtimeType,_this.rabbitId,_this.symptoms,_this.diagnosis,_this.treatment,_this.medication,_this.dosage,_this.startedAt,_this.endedAt,_this.outcome,_this.cost,_this.veterinarian,_this.notes);
}

@override
String toString() {
  final _this = this as MedicalRecordUpdate;
  return 'MedicalRecordUpdate(rabbitId: ${_this.rabbitId}, symptoms: ${_this.symptoms}, diagnosis: ${_this.diagnosis}, treatment: ${_this.treatment}, medication: ${_this.medication}, dosage: ${_this.dosage}, startedAt: ${_this.startedAt}, endedAt: ${_this.endedAt}, outcome: ${_this.outcome}, cost: ${_this.cost}, veterinarian: ${_this.veterinarian}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $MedicalRecordUpdateCopyWith<$Res>  {
  factory $MedicalRecordUpdateCopyWith(MedicalRecordUpdate value, $Res Function(MedicalRecordUpdate) _then) = _$MedicalRecordUpdateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'rabbit_id') int? rabbitId, String? symptoms, String? diagnosis, String? treatment, String? medication, String? dosage,@JsonKey(name: 'started_at')@NullableDateOnlyConverter() DateTime? startedAt,@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() DateTime? endedAt, String? outcome, double? cost, String? veterinarian, String? notes
});




}
/// @nodoc
class _$MedicalRecordUpdateCopyWithImpl<$Res>
    implements $MedicalRecordUpdateCopyWith<$Res> {
  _$MedicalRecordUpdateCopyWithImpl(this._self, this._then);

  final MedicalRecordUpdate _self;
  final $Res Function(MedicalRecordUpdate) _then;

/// Create a copy of MedicalRecordUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rabbitId = freezed,Object? symptoms = freezed,Object? diagnosis = freezed,Object? treatment = freezed,Object? medication = freezed,Object? dosage = freezed,Object? startedAt = freezed,Object? endedAt = freezed,Object? outcome = freezed,Object? cost = freezed,Object? veterinarian = freezed,Object? notes = freezed,}) {
  return _then(MedicalRecordUpdate(
rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,symptoms: freezed == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as String?,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,treatment: freezed == treatment ? _self.treatment : treatment // ignore: cast_nullable_to_non_nullable
as String?,medication: freezed == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as String?,dosage: freezed == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,veterinarian: freezed == veterinarian ? _self.veterinarian : veterinarian // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicalRecordUpdate].
extension MedicalRecordUpdatePatterns on MedicalRecordUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalRecordUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalRecordUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalRecordUpdate value)  $default,){
final _that = this;
switch (_that) {
case _MedicalRecordUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalRecordUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalRecordUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'rabbit_id')  int? rabbitId,  String? symptoms,  String? diagnosis,  String? treatment,  String? medication,  String? dosage, @JsonKey(name: 'started_at')@NullableDateOnlyConverter()  DateTime? startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter()  DateTime? endedAt,  String? outcome,  double? cost,  String? veterinarian,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalRecordUpdate() when $default != null:
return $default(_that.rabbitId,_that.symptoms,_that.diagnosis,_that.treatment,_that.medication,_that.dosage,_that.startedAt,_that.endedAt,_that.outcome,_that.cost,_that.veterinarian,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'rabbit_id')  int? rabbitId,  String? symptoms,  String? diagnosis,  String? treatment,  String? medication,  String? dosage, @JsonKey(name: 'started_at')@NullableDateOnlyConverter()  DateTime? startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter()  DateTime? endedAt,  String? outcome,  double? cost,  String? veterinarian,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _MedicalRecordUpdate():
return $default(_that.rabbitId,_that.symptoms,_that.diagnosis,_that.treatment,_that.medication,_that.dosage,_that.startedAt,_that.endedAt,_that.outcome,_that.cost,_that.veterinarian,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'rabbit_id')  int? rabbitId,  String? symptoms,  String? diagnosis,  String? treatment,  String? medication,  String? dosage, @JsonKey(name: 'started_at')@NullableDateOnlyConverter()  DateTime? startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter()  DateTime? endedAt,  String? outcome,  double? cost,  String? veterinarian,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _MedicalRecordUpdate() when $default != null:
return $default(_that.rabbitId,_that.symptoms,_that.diagnosis,_that.treatment,_that.medication,_that.dosage,_that.startedAt,_that.endedAt,_that.outcome,_that.cost,_that.veterinarian,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicalRecordUpdate implements MedicalRecordUpdate {
  const _MedicalRecordUpdate({@JsonKey(name: 'rabbit_id') this.rabbitId, this.symptoms, this.diagnosis, this.treatment, this.medication, this.dosage, @JsonKey(name: 'started_at')@NullableDateOnlyConverter() this.startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter() this.endedAt, this.outcome, this.cost, this.veterinarian, this.notes});
  factory _MedicalRecordUpdate.fromJson(Map<String, dynamic> json) => _$MedicalRecordUpdateFromJson(json);

@override@JsonKey(name: 'rabbit_id') final  int? rabbitId;
@override final  String? symptoms;
@override final  String? diagnosis;
@override final  String? treatment;
@override final  String? medication;
@override final  String? dosage;
@override@JsonKey(name: 'started_at')@NullableDateOnlyConverter() final  DateTime? startedAt;
@override@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() final  DateTime? endedAt;
@override final  String? outcome;
@override final  double? cost;
@override final  String? veterinarian;
@override final  String? notes;

/// Create a copy of MedicalRecordUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalRecordUpdateCopyWith<_MedicalRecordUpdate> get copyWith => __$MedicalRecordUpdateCopyWithImpl<_MedicalRecordUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalRecordUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalRecordUpdate&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.symptoms, symptoms) || other.symptoms == symptoms)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.treatment, treatment) || other.treatment == treatment)&&(identical(other.medication, medication) || other.medication == medication)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.veterinarian, veterinarian) || other.veterinarian == veterinarian)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rabbitId,symptoms,diagnosis,treatment,medication,dosage,startedAt,endedAt,outcome,cost,veterinarian,notes);
}

@override
String toString() {
    return 'MedicalRecordUpdate(rabbitId: $rabbitId, symptoms: $symptoms, diagnosis: $diagnosis, treatment: $treatment, medication: $medication, dosage: $dosage, startedAt: $startedAt, endedAt: $endedAt, outcome: $outcome, cost: $cost, veterinarian: $veterinarian, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$MedicalRecordUpdateCopyWith<$Res> implements $MedicalRecordUpdateCopyWith<$Res> {
  factory _$MedicalRecordUpdateCopyWith(_MedicalRecordUpdate value, $Res Function(_MedicalRecordUpdate) _then) = __$MedicalRecordUpdateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'rabbit_id') int? rabbitId, String? symptoms, String? diagnosis, String? treatment, String? medication, String? dosage,@JsonKey(name: 'started_at')@NullableDateOnlyConverter() DateTime? startedAt,@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() DateTime? endedAt, String? outcome, double? cost, String? veterinarian, String? notes
});




}
/// @nodoc
class __$MedicalRecordUpdateCopyWithImpl<$Res>
    implements _$MedicalRecordUpdateCopyWith<$Res> {
  __$MedicalRecordUpdateCopyWithImpl(this._self, this._then);

  final _MedicalRecordUpdate _self;
  final $Res Function(_MedicalRecordUpdate) _then;

/// Create a copy of MedicalRecordUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rabbitId = freezed,Object? symptoms = freezed,Object? diagnosis = freezed,Object? treatment = freezed,Object? medication = freezed,Object? dosage = freezed,Object? startedAt = freezed,Object? endedAt = freezed,Object? outcome = freezed,Object? cost = freezed,Object? veterinarian = freezed,Object? notes = freezed,}) {
  return _then(_MedicalRecordUpdate(
rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,symptoms: freezed == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as String?,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,treatment: freezed == treatment ? _self.treatment : treatment // ignore: cast_nullable_to_non_nullable
as String?,medication: freezed == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as String?,dosage: freezed == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,veterinarian: freezed == veterinarian ? _self.veterinarian : veterinarian // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MedicalStatistics {

@JsonKey(name: 'total_records') int get totalRecords;@JsonKey(name: 'by_outcome') MedicalOutcomeStats get byOutcome;@JsonKey(name: 'ongoing_treatments') List<OngoingTreatment> get ongoingTreatments;@JsonKey(name: 'total_cost') double get totalCost;@JsonKey(name: 'this_year') int get thisYear;@JsonKey(name: 'last_month') int get lastMonth;
/// Create a copy of MedicalStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalStatisticsCopyWith<MedicalStatistics> get copyWith => _$MedicalStatisticsCopyWithImpl<MedicalStatistics>(this as MedicalStatistics, _$identity);

  /// Serializes this MedicalStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MedicalStatistics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalStatistics&&(identical(other.totalRecords, _this.totalRecords) || other.totalRecords == _this.totalRecords)&&(identical(other.byOutcome, _this.byOutcome) || other.byOutcome == _this.byOutcome)&&const DeepCollectionEquality().equals(other.ongoingTreatments, _this.ongoingTreatments)&&(identical(other.totalCost, _this.totalCost) || other.totalCost == _this.totalCost)&&(identical(other.thisYear, _this.thisYear) || other.thisYear == _this.thisYear)&&(identical(other.lastMonth, _this.lastMonth) || other.lastMonth == _this.lastMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MedicalStatistics;
  return Object.hash(runtimeType,_this.totalRecords,_this.byOutcome,const DeepCollectionEquality().hash(_this.ongoingTreatments),_this.totalCost,_this.thisYear,_this.lastMonth);
}

@override
String toString() {
  final _this = this as MedicalStatistics;
  return 'MedicalStatistics(totalRecords: ${_this.totalRecords}, byOutcome: ${_this.byOutcome}, ongoingTreatments: ${_this.ongoingTreatments}, totalCost: ${_this.totalCost}, thisYear: ${_this.thisYear}, lastMonth: ${_this.lastMonth})';
}


}

/// @nodoc
abstract mixin class $MedicalStatisticsCopyWith<$Res>  {
  factory $MedicalStatisticsCopyWith(MedicalStatistics value, $Res Function(MedicalStatistics) _then) = _$MedicalStatisticsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_records') int totalRecords,@JsonKey(name: 'by_outcome') MedicalOutcomeStats byOutcome,@JsonKey(name: 'ongoing_treatments') List<OngoingTreatment> ongoingTreatments,@JsonKey(name: 'total_cost') double totalCost,@JsonKey(name: 'this_year') int thisYear,@JsonKey(name: 'last_month') int lastMonth
});


$MedicalOutcomeStatsCopyWith<$Res> get byOutcome;

}
/// @nodoc
class _$MedicalStatisticsCopyWithImpl<$Res>
    implements $MedicalStatisticsCopyWith<$Res> {
  _$MedicalStatisticsCopyWithImpl(this._self, this._then);

  final MedicalStatistics _self;
  final $Res Function(MedicalStatistics) _then;

/// Create a copy of MedicalStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalRecords = null,Object? byOutcome = null,Object? ongoingTreatments = null,Object? totalCost = null,Object? thisYear = null,Object? lastMonth = null,}) {
  return _then(MedicalStatistics(
totalRecords: null == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int,byOutcome: null == byOutcome ? _self.byOutcome : byOutcome // ignore: cast_nullable_to_non_nullable
as MedicalOutcomeStats,ongoingTreatments: null == ongoingTreatments ? _self.ongoingTreatments : ongoingTreatments // ignore: cast_nullable_to_non_nullable
as List<OngoingTreatment>,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,thisYear: null == thisYear ? _self.thisYear : thisYear // ignore: cast_nullable_to_non_nullable
as int,lastMonth: null == lastMonth ? _self.lastMonth : lastMonth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of MedicalStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicalOutcomeStatsCopyWith<$Res> get byOutcome {
  
  return $MedicalOutcomeStatsCopyWith<$Res>(_self.byOutcome, (value) {
    return _then(_self.copyWith(byOutcome: value));
  });
}
}


/// Adds pattern-matching-related methods to [MedicalStatistics].
extension MedicalStatisticsPatterns on MedicalStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalStatistics value)  $default,){
final _that = this;
switch (_that) {
case _MedicalStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_records')  int totalRecords, @JsonKey(name: 'by_outcome')  MedicalOutcomeStats byOutcome, @JsonKey(name: 'ongoing_treatments')  List<OngoingTreatment> ongoingTreatments, @JsonKey(name: 'total_cost')  double totalCost, @JsonKey(name: 'this_year')  int thisYear, @JsonKey(name: 'last_month')  int lastMonth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalStatistics() when $default != null:
return $default(_that.totalRecords,_that.byOutcome,_that.ongoingTreatments,_that.totalCost,_that.thisYear,_that.lastMonth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_records')  int totalRecords, @JsonKey(name: 'by_outcome')  MedicalOutcomeStats byOutcome, @JsonKey(name: 'ongoing_treatments')  List<OngoingTreatment> ongoingTreatments, @JsonKey(name: 'total_cost')  double totalCost, @JsonKey(name: 'this_year')  int thisYear, @JsonKey(name: 'last_month')  int lastMonth)  $default,) {final _that = this;
switch (_that) {
case _MedicalStatistics():
return $default(_that.totalRecords,_that.byOutcome,_that.ongoingTreatments,_that.totalCost,_that.thisYear,_that.lastMonth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_records')  int totalRecords, @JsonKey(name: 'by_outcome')  MedicalOutcomeStats byOutcome, @JsonKey(name: 'ongoing_treatments')  List<OngoingTreatment> ongoingTreatments, @JsonKey(name: 'total_cost')  double totalCost, @JsonKey(name: 'this_year')  int thisYear, @JsonKey(name: 'last_month')  int lastMonth)?  $default,) {final _that = this;
switch (_that) {
case _MedicalStatistics() when $default != null:
return $default(_that.totalRecords,_that.byOutcome,_that.ongoingTreatments,_that.totalCost,_that.thisYear,_that.lastMonth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicalStatistics implements MedicalStatistics {
  const _MedicalStatistics({@JsonKey(name: 'total_records') required this.totalRecords, @JsonKey(name: 'by_outcome') required this.byOutcome, @JsonKey(name: 'ongoing_treatments') required  List<OngoingTreatment> ongoingTreatments, @JsonKey(name: 'total_cost') required this.totalCost, @JsonKey(name: 'this_year') required this.thisYear, @JsonKey(name: 'last_month') required this.lastMonth}): _ongoingTreatments = ongoingTreatments;
  factory _MedicalStatistics.fromJson(Map<String, dynamic> json) => _$MedicalStatisticsFromJson(json);

@override@JsonKey(name: 'total_records') final  int totalRecords;
@override@JsonKey(name: 'by_outcome') final  MedicalOutcomeStats byOutcome;
 final  List<OngoingTreatment> _ongoingTreatments;
@override@JsonKey(name: 'ongoing_treatments') List<OngoingTreatment> get ongoingTreatments {
  if (_ongoingTreatments is EqualUnmodifiableListView) return _ongoingTreatments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ongoingTreatments);
}

@override@JsonKey(name: 'total_cost') final  double totalCost;
@override@JsonKey(name: 'this_year') final  int thisYear;
@override@JsonKey(name: 'last_month') final  int lastMonth;

/// Create a copy of MedicalStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalStatisticsCopyWith<_MedicalStatistics> get copyWith => __$MedicalStatisticsCopyWithImpl<_MedicalStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalStatistics&&(identical(other.totalRecords, totalRecords) || other.totalRecords == totalRecords)&&(identical(other.byOutcome, byOutcome) || other.byOutcome == byOutcome)&&const DeepCollectionEquality().equals(other.ongoingTreatments, _ongoingTreatments)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.thisYear, thisYear) || other.thisYear == thisYear)&&(identical(other.lastMonth, lastMonth) || other.lastMonth == lastMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalRecords,byOutcome,const DeepCollectionEquality().hash(_ongoingTreatments),totalCost,thisYear,lastMonth);
}

@override
String toString() {
    return 'MedicalStatistics(totalRecords: $totalRecords, byOutcome: $byOutcome, ongoingTreatments: $ongoingTreatments, totalCost: $totalCost, thisYear: $thisYear, lastMonth: $lastMonth)';
}


}

/// @nodoc
abstract mixin class _$MedicalStatisticsCopyWith<$Res> implements $MedicalStatisticsCopyWith<$Res> {
  factory _$MedicalStatisticsCopyWith(_MedicalStatistics value, $Res Function(_MedicalStatistics) _then) = __$MedicalStatisticsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_records') int totalRecords,@JsonKey(name: 'by_outcome') MedicalOutcomeStats byOutcome,@JsonKey(name: 'ongoing_treatments') List<OngoingTreatment> ongoingTreatments,@JsonKey(name: 'total_cost') double totalCost,@JsonKey(name: 'this_year') int thisYear,@JsonKey(name: 'last_month') int lastMonth
});


@override $MedicalOutcomeStatsCopyWith<$Res> get byOutcome;

}
/// @nodoc
class __$MedicalStatisticsCopyWithImpl<$Res>
    implements _$MedicalStatisticsCopyWith<$Res> {
  __$MedicalStatisticsCopyWithImpl(this._self, this._then);

  final _MedicalStatistics _self;
  final $Res Function(_MedicalStatistics) _then;

/// Create a copy of MedicalStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalRecords = null,Object? byOutcome = null,Object? ongoingTreatments = null,Object? totalCost = null,Object? thisYear = null,Object? lastMonth = null,}) {
  return _then(_MedicalStatistics(
totalRecords: null == totalRecords ? _self.totalRecords : totalRecords // ignore: cast_nullable_to_non_nullable
as int,byOutcome: null == byOutcome ? _self.byOutcome : byOutcome // ignore: cast_nullable_to_non_nullable
as MedicalOutcomeStats,ongoingTreatments: null == ongoingTreatments ? _self._ongoingTreatments : ongoingTreatments // ignore: cast_nullable_to_non_nullable
as List<OngoingTreatment>,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,thisYear: null == thisYear ? _self.thisYear : thisYear // ignore: cast_nullable_to_non_nullable
as int,lastMonth: null == lastMonth ? _self.lastMonth : lastMonth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of MedicalStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicalOutcomeStatsCopyWith<$Res> get byOutcome {
  
  return $MedicalOutcomeStatsCopyWith<$Res>(_self.byOutcome, (value) {
    return _then(_self.copyWith(byOutcome: value));
  });
}
}


/// @nodoc
mixin _$MedicalOutcomeStats {

@JsonKey(defaultValue: 0) int get recovered;@JsonKey(defaultValue: 0) int get ongoing;@JsonKey(defaultValue: 0) int get died;@JsonKey(defaultValue: 0) int get euthanized;
/// Create a copy of MedicalOutcomeStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalOutcomeStatsCopyWith<MedicalOutcomeStats> get copyWith => _$MedicalOutcomeStatsCopyWithImpl<MedicalOutcomeStats>(this as MedicalOutcomeStats, _$identity);

  /// Serializes this MedicalOutcomeStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MedicalOutcomeStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalOutcomeStats&&(identical(other.recovered, _this.recovered) || other.recovered == _this.recovered)&&(identical(other.ongoing, _this.ongoing) || other.ongoing == _this.ongoing)&&(identical(other.died, _this.died) || other.died == _this.died)&&(identical(other.euthanized, _this.euthanized) || other.euthanized == _this.euthanized));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MedicalOutcomeStats;
  return Object.hash(runtimeType,_this.recovered,_this.ongoing,_this.died,_this.euthanized);
}

@override
String toString() {
  final _this = this as MedicalOutcomeStats;
  return 'MedicalOutcomeStats(recovered: ${_this.recovered}, ongoing: ${_this.ongoing}, died: ${_this.died}, euthanized: ${_this.euthanized})';
}


}

/// @nodoc
abstract mixin class $MedicalOutcomeStatsCopyWith<$Res>  {
  factory $MedicalOutcomeStatsCopyWith(MedicalOutcomeStats value, $Res Function(MedicalOutcomeStats) _then) = _$MedicalOutcomeStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: 0) int recovered,@JsonKey(defaultValue: 0) int ongoing,@JsonKey(defaultValue: 0) int died,@JsonKey(defaultValue: 0) int euthanized
});




}
/// @nodoc
class _$MedicalOutcomeStatsCopyWithImpl<$Res>
    implements $MedicalOutcomeStatsCopyWith<$Res> {
  _$MedicalOutcomeStatsCopyWithImpl(this._self, this._then);

  final MedicalOutcomeStats _self;
  final $Res Function(MedicalOutcomeStats) _then;

/// Create a copy of MedicalOutcomeStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recovered = null,Object? ongoing = null,Object? died = null,Object? euthanized = null,}) {
  return _then(MedicalOutcomeStats(
recovered: null == recovered ? _self.recovered : recovered // ignore: cast_nullable_to_non_nullable
as int,ongoing: null == ongoing ? _self.ongoing : ongoing // ignore: cast_nullable_to_non_nullable
as int,died: null == died ? _self.died : died // ignore: cast_nullable_to_non_nullable
as int,euthanized: null == euthanized ? _self.euthanized : euthanized // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicalOutcomeStats].
extension MedicalOutcomeStatsPatterns on MedicalOutcomeStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalOutcomeStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalOutcomeStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalOutcomeStats value)  $default,){
final _that = this;
switch (_that) {
case _MedicalOutcomeStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalOutcomeStats value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalOutcomeStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: 0)  int recovered, @JsonKey(defaultValue: 0)  int ongoing, @JsonKey(defaultValue: 0)  int died, @JsonKey(defaultValue: 0)  int euthanized)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalOutcomeStats() when $default != null:
return $default(_that.recovered,_that.ongoing,_that.died,_that.euthanized);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: 0)  int recovered, @JsonKey(defaultValue: 0)  int ongoing, @JsonKey(defaultValue: 0)  int died, @JsonKey(defaultValue: 0)  int euthanized)  $default,) {final _that = this;
switch (_that) {
case _MedicalOutcomeStats():
return $default(_that.recovered,_that.ongoing,_that.died,_that.euthanized);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: 0)  int recovered, @JsonKey(defaultValue: 0)  int ongoing, @JsonKey(defaultValue: 0)  int died, @JsonKey(defaultValue: 0)  int euthanized)?  $default,) {final _that = this;
switch (_that) {
case _MedicalOutcomeStats() when $default != null:
return $default(_that.recovered,_that.ongoing,_that.died,_that.euthanized);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicalOutcomeStats implements MedicalOutcomeStats {
  const _MedicalOutcomeStats({@JsonKey(defaultValue: 0) required this.recovered, @JsonKey(defaultValue: 0) required this.ongoing, @JsonKey(defaultValue: 0) required this.died, @JsonKey(defaultValue: 0) required this.euthanized});
  factory _MedicalOutcomeStats.fromJson(Map<String, dynamic> json) => _$MedicalOutcomeStatsFromJson(json);

@override@JsonKey(defaultValue: 0) final  int recovered;
@override@JsonKey(defaultValue: 0) final  int ongoing;
@override@JsonKey(defaultValue: 0) final  int died;
@override@JsonKey(defaultValue: 0) final  int euthanized;

/// Create a copy of MedicalOutcomeStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalOutcomeStatsCopyWith<_MedicalOutcomeStats> get copyWith => __$MedicalOutcomeStatsCopyWithImpl<_MedicalOutcomeStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalOutcomeStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalOutcomeStats&&(identical(other.recovered, recovered) || other.recovered == recovered)&&(identical(other.ongoing, ongoing) || other.ongoing == ongoing)&&(identical(other.died, died) || other.died == died)&&(identical(other.euthanized, euthanized) || other.euthanized == euthanized));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,recovered,ongoing,died,euthanized);
}

@override
String toString() {
    return 'MedicalOutcomeStats(recovered: $recovered, ongoing: $ongoing, died: $died, euthanized: $euthanized)';
}


}

/// @nodoc
abstract mixin class _$MedicalOutcomeStatsCopyWith<$Res> implements $MedicalOutcomeStatsCopyWith<$Res> {
  factory _$MedicalOutcomeStatsCopyWith(_MedicalOutcomeStats value, $Res Function(_MedicalOutcomeStats) _then) = __$MedicalOutcomeStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: 0) int recovered,@JsonKey(defaultValue: 0) int ongoing,@JsonKey(defaultValue: 0) int died,@JsonKey(defaultValue: 0) int euthanized
});




}
/// @nodoc
class __$MedicalOutcomeStatsCopyWithImpl<$Res>
    implements _$MedicalOutcomeStatsCopyWith<$Res> {
  __$MedicalOutcomeStatsCopyWithImpl(this._self, this._then);

  final _MedicalOutcomeStats _self;
  final $Res Function(_MedicalOutcomeStats) _then;

/// Create a copy of MedicalOutcomeStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recovered = null,Object? ongoing = null,Object? died = null,Object? euthanized = null,}) {
  return _then(_MedicalOutcomeStats(
recovered: null == recovered ? _self.recovered : recovered // ignore: cast_nullable_to_non_nullable
as int,ongoing: null == ongoing ? _self.ongoing : ongoing // ignore: cast_nullable_to_non_nullable
as int,died: null == died ? _self.died : died // ignore: cast_nullable_to_non_nullable
as int,euthanized: null == euthanized ? _self.euthanized : euthanized // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OngoingTreatment {

@IntConverter() int get id;@JsonKey(name: 'rabbit_id')@IntConverter() int get rabbitId;@JsonKey(name: 'rabbit_name') String? get rabbitName; String? get diagnosis;@JsonKey(name: 'started_at')@DateOnlyConverter() DateTime get startedAt;@JsonKey(name: 'days_ongoing') int get daysOngoing; String? get symptoms;
/// Create a copy of OngoingTreatment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OngoingTreatmentCopyWith<OngoingTreatment> get copyWith => _$OngoingTreatmentCopyWithImpl<OngoingTreatment>(this as OngoingTreatment, _$identity);

  /// Serializes this OngoingTreatment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OngoingTreatment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OngoingTreatment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.rabbitName, _this.rabbitName) || other.rabbitName == _this.rabbitName)&&(identical(other.diagnosis, _this.diagnosis) || other.diagnosis == _this.diagnosis)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.daysOngoing, _this.daysOngoing) || other.daysOngoing == _this.daysOngoing)&&(identical(other.symptoms, _this.symptoms) || other.symptoms == _this.symptoms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OngoingTreatment;
  return Object.hash(runtimeType,_this.id,_this.rabbitId,_this.rabbitName,_this.diagnosis,_this.startedAt,_this.daysOngoing,_this.symptoms);
}

@override
String toString() {
  final _this = this as OngoingTreatment;
  return 'OngoingTreatment(id: ${_this.id}, rabbitId: ${_this.rabbitId}, rabbitName: ${_this.rabbitName}, diagnosis: ${_this.diagnosis}, startedAt: ${_this.startedAt}, daysOngoing: ${_this.daysOngoing}, symptoms: ${_this.symptoms})';
}


}

/// @nodoc
abstract mixin class $OngoingTreatmentCopyWith<$Res>  {
  factory $OngoingTreatmentCopyWith(OngoingTreatment value, $Res Function(OngoingTreatment) _then) = _$OngoingTreatmentCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@IntConverter() int rabbitId,@JsonKey(name: 'rabbit_name') String? rabbitName, String? diagnosis,@JsonKey(name: 'started_at')@DateOnlyConverter() DateTime startedAt,@JsonKey(name: 'days_ongoing') int daysOngoing, String? symptoms
});




}
/// @nodoc
class _$OngoingTreatmentCopyWithImpl<$Res>
    implements $OngoingTreatmentCopyWith<$Res> {
  _$OngoingTreatmentCopyWithImpl(this._self, this._then);

  final OngoingTreatment _self;
  final $Res Function(OngoingTreatment) _then;

/// Create a copy of OngoingTreatment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rabbitId = null,Object? rabbitName = freezed,Object? diagnosis = freezed,Object? startedAt = null,Object? daysOngoing = null,Object? symptoms = freezed,}) {
  return _then(OngoingTreatment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,rabbitName: freezed == rabbitName ? _self.rabbitName : rabbitName // ignore: cast_nullable_to_non_nullable
as String?,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,daysOngoing: null == daysOngoing ? _self.daysOngoing : daysOngoing // ignore: cast_nullable_to_non_nullable
as int,symptoms: freezed == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OngoingTreatment].
extension OngoingTreatmentPatterns on OngoingTreatment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OngoingTreatment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OngoingTreatment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OngoingTreatment value)  $default,){
final _that = this;
switch (_that) {
case _OngoingTreatment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OngoingTreatment value)?  $default,){
final _that = this;
switch (_that) {
case _OngoingTreatment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId, @JsonKey(name: 'rabbit_name')  String? rabbitName,  String? diagnosis, @JsonKey(name: 'started_at')@DateOnlyConverter()  DateTime startedAt, @JsonKey(name: 'days_ongoing')  int daysOngoing,  String? symptoms)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OngoingTreatment() when $default != null:
return $default(_that.id,_that.rabbitId,_that.rabbitName,_that.diagnosis,_that.startedAt,_that.daysOngoing,_that.symptoms);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId, @JsonKey(name: 'rabbit_name')  String? rabbitName,  String? diagnosis, @JsonKey(name: 'started_at')@DateOnlyConverter()  DateTime startedAt, @JsonKey(name: 'days_ongoing')  int daysOngoing,  String? symptoms)  $default,) {final _that = this;
switch (_that) {
case _OngoingTreatment():
return $default(_that.id,_that.rabbitId,_that.rabbitName,_that.diagnosis,_that.startedAt,_that.daysOngoing,_that.symptoms);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId, @JsonKey(name: 'rabbit_name')  String? rabbitName,  String? diagnosis, @JsonKey(name: 'started_at')@DateOnlyConverter()  DateTime startedAt, @JsonKey(name: 'days_ongoing')  int daysOngoing,  String? symptoms)?  $default,) {final _that = this;
switch (_that) {
case _OngoingTreatment() when $default != null:
return $default(_that.id,_that.rabbitId,_that.rabbitName,_that.diagnosis,_that.startedAt,_that.daysOngoing,_that.symptoms);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OngoingTreatment implements OngoingTreatment {
  const _OngoingTreatment({@IntConverter() required this.id, @JsonKey(name: 'rabbit_id')@IntConverter() required this.rabbitId, @JsonKey(name: 'rabbit_name') this.rabbitName, this.diagnosis, @JsonKey(name: 'started_at')@DateOnlyConverter() required this.startedAt, @JsonKey(name: 'days_ongoing') required this.daysOngoing, this.symptoms});
  factory _OngoingTreatment.fromJson(Map<String, dynamic> json) => _$OngoingTreatmentFromJson(json);

@override@IntConverter() final  int id;
@override@JsonKey(name: 'rabbit_id')@IntConverter() final  int rabbitId;
@override@JsonKey(name: 'rabbit_name') final  String? rabbitName;
@override final  String? diagnosis;
@override@JsonKey(name: 'started_at')@DateOnlyConverter() final  DateTime startedAt;
@override@JsonKey(name: 'days_ongoing') final  int daysOngoing;
@override final  String? symptoms;

/// Create a copy of OngoingTreatment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OngoingTreatmentCopyWith<_OngoingTreatment> get copyWith => __$OngoingTreatmentCopyWithImpl<_OngoingTreatment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OngoingTreatmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OngoingTreatment&&(identical(other.id, id) || other.id == id)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.rabbitName, rabbitName) || other.rabbitName == rabbitName)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.daysOngoing, daysOngoing) || other.daysOngoing == daysOngoing)&&(identical(other.symptoms, symptoms) || other.symptoms == symptoms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,rabbitId,rabbitName,diagnosis,startedAt,daysOngoing,symptoms);
}

@override
String toString() {
    return 'OngoingTreatment(id: $id, rabbitId: $rabbitId, rabbitName: $rabbitName, diagnosis: $diagnosis, startedAt: $startedAt, daysOngoing: $daysOngoing, symptoms: $symptoms)';
}


}

/// @nodoc
abstract mixin class _$OngoingTreatmentCopyWith<$Res> implements $OngoingTreatmentCopyWith<$Res> {
  factory _$OngoingTreatmentCopyWith(_OngoingTreatment value, $Res Function(_OngoingTreatment) _then) = __$OngoingTreatmentCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@IntConverter() int rabbitId,@JsonKey(name: 'rabbit_name') String? rabbitName, String? diagnosis,@JsonKey(name: 'started_at')@DateOnlyConverter() DateTime startedAt,@JsonKey(name: 'days_ongoing') int daysOngoing, String? symptoms
});




}
/// @nodoc
class __$OngoingTreatmentCopyWithImpl<$Res>
    implements _$OngoingTreatmentCopyWith<$Res> {
  __$OngoingTreatmentCopyWithImpl(this._self, this._then);

  final _OngoingTreatment _self;
  final $Res Function(_OngoingTreatment) _then;

/// Create a copy of OngoingTreatment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rabbitId = null,Object? rabbitName = freezed,Object? diagnosis = freezed,Object? startedAt = null,Object? daysOngoing = null,Object? symptoms = freezed,}) {
  return _then(_OngoingTreatment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,rabbitName: freezed == rabbitName ? _self.rabbitName : rabbitName // ignore: cast_nullable_to_non_nullable
as String?,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,daysOngoing: null == daysOngoing ? _self.daysOngoing : daysOngoing // ignore: cast_nullable_to_non_nullable
as int,symptoms: freezed == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MedicalRecordWithDays {

@IntConverter() int get id;@JsonKey(name: 'rabbit_id')@IntConverter() int get rabbitId; String get symptoms; String? get diagnosis; String? get treatment; String? get medication; String? get dosage;@JsonKey(name: 'started_at')@DateOnlyConverter() DateTime get startedAt;@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() DateTime? get endedAt;@JsonKey(defaultValue: MedicalOutcome.ongoing) MedicalOutcome get outcome;@DoubleConverter() double? get cost; String? get veterinarian; String? get notes;@JsonKey(name: 'days_ongoing') int get daysOngoing;/// Кролик, которого лечили или прививали.
///
/// Сервер шлёт его урезанным — id, кличка, бирка, пол, дата рождения, —
/// и разбор в полную модель упал бы, поэтому связь просто выбрасывали.
/// В списках при этом стояла ветка «показать кличку», которая не
/// выполнялась никогда: данные приходили и не доезжали до экрана.
@JsonKey(name: 'rabbit') RabbitRef? get rabbit;
/// Create a copy of MedicalRecordWithDays
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalRecordWithDaysCopyWith<MedicalRecordWithDays> get copyWith => _$MedicalRecordWithDaysCopyWithImpl<MedicalRecordWithDays>(this as MedicalRecordWithDays, _$identity);

  /// Serializes this MedicalRecordWithDays to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MedicalRecordWithDays;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalRecordWithDays&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.symptoms, _this.symptoms) || other.symptoms == _this.symptoms)&&(identical(other.diagnosis, _this.diagnosis) || other.diagnosis == _this.diagnosis)&&(identical(other.treatment, _this.treatment) || other.treatment == _this.treatment)&&(identical(other.medication, _this.medication) || other.medication == _this.medication)&&(identical(other.dosage, _this.dosage) || other.dosage == _this.dosage)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.cost, _this.cost) || other.cost == _this.cost)&&(identical(other.veterinarian, _this.veterinarian) || other.veterinarian == _this.veterinarian)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.daysOngoing, _this.daysOngoing) || other.daysOngoing == _this.daysOngoing)&&(identical(other.rabbit, _this.rabbit) || other.rabbit == _this.rabbit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MedicalRecordWithDays;
  return Object.hash(runtimeType,_this.id,_this.rabbitId,_this.symptoms,_this.diagnosis,_this.treatment,_this.medication,_this.dosage,_this.startedAt,_this.endedAt,_this.outcome,_this.cost,_this.veterinarian,_this.notes,_this.daysOngoing,_this.rabbit);
}

@override
String toString() {
  final _this = this as MedicalRecordWithDays;
  return 'MedicalRecordWithDays(id: ${_this.id}, rabbitId: ${_this.rabbitId}, symptoms: ${_this.symptoms}, diagnosis: ${_this.diagnosis}, treatment: ${_this.treatment}, medication: ${_this.medication}, dosage: ${_this.dosage}, startedAt: ${_this.startedAt}, endedAt: ${_this.endedAt}, outcome: ${_this.outcome}, cost: ${_this.cost}, veterinarian: ${_this.veterinarian}, notes: ${_this.notes}, daysOngoing: ${_this.daysOngoing}, rabbit: ${_this.rabbit})';
}


}

/// @nodoc
abstract mixin class $MedicalRecordWithDaysCopyWith<$Res>  {
  factory $MedicalRecordWithDaysCopyWith(MedicalRecordWithDays value, $Res Function(MedicalRecordWithDays) _then) = _$MedicalRecordWithDaysCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@IntConverter() int rabbitId, String symptoms, String? diagnosis, String? treatment, String? medication, String? dosage,@JsonKey(name: 'started_at')@DateOnlyConverter() DateTime startedAt,@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() DateTime? endedAt,@JsonKey(defaultValue: MedicalOutcome.ongoing) MedicalOutcome outcome,@DoubleConverter() double? cost, String? veterinarian, String? notes,@JsonKey(name: 'days_ongoing') int daysOngoing,@JsonKey(name: 'rabbit') RabbitRef? rabbit
});


$RabbitRefCopyWith<$Res>? get rabbit;

}
/// @nodoc
class _$MedicalRecordWithDaysCopyWithImpl<$Res>
    implements $MedicalRecordWithDaysCopyWith<$Res> {
  _$MedicalRecordWithDaysCopyWithImpl(this._self, this._then);

  final MedicalRecordWithDays _self;
  final $Res Function(MedicalRecordWithDays) _then;

/// Create a copy of MedicalRecordWithDays
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rabbitId = null,Object? symptoms = null,Object? diagnosis = freezed,Object? treatment = freezed,Object? medication = freezed,Object? dosage = freezed,Object? startedAt = null,Object? endedAt = freezed,Object? outcome = null,Object? cost = freezed,Object? veterinarian = freezed,Object? notes = freezed,Object? daysOngoing = null,Object? rabbit = freezed,}) {
  return _then(MedicalRecordWithDays(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,symptoms: null == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as String,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,treatment: freezed == treatment ? _self.treatment : treatment // ignore: cast_nullable_to_non_nullable
as String?,medication: freezed == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as String?,dosage: freezed == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as MedicalOutcome,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,veterinarian: freezed == veterinarian ? _self.veterinarian : veterinarian // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,daysOngoing: null == daysOngoing ? _self.daysOngoing : daysOngoing // ignore: cast_nullable_to_non_nullable
as int,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,
  ));
}
/// Create a copy of MedicalRecordWithDays
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitRefCopyWith<$Res>? get rabbit {
    if (_self.rabbit == null) {
    return null;
  }

  return $RabbitRefCopyWith<$Res>(_self.rabbit!, (value) {
    return _then(_self.copyWith(rabbit: value));
  });
}
}


/// Adds pattern-matching-related methods to [MedicalRecordWithDays].
extension MedicalRecordWithDaysPatterns on MedicalRecordWithDays {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalRecordWithDays value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalRecordWithDays() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalRecordWithDays value)  $default,){
final _that = this;
switch (_that) {
case _MedicalRecordWithDays():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalRecordWithDays value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalRecordWithDays() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId,  String symptoms,  String? diagnosis,  String? treatment,  String? medication,  String? dosage, @JsonKey(name: 'started_at')@DateOnlyConverter()  DateTime startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter()  DateTime? endedAt, @JsonKey(defaultValue: MedicalOutcome.ongoing)  MedicalOutcome outcome, @DoubleConverter()  double? cost,  String? veterinarian,  String? notes, @JsonKey(name: 'days_ongoing')  int daysOngoing, @JsonKey(name: 'rabbit')  RabbitRef? rabbit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalRecordWithDays() when $default != null:
return $default(_that.id,_that.rabbitId,_that.symptoms,_that.diagnosis,_that.treatment,_that.medication,_that.dosage,_that.startedAt,_that.endedAt,_that.outcome,_that.cost,_that.veterinarian,_that.notes,_that.daysOngoing,_that.rabbit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId,  String symptoms,  String? diagnosis,  String? treatment,  String? medication,  String? dosage, @JsonKey(name: 'started_at')@DateOnlyConverter()  DateTime startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter()  DateTime? endedAt, @JsonKey(defaultValue: MedicalOutcome.ongoing)  MedicalOutcome outcome, @DoubleConverter()  double? cost,  String? veterinarian,  String? notes, @JsonKey(name: 'days_ongoing')  int daysOngoing, @JsonKey(name: 'rabbit')  RabbitRef? rabbit)  $default,) {final _that = this;
switch (_that) {
case _MedicalRecordWithDays():
return $default(_that.id,_that.rabbitId,_that.symptoms,_that.diagnosis,_that.treatment,_that.medication,_that.dosage,_that.startedAt,_that.endedAt,_that.outcome,_that.cost,_that.veterinarian,_that.notes,_that.daysOngoing,_that.rabbit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId,  String symptoms,  String? diagnosis,  String? treatment,  String? medication,  String? dosage, @JsonKey(name: 'started_at')@DateOnlyConverter()  DateTime startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter()  DateTime? endedAt, @JsonKey(defaultValue: MedicalOutcome.ongoing)  MedicalOutcome outcome, @DoubleConverter()  double? cost,  String? veterinarian,  String? notes, @JsonKey(name: 'days_ongoing')  int daysOngoing, @JsonKey(name: 'rabbit')  RabbitRef? rabbit)?  $default,) {final _that = this;
switch (_that) {
case _MedicalRecordWithDays() when $default != null:
return $default(_that.id,_that.rabbitId,_that.symptoms,_that.diagnosis,_that.treatment,_that.medication,_that.dosage,_that.startedAt,_that.endedAt,_that.outcome,_that.cost,_that.veterinarian,_that.notes,_that.daysOngoing,_that.rabbit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicalRecordWithDays implements MedicalRecordWithDays {
  const _MedicalRecordWithDays({@IntConverter() required this.id, @JsonKey(name: 'rabbit_id')@IntConverter() required this.rabbitId, required this.symptoms, this.diagnosis, this.treatment, this.medication, this.dosage, @JsonKey(name: 'started_at')@DateOnlyConverter() required this.startedAt, @JsonKey(name: 'ended_at')@NullableDateOnlyConverter() this.endedAt, @JsonKey(defaultValue: MedicalOutcome.ongoing) required this.outcome, @DoubleConverter() this.cost, this.veterinarian, this.notes, @JsonKey(name: 'days_ongoing') required this.daysOngoing, @JsonKey(name: 'rabbit') this.rabbit});
  factory _MedicalRecordWithDays.fromJson(Map<String, dynamic> json) => _$MedicalRecordWithDaysFromJson(json);

@override@IntConverter() final  int id;
@override@JsonKey(name: 'rabbit_id')@IntConverter() final  int rabbitId;
@override final  String symptoms;
@override final  String? diagnosis;
@override final  String? treatment;
@override final  String? medication;
@override final  String? dosage;
@override@JsonKey(name: 'started_at')@DateOnlyConverter() final  DateTime startedAt;
@override@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() final  DateTime? endedAt;
@override@JsonKey(defaultValue: MedicalOutcome.ongoing) final  MedicalOutcome outcome;
@override@DoubleConverter() final  double? cost;
@override final  String? veterinarian;
@override final  String? notes;
@override@JsonKey(name: 'days_ongoing') final  int daysOngoing;
/// Кролик, которого лечили или прививали.
///
/// Сервер шлёт его урезанным — id, кличка, бирка, пол, дата рождения, —
/// и разбор в полную модель упал бы, поэтому связь просто выбрасывали.
/// В списках при этом стояла ветка «показать кличку», которая не
/// выполнялась никогда: данные приходили и не доезжали до экрана.
@override@JsonKey(name: 'rabbit') final  RabbitRef? rabbit;

/// Create a copy of MedicalRecordWithDays
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalRecordWithDaysCopyWith<_MedicalRecordWithDays> get copyWith => __$MedicalRecordWithDaysCopyWithImpl<_MedicalRecordWithDays>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalRecordWithDaysToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalRecordWithDays&&(identical(other.id, id) || other.id == id)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.symptoms, symptoms) || other.symptoms == symptoms)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.treatment, treatment) || other.treatment == treatment)&&(identical(other.medication, medication) || other.medication == medication)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.veterinarian, veterinarian) || other.veterinarian == veterinarian)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.daysOngoing, daysOngoing) || other.daysOngoing == daysOngoing)&&(identical(other.rabbit, rabbit) || other.rabbit == rabbit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,rabbitId,symptoms,diagnosis,treatment,medication,dosage,startedAt,endedAt,outcome,cost,veterinarian,notes,daysOngoing,rabbit);
}

@override
String toString() {
    return 'MedicalRecordWithDays(id: $id, rabbitId: $rabbitId, symptoms: $symptoms, diagnosis: $diagnosis, treatment: $treatment, medication: $medication, dosage: $dosage, startedAt: $startedAt, endedAt: $endedAt, outcome: $outcome, cost: $cost, veterinarian: $veterinarian, notes: $notes, daysOngoing: $daysOngoing, rabbit: $rabbit)';
}


}

/// @nodoc
abstract mixin class _$MedicalRecordWithDaysCopyWith<$Res> implements $MedicalRecordWithDaysCopyWith<$Res> {
  factory _$MedicalRecordWithDaysCopyWith(_MedicalRecordWithDays value, $Res Function(_MedicalRecordWithDays) _then) = __$MedicalRecordWithDaysCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@IntConverter() int rabbitId, String symptoms, String? diagnosis, String? treatment, String? medication, String? dosage,@JsonKey(name: 'started_at')@DateOnlyConverter() DateTime startedAt,@JsonKey(name: 'ended_at')@NullableDateOnlyConverter() DateTime? endedAt,@JsonKey(defaultValue: MedicalOutcome.ongoing) MedicalOutcome outcome,@DoubleConverter() double? cost, String? veterinarian, String? notes,@JsonKey(name: 'days_ongoing') int daysOngoing,@JsonKey(name: 'rabbit') RabbitRef? rabbit
});


@override $RabbitRefCopyWith<$Res>? get rabbit;

}
/// @nodoc
class __$MedicalRecordWithDaysCopyWithImpl<$Res>
    implements _$MedicalRecordWithDaysCopyWith<$Res> {
  __$MedicalRecordWithDaysCopyWithImpl(this._self, this._then);

  final _MedicalRecordWithDays _self;
  final $Res Function(_MedicalRecordWithDays) _then;

/// Create a copy of MedicalRecordWithDays
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rabbitId = null,Object? symptoms = null,Object? diagnosis = freezed,Object? treatment = freezed,Object? medication = freezed,Object? dosage = freezed,Object? startedAt = null,Object? endedAt = freezed,Object? outcome = null,Object? cost = freezed,Object? veterinarian = freezed,Object? notes = freezed,Object? daysOngoing = null,Object? rabbit = freezed,}) {
  return _then(_MedicalRecordWithDays(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,symptoms: null == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as String,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,treatment: freezed == treatment ? _self.treatment : treatment // ignore: cast_nullable_to_non_nullable
as String?,medication: freezed == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as String?,dosage: freezed == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as MedicalOutcome,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,veterinarian: freezed == veterinarian ? _self.veterinarian : veterinarian // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,daysOngoing: null == daysOngoing ? _self.daysOngoing : daysOngoing // ignore: cast_nullable_to_non_nullable
as int,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,
  ));
}

/// Create a copy of MedicalRecordWithDays
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitRefCopyWith<$Res>? get rabbit {
    if (_self.rabbit == null) {
    return null;
  }

  return $RabbitRefCopyWith<$Res>(_self.rabbit!, (value) {
    return _then(_self.copyWith(rabbit: value));
  });
}
}


/// @nodoc
mixin _$CostReport {

 List<MedicalRecord> get records;@JsonKey(name: 'total_cost') double get totalCost; int get count;
/// Create a copy of CostReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CostReportCopyWith<CostReport> get copyWith => _$CostReportCopyWithImpl<CostReport>(this as CostReport, _$identity);

  /// Serializes this CostReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CostReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CostReport&&const DeepCollectionEquality().equals(other.records, _this.records)&&(identical(other.totalCost, _this.totalCost) || other.totalCost == _this.totalCost)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CostReport;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.records),_this.totalCost,_this.count);
}

@override
String toString() {
  final _this = this as CostReport;
  return 'CostReport(records: ${_this.records}, totalCost: ${_this.totalCost}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $CostReportCopyWith<$Res>  {
  factory $CostReportCopyWith(CostReport value, $Res Function(CostReport) _then) = _$CostReportCopyWithImpl;
@useResult
$Res call({
 List<MedicalRecord> records,@JsonKey(name: 'total_cost') double totalCost, int count
});




}
/// @nodoc
class _$CostReportCopyWithImpl<$Res>
    implements $CostReportCopyWith<$Res> {
  _$CostReportCopyWithImpl(this._self, this._then);

  final CostReport _self;
  final $Res Function(CostReport) _then;

/// Create a copy of CostReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? records = null,Object? totalCost = null,Object? count = null,}) {
  return _then(CostReport(
records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<MedicalRecord>,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CostReport].
extension CostReportPatterns on CostReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CostReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CostReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CostReport value)  $default,){
final _that = this;
switch (_that) {
case _CostReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CostReport value)?  $default,){
final _that = this;
switch (_that) {
case _CostReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MedicalRecord> records, @JsonKey(name: 'total_cost')  double totalCost,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CostReport() when $default != null:
return $default(_that.records,_that.totalCost,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MedicalRecord> records, @JsonKey(name: 'total_cost')  double totalCost,  int count)  $default,) {final _that = this;
switch (_that) {
case _CostReport():
return $default(_that.records,_that.totalCost,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MedicalRecord> records, @JsonKey(name: 'total_cost')  double totalCost,  int count)?  $default,) {final _that = this;
switch (_that) {
case _CostReport() when $default != null:
return $default(_that.records,_that.totalCost,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CostReport implements CostReport {
  const _CostReport({required  List<MedicalRecord> records, @JsonKey(name: 'total_cost') required this.totalCost, required this.count}): _records = records;
  factory _CostReport.fromJson(Map<String, dynamic> json) => _$CostReportFromJson(json);

 final  List<MedicalRecord> _records;
@override List<MedicalRecord> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

@override@JsonKey(name: 'total_cost') final  double totalCost;
@override final  int count;

/// Create a copy of CostReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CostReportCopyWith<_CostReport> get copyWith => __$CostReportCopyWithImpl<_CostReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CostReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CostReport&&const DeepCollectionEquality().equals(other.records, _records)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_records),totalCost,count);
}

@override
String toString() {
    return 'CostReport(records: $records, totalCost: $totalCost, count: $count)';
}


}

/// @nodoc
abstract mixin class _$CostReportCopyWith<$Res> implements $CostReportCopyWith<$Res> {
  factory _$CostReportCopyWith(_CostReport value, $Res Function(_CostReport) _then) = __$CostReportCopyWithImpl;
@override @useResult
$Res call({
 List<MedicalRecord> records,@JsonKey(name: 'total_cost') double totalCost, int count
});




}
/// @nodoc
class __$CostReportCopyWithImpl<$Res>
    implements _$CostReportCopyWith<$Res> {
  __$CostReportCopyWithImpl(this._self, this._then);

  final _CostReport _self;
  final $Res Function(_CostReport) _then;

/// Create a copy of CostReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? records = null,Object? totalCost = null,Object? count = null,}) {
  return _then(_CostReport(
records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<MedicalRecord>,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
