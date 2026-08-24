// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserRef _$UserRefFromJson(Map<String, dynamic> json) {
  return _UserRef.fromJson(json);
}

/// @nodoc
mixin _$UserRef {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  /// Serializes this UserRef to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRefCopyWith<UserRef> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRefCopyWith<$Res> {
  factory $UserRefCopyWith(UserRef value, $Res Function(UserRef) then) =
      _$UserRefCopyWithImpl<$Res, UserRef>;
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'full_name') String fullName,
    String? email,
  });
}

/// @nodoc
class _$UserRefCopyWithImpl<$Res, $Val extends UserRef>
    implements $UserRefCopyWith<$Res> {
  _$UserRefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserRefImplCopyWith<$Res> implements $UserRefCopyWith<$Res> {
  factory _$$UserRefImplCopyWith(
    _$UserRefImpl value,
    $Res Function(_$UserRefImpl) then,
  ) = __$$UserRefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'full_name') String fullName,
    String? email,
  });
}

/// @nodoc
class __$$UserRefImplCopyWithImpl<$Res>
    extends _$UserRefCopyWithImpl<$Res, _$UserRefImpl>
    implements _$$UserRefImplCopyWith<$Res> {
  __$$UserRefImplCopyWithImpl(
    _$UserRefImpl _value,
    $Res Function(_$UserRefImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = freezed,
  }) {
    return _then(
      _$UserRefImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRefImpl implements _UserRef {
  const _$UserRefImpl({
    @IntConverter() required this.id,
    @JsonKey(name: 'full_name') required this.fullName,
    this.email,
  });

  factory _$UserRefImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRefImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String? email;

  @override
  String toString() {
    return 'UserRef(id: $id, fullName: $fullName, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRefImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, fullName, email);

  /// Create a copy of UserRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRefImplCopyWith<_$UserRefImpl> get copyWith =>
      __$$UserRefImplCopyWithImpl<_$UserRefImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRefImplToJson(this);
  }
}

abstract class _UserRef implements UserRef {
  const factory _UserRef({
    @IntConverter() required final int id,
    @JsonKey(name: 'full_name') required final String fullName,
    final String? email,
  }) = _$UserRefImpl;

  factory _UserRef.fromJson(Map<String, dynamic> json) = _$UserRefImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  String? get email;

  /// Create a copy of UserRef
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRefImplCopyWith<_$UserRefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
