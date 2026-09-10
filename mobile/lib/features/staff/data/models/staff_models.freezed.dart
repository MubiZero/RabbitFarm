// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FarmMember {

@IntConverter() int get id; String get email;@JsonKey(name: 'full_name') String get fullName; String? get phone; FarmRole get role;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of FarmMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmMemberCopyWith<FarmMember> get copyWith => _$FarmMemberCopyWithImpl<FarmMember>(this as FarmMember, _$identity);

  /// Serializes this FarmMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FarmMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmMember&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FarmMember;
  return Object.hash(runtimeType,_this.id,_this.email,_this.fullName,_this.phone,_this.role,_this.isActive);
}

@override
String toString() {
  final _this = this as FarmMember;
  return 'FarmMember(id: ${_this.id}, email: ${_this.email}, fullName: ${_this.fullName}, phone: ${_this.phone}, role: ${_this.role}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $FarmMemberCopyWith<$Res>  {
  factory $FarmMemberCopyWith(FarmMember value, $Res Function(FarmMember) _then) = _$FarmMemberCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String email,@JsonKey(name: 'full_name') String fullName, String? phone, FarmRole role,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$FarmMemberCopyWithImpl<$Res>
    implements $FarmMemberCopyWith<$Res> {
  _$FarmMemberCopyWithImpl(this._self, this._then);

  final FarmMember _self;
  final $Res Function(FarmMember) _then;

/// Create a copy of FarmMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? fullName = null,Object? phone = freezed,Object? role = null,Object? isActive = null,}) {
  return _then(FarmMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FarmRole,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FarmMember].
extension FarmMemberPatterns on FarmMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmMember value)  $default,){
final _that = this;
switch (_that) {
case _FarmMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmMember value)?  $default,){
final _that = this;
switch (_that) {
case _FarmMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String email, @JsonKey(name: 'full_name')  String fullName,  String? phone,  FarmRole role, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmMember() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.phone,_that.role,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String email, @JsonKey(name: 'full_name')  String fullName,  String? phone,  FarmRole role, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _FarmMember():
return $default(_that.id,_that.email,_that.fullName,_that.phone,_that.role,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String email, @JsonKey(name: 'full_name')  String fullName,  String? phone,  FarmRole role, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _FarmMember() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.phone,_that.role,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FarmMember extends FarmMember {
  const _FarmMember({@IntConverter() required this.id, required this.email, @JsonKey(name: 'full_name') required this.fullName, this.phone, required this.role, @JsonKey(name: 'is_active') this.isActive = true}): super._();
  factory _FarmMember.fromJson(Map<String, dynamic> json) => _$FarmMemberFromJson(json);

@override@IntConverter() final  int id;
@override final  String email;
@override@JsonKey(name: 'full_name') final  String fullName;
@override final  String? phone;
@override final  FarmRole role;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of FarmMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmMemberCopyWith<_FarmMember> get copyWith => __$FarmMemberCopyWithImpl<_FarmMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmMemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmMember&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,email,fullName,phone,role,isActive);
}

@override
String toString() {
    return 'FarmMember(id: $id, email: $email, fullName: $fullName, phone: $phone, role: $role, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$FarmMemberCopyWith<$Res> implements $FarmMemberCopyWith<$Res> {
  factory _$FarmMemberCopyWith(_FarmMember value, $Res Function(_FarmMember) _then) = __$FarmMemberCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String email,@JsonKey(name: 'full_name') String fullName, String? phone, FarmRole role,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$FarmMemberCopyWithImpl<$Res>
    implements _$FarmMemberCopyWith<$Res> {
  __$FarmMemberCopyWithImpl(this._self, this._then);

  final _FarmMember _self;
  final $Res Function(_FarmMember) _then;

/// Create a copy of FarmMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? fullName = null,Object? phone = freezed,Object? role = null,Object? isActive = null,}) {
  return _then(_FarmMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FarmRole,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$FarmInvitation {

@IntConverter() int get id; String? get email; String? get phone;@JsonKey(name: 'full_name') String? get fullName; FarmRole get role;@JsonKey(name: 'expires_at')@DateTimeConverter() DateTime get expiresAt;
/// Create a copy of FarmInvitation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmInvitationCopyWith<FarmInvitation> get copyWith => _$FarmInvitationCopyWithImpl<FarmInvitation>(this as FarmInvitation, _$identity);

  /// Serializes this FarmInvitation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FarmInvitation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmInvitation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FarmInvitation;
  return Object.hash(runtimeType,_this.id,_this.email,_this.phone,_this.fullName,_this.role,_this.expiresAt);
}

@override
String toString() {
  final _this = this as FarmInvitation;
  return 'FarmInvitation(id: ${_this.id}, email: ${_this.email}, phone: ${_this.phone}, fullName: ${_this.fullName}, role: ${_this.role}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $FarmInvitationCopyWith<$Res>  {
  factory $FarmInvitationCopyWith(FarmInvitation value, $Res Function(FarmInvitation) _then) = _$FarmInvitationCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String? email, String? phone,@JsonKey(name: 'full_name') String? fullName, FarmRole role,@JsonKey(name: 'expires_at')@DateTimeConverter() DateTime expiresAt
});




}
/// @nodoc
class _$FarmInvitationCopyWithImpl<$Res>
    implements $FarmInvitationCopyWith<$Res> {
  _$FarmInvitationCopyWithImpl(this._self, this._then);

  final FarmInvitation _self;
  final $Res Function(FarmInvitation) _then;

/// Create a copy of FarmInvitation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = freezed,Object? phone = freezed,Object? fullName = freezed,Object? role = null,Object? expiresAt = null,}) {
  return _then(FarmInvitation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FarmRole,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FarmInvitation].
extension FarmInvitationPatterns on FarmInvitation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmInvitation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmInvitation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmInvitation value)  $default,){
final _that = this;
switch (_that) {
case _FarmInvitation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmInvitation value)?  $default,){
final _that = this;
switch (_that) {
case _FarmInvitation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String? email,  String? phone, @JsonKey(name: 'full_name')  String? fullName,  FarmRole role, @JsonKey(name: 'expires_at')@DateTimeConverter()  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmInvitation() when $default != null:
return $default(_that.id,_that.email,_that.phone,_that.fullName,_that.role,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String? email,  String? phone, @JsonKey(name: 'full_name')  String? fullName,  FarmRole role, @JsonKey(name: 'expires_at')@DateTimeConverter()  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _FarmInvitation():
return $default(_that.id,_that.email,_that.phone,_that.fullName,_that.role,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String? email,  String? phone, @JsonKey(name: 'full_name')  String? fullName,  FarmRole role, @JsonKey(name: 'expires_at')@DateTimeConverter()  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _FarmInvitation() when $default != null:
return $default(_that.id,_that.email,_that.phone,_that.fullName,_that.role,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FarmInvitation extends FarmInvitation {
  const _FarmInvitation({@IntConverter() required this.id, this.email, this.phone, @JsonKey(name: 'full_name') this.fullName, required this.role, @JsonKey(name: 'expires_at')@DateTimeConverter() required this.expiresAt}): super._();
  factory _FarmInvitation.fromJson(Map<String, dynamic> json) => _$FarmInvitationFromJson(json);

@override@IntConverter() final  int id;
@override final  String? email;
@override final  String? phone;
@override@JsonKey(name: 'full_name') final  String? fullName;
@override final  FarmRole role;
@override@JsonKey(name: 'expires_at')@DateTimeConverter() final  DateTime expiresAt;

/// Create a copy of FarmInvitation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmInvitationCopyWith<_FarmInvitation> get copyWith => __$FarmInvitationCopyWithImpl<_FarmInvitation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmInvitationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmInvitation&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.role, role) || other.role == role)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,email,phone,fullName,role,expiresAt);
}

@override
String toString() {
    return 'FarmInvitation(id: $id, email: $email, phone: $phone, fullName: $fullName, role: $role, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$FarmInvitationCopyWith<$Res> implements $FarmInvitationCopyWith<$Res> {
  factory _$FarmInvitationCopyWith(_FarmInvitation value, $Res Function(_FarmInvitation) _then) = __$FarmInvitationCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String? email, String? phone,@JsonKey(name: 'full_name') String? fullName, FarmRole role,@JsonKey(name: 'expires_at')@DateTimeConverter() DateTime expiresAt
});




}
/// @nodoc
class __$FarmInvitationCopyWithImpl<$Res>
    implements _$FarmInvitationCopyWith<$Res> {
  __$FarmInvitationCopyWithImpl(this._self, this._then);

  final _FarmInvitation _self;
  final $Res Function(_FarmInvitation) _then;

/// Create a copy of FarmInvitation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = freezed,Object? phone = freezed,Object? fullName = freezed,Object? role = null,Object? expiresAt = null,}) {
  return _then(_FarmInvitation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FarmRole,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CreatedInvitation {

@IntConverter() int get id; String? get email; String? get phone; FarmRole get role; String get code;@JsonKey(name: 'expires_at')@DateTimeConverter() DateTime get expiresAt;
/// Create a copy of CreatedInvitation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatedInvitationCopyWith<CreatedInvitation> get copyWith => _$CreatedInvitationCopyWithImpl<CreatedInvitation>(this as CreatedInvitation, _$identity);

  /// Serializes this CreatedInvitation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreatedInvitation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatedInvitation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreatedInvitation;
  return Object.hash(runtimeType,_this.id,_this.email,_this.phone,_this.role,_this.code,_this.expiresAt);
}

@override
String toString() {
  final _this = this as CreatedInvitation;
  return 'CreatedInvitation(id: ${_this.id}, email: ${_this.email}, phone: ${_this.phone}, role: ${_this.role}, code: ${_this.code}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $CreatedInvitationCopyWith<$Res>  {
  factory $CreatedInvitationCopyWith(CreatedInvitation value, $Res Function(CreatedInvitation) _then) = _$CreatedInvitationCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String? email, String? phone, FarmRole role, String code,@JsonKey(name: 'expires_at')@DateTimeConverter() DateTime expiresAt
});




}
/// @nodoc
class _$CreatedInvitationCopyWithImpl<$Res>
    implements $CreatedInvitationCopyWith<$Res> {
  _$CreatedInvitationCopyWithImpl(this._self, this._then);

  final CreatedInvitation _self;
  final $Res Function(CreatedInvitation) _then;

/// Create a copy of CreatedInvitation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = freezed,Object? phone = freezed,Object? role = null,Object? code = null,Object? expiresAt = null,}) {
  return _then(CreatedInvitation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FarmRole,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatedInvitation].
extension CreatedInvitationPatterns on CreatedInvitation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatedInvitation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatedInvitation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatedInvitation value)  $default,){
final _that = this;
switch (_that) {
case _CreatedInvitation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatedInvitation value)?  $default,){
final _that = this;
switch (_that) {
case _CreatedInvitation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String? email,  String? phone,  FarmRole role,  String code, @JsonKey(name: 'expires_at')@DateTimeConverter()  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatedInvitation() when $default != null:
return $default(_that.id,_that.email,_that.phone,_that.role,_that.code,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String? email,  String? phone,  FarmRole role,  String code, @JsonKey(name: 'expires_at')@DateTimeConverter()  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _CreatedInvitation():
return $default(_that.id,_that.email,_that.phone,_that.role,_that.code,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String? email,  String? phone,  FarmRole role,  String code, @JsonKey(name: 'expires_at')@DateTimeConverter()  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _CreatedInvitation() when $default != null:
return $default(_that.id,_that.email,_that.phone,_that.role,_that.code,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatedInvitation extends CreatedInvitation {
  const _CreatedInvitation({@IntConverter() required this.id, this.email, this.phone, required this.role, required this.code, @JsonKey(name: 'expires_at')@DateTimeConverter() required this.expiresAt}): super._();
  factory _CreatedInvitation.fromJson(Map<String, dynamic> json) => _$CreatedInvitationFromJson(json);

@override@IntConverter() final  int id;
@override final  String? email;
@override final  String? phone;
@override final  FarmRole role;
@override final  String code;
@override@JsonKey(name: 'expires_at')@DateTimeConverter() final  DateTime expiresAt;

/// Create a copy of CreatedInvitation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedInvitationCopyWith<_CreatedInvitation> get copyWith => __$CreatedInvitationCopyWithImpl<_CreatedInvitation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatedInvitationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatedInvitation&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.code, code) || other.code == code)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,email,phone,role,code,expiresAt);
}

@override
String toString() {
    return 'CreatedInvitation(id: $id, email: $email, phone: $phone, role: $role, code: $code, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$CreatedInvitationCopyWith<$Res> implements $CreatedInvitationCopyWith<$Res> {
  factory _$CreatedInvitationCopyWith(_CreatedInvitation value, $Res Function(_CreatedInvitation) _then) = __$CreatedInvitationCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String? email, String? phone, FarmRole role, String code,@JsonKey(name: 'expires_at')@DateTimeConverter() DateTime expiresAt
});




}
/// @nodoc
class __$CreatedInvitationCopyWithImpl<$Res>
    implements _$CreatedInvitationCopyWith<$Res> {
  __$CreatedInvitationCopyWithImpl(this._self, this._then);

  final _CreatedInvitation _self;
  final $Res Function(_CreatedInvitation) _then;

/// Create a copy of CreatedInvitation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = freezed,Object? phone = freezed,Object? role = null,Object? code = null,Object? expiresAt = null,}) {
  return _then(_CreatedInvitation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FarmRole,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
