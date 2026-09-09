// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 int get id; String get email;@JsonKey(name: 'full_name') String get fullName; String get role; String? get phone;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'is_platform_admin') bool get isPlatformAdmin;@JsonKey(name: 'last_login_at')@NullableDateTimeConverter() DateTime? get lastLoginAt;@JsonKey(name: 'created_at')@DateTimeConverter() DateTime get createdAt;@JsonKey(name: 'updated_at')@DateTimeConverter() DateTime get updatedAt; FarmRef? get farm;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.isPlatformAdmin, _this.isPlatformAdmin) || other.isPlatformAdmin == _this.isPlatformAdmin)&&(identical(other.lastLoginAt, _this.lastLoginAt) || other.lastLoginAt == _this.lastLoginAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.farm, _this.farm) || other.farm == _this.farm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserModel;
  return Object.hash(runtimeType,_this.id,_this.email,_this.fullName,_this.role,_this.phone,_this.avatarUrl,_this.isActive,_this.isPlatformAdmin,_this.lastLoginAt,_this.createdAt,_this.updatedAt,_this.farm);
}

@override
String toString() {
  final _this = this as UserModel;
  return 'UserModel(id: ${_this.id}, email: ${_this.email}, fullName: ${_this.fullName}, role: ${_this.role}, phone: ${_this.phone}, avatarUrl: ${_this.avatarUrl}, isActive: ${_this.isActive}, isPlatformAdmin: ${_this.isPlatformAdmin}, lastLoginAt: ${_this.lastLoginAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, farm: ${_this.farm})';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 int id, String email,@JsonKey(name: 'full_name') String fullName, String role, String? phone,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_platform_admin') bool isPlatformAdmin,@JsonKey(name: 'last_login_at')@NullableDateTimeConverter() DateTime? lastLoginAt,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt,@JsonKey(name: 'updated_at')@DateTimeConverter() DateTime updatedAt, FarmRef? farm
});


$FarmRefCopyWith<$Res>? get farm;

}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? fullName = null,Object? role = null,Object? phone = freezed,Object? avatarUrl = freezed,Object? isActive = null,Object? isPlatformAdmin = null,Object? lastLoginAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? farm = freezed,}) {
  return _then(UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isPlatformAdmin: null == isPlatformAdmin ? _self.isPlatformAdmin : isPlatformAdmin // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,farm: freezed == farm ? _self.farm : farm // ignore: cast_nullable_to_non_nullable
as FarmRef?,
  ));
}
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FarmRefCopyWith<$Res>? get farm {
    if (_self.farm == null) {
    return null;
  }

  return $FarmRefCopyWith<$Res>(_self.farm!, (value) {
    return _then(_self.copyWith(farm: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String email, @JsonKey(name: 'full_name')  String fullName,  String role,  String? phone, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_platform_admin')  bool isPlatformAdmin, @JsonKey(name: 'last_login_at')@NullableDateTimeConverter()  DateTime? lastLoginAt, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateTimeConverter()  DateTime updatedAt,  FarmRef? farm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.role,_that.phone,_that.avatarUrl,_that.isActive,_that.isPlatformAdmin,_that.lastLoginAt,_that.createdAt,_that.updatedAt,_that.farm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String email, @JsonKey(name: 'full_name')  String fullName,  String role,  String? phone, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_platform_admin')  bool isPlatformAdmin, @JsonKey(name: 'last_login_at')@NullableDateTimeConverter()  DateTime? lastLoginAt, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateTimeConverter()  DateTime updatedAt,  FarmRef? farm)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.email,_that.fullName,_that.role,_that.phone,_that.avatarUrl,_that.isActive,_that.isPlatformAdmin,_that.lastLoginAt,_that.createdAt,_that.updatedAt,_that.farm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String email, @JsonKey(name: 'full_name')  String fullName,  String role,  String? phone, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_platform_admin')  bool isPlatformAdmin, @JsonKey(name: 'last_login_at')@NullableDateTimeConverter()  DateTime? lastLoginAt, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateTimeConverter()  DateTime updatedAt,  FarmRef? farm)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.role,_that.phone,_that.avatarUrl,_that.isActive,_that.isPlatformAdmin,_that.lastLoginAt,_that.createdAt,_that.updatedAt,_that.farm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.email, @JsonKey(name: 'full_name') required this.fullName, required this.role, this.phone, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'is_active') required this.isActive, @JsonKey(name: 'is_platform_admin') this.isPlatformAdmin = false, @JsonKey(name: 'last_login_at')@NullableDateTimeConverter() this.lastLoginAt, @JsonKey(name: 'created_at')@DateTimeConverter() required this.createdAt, @JsonKey(name: 'updated_at')@DateTimeConverter() required this.updatedAt, this.farm});
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  int id;
@override final  String email;
@override@JsonKey(name: 'full_name') final  String fullName;
@override final  String role;
@override final  String? phone;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'is_platform_admin') final  bool isPlatformAdmin;
@override@JsonKey(name: 'last_login_at')@NullableDateTimeConverter() final  DateTime? lastLoginAt;
@override@JsonKey(name: 'created_at')@DateTimeConverter() final  DateTime createdAt;
@override@JsonKey(name: 'updated_at')@DateTimeConverter() final  DateTime updatedAt;
@override final  FarmRef? farm;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.role, role) || other.role == role)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isPlatformAdmin, isPlatformAdmin) || other.isPlatformAdmin == isPlatformAdmin)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.farm, farm) || other.farm == farm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,email,fullName,role,phone,avatarUrl,isActive,isPlatformAdmin,lastLoginAt,createdAt,updatedAt,farm);
}

@override
String toString() {
    return 'UserModel(id: $id, email: $email, fullName: $fullName, role: $role, phone: $phone, avatarUrl: $avatarUrl, isActive: $isActive, isPlatformAdmin: $isPlatformAdmin, lastLoginAt: $lastLoginAt, createdAt: $createdAt, updatedAt: $updatedAt, farm: $farm)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String email,@JsonKey(name: 'full_name') String fullName, String role, String? phone,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_platform_admin') bool isPlatformAdmin,@JsonKey(name: 'last_login_at')@NullableDateTimeConverter() DateTime? lastLoginAt,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt,@JsonKey(name: 'updated_at')@DateTimeConverter() DateTime updatedAt, FarmRef? farm
});


@override $FarmRefCopyWith<$Res>? get farm;

}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? fullName = null,Object? role = null,Object? phone = freezed,Object? avatarUrl = freezed,Object? isActive = null,Object? isPlatformAdmin = null,Object? lastLoginAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? farm = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isPlatformAdmin: null == isPlatformAdmin ? _self.isPlatformAdmin : isPlatformAdmin // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,farm: freezed == farm ? _self.farm : farm // ignore: cast_nullable_to_non_nullable
as FarmRef?,
  ));
}

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FarmRefCopyWith<$Res>? get farm {
    if (_self.farm == null) {
    return null;
  }

  return $FarmRefCopyWith<$Res>(_self.farm!, (value) {
    return _then(_self.copyWith(farm: value));
  });
}
}

// dart format on
