// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cage_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CageStatistics _$CageStatisticsFromJson(Map<String, dynamic> json) {
  return _CageStatistics.fromJson(json);
}

/// @nodoc
mixin _$CageStatistics {
  @JsonKey(name: 'total_cages')
  int get totalCages => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_type')
  Map<String, int> get byType => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_condition')
  Map<String, int> get byCondition => throw _privateConstructorUsedError;
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
    @JsonKey(name: 'total_cages') int totalCages,
    @JsonKey(name: 'by_type') Map<String, int> byType,
    @JsonKey(name: 'by_condition') Map<String, int> byCondition,
    CageOccupancyStats occupancy,
  });

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
                      as Map<String, int>,
            byCondition: null == byCondition
                ? _value.byCondition
                : byCondition // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
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
    @JsonKey(name: 'total_cages') int totalCages,
    @JsonKey(name: 'by_type') Map<String, int> byType,
    @JsonKey(name: 'by_condition') Map<String, int> byCondition,
    CageOccupancyStats occupancy,
  });

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
            ? _value._byType
            : byType // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        byCondition: null == byCondition
            ? _value._byCondition
            : byCondition // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
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
    @JsonKey(name: 'total_cages') required this.totalCages,
    @JsonKey(name: 'by_type') required final Map<String, int> byType,
    @JsonKey(name: 'by_condition') required final Map<String, int> byCondition,
    required this.occupancy,
  }) : _byType = byType,
       _byCondition = byCondition;

  factory _$CageStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CageStatisticsImplFromJson(json);

  @override
  @JsonKey(name: 'total_cages')
  final int totalCages;
  final Map<String, int> _byType;
  @override
  @JsonKey(name: 'by_type')
  Map<String, int> get byType {
    if (_byType is EqualUnmodifiableMapView) return _byType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byType);
  }

  final Map<String, int> _byCondition;
  @override
  @JsonKey(name: 'by_condition')
  Map<String, int> get byCondition {
    if (_byCondition is EqualUnmodifiableMapView) return _byCondition;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byCondition);
  }

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
            const DeepCollectionEquality().equals(other._byType, _byType) &&
            const DeepCollectionEquality().equals(
              other._byCondition,
              _byCondition,
            ) &&
            (identical(other.occupancy, occupancy) ||
                other.occupancy == occupancy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalCages,
    const DeepCollectionEquality().hash(_byType),
    const DeepCollectionEquality().hash(_byCondition),
    occupancy,
  );

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
    @JsonKey(name: 'total_cages') required final int totalCages,
    @JsonKey(name: 'by_type') required final Map<String, int> byType,
    @JsonKey(name: 'by_condition') required final Map<String, int> byCondition,
    required final CageOccupancyStats occupancy,
  }) = _$CageStatisticsImpl;

  factory _CageStatistics.fromJson(Map<String, dynamic> json) =
      _$CageStatisticsImpl.fromJson;

  @override
  @JsonKey(name: 'total_cages')
  int get totalCages;
  @override
  @JsonKey(name: 'by_type')
  Map<String, int> get byType;
  @override
  @JsonKey(name: 'by_condition')
  Map<String, int> get byCondition;
  @override
  CageOccupancyStats get occupancy;

  /// Create a copy of CageStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CageStatisticsImplCopyWith<_$CageStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CageOccupancyStats _$CageOccupancyStatsFromJson(Map<String, dynamic> json) {
  return _CageOccupancyStats.fromJson(json);
}

/// @nodoc
mixin _$CageOccupancyStats {
  @JsonKey(name: 'total_capacity')
  int get totalCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_occupancy')
  int get currentOccupancy => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_spaces')
  int get availableSpaces => throw _privateConstructorUsedError;
  @JsonKey(name: 'occupancy_rate')
  int get occupancyRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_cages')
  int get fullCages => throw _privateConstructorUsedError;
  @JsonKey(name: 'empty_cages')
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
    @JsonKey(name: 'total_capacity') int totalCapacity,
    @JsonKey(name: 'current_occupancy') int currentOccupancy,
    @JsonKey(name: 'available_spaces') int availableSpaces,
    @JsonKey(name: 'occupancy_rate') int occupancyRate,
    @JsonKey(name: 'full_cages') int fullCages,
    @JsonKey(name: 'empty_cages') int emptyCages,
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
    @JsonKey(name: 'total_capacity') int totalCapacity,
    @JsonKey(name: 'current_occupancy') int currentOccupancy,
    @JsonKey(name: 'available_spaces') int availableSpaces,
    @JsonKey(name: 'occupancy_rate') int occupancyRate,
    @JsonKey(name: 'full_cages') int fullCages,
    @JsonKey(name: 'empty_cages') int emptyCages,
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
    @JsonKey(name: 'total_capacity') required this.totalCapacity,
    @JsonKey(name: 'current_occupancy') required this.currentOccupancy,
    @JsonKey(name: 'available_spaces') required this.availableSpaces,
    @JsonKey(name: 'occupancy_rate') required this.occupancyRate,
    @JsonKey(name: 'full_cages') required this.fullCages,
    @JsonKey(name: 'empty_cages') required this.emptyCages,
  });

  factory _$CageOccupancyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CageOccupancyStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_capacity')
  final int totalCapacity;
  @override
  @JsonKey(name: 'current_occupancy')
  final int currentOccupancy;
  @override
  @JsonKey(name: 'available_spaces')
  final int availableSpaces;
  @override
  @JsonKey(name: 'occupancy_rate')
  final int occupancyRate;
  @override
  @JsonKey(name: 'full_cages')
  final int fullCages;
  @override
  @JsonKey(name: 'empty_cages')
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
    @JsonKey(name: 'total_capacity') required final int totalCapacity,
    @JsonKey(name: 'current_occupancy') required final int currentOccupancy,
    @JsonKey(name: 'available_spaces') required final int availableSpaces,
    @JsonKey(name: 'occupancy_rate') required final int occupancyRate,
    @JsonKey(name: 'full_cages') required final int fullCages,
    @JsonKey(name: 'empty_cages') required final int emptyCages,
  }) = _$CageOccupancyStatsImpl;

  factory _CageOccupancyStats.fromJson(Map<String, dynamic> json) =
      _$CageOccupancyStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_capacity')
  int get totalCapacity;
  @override
  @JsonKey(name: 'current_occupancy')
  int get currentOccupancy;
  @override
  @JsonKey(name: 'available_spaces')
  int get availableSpaces;
  @override
  @JsonKey(name: 'occupancy_rate')
  int get occupancyRate;
  @override
  @JsonKey(name: 'full_cages')
  int get fullCages;
  @override
  @JsonKey(name: 'empty_cages')
  int get emptyCages;

  /// Create a copy of CageOccupancyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CageOccupancyStatsImplCopyWith<_$CageOccupancyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
