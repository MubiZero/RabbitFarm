// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_admin_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Plan _$PlanFromJson(Map<String, dynamic> json) {
  return _Plan.fromJson(json);
}

/// @nodoc
mixin _$Plan {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_rabbits')
  @NullableIntConverter()
  int? get maxRabbits => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_staff')
  @NullableIntConverter()
  int? get maxStaff => throw _privateConstructorUsedError;
  @DoubleConverter()
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this Plan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanCopyWith<Plan> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanCopyWith<$Res> {
  factory $PlanCopyWith(Plan value, $Res Function(Plan) then) =
      _$PlanCopyWithImpl<$Res, Plan>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String name,
    @JsonKey(name: 'max_rabbits') @NullableIntConverter() int? maxRabbits,
    @JsonKey(name: 'max_staff') @NullableIntConverter() int? maxStaff,
    @DoubleConverter() double? price,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'is_default') bool isDefault,
  });
}

/// @nodoc
class _$PlanCopyWithImpl<$Res, $Val extends Plan>
    implements $PlanCopyWith<$Res> {
  _$PlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? maxRabbits = freezed,
    Object? maxStaff = freezed,
    Object? price = freezed,
    Object? isActive = null,
    Object? isDefault = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            maxRabbits: freezed == maxRabbits
                ? _value.maxRabbits
                : maxRabbits // ignore: cast_nullable_to_non_nullable
                      as int?,
            maxStaff: freezed == maxStaff
                ? _value.maxStaff
                : maxStaff // ignore: cast_nullable_to_non_nullable
                      as int?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlanImplCopyWith<$Res> implements $PlanCopyWith<$Res> {
  factory _$$PlanImplCopyWith(
    _$PlanImpl value,
    $Res Function(_$PlanImpl) then,
  ) = __$$PlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String name,
    @JsonKey(name: 'max_rabbits') @NullableIntConverter() int? maxRabbits,
    @JsonKey(name: 'max_staff') @NullableIntConverter() int? maxStaff,
    @DoubleConverter() double? price,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'is_default') bool isDefault,
  });
}

/// @nodoc
class __$$PlanImplCopyWithImpl<$Res>
    extends _$PlanCopyWithImpl<$Res, _$PlanImpl>
    implements _$$PlanImplCopyWith<$Res> {
  __$$PlanImplCopyWithImpl(_$PlanImpl _value, $Res Function(_$PlanImpl) _then)
    : super(_value, _then);

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? maxRabbits = freezed,
    Object? maxStaff = freezed,
    Object? price = freezed,
    Object? isActive = null,
    Object? isDefault = null,
  }) {
    return _then(
      _$PlanImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        maxRabbits: freezed == maxRabbits
            ? _value.maxRabbits
            : maxRabbits // ignore: cast_nullable_to_non_nullable
                  as int?,
        maxStaff: freezed == maxStaff
            ? _value.maxStaff
            : maxStaff // ignore: cast_nullable_to_non_nullable
                  as int?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanImpl extends _Plan {
  const _$PlanImpl({
    @IntConverter() required this.id,
    required this.name,
    @JsonKey(name: 'max_rabbits') @NullableIntConverter() this.maxRabbits,
    @JsonKey(name: 'max_staff') @NullableIntConverter() this.maxStaff,
    @DoubleConverter() this.price,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'is_default') this.isDefault = false,
  }) : super._();

  factory _$PlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'max_rabbits')
  @NullableIntConverter()
  final int? maxRabbits;
  @override
  @JsonKey(name: 'max_staff')
  @NullableIntConverter()
  final int? maxStaff;
  @override
  @DoubleConverter()
  final double? price;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;

  @override
  String toString() {
    return 'Plan(id: $id, name: $name, maxRabbits: $maxRabbits, maxStaff: $maxStaff, price: $price, isActive: $isActive, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.maxRabbits, maxRabbits) ||
                other.maxRabbits == maxRabbits) &&
            (identical(other.maxStaff, maxStaff) ||
                other.maxStaff == maxStaff) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    maxRabbits,
    maxStaff,
    price,
    isActive,
    isDefault,
  );

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanImplCopyWith<_$PlanImpl> get copyWith =>
      __$$PlanImplCopyWithImpl<_$PlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanImplToJson(this);
  }
}

abstract class _Plan extends Plan {
  const factory _Plan({
    @IntConverter() required final int id,
    required final String name,
    @JsonKey(name: 'max_rabbits') @NullableIntConverter() final int? maxRabbits,
    @JsonKey(name: 'max_staff') @NullableIntConverter() final int? maxStaff,
    @DoubleConverter() final double? price,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'is_default') final bool isDefault,
  }) = _$PlanImpl;
  const _Plan._() : super._();

  factory _Plan.fromJson(Map<String, dynamic> json) = _$PlanImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'max_rabbits')
  @NullableIntConverter()
  int? get maxRabbits;
  @override
  @JsonKey(name: 'max_staff')
  @NullableIntConverter()
  int? get maxStaff;
  @override
  @DoubleConverter()
  double? get price;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanImplCopyWith<_$PlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlanDraft _$PlanDraftFromJson(Map<String, dynamic> json) {
  return _PlanDraft.fromJson(json);
}

