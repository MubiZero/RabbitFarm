// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRef {

@IntConverter() int get id;@JsonKey(name: 'full_name') String get fullName; String? get email; String? get phone;
/// Create a copy of UserRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRefCopyWith<UserRef> get copyWith => _$UserRefCopyWithImpl<UserRef>(this as UserRef, _$identity);

  /// Serializes this UserRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserRef;
  return Object.hash(runtimeType,_this.id,_this.fullName,_this.email,_this.phone);
}

@override
String toString() {
  final _this = this as UserRef;
  return 'UserRef(id: ${_this.id}, fullName: ${_this.fullName}, email: ${_this.email}, phone: ${_this.phone})';
}


}

/// @nodoc
abstract mixin class $UserRefCopyWith<$Res>  {
  factory $UserRefCopyWith(UserRef value, $Res Function(UserRef) _then) = _$UserRefCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'full_name') String fullName, String? email, String? phone
});




}
/// @nodoc
class _$UserRefCopyWithImpl<$Res>
    implements $UserRefCopyWith<$Res> {
  _$UserRefCopyWithImpl(this._self, this._then);

  final UserRef _self;
  final $Res Function(UserRef) _then;

/// Create a copy of UserRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? email = freezed,Object? phone = freezed,}) {
  return _then(UserRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserRef].
extension UserRefPatterns on UserRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRef value)  $default,){
final _that = this;
switch (_that) {
case _UserRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRef value)?  $default,){
final _that = this;
switch (_that) {
case _UserRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'full_name')  String fullName,  String? email,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRef() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'full_name')  String fullName,  String? email,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _UserRef():
return $default(_that.id,_that.fullName,_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id, @JsonKey(name: 'full_name')  String fullName,  String? email,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _UserRef() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserRef implements UserRef {
  const _UserRef({@IntConverter() required this.id, @JsonKey(name: 'full_name') required this.fullName, this.email, this.phone});
  factory _UserRef.fromJson(Map<String, dynamic> json) => _$UserRefFromJson(json);

@override@IntConverter() final  int id;
@override@JsonKey(name: 'full_name') final  String fullName;
@override final  String? email;
@override final  String? phone;

/// Create a copy of UserRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRefCopyWith<_UserRef> get copyWith => __$UserRefCopyWithImpl<_UserRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRef&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,email,phone);
}

@override
String toString() {
    return 'UserRef(id: $id, fullName: $fullName, email: $email, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$UserRefCopyWith<$Res> implements $UserRefCopyWith<$Res> {
  factory _$UserRefCopyWith(_UserRef value, $Res Function(_UserRef) _then) = __$UserRefCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'full_name') String fullName, String? email, String? phone
});




}
/// @nodoc
class __$UserRefCopyWithImpl<$Res>
    implements _$UserRefCopyWith<$Res> {
  __$UserRefCopyWithImpl(this._self, this._then);

  final _UserRef _self;
  final $Res Function(_UserRef) _then;

/// Create a copy of UserRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? email = freezed,Object? phone = freezed,}) {
  return _then(_UserRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
