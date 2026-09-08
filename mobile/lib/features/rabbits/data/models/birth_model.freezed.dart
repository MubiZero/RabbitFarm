// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'birth_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BirthModel implements DiagnosticableTreeMixin {

 int get id;@JsonKey(name: 'breeding_id') int? get breedingId;@JsonKey(name: 'mother_id') int get motherId;@JsonKey(name: 'birth_date') String get birthDate;@JsonKey(name: 'kits_born_alive') int get kitsBornAlive;@JsonKey(name: 'kits_born_dead') int get kitsBornDead;@JsonKey(name: 'kits_weaned') int? get kitsWeaned;@JsonKey(name: 'weaning_date') String? get weaningDate; String? get complications; String? get notes;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt; RabbitModel? get mother; BreedingModel? get breeding; List<RabbitModel>? get kits;
/// Create a copy of BirthModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BirthModelCopyWith<BirthModel> get copyWith => _$BirthModelCopyWithImpl<BirthModel>(this as BirthModel, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as BirthModel;
  properties
    ..add(DiagnosticsProperty('type', 'BirthModel'))
    ..add(DiagnosticsProperty('id', _this.id))..add(DiagnosticsProperty('breedingId', _this.breedingId))..add(DiagnosticsProperty('motherId', _this.motherId))..add(DiagnosticsProperty('birthDate', _this.birthDate))..add(DiagnosticsProperty('kitsBornAlive', _this.kitsBornAlive))..add(DiagnosticsProperty('kitsBornDead', _this.kitsBornDead))..add(DiagnosticsProperty('kitsWeaned', _this.kitsWeaned))..add(DiagnosticsProperty('weaningDate', _this.weaningDate))..add(DiagnosticsProperty('complications', _this.complications))..add(DiagnosticsProperty('notes', _this.notes))..add(DiagnosticsProperty('createdAt', _this.createdAt))..add(DiagnosticsProperty('updatedAt', _this.updatedAt))..add(DiagnosticsProperty('mother', _this.mother))..add(DiagnosticsProperty('breeding', _this.breeding))..add(DiagnosticsProperty('kits', _this.kits));
}

@override
bool operator ==(Object other) {
  final _this = this as BirthModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BirthModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.breedingId, _this.breedingId) || other.breedingId == _this.breedingId)&&(identical(other.motherId, _this.motherId) || other.motherId == _this.motherId)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.kitsBornAlive, _this.kitsBornAlive) || other.kitsBornAlive == _this.kitsBornAlive)&&(identical(other.kitsBornDead, _this.kitsBornDead) || other.kitsBornDead == _this.kitsBornDead)&&(identical(other.kitsWeaned, _this.kitsWeaned) || other.kitsWeaned == _this.kitsWeaned)&&(identical(other.weaningDate, _this.weaningDate) || other.weaningDate == _this.weaningDate)&&(identical(other.complications, _this.complications) || other.complications == _this.complications)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.mother, _this.mother) || other.mother == _this.mother)&&(identical(other.breeding, _this.breeding) || other.breeding == _this.breeding)&&const DeepCollectionEquality().equals(other.kits, _this.kits));
}


@override
int get hashCode {
  final _this = this as BirthModel;
  return Object.hash(runtimeType,_this.id,_this.breedingId,_this.motherId,_this.birthDate,_this.kitsBornAlive,_this.kitsBornDead,_this.kitsWeaned,_this.weaningDate,_this.complications,_this.notes,_this.createdAt,_this.updatedAt,_this.mother,_this.breeding,const DeepCollectionEquality().hash(_this.kits));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as BirthModel;
  return 'BirthModel(id: ${_this.id}, breedingId: ${_this.breedingId}, motherId: ${_this.motherId}, birthDate: ${_this.birthDate}, kitsBornAlive: ${_this.kitsBornAlive}, kitsBornDead: ${_this.kitsBornDead}, kitsWeaned: ${_this.kitsWeaned}, weaningDate: ${_this.weaningDate}, complications: ${_this.complications}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, mother: ${_this.mother}, breeding: ${_this.breeding}, kits: ${_this.kits})';
}


}

/// @nodoc
abstract mixin class $BirthModelCopyWith<$Res>  {
  factory $BirthModelCopyWith(BirthModel value, $Res Function(BirthModel) _then) = _$BirthModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'breeding_id') int? breedingId,@JsonKey(name: 'mother_id') int motherId,@JsonKey(name: 'birth_date') String birthDate,@JsonKey(name: 'kits_born_alive') int kitsBornAlive,@JsonKey(name: 'kits_born_dead') int kitsBornDead,@JsonKey(name: 'kits_weaned') int? kitsWeaned,@JsonKey(name: 'weaning_date') String? weaningDate, String? complications, String? notes,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, RabbitModel? mother, BreedingModel? breeding, List<RabbitModel>? kits
});


