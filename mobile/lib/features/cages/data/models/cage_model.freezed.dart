// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cage_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CageModel _$CageModelFromJson(Map<String, dynamic> json) {
  return _CageModel.fromJson(json);
}

/// @nodoc
mixin _$CageModel {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get number => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // single, group, maternity
  String? get size => throw _privateConstructorUsedError;
  @IntConverter()
  int get capacity => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String get condition =>
      throw _privateConstructorUsedError; // good, needs_repair, broken
  @JsonKey(name: 'last_cleaned_at')
  DateTime? get lastCleanedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Related data
  List<RabbitModel>? get rabbits => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_occupancy')
  @IntConverter()
  int? get currentOccupancy => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_full')
  bool? get isFull => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool? get isAvailable => throw _privateConstructorUsedError;

  /// Serializes this CageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CageModelCopyWith<CageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CageModelCopyWith<$Res> {
  factory $CageModelCopyWith(CageModel value, $Res Function(CageModel) then) =
      _$CageModelCopyWithImpl<$Res, CageModel>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String number,
    String type,
    String? size,
    @IntConverter() int capacity,
    String? location,
    String condition,
    @JsonKey(name: 'last_cleaned_at') DateTime? lastCleanedAt,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    List<RabbitModel>? rabbits,
    @JsonKey(name: 'current_occupancy') @IntConverter() int? currentOccupancy,
    @JsonKey(name: 'is_full') bool? isFull,
    @JsonKey(name: 'is_available') bool? isAvailable,
  });
}

/// @nodoc
class _$CageModelCopyWithImpl<$Res, $Val extends CageModel>
    implements $CageModelCopyWith<$Res> {
  _$CageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? type = null,
    Object? size = freezed,
    Object? capacity = null,
    Object? location = freezed,
    Object? condition = null,
    Object? lastCleanedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? rabbits = freezed,
    Object? currentOccupancy = freezed,
    Object? isFull = freezed,
    Object? isAvailable = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            size: freezed == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as String?,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            condition: null == condition
                ? _value.condition
                : condition // ignore: cast_nullable_to_non_nullable
                      as String,
            lastCleanedAt: freezed == lastCleanedAt
                ? _value.lastCleanedAt
                : lastCleanedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
            rabbits: freezed == rabbits
                ? _value.rabbits
                : rabbits // ignore: cast_nullable_to_non_nullable
                      as List<RabbitModel>?,
            currentOccupancy: freezed == currentOccupancy
                ? _value.currentOccupancy
                : currentOccupancy // ignore: cast_nullable_to_non_nullable
                      as int?,
            isFull: freezed == isFull
                ? _value.isFull
                : isFull // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isAvailable: freezed == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CageModelImplCopyWith<$Res>
    implements $CageModelCopyWith<$Res> {
  factory _$$CageModelImplCopyWith(
    _$CageModelImpl value,
    $Res Function(_$CageModelImpl) then,
  ) = __$$CageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String number,
    String type,
    String? size,
    @IntConverter() int capacity,
    String? location,
    String condition,
    @JsonKey(name: 'last_cleaned_at') DateTime? lastCleanedAt,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    List<RabbitModel>? rabbits,
    @JsonKey(name: 'current_occupancy') @IntConverter() int? currentOccupancy,
    @JsonKey(name: 'is_full') bool? isFull,
    @JsonKey(name: 'is_available') bool? isAvailable,
  });
}

