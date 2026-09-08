// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vaccination_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Vaccination {

@IntConverter() int get id;@JsonKey(name: 'rabbit_id')@IntConverter() int get rabbitId;@JsonKey(name: 'vaccine_name') String get vaccineName;@JsonKey(name: 'vaccine_type') VaccineType get vaccineType;@JsonKey(name: 'vaccination_date')@DateOnlyConverter() DateTime get vaccinationDate;@JsonKey(name: 'next_vaccination_date')@NullableDateOnlyConverter() DateTime? get nextVaccinationDate;@JsonKey(name: 'batch_number') String? get batchNumber; String? get veterinarian; String? get notes;@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? get updatedAt;/// Кролик, которого лечили или прививали.
///
/// Сервер шлёт его урезанным — id, кличка, бирка, пол, дата рождения, —
/// и разбор в полную модель упал бы, поэтому связь просто выбрасывали.
/// В списках при этом стояла ветка «показать кличку», которая не
/// выполнялась никогда: данные приходили и не доезжали до экрана.
@JsonKey(name: 'rabbit') RabbitRef? get rabbit;@JsonKey(name: 'days_until') int? get daysUntil;@JsonKey(name: 'days_overdue') int? get daysOverdue;@JsonKey(name: 'is_overdue') bool? get isOverdue;
/// Create a copy of Vaccination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccinationCopyWith<Vaccination> get copyWith => _$VaccinationCopyWithImpl<Vaccination>(this as Vaccination, _$identity);

  /// Serializes this Vaccination to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Vaccination;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vaccination&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.vaccineName, _this.vaccineName) || other.vaccineName == _this.vaccineName)&&(identical(other.vaccineType, _this.vaccineType) || other.vaccineType == _this.vaccineType)&&(identical(other.vaccinationDate, _this.vaccinationDate) || other.vaccinationDate == _this.vaccinationDate)&&(identical(other.nextVaccinationDate, _this.nextVaccinationDate) || other.nextVaccinationDate == _this.nextVaccinationDate)&&(identical(other.batchNumber, _this.batchNumber) || other.batchNumber == _this.batchNumber)&&(identical(other.veterinarian, _this.veterinarian) || other.veterinarian == _this.veterinarian)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.rabbit, _this.rabbit) || other.rabbit == _this.rabbit)&&(identical(other.daysUntil, _this.daysUntil) || other.daysUntil == _this.daysUntil)&&(identical(other.daysOverdue, _this.daysOverdue) || other.daysOverdue == _this.daysOverdue)&&(identical(other.isOverdue, _this.isOverdue) || other.isOverdue == _this.isOverdue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Vaccination;
  return Object.hash(runtimeType,_this.id,_this.rabbitId,_this.vaccineName,_this.vaccineType,_this.vaccinationDate,_this.nextVaccinationDate,_this.batchNumber,_this.veterinarian,_this.notes,_this.createdAt,_this.updatedAt,_this.rabbit,_this.daysUntil,_this.daysOverdue,_this.isOverdue);
}

@override
String toString() {
  final _this = this as Vaccination;
  return 'Vaccination(id: ${_this.id}, rabbitId: ${_this.rabbitId}, vaccineName: ${_this.vaccineName}, vaccineType: ${_this.vaccineType}, vaccinationDate: ${_this.vaccinationDate}, nextVaccinationDate: ${_this.nextVaccinationDate}, batchNumber: ${_this.batchNumber}, veterinarian: ${_this.veterinarian}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, rabbit: ${_this.rabbit}, daysUntil: ${_this.daysUntil}, daysOverdue: ${_this.daysOverdue}, isOverdue: ${_this.isOverdue})';
}


}

/// @nodoc
abstract mixin class $VaccinationCopyWith<$Res>  {
  factory $VaccinationCopyWith(Vaccination value, $Res Function(Vaccination) _then) = _$VaccinationCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@IntConverter() int rabbitId,@JsonKey(name: 'vaccine_name') String vaccineName,@JsonKey(name: 'vaccine_type') VaccineType vaccineType,@JsonKey(name: 'vaccination_date')@DateOnlyConverter() DateTime vaccinationDate,@JsonKey(name: 'next_vaccination_date')@NullableDateOnlyConverter() DateTime? nextVaccinationDate,@JsonKey(name: 'batch_number') String? batchNumber, String? veterinarian, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt,@JsonKey(name: 'rabbit') RabbitRef? rabbit,@JsonKey(name: 'days_until') int? daysUntil,@JsonKey(name: 'days_overdue') int? daysOverdue,@JsonKey(name: 'is_overdue') bool? isOverdue
});


