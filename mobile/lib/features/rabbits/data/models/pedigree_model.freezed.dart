// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pedigree_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PedigreeModel {

 int get id;/// Кличка необязательна: в базе столбец допускает пустоту, и подставлять
/// за неё готовую фразу здесь значило бы прятать переводимую подпись
/// в слое данных.
 String? get name; String? get tagId; String get sex; String? get birthDate; String? get breed; PedigreeModel? get father; PedigreeModel? get mother;
/// Create a copy of PedigreeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PedigreeModelCopyWith<PedigreeModel> get copyWith => _$PedigreeModelCopyWithImpl<PedigreeModel>(this as PedigreeModel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PedigreeModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PedigreeModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.tagId, _this.tagId) || other.tagId == _this.tagId)&&(identical(other.sex, _this.sex) || other.sex == _this.sex)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.breed, _this.breed) || other.breed == _this.breed)&&(identical(other.father, _this.father) || other.father == _this.father)&&(identical(other.mother, _this.mother) || other.mother == _this.mother));
}


@override
int get hashCode {
  final _this = this as PedigreeModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.tagId,_this.sex,_this.birthDate,_this.breed,_this.father,_this.mother);
}

@override
String toString() {
  final _this = this as PedigreeModel;
  return 'PedigreeModel(id: ${_this.id}, name: ${_this.name}, tagId: ${_this.tagId}, sex: ${_this.sex}, birthDate: ${_this.birthDate}, breed: ${_this.breed}, father: ${_this.father}, mother: ${_this.mother})';
}


}

/// @nodoc
abstract mixin class $PedigreeModelCopyWith<$Res>  {
  factory $PedigreeModelCopyWith(PedigreeModel value, $Res Function(PedigreeModel) _then) = _$PedigreeModelCopyWithImpl;
@useResult
$Res call({
 int id, String? name, String? tagId, String sex, String? birthDate, String? breed, PedigreeModel? father, PedigreeModel? mother
});


$PedigreeModelCopyWith<$Res>? get father;$PedigreeModelCopyWith<$Res>? get mother;

}
/// @nodoc
class _$PedigreeModelCopyWithImpl<$Res>
    implements $PedigreeModelCopyWith<$Res> {
  _$PedigreeModelCopyWithImpl(this._self, this._then);

  final PedigreeModel _self;
  final $Res Function(PedigreeModel) _then;

/// Create a copy of PedigreeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? tagId = freezed,Object? sex = null,Object? birthDate = freezed,Object? breed = freezed,Object? father = freezed,Object? mother = freezed,}) {
  return _then(PedigreeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,tagId: freezed == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as String?,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,breed: freezed == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String?,father: freezed == father ? _self.father : father // ignore: cast_nullable_to_non_nullable
as PedigreeModel?,mother: freezed == mother ? _self.mother : mother // ignore: cast_nullable_to_non_nullable
as PedigreeModel?,
  ));
}
/// Create a copy of PedigreeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PedigreeModelCopyWith<$Res>? get father {
    if (_self.father == null) {
    return null;
  }

  return $PedigreeModelCopyWith<$Res>(_self.father!, (value) {
    return _then(_self.copyWith(father: value));
  });
}/// Create a copy of PedigreeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PedigreeModelCopyWith<$Res>? get mother {
    if (_self.mother == null) {
    return null;
  }

  return $PedigreeModelCopyWith<$Res>(_self.mother!, (value) {
    return _then(_self.copyWith(mother: value));
  });
}
}


