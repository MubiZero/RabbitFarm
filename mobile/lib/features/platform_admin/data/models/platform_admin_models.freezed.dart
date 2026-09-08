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

FarmStaffMember _$FarmStaffMemberFromJson(Map<String, dynamic> json) {
  return _FarmStaffMember.fromJson(json);
}

/// @nodoc
mixin _$FarmStaffMember {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError; // `null` — «ни разу не заходил», а не «неизвестно»: поддержке важно
  // отличать нового человека от того, кто перестал заходить.
  @JsonKey(name: 'last_login_at')
  @NullableDateTimeConverter()
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;

  /// Serializes this FarmStaffMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FarmStaffMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmStaffMemberCopyWith<FarmStaffMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmStaffMemberCopyWith<$Res> {
  factory $FarmStaffMemberCopyWith(
    FarmStaffMember value,
    $Res Function(FarmStaffMember) then,
  ) = _$FarmStaffMemberCopyWithImpl<$Res, FarmStaffMember>;
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'full_name') String fullName,
    String? email,
    String? phone,
    String role,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'last_login_at')
    @NullableDateTimeConverter()
    DateTime? lastLoginAt,
  });
}

/// @nodoc
class _$FarmStaffMemberCopyWithImpl<$Res, $Val extends FarmStaffMember>
    implements $FarmStaffMemberCopyWith<$Res> {
  _$FarmStaffMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FarmStaffMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? role = null,
    Object? isActive = null,
    Object? lastLoginAt = freezed,
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
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastLoginAt: freezed == lastLoginAt
                ? _value.lastLoginAt
                : lastLoginAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FarmStaffMemberImplCopyWith<$Res>
    implements $FarmStaffMemberCopyWith<$Res> {
  factory _$$FarmStaffMemberImplCopyWith(
    _$FarmStaffMemberImpl value,
    $Res Function(_$FarmStaffMemberImpl) then,
  ) = __$$FarmStaffMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'full_name') String fullName,
    String? email,
    String? phone,
    String role,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'last_login_at')
    @NullableDateTimeConverter()
    DateTime? lastLoginAt,
  });
}

/// @nodoc
class __$$FarmStaffMemberImplCopyWithImpl<$Res>
    extends _$FarmStaffMemberCopyWithImpl<$Res, _$FarmStaffMemberImpl>
    implements _$$FarmStaffMemberImplCopyWith<$Res> {
  __$$FarmStaffMemberImplCopyWithImpl(
    _$FarmStaffMemberImpl _value,
    $Res Function(_$FarmStaffMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FarmStaffMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? role = null,
    Object? isActive = null,
    Object? lastLoginAt = freezed,
  }) {
    return _then(
      _$FarmStaffMemberImpl(
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
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastLoginAt: freezed == lastLoginAt
            ? _value.lastLoginAt
            : lastLoginAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FarmStaffMemberImpl implements _FarmStaffMember {
  const _$FarmStaffMemberImpl({
    @IntConverter() required this.id,
    @JsonKey(name: 'full_name') required this.fullName,
    this.email,
    this.phone,
    required this.role,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'last_login_at')
    @NullableDateTimeConverter()
    this.lastLoginAt,
  });

  factory _$FarmStaffMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$FarmStaffMemberImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String role;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  // `null` — «ни разу не заходил», а не «неизвестно»: поддержке важно
  // отличать нового человека от того, кто перестал заходить.
  @override
  @JsonKey(name: 'last_login_at')
  @NullableDateTimeConverter()
  final DateTime? lastLoginAt;

  @override
  String toString() {
    return 'FarmStaffMember(id: $id, fullName: $fullName, email: $email, phone: $phone, role: $role, isActive: $isActive, lastLoginAt: $lastLoginAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmStaffMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fullName,
    email,
    phone,
    role,
    isActive,
    lastLoginAt,
  );

  /// Create a copy of FarmStaffMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmStaffMemberImplCopyWith<_$FarmStaffMemberImpl> get copyWith =>
      __$$FarmStaffMemberImplCopyWithImpl<_$FarmStaffMemberImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FarmStaffMemberImplToJson(this);
  }
}

abstract class _FarmStaffMember implements FarmStaffMember {
  const factory _FarmStaffMember({
    @IntConverter() required final int id,
    @JsonKey(name: 'full_name') required final String fullName,
    final String? email,
    final String? phone,
    required final String role,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'last_login_at')
    @NullableDateTimeConverter()
    final DateTime? lastLoginAt,
  }) = _$FarmStaffMemberImpl;

  factory _FarmStaffMember.fromJson(Map<String, dynamic> json) =
      _$FarmStaffMemberImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String get role;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive; // `null` — «ни разу не заходил», а не «неизвестно»: поддержке важно
  // отличать нового человека от того, кто перестал заходить.
  @override
  @JsonKey(name: 'last_login_at')
  @NullableDateTimeConverter()
  DateTime? get lastLoginAt;

  /// Create a copy of FarmStaffMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmStaffMemberImplCopyWith<_$FarmStaffMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FarmPayment _$FarmPaymentFromJson(Map<String, dynamic> json) {
  return _FarmPayment.fromJson(json);
}

/// @nodoc
mixin _$FarmPayment {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FarmPayment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FarmPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmPaymentCopyWith<FarmPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmPaymentCopyWith<$Res> {
  factory $FarmPaymentCopyWith(
    FarmPayment value,
    $Res Function(FarmPayment) then,
  ) = _$FarmPaymentCopyWithImpl<$Res, FarmPayment>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String amount,
    String currency,
    String status,
    String? description,
    @JsonKey(name: 'created_at') @DateTimeConverter() DateTime createdAt,
  });
}

