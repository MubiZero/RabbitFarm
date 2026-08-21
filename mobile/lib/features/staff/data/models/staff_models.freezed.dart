// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FarmMember _$FarmMemberFromJson(Map<String, dynamic> json) {
  return _FarmMember.fromJson(json);
}

/// @nodoc
mixin _$FarmMember {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  FarmRole get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  @NullableIntConverter()
  int? get ownerId => throw _privateConstructorUsedError;

  /// Serializes this FarmMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FarmMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmMemberCopyWith<FarmMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmMemberCopyWith<$Res> {
  factory $FarmMemberCopyWith(
    FarmMember value,
    $Res Function(FarmMember) then,
  ) = _$FarmMemberCopyWithImpl<$Res, FarmMember>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String email,
    @JsonKey(name: 'full_name') String fullName,
    String? phone,
    FarmRole role,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'owner_id') @NullableIntConverter() int? ownerId,
  });
}

/// @nodoc
class _$FarmMemberCopyWithImpl<$Res, $Val extends FarmMember>
    implements $FarmMemberCopyWith<$Res> {
  _$FarmMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FarmMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = null,
    Object? phone = freezed,
    Object? role = null,
    Object? isActive = null,
    Object? ownerId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as FarmRole,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            ownerId: freezed == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FarmMemberImplCopyWith<$Res>
    implements $FarmMemberCopyWith<$Res> {
  factory _$$FarmMemberImplCopyWith(
    _$FarmMemberImpl value,
    $Res Function(_$FarmMemberImpl) then,
  ) = __$$FarmMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String email,
    @JsonKey(name: 'full_name') String fullName,
    String? phone,
    FarmRole role,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'owner_id') @NullableIntConverter() int? ownerId,
  });
}

/// @nodoc
class __$$FarmMemberImplCopyWithImpl<$Res>
    extends _$FarmMemberCopyWithImpl<$Res, _$FarmMemberImpl>
    implements _$$FarmMemberImplCopyWith<$Res> {
  __$$FarmMemberImplCopyWithImpl(
    _$FarmMemberImpl _value,
    $Res Function(_$FarmMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FarmMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = null,
    Object? phone = freezed,
    Object? role = null,
    Object? isActive = null,
    Object? ownerId = freezed,
  }) {
    return _then(
      _$FarmMemberImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as FarmRole,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FarmMemberImpl extends _FarmMember {
  const _$FarmMemberImpl({
    @IntConverter() required this.id,
    required this.email,
    @JsonKey(name: 'full_name') required this.fullName,
    this.phone,
    required this.role,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'owner_id') @NullableIntConverter() this.ownerId,
  }) : super._();

  factory _$FarmMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$FarmMemberImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String email;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String? phone;
  @override
  final FarmRole role;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'owner_id')
  @NullableIntConverter()
  final int? ownerId;

  @override
  String toString() {
    return 'FarmMember(id: $id, email: $email, fullName: $fullName, phone: $phone, role: $role, isActive: $isActive, ownerId: $ownerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    fullName,
    phone,
    role,
    isActive,
    ownerId,
  );

  /// Create a copy of FarmMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmMemberImplCopyWith<_$FarmMemberImpl> get copyWith =>
      __$$FarmMemberImplCopyWithImpl<_$FarmMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FarmMemberImplToJson(this);
  }
}

abstract class _FarmMember extends FarmMember {
  const factory _FarmMember({
    @IntConverter() required final int id,
    required final String email,
    @JsonKey(name: 'full_name') required final String fullName,
    final String? phone,
    required final FarmRole role,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'owner_id') @NullableIntConverter() final int? ownerId,
  }) = _$FarmMemberImpl;
  const _FarmMember._() : super._();

  factory _FarmMember.fromJson(Map<String, dynamic> json) =
      _$FarmMemberImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get email;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  String? get phone;
  @override
  FarmRole get role;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'owner_id')
  @NullableIntConverter()
  int? get ownerId;

  /// Create a copy of FarmMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmMemberImplCopyWith<_$FarmMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FarmInvitation _$FarmInvitationFromJson(Map<String, dynamic> json) {
  return _FarmInvitation.fromJson(json);
}

/// @nodoc
mixin _$FarmInvitation {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  FarmRole get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this FarmInvitation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FarmInvitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmInvitationCopyWith<FarmInvitation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmInvitationCopyWith<$Res> {
  factory $FarmInvitationCopyWith(
    FarmInvitation value,
    $Res Function(FarmInvitation) then,
  ) = _$FarmInvitationCopyWithImpl<$Res, FarmInvitation>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String email,
    FarmRole role,
    @JsonKey(name: 'expires_at') DateTime expiresAt,
  });
}

/// @nodoc
class _$FarmInvitationCopyWithImpl<$Res, $Val extends FarmInvitation>
    implements $FarmInvitationCopyWith<$Res> {
  _$FarmInvitationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FarmInvitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? role = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as FarmRole,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FarmInvitationImplCopyWith<$Res>
    implements $FarmInvitationCopyWith<$Res> {
  factory _$$FarmInvitationImplCopyWith(
    _$FarmInvitationImpl value,
    $Res Function(_$FarmInvitationImpl) then,
  ) = __$$FarmInvitationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String email,
    FarmRole role,
    @JsonKey(name: 'expires_at') DateTime expiresAt,
  });
}

