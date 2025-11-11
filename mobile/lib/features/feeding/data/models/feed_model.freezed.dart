// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Feed _$FeedFromJson(Map<String, dynamic> json) {
  return _Feed.fromJson(json);
}

/// @nodoc
mixin _$Feed {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  FeedType get type => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: FeedUnit.kg)
  FeedUnit get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_stock')
  @DoubleConverter()
  double get currentStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_stock')
  @DoubleConverter()
  double get minStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_per_unit')
  @DoubleConverter()
  double? get costPerUnit => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Feed to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Feed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedCopyWith<Feed> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedCopyWith<$Res> {
  factory $FeedCopyWith(Feed value, $Res Function(Feed) then) =
      _$FeedCopyWithImpl<$Res, Feed>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String name,
    FeedType type,
    String? brand,
    @JsonKey(defaultValue: FeedUnit.kg) FeedUnit unit,
    @JsonKey(name: 'current_stock') @DoubleConverter() double currentStock,
    @JsonKey(name: 'min_stock') @DoubleConverter() double minStock,
    @JsonKey(name: 'cost_per_unit') @DoubleConverter() double? costPerUnit,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$FeedCopyWithImpl<$Res, $Val extends Feed>
    implements $FeedCopyWith<$Res> {
  _$FeedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Feed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? brand = freezed,
    Object? unit = null,
    Object? currentStock = null,
    Object? minStock = null,
    Object? costPerUnit = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as FeedType,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String?,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as FeedUnit,
            currentStock: null == currentStock
                ? _value.currentStock
                : currentStock // ignore: cast_nullable_to_non_nullable
                      as double,
            minStock: null == minStock
                ? _value.minStock
                : minStock // ignore: cast_nullable_to_non_nullable
                      as double,
            costPerUnit: freezed == costPerUnit
                ? _value.costPerUnit
                : costPerUnit // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedImplCopyWith<$Res> implements $FeedCopyWith<$Res> {
  factory _$$FeedImplCopyWith(
    _$FeedImpl value,
    $Res Function(_$FeedImpl) then,
  ) = __$$FeedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String name,
    FeedType type,
    String? brand,
    @JsonKey(defaultValue: FeedUnit.kg) FeedUnit unit,
    @JsonKey(name: 'current_stock') @DoubleConverter() double currentStock,
    @JsonKey(name: 'min_stock') @DoubleConverter() double minStock,
    @JsonKey(name: 'cost_per_unit') @DoubleConverter() double? costPerUnit,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$FeedImplCopyWithImpl<$Res>
    extends _$FeedCopyWithImpl<$Res, _$FeedImpl>
    implements _$$FeedImplCopyWith<$Res> {
  __$$FeedImplCopyWithImpl(_$FeedImpl _value, $Res Function(_$FeedImpl) _then)
    : super(_value, _then);

  /// Create a copy of Feed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? brand = freezed,
    Object? unit = null,
    Object? currentStock = null,
    Object? minStock = null,
    Object? costPerUnit = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$FeedImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as FeedType,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String?,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as FeedUnit,
        currentStock: null == currentStock
            ? _value.currentStock
            : currentStock // ignore: cast_nullable_to_non_nullable
                  as double,
        minStock: null == minStock
            ? _value.minStock
            : minStock // ignore: cast_nullable_to_non_nullable
                  as double,
        costPerUnit: freezed == costPerUnit
            ? _value.costPerUnit
            : costPerUnit // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedImpl implements _Feed {
  const _$FeedImpl({
    @IntConverter() required this.id,
    required this.name,
    required this.type,
    this.brand,
    @JsonKey(defaultValue: FeedUnit.kg) required this.unit,
    @JsonKey(name: 'current_stock')
    @DoubleConverter()
    required this.currentStock,
    @JsonKey(name: 'min_stock') @DoubleConverter() required this.minStock,
    @JsonKey(name: 'cost_per_unit') @DoubleConverter() this.costPerUnit,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$FeedImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String name;
  @override
  final FeedType type;
  @override
  final String? brand;
  @override
  @JsonKey(defaultValue: FeedUnit.kg)
  final FeedUnit unit;
  @override
  @JsonKey(name: 'current_stock')
  @DoubleConverter()
  final double currentStock;
  @override
  @JsonKey(name: 'min_stock')
  @DoubleConverter()
  final double minStock;
  @override
  @JsonKey(name: 'cost_per_unit')
  @DoubleConverter()
  final double? costPerUnit;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Feed(id: $id, name: $name, type: $type, brand: $brand, unit: $unit, currentStock: $currentStock, minStock: $minStock, costPerUnit: $costPerUnit, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.minStock, minStock) ||
                other.minStock == minStock) &&
            (identical(other.costPerUnit, costPerUnit) ||
                other.costPerUnit == costPerUnit) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    brand,
    unit,
    currentStock,
    minStock,
    costPerUnit,
    notes,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Feed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedImplCopyWith<_$FeedImpl> get copyWith =>
      __$$FeedImplCopyWithImpl<_$FeedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedImplToJson(this);
  }
}

abstract class _Feed implements Feed {
  const factory _Feed({
    @IntConverter() required final int id,
    required final String name,
    required final FeedType type,
    final String? brand,
    @JsonKey(defaultValue: FeedUnit.kg) required final FeedUnit unit,
    @JsonKey(name: 'current_stock')
    @DoubleConverter()
    required final double currentStock,
    @JsonKey(name: 'min_stock')
    @DoubleConverter()
    required final double minStock,
    @JsonKey(name: 'cost_per_unit')
    @DoubleConverter()
    final double? costPerUnit,
    final String? notes,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$FeedImpl;

  factory _Feed.fromJson(Map<String, dynamic> json) = _$FeedImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get name;
  @override
  FeedType get type;
  @override
  String? get brand;
  @override
  @JsonKey(defaultValue: FeedUnit.kg)
  FeedUnit get unit;
  @override
  @JsonKey(name: 'current_stock')
  @DoubleConverter()
  double get currentStock;
  @override
  @JsonKey(name: 'min_stock')
  @DoubleConverter()
  double get minStock;
  @override
  @JsonKey(name: 'cost_per_unit')
  @DoubleConverter()
  double? get costPerUnit;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of Feed
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedImplCopyWith<_$FeedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedCreate _$FeedCreateFromJson(Map<String, dynamic> json) {
  return _FeedCreate.fromJson(json);
}

/// @nodoc
mixin _$FeedCreate {
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 'kg')
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_stock')
  double? get currentStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_stock')
  double? get minStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_per_unit')
  double? get costPerUnit => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this FeedCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedCreateCopyWith<FeedCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedCreateCopyWith<$Res> {
  factory $FeedCreateCopyWith(
    FeedCreate value,
    $Res Function(FeedCreate) then,
  ) = _$FeedCreateCopyWithImpl<$Res, FeedCreate>;
  @useResult
  $Res call({
    String name,
    String type,
    String? brand,
    @JsonKey(defaultValue: 'kg') String? unit,
    @JsonKey(name: 'current_stock') double? currentStock,
    @JsonKey(name: 'min_stock') double? minStock,
    @JsonKey(name: 'cost_per_unit') double? costPerUnit,
    String? notes,
  });
}

/// @nodoc
class _$FeedCreateCopyWithImpl<$Res, $Val extends FeedCreate>
    implements $FeedCreateCopyWith<$Res> {
  _$FeedCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? brand = freezed,
    Object? unit = freezed,
    Object? currentStock = freezed,
    Object? minStock = freezed,
    Object? costPerUnit = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String?,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentStock: freezed == currentStock
                ? _value.currentStock
                : currentStock // ignore: cast_nullable_to_non_nullable
                      as double?,
            minStock: freezed == minStock
                ? _value.minStock
                : minStock // ignore: cast_nullable_to_non_nullable
                      as double?,
            costPerUnit: freezed == costPerUnit
                ? _value.costPerUnit
                : costPerUnit // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedCreateImplCopyWith<$Res>
    implements $FeedCreateCopyWith<$Res> {
  factory _$$FeedCreateImplCopyWith(
    _$FeedCreateImpl value,
    $Res Function(_$FeedCreateImpl) then,
  ) = __$$FeedCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String type,
    String? brand,
    @JsonKey(defaultValue: 'kg') String? unit,
    @JsonKey(name: 'current_stock') double? currentStock,
    @JsonKey(name: 'min_stock') double? minStock,
    @JsonKey(name: 'cost_per_unit') double? costPerUnit,
    String? notes,
  });
}

/// @nodoc
class __$$FeedCreateImplCopyWithImpl<$Res>
    extends _$FeedCreateCopyWithImpl<$Res, _$FeedCreateImpl>
    implements _$$FeedCreateImplCopyWith<$Res> {
  __$$FeedCreateImplCopyWithImpl(
    _$FeedCreateImpl _value,
    $Res Function(_$FeedCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? brand = freezed,
    Object? unit = freezed,
    Object? currentStock = freezed,
    Object? minStock = freezed,
    Object? costPerUnit = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$FeedCreateImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String?,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentStock: freezed == currentStock
            ? _value.currentStock
            : currentStock // ignore: cast_nullable_to_non_nullable
                  as double?,
        minStock: freezed == minStock
            ? _value.minStock
            : minStock // ignore: cast_nullable_to_non_nullable
                  as double?,
        costPerUnit: freezed == costPerUnit
            ? _value.costPerUnit
            : costPerUnit // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedCreateImpl implements _FeedCreate {
  const _$FeedCreateImpl({
    required this.name,
    required this.type,
    this.brand,
    @JsonKey(defaultValue: 'kg') this.unit,
    @JsonKey(name: 'current_stock') this.currentStock,
    @JsonKey(name: 'min_stock') this.minStock,
    @JsonKey(name: 'cost_per_unit') this.costPerUnit,
    this.notes,
  });

  factory _$FeedCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedCreateImplFromJson(json);

  @override
  final String name;
  @override
  final String type;
  @override
  final String? brand;
  @override
  @JsonKey(defaultValue: 'kg')
  final String? unit;
  @override
  @JsonKey(name: 'current_stock')
  final double? currentStock;
  @override
  @JsonKey(name: 'min_stock')
  final double? minStock;
  @override
  @JsonKey(name: 'cost_per_unit')
  final double? costPerUnit;
  @override
  final String? notes;

  @override
  String toString() {
    return 'FeedCreate(name: $name, type: $type, brand: $brand, unit: $unit, currentStock: $currentStock, minStock: $minStock, costPerUnit: $costPerUnit, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedCreateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.minStock, minStock) ||
                other.minStock == minStock) &&
            (identical(other.costPerUnit, costPerUnit) ||
                other.costPerUnit == costPerUnit) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    type,
    brand,
    unit,
    currentStock,
    minStock,
    costPerUnit,
    notes,
  );

  /// Create a copy of FeedCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedCreateImplCopyWith<_$FeedCreateImpl> get copyWith =>
      __$$FeedCreateImplCopyWithImpl<_$FeedCreateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedCreateImplToJson(this);
  }
}

abstract class _FeedCreate implements FeedCreate {
  const factory _FeedCreate({
    required final String name,
    required final String type,
    final String? brand,
    @JsonKey(defaultValue: 'kg') final String? unit,
    @JsonKey(name: 'current_stock') final double? currentStock,
    @JsonKey(name: 'min_stock') final double? minStock,
    @JsonKey(name: 'cost_per_unit') final double? costPerUnit,
    final String? notes,
  }) = _$FeedCreateImpl;

  factory _FeedCreate.fromJson(Map<String, dynamic> json) =
      _$FeedCreateImpl.fromJson;

  @override
  String get name;
  @override
  String get type;
  @override
  String? get brand;
  @override
  @JsonKey(defaultValue: 'kg')
  String? get unit;
  @override
  @JsonKey(name: 'current_stock')
  double? get currentStock;
  @override
  @JsonKey(name: 'min_stock')
  double? get minStock;
  @override
  @JsonKey(name: 'cost_per_unit')
  double? get costPerUnit;
  @override
  String? get notes;

  /// Create a copy of FeedCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedCreateImplCopyWith<_$FeedCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedUpdate _$FeedUpdateFromJson(Map<String, dynamic> json) {
  return _FeedUpdate.fromJson(json);
}

/// @nodoc
mixin _$FeedUpdate {
  String? get name => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_stock')
  double? get currentStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_stock')
  double? get minStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_per_unit')
  double? get costPerUnit => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this FeedUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedUpdateCopyWith<FeedUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedUpdateCopyWith<$Res> {
  factory $FeedUpdateCopyWith(
    FeedUpdate value,
    $Res Function(FeedUpdate) then,
  ) = _$FeedUpdateCopyWithImpl<$Res, FeedUpdate>;
  @useResult
  $Res call({
    String? name,
    String? type,
    String? brand,
    String? unit,
    @JsonKey(name: 'current_stock') double? currentStock,
    @JsonKey(name: 'min_stock') double? minStock,
    @JsonKey(name: 'cost_per_unit') double? costPerUnit,
    String? notes,
  });
}

/// @nodoc
class _$FeedUpdateCopyWithImpl<$Res, $Val extends FeedUpdate>
    implements $FeedUpdateCopyWith<$Res> {
  _$FeedUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? type = freezed,
    Object? brand = freezed,
    Object? unit = freezed,
    Object? currentStock = freezed,
    Object? minStock = freezed,
    Object? costPerUnit = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String?,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentStock: freezed == currentStock
                ? _value.currentStock
                : currentStock // ignore: cast_nullable_to_non_nullable
                      as double?,
            minStock: freezed == minStock
                ? _value.minStock
                : minStock // ignore: cast_nullable_to_non_nullable
                      as double?,
            costPerUnit: freezed == costPerUnit
                ? _value.costPerUnit
                : costPerUnit // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedUpdateImplCopyWith<$Res>
    implements $FeedUpdateCopyWith<$Res> {
  factory _$$FeedUpdateImplCopyWith(
    _$FeedUpdateImpl value,
    $Res Function(_$FeedUpdateImpl) then,
  ) = __$$FeedUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? name,
    String? type,
    String? brand,
    String? unit,
    @JsonKey(name: 'current_stock') double? currentStock,
    @JsonKey(name: 'min_stock') double? minStock,
    @JsonKey(name: 'cost_per_unit') double? costPerUnit,
    String? notes,
  });
}

/// @nodoc
class __$$FeedUpdateImplCopyWithImpl<$Res>
    extends _$FeedUpdateCopyWithImpl<$Res, _$FeedUpdateImpl>
    implements _$$FeedUpdateImplCopyWith<$Res> {
  __$$FeedUpdateImplCopyWithImpl(
    _$FeedUpdateImpl _value,
    $Res Function(_$FeedUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? type = freezed,
    Object? brand = freezed,
    Object? unit = freezed,
    Object? currentStock = freezed,
    Object? minStock = freezed,
    Object? costPerUnit = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$FeedUpdateImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String?,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentStock: freezed == currentStock
            ? _value.currentStock
            : currentStock // ignore: cast_nullable_to_non_nullable
                  as double?,
        minStock: freezed == minStock
            ? _value.minStock
            : minStock // ignore: cast_nullable_to_non_nullable
                  as double?,
        costPerUnit: freezed == costPerUnit
            ? _value.costPerUnit
            : costPerUnit // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedUpdateImpl implements _FeedUpdate {
  const _$FeedUpdateImpl({
    this.name,
    this.type,
    this.brand,
    this.unit,
    @JsonKey(name: 'current_stock') this.currentStock,
    @JsonKey(name: 'min_stock') this.minStock,
    @JsonKey(name: 'cost_per_unit') this.costPerUnit,
    this.notes,
  });

  factory _$FeedUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedUpdateImplFromJson(json);

  @override
  final String? name;
  @override
  final String? type;
  @override
  final String? brand;
  @override
  final String? unit;
  @override
  @JsonKey(name: 'current_stock')
  final double? currentStock;
  @override
  @JsonKey(name: 'min_stock')
  final double? minStock;
  @override
  @JsonKey(name: 'cost_per_unit')
  final double? costPerUnit;
  @override
  final String? notes;

  @override
  String toString() {
    return 'FeedUpdate(name: $name, type: $type, brand: $brand, unit: $unit, currentStock: $currentStock, minStock: $minStock, costPerUnit: $costPerUnit, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedUpdateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.minStock, minStock) ||
                other.minStock == minStock) &&
            (identical(other.costPerUnit, costPerUnit) ||
                other.costPerUnit == costPerUnit) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    type,
    brand,
    unit,
    currentStock,
    minStock,
    costPerUnit,
    notes,
  );

  /// Create a copy of FeedUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedUpdateImplCopyWith<_$FeedUpdateImpl> get copyWith =>
      __$$FeedUpdateImplCopyWithImpl<_$FeedUpdateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedUpdateImplToJson(this);
  }
}

abstract class _FeedUpdate implements FeedUpdate {
  const factory _FeedUpdate({
    final String? name,
    final String? type,
    final String? brand,
    final String? unit,
    @JsonKey(name: 'current_stock') final double? currentStock,
    @JsonKey(name: 'min_stock') final double? minStock,
    @JsonKey(name: 'cost_per_unit') final double? costPerUnit,
    final String? notes,
  }) = _$FeedUpdateImpl;

  factory _FeedUpdate.fromJson(Map<String, dynamic> json) =
      _$FeedUpdateImpl.fromJson;

  @override
  String? get name;
  @override
  String? get type;
  @override
  String? get brand;
  @override
  String? get unit;
  @override
  @JsonKey(name: 'current_stock')
  double? get currentStock;
  @override
  @JsonKey(name: 'min_stock')
  double? get minStock;
  @override
  @JsonKey(name: 'cost_per_unit')
  double? get costPerUnit;
  @override
  String? get notes;

  /// Create a copy of FeedUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedUpdateImplCopyWith<_$FeedUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockAdjustment _$StockAdjustmentFromJson(Map<String, dynamic> json) {
  return _StockAdjustment.fromJson(json);
}

/// @nodoc
mixin _$StockAdjustment {
  double get quantity => throw _privateConstructorUsedError;
  String get operation => throw _privateConstructorUsedError;

  /// Serializes this StockAdjustment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockAdjustment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockAdjustmentCopyWith<StockAdjustment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockAdjustmentCopyWith<$Res> {
  factory $StockAdjustmentCopyWith(
    StockAdjustment value,
    $Res Function(StockAdjustment) then,
  ) = _$StockAdjustmentCopyWithImpl<$Res, StockAdjustment>;
  @useResult
  $Res call({double quantity, String operation});
}

/// @nodoc
class _$StockAdjustmentCopyWithImpl<$Res, $Val extends StockAdjustment>
    implements $StockAdjustmentCopyWith<$Res> {
  _$StockAdjustmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockAdjustment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? quantity = null, Object? operation = null}) {
    return _then(
      _value.copyWith(
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            operation: null == operation
                ? _value.operation
                : operation // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockAdjustmentImplCopyWith<$Res>
    implements $StockAdjustmentCopyWith<$Res> {
  factory _$$StockAdjustmentImplCopyWith(
    _$StockAdjustmentImpl value,
    $Res Function(_$StockAdjustmentImpl) then,
  ) = __$$StockAdjustmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double quantity, String operation});
}

/// @nodoc
class __$$StockAdjustmentImplCopyWithImpl<$Res>
    extends _$StockAdjustmentCopyWithImpl<$Res, _$StockAdjustmentImpl>
    implements _$$StockAdjustmentImplCopyWith<$Res> {
  __$$StockAdjustmentImplCopyWithImpl(
    _$StockAdjustmentImpl _value,
    $Res Function(_$StockAdjustmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockAdjustment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? quantity = null, Object? operation = null}) {
    return _then(
      _$StockAdjustmentImpl(
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        operation: null == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockAdjustmentImpl implements _StockAdjustment {
  const _$StockAdjustmentImpl({
    required this.quantity,
    required this.operation,
  });

  factory _$StockAdjustmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockAdjustmentImplFromJson(json);

  @override
  final double quantity;
  @override
  final String operation;

  @override
  String toString() {
    return 'StockAdjustment(quantity: $quantity, operation: $operation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockAdjustmentImpl &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.operation, operation) ||
                other.operation == operation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quantity, operation);

  /// Create a copy of StockAdjustment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockAdjustmentImplCopyWith<_$StockAdjustmentImpl> get copyWith =>
      __$$StockAdjustmentImplCopyWithImpl<_$StockAdjustmentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StockAdjustmentImplToJson(this);
  }
}

abstract class _StockAdjustment implements StockAdjustment {
  const factory _StockAdjustment({
    required final double quantity,
    required final String operation,
  }) = _$StockAdjustmentImpl;

  factory _StockAdjustment.fromJson(Map<String, dynamic> json) =
      _$StockAdjustmentImpl.fromJson;

  @override
  double get quantity;
  @override
  String get operation;

  /// Create a copy of StockAdjustment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockAdjustmentImplCopyWith<_$StockAdjustmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedStatistics _$FeedStatisticsFromJson(Map<String, dynamic> json) {
  return _FeedStatistics.fromJson(json);
}

/// @nodoc
mixin _$FeedStatistics {
  @JsonKey(name: 'total_feeds')
  int get totalFeeds => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_type')
  FeedTypeStats get byType => throw _privateConstructorUsedError;
  @JsonKey(name: 'low_stock_count')
  int get lowStockCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'low_stock_items')
  List<LowStockItem> get lowStockItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_stock_value')
  double get totalStockValue => throw _privateConstructorUsedError;

  /// Serializes this FeedStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedStatisticsCopyWith<FeedStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedStatisticsCopyWith<$Res> {
  factory $FeedStatisticsCopyWith(
    FeedStatistics value,
    $Res Function(FeedStatistics) then,
  ) = _$FeedStatisticsCopyWithImpl<$Res, FeedStatistics>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_feeds') int totalFeeds,
    @JsonKey(name: 'by_type') FeedTypeStats byType,
    @JsonKey(name: 'low_stock_count') int lowStockCount,
    @JsonKey(name: 'low_stock_items') List<LowStockItem> lowStockItems,
    @JsonKey(name: 'total_stock_value') double totalStockValue,
  });

  $FeedTypeStatsCopyWith<$Res> get byType;
}

/// @nodoc
class _$FeedStatisticsCopyWithImpl<$Res, $Val extends FeedStatistics>
    implements $FeedStatisticsCopyWith<$Res> {
  _$FeedStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalFeeds = null,
    Object? byType = null,
    Object? lowStockCount = null,
    Object? lowStockItems = null,
    Object? totalStockValue = null,
  }) {
    return _then(
      _value.copyWith(
            totalFeeds: null == totalFeeds
                ? _value.totalFeeds
                : totalFeeds // ignore: cast_nullable_to_non_nullable
                      as int,
            byType: null == byType
                ? _value.byType
                : byType // ignore: cast_nullable_to_non_nullable
                      as FeedTypeStats,
            lowStockCount: null == lowStockCount
                ? _value.lowStockCount
                : lowStockCount // ignore: cast_nullable_to_non_nullable
                      as int,
            lowStockItems: null == lowStockItems
                ? _value.lowStockItems
                : lowStockItems // ignore: cast_nullable_to_non_nullable
                      as List<LowStockItem>,
            totalStockValue: null == totalStockValue
                ? _value.totalStockValue
                : totalStockValue // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }

  /// Create a copy of FeedStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeedTypeStatsCopyWith<$Res> get byType {
    return $FeedTypeStatsCopyWith<$Res>(_value.byType, (value) {
      return _then(_value.copyWith(byType: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FeedStatisticsImplCopyWith<$Res>
    implements $FeedStatisticsCopyWith<$Res> {
  factory _$$FeedStatisticsImplCopyWith(
    _$FeedStatisticsImpl value,
    $Res Function(_$FeedStatisticsImpl) then,
  ) = __$$FeedStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_feeds') int totalFeeds,
    @JsonKey(name: 'by_type') FeedTypeStats byType,
    @JsonKey(name: 'low_stock_count') int lowStockCount,
    @JsonKey(name: 'low_stock_items') List<LowStockItem> lowStockItems,
    @JsonKey(name: 'total_stock_value') double totalStockValue,
  });

  @override
  $FeedTypeStatsCopyWith<$Res> get byType;
}

/// @nodoc
class __$$FeedStatisticsImplCopyWithImpl<$Res>
    extends _$FeedStatisticsCopyWithImpl<$Res, _$FeedStatisticsImpl>
    implements _$$FeedStatisticsImplCopyWith<$Res> {
  __$$FeedStatisticsImplCopyWithImpl(
    _$FeedStatisticsImpl _value,
    $Res Function(_$FeedStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalFeeds = null,
    Object? byType = null,
    Object? lowStockCount = null,
    Object? lowStockItems = null,
    Object? totalStockValue = null,
  }) {
    return _then(
      _$FeedStatisticsImpl(
        totalFeeds: null == totalFeeds
            ? _value.totalFeeds
            : totalFeeds // ignore: cast_nullable_to_non_nullable
                  as int,
        byType: null == byType
            ? _value.byType
            : byType // ignore: cast_nullable_to_non_nullable
                  as FeedTypeStats,
        lowStockCount: null == lowStockCount
            ? _value.lowStockCount
            : lowStockCount // ignore: cast_nullable_to_non_nullable
                  as int,
        lowStockItems: null == lowStockItems
            ? _value._lowStockItems
            : lowStockItems // ignore: cast_nullable_to_non_nullable
                  as List<LowStockItem>,
        totalStockValue: null == totalStockValue
            ? _value.totalStockValue
            : totalStockValue // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedStatisticsImpl implements _FeedStatistics {
  const _$FeedStatisticsImpl({
    @JsonKey(name: 'total_feeds') required this.totalFeeds,
    @JsonKey(name: 'by_type') required this.byType,
    @JsonKey(name: 'low_stock_count') required this.lowStockCount,
    @JsonKey(name: 'low_stock_items')
    required final List<LowStockItem> lowStockItems,
    @JsonKey(name: 'total_stock_value') required this.totalStockValue,
  }) : _lowStockItems = lowStockItems;

  factory _$FeedStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedStatisticsImplFromJson(json);

  @override
  @JsonKey(name: 'total_feeds')
  final int totalFeeds;
  @override
  @JsonKey(name: 'by_type')
  final FeedTypeStats byType;
  @override
  @JsonKey(name: 'low_stock_count')
  final int lowStockCount;
  final List<LowStockItem> _lowStockItems;
  @override
  @JsonKey(name: 'low_stock_items')
  List<LowStockItem> get lowStockItems {
    if (_lowStockItems is EqualUnmodifiableListView) return _lowStockItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lowStockItems);
  }

  @override
  @JsonKey(name: 'total_stock_value')
  final double totalStockValue;

  @override
  String toString() {
    return 'FeedStatistics(totalFeeds: $totalFeeds, byType: $byType, lowStockCount: $lowStockCount, lowStockItems: $lowStockItems, totalStockValue: $totalStockValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedStatisticsImpl &&
            (identical(other.totalFeeds, totalFeeds) ||
                other.totalFeeds == totalFeeds) &&
            (identical(other.byType, byType) || other.byType == byType) &&
            (identical(other.lowStockCount, lowStockCount) ||
                other.lowStockCount == lowStockCount) &&
            const DeepCollectionEquality().equals(
              other._lowStockItems,
              _lowStockItems,
            ) &&
            (identical(other.totalStockValue, totalStockValue) ||
                other.totalStockValue == totalStockValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalFeeds,
    byType,
    lowStockCount,
    const DeepCollectionEquality().hash(_lowStockItems),
    totalStockValue,
  );

  /// Create a copy of FeedStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedStatisticsImplCopyWith<_$FeedStatisticsImpl> get copyWith =>
      __$$FeedStatisticsImplCopyWithImpl<_$FeedStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedStatisticsImplToJson(this);
  }
}

abstract class _FeedStatistics implements FeedStatistics {
  const factory _FeedStatistics({
    @JsonKey(name: 'total_feeds') required final int totalFeeds,
    @JsonKey(name: 'by_type') required final FeedTypeStats byType,
    @JsonKey(name: 'low_stock_count') required final int lowStockCount,
    @JsonKey(name: 'low_stock_items')
    required final List<LowStockItem> lowStockItems,
    @JsonKey(name: 'total_stock_value') required final double totalStockValue,
  }) = _$FeedStatisticsImpl;

  factory _FeedStatistics.fromJson(Map<String, dynamic> json) =
      _$FeedStatisticsImpl.fromJson;

  @override
  @JsonKey(name: 'total_feeds')
  int get totalFeeds;
  @override
  @JsonKey(name: 'by_type')
  FeedTypeStats get byType;
  @override
  @JsonKey(name: 'low_stock_count')
  int get lowStockCount;
  @override
  @JsonKey(name: 'low_stock_items')
  List<LowStockItem> get lowStockItems;
  @override
  @JsonKey(name: 'total_stock_value')
  double get totalStockValue;

  /// Create a copy of FeedStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedStatisticsImplCopyWith<_$FeedStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedTypeStats _$FeedTypeStatsFromJson(Map<String, dynamic> json) {
  return _FeedTypeStats.fromJson(json);
}

/// @nodoc
mixin _$FeedTypeStats {
  @JsonKey(defaultValue: 0)
  int get pellets => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0)
  int get hay => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0)
  int get vegetables => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0)
  int get grain => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0)
  int get supplements => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0)
  int get other => throw _privateConstructorUsedError;

  /// Serializes this FeedTypeStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedTypeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedTypeStatsCopyWith<FeedTypeStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedTypeStatsCopyWith<$Res> {
  factory $FeedTypeStatsCopyWith(
    FeedTypeStats value,
    $Res Function(FeedTypeStats) then,
  ) = _$FeedTypeStatsCopyWithImpl<$Res, FeedTypeStats>;
  @useResult
  $Res call({
    @JsonKey(defaultValue: 0) int pellets,
    @JsonKey(defaultValue: 0) int hay,
    @JsonKey(defaultValue: 0) int vegetables,
    @JsonKey(defaultValue: 0) int grain,
    @JsonKey(defaultValue: 0) int supplements,
    @JsonKey(defaultValue: 0) int other,
  });
}

/// @nodoc
class _$FeedTypeStatsCopyWithImpl<$Res, $Val extends FeedTypeStats>
    implements $FeedTypeStatsCopyWith<$Res> {
  _$FeedTypeStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedTypeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pellets = null,
    Object? hay = null,
    Object? vegetables = null,
    Object? grain = null,
    Object? supplements = null,
    Object? other = null,
  }) {
    return _then(
      _value.copyWith(
            pellets: null == pellets
                ? _value.pellets
                : pellets // ignore: cast_nullable_to_non_nullable
                      as int,
            hay: null == hay
                ? _value.hay
                : hay // ignore: cast_nullable_to_non_nullable
                      as int,
            vegetables: null == vegetables
                ? _value.vegetables
                : vegetables // ignore: cast_nullable_to_non_nullable
                      as int,
            grain: null == grain
                ? _value.grain
                : grain // ignore: cast_nullable_to_non_nullable
                      as int,
            supplements: null == supplements
                ? _value.supplements
                : supplements // ignore: cast_nullable_to_non_nullable
                      as int,
            other: null == other
                ? _value.other
                : other // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedTypeStatsImplCopyWith<$Res>
    implements $FeedTypeStatsCopyWith<$Res> {
  factory _$$FeedTypeStatsImplCopyWith(
    _$FeedTypeStatsImpl value,
    $Res Function(_$FeedTypeStatsImpl) then,
  ) = __$$FeedTypeStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(defaultValue: 0) int pellets,
    @JsonKey(defaultValue: 0) int hay,
    @JsonKey(defaultValue: 0) int vegetables,
    @JsonKey(defaultValue: 0) int grain,
    @JsonKey(defaultValue: 0) int supplements,
    @JsonKey(defaultValue: 0) int other,
  });
}

/// @nodoc
class __$$FeedTypeStatsImplCopyWithImpl<$Res>
    extends _$FeedTypeStatsCopyWithImpl<$Res, _$FeedTypeStatsImpl>
    implements _$$FeedTypeStatsImplCopyWith<$Res> {
  __$$FeedTypeStatsImplCopyWithImpl(
    _$FeedTypeStatsImpl _value,
    $Res Function(_$FeedTypeStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedTypeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pellets = null,
    Object? hay = null,
    Object? vegetables = null,
    Object? grain = null,
    Object? supplements = null,
    Object? other = null,
  }) {
    return _then(
      _$FeedTypeStatsImpl(
        pellets: null == pellets
            ? _value.pellets
            : pellets // ignore: cast_nullable_to_non_nullable
                  as int,
        hay: null == hay
            ? _value.hay
            : hay // ignore: cast_nullable_to_non_nullable
                  as int,
        vegetables: null == vegetables
            ? _value.vegetables
            : vegetables // ignore: cast_nullable_to_non_nullable
                  as int,
        grain: null == grain
            ? _value.grain
            : grain // ignore: cast_nullable_to_non_nullable
                  as int,
        supplements: null == supplements
            ? _value.supplements
            : supplements // ignore: cast_nullable_to_non_nullable
                  as int,
        other: null == other
            ? _value.other
            : other // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedTypeStatsImpl implements _FeedTypeStats {
  const _$FeedTypeStatsImpl({
    @JsonKey(defaultValue: 0) required this.pellets,
    @JsonKey(defaultValue: 0) required this.hay,
    @JsonKey(defaultValue: 0) required this.vegetables,
    @JsonKey(defaultValue: 0) required this.grain,
    @JsonKey(defaultValue: 0) required this.supplements,
    @JsonKey(defaultValue: 0) required this.other,
  });

  factory _$FeedTypeStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedTypeStatsImplFromJson(json);

  @override
  @JsonKey(defaultValue: 0)
  final int pellets;
  @override
  @JsonKey(defaultValue: 0)
  final int hay;
  @override
  @JsonKey(defaultValue: 0)
  final int vegetables;
  @override
  @JsonKey(defaultValue: 0)
  final int grain;
  @override
  @JsonKey(defaultValue: 0)
  final int supplements;
  @override
  @JsonKey(defaultValue: 0)
  final int other;

  @override
  String toString() {
    return 'FeedTypeStats(pellets: $pellets, hay: $hay, vegetables: $vegetables, grain: $grain, supplements: $supplements, other: $other)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedTypeStatsImpl &&
            (identical(other.pellets, pellets) || other.pellets == pellets) &&
            (identical(other.hay, hay) || other.hay == hay) &&
            (identical(other.vegetables, vegetables) ||
                other.vegetables == vegetables) &&
            (identical(other.grain, grain) || other.grain == grain) &&
            (identical(other.supplements, supplements) ||
                other.supplements == supplements) &&
            (identical(other.other, this.other) || other.other == this.other));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pellets,
    hay,
    vegetables,
    grain,
    supplements,
    other,
  );

  /// Create a copy of FeedTypeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedTypeStatsImplCopyWith<_$FeedTypeStatsImpl> get copyWith =>
      __$$FeedTypeStatsImplCopyWithImpl<_$FeedTypeStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedTypeStatsImplToJson(this);
  }
}

abstract class _FeedTypeStats implements FeedTypeStats {
  const factory _FeedTypeStats({
    @JsonKey(defaultValue: 0) required final int pellets,
    @JsonKey(defaultValue: 0) required final int hay,
    @JsonKey(defaultValue: 0) required final int vegetables,
    @JsonKey(defaultValue: 0) required final int grain,
    @JsonKey(defaultValue: 0) required final int supplements,
    @JsonKey(defaultValue: 0) required final int other,
  }) = _$FeedTypeStatsImpl;

  factory _FeedTypeStats.fromJson(Map<String, dynamic> json) =
      _$FeedTypeStatsImpl.fromJson;

  @override
  @JsonKey(defaultValue: 0)
  int get pellets;
  @override
  @JsonKey(defaultValue: 0)
  int get hay;
  @override
  @JsonKey(defaultValue: 0)
  int get vegetables;
  @override
  @JsonKey(defaultValue: 0)
  int get grain;
  @override
  @JsonKey(defaultValue: 0)
  int get supplements;
  @override
  @JsonKey(defaultValue: 0)
  int get other;

  /// Create a copy of FeedTypeStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedTypeStatsImplCopyWith<_$FeedTypeStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LowStockItem _$LowStockItemFromJson(Map<String, dynamic> json) {
  return _LowStockItem.fromJson(json);
}

/// @nodoc
mixin _$LowStockItem {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_stock')
  @DoubleConverter()
  double get currentStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_stock')
  @DoubleConverter()
  double get minStock => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;

  /// Serializes this LowStockItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LowStockItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LowStockItemCopyWith<LowStockItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LowStockItemCopyWith<$Res> {
  factory $LowStockItemCopyWith(
    LowStockItem value,
    $Res Function(LowStockItem) then,
  ) = _$LowStockItemCopyWithImpl<$Res, LowStockItem>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String name,
    @JsonKey(name: 'current_stock') @DoubleConverter() double currentStock,
    @JsonKey(name: 'min_stock') @DoubleConverter() double minStock,
    String unit,
  });
}

/// @nodoc
class _$LowStockItemCopyWithImpl<$Res, $Val extends LowStockItem>
    implements $LowStockItemCopyWith<$Res> {
  _$LowStockItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LowStockItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? currentStock = null,
    Object? minStock = null,
    Object? unit = null,
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
            currentStock: null == currentStock
                ? _value.currentStock
                : currentStock // ignore: cast_nullable_to_non_nullable
                      as double,
            minStock: null == minStock
                ? _value.minStock
                : minStock // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LowStockItemImplCopyWith<$Res>
    implements $LowStockItemCopyWith<$Res> {
  factory _$$LowStockItemImplCopyWith(
    _$LowStockItemImpl value,
    $Res Function(_$LowStockItemImpl) then,
  ) = __$$LowStockItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String name,
    @JsonKey(name: 'current_stock') @DoubleConverter() double currentStock,
    @JsonKey(name: 'min_stock') @DoubleConverter() double minStock,
    String unit,
  });
}

/// @nodoc
class __$$LowStockItemImplCopyWithImpl<$Res>
    extends _$LowStockItemCopyWithImpl<$Res, _$LowStockItemImpl>
    implements _$$LowStockItemImplCopyWith<$Res> {
  __$$LowStockItemImplCopyWithImpl(
    _$LowStockItemImpl _value,
    $Res Function(_$LowStockItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LowStockItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? currentStock = null,
    Object? minStock = null,
    Object? unit = null,
  }) {
    return _then(
      _$LowStockItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        currentStock: null == currentStock
            ? _value.currentStock
            : currentStock // ignore: cast_nullable_to_non_nullable
                  as double,
        minStock: null == minStock
            ? _value.minStock
            : minStock // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LowStockItemImpl implements _LowStockItem {
  const _$LowStockItemImpl({
    @IntConverter() required this.id,
    required this.name,
    @JsonKey(name: 'current_stock')
    @DoubleConverter()
    required this.currentStock,
    @JsonKey(name: 'min_stock') @DoubleConverter() required this.minStock,
    required this.unit,
  });

  factory _$LowStockItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LowStockItemImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'current_stock')
  @DoubleConverter()
  final double currentStock;
  @override
  @JsonKey(name: 'min_stock')
  @DoubleConverter()
  final double minStock;
  @override
  final String unit;

  @override
  String toString() {
    return 'LowStockItem(id: $id, name: $name, currentStock: $currentStock, minStock: $minStock, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LowStockItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.minStock, minStock) ||
                other.minStock == minStock) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, currentStock, minStock, unit);

  /// Create a copy of LowStockItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LowStockItemImplCopyWith<_$LowStockItemImpl> get copyWith =>
      __$$LowStockItemImplCopyWithImpl<_$LowStockItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LowStockItemImplToJson(this);
  }
}

abstract class _LowStockItem implements LowStockItem {
  const factory _LowStockItem({
    @IntConverter() required final int id,
    required final String name,
    @JsonKey(name: 'current_stock')
    @DoubleConverter()
    required final double currentStock,
    @JsonKey(name: 'min_stock')
    @DoubleConverter()
    required final double minStock,
    required final String unit,
  }) = _$LowStockItemImpl;

  factory _LowStockItem.fromJson(Map<String, dynamic> json) =
      _$LowStockItemImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'current_stock')
  @DoubleConverter()
  double get currentStock;
  @override
  @JsonKey(name: 'min_stock')
  @DoubleConverter()
  double get minStock;
  @override
  String get unit;

  /// Create a copy of LowStockItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LowStockItemImplCopyWith<_$LowStockItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