/// @nodoc
class _$FarmPaymentCopyWithImpl<$Res, $Val extends FarmPayment>
    implements $FarmPaymentCopyWith<$Res> {
  _$FarmPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FarmPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? description = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FarmPaymentImplCopyWith<$Res>
    implements $FarmPaymentCopyWith<$Res> {
  factory _$$FarmPaymentImplCopyWith(
    _$FarmPaymentImpl value,
    $Res Function(_$FarmPaymentImpl) then,
  ) = __$$FarmPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String amount,
    String currency,
    String status,
    String? description,
    @JsonKey(name: 'created_at') @DateTimeConverter() DateTime createdAt,
  });
}

/// @nodoc
class __$$FarmPaymentImplCopyWithImpl<$Res>
    extends _$FarmPaymentCopyWithImpl<$Res, _$FarmPaymentImpl>
    implements _$$FarmPaymentImplCopyWith<$Res> {
  __$$FarmPaymentImplCopyWithImpl(
    _$FarmPaymentImpl _value,
    $Res Function(_$FarmPaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FarmPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? description = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$FarmPaymentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FarmPaymentImpl implements _FarmPayment {
  const _$FarmPaymentImpl({
    @IntConverter() required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    this.description,
    @JsonKey(name: 'created_at') @DateTimeConverter() required this.createdAt,
  });

  factory _$FarmPaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$FarmPaymentImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String amount;
  @override
  final String currency;
  @override
  final String status;
  @override
  final String? description;
  @override
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  final DateTime createdAt;

  @override
  String toString() {
    return 'FarmPayment(id: $id, amount: $amount, currency: $currency, status: $status, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmPaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    amount,
    currency,
    status,
    description,
    createdAt,
  );

  /// Create a copy of FarmPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmPaymentImplCopyWith<_$FarmPaymentImpl> get copyWith =>
      __$$FarmPaymentImplCopyWithImpl<_$FarmPaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FarmPaymentImplToJson(this);
  }
}

abstract class _FarmPayment implements FarmPayment {
  const factory _FarmPayment({
    @IntConverter() required final int id,
    required final String amount,
    required final String currency,
    required final String status,
    final String? description,
    @JsonKey(name: 'created_at')
    @DateTimeConverter()
    required final DateTime createdAt,
  }) = _$FarmPaymentImpl;

  factory _FarmPayment.fromJson(Map<String, dynamic> json) =
      _$FarmPaymentImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get amount;
  @override
  String get currency;
  @override
  String get status;
  @override
  String? get description;
  @override
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  DateTime get createdAt;

  /// Create a copy of FarmPayment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmPaymentImplCopyWith<_$FarmPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlatformFarmDetail _$PlatformFarmDetailFromJson(Map<String, dynamic> json) {
  return _PlatformFarmDetail.fromJson(json);
}

/// @nodoc
mixin _$PlatformFarmDetail {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  UserRef? get owner => throw _privateConstructorUsedError;
  @JsonKey(name: 'plan_id')
  @NullableIntConverter()
  int? get planId => throw _privateConstructorUsedError;
  Plan? get plan =>
      throw _privateConstructorUsedError; // Пусто = бессрочно. Так и будет у бесплатного тарифа по умолчанию.
  @JsonKey(name: 'plan_expires_at')
  @NullableDateTimeConverter()
  DateTime? get planExpiresAt => throw _privateConstructorUsedError; // `active` / `read_only` / `suspended`. Строкой, а не enum: значение
  // приходит от сервера, и незнакомое (например, добавленное позже)
  // не должно ронять разбор всей фермы.
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'extra_rabbits')
  @NullableIntConverter()
  int? get extraRabbits => throw _privateConstructorUsedError;
  @JsonKey(name: 'extra_staff')
  @NullableIntConverter()
  int? get extraStaff => throw _privateConstructorUsedError;
  @JsonKey(name: 'extras_until')
  @NullableDateTimeConverter()
  DateTime? get extrasUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbits_count')
  @IntConverter()
  int get rabbitsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'staff_count')
  @IntConverter()
  int get staffCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_active')
  @NullableDateTimeConverter()
  DateTime? get lastActiveAt => throw _privateConstructorUsedError;
  List<FarmStaffMember> get staff => throw _privateConstructorUsedError;
  List<FarmPayment> get payments => throw _privateConstructorUsedError;
  @JsonKey(name: 'storage_bytes')
  @IntConverter()
  int get storageBytes => throw _privateConstructorUsedError; // Мягкое удаление: доступ фермы закрыт сразу, а записи физически уходят
  // через окно ожидания. Пусто = ферма жива.
  @JsonKey(name: 'deleted_at')
  @NullableDateTimeConverter()
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this PlatformFarmDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlatformFarmDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlatformFarmDetailCopyWith<PlatformFarmDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlatformFarmDetailCopyWith<$Res> {
  factory $PlatformFarmDetailCopyWith(
    PlatformFarmDetail value,
    $Res Function(PlatformFarmDetail) then,
  ) = _$PlatformFarmDetailCopyWithImpl<$Res, PlatformFarmDetail>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String name,
    UserRef? owner,
    @JsonKey(name: 'plan_id') @NullableIntConverter() int? planId,
    Plan? plan,
    @JsonKey(name: 'plan_expires_at')
    @NullableDateTimeConverter()
    DateTime? planExpiresAt,
    String status,
    @JsonKey(name: 'extra_rabbits') @NullableIntConverter() int? extraRabbits,
    @JsonKey(name: 'extra_staff') @NullableIntConverter() int? extraStaff,
    @JsonKey(name: 'extras_until')
    @NullableDateTimeConverter()
    DateTime? extrasUntil,
    @JsonKey(name: 'rabbits_count') @IntConverter() int rabbitsCount,
    @JsonKey(name: 'staff_count') @IntConverter() int staffCount,
    @JsonKey(name: 'created_at') @DateTimeConverter() DateTime createdAt,
    @JsonKey(name: 'last_active')
    @NullableDateTimeConverter()
    DateTime? lastActiveAt,
    List<FarmStaffMember> staff,
    List<FarmPayment> payments,
    @JsonKey(name: 'storage_bytes') @IntConverter() int storageBytes,
    @JsonKey(name: 'deleted_at')
    @NullableDateTimeConverter()
    DateTime? deletedAt,
  });

  $UserRefCopyWith<$Res>? get owner;
  $PlanCopyWith<$Res>? get plan;
}