/// @nodoc
mixin _$PlanDraft {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_rabbits')
  int? get maxRabbits => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_staff')
  int? get maxStaff => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this PlanDraft to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlanDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanDraftCopyWith<PlanDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanDraftCopyWith<$Res> {
  factory $PlanDraftCopyWith(PlanDraft value, $Res Function(PlanDraft) then) =
      _$PlanDraftCopyWithImpl<$Res, PlanDraft>;
  @useResult
  $Res call({
    String name,
    @JsonKey(name: 'max_rabbits') int? maxRabbits,
    @JsonKey(name: 'max_staff') int? maxStaff,
    double? price,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'is_default') bool isDefault,
  });
}

/// @nodoc
class _$PlanDraftCopyWithImpl<$Res, $Val extends PlanDraft>
    implements $PlanDraftCopyWith<$Res> {
  _$PlanDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlanDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? maxRabbits = freezed,
    Object? maxStaff = freezed,
    Object? price = freezed,
    Object? isActive = null,
    Object? isDefault = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            maxRabbits: freezed == maxRabbits
                ? _value.maxRabbits
                : maxRabbits // ignore: cast_nullable_to_non_nullable
                      as int?,
            maxStaff: freezed == maxStaff
                ? _value.maxStaff
                : maxStaff // ignore: cast_nullable_to_non_nullable
                      as int?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlanDraftImplCopyWith<$Res>
    implements $PlanDraftCopyWith<$Res> {
  factory _$$PlanDraftImplCopyWith(
    _$PlanDraftImpl value,
    $Res Function(_$PlanDraftImpl) then,
  ) = __$$PlanDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    @JsonKey(name: 'max_rabbits') int? maxRabbits,
    @JsonKey(name: 'max_staff') int? maxStaff,
    double? price,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'is_default') bool isDefault,
  });
}

/// @nodoc
class __$$PlanDraftImplCopyWithImpl<$Res>
    extends _$PlanDraftCopyWithImpl<$Res, _$PlanDraftImpl>
    implements _$$PlanDraftImplCopyWith<$Res> {
  __$$PlanDraftImplCopyWithImpl(
    _$PlanDraftImpl _value,
    $Res Function(_$PlanDraftImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlanDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? maxRabbits = freezed,
    Object? maxStaff = freezed,
    Object? price = freezed,
    Object? isActive = null,
    Object? isDefault = null,
  }) {
    return _then(
      _$PlanDraftImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        maxRabbits: freezed == maxRabbits
            ? _value.maxRabbits
            : maxRabbits // ignore: cast_nullable_to_non_nullable
                  as int?,
        maxStaff: freezed == maxStaff
            ? _value.maxStaff
            : maxStaff // ignore: cast_nullable_to_non_nullable
                  as int?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanDraftImpl implements _PlanDraft {
  const _$PlanDraftImpl({
    required this.name,
    @JsonKey(name: 'max_rabbits') this.maxRabbits,
    @JsonKey(name: 'max_staff') this.maxStaff,
    this.price,
    @JsonKey(name: 'is_active') required this.isActive,
    @JsonKey(name: 'is_default') this.isDefault = false,
  });

  factory _$PlanDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanDraftImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey(name: 'max_rabbits')
  final int? maxRabbits;
  @override
  @JsonKey(name: 'max_staff')
  final int? maxStaff;
  @override
  final double? price;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;

  @override
  String toString() {
    return 'PlanDraft(name: $name, maxRabbits: $maxRabbits, maxStaff: $maxStaff, price: $price, isActive: $isActive, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanDraftImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.maxRabbits, maxRabbits) ||
                other.maxRabbits == maxRabbits) &&
            (identical(other.maxStaff, maxStaff) ||
                other.maxStaff == maxStaff) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    maxRabbits,
    maxStaff,
    price,
    isActive,
    isDefault,
  );

  /// Create a copy of PlanDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanDraftImplCopyWith<_$PlanDraftImpl> get copyWith =>
      __$$PlanDraftImplCopyWithImpl<_$PlanDraftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanDraftImplToJson(this);
  }
}

abstract class _PlanDraft implements PlanDraft {
  const factory _PlanDraft({
    required final String name,
    @JsonKey(name: 'max_rabbits') final int? maxRabbits,
    @JsonKey(name: 'max_staff') final int? maxStaff,
    final double? price,
    @JsonKey(name: 'is_active') required final bool isActive,
    @JsonKey(name: 'is_default') final bool isDefault,
  }) = _$PlanDraftImpl;

  factory _PlanDraft.fromJson(Map<String, dynamic> json) =
      _$PlanDraftImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(name: 'max_rabbits')
  int? get maxRabbits;
  @override
  @JsonKey(name: 'max_staff')
  int? get maxStaff;
  @override
  double? get price;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;

  /// Create a copy of PlanDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanDraftImplCopyWith<_$PlanDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlatformFarm _$PlatformFarmFromJson(Map<String, dynamic> json) {
  return _PlatformFarm.fromJson(json);
}

/// @nodoc
mixin _$PlatformFarm {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  UserRef? get owner => throw _privateConstructorUsedError;
  Plan? get plan => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbits_count')
  @IntConverter()
  int get rabbitsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'staff_count')
  @IntConverter()
  int get staffCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError; // Последний вход кого-либо из фермы — `max(users.last_login_at)`. `null`
  // значит «никто ещё не заходил», а не «неизвестно»: разница важна для
  // фильтра «не заходили N дней».
  @JsonKey(name: 'last_active')
  @NullableDateTimeConverter()
  DateTime? get lastActiveAt => throw _privateConstructorUsedError;

  /// Serializes this PlatformFarm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlatformFarm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlatformFarmCopyWith<PlatformFarm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlatformFarmCopyWith<$Res> {
  factory $PlatformFarmCopyWith(
    PlatformFarm value,
    $Res Function(PlatformFarm) then,
  ) = _$PlatformFarmCopyWithImpl<$Res, PlatformFarm>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String name,
    UserRef? owner,
    Plan? plan,
    @JsonKey(name: 'rabbits_count') @IntConverter() int rabbitsCount,
    @JsonKey(name: 'staff_count') @IntConverter() int staffCount,
    @JsonKey(name: 'created_at') @DateTimeConverter() DateTime createdAt,
    @JsonKey(name: 'last_active')
    @NullableDateTimeConverter()
    DateTime? lastActiveAt,
  });

  $UserRefCopyWith<$Res>? get owner;
  $PlanCopyWith<$Res>? get plan;
}