$RabbitModelCopyWith<$Res>? get mother;$BreedingModelCopyWith<$Res>? get breeding;

}
/// @nodoc
class _$BirthModelCopyWithImpl<$Res>
    implements $BirthModelCopyWith<$Res> {
  _$BirthModelCopyWithImpl(this._self, this._then);

  final BirthModel _self;
  final $Res Function(BirthModel) _then;

/// Create a copy of BirthModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? breedingId = freezed,Object? motherId = null,Object? birthDate = null,Object? kitsBornAlive = null,Object? kitsBornDead = null,Object? kitsWeaned = freezed,Object? weaningDate = freezed,Object? complications = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? mother = freezed,Object? breeding = freezed,Object? kits = freezed,}) {
  return _then(BirthModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,breedingId: freezed == breedingId ? _self.breedingId : breedingId // ignore: cast_nullable_to_non_nullable
as int?,motherId: null == motherId ? _self.motherId : motherId // ignore: cast_nullable_to_non_nullable
as int,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String,kitsBornAlive: null == kitsBornAlive ? _self.kitsBornAlive : kitsBornAlive // ignore: cast_nullable_to_non_nullable
as int,kitsBornDead: null == kitsBornDead ? _self.kitsBornDead : kitsBornDead // ignore: cast_nullable_to_non_nullable
as int,kitsWeaned: freezed == kitsWeaned ? _self.kitsWeaned : kitsWeaned // ignore: cast_nullable_to_non_nullable
as int?,weaningDate: freezed == weaningDate ? _self.weaningDate : weaningDate // ignore: cast_nullable_to_non_nullable
as String?,complications: freezed == complications ? _self.complications : complications // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,mother: freezed == mother ? _self.mother : mother // ignore: cast_nullable_to_non_nullable
as RabbitModel?,breeding: freezed == breeding ? _self.breeding : breeding // ignore: cast_nullable_to_non_nullable
as BreedingModel?,kits: freezed == kits ? _self.kits : kits // ignore: cast_nullable_to_non_nullable
as List<RabbitModel>?,
  ));
}
/// Create a copy of BirthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitModelCopyWith<$Res>? get mother {
    if (_self.mother == null) {
    return null;
  }

  return $RabbitModelCopyWith<$Res>(_self.mother!, (value) {
    return _then(_self.copyWith(mother: value));
  });
}/// Create a copy of BirthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BreedingModelCopyWith<$Res>? get breeding {
    if (_self.breeding == null) {
    return null;
  }

  return $BreedingModelCopyWith<$Res>(_self.breeding!, (value) {
    return _then(_self.copyWith(breeding: value));
  });
}
}