/// @nodoc
class _$PlatformFarmDetailCopyWithImpl<$Res, $Val extends PlatformFarmDetail>
    implements $PlatformFarmDetailCopyWith<$Res> {
  _$PlatformFarmDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlatformFarmDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? owner = freezed,
    Object? planId = freezed,
    Object? plan = freezed,
    Object? planExpiresAt = freezed,
    Object? status = null,
    Object? extraRabbits = freezed,
    Object? extraStaff = freezed,
    Object? extrasUntil = freezed,
    Object? rabbitsCount = null,
    Object? staffCount = null,
    Object? createdAt = null,
    Object? lastActiveAt = freezed,
    Object? staff = null,
    Object? payments = null,
    Object? storageBytes = null,
    Object? deletedAt = freezed,
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
            planId: freezed == planId
                ? _value.planId
                : planId // ignore: cast_nullable_to_non_nullable
                      as int?,
            plan: freezed == plan
                ? _value.plan
                : plan // ignore: cast_nullable_to_non_nullable
                      as Plan?,
            planExpiresAt: freezed == planExpiresAt
                ? _value.planExpiresAt
                : planExpiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            extraRabbits: freezed == extraRabbits
                ? _value.extraRabbits
                : extraRabbits // ignore: cast_nullable_to_non_nullable
                      as int?,
            extraStaff: freezed == extraStaff
                ? _value.extraStaff
                : extraStaff // ignore: cast_nullable_to_non_nullable
                      as int?,
            extrasUntil: freezed == extrasUntil
                ? _value.extrasUntil
                : extrasUntil // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
            staff: null == staff
                ? _value.staff
                : staff // ignore: cast_nullable_to_non_nullable
                      as List<FarmStaffMember>,
            payments: null == payments
                ? _value.payments
                : payments // ignore: cast_nullable_to_non_nullable
                      as List<FarmPayment>,
            storageBytes: null == storageBytes
                ? _value.storageBytes
                : storageBytes // ignore: cast_nullable_to_non_nullable
                      as int,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of PlatformFarmDetail
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

  /// Create a copy of PlatformFarmDetail
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
abstract class _$$PlatformFarmDetailImplCopyWith<$Res>
    implements $PlatformFarmDetailCopyWith<$Res> {
  factory _$$PlatformFarmDetailImplCopyWith(
    _$PlatformFarmDetailImpl value,
    $Res Function(_$PlatformFarmDetailImpl) then,
  ) = __$$PlatformFarmDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String name,
    UserRef? owner,
    @JsonKey(name: 'plan_id') @NullableIntConverter() int? planId,
    Plan? plan,
    @JsonKey(name: 'plan_expires_at')
    @NullableDateTimeConverter()
    DateTime? planExpiresAt,
    String status,
    @JsonKey(name: 'extra_rabbits') @NullableIntConverter() int? extraRabbits,
    @JsonKey(name: 'extra_staff') @NullableIntConverter() int? extraStaff,
    @JsonKey(name: 'extras_until')
    @NullableDateTimeConverter()
    DateTime? extrasUntil,
    @JsonKey(name: 'rabbits_count') @IntConverter() int rabbitsCount,
    @JsonKey(name: 'staff_count') @IntConverter() int staffCount,
    @JsonKey(name: 'created_at') @DateTimeConverter() DateTime createdAt,
    @JsonKey(name: 'last_active')
    @NullableDateTimeConverter()
    DateTime? lastActiveAt,
    List<FarmStaffMember> staff,
    List<FarmPayment> payments,
    @JsonKey(name: 'storage_bytes') @IntConverter() int storageBytes,
    @JsonKey(name: 'deleted_at')
    @NullableDateTimeConverter()
    DateTime? deletedAt,
  });

  @override
  $UserRefCopyWith<$Res>? get owner;
  @override
  $PlanCopyWith<$Res>? get plan;
}

