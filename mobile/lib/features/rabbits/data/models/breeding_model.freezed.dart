// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breeding_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BreedingModel {

 int get id;@JsonKey(name: 'male_id') int get maleId;@JsonKey(name: 'female_id') int get femaleId;@JsonKey(name: 'breeding_date') String get breedingDate; String get status;@JsonKey(name: 'palpation_date') String? get palpationDate;@JsonKey(name: 'is_pregnant') bool? get isPregnant;@JsonKey(name: 'expected_birth_date') String? get expectedBirthDate; String? get notes;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt; RabbitModel? get male; RabbitModel? get female; String? get actualBirthDate; String? get weaningDate;@JsonKey(name: 'inbreeding_coefficient') double? get inbreedingCoefficient;@JsonKey(name: 'common_ancestors') List<String>? get commonAncestors;
/// Create a copy of BreedingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedingModelCopyWith<BreedingModel> get copyWith => _$BreedingModelCopyWithImpl<BreedingModel>(this as BreedingModel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BreedingModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedingModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.maleId, _this.maleId) || other.maleId == _this.maleId)&&(identical(other.femaleId, _this.femaleId) || other.femaleId == _this.femaleId)&&(identical(other.breedingDate, _this.breedingDate) || other.breedingDate == _this.breedingDate)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.palpationDate, _this.palpationDate) || other.palpationDate == _this.palpationDate)&&(identical(other.isPregnant, _this.isPregnant) || other.isPregnant == _this.isPregnant)&&(identical(other.expectedBirthDate, _this.expectedBirthDate) || other.expectedBirthDate == _this.expectedBirthDate)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.male, _this.male) || other.male == _this.male)&&(identical(other.female, _this.female) || other.female == _this.female)&&(identical(other.actualBirthDate, _this.actualBirthDate) || other.actualBirthDate == _this.actualBirthDate)&&(identical(other.weaningDate, _this.weaningDate) || other.weaningDate == _this.weaningDate)&&(identical(other.inbreedingCoefficient, _this.inbreedingCoefficient) || other.inbreedingCoefficient == _this.inbreedingCoefficient)&&const DeepCollectionEquality().equals(other.commonAncestors, _this.commonAncestors));
}


@override
int get hashCode {
  final _this = this as BreedingModel;
  return Object.hash(runtimeType,_this.id,_this.maleId,_this.femaleId,_this.breedingDate,_this.status,_this.palpationDate,_this.isPregnant,_this.expectedBirthDate,_this.notes,_this.createdAt,_this.updatedAt,_this.male,_this.female,_this.actualBirthDate,_this.weaningDate,_this.inbreedingCoefficient,const DeepCollectionEquality().hash(_this.commonAncestors));
}

@override
String toString() {
  final _this = this as BreedingModel;
  return 'BreedingModel(id: ${_this.id}, maleId: ${_this.maleId}, femaleId: ${_this.femaleId}, breedingDate: ${_this.breedingDate}, status: ${_this.status}, palpationDate: ${_this.palpationDate}, isPregnant: ${_this.isPregnant}, expectedBirthDate: ${_this.expectedBirthDate}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, male: ${_this.male}, female: ${_this.female}, actualBirthDate: ${_this.actualBirthDate}, weaningDate: ${_this.weaningDate}, inbreedingCoefficient: ${_this.inbreedingCoefficient}, commonAncestors: ${_this.commonAncestors})';
}


}

/// @nodoc
abstract mixin class $BreedingModelCopyWith<$Res>  {
  factory $BreedingModelCopyWith(BreedingModel value, $Res Function(BreedingModel) _then) = _$BreedingModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'male_id') int maleId,@JsonKey(name: 'female_id') int femaleId,@JsonKey(name: 'breeding_date') String breedingDate, String status,@JsonKey(name: 'palpation_date') String? palpationDate,@JsonKey(name: 'is_pregnant') bool? isPregnant,@JsonKey(name: 'expected_birth_date') String? expectedBirthDate, String? notes,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, RabbitModel? male, RabbitModel? female, String? actualBirthDate, String? weaningDate,@JsonKey(name: 'inbreeding_coefficient') double? inbreedingCoefficient,@JsonKey(name: 'common_ancestors') List<String>? commonAncestors
});