/// Adds pattern-matching-related methods to [BirthModel].
extension BirthModelPatterns on BirthModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BirthModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BirthModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BirthModel value)  $default,){
final _that = this;
switch (_that) {
case _BirthModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BirthModel value)?  $default,){
final _that = this;
switch (_that) {
case _BirthModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'breeding_id')  int? breedingId, @JsonKey(name: 'mother_id')  int motherId, @JsonKey(name: 'birth_date')  String birthDate, @JsonKey(name: 'kits_born_alive')  int kitsBornAlive, @JsonKey(name: 'kits_born_dead')  int kitsBornDead, @JsonKey(name: 'kits_weaned')  int? kitsWeaned, @JsonKey(name: 'weaning_date')  String? weaningDate,  String? complications,  String? notes, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  RabbitModel? mother,  BreedingModel? breeding,  List<RabbitModel>? kits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BirthModel() when $default != null:
return $default(_that.id,_that.breedingId,_that.motherId,_that.birthDate,_that.kitsBornAlive,_that.kitsBornDead,_that.kitsWeaned,_that.weaningDate,_that.complications,_that.notes,_that.createdAt,_that.updatedAt,_that.mother,_that.breeding,_that.kits);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'breeding_id')  int? breedingId, @JsonKey(name: 'mother_id')  int motherId, @JsonKey(name: 'birth_date')  String birthDate, @JsonKey(name: 'kits_born_alive')  int kitsBornAlive, @JsonKey(name: 'kits_born_dead')  int kitsBornDead, @JsonKey(name: 'kits_weaned')  int? kitsWeaned, @JsonKey(name: 'weaning_date')  String? weaningDate,  String? complications,  String? notes, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  RabbitModel? mother,  BreedingModel? breeding,  List<RabbitModel>? kits)  $default,) {final _that = this;
switch (_that) {
case _BirthModel():
return $default(_that.id,_that.breedingId,_that.motherId,_that.birthDate,_that.kitsBornAlive,_that.kitsBornDead,_that.kitsWeaned,_that.weaningDate,_that.complications,_that.notes,_that.createdAt,_that.updatedAt,_that.mother,_that.breeding,_that.kits);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'breeding_id')  int? breedingId, @JsonKey(name: 'mother_id')  int motherId, @JsonKey(name: 'birth_date')  String birthDate, @JsonKey(name: 'kits_born_alive')  int kitsBornAlive, @JsonKey(name: 'kits_born_dead')  int kitsBornDead, @JsonKey(name: 'kits_weaned')  int? kitsWeaned, @JsonKey(name: 'weaning_date')  String? weaningDate,  String? complications,  String? notes, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  RabbitModel? mother,  BreedingModel? breeding,  List<RabbitModel>? kits)?  $default,) {final _that = this;
switch (_that) {
case _BirthModel() when $default != null:
return $default(_that.id,_that.breedingId,_that.motherId,_that.birthDate,_that.kitsBornAlive,_that.kitsBornDead,_that.kitsWeaned,_that.weaningDate,_that.complications,_that.notes,_that.createdAt,_that.updatedAt,_that.mother,_that.breeding,_that.kits);case _:
  return null;

}
}

}

/// @nodoc


class _BirthModel with DiagnosticableTreeMixin implements BirthModel {
  const _BirthModel({required this.id, @JsonKey(name: 'breeding_id') this.breedingId, @JsonKey(name: 'mother_id') required this.motherId, @JsonKey(name: 'birth_date') required this.birthDate, @JsonKey(name: 'kits_born_alive') required this.kitsBornAlive, @JsonKey(name: 'kits_born_dead') required this.kitsBornDead, @JsonKey(name: 'kits_weaned') this.kitsWeaned, @JsonKey(name: 'weaning_date') this.weaningDate, this.complications, this.notes, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, this.mother, this.breeding,  List<RabbitModel>? kits}): _kits = kits;
  

@override final  int id;
@override@JsonKey(name: 'breeding_id') final  int? breedingId;
@override@JsonKey(name: 'mother_id') final  int motherId;
@override@JsonKey(name: 'birth_date') final  String birthDate;
@override@JsonKey(name: 'kits_born_alive') final  int kitsBornAlive;
@override@JsonKey(name: 'kits_born_dead') final  int kitsBornDead;
@override@JsonKey(name: 'kits_weaned') final  int? kitsWeaned;
@override@JsonKey(name: 'weaning_date') final  String? weaningDate;
@override final  String? complications;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override final  RabbitModel? mother;
@override final  BreedingModel? breeding;
 final  List<RabbitModel>? _kits;
@override List<RabbitModel>? get kits {
  final value = _kits;
  if (value == null) return null;
  if (_kits is EqualUnmodifiableListView) return _kits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of BirthModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BirthModelCopyWith<_BirthModel> get copyWith => __$BirthModelCopyWithImpl<_BirthModel>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'BirthModel'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('breedingId', breedingId))..add(DiagnosticsProperty('motherId', motherId))..add(DiagnosticsProperty('birthDate', birthDate))..add(DiagnosticsProperty('kitsBornAlive', kitsBornAlive))..add(DiagnosticsProperty('kitsBornDead', kitsBornDead))..add(DiagnosticsProperty('kitsWeaned', kitsWeaned))..add(DiagnosticsProperty('weaningDate', weaningDate))..add(DiagnosticsProperty('complications', complications))..add(DiagnosticsProperty('notes', notes))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('updatedAt', updatedAt))..add(DiagnosticsProperty('mother', mother))..add(DiagnosticsProperty('breeding', breeding))..add(DiagnosticsProperty('kits', kits));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BirthModel&&(identical(other.id, id) || other.id == id)&&(identical(other.breedingId, breedingId) || other.breedingId == breedingId)&&(identical(other.motherId, motherId) || other.motherId == motherId)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.kitsBornAlive, kitsBornAlive) || other.kitsBornAlive == kitsBornAlive)&&(identical(other.kitsBornDead, kitsBornDead) || other.kitsBornDead == kitsBornDead)&&(identical(other.kitsWeaned, kitsWeaned) || other.kitsWeaned == kitsWeaned)&&(identical(other.weaningDate, weaningDate) || other.weaningDate == weaningDate)&&(identical(other.complications, complications) || other.complications == complications)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.mother, mother) || other.mother == mother)&&(identical(other.breeding, breeding) || other.breeding == breeding)&&const DeepCollectionEquality().equals(other.kits, _kits));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,breedingId,motherId,birthDate,kitsBornAlive,kitsBornDead,kitsWeaned,weaningDate,complications,notes,createdAt,updatedAt,mother,breeding,const DeepCollectionEquality().hash(_kits));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'BirthModel(id: $id, breedingId: $breedingId, motherId: $motherId, birthDate: $birthDate, kitsBornAlive: $kitsBornAlive, kitsBornDead: $kitsBornDead, kitsWeaned: $kitsWeaned, weaningDate: $weaningDate, complications: $complications, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, mother: $mother, breeding: $breeding, kits: $kits)';
}


}