/// @nodoc
class __$$PlatformFarmDetailImplCopyWithImpl<$Res>
    extends _$PlatformFarmDetailCopyWithImpl<$Res, _$PlatformFarmDetailImpl>
    implements _$$PlatformFarmDetailImplCopyWith<$Res> {
  __$$PlatformFarmDetailImplCopyWithImpl(
    _$PlatformFarmDetailImpl _value,
    $Res Function(_$PlatformFarmDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlatformFarmDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? owner = freezed,
    Object? planId = freezed,
    Object? plan = freezed,
    Object? planExpiresAt = freezed,
    Object? status = null,
    Object? extraRabbits = freezed,
    Object? extraStaff = freezed,
    Object? extrasUntil = freezed,
    Object? rabbitsCount = null,
    Object? staffCount = null,
    Object? createdAt = null,
    Object? lastActiveAt = freezed,
    Object? staff = null,
    Object? payments = null,
    Object? storageBytes = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$PlatformFarmDetailImpl(
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
        planId: freezed == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as int?,
        plan: freezed == plan
            ? _value.plan
            : plan // ignore: cast_nullable_to_non_nullable
                  as Plan?,
        planExpiresAt: freezed == planExpiresAt
            ? _value.planExpiresAt
            : planExpiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        extraRabbits: freezed == extraRabbits
            ? _value.extraRabbits
            : extraRabbits // ignore: cast_nullable_to_non_nullable
                  as int?,
        extraStaff: freezed == extraStaff
            ? _value.extraStaff
            : extraStaff // ignore: cast_nullable_to_non_nullable
                  as int?,
        extrasUntil: freezed == extrasUntil
            ? _value.extrasUntil
            : extrasUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
        staff: null == staff
            ? _value._staff
            : staff // ignore: cast_nullable_to_non_nullable
                  as List<FarmStaffMember>,
        payments: null == payments
            ? _value._payments
            : payments // ignore: cast_nullable_to_non_nullable
                  as List<FarmPayment>,
        storageBytes: null == storageBytes
            ? _value.storageBytes
            : storageBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlatformFarmDetailImpl extends _PlatformFarmDetail {
  const _$PlatformFarmDetailImpl({
    @IntConverter() required this.id,
    required this.name,
    this.owner,
    @JsonKey(name: 'plan_id') @NullableIntConverter() this.planId,
    this.plan,
    @JsonKey(name: 'plan_expires_at')
    @NullableDateTimeConverter()
    this.planExpiresAt,
    this.status = 'active',
    @JsonKey(name: 'extra_rabbits') @NullableIntConverter() this.extraRabbits,
    @JsonKey(name: 'extra_staff') @NullableIntConverter() this.extraStaff,
    @JsonKey(name: 'extras_until')
    @NullableDateTimeConverter()
    this.extrasUntil,
    @JsonKey(name: 'rabbits_count') @IntConverter() this.rabbitsCount = 0,
    @JsonKey(name: 'staff_count') @IntConverter() this.staffCount = 0,
    @JsonKey(name: 'created_at') @DateTimeConverter() required this.createdAt,
    @JsonKey(name: 'last_active')
    @NullableDateTimeConverter()
    this.lastActiveAt,
    final List<FarmStaffMember> staff = const [],
    final List<FarmPayment> payments = const [],
    @JsonKey(name: 'storage_bytes') @IntConverter() this.storageBytes = 0,
    @JsonKey(name: 'deleted_at') @NullableDateTimeConverter() this.deletedAt,
  }) : _staff = staff,
       _payments = payments,
       super._();

  factory _$PlatformFarmDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlatformFarmDetailImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String name;
  @override
  final UserRef? owner;
  @override
  @JsonKey(name: 'plan_id')
  @NullableIntConverter()
  final int? planId;
  @override
  final Plan? plan;
  // Пусто = бессрочно. Так и будет у бесплатного тарифа по умолчанию.
  @override
  @JsonKey(name: 'plan_expires_at')
  @NullableDateTimeConverter()
  final DateTime? planExpiresAt;
  // `active` / `read_only` / `suspended`. Строкой, а не enum: значение
  // приходит от сервера, и незнакомое (например, добавленное позже)
  // не должно ронять разбор всей фермы.
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'extra_rabbits')
  @NullableIntConverter()
  final int? extraRabbits;
  @override
  @JsonKey(name: 'extra_staff')
  @NullableIntConverter()
  final int? extraStaff;
  @override
  @JsonKey(name: 'extras_until')
  @NullableDateTimeConverter()
  final DateTime? extrasUntil;
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
  @override
  @JsonKey(name: 'last_active')
  @NullableDateTimeConverter()
  final DateTime? lastActiveAt;
  final List<FarmStaffMember> _staff;
  @override
  @JsonKey()
  List<FarmStaffMember> get staff {
    if (_staff is EqualUnmodifiableListView) return _staff;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_staff);
  }

  final List<FarmPayment> _payments;
  @override
  @JsonKey()
  List<FarmPayment> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  @JsonKey(name: 'storage_bytes')
  @IntConverter()
  final int storageBytes;
  // Мягкое удаление: доступ фермы закрыт сразу, а записи физически уходят
  // через окно ожидания. Пусто = ферма жива.
  @override
  @JsonKey(name: 'deleted_at')
  @NullableDateTimeConverter()
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'PlatformFarmDetail(id: $id, name: $name, owner: $owner, planId: $planId, plan: $plan, planExpiresAt: $planExpiresAt, status: $status, extraRabbits: $extraRabbits, extraStaff: $extraStaff, extrasUntil: $extrasUntil, rabbitsCount: $rabbitsCount, staffCount: $staffCount, createdAt: $createdAt, lastActiveAt: $lastActiveAt, staff: $staff, payments: $payments, storageBytes: $storageBytes, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformFarmDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.plan, plan) || other.plan == plan) &&
            (identical(other.planExpiresAt, planExpiresAt) ||
                other.planExpiresAt == planExpiresAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.extraRabbits, extraRabbits) ||
                other.extraRabbits == extraRabbits) &&
            (identical(other.extraStaff, extraStaff) ||
                other.extraStaff == extraStaff) &&
            (identical(other.extrasUntil, extrasUntil) ||
                other.extrasUntil == extrasUntil) &&
            (identical(other.rabbitsCount, rabbitsCount) ||
                other.rabbitsCount == rabbitsCount) &&
            (identical(other.staffCount, staffCount) ||
                other.staffCount == staffCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt) &&
            const DeepCollectionEquality().equals(other._staff, _staff) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.storageBytes, storageBytes) ||
                other.storageBytes == storageBytes) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    owner,
    planId,
    plan,
    planExpiresAt,
    status,
    extraRabbits,
    extraStaff,
    extrasUntil,
    rabbitsCount,
    staffCount,
    createdAt,
    lastActiveAt,
    const DeepCollectionEquality().hash(_staff),
    const DeepCollectionEquality().hash(_payments),
    storageBytes,
    deletedAt,
  );

  /// Create a copy of PlatformFarmDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformFarmDetailImplCopyWith<_$PlatformFarmDetailImpl> get copyWith =>
      __$$PlatformFarmDetailImplCopyWithImpl<_$PlatformFarmDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PlatformFarmDetailImplToJson(this);
  }
}