$RabbitModelCopyWith<$Res>? get male;$RabbitModelCopyWith<$Res>? get female;

}
/// @nodoc
class _$BreedingModelCopyWithImpl<$Res>
    implements $BreedingModelCopyWith<$Res> {
  _$BreedingModelCopyWithImpl(this._self, this._then);

  final BreedingModel _self;
  final $Res Function(BreedingModel) _then;

/// Create a copy of BreedingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? maleId = null,Object? femaleId = null,Object? breedingDate = null,Object? status = null,Object? palpationDate = freezed,Object? isPregnant = freezed,Object? expectedBirthDate = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? male = freezed,Object? female = freezed,Object? actualBirthDate = freezed,Object? weaningDate = freezed,Object? inbreedingCoefficient = freezed,Object? commonAncestors = freezed,}) {
  return _then(BreedingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,maleId: null == maleId ? _self.maleId : maleId // ignore: cast_nullable_to_non_nullable
as int,femaleId: null == femaleId ? _self.femaleId : femaleId // ignore: cast_nullable_to_non_nullable
as int,breedingDate: null == breedingDate ? _self.breedingDate : breedingDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,palpationDate: freezed == palpationDate ? _self.palpationDate : palpationDate // ignore: cast_nullable_to_non_nullable
as String?,isPregnant: freezed == isPregnant ? _self.isPregnant : isPregnant // ignore: cast_nullable_to_non_nullable
as bool?,expectedBirthDate: freezed == expectedBirthDate ? _self.expectedBirthDate : expectedBirthDate // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,male: freezed == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as RabbitModel?,female: freezed == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as RabbitModel?,actualBirthDate: freezed == actualBirthDate ? _self.actualBirthDate : actualBirthDate // ignore: cast_nullable_to_non_nullable
as String?,weaningDate: freezed == weaningDate ? _self.weaningDate : weaningDate // ignore: cast_nullable_to_non_nullable
as String?,inbreedingCoefficient: freezed == inbreedingCoefficient ? _self.inbreedingCoefficient : inbreedingCoefficient // ignore: cast_nullable_to_non_nullable
as double?,commonAncestors: freezed == commonAncestors ? _self.commonAncestors : commonAncestors // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}
/// Create a copy of BreedingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitModelCopyWith<$Res>? get male {
    if (_self.male == null) {
    return null;
  }

  return $RabbitModelCopyWith<$Res>(_self.male!, (value) {
    return _then(_self.copyWith(male: value));
  });
}/// Create a copy of BreedingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitModelCopyWith<$Res>? get female {
    if (_self.female == null) {
    return null;
  }

  return $RabbitModelCopyWith<$Res>(_self.female!, (value) {
    return _then(_self.copyWith(female: value));
  });
}
}


/// Adds pattern-matching-related methods to [BreedingModel].
extension BreedingModelPatterns on BreedingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreedingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreedingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreedingModel value)  $default,){
final _that = this;
switch (_that) {
case _BreedingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreedingModel value)?  $default,){
final _that = this;
switch (_that) {
case _BreedingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'male_id')  int maleId, @JsonKey(name: 'female_id')  int femaleId, @JsonKey(name: 'breeding_date')  String breedingDate,  String status, @JsonKey(name: 'palpation_date')  String? palpationDate, @JsonKey(name: 'is_pregnant')  bool? isPregnant, @JsonKey(name: 'expected_birth_date')  String? expectedBirthDate,  String? notes, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  RabbitModel? male,  RabbitModel? female,  String? actualBirthDate,  String? weaningDate, @JsonKey(name: 'inbreeding_coefficient')  double? inbreedingCoefficient, @JsonKey(name: 'common_ancestors')  List<String>? commonAncestors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreedingModel() when $default != null:
return $default(_that.id,_that.maleId,_that.femaleId,_that.breedingDate,_that.status,_that.palpationDate,_that.isPregnant,_that.expectedBirthDate,_that.notes,_that.createdAt,_that.updatedAt,_that.male,_that.female,_that.actualBirthDate,_that.weaningDate,_that.inbreedingCoefficient,_that.commonAncestors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'male_id')  int maleId, @JsonKey(name: 'female_id')  int femaleId, @JsonKey(name: 'breeding_date')  String breedingDate,  String status, @JsonKey(name: 'palpation_date')  String? palpationDate, @JsonKey(name: 'is_pregnant')  bool? isPregnant, @JsonKey(name: 'expected_birth_date')  String? expectedBirthDate,  String? notes, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  RabbitModel? male,  RabbitModel? female,  String? actualBirthDate,  String? weaningDate, @JsonKey(name: 'inbreeding_coefficient')  double? inbreedingCoefficient, @JsonKey(name: 'common_ancestors')  List<String>? commonAncestors)  $default,) {final _that = this;
switch (_that) {
case _BreedingModel():
return $default(_that.id,_that.maleId,_that.femaleId,_that.breedingDate,_that.status,_that.palpationDate,_that.isPregnant,_that.expectedBirthDate,_that.notes,_that.createdAt,_that.updatedAt,_that.male,_that.female,_that.actualBirthDate,_that.weaningDate,_that.inbreedingCoefficient,_that.commonAncestors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'male_id')  int maleId, @JsonKey(name: 'female_id')  int femaleId, @JsonKey(name: 'breeding_date')  String breedingDate,  String status, @JsonKey(name: 'palpation_date')  String? palpationDate, @JsonKey(name: 'is_pregnant')  bool? isPregnant, @JsonKey(name: 'expected_birth_date')  String? expectedBirthDate,  String? notes, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  RabbitModel? male,  RabbitModel? female,  String? actualBirthDate,  String? weaningDate, @JsonKey(name: 'inbreeding_coefficient')  double? inbreedingCoefficient, @JsonKey(name: 'common_ancestors')  List<String>? commonAncestors)?  $default,) {final _that = this;
switch (_that) {
case _BreedingModel() when $default != null:
return $default(_that.id,_that.maleId,_that.femaleId,_that.breedingDate,_that.status,_that.palpationDate,_that.isPregnant,_that.expectedBirthDate,_that.notes,_that.createdAt,_that.updatedAt,_that.male,_that.female,_that.actualBirthDate,_that.weaningDate,_that.inbreedingCoefficient,_that.commonAncestors);case _:
  return null;

}
}

}