/// @nodoc
abstract mixin class _$BirthModelCopyWith<$Res> implements $BirthModelCopyWith<$Res> {
  factory _$BirthModelCopyWith(_BirthModel value, $Res Function(_BirthModel) _then) = __$BirthModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'breeding_id') int? breedingId,@JsonKey(name: 'mother_id') int motherId,@JsonKey(name: 'birth_date') String birthDate,@JsonKey(name: 'kits_born_alive') int kitsBornAlive,@JsonKey(name: 'kits_born_dead') int kitsBornDead,@JsonKey(name: 'kits_weaned') int? kitsWeaned,@JsonKey(name: 'weaning_date') String? weaningDate, String? complications, String? notes,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, RabbitModel? mother, BreedingModel? breeding, List<RabbitModel>? kits
});


@override $RabbitModelCopyWith<$Res>? get mother;@override $BreedingModelCopyWith<$Res>? get breeding;

}
/// @nodoc
class __$BirthModelCopyWithImpl<$Res>
    implements _$BirthModelCopyWith<$Res> {
  __$BirthModelCopyWithImpl(this._self, this._then);

  final _BirthModel _self;
  final $Res Function(_BirthModel) _then;

/// Create a copy of BirthModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? breedingId = freezed,Object? motherId = null,Object? birthDate = null,Object? kitsBornAlive = null,Object? kitsBornDead = null,Object? kitsWeaned = freezed,Object? weaningDate = freezed,Object? complications = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? mother = freezed,Object? breeding = freezed,Object? kits = freezed,}) {
  return _then(_BirthModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,breedingId: freezed == breedingId ? _self.breedingId : breedingId // ignore: cast_nullable_to_non_nullable
as int?,motherId: null == motherId ? _self.motherId : motherId // ignore: cast_nullable_to_non_nullable
as int,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String,kitsBornAlive: null == kitsBornAlive ? _self.kitsBornAlive : kitsBornAlive // ignore: cast_nullable_to_non_nullable
as int,kitsBornDead: null == kitsBornDead ? _self.kitsBornDead : kitsBornDead // ignore: cast_nullable_to_non_nullable
as int,kitsWeaned: freezed == kitsWeaned ? _self.kitsWeaned : kitsWeaned // ignore: cast_nullable_to_non_nullable
as int?,weaningDate: freezed == weaningDate ? _self.weaningDate : weaningDate // ignore: cast_nullable_to_non_nullable
as String?,complications: freezed == complications ? _self.complications : complications // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,mother: freezed == mother ? _self.mother : mother // ignore: cast_nullable_to_non_nullable
as RabbitModel?,breeding: freezed == breeding ? _self.breeding : breeding // ignore: cast_nullable_to_non_nullable
as BreedingModel?,kits: freezed == kits ? _self._kits : kits // ignore: cast_nullable_to_non_nullable
as List<RabbitModel>?,
  ));
}

/// Create a copy of BirthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitModelCopyWith<$Res>? get mother {
    if (_self.mother == null) {
    return null;
  }

  return $RabbitModelCopyWith<$Res>(_self.mother!, (value) {
    return _then(_self.copyWith(mother: value));
  });
}/// Create a copy of BirthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BreedingModelCopyWith<$Res>? get breeding {
    if (_self.breeding == null) {
    return null;
  }

  return $BreedingModelCopyWith<$Res>(_self.breeding!, (value) {
    return _then(_self.copyWith(breeding: value));
  });
}
}

// dart format on