$RabbitRefCopyWith<$Res>? get rabbit;

}
/// @nodoc
class _$VaccinationCopyWithImpl<$Res>
    implements $VaccinationCopyWith<$Res> {
  _$VaccinationCopyWithImpl(this._self, this._then);

  final Vaccination _self;
  final $Res Function(Vaccination) _then;

/// Create a copy of Vaccination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rabbitId = null,Object? vaccineName = null,Object? vaccineType = null,Object? vaccinationDate = null,Object? nextVaccinationDate = freezed,Object? batchNumber = freezed,Object? veterinarian = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rabbit = freezed,Object? daysUntil = freezed,Object? daysOverdue = freezed,Object? isOverdue = freezed,}) {
  return _then(Vaccination(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,vaccineName: null == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String,vaccineType: null == vaccineType ? _self.vaccineType : vaccineType // ignore: cast_nullable_to_non_nullable
as VaccineType,vaccinationDate: null == vaccinationDate ? _self.vaccinationDate : vaccinationDate // ignore: cast_nullable_to_non_nullable
as DateTime,nextVaccinationDate: freezed == nextVaccinationDate ? _self.nextVaccinationDate : nextVaccinationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,veterinarian: freezed == veterinarian ? _self.veterinarian : veterinarian // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,daysUntil: freezed == daysUntil ? _self.daysUntil : daysUntil // ignore: cast_nullable_to_non_nullable
as int?,daysOverdue: freezed == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int?,isOverdue: freezed == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of Vaccination
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


/// Adds pattern-matching-related methods to [Vaccination].
extension VaccinationPatterns on Vaccination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vaccination value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vaccination() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vaccination value)  $default,){
final _that = this;
switch (_that) {
case _Vaccination():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vaccination value)?  $default,){
final _that = this;
switch (_that) {
case _Vaccination() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId, @JsonKey(name: 'vaccine_name')  String vaccineName, @JsonKey(name: 'vaccine_type')  VaccineType vaccineType, @JsonKey(name: 'vaccination_date')@DateOnlyConverter()  DateTime vaccinationDate, @JsonKey(name: 'next_vaccination_date')@NullableDateOnlyConverter()  DateTime? nextVaccinationDate, @JsonKey(name: 'batch_number')  String? batchNumber,  String? veterinarian,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt, @JsonKey(name: 'rabbit')  RabbitRef? rabbit, @JsonKey(name: 'days_until')  int? daysUntil, @JsonKey(name: 'days_overdue')  int? daysOverdue, @JsonKey(name: 'is_overdue')  bool? isOverdue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vaccination() when $default != null:
return $default(_that.id,_that.rabbitId,_that.vaccineName,_that.vaccineType,_that.vaccinationDate,_that.nextVaccinationDate,_that.batchNumber,_that.veterinarian,_that.notes,_that.createdAt,_that.updatedAt,_that.rabbit,_that.daysUntil,_that.daysOverdue,_that.isOverdue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId, @JsonKey(name: 'vaccine_name')  String vaccineName, @JsonKey(name: 'vaccine_type')  VaccineType vaccineType, @JsonKey(name: 'vaccination_date')@DateOnlyConverter()  DateTime vaccinationDate, @JsonKey(name: 'next_vaccination_date')@NullableDateOnlyConverter()  DateTime? nextVaccinationDate, @JsonKey(name: 'batch_number')  String? batchNumber,  String? veterinarian,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt, @JsonKey(name: 'rabbit')  RabbitRef? rabbit, @JsonKey(name: 'days_until')  int? daysUntil, @JsonKey(name: 'days_overdue')  int? daysOverdue, @JsonKey(name: 'is_overdue')  bool? isOverdue)  $default,) {final _that = this;
switch (_that) {
case _Vaccination():
return $default(_that.id,_that.rabbitId,_that.vaccineName,_that.vaccineType,_that.vaccinationDate,_that.nextVaccinationDate,_that.batchNumber,_that.veterinarian,_that.notes,_that.createdAt,_that.updatedAt,_that.rabbit,_that.daysUntil,_that.daysOverdue,_that.isOverdue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId, @JsonKey(name: 'vaccine_name')  String vaccineName, @JsonKey(name: 'vaccine_type')  VaccineType vaccineType, @JsonKey(name: 'vaccination_date')@DateOnlyConverter()  DateTime vaccinationDate, @JsonKey(name: 'next_vaccination_date')@NullableDateOnlyConverter()  DateTime? nextVaccinationDate, @JsonKey(name: 'batch_number')  String? batchNumber,  String? veterinarian,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt, @JsonKey(name: 'rabbit')  RabbitRef? rabbit, @JsonKey(name: 'days_until')  int? daysUntil, @JsonKey(name: 'days_overdue')  int? daysOverdue, @JsonKey(name: 'is_overdue')  bool? isOverdue)?  $default,) {final _that = this;
switch (_that) {
case _Vaccination() when $default != null:
return $default(_that.id,_that.rabbitId,_that.vaccineName,_that.vaccineType,_that.vaccinationDate,_that.nextVaccinationDate,_that.batchNumber,_that.veterinarian,_that.notes,_that.createdAt,_that.updatedAt,_that.rabbit,_that.daysUntil,_that.daysOverdue,_that.isOverdue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Vaccination implements Vaccination {
  const _Vaccination({@IntConverter() required this.id, @JsonKey(name: 'rabbit_id')@IntConverter() required this.rabbitId, @JsonKey(name: 'vaccine_name') required this.vaccineName, @JsonKey(name: 'vaccine_type') required this.vaccineType, @JsonKey(name: 'vaccination_date')@DateOnlyConverter() required this.vaccinationDate, @JsonKey(name: 'next_vaccination_date')@NullableDateOnlyConverter() this.nextVaccinationDate, @JsonKey(name: 'batch_number') this.batchNumber, this.veterinarian, this.notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter() this.updatedAt, @JsonKey(name: 'rabbit') this.rabbit, @JsonKey(name: 'days_until') this.daysUntil, @JsonKey(name: 'days_overdue') this.daysOverdue, @JsonKey(name: 'is_overdue') this.isOverdue});
  factory _Vaccination.fromJson(Map<String, dynamic> json) => _$VaccinationFromJson(json);

@override@IntConverter() final  int id;
@override@JsonKey(name: 'rabbit_id')@IntConverter() final  int rabbitId;
@override@JsonKey(name: 'vaccine_name') final  String vaccineName;
@override@JsonKey(name: 'vaccine_type') final  VaccineType vaccineType;
@override@JsonKey(name: 'vaccination_date')@DateOnlyConverter() final  DateTime vaccinationDate;
@override@JsonKey(name: 'next_vaccination_date')@NullableDateOnlyConverter() final  DateTime? nextVaccinationDate;
@override@JsonKey(name: 'batch_number') final  String? batchNumber;
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
@override@JsonKey(name: 'days_until') final  int? daysUntil;
@override@JsonKey(name: 'days_overdue') final  int? daysOverdue;
@override@JsonKey(name: 'is_overdue') final  bool? isOverdue;

/// Create a copy of Vaccination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccinationCopyWith<_Vaccination> get copyWith => __$VaccinationCopyWithImpl<_Vaccination>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccinationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vaccination&&(identical(other.id, id) || other.id == id)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.vaccineType, vaccineType) || other.vaccineType == vaccineType)&&(identical(other.vaccinationDate, vaccinationDate) || other.vaccinationDate == vaccinationDate)&&(identical(other.nextVaccinationDate, nextVaccinationDate) || other.nextVaccinationDate == nextVaccinationDate)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.veterinarian, veterinarian) || other.veterinarian == veterinarian)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rabbit, rabbit) || other.rabbit == rabbit)&&(identical(other.daysUntil, daysUntil) || other.daysUntil == daysUntil)&&(identical(other.daysOverdue, daysOverdue) || other.daysOverdue == daysOverdue)&&(identical(other.isOverdue, isOverdue) || other.isOverdue == isOverdue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,rabbitId,vaccineName,vaccineType,vaccinationDate,nextVaccinationDate,batchNumber,veterinarian,notes,createdAt,updatedAt,rabbit,daysUntil,daysOverdue,isOverdue);
}

@override
String toString() {
    return 'Vaccination(id: $id, rabbitId: $rabbitId, vaccineName: $vaccineName, vaccineType: $vaccineType, vaccinationDate: $vaccinationDate, nextVaccinationDate: $nextVaccinationDate, batchNumber: $batchNumber, veterinarian: $veterinarian, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, rabbit: $rabbit, daysUntil: $daysUntil, daysOverdue: $daysOverdue, isOverdue: $isOverdue)';
}


}

/// @nodoc
abstract mixin class _$VaccinationCopyWith<$Res> implements $VaccinationCopyWith<$Res> {
  factory _$VaccinationCopyWith(_Vaccination value, $Res Function(_Vaccination) _then) = __$VaccinationCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@IntConverter() int rabbitId,@JsonKey(name: 'vaccine_name') String vaccineName,@JsonKey(name: 'vaccine_type') VaccineType vaccineType,@JsonKey(name: 'vaccination_date')@DateOnlyConverter() DateTime vaccinationDate,@JsonKey(name: 'next_vaccination_date')@NullableDateOnlyConverter() DateTime? nextVaccinationDate,@JsonKey(name: 'batch_number') String? batchNumber, String? veterinarian, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt,@JsonKey(name: 'rabbit') RabbitRef? rabbit,@JsonKey(name: 'days_until') int? daysUntil,@JsonKey(name: 'days_overdue') int? daysOverdue,@JsonKey(name: 'is_overdue') bool? isOverdue
});


@override $RabbitRefCopyWith<$Res>? get rabbit;

}
/// @nodoc
class __$VaccinationCopyWithImpl<$Res>
    implements _$VaccinationCopyWith<$Res> {
  __$VaccinationCopyWithImpl(this._self, this._then);

  final _Vaccination _self;
  final $Res Function(_Vaccination) _then;

/// Create a copy of Vaccination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rabbitId = null,Object? vaccineName = null,Object? vaccineType = null,Object? vaccinationDate = null,Object? nextVaccinationDate = freezed,Object? batchNumber = freezed,Object? veterinarian = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rabbit = freezed,Object? daysUntil = freezed,Object? daysOverdue = freezed,Object? isOverdue = freezed,}) {
  return _then(_Vaccination(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,vaccineName: null == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String,vaccineType: null == vaccineType ? _self.vaccineType : vaccineType // ignore: cast_nullable_to_non_nullable
as VaccineType,vaccinationDate: null == vaccinationDate ? _self.vaccinationDate : vaccinationDate // ignore: cast_nullable_to_non_nullable
as DateTime,nextVaccinationDate: freezed == nextVaccinationDate ? _self.nextVaccinationDate : nextVaccinationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,veterinarian: freezed == veterinarian ? _self.veterinarian : veterinarian // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,daysUntil: freezed == daysUntil ? _self.daysUntil : daysUntil // ignore: cast_nullable_to_non_nullable
as int?,daysOverdue: freezed == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int?,isOverdue: freezed == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of Vaccination
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
mixin _$VaccinationStatistics {

@JsonKey(name: 'total_vaccinations') int get totalVaccinations;@JsonKey(name: 'by_vaccine_type') Map<String, int> get byVaccineType; VaccinationUpcoming get upcoming;@JsonKey(name: 'this_year') int get thisYear;@JsonKey(name: 'last_30_days') int get last30Days;
/// Create a copy of VaccinationStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccinationStatisticsCopyWith<VaccinationStatistics> get copyWith => _$VaccinationStatisticsCopyWithImpl<VaccinationStatistics>(this as VaccinationStatistics, _$identity);

  /// Serializes this VaccinationStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VaccinationStatistics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaccinationStatistics&&(identical(other.totalVaccinations, _this.totalVaccinations) || other.totalVaccinations == _this.totalVaccinations)&&const DeepCollectionEquality().equals(other.byVaccineType, _this.byVaccineType)&&(identical(other.upcoming, _this.upcoming) || other.upcoming == _this.upcoming)&&(identical(other.thisYear, _this.thisYear) || other.thisYear == _this.thisYear)&&(identical(other.last30Days, _this.last30Days) || other.last30Days == _this.last30Days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VaccinationStatistics;
  return Object.hash(runtimeType,_this.totalVaccinations,const DeepCollectionEquality().hash(_this.byVaccineType),_this.upcoming,_this.thisYear,_this.last30Days);
}

@override
String toString() {
  final _this = this as VaccinationStatistics;
  return 'VaccinationStatistics(totalVaccinations: ${_this.totalVaccinations}, byVaccineType: ${_this.byVaccineType}, upcoming: ${_this.upcoming}, thisYear: ${_this.thisYear}, last30Days: ${_this.last30Days})';
}


}

/// @nodoc
abstract mixin class $VaccinationStatisticsCopyWith<$Res>  {
  factory $VaccinationStatisticsCopyWith(VaccinationStatistics value, $Res Function(VaccinationStatistics) _then) = _$VaccinationStatisticsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_vaccinations') int totalVaccinations,@JsonKey(name: 'by_vaccine_type') Map<String, int> byVaccineType, VaccinationUpcoming upcoming,@JsonKey(name: 'this_year') int thisYear,@JsonKey(name: 'last_30_days') int last30Days
});


$VaccinationUpcomingCopyWith<$Res> get upcoming;

}
/// @nodoc
class _$VaccinationStatisticsCopyWithImpl<$Res>
    implements $VaccinationStatisticsCopyWith<$Res> {
  _$VaccinationStatisticsCopyWithImpl(this._self, this._then);

  final VaccinationStatistics _self;
  final $Res Function(VaccinationStatistics) _then;

/// Create a copy of VaccinationStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalVaccinations = null,Object? byVaccineType = null,Object? upcoming = null,Object? thisYear = null,Object? last30Days = null,}) {
  return _then(VaccinationStatistics(
totalVaccinations: null == totalVaccinations ? _self.totalVaccinations : totalVaccinations // ignore: cast_nullable_to_non_nullable
as int,byVaccineType: null == byVaccineType ? _self.byVaccineType : byVaccineType // ignore: cast_nullable_to_non_nullable
as Map<String, int>,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as VaccinationUpcoming,thisYear: null == thisYear ? _self.thisYear : thisYear // ignore: cast_nullable_to_non_nullable
as int,last30Days: null == last30Days ? _self.last30Days : last30Days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of VaccinationStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaccinationUpcomingCopyWith<$Res> get upcoming {
  
  return $VaccinationUpcomingCopyWith<$Res>(_self.upcoming, (value) {
    return _then(_self.copyWith(upcoming: value));
  });
}
}


/// Adds pattern-matching-related methods to [VaccinationStatistics].
extension VaccinationStatisticsPatterns on VaccinationStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaccinationStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaccinationStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaccinationStatistics value)  $default,){
final _that = this;
switch (_that) {
case _VaccinationStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaccinationStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _VaccinationStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_vaccinations')  int totalVaccinations, @JsonKey(name: 'by_vaccine_type')  Map<String, int> byVaccineType,  VaccinationUpcoming upcoming, @JsonKey(name: 'this_year')  int thisYear, @JsonKey(name: 'last_30_days')  int last30Days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaccinationStatistics() when $default != null:
return $default(_that.totalVaccinations,_that.byVaccineType,_that.upcoming,_that.thisYear,_that.last30Days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_vaccinations')  int totalVaccinations, @JsonKey(name: 'by_vaccine_type')  Map<String, int> byVaccineType,  VaccinationUpcoming upcoming, @JsonKey(name: 'this_year')  int thisYear, @JsonKey(name: 'last_30_days')  int last30Days)  $default,) {final _that = this;
switch (_that) {
case _VaccinationStatistics():
return $default(_that.totalVaccinations,_that.byVaccineType,_that.upcoming,_that.thisYear,_that.last30Days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_vaccinations')  int totalVaccinations, @JsonKey(name: 'by_vaccine_type')  Map<String, int> byVaccineType,  VaccinationUpcoming upcoming, @JsonKey(name: 'this_year')  int thisYear, @JsonKey(name: 'last_30_days')  int last30Days)?  $default,) {final _that = this;
switch (_that) {
case _VaccinationStatistics() when $default != null:
return $default(_that.totalVaccinations,_that.byVaccineType,_that.upcoming,_that.thisYear,_that.last30Days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaccinationStatistics implements VaccinationStatistics {
  const _VaccinationStatistics({@JsonKey(name: 'total_vaccinations') required this.totalVaccinations, @JsonKey(name: 'by_vaccine_type') required  Map<String, int> byVaccineType, required this.upcoming, @JsonKey(name: 'this_year') required this.thisYear, @JsonKey(name: 'last_30_days') required this.last30Days}): _byVaccineType = byVaccineType;
  factory _VaccinationStatistics.fromJson(Map<String, dynamic> json) => _$VaccinationStatisticsFromJson(json);

@override@JsonKey(name: 'total_vaccinations') final  int totalVaccinations;
 final  Map<String, int> _byVaccineType;
@override@JsonKey(name: 'by_vaccine_type') Map<String, int> get byVaccineType {
  if (_byVaccineType is EqualUnmodifiableMapView) return _byVaccineType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byVaccineType);
}

@override final  VaccinationUpcoming upcoming;
@override@JsonKey(name: 'this_year') final  int thisYear;
@override@JsonKey(name: 'last_30_days') final  int last30Days;

/// Create a copy of VaccinationStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccinationStatisticsCopyWith<_VaccinationStatistics> get copyWith => __$VaccinationStatisticsCopyWithImpl<_VaccinationStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccinationStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaccinationStatistics&&(identical(other.totalVaccinations, totalVaccinations) || other.totalVaccinations == totalVaccinations)&&const DeepCollectionEquality().equals(other.byVaccineType, _byVaccineType)&&(identical(other.upcoming, upcoming) || other.upcoming == upcoming)&&(identical(other.thisYear, thisYear) || other.thisYear == thisYear)&&(identical(other.last30Days, last30Days) || other.last30Days == last30Days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalVaccinations,const DeepCollectionEquality().hash(_byVaccineType),upcoming,thisYear,last30Days);
}

@override
String toString() {
    return 'VaccinationStatistics(totalVaccinations: $totalVaccinations, byVaccineType: $byVaccineType, upcoming: $upcoming, thisYear: $thisYear, last30Days: $last30Days)';
}


}

/// @nodoc
abstract mixin class _$VaccinationStatisticsCopyWith<$Res> implements $VaccinationStatisticsCopyWith<$Res> {
  factory _$VaccinationStatisticsCopyWith(_VaccinationStatistics value, $Res Function(_VaccinationStatistics) _then) = __$VaccinationStatisticsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_vaccinations') int totalVaccinations,@JsonKey(name: 'by_vaccine_type') Map<String, int> byVaccineType, VaccinationUpcoming upcoming,@JsonKey(name: 'this_year') int thisYear,@JsonKey(name: 'last_30_days') int last30Days
});


@override $VaccinationUpcomingCopyWith<$Res> get upcoming;

}
/// @nodoc
class __$VaccinationStatisticsCopyWithImpl<$Res>
    implements _$VaccinationStatisticsCopyWith<$Res> {
  __$VaccinationStatisticsCopyWithImpl(this._self, this._then);

  final _VaccinationStatistics _self;
  final $Res Function(_VaccinationStatistics) _then;

/// Create a copy of VaccinationStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalVaccinations = null,Object? byVaccineType = null,Object? upcoming = null,Object? thisYear = null,Object? last30Days = null,}) {
  return _then(_VaccinationStatistics(
totalVaccinations: null == totalVaccinations ? _self.totalVaccinations : totalVaccinations // ignore: cast_nullable_to_non_nullable
as int,byVaccineType: null == byVaccineType ? _self._byVaccineType : byVaccineType // ignore: cast_nullable_to_non_nullable
as Map<String, int>,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as VaccinationUpcoming,thisYear: null == thisYear ? _self.thisYear : thisYear // ignore: cast_nullable_to_non_nullable
as int,last30Days: null == last30Days ? _self.last30Days : last30Days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of VaccinationStatistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaccinationUpcomingCopyWith<$Res> get upcoming {
  
  return $VaccinationUpcomingCopyWith<$Res>(_self.upcoming, (value) {
    return _then(_self.copyWith(upcoming: value));
  });
}
}


/// @nodoc
mixin _$VaccinationUpcoming {

 int get total;@JsonKey(name: 'next_30_days') int get next30Days; int get overdue; List<UpcomingVaccinationItem> get list;
/// Create a copy of VaccinationUpcoming
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccinationUpcomingCopyWith<VaccinationUpcoming> get copyWith => _$VaccinationUpcomingCopyWithImpl<VaccinationUpcoming>(this as VaccinationUpcoming, _$identity);

  /// Serializes this VaccinationUpcoming to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VaccinationUpcoming;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaccinationUpcoming&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.next30Days, _this.next30Days) || other.next30Days == _this.next30Days)&&(identical(other.overdue, _this.overdue) || other.overdue == _this.overdue)&&const DeepCollectionEquality().equals(other.list, _this.list));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VaccinationUpcoming;
  return Object.hash(runtimeType,_this.total,_this.next30Days,_this.overdue,const DeepCollectionEquality().hash(_this.list));
}

@override
String toString() {
  final _this = this as VaccinationUpcoming;
  return 'VaccinationUpcoming(total: ${_this.total}, next30Days: ${_this.next30Days}, overdue: ${_this.overdue}, list: ${_this.list})';
}


}

/// @nodoc
abstract mixin class $VaccinationUpcomingCopyWith<$Res>  {
  factory $VaccinationUpcomingCopyWith(VaccinationUpcoming value, $Res Function(VaccinationUpcoming) _then) = _$VaccinationUpcomingCopyWithImpl;
@useResult
$Res call({
 int total,@JsonKey(name: 'next_30_days') int next30Days, int overdue, List<UpcomingVaccinationItem> list
});




}
/// @nodoc
class _$VaccinationUpcomingCopyWithImpl<$Res>
    implements $VaccinationUpcomingCopyWith<$Res> {
  _$VaccinationUpcomingCopyWithImpl(this._self, this._then);

  final VaccinationUpcoming _self;
  final $Res Function(VaccinationUpcoming) _then;

/// Create a copy of VaccinationUpcoming
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? next30Days = null,Object? overdue = null,Object? list = null,}) {
  return _then(VaccinationUpcoming(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,next30Days: null == next30Days ? _self.next30Days : next30Days // ignore: cast_nullable_to_non_nullable
as int,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<UpcomingVaccinationItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [VaccinationUpcoming].
extension VaccinationUpcomingPatterns on VaccinationUpcoming {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaccinationUpcoming value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaccinationUpcoming() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaccinationUpcoming value)  $default,){
final _that = this;
switch (_that) {
case _VaccinationUpcoming():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaccinationUpcoming value)?  $default,){
final _that = this;
switch (_that) {
case _VaccinationUpcoming() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total, @JsonKey(name: 'next_30_days')  int next30Days,  int overdue,  List<UpcomingVaccinationItem> list)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaccinationUpcoming() when $default != null:
return $default(_that.total,_that.next30Days,_that.overdue,_that.list);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total, @JsonKey(name: 'next_30_days')  int next30Days,  int overdue,  List<UpcomingVaccinationItem> list)  $default,) {final _that = this;
switch (_that) {
case _VaccinationUpcoming():
return $default(_that.total,_that.next30Days,_that.overdue,_that.list);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total, @JsonKey(name: 'next_30_days')  int next30Days,  int overdue,  List<UpcomingVaccinationItem> list)?  $default,) {final _that = this;
switch (_that) {
case _VaccinationUpcoming() when $default != null:
return $default(_that.total,_that.next30Days,_that.overdue,_that.list);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaccinationUpcoming implements VaccinationUpcoming {
  const _VaccinationUpcoming({required this.total, @JsonKey(name: 'next_30_days') required this.next30Days, required this.overdue, required  List<UpcomingVaccinationItem> list}): _list = list;
  factory _VaccinationUpcoming.fromJson(Map<String, dynamic> json) => _$VaccinationUpcomingFromJson(json);

@override final  int total;
@override@JsonKey(name: 'next_30_days') final  int next30Days;
@override final  int overdue;
 final  List<UpcomingVaccinationItem> _list;
@override List<UpcomingVaccinationItem> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}


/// Create a copy of VaccinationUpcoming
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccinationUpcomingCopyWith<_VaccinationUpcoming> get copyWith => __$VaccinationUpcomingCopyWithImpl<_VaccinationUpcoming>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccinationUpcomingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaccinationUpcoming&&(identical(other.total, total) || other.total == total)&&(identical(other.next30Days, next30Days) || other.next30Days == next30Days)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&const DeepCollectionEquality().equals(other.list, _list));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,next30Days,overdue,const DeepCollectionEquality().hash(_list));
}

@override
String toString() {
    return 'VaccinationUpcoming(total: $total, next30Days: $next30Days, overdue: $overdue, list: $list)';
}


}

/// @nodoc
abstract mixin class _$VaccinationUpcomingCopyWith<$Res> implements $VaccinationUpcomingCopyWith<$Res> {
  factory _$VaccinationUpcomingCopyWith(_VaccinationUpcoming value, $Res Function(_VaccinationUpcoming) _then) = __$VaccinationUpcomingCopyWithImpl;
@override @useResult
$Res call({
 int total,@JsonKey(name: 'next_30_days') int next30Days, int overdue, List<UpcomingVaccinationItem> list
});




}
/// @nodoc
class __$VaccinationUpcomingCopyWithImpl<$Res>
    implements _$VaccinationUpcomingCopyWith<$Res> {
  __$VaccinationUpcomingCopyWithImpl(this._self, this._then);

  final _VaccinationUpcoming _self;
  final $Res Function(_VaccinationUpcoming) _then;

/// Create a copy of VaccinationUpcoming
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? next30Days = null,Object? overdue = null,Object? list = null,}) {
  return _then(_VaccinationUpcoming(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,next30Days: null == next30Days ? _self.next30Days : next30Days // ignore: cast_nullable_to_non_nullable
as int,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<UpcomingVaccinationItem>,
  ));
}


}


/// @nodoc
mixin _$UpcomingVaccinationItem {

@IntConverter() int get id;@JsonKey(name: 'rabbit_id')@IntConverter() int get rabbitId;@JsonKey(name: 'rabbit_name') String? get rabbitName;@JsonKey(name: 'vaccine_name') String get vaccineName;@JsonKey(name: 'vaccine_type') VaccineType get vaccineType;@JsonKey(name: 'next_vaccination_date')@DateOnlyConverter() DateTime get nextVaccinationDate;@JsonKey(name: 'days_until') int get daysUntil;@JsonKey(name: 'is_overdue') bool? get isOverdue;
/// Create a copy of UpcomingVaccinationItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpcomingVaccinationItemCopyWith<UpcomingVaccinationItem> get copyWith => _$UpcomingVaccinationItemCopyWithImpl<UpcomingVaccinationItem>(this as UpcomingVaccinationItem, _$identity);

  /// Serializes this UpcomingVaccinationItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpcomingVaccinationItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingVaccinationItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.rabbitName, _this.rabbitName) || other.rabbitName == _this.rabbitName)&&(identical(other.vaccineName, _this.vaccineName) || other.vaccineName == _this.vaccineName)&&(identical(other.vaccineType, _this.vaccineType) || other.vaccineType == _this.vaccineType)&&(identical(other.nextVaccinationDate, _this.nextVaccinationDate) || other.nextVaccinationDate == _this.nextVaccinationDate)&&(identical(other.daysUntil, _this.daysUntil) || other.daysUntil == _this.daysUntil)&&(identical(other.isOverdue, _this.isOverdue) || other.isOverdue == _this.isOverdue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpcomingVaccinationItem;
  return Object.hash(runtimeType,_this.id,_this.rabbitId,_this.rabbitName,_this.vaccineName,_this.vaccineType,_this.nextVaccinationDate,_this.daysUntil,_this.isOverdue);
}

@override
String toString() {
  final _this = this as UpcomingVaccinationItem;
  return 'UpcomingVaccinationItem(id: ${_this.id}, rabbitId: ${_this.rabbitId}, rabbitName: ${_this.rabbitName}, vaccineName: ${_this.vaccineName}, vaccineType: ${_this.vaccineType}, nextVaccinationDate: ${_this.nextVaccinationDate}, daysUntil: ${_this.daysUntil}, isOverdue: ${_this.isOverdue})';
}


}

/// @nodoc
abstract mixin class $UpcomingVaccinationItemCopyWith<$Res>  {
  factory $UpcomingVaccinationItemCopyWith(UpcomingVaccinationItem value, $Res Function(UpcomingVaccinationItem) _then) = _$UpcomingVaccinationItemCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@IntConverter() int rabbitId,@JsonKey(name: 'rabbit_name') String? rabbitName,@JsonKey(name: 'vaccine_name') String vaccineName,@JsonKey(name: 'vaccine_type') VaccineType vaccineType,@JsonKey(name: 'next_vaccination_date')@DateOnlyConverter() DateTime nextVaccinationDate,@JsonKey(name: 'days_until') int daysUntil,@JsonKey(name: 'is_overdue') bool? isOverdue
});




}
/// @nodoc
class _$UpcomingVaccinationItemCopyWithImpl<$Res>
    implements $UpcomingVaccinationItemCopyWith<$Res> {
  _$UpcomingVaccinationItemCopyWithImpl(this._self, this._then);

  final UpcomingVaccinationItem _self;
  final $Res Function(UpcomingVaccinationItem) _then;

/// Create a copy of UpcomingVaccinationItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rabbitId = null,Object? rabbitName = freezed,Object? vaccineName = null,Object? vaccineType = null,Object? nextVaccinationDate = null,Object? daysUntil = null,Object? isOverdue = freezed,}) {
  return _then(UpcomingVaccinationItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,rabbitName: freezed == rabbitName ? _self.rabbitName : rabbitName // ignore: cast_nullable_to_non_nullable
as String?,vaccineName: null == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String,vaccineType: null == vaccineType ? _self.vaccineType : vaccineType // ignore: cast_nullable_to_non_nullable
as VaccineType,nextVaccinationDate: null == nextVaccinationDate ? _self.nextVaccinationDate : nextVaccinationDate // ignore: cast_nullable_to_non_nullable
as DateTime,daysUntil: null == daysUntil ? _self.daysUntil : daysUntil // ignore: cast_nullable_to_non_nullable
as int,isOverdue: freezed == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpcomingVaccinationItem].
extension UpcomingVaccinationItemPatterns on UpcomingVaccinationItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpcomingVaccinationItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpcomingVaccinationItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpcomingVaccinationItem value)  $default,){
final _that = this;
switch (_that) {
case _UpcomingVaccinationItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpcomingVaccinationItem value)?  $default,){
final _that = this;
switch (_that) {
case _UpcomingVaccinationItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId, @JsonKey(name: 'rabbit_name')  String? rabbitName, @JsonKey(name: 'vaccine_name')  String vaccineName, @JsonKey(name: 'vaccine_type')  VaccineType vaccineType, @JsonKey(name: 'next_vaccination_date')@DateOnlyConverter()  DateTime nextVaccinationDate, @JsonKey(name: 'days_until')  int daysUntil, @JsonKey(name: 'is_overdue')  bool? isOverdue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpcomingVaccinationItem() when $default != null:
return $default(_that.id,_that.rabbitId,_that.rabbitName,_that.vaccineName,_that.vaccineType,_that.nextVaccinationDate,_that.daysUntil,_that.isOverdue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId, @JsonKey(name: 'rabbit_name')  String? rabbitName, @JsonKey(name: 'vaccine_name')  String vaccineName, @JsonKey(name: 'vaccine_type')  VaccineType vaccineType, @JsonKey(name: 'next_vaccination_date')@DateOnlyConverter()  DateTime nextVaccinationDate, @JsonKey(name: 'days_until')  int daysUntil, @JsonKey(name: 'is_overdue')  bool? isOverdue)  $default,) {final _that = this;
switch (_that) {
case _UpcomingVaccinationItem():
return $default(_that.id,_that.rabbitId,_that.rabbitName,_that.vaccineName,_that.vaccineType,_that.nextVaccinationDate,_that.daysUntil,_that.isOverdue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@IntConverter()  int rabbitId, @JsonKey(name: 'rabbit_name')  String? rabbitName, @JsonKey(name: 'vaccine_name')  String vaccineName, @JsonKey(name: 'vaccine_type')  VaccineType vaccineType, @JsonKey(name: 'next_vaccination_date')@DateOnlyConverter()  DateTime nextVaccinationDate, @JsonKey(name: 'days_until')  int daysUntil, @JsonKey(name: 'is_overdue')  bool? isOverdue)?  $default,) {final _that = this;
switch (_that) {
case _UpcomingVaccinationItem() when $default != null:
return $default(_that.id,_that.rabbitId,_that.rabbitName,_that.vaccineName,_that.vaccineType,_that.nextVaccinationDate,_that.daysUntil,_that.isOverdue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpcomingVaccinationItem implements UpcomingVaccinationItem {
  const _UpcomingVaccinationItem({@IntConverter() required this.id, @JsonKey(name: 'rabbit_id')@IntConverter() required this.rabbitId, @JsonKey(name: 'rabbit_name') this.rabbitName, @JsonKey(name: 'vaccine_name') required this.vaccineName, @JsonKey(name: 'vaccine_type') required this.vaccineType, @JsonKey(name: 'next_vaccination_date')@DateOnlyConverter() required this.nextVaccinationDate, @JsonKey(name: 'days_until') required this.daysUntil, @JsonKey(name: 'is_overdue') this.isOverdue});
  factory _UpcomingVaccinationItem.fromJson(Map<String, dynamic> json) => _$UpcomingVaccinationItemFromJson(json);

@override@IntConverter() final  int id;
@override@JsonKey(name: 'rabbit_id')@IntConverter() final  int rabbitId;
@override@JsonKey(name: 'rabbit_name') final  String? rabbitName;
@override@JsonKey(name: 'vaccine_name') final  String vaccineName;
@override@JsonKey(name: 'vaccine_type') final  VaccineType vaccineType;
@override@JsonKey(name: 'next_vaccination_date')@DateOnlyConverter() final  DateTime nextVaccinationDate;
@override@JsonKey(name: 'days_until') final  int daysUntil;
@override@JsonKey(name: 'is_overdue') final  bool? isOverdue;

/// Create a copy of UpcomingVaccinationItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpcomingVaccinationItemCopyWith<_UpcomingVaccinationItem> get copyWith => __$UpcomingVaccinationItemCopyWithImpl<_UpcomingVaccinationItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpcomingVaccinationItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpcomingVaccinationItem&&(identical(other.id, id) || other.id == id)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.rabbitName, rabbitName) || other.rabbitName == rabbitName)&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.vaccineType, vaccineType) || other.vaccineType == vaccineType)&&(identical(other.nextVaccinationDate, nextVaccinationDate) || other.nextVaccinationDate == nextVaccinationDate)&&(identical(other.daysUntil, daysUntil) || other.daysUntil == daysUntil)&&(identical(other.isOverdue, isOverdue) || other.isOverdue == isOverdue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,rabbitId,rabbitName,vaccineName,vaccineType,nextVaccinationDate,daysUntil,isOverdue);
}

@override
String toString() {
    return 'UpcomingVaccinationItem(id: $id, rabbitId: $rabbitId, rabbitName: $rabbitName, vaccineName: $vaccineName, vaccineType: $vaccineType, nextVaccinationDate: $nextVaccinationDate, daysUntil: $daysUntil, isOverdue: $isOverdue)';
}


}

/// @nodoc
abstract mixin class _$UpcomingVaccinationItemCopyWith<$Res> implements $UpcomingVaccinationItemCopyWith<$Res> {
  factory _$UpcomingVaccinationItemCopyWith(_UpcomingVaccinationItem value, $Res Function(_UpcomingVaccinationItem) _then) = __$UpcomingVaccinationItemCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@IntConverter() int rabbitId,@JsonKey(name: 'rabbit_name') String? rabbitName,@JsonKey(name: 'vaccine_name') String vaccineName,@JsonKey(name: 'vaccine_type') VaccineType vaccineType,@JsonKey(name: 'next_vaccination_date')@DateOnlyConverter() DateTime nextVaccinationDate,@JsonKey(name: 'days_until') int daysUntil,@JsonKey(name: 'is_overdue') bool? isOverdue
});




}
/// @nodoc
class __$UpcomingVaccinationItemCopyWithImpl<$Res>
    implements _$UpcomingVaccinationItemCopyWith<$Res> {
  __$UpcomingVaccinationItemCopyWithImpl(this._self, this._then);

  final _UpcomingVaccinationItem _self;
  final $Res Function(_UpcomingVaccinationItem) _then;

/// Create a copy of UpcomingVaccinationItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rabbitId = null,Object? rabbitName = freezed,Object? vaccineName = null,Object? vaccineType = null,Object? nextVaccinationDate = null,Object? daysUntil = null,Object? isOverdue = freezed,}) {
  return _then(_UpcomingVaccinationItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: null == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int,rabbitName: freezed == rabbitName ? _self.rabbitName : rabbitName // ignore: cast_nullable_to_non_nullable
as String?,vaccineName: null == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String,vaccineType: null == vaccineType ? _self.vaccineType : vaccineType // ignore: cast_nullable_to_non_nullable
as VaccineType,nextVaccinationDate: null == nextVaccinationDate ? _self.nextVaccinationDate : nextVaccinationDate // ignore: cast_nullable_to_non_nullable
as DateTime,daysUntil: null == daysUntil ? _self.daysUntil : daysUntil // ignore: cast_nullable_to_non_nullable
as int,isOverdue: freezed == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