/// @nodoc
class __$$CageModelImplCopyWithImpl<$Res>
    extends _$CageModelCopyWithImpl<$Res, _$CageModelImpl>
    implements _$$CageModelImplCopyWith<$Res> {
  __$$CageModelImplCopyWithImpl(
    _$CageModelImpl _value,
    $Res Function(_$CageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? type = null,
    Object? size = freezed,
    Object? capacity = null,
    Object? location = freezed,
    Object? condition = null,
    Object? lastCleanedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? rabbits = freezed,
    Object? currentOccupancy = freezed,
    Object? isFull = freezed,
    Object? isAvailable = freezed,
  }) {
    return _then(
      _$CageModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        size: freezed == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as String?,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        condition: null == condition
            ? _value.condition
            : condition // ignore: cast_nullable_to_non_nullable
                  as String,
        lastCleanedAt: freezed == lastCleanedAt
            ? _value.lastCleanedAt
            : lastCleanedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
        rabbits: freezed == rabbits
            ? _value._rabbits
            : rabbits // ignore: cast_nullable_to_non_nullable
                  as List<RabbitModel>?,
        currentOccupancy: freezed == currentOccupancy
            ? _value.currentOccupancy
            : currentOccupancy // ignore: cast_nullable_to_non_nullable
                  as int?,
        isFull: freezed == isFull
            ? _value.isFull
            : isFull // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isAvailable: freezed == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CageModelImpl implements _CageModel {
  const _$CageModelImpl({
    @IntConverter() required this.id,
    required this.number,
    required this.type,
    this.size,
    @IntConverter() required this.capacity,
    this.location,
    required this.condition,
    @JsonKey(name: 'last_cleaned_at') this.lastCleanedAt,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    final List<RabbitModel>? rabbits,
    @JsonKey(name: 'current_occupancy') @IntConverter() this.currentOccupancy,
    @JsonKey(name: 'is_full') this.isFull,
    @JsonKey(name: 'is_available') this.isAvailable,
  }) : _rabbits = rabbits;

  factory _$CageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CageModelImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String number;
  @override
  final String type;
  // single, group, maternity
  @override
  final String? size;
  @override
  @IntConverter()
  final int capacity;
  @override
  final String? location;
  @override
  final String condition;
  // good, needs_repair, broken
  @override
  @JsonKey(name: 'last_cleaned_at')
  final DateTime? lastCleanedAt;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  // Related data
  final List<RabbitModel>? _rabbits;
  // Related data
  @override
  List<RabbitModel>? get rabbits {
    final value = _rabbits;
    if (value == null) return null;
    if (_rabbits is EqualUnmodifiableListView) return _rabbits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'current_occupancy')
  @IntConverter()
  final int? currentOccupancy;
  @override
  @JsonKey(name: 'is_full')
  final bool? isFull;
  @override
  @JsonKey(name: 'is_available')
  final bool? isAvailable;

  @override
  String toString() {
    return 'CageModel(id: $id, number: $number, type: $type, size: $size, capacity: $capacity, location: $location, condition: $condition, lastCleanedAt: $lastCleanedAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, rabbits: $rabbits, currentOccupancy: $currentOccupancy, isFull: $isFull, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.lastCleanedAt, lastCleanedAt) ||
                other.lastCleanedAt == lastCleanedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._rabbits, _rabbits) &&
            (identical(other.currentOccupancy, currentOccupancy) ||
                other.currentOccupancy == currentOccupancy) &&
            (identical(other.isFull, isFull) || other.isFull == isFull) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    number,
    type,
    size,
    capacity,
    location,
    condition,
    lastCleanedAt,
    notes,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_rabbits),
    currentOccupancy,
    isFull,
    isAvailable,
  );

  /// Create a copy of CageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CageModelImplCopyWith<_$CageModelImpl> get copyWith =>
      __$$CageModelImplCopyWithImpl<_$CageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CageModelImplToJson(this);
  }
}

abstract class _CageModel implements CageModel {
  const factory _CageModel({
    @IntConverter() required final int id,
    required final String number,
    required final String type,
    final String? size,
    @IntConverter() required final int capacity,
    final String? location,
    required final String condition,
    @JsonKey(name: 'last_cleaned_at') final DateTime? lastCleanedAt,
    final String? notes,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    final List<RabbitModel>? rabbits,
    @JsonKey(name: 'current_occupancy')
    @IntConverter()
    final int? currentOccupancy,
    @JsonKey(name: 'is_full') final bool? isFull,
    @JsonKey(name: 'is_available') final bool? isAvailable,
  }) = _$CageModelImpl;

  factory _CageModel.fromJson(Map<String, dynamic> json) =
      _$CageModelImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get number;
  @override
  String get type; // single, group, maternity
  @override
  String? get size;
  @override
  @IntConverter()
  int get capacity;
  @override
  String? get location;
  @override
  String get condition; // good, needs_repair, broken
  @override
  @JsonKey(name: 'last_cleaned_at')
  DateTime? get lastCleanedAt;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt; // Related data
  @override
  List<RabbitModel>? get rabbits;
  @override
  @JsonKey(name: 'current_occupancy')
  @IntConverter()
  int? get currentOccupancy;
  @override
  @JsonKey(name: 'is_full')
  bool? get isFull;
  @override
  @JsonKey(name: 'is_available')
  bool? get isAvailable;

  /// Create a copy of CageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CageModelImplCopyWith<_$CageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CageStatistics _$CageStatisticsFromJson(Map<String, dynamic> json) {
  return _CageStatistics.fromJson(json);
}