abstract class _PlatformFarmDetail extends PlatformFarmDetail {
  const factory _PlatformFarmDetail({
    @IntConverter() required final int id,
    required final String name,
    final UserRef? owner,
    @JsonKey(name: 'plan_id') @NullableIntConverter() final int? planId,
    final Plan? plan,
    @JsonKey(name: 'plan_expires_at')
    @NullableDateTimeConverter()
    final DateTime? planExpiresAt,
    final String status,
    @JsonKey(name: 'extra_rabbits')
    @NullableIntConverter()
    final int? extraRabbits,
    @JsonKey(name: 'extra_staff') @NullableIntConverter() final int? extraStaff,
    @JsonKey(name: 'extras_until')
    @NullableDateTimeConverter()
    final DateTime? extrasUntil,
    @JsonKey(name: 'rabbits_count') @IntConverter() final int rabbitsCount,
    @JsonKey(name: 'staff_count') @IntConverter() final int staffCount,
    @JsonKey(name: 'created_at')
    @DateTimeConverter()
    required final DateTime createdAt,
    @JsonKey(name: 'last_active')
    @NullableDateTimeConverter()
    final DateTime? lastActiveAt,
    final List<FarmStaffMember> staff,
    final List<FarmPayment> payments,
    @JsonKey(name: 'storage_bytes') @IntConverter() final int storageBytes,
    @JsonKey(name: 'deleted_at')
    @NullableDateTimeConverter()
    final DateTime? deletedAt,
  }) = _$PlatformFarmDetailImpl;
  const _PlatformFarmDetail._() : super._();