/// @nodoc


class _BreedingModel implements BreedingModel {
  const _BreedingModel({required this.id, @JsonKey(name: 'male_id') required this.maleId, @JsonKey(name: 'female_id') required this.femaleId, @JsonKey(name: 'breeding_date') required this.breedingDate, required this.status, @JsonKey(name: 'palpation_date') this.palpationDate, @JsonKey(name: 'is_pregnant') this.isPregnant, @JsonKey(name: 'expected_birth_date') this.expectedBirthDate, this.notes, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, this.male, this.female, this.actualBirthDate, this.weaningDate, @JsonKey(name: 'inbreeding_coefficient') this.inbreedingCoefficient, @JsonKey(name: 'common_ancestors')  List<String>? commonAncestors}): _commonAncestors = commonAncestors;
  

@override final  int id;
@override@JsonKey(name: 'male_id') final  int maleId;
@override@JsonKey(name: 'female_id') final  int femaleId;
@override@JsonKey(name: 'breeding_date') final  String breedingDate;
@override final  String status;
@override@JsonKey(name: 'palpation_date') final  String? palpationDate;
@override@JsonKey(name: 'is_pregnant') final  bool? isPregnant;
@override@JsonKey(name: 'expected_birth_date') final  String? expectedBirthDate;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override final  RabbitModel? male;
@override final  RabbitModel? female;
@override final  String? actualBirthDate;
@override final  String? weaningDate;
@override@JsonKey(name: 'inbreeding_coefficient') final  double? inbreedingCoefficient;
 final  List<String>? _commonAncestors;
@override@JsonKey(name: 'common_ancestors') List<String>? get commonAncestors {
  final value = _commonAncestors;
  if (value == null) return null;
  if (_commonAncestors is EqualUnmodifiableListView) return _commonAncestors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of BreedingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedingModelCopyWith<_BreedingModel> get copyWith => __$BreedingModelCopyWithImpl<_BreedingModel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.maleId, maleId) || other.maleId == maleId)&&(identical(other.femaleId, femaleId) || other.femaleId == femaleId)&&(identical(other.breedingDate, breedingDate) || other.breedingDate == breedingDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.palpationDate, palpationDate) || other.palpationDate == palpationDate)&&(identical(other.isPregnant, isPregnant) || other.isPregnant == isPregnant)&&(identical(other.expectedBirthDate, expectedBirthDate) || other.expectedBirthDate == expectedBirthDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.male, male) || other.male == male)&&(identical(other.female, female) || other.female == female)&&(identical(other.actualBirthDate, actualBirthDate) || other.actualBirthDate == actualBirthDate)&&(identical(other.weaningDate, weaningDate) || other.weaningDate == weaningDate)&&(identical(other.inbreedingCoefficient, inbreedingCoefficient) || other.inbreedingCoefficient == inbreedingCoefficient)&&const DeepCollectionEquality().equals(other.commonAncestors, _commonAncestors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,maleId,femaleId,breedingDate,status,palpationDate,isPregnant,expectedBirthDate,notes,createdAt,updatedAt,male,female,actualBirthDate,weaningDate,inbreedingCoefficient,const DeepCollectionEquality().hash(_commonAncestors));
}