/// @nodoc
class _$PlatformFarmCopyWithImpl<$Res, $Val extends PlatformFarm>
    implements $PlatformFarmCopyWith<$Res> {
  _$PlatformFarmCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlatformFarm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? owner = freezed,
    Object? plan = freezed,
    Object? rabbitsCount = null,
    Object? staffCount = null,
    Object? createdAt = null,
    Object? lastActiveAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            owner: freezed == owner
                ? _value.owner
                : owner // ignore: cast_nullable_to_non_nullable
                      as UserRef?,
            plan: freezed == plan
                ? _value.plan
                : plan // ignore: cast_nullable_to_non_nullable
                      as Plan?,
            rabbitsCount: null == rabbitsCount
                ? _value.rabbitsCount
                : rabbitsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            staffCount: null == staffCount
                ? _value.staffCount
                : staffCount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastActiveAt: freezed == lastActiveAt
                ? _value.lastActiveAt
                : lastActiveAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of PlatformFarm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserRefCopyWith<$Res>? get owner {
    if (_value.owner == null) {
      return null;
    }

    return $UserRefCopyWith<$Res>(_value.owner!, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }

  /// Create a copy of PlatformFarm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlanCopyWith<$Res>? get plan {
    if (_value.plan == null) {
      return null;
    }

    return $PlanCopyWith<$Res>(_value.plan!, (value) {
      return _then(_value.copyWith(plan: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlatformFarmImplCopyWith<$Res>
    implements $PlatformFarmCopyWith<$Res> {
  factory _$$PlatformFarmImplCopyWith(
    _$PlatformFarmImpl value,
    $Res Function(_$PlatformFarmImpl) then,
  ) = __$$PlatformFarmImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String name,
    UserRef? owner,
    Plan? plan,
    @JsonKey(name: 'rabbits_count') @IntConverter() int rabbitsCount,
    @JsonKey(name: 'staff_count') @IntConverter() int staffCount,
    @JsonKey(name: 'created_at') @DateTimeConverter() DateTime createdAt,
    @JsonKey(name: 'last_active')
    @NullableDateTimeConverter()
    DateTime? lastActiveAt,
  });

  @override
  $UserRefCopyWith<$Res>? get owner;
  @override
  $PlanCopyWith<$Res>? get plan;
}

/// @nodoc
class __$$PlatformFarmImplCopyWithImpl<$Res>
    extends _$PlatformFarmCopyWithImpl<$Res, _$PlatformFarmImpl>
    implements _$$PlatformFarmImplCopyWith<$Res> {
  __$$PlatformFarmImplCopyWithImpl(
    _$PlatformFarmImpl _value,
    $Res Function(_$PlatformFarmImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlatformFarm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? owner = freezed,
    Object? plan = freezed,
    Object? rabbitsCount = null,
    Object? staffCount = null,
    Object? createdAt = null,
    Object? lastActiveAt = freezed,
  }) {
    return _then(
      _$PlatformFarmImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        owner: freezed == owner
            ? _value.owner
            : owner // ignore: cast_nullable_to_non_nullable
                  as UserRef?,
        plan: freezed == plan
            ? _value.plan
            : plan // ignore: cast_nullable_to_non_nullable
                  as Plan?,
        rabbitsCount: null == rabbitsCount
            ? _value.rabbitsCount
            : rabbitsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        staffCount: null == staffCount
            ? _value.staffCount
            : staffCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastActiveAt: freezed == lastActiveAt
            ? _value.lastActiveAt
            : lastActiveAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlatformFarmImpl extends _PlatformFarm {
  const _$PlatformFarmImpl({
    @IntConverter() required this.id,
    required this.name,
    this.owner,
    this.plan,
    @JsonKey(name: 'rabbits_count') @IntConverter() this.rabbitsCount = 0,
    @JsonKey(name: 'staff_count') @IntConverter() this.staffCount = 0,
    @JsonKey(name: 'created_at') @DateTimeConverter() required this.createdAt,
    @JsonKey(name: 'last_active')
    @NullableDateTimeConverter()
    this.lastActiveAt,
  }) : super._();

  factory _$PlatformFarmImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlatformFarmImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String name;
  @override
  final UserRef? owner;
  @override
  final Plan? plan;
  @override
  @JsonKey(name: 'rabbits_count')
  @IntConverter()
  final int rabbitsCount;
  @override
  @JsonKey(name: 'staff_count')
  @IntConverter()
  final int staffCount;
  @override
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  final DateTime createdAt;
  // Последний вход кого-либо из фермы — `max(users.last_login_at)`. `null`
  // значит «никто ещё не заходил», а не «неизвестно»: разница важна для
  // фильтра «не заходили N дней».
  @override
  @JsonKey(name: 'last_active')
  @NullableDateTimeConverter()
  final DateTime? lastActiveAt;

  @override
  String toString() {
    return 'PlatformFarm(id: $id, name: $name, owner: $owner, plan: $plan, rabbitsCount: $rabbitsCount, staffCount: $staffCount, createdAt: $createdAt, lastActiveAt: $lastActiveAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformFarmImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.plan, plan) || other.plan == plan) &&
            (identical(other.rabbitsCount, rabbitsCount) ||
                other.rabbitsCount == rabbitsCount) &&
            (identical(other.staffCount, staffCount) ||
                other.staffCount == staffCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    owner,
    plan,
    rabbitsCount,
    staffCount,
    createdAt,
    lastActiveAt,
  );

  /// Create a copy of PlatformFarm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformFarmImplCopyWith<_$PlatformFarmImpl> get copyWith =>
      __$$PlatformFarmImplCopyWithImpl<_$PlatformFarmImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlatformFarmImplToJson(this);
  }
}

abstract class _PlatformFarm extends PlatformFarm {
  const factory _PlatformFarm({
    @IntConverter() required final int id,
    required final String name,
    final UserRef? owner,
    final Plan? plan,
    @JsonKey(name: 'rabbits_count') @IntConverter() final int rabbitsCount,
    @JsonKey(name: 'staff_count') @IntConverter() final int staffCount,
    @JsonKey(name: 'created_at')
    @DateTimeConverter()
    required final DateTime createdAt,
    @JsonKey(name: 'last_active')
    @NullableDateTimeConverter()
    final DateTime? lastActiveAt,
  }) = _$PlatformFarmImpl;
  const _PlatformFarm._() : super._();

  factory _PlatformFarm.fromJson(Map<String, dynamic> json) =
      _$PlatformFarmImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get name;
  @override
  UserRef? get owner;
  @override
  Plan? get plan;
  @override
  @JsonKey(name: 'rabbits_count')
  @IntConverter()
  int get rabbitsCount;
  @override
  @JsonKey(name: 'staff_count')
  @IntConverter()
  int get staffCount;
  @override
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  DateTime get createdAt; // Последний вход кого-либо из фермы — `max(users.last_login_at)`. `null`
  // значит «никто ещё не заходил», а не «неизвестно»: разница важна для
  // фильтра «не заходили N дней».
  @override
  @JsonKey(name: 'last_active')
  @NullableDateTimeConverter()
  DateTime? get lastActiveAt;

  /// Create a copy of PlatformFarm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlatformFarmImplCopyWith<_$PlatformFarmImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