/// Adds pattern-matching-related methods to [PedigreeModel].
extension PedigreeModelPatterns on PedigreeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PedigreeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PedigreeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PedigreeModel value)  $default,){
final _that = this;
switch (_that) {
case _PedigreeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PedigreeModel value)?  $default,){
final _that = this;
switch (_that) {
case _PedigreeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? name,  String? tagId,  String sex,  String? birthDate,  String? breed,  PedigreeModel? father,  PedigreeModel? mother)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PedigreeModel() when $default != null:
return $default(_that.id,_that.name,_that.tagId,_that.sex,_that.birthDate,_that.breed,_that.father,_that.mother);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? name,  String? tagId,  String sex,  String? birthDate,  String? breed,  PedigreeModel? father,  PedigreeModel? mother)  $default,) {final _that = this;
switch (_that) {
case _PedigreeModel():
return $default(_that.id,_that.name,_that.tagId,_that.sex,_that.birthDate,_that.breed,_that.father,_that.mother);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? name,  String? tagId,  String sex,  String? birthDate,  String? breed,  PedigreeModel? father,  PedigreeModel? mother)?  $default,) {final _that = this;
switch (_that) {
case _PedigreeModel() when $default != null:
return $default(_that.id,_that.name,_that.tagId,_that.sex,_that.birthDate,_that.breed,_that.father,_that.mother);case _:
  return null;

}
}

}

/// @nodoc


class _PedigreeModel implements PedigreeModel {
  const _PedigreeModel({required this.id, this.name, this.tagId, required this.sex, this.birthDate, this.breed, this.father, this.mother});
  

@override final  int id;
/// Кличка необязательна: в базе столбец допускает пустоту, и подставлять
/// за неё готовую фразу здесь значило бы прятать переводимую подпись
/// в слое данных.
@override final  String? name;
@override final  String? tagId;
@override final  String sex;
@override final  String? birthDate;
@override final  String? breed;
@override final  PedigreeModel? father;
@override final  PedigreeModel? mother;

/// Create a copy of PedigreeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PedigreeModelCopyWith<_PedigreeModel> get copyWith => __$PedigreeModelCopyWithImpl<_PedigreeModel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PedigreeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.tagId, tagId) || other.tagId == tagId)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.father, father) || other.father == father)&&(identical(other.mother, mother) || other.mother == mother));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,tagId,sex,birthDate,breed,father,mother);
}

@override
String toString() {
    return 'PedigreeModel(id: $id, name: $name, tagId: $tagId, sex: $sex, birthDate: $birthDate, breed: $breed, father: $father, mother: $mother)';
}


}

/// @nodoc
abstract mixin class _$PedigreeModelCopyWith<$Res> implements $PedigreeModelCopyWith<$Res> {
  factory _$PedigreeModelCopyWith(_PedigreeModel value, $Res Function(_PedigreeModel) _then) = __$PedigreeModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String? name, String? tagId, String sex, String? birthDate, String? breed, PedigreeModel? father, PedigreeModel? mother
});


@override $PedigreeModelCopyWith<$Res>? get father;@override $PedigreeModelCopyWith<$Res>? get mother;

}
/// @nodoc
class __$PedigreeModelCopyWithImpl<$Res>
    implements _$PedigreeModelCopyWith<$Res> {
  __$PedigreeModelCopyWithImpl(this._self, this._then);

  final _PedigreeModel _self;
  final $Res Function(_PedigreeModel) _then;

/// Create a copy of PedigreeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? tagId = freezed,Object? sex = null,Object? birthDate = freezed,Object? breed = freezed,Object? father = freezed,Object? mother = freezed,}) {
  return _then(_PedigreeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,tagId: freezed == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as String?,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,breed: freezed == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String?,father: freezed == father ? _self.father : father // ignore: cast_nullable_to_non_nullable
as PedigreeModel?,mother: freezed == mother ? _self.mother : mother // ignore: cast_nullable_to_non_nullable
as PedigreeModel?,
  ));
}

/// Create a copy of PedigreeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PedigreeModelCopyWith<$Res>? get father {
    if (_self.father == null) {
    return null;
  }

  return $PedigreeModelCopyWith<$Res>(_self.father!, (value) {
    return _then(_self.copyWith(father: value));
  });
}/// Create a copy of PedigreeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PedigreeModelCopyWith<$Res>? get mother {
    if (_self.mother == null) {
    return null;
  }

  return $PedigreeModelCopyWith<$Res>(_self.mother!, (value) {
    return _then(_self.copyWith(mother: value));
  });
}
}

// dart format on