@override
String toString() {
    return 'BreedingModel(id: $id, maleId: $maleId, femaleId: $femaleId, breedingDate: $breedingDate, status: $status, palpationDate: $palpationDate, isPregnant: $isPregnant, expectedBirthDate: $expectedBirthDate, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, male: $male, female: $female, actualBirthDate: $actualBirthDate, weaningDate: $weaningDate, inbreedingCoefficient: $inbreedingCoefficient, commonAncestors: $commonAncestors)';
}


}

/// @nodoc
abstract mixin class _$BreedingModelCopyWith<$Res> implements $BreedingModelCopyWith<$Res> {
  factory _$BreedingModelCopyWith(_BreedingModel value, $Res Function(_BreedingModel) _then) = __$BreedingModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'male_id') int maleId,@JsonKey(name: 'female_id') int femaleId,@JsonKey(name: 'breeding_date') String breedingDate, String status,@JsonKey(name: 'palpation_date') String? palpationDate,@JsonKey(name: 'is_pregnant') bool? isPregnant,@JsonKey(name: 'expected_birth_date') String? expectedBirthDate, String? notes,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, RabbitModel? male, RabbitModel? female, String? actualBirthDate, String? weaningDate,@JsonKey(name: 'inbreeding_coefficient') double? inbreedingCoefficient,@JsonKey(name: 'common_ancestors') List<String>? commonAncestors
});


@override $RabbitModelCopyWith<$Res>? get male;@override $RabbitModelCopyWith<$Res>? get female;

}
/// @nodoc
class __$BreedingModelCopyWithImpl<$Res>
    implements _$BreedingModelCopyWith<$Res> {
  __$BreedingModelCopyWithImpl(this._self, this._then);

  final _BreedingModel _self;
  final $Res Function(_BreedingModel) _then;

/// Create a copy of BreedingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? maleId = null,Object? femaleId = null,Object? breedingDate = null,Object? status = null,Object? palpationDate = freezed,Object? isPregnant = freezed,Object? expectedBirthDate = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? male = freezed,Object? female = freezed,Object? actualBirthDate = freezed,Object? weaningDate = freezed,Object? inbreedingCoefficient = freezed,Object? commonAncestors = freezed,}) {
  return _then(_BreedingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,maleId: null == maleId ? _self.maleId : maleId // ignore: cast_nullable_to_non_nullable
as int,femaleId: null == femaleId ? _self.femaleId : femaleId // ignore: cast_nullable_to_non_nullable
as int,breedingDate: null == breedingDate ? _self.breedingDate : breedingDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,palpationDate: freezed == palpationDate ? _self.palpationDate : palpationDate // ignore: cast_nullable_to_non_nullable
as String?,isPregnant: freezed == isPregnant ? _self.isPregnant : isPregnant // ignore: cast_nullable_to_non_nullable
as bool?,expectedBirthDate: freezed == expectedBirthDate ? _self.expectedBirthDate : expectedBirthDate // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,male: freezed == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as RabbitModel?,female: freezed == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as RabbitModel?,actualBirthDate: freezed == actualBirthDate ? _self.actualBirthDate : actualBirthDate // ignore: cast_nullable_to_non_nullable
as String?,weaningDate: freezed == weaningDate ? _self.weaningDate : weaningDate // ignore: cast_nullable_to_non_nullable
as String?,inbreedingCoefficient: freezed == inbreedingCoefficient ? _self.inbreedingCoefficient : inbreedingCoefficient // ignore: cast_nullable_to_non_nullable
as double?,commonAncestors: freezed == commonAncestors ? _self._commonAncestors : commonAncestors // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

/// Create a copy of BreedingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitModelCopyWith<$Res>? get male {
    if (_self.male == null) {
    return null;
  }

  return $RabbitModelCopyWith<$Res>(_self.male!, (value) {
    return _then(_self.copyWith(male: value));
  });
}/// Create a copy of BreedingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitModelCopyWith<$Res>? get female {
    if (_self.female == null) {
    return null;
  }

  return $RabbitModelCopyWith<$Res>(_self.female!, (value) {
    return _then(_self.copyWith(female: value));
  });
}
}

// dart format on