/// @nodoc
mixin _$CageStatistics {
  @JsonKey(name: 'total_cages')
  @IntConverter()
  int get totalCages => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_type')
  CageTypeStats get byType => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_condition')
  CageConditionStats get byCondition => throw _privateConstructorUsedError;
  CageOccupancyStats get occupancy => throw _privateConstructorUsedError;

  /// Serializes this CageStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CageStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CageStatisticsCopyWith<CageStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CageStatisticsCopyWith<$Res> {
  factory $CageStatisticsCopyWith(
    CageStatistics value,
    $Res Function(CageStatistics) then,
  ) = _$CageStatisticsCopyWithImpl<$Res, CageStatistics>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_cages') @IntConverter() int totalCages,
    @JsonKey(name: 'by_type') CageTypeStats byType,
    @JsonKey(name: 'by_condition') CageConditionStats byCondition,
    CageOccupancyStats occupancy,
  });

  $CageTypeStatsCopyWith<$Res> get byType;
  $CageConditionStatsCopyWith<$Res> get byCondition;
  $CageOccupancyStatsCopyWith<$Res> get occupancy;
}

/// @nodoc
class _$CageStatisticsCopyWithImpl<$Res, $Val extends CageStatistics>
    implements $CageStatisticsCopyWith<$Res> {
  _$CageStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CageStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCages = null,
    Object? byType = null,
    Object? byCondition = null,
    Object? occupancy = null,
  }) {
    return _then(
      _value.copyWith(
            totalCages: null == totalCages
                ? _value.totalCages
                : totalCages // ignore: cast_nullable_to_non_nullable
                      as int,
            byType: null == byType
                ? _value.byType
                : byType // ignore: cast_nullable_to_non_nullable
                      as CageTypeStats,
            byCondition: null == byCondition
                ? _value.byCondition
                : byCondition // ignore: cast_nullable_to_non_nullable
                      as CageConditionStats,
            occupancy: null == occupancy
                ? _value.occupancy
                : occupancy // ignore: cast_nullable_to_non_nullable
                      as CageOccupancyStats,
          )
          as $Val,
    );
  }

  /// Create a copy of CageStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CageTypeStatsCopyWith<$Res> get byType {
    return $CageTypeStatsCopyWith<$Res>(_value.byType, (value) {
      return _then(_value.copyWith(byType: value) as $Val);
    });
  }

  /// Create a copy of CageStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CageConditionStatsCopyWith<$Res> get byCondition {
    return $CageConditionStatsCopyWith<$Res>(_value.byCondition, (value) {
      return _then(_value.copyWith(byCondition: value) as $Val);
    });
  }

  /// Create a copy of CageStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CageOccupancyStatsCopyWith<$Res> get occupancy {
    return $CageOccupancyStatsCopyWith<$Res>(_value.occupancy, (value) {
      return _then(_value.copyWith(occupancy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CageStatisticsImplCopyWith<$Res>
    implements $CageStatisticsCopyWith<$Res> {
  factory _$$CageStatisticsImplCopyWith(
    _$CageStatisticsImpl value,
    $Res Function(_$CageStatisticsImpl) then,
  ) = __$$CageStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_cages') @IntConverter() int totalCages,
    @JsonKey(name: 'by_type') CageTypeStats byType,
    @JsonKey(name: 'by_condition') CageConditionStats byCondition,
    CageOccupancyStats occupancy,
  });

  @override
  $CageTypeStatsCopyWith<$Res> get byType;
  @override
  $CageConditionStatsCopyWith<$Res> get byCondition;
  @override
  $CageOccupancyStatsCopyWith<$Res> get occupancy;
}

/// @nodoc
class __$$CageStatisticsImplCopyWithImpl<$Res>
    extends _$CageStatisticsCopyWithImpl<$Res, _$CageStatisticsImpl>
    implements _$$CageStatisticsImplCopyWith<$Res> {
  __$$CageStatisticsImplCopyWithImpl(
    _$CageStatisticsImpl _value,
    $Res Function(_$CageStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CageStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCages = null,
    Object? byType = null,
    Object? byCondition = null,
    Object? occupancy = null,
  }) {
    return _then(
      _$CageStatisticsImpl(
        totalCages: null == totalCages
            ? _value.totalCages
            : totalCages // ignore: cast_nullable_to_non_nullable
                  as int,
        byType: null == byType
            ? _value.byType
            : byType // ignore: cast_nullable_to_non_nullable
                  as CageTypeStats,
        byCondition: null == byCondition
            ? _value.byCondition
            : byCondition // ignore: cast_nullable_to_non_nullable
                  as CageConditionStats,
        occupancy: null == occupancy
            ? _value.occupancy
            : occupancy // ignore: cast_nullable_to_non_nullable
                  as CageOccupancyStats,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CageStatisticsImpl implements _CageStatistics {
  const _$CageStatisticsImpl({
    @JsonKey(name: 'total_cages') @IntConverter() required this.totalCages,
    @JsonKey(name: 'by_type') required this.byType,
    @JsonKey(name: 'by_condition') required this.byCondition,
    required this.occupancy,
  });

  factory _$CageStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CageStatisticsImplFromJson(json);

  @override
  @JsonKey(name: 'total_cages')
  @IntConverter()
  final int totalCages;
  @override
  @JsonKey(name: 'by_type')
  final CageTypeStats byType;
  @override
  @JsonKey(name: 'by_condition')
  final CageConditionStats byCondition;
  @override
  final CageOccupancyStats occupancy;

  @override
  String toString() {
    return 'CageStatistics(totalCages: $totalCages, byType: $byType, byCondition: $byCondition, occupancy: $occupancy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CageStatisticsImpl &&
            (identical(other.totalCages, totalCages) ||
                other.totalCages == totalCages) &&
            (identical(other.byType, byType) || other.byType == byType) &&
            (identical(other.byCondition, byCondition) ||
                other.byCondition == byCondition) &&
            (identical(other.occupancy, occupancy) ||
                other.occupancy == occupancy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalCages, byType, byCondition, occupancy);

  /// Create a copy of CageStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CageStatisticsImplCopyWith<_$CageStatisticsImpl> get copyWith =>
      __$$CageStatisticsImplCopyWithImpl<_$CageStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CageStatisticsImplToJson(this);
  }
}

abstract class _CageStatistics implements CageStatistics {
  const factory _CageStatistics({
    @JsonKey(name: 'total_cages') @IntConverter() required final int totalCages,
    @JsonKey(name: 'by_type') required final CageTypeStats byType,
    @JsonKey(name: 'by_condition')
    required final CageConditionStats byCondition,
    required final CageOccupancyStats occupancy,
  }) = _$CageStatisticsImpl;

  factory _CageStatistics.fromJson(Map<String, dynamic> json) =
      _$CageStatisticsImpl.fromJson;

  @override
  @JsonKey(name: 'total_cages')
  @IntConverter()
  int get totalCages;
  @override
  @JsonKey(name: 'by_type')
  CageTypeStats get byType;
  @override
  @JsonKey(name: 'by_condition')
  CageConditionStats get byCondition;
  @override
  CageOccupancyStats get occupancy;

  /// Create a copy of CageStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CageStatisticsImplCopyWith<_$CageStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CageTypeStats _$CageTypeStatsFromJson(Map<String, dynamic> json) {
  return _CageTypeStats.fromJson(json);
}

/// @nodoc
mixin _$CageTypeStats {
  @IntConverter()
  int get single => throw _privateConstructorUsedError;
  @IntConverter()
  int get group => throw _privateConstructorUsedError;
  @IntConverter()
  int get maternity => throw _privateConstructorUsedError;

  /// Serializes this CageTypeStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CageTypeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CageTypeStatsCopyWith<CageTypeStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CageTypeStatsCopyWith<$Res> {
  factory $CageTypeStatsCopyWith(
    CageTypeStats value,
    $Res Function(CageTypeStats) then,
  ) = _$CageTypeStatsCopyWithImpl<$Res, CageTypeStats>;
  @useResult
  $Res call({
    @IntConverter() int single,
    @IntConverter() int group,
    @IntConverter() int maternity,
  });
}

/// @nodoc
class _$CageTypeStatsCopyWithImpl<$Res, $Val extends CageTypeStats>
    implements $CageTypeStatsCopyWith<$Res> {
  _$CageTypeStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CageTypeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? single = null,
    Object? group = null,
    Object? maternity = null,
  }) {
    return _then(
      _value.copyWith(
            single: null == single
                ? _value.single
                : single // ignore: cast_nullable_to_non_nullable
                      as int,
            group: null == group
                ? _value.group
                : group // ignore: cast_nullable_to_non_nullable
                      as int,
            maternity: null == maternity
                ? _value.maternity
                : maternity // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CageTypeStatsImplCopyWith<$Res>
    implements $CageTypeStatsCopyWith<$Res> {
  factory _$$CageTypeStatsImplCopyWith(
    _$CageTypeStatsImpl value,
    $Res Function(_$CageTypeStatsImpl) then,
  ) = __$$CageTypeStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int single,
    @IntConverter() int group,
    @IntConverter() int maternity,
  });
}

/// @nodoc
class __$$CageTypeStatsImplCopyWithImpl<$Res>
    extends _$CageTypeStatsCopyWithImpl<$Res, _$CageTypeStatsImpl>
    implements _$$CageTypeStatsImplCopyWith<$Res> {
  __$$CageTypeStatsImplCopyWithImpl(
    _$CageTypeStatsImpl _value,
    $Res Function(_$CageTypeStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CageTypeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? single = null,
    Object? group = null,
    Object? maternity = null,
  }) {
    return _then(
      _$CageTypeStatsImpl(
        single: null == single
            ? _value.single
            : single // ignore: cast_nullable_to_non_nullable
                  as int,
        group: null == group
            ? _value.group
            : group // ignore: cast_nullable_to_non_nullable
                  as int,
        maternity: null == maternity
            ? _value.maternity
            : maternity // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CageTypeStatsImpl implements _CageTypeStats {
  const _$CageTypeStatsImpl({
    @IntConverter() required this.single,
    @IntConverter() required this.group,
    @IntConverter() required this.maternity,
  });

  factory _$CageTypeStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CageTypeStatsImplFromJson(json);

  @override
  @IntConverter()
  final int single;
  @override
  @IntConverter()
  final int group;
  @override
  @IntConverter()
  final int maternity;

  @override
  String toString() {
    return 'CageTypeStats(single: $single, group: $group, maternity: $maternity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CageTypeStatsImpl &&
            (identical(other.single, single) || other.single == single) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.maternity, maternity) ||
                other.maternity == maternity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, single, group, maternity);

  /// Create a copy of CageTypeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CageTypeStatsImplCopyWith<_$CageTypeStatsImpl> get copyWith =>
      __$$CageTypeStatsImplCopyWithImpl<_$CageTypeStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CageTypeStatsImplToJson(this);
  }
}

abstract class _CageTypeStats implements CageTypeStats {
  const factory _CageTypeStats({
    @IntConverter() required final int single,
    @IntConverter() required final int group,
    @IntConverter() required final int maternity,
  }) = _$CageTypeStatsImpl;

  factory _CageTypeStats.fromJson(Map<String, dynamic> json) =
      _$CageTypeStatsImpl.fromJson;

  @override
  @IntConverter()
  int get single;
  @override
  @IntConverter()
  int get group;
  @override
  @IntConverter()
  int get maternity;

  /// Create a copy of CageTypeStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CageTypeStatsImplCopyWith<_$CageTypeStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CageConditionStats _$CageConditionStatsFromJson(Map<String, dynamic> json) {
  return _CageConditionStats.fromJson(json);
}

/// @nodoc
mixin _$CageConditionStats {
  @IntConverter()
  int get good => throw _privateConstructorUsedError;
  @JsonKey(name: 'needs_repair')
  @IntConverter()
  int get needsRepair => throw _privateConstructorUsedError;
  @IntConverter()
  int get broken => throw _privateConstructorUsedError;

  /// Serializes this CageConditionStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CageConditionStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CageConditionStatsCopyWith<CageConditionStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CageConditionStatsCopyWith<$Res> {
  factory $CageConditionStatsCopyWith(
    CageConditionStats value,
    $Res Function(CageConditionStats) then,
  ) = _$CageConditionStatsCopyWithImpl<$Res, CageConditionStats>;
  @useResult
  $Res call({
    @IntConverter() int good,
    @JsonKey(name: 'needs_repair') @IntConverter() int needsRepair,
    @IntConverter() int broken,
  });
}

/// @nodoc
class _$CageConditionStatsCopyWithImpl<$Res, $Val extends CageConditionStats>
    implements $CageConditionStatsCopyWith<$Res> {
  _$CageConditionStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CageConditionStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? good = null,
    Object? needsRepair = null,
    Object? broken = null,
  }) {
    return _then(
      _value.copyWith(
            good: null == good
                ? _value.good
                : good // ignore: cast_nullable_to_non_nullable
                      as int,
            needsRepair: null == needsRepair
                ? _value.needsRepair
                : needsRepair // ignore: cast_nullable_to_non_nullable
                      as int,
            broken: null == broken
                ? _value.broken
                : broken // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CageConditionStatsImplCopyWith<$Res>
    implements $CageConditionStatsCopyWith<$Res> {
  factory _$$CageConditionStatsImplCopyWith(
    _$CageConditionStatsImpl value,
    $Res Function(_$CageConditionStatsImpl) then,
  ) = __$$CageConditionStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int good,
    @JsonKey(name: 'needs_repair') @IntConverter() int needsRepair,
    @IntConverter() int broken,
  });
}

/// @nodoc
class __$$CageConditionStatsImplCopyWithImpl<$Res>
    extends _$CageConditionStatsCopyWithImpl<$Res, _$CageConditionStatsImpl>
    implements _$$CageConditionStatsImplCopyWith<$Res> {
  __$$CageConditionStatsImplCopyWithImpl(
    _$CageConditionStatsImpl _value,
    $Res Function(_$CageConditionStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CageConditionStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? good = null,
    Object? needsRepair = null,
    Object? broken = null,
  }) {
    return _then(
      _$CageConditionStatsImpl(
        good: null == good
            ? _value.good
            : good // ignore: cast_nullable_to_non_nullable
                  as int,
        needsRepair: null == needsRepair
            ? _value.needsRepair
            : needsRepair // ignore: cast_nullable_to_non_nullable
                  as int,
        broken: null == broken
            ? _value.broken
            : broken // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CageConditionStatsImpl implements _CageConditionStats {
  const _$CageConditionStatsImpl({
    @IntConverter() required this.good,
    @JsonKey(name: 'needs_repair') @IntConverter() required this.needsRepair,
    @IntConverter() required this.broken,
  });

  factory _$CageConditionStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CageConditionStatsImplFromJson(json);

  @override
  @IntConverter()
  final int good;
  @override
  @JsonKey(name: 'needs_repair')
  @IntConverter()
  final int needsRepair;
  @override
  @IntConverter()
  final int broken;

  @override
  String toString() {
    return 'CageConditionStats(good: $good, needsRepair: $needsRepair, broken: $broken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CageConditionStatsImpl &&
            (identical(other.good, good) || other.good == good) &&
            (identical(other.needsRepair, needsRepair) ||
                other.needsRepair == needsRepair) &&
            (identical(other.broken, broken) || other.broken == broken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, good, needsRepair, broken);

  /// Create a copy of CageConditionStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CageConditionStatsImplCopyWith<_$CageConditionStatsImpl> get copyWith =>
      __$$CageConditionStatsImplCopyWithImpl<_$CageConditionStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CageConditionStatsImplToJson(this);
  }
}

abstract class _CageConditionStats implements CageConditionStats {
  const factory _CageConditionStats({
    @IntConverter() required final int good,
    @JsonKey(name: 'needs_repair')
    @IntConverter()
    required final int needsRepair,
    @IntConverter() required final int broken,
  }) = _$CageConditionStatsImpl;

  factory _CageConditionStats.fromJson(Map<String, dynamic> json) =
      _$CageConditionStatsImpl.fromJson;

  @override
  @IntConverter()
  int get good;
  @override
  @JsonKey(name: 'needs_repair')
  @IntConverter()
  int get needsRepair;
  @override
  @IntConverter()
  int get broken;

  /// Create a copy of CageConditionStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CageConditionStatsImplCopyWith<_$CageConditionStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CageOccupancyStats _$CageOccupancyStatsFromJson(Map<String, dynamic> json) {
  return _CageOccupancyStats.fromJson(json);
}

/// @nodoc
mixin _$CageOccupancyStats {
  @JsonKey(name: 'total_capacity')
  @IntConverter()
  int get totalCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_occupancy')
  @IntConverter()
  int get currentOccupancy => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_spaces')
  @IntConverter()
  int get availableSpaces => throw _privateConstructorUsedError;
  @JsonKey(name: 'occupancy_rate')
  @IntConverter()
  int get occupancyRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_cages')
  @IntConverter()
  int get fullCages => throw _privateConstructorUsedError;
  @JsonKey(name: 'empty_cages')
  @IntConverter()
  int get emptyCages => throw _privateConstructorUsedError;

  /// Serializes this CageOccupancyStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CageOccupancyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CageOccupancyStatsCopyWith<CageOccupancyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CageOccupancyStatsCopyWith<$Res> {
  factory $CageOccupancyStatsCopyWith(
    CageOccupancyStats value,
    $Res Function(CageOccupancyStats) then,
  ) = _$CageOccupancyStatsCopyWithImpl<$Res, CageOccupancyStats>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_capacity') @IntConverter() int totalCapacity,
    @JsonKey(name: 'current_occupancy') @IntConverter() int currentOccupancy,
    @JsonKey(name: 'available_spaces') @IntConverter() int availableSpaces,
    @JsonKey(name: 'occupancy_rate') @IntConverter() int occupancyRate,
    @JsonKey(name: 'full_cages') @IntConverter() int fullCages,
    @JsonKey(name: 'empty_cages') @IntConverter() int emptyCages,
  });
}

/// @nodoc
class _$CageOccupancyStatsCopyWithImpl<$Res, $Val extends CageOccupancyStats>
    implements $CageOccupancyStatsCopyWith<$Res> {
  _$CageOccupancyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CageOccupancyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCapacity = null,
    Object? currentOccupancy = null,
    Object? availableSpaces = null,
    Object? occupancyRate = null,
    Object? fullCages = null,
    Object? emptyCages = null,
  }) {
    return _then(
      _value.copyWith(
            totalCapacity: null == totalCapacity
                ? _value.totalCapacity
                : totalCapacity // ignore: cast_nullable_to_non_nullable
                      as int,
            currentOccupancy: null == currentOccupancy
                ? _value.currentOccupancy
                : currentOccupancy // ignore: cast_nullable_to_non_nullable
                      as int,
            availableSpaces: null == availableSpaces
                ? _value.availableSpaces
                : availableSpaces // ignore: cast_nullable_to_non_nullable
                      as int,
            occupancyRate: null == occupancyRate
                ? _value.occupancyRate
                : occupancyRate // ignore: cast_nullable_to_non_nullable
                      as int,
            fullCages: null == fullCages
                ? _value.fullCages
                : fullCages // ignore: cast_nullable_to_non_nullable
                      as int,
            emptyCages: null == emptyCages
                ? _value.emptyCages
                : emptyCages // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CageOccupancyStatsImplCopyWith<$Res>
    implements $CageOccupancyStatsCopyWith<$Res> {
  factory _$$CageOccupancyStatsImplCopyWith(
    _$CageOccupancyStatsImpl value,
    $Res Function(_$CageOccupancyStatsImpl) then,
  ) = __$$CageOccupancyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_capacity') @IntConverter() int totalCapacity,
    @JsonKey(name: 'current_occupancy') @IntConverter() int currentOccupancy,
    @JsonKey(name: 'available_spaces') @IntConverter() int availableSpaces,
    @JsonKey(name: 'occupancy_rate') @IntConverter() int occupancyRate,
    @JsonKey(name: 'full_cages') @IntConverter() int fullCages,
    @JsonKey(name: 'empty_cages') @IntConverter() int emptyCages,
  });
}

/// @nodoc
class __$$CageOccupancyStatsImplCopyWithImpl<$Res>
    extends _$CageOccupancyStatsCopyWithImpl<$Res, _$CageOccupancyStatsImpl>
    implements _$$CageOccupancyStatsImplCopyWith<$Res> {
  __$$CageOccupancyStatsImplCopyWithImpl(
    _$CageOccupancyStatsImpl _value,
    $Res Function(_$CageOccupancyStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CageOccupancyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCapacity = null,
    Object? currentOccupancy = null,
    Object? availableSpaces = null,
    Object? occupancyRate = null,
    Object? fullCages = null,
    Object? emptyCages = null,
  }) {
    return _then(
      _$CageOccupancyStatsImpl(
        totalCapacity: null == totalCapacity
            ? _value.totalCapacity
            : totalCapacity // ignore: cast_nullable_to_non_nullable
                  as int,
        currentOccupancy: null == currentOccupancy
            ? _value.currentOccupancy
            : currentOccupancy // ignore: cast_nullable_to_non_nullable
                  as int,
        availableSpaces: null == availableSpaces
            ? _value.availableSpaces
            : availableSpaces // ignore: cast_nullable_to_non_nullable
                  as int,
        occupancyRate: null == occupancyRate
            ? _value.occupancyRate
            : occupancyRate // ignore: cast_nullable_to_non_nullable
                  as int,
        fullCages: null == fullCages
            ? _value.fullCages
            : fullCages // ignore: cast_nullable_to_non_nullable
                  as int,
        emptyCages: null == emptyCages
            ? _value.emptyCages
            : emptyCages // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CageOccupancyStatsImpl implements _CageOccupancyStats {
  const _$CageOccupancyStatsImpl({
    @JsonKey(name: 'total_capacity')
    @IntConverter()
    required this.totalCapacity,
    @JsonKey(name: 'current_occupancy')
    @IntConverter()
    required this.currentOccupancy,
    @JsonKey(name: 'available_spaces')
    @IntConverter()
    required this.availableSpaces,
    @JsonKey(name: 'occupancy_rate')
    @IntConverter()
    required this.occupancyRate,
    @JsonKey(name: 'full_cages') @IntConverter() required this.fullCages,
    @JsonKey(name: 'empty_cages') @IntConverter() required this.emptyCages,
  });

  factory _$CageOccupancyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CageOccupancyStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_capacity')
  @IntConverter()
  final int totalCapacity;
  @override
  @JsonKey(name: 'current_occupancy')
  @IntConverter()
  final int currentOccupancy;
  @override
  @JsonKey(name: 'available_spaces')
  @IntConverter()
  final int availableSpaces;
  @override
  @JsonKey(name: 'occupancy_rate')
  @IntConverter()
  final int occupancyRate;
  @override
  @JsonKey(name: 'full_cages')
  @IntConverter()
  final int fullCages;
  @override
  @JsonKey(name: 'empty_cages')
  @IntConverter()
  final int emptyCages;

  @override
  String toString() {
    return 'CageOccupancyStats(totalCapacity: $totalCapacity, currentOccupancy: $currentOccupancy, availableSpaces: $availableSpaces, occupancyRate: $occupancyRate, fullCages: $fullCages, emptyCages: $emptyCages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CageOccupancyStatsImpl &&
            (identical(other.totalCapacity, totalCapacity) ||
                other.totalCapacity == totalCapacity) &&
            (identical(other.currentOccupancy, currentOccupancy) ||
                other.currentOccupancy == currentOccupancy) &&
            (identical(other.availableSpaces, availableSpaces) ||
                other.availableSpaces == availableSpaces) &&
            (identical(other.occupancyRate, occupancyRate) ||
                other.occupancyRate == occupancyRate) &&
            (identical(other.fullCages, fullCages) ||
                other.fullCages == fullCages) &&
            (identical(other.emptyCages, emptyCages) ||
                other.emptyCages == emptyCages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalCapacity,
    currentOccupancy,
    availableSpaces,
    occupancyRate,
    fullCages,
    emptyCages,
  );

  /// Create a copy of CageOccupancyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CageOccupancyStatsImplCopyWith<_$CageOccupancyStatsImpl> get copyWith =>
      __$$CageOccupancyStatsImplCopyWithImpl<_$CageOccupancyStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CageOccupancyStatsImplToJson(this);
  }
}

abstract class _CageOccupancyStats implements CageOccupancyStats {
  const factory _CageOccupancyStats({
    @JsonKey(name: 'total_capacity')
    @IntConverter()
    required final int totalCapacity,
    @JsonKey(name: 'current_occupancy')
    @IntConverter()
    required final int currentOccupancy,
    @JsonKey(name: 'available_spaces')
    @IntConverter()
    required final int availableSpaces,
    @JsonKey(name: 'occupancy_rate')
    @IntConverter()
    required final int occupancyRate,
    @JsonKey(name: 'full_cages') @IntConverter() required final int fullCages,
    @JsonKey(name: 'empty_cages') @IntConverter() required final int emptyCages,
  }) = _$CageOccupancyStatsImpl;

  factory _CageOccupancyStats.fromJson(Map<String, dynamic> json) =
      _$CageOccupancyStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_capacity')
  @IntConverter()
  int get totalCapacity;
  @override
  @JsonKey(name: 'current_occupancy')
  @IntConverter()
  int get currentOccupancy;
  @override
  @JsonKey(name: 'available_spaces')
  @IntConverter()
  int get availableSpaces;
  @override
  @JsonKey(name: 'occupancy_rate')
  @IntConverter()
  int get occupancyRate;
  @override
  @JsonKey(name: 'full_cages')
  @IntConverter()
  int get fullCages;
  @override
  @JsonKey(name: 'empty_cages')
  @IntConverter()
  int get emptyCages;

  /// Create a copy of CageOccupancyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CageOccupancyStatsImplCopyWith<_$CageOccupancyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