  factory _PlatformFarmDetail.fromJson(Map<String, dynamic> json) =
      _$PlatformFarmDetailImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get name;
  @override
  UserRef? get owner;
  @override
  @JsonKey(name: 'plan_id')
  @NullableIntConverter()
  int? get planId;
  @override
  Plan? get plan; // Пусто = бессрочно. Так и будет у бесплатного тарифа по умолчанию.
  @override
  @JsonKey(name: 'plan_expires_at')
  @NullableDateTimeConverter()
  DateTime? get planExpiresAt; // `active` / `read_only` / `suspended`. Строкой, а не enum: значение
  // приходит от сервера, и незнакомое (например, добавленное позже)
  // не должно ронять разбор всей фермы.
  @override
  String get status;
  @override
  @JsonKey(name: 'extra_rabbits')
  @NullableIntConverter()
  int? get extraRabbits;
  @override
  @JsonKey(name: 'extra_staff')
  @NullableIntConverter()
  int? get extraStaff;
  @override
  @JsonKey(name: 'extras_until')
  @NullableDateTimeConverter()
  DateTime? get extrasUntil;
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
  DateTime get createdAt;
  @override
  @JsonKey(name: 'last_active')
  @NullableDateTimeConverter()
  DateTime? get lastActiveAt;
  @override
  List<FarmStaffMember> get staff;
  @override
  List<FarmPayment> get payments;
  @override
  @JsonKey(name: 'storage_bytes')
  @IntConverter()
  int get storageBytes; // Мягкое удаление: доступ фермы закрыт сразу, а записи физически уходят
  // через окно ожидания. Пусто = ферма жива.
  @override
  @JsonKey(name: 'deleted_at')
  @NullableDateTimeConverter()
  DateTime? get deletedAt;

  /// Create a copy of PlatformFarmDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlatformFarmDetailImplCopyWith<_$PlatformFarmDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