/// @nodoc
class __$$FarmInvitationImplCopyWithImpl<$Res>
    extends _$FarmInvitationCopyWithImpl<$Res, _$FarmInvitationImpl>
    implements _$$FarmInvitationImplCopyWith<$Res> {
  __$$FarmInvitationImplCopyWithImpl(
    _$FarmInvitationImpl _value,
    $Res Function(_$FarmInvitationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FarmInvitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? role = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _$FarmInvitationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as FarmRole,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FarmInvitationImpl implements _FarmInvitation {
  const _$FarmInvitationImpl({
    @IntConverter() required this.id,
    required this.email,
    required this.role,
    @JsonKey(name: 'expires_at') required this.expiresAt,
  });

  factory _$FarmInvitationImpl.fromJson(Map<String, dynamic> json) =>
      _$$FarmInvitationImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String email;
  @override
  final FarmRole role;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;

  @override
  String toString() {
    return 'FarmInvitation(id: $id, email: $email, role: $role, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmInvitationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, role, expiresAt);

  /// Create a copy of FarmInvitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmInvitationImplCopyWith<_$FarmInvitationImpl> get copyWith =>
      __$$FarmInvitationImplCopyWithImpl<_$FarmInvitationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FarmInvitationImplToJson(this);
  }
}

abstract class _FarmInvitation implements FarmInvitation {
  const factory _FarmInvitation({
    @IntConverter() required final int id,
    required final String email,
    required final FarmRole role,
    @JsonKey(name: 'expires_at') required final DateTime expiresAt,
  }) = _$FarmInvitationImpl;

  factory _FarmInvitation.fromJson(Map<String, dynamic> json) =
      _$FarmInvitationImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get email;
  @override
  FarmRole get role;
  @override
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt;

  /// Create a copy of FarmInvitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmInvitationImplCopyWith<_$FarmInvitationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatedInvitation _$CreatedInvitationFromJson(Map<String, dynamic> json) {
  return _CreatedInvitation.fromJson(json);
}

/// @nodoc
mixin _$CreatedInvitation {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  FarmRole get role => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this CreatedInvitation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatedInvitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatedInvitationCopyWith<CreatedInvitation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatedInvitationCopyWith<$Res> {
  factory $CreatedInvitationCopyWith(
    CreatedInvitation value,
    $Res Function(CreatedInvitation) then,
  ) = _$CreatedInvitationCopyWithImpl<$Res, CreatedInvitation>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String email,
    FarmRole role,
    String code,
    @JsonKey(name: 'expires_at') DateTime expiresAt,
  });
}

/// @nodoc
class _$CreatedInvitationCopyWithImpl<$Res, $Val extends CreatedInvitation>
    implements $CreatedInvitationCopyWith<$Res> {
  _$CreatedInvitationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatedInvitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? role = null,
    Object? code = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as FarmRole,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreatedInvitationImplCopyWith<$Res>
    implements $CreatedInvitationCopyWith<$Res> {
  factory _$$CreatedInvitationImplCopyWith(
    _$CreatedInvitationImpl value,
    $Res Function(_$CreatedInvitationImpl) then,
  ) = __$$CreatedInvitationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String email,
    FarmRole role,
    String code,
    @JsonKey(name: 'expires_at') DateTime expiresAt,
  });
}

/// @nodoc
class __$$CreatedInvitationImplCopyWithImpl<$Res>
    extends _$CreatedInvitationCopyWithImpl<$Res, _$CreatedInvitationImpl>
    implements _$$CreatedInvitationImplCopyWith<$Res> {
  __$$CreatedInvitationImplCopyWithImpl(
    _$CreatedInvitationImpl _value,
    $Res Function(_$CreatedInvitationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreatedInvitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? role = null,
    Object? code = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _$CreatedInvitationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as FarmRole,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatedInvitationImpl implements _CreatedInvitation {
  const _$CreatedInvitationImpl({
    @IntConverter() required this.id,
    required this.email,
    required this.role,
    required this.code,
    @JsonKey(name: 'expires_at') required this.expiresAt,
  });

  factory _$CreatedInvitationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatedInvitationImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String email;
  @override
  final FarmRole role;
  @override
  final String code;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;

  @override
  String toString() {
    return 'CreatedInvitation(id: $id, email: $email, role: $role, code: $code, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatedInvitationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, email, role, code, expiresAt);

  /// Create a copy of CreatedInvitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatedInvitationImplCopyWith<_$CreatedInvitationImpl> get copyWith =>
      __$$CreatedInvitationImplCopyWithImpl<_$CreatedInvitationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatedInvitationImplToJson(this);
  }
}

abstract class _CreatedInvitation implements CreatedInvitation {
  const factory _CreatedInvitation({
    @IntConverter() required final int id,
    required final String email,
    required final FarmRole role,
    required final String code,
    @JsonKey(name: 'expires_at') required final DateTime expiresAt,
  }) = _$CreatedInvitationImpl;

  factory _CreatedInvitation.fromJson(Map<String, dynamic> json) =
      _$CreatedInvitationImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get email;
  @override
  FarmRole get role;
  @override
  String get code;
  @override
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt;

  /// Create a copy of CreatedInvitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatedInvitationImplCopyWith<_$CreatedInvitationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
