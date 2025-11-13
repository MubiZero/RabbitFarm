// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardReport _$DashboardReportFromJson(Map<String, dynamic> json) {
  return _DashboardReport.fromJson(json);
}

/// @nodoc
mixin _$DashboardReport {
  RabbitStats get rabbits => throw _privateConstructorUsedError;
  CageStats get cages => throw _privateConstructorUsedError;
  HealthStats get health => throw _privateConstructorUsedError;
  FinanceStats get finance => throw _privateConstructorUsedError;
  TaskStats get tasks => throw _privateConstructorUsedError;
  InventoryStats get inventory => throw _privateConstructorUsedError;
  BreedingStats get breeding => throw _privateConstructorUsedError;

  /// Serializes this DashboardReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardReportCopyWith<DashboardReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardReportCopyWith<$Res> {
  factory $DashboardReportCopyWith(
    DashboardReport value,
    $Res Function(DashboardReport) then,
  ) = _$DashboardReportCopyWithImpl<$Res, DashboardReport>;
  @useResult
  $Res call({
    RabbitStats rabbits,
    CageStats cages,
    HealthStats health,
    FinanceStats finance,
    TaskStats tasks,
    InventoryStats inventory,
    BreedingStats breeding,
  });

  $RabbitStatsCopyWith<$Res> get rabbits;
  $CageStatsCopyWith<$Res> get cages;
  $HealthStatsCopyWith<$Res> get health;
  $FinanceStatsCopyWith<$Res> get finance;
  $TaskStatsCopyWith<$Res> get tasks;
  $InventoryStatsCopyWith<$Res> get inventory;
  $BreedingStatsCopyWith<$Res> get breeding;
}

/// @nodoc
class _$DashboardReportCopyWithImpl<$Res, $Val extends DashboardReport>
    implements $DashboardReportCopyWith<$Res> {
  _$DashboardReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rabbits = null,
    Object? cages = null,
    Object? health = null,
    Object? finance = null,
    Object? tasks = null,
    Object? inventory = null,
    Object? breeding = null,
  }) {
    return _then(
      _value.copyWith(
            rabbits: null == rabbits
                ? _value.rabbits
                : rabbits // ignore: cast_nullable_to_non_nullable
                      as RabbitStats,
            cages: null == cages
                ? _value.cages
                : cages // ignore: cast_nullable_to_non_nullable
                      as CageStats,
            health: null == health
                ? _value.health
                : health // ignore: cast_nullable_to_non_nullable
                      as HealthStats,
            finance: null == finance
                ? _value.finance
                : finance // ignore: cast_nullable_to_non_nullable
                      as FinanceStats,
            tasks: null == tasks
                ? _value.tasks
                : tasks // ignore: cast_nullable_to_non_nullable
                      as TaskStats,
            inventory: null == inventory
                ? _value.inventory
                : inventory // ignore: cast_nullable_to_non_nullable
                      as InventoryStats,
            breeding: null == breeding
                ? _value.breeding
                : breeding // ignore: cast_nullable_to_non_nullable
                      as BreedingStats,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RabbitStatsCopyWith<$Res> get rabbits {
    return $RabbitStatsCopyWith<$Res>(_value.rabbits, (value) {
      return _then(_value.copyWith(rabbits: value) as $Val);
    });
  }

  /// Create a copy of DashboardReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CageStatsCopyWith<$Res> get cages {
    return $CageStatsCopyWith<$Res>(_value.cages, (value) {
      return _then(_value.copyWith(cages: value) as $Val);
    });
  }

  /// Create a copy of DashboardReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HealthStatsCopyWith<$Res> get health {
    return $HealthStatsCopyWith<$Res>(_value.health, (value) {
      return _then(_value.copyWith(health: value) as $Val);
    });
  }

  /// Create a copy of DashboardReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FinanceStatsCopyWith<$Res> get finance {
    return $FinanceStatsCopyWith<$Res>(_value.finance, (value) {
      return _then(_value.copyWith(finance: value) as $Val);
    });
  }

  /// Create a copy of DashboardReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskStatsCopyWith<$Res> get tasks {
    return $TaskStatsCopyWith<$Res>(_value.tasks, (value) {
      return _then(_value.copyWith(tasks: value) as $Val);
    });
  }

  /// Create a copy of DashboardReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InventoryStatsCopyWith<$Res> get inventory {
    return $InventoryStatsCopyWith<$Res>(_value.inventory, (value) {
      return _then(_value.copyWith(inventory: value) as $Val);
    });
  }

  /// Create a copy of DashboardReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BreedingStatsCopyWith<$Res> get breeding {
    return $BreedingStatsCopyWith<$Res>(_value.breeding, (value) {
      return _then(_value.copyWith(breeding: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardReportImplCopyWith<$Res>
    implements $DashboardReportCopyWith<$Res> {
  factory _$$DashboardReportImplCopyWith(
    _$DashboardReportImpl value,
    $Res Function(_$DashboardReportImpl) then,
  ) = __$$DashboardReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RabbitStats rabbits,
    CageStats cages,
    HealthStats health,
    FinanceStats finance,
    TaskStats tasks,
    InventoryStats inventory,
    BreedingStats breeding,
  });

  @override
  $RabbitStatsCopyWith<$Res> get rabbits;
  @override
  $CageStatsCopyWith<$Res> get cages;
  @override
  $HealthStatsCopyWith<$Res> get health;
  @override
  $FinanceStatsCopyWith<$Res> get finance;
  @override
  $TaskStatsCopyWith<$Res> get tasks;
  @override
  $InventoryStatsCopyWith<$Res> get inventory;
  @override
  $BreedingStatsCopyWith<$Res> get breeding;
}

/// @nodoc
class __$$DashboardReportImplCopyWithImpl<$Res>
    extends _$DashboardReportCopyWithImpl<$Res, _$DashboardReportImpl>
    implements _$$DashboardReportImplCopyWith<$Res> {
  __$$DashboardReportImplCopyWithImpl(
    _$DashboardReportImpl _value,
    $Res Function(_$DashboardReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rabbits = null,
    Object? cages = null,
    Object? health = null,
    Object? finance = null,
    Object? tasks = null,
    Object? inventory = null,
    Object? breeding = null,
  }) {
    return _then(
      _$DashboardReportImpl(
        rabbits: null == rabbits
            ? _value.rabbits
            : rabbits // ignore: cast_nullable_to_non_nullable
                  as RabbitStats,
        cages: null == cages
            ? _value.cages
            : cages // ignore: cast_nullable_to_non_nullable
                  as CageStats,
        health: null == health
            ? _value.health
            : health // ignore: cast_nullable_to_non_nullable
                  as HealthStats,
        finance: null == finance
            ? _value.finance
            : finance // ignore: cast_nullable_to_non_nullable
                  as FinanceStats,
        tasks: null == tasks
            ? _value.tasks
            : tasks // ignore: cast_nullable_to_non_nullable
                  as TaskStats,
        inventory: null == inventory
            ? _value.inventory
            : inventory // ignore: cast_nullable_to_non_nullable
                  as InventoryStats,
        breeding: null == breeding
            ? _value.breeding
            : breeding // ignore: cast_nullable_to_non_nullable
                  as BreedingStats,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardReportImpl implements _DashboardReport {
  const _$DashboardReportImpl({
    required this.rabbits,
    required this.cages,
    required this.health,
    required this.finance,
    required this.tasks,
    required this.inventory,
    required this.breeding,
  });

  factory _$DashboardReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardReportImplFromJson(json);

  @override
  final RabbitStats rabbits;
  @override
  final CageStats cages;
  @override
  final HealthStats health;
  @override
  final FinanceStats finance;
  @override
  final TaskStats tasks;
  @override
  final InventoryStats inventory;
  @override
  final BreedingStats breeding;

  @override
  String toString() {
    return 'DashboardReport(rabbits: $rabbits, cages: $cages, health: $health, finance: $finance, tasks: $tasks, inventory: $inventory, breeding: $breeding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardReportImpl &&
            (identical(other.rabbits, rabbits) || other.rabbits == rabbits) &&
            (identical(other.cages, cages) || other.cages == cages) &&
            (identical(other.health, health) || other.health == health) &&
            (identical(other.finance, finance) || other.finance == finance) &&
            (identical(other.tasks, tasks) || other.tasks == tasks) &&
            (identical(other.inventory, inventory) ||
                other.inventory == inventory) &&
            (identical(other.breeding, breeding) ||
                other.breeding == breeding));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rabbits,
    cages,
    health,
    finance,
    tasks,
    inventory,
    breeding,
  );

  /// Create a copy of DashboardReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardReportImplCopyWith<_$DashboardReportImpl> get copyWith =>
      __$$DashboardReportImplCopyWithImpl<_$DashboardReportImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardReportImplToJson(this);
  }
}

abstract class _DashboardReport implements DashboardReport {
  const factory _DashboardReport({
    required final RabbitStats rabbits,
    required final CageStats cages,
    required final HealthStats health,
    required final FinanceStats finance,
    required final TaskStats tasks,
    required final InventoryStats inventory,
    required final BreedingStats breeding,
  }) = _$DashboardReportImpl;

  factory _DashboardReport.fromJson(Map<String, dynamic> json) =
      _$DashboardReportImpl.fromJson;

  @override
  RabbitStats get rabbits;
  @override
  CageStats get cages;
  @override
  HealthStats get health;
  @override
  FinanceStats get finance;
  @override
  TaskStats get tasks;
  @override
  InventoryStats get inventory;
  @override
  BreedingStats get breeding;

  /// Create a copy of DashboardReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardReportImplCopyWith<_$DashboardReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RabbitStats _$RabbitStatsFromJson(Map<String, dynamic> json) {
  return _RabbitStats.fromJson(json);
}

/// @nodoc
mixin _$RabbitStats {
  @IntConverter()
  int get total => throw _privateConstructorUsedError;
  @IntConverter()
  int get male => throw _privateConstructorUsedError;
  @IntConverter()
  int get female => throw _privateConstructorUsedError;

  /// Serializes this RabbitStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RabbitStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RabbitStatsCopyWith<RabbitStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RabbitStatsCopyWith<$Res> {
  factory $RabbitStatsCopyWith(
    RabbitStats value,
    $Res Function(RabbitStats) then,
  ) = _$RabbitStatsCopyWithImpl<$Res, RabbitStats>;
  @useResult
  $Res call({
    @IntConverter() int total,
    @IntConverter() int male,
    @IntConverter() int female,
  });
}

/// @nodoc
class _$RabbitStatsCopyWithImpl<$Res, $Val extends RabbitStats>
    implements $RabbitStatsCopyWith<$Res> {
  _$RabbitStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RabbitStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? male = null,
    Object? female = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            male: null == male
                ? _value.male
                : male // ignore: cast_nullable_to_non_nullable
                      as int,
            female: null == female
                ? _value.female
                : female // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RabbitStatsImplCopyWith<$Res>
    implements $RabbitStatsCopyWith<$Res> {
  factory _$$RabbitStatsImplCopyWith(
    _$RabbitStatsImpl value,
    $Res Function(_$RabbitStatsImpl) then,
  ) = __$$RabbitStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int total,
    @IntConverter() int male,
    @IntConverter() int female,
  });
}

/// @nodoc
class __$$RabbitStatsImplCopyWithImpl<$Res>
    extends _$RabbitStatsCopyWithImpl<$Res, _$RabbitStatsImpl>
    implements _$$RabbitStatsImplCopyWith<$Res> {
  __$$RabbitStatsImplCopyWithImpl(
    _$RabbitStatsImpl _value,
    $Res Function(_$RabbitStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RabbitStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? male = null,
    Object? female = null,
  }) {
    return _then(
      _$RabbitStatsImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        male: null == male
            ? _value.male
            : male // ignore: cast_nullable_to_non_nullable
                  as int,
        female: null == female
            ? _value.female
            : female // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RabbitStatsImpl implements _RabbitStats {
  const _$RabbitStatsImpl({
    @IntConverter() required this.total,
    @IntConverter() required this.male,
    @IntConverter() required this.female,
  });

  factory _$RabbitStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RabbitStatsImplFromJson(json);

  @override
  @IntConverter()
  final int total;
  @override
  @IntConverter()
  final int male;
  @override
  @IntConverter()
  final int female;

  @override
  String toString() {
    return 'RabbitStats(total: $total, male: $male, female: $female)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RabbitStatsImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.male, male) || other.male == male) &&
            (identical(other.female, female) || other.female == female));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total, male, female);

  /// Create a copy of RabbitStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RabbitStatsImplCopyWith<_$RabbitStatsImpl> get copyWith =>
      __$$RabbitStatsImplCopyWithImpl<_$RabbitStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RabbitStatsImplToJson(this);
  }
}

abstract class _RabbitStats implements RabbitStats {
  const factory _RabbitStats({
    @IntConverter() required final int total,
    @IntConverter() required final int male,
    @IntConverter() required final int female,
  }) = _$RabbitStatsImpl;

  factory _RabbitStats.fromJson(Map<String, dynamic> json) =
      _$RabbitStatsImpl.fromJson;

  @override
  @IntConverter()
  int get total;
  @override
  @IntConverter()
  int get male;
  @override
  @IntConverter()
  int get female;

  /// Create a copy of RabbitStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RabbitStatsImplCopyWith<_$RabbitStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CageStats _$CageStatsFromJson(Map<String, dynamic> json) {
  return _CageStats.fromJson(json);
}

/// @nodoc
mixin _$CageStats {
  @IntConverter()
  int get total => throw _privateConstructorUsedError;
  @IntConverter()
  int get occupied => throw _privateConstructorUsedError;
  @IntConverter()
  int get available => throw _privateConstructorUsedError;

  /// Serializes this CageStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CageStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CageStatsCopyWith<CageStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CageStatsCopyWith<$Res> {
  factory $CageStatsCopyWith(CageStats value, $Res Function(CageStats) then) =
      _$CageStatsCopyWithImpl<$Res, CageStats>;
  @useResult
  $Res call({
    @IntConverter() int total,
    @IntConverter() int occupied,
    @IntConverter() int available,
  });
}

/// @nodoc
class _$CageStatsCopyWithImpl<$Res, $Val extends CageStats>
    implements $CageStatsCopyWith<$Res> {
  _$CageStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CageStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? occupied = null,
    Object? available = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            occupied: null == occupied
                ? _value.occupied
                : occupied // ignore: cast_nullable_to_non_nullable
                      as int,
            available: null == available
                ? _value.available
                : available // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CageStatsImplCopyWith<$Res>
    implements $CageStatsCopyWith<$Res> {
  factory _$$CageStatsImplCopyWith(
    _$CageStatsImpl value,
    $Res Function(_$CageStatsImpl) then,
  ) = __$$CageStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int total,
    @IntConverter() int occupied,
    @IntConverter() int available,
  });
}

/// @nodoc
class __$$CageStatsImplCopyWithImpl<$Res>
    extends _$CageStatsCopyWithImpl<$Res, _$CageStatsImpl>
    implements _$$CageStatsImplCopyWith<$Res> {
  __$$CageStatsImplCopyWithImpl(
    _$CageStatsImpl _value,
    $Res Function(_$CageStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CageStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? occupied = null,
    Object? available = null,
  }) {
    return _then(
      _$CageStatsImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        occupied: null == occupied
            ? _value.occupied
            : occupied // ignore: cast_nullable_to_non_nullable
                  as int,
        available: null == available
            ? _value.available
            : available // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CageStatsImpl implements _CageStats {
  const _$CageStatsImpl({
    @IntConverter() required this.total,
    @IntConverter() required this.occupied,
    @IntConverter() required this.available,
  });

  factory _$CageStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CageStatsImplFromJson(json);

  @override
  @IntConverter()
  final int total;
  @override
  @IntConverter()
  final int occupied;
  @override
  @IntConverter()
  final int available;

  @override
  String toString() {
    return 'CageStats(total: $total, occupied: $occupied, available: $available)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CageStatsImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.occupied, occupied) ||
                other.occupied == occupied) &&
            (identical(other.available, available) ||
                other.available == available));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total, occupied, available);

  /// Create a copy of CageStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CageStatsImplCopyWith<_$CageStatsImpl> get copyWith =>
      __$$CageStatsImplCopyWithImpl<_$CageStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CageStatsImplToJson(this);
  }
}

abstract class _CageStats implements CageStats {
  const factory _CageStats({
    @IntConverter() required final int total,
    @IntConverter() required final int occupied,
    @IntConverter() required final int available,
  }) = _$CageStatsImpl;

  factory _CageStats.fromJson(Map<String, dynamic> json) =
      _$CageStatsImpl.fromJson;

  @override
  @IntConverter()
  int get total;
  @override
  @IntConverter()
  int get occupied;
  @override
  @IntConverter()
  int get available;

  /// Create a copy of CageStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CageStatsImplCopyWith<_$CageStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HealthStats _$HealthStatsFromJson(Map<String, dynamic> json) {
  return _HealthStats.fromJson(json);
}

/// @nodoc
mixin _$HealthStats {
  @IntConverter()
  int get upcomingVaccinations => throw _privateConstructorUsedError;
  @IntConverter()
  int get overdueVaccinations => throw _privateConstructorUsedError;

  /// Serializes this HealthStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthStatsCopyWith<HealthStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthStatsCopyWith<$Res> {
  factory $HealthStatsCopyWith(
    HealthStats value,
    $Res Function(HealthStats) then,
  ) = _$HealthStatsCopyWithImpl<$Res, HealthStats>;
  @useResult
  $Res call({
    @IntConverter() int upcomingVaccinations,
    @IntConverter() int overdueVaccinations,
  });
}

/// @nodoc
class _$HealthStatsCopyWithImpl<$Res, $Val extends HealthStats>
    implements $HealthStatsCopyWith<$Res> {
  _$HealthStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? upcomingVaccinations = null,
    Object? overdueVaccinations = null,
  }) {
    return _then(
      _value.copyWith(
            upcomingVaccinations: null == upcomingVaccinations
                ? _value.upcomingVaccinations
                : upcomingVaccinations // ignore: cast_nullable_to_non_nullable
                      as int,
            overdueVaccinations: null == overdueVaccinations
                ? _value.overdueVaccinations
                : overdueVaccinations // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HealthStatsImplCopyWith<$Res>
    implements $HealthStatsCopyWith<$Res> {
  factory _$$HealthStatsImplCopyWith(
    _$HealthStatsImpl value,
    $Res Function(_$HealthStatsImpl) then,
  ) = __$$HealthStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int upcomingVaccinations,
    @IntConverter() int overdueVaccinations,
  });
}

/// @nodoc
class __$$HealthStatsImplCopyWithImpl<$Res>
    extends _$HealthStatsCopyWithImpl<$Res, _$HealthStatsImpl>
    implements _$$HealthStatsImplCopyWith<$Res> {
  __$$HealthStatsImplCopyWithImpl(
    _$HealthStatsImpl _value,
    $Res Function(_$HealthStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HealthStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? upcomingVaccinations = null,
    Object? overdueVaccinations = null,
  }) {
    return _then(
      _$HealthStatsImpl(
        upcomingVaccinations: null == upcomingVaccinations
            ? _value.upcomingVaccinations
            : upcomingVaccinations // ignore: cast_nullable_to_non_nullable
                  as int,
        overdueVaccinations: null == overdueVaccinations
            ? _value.overdueVaccinations
            : overdueVaccinations // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthStatsImpl implements _HealthStats {
  const _$HealthStatsImpl({
    @IntConverter() required this.upcomingVaccinations,
    @IntConverter() required this.overdueVaccinations,
  });

  factory _$HealthStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthStatsImplFromJson(json);

  @override
  @IntConverter()
  final int upcomingVaccinations;
  @override
  @IntConverter()
  final int overdueVaccinations;

  @override
  String toString() {
    return 'HealthStats(upcomingVaccinations: $upcomingVaccinations, overdueVaccinations: $overdueVaccinations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthStatsImpl &&
            (identical(other.upcomingVaccinations, upcomingVaccinations) ||
                other.upcomingVaccinations == upcomingVaccinations) &&
            (identical(other.overdueVaccinations, overdueVaccinations) ||
                other.overdueVaccinations == overdueVaccinations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, upcomingVaccinations, overdueVaccinations);

  /// Create a copy of HealthStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthStatsImplCopyWith<_$HealthStatsImpl> get copyWith =>
      __$$HealthStatsImplCopyWithImpl<_$HealthStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthStatsImplToJson(this);
  }
}

abstract class _HealthStats implements HealthStats {
  const factory _HealthStats({
    @IntConverter() required final int upcomingVaccinations,
    @IntConverter() required final int overdueVaccinations,
  }) = _$HealthStatsImpl;

  factory _HealthStats.fromJson(Map<String, dynamic> json) =
      _$HealthStatsImpl.fromJson;

  @override
  @IntConverter()
  int get upcomingVaccinations;
  @override
  @IntConverter()
  int get overdueVaccinations;

  /// Create a copy of HealthStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthStatsImplCopyWith<_$HealthStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinanceStats _$FinanceStatsFromJson(Map<String, dynamic> json) {
  return _FinanceStats.fromJson(json);
}

/// @nodoc
mixin _$FinanceStats {
  @DoubleConverter()
  double get income30days => throw _privateConstructorUsedError;
  @DoubleConverter()
  double get expenses30days => throw _privateConstructorUsedError;
  @DoubleConverter()
  double get profit30days => throw _privateConstructorUsedError;

  /// Serializes this FinanceStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinanceStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinanceStatsCopyWith<FinanceStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinanceStatsCopyWith<$Res> {
  factory $FinanceStatsCopyWith(
    FinanceStats value,
    $Res Function(FinanceStats) then,
  ) = _$FinanceStatsCopyWithImpl<$Res, FinanceStats>;
  @useResult
  $Res call({
    @DoubleConverter() double income30days,
    @DoubleConverter() double expenses30days,
    @DoubleConverter() double profit30days,
  });
}

/// @nodoc
class _$FinanceStatsCopyWithImpl<$Res, $Val extends FinanceStats>
    implements $FinanceStatsCopyWith<$Res> {
  _$FinanceStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinanceStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income30days = null,
    Object? expenses30days = null,
    Object? profit30days = null,
  }) {
    return _then(
      _value.copyWith(
            income30days: null == income30days
                ? _value.income30days
                : income30days // ignore: cast_nullable_to_non_nullable
                      as double,
            expenses30days: null == expenses30days
                ? _value.expenses30days
                : expenses30days // ignore: cast_nullable_to_non_nullable
                      as double,
            profit30days: null == profit30days
                ? _value.profit30days
                : profit30days // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinanceStatsImplCopyWith<$Res>
    implements $FinanceStatsCopyWith<$Res> {
  factory _$$FinanceStatsImplCopyWith(
    _$FinanceStatsImpl value,
    $Res Function(_$FinanceStatsImpl) then,
  ) = __$$FinanceStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @DoubleConverter() double income30days,
    @DoubleConverter() double expenses30days,
    @DoubleConverter() double profit30days,
  });
}

/// @nodoc
class __$$FinanceStatsImplCopyWithImpl<$Res>
    extends _$FinanceStatsCopyWithImpl<$Res, _$FinanceStatsImpl>
    implements _$$FinanceStatsImplCopyWith<$Res> {
  __$$FinanceStatsImplCopyWithImpl(
    _$FinanceStatsImpl _value,
    $Res Function(_$FinanceStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinanceStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income30days = null,
    Object? expenses30days = null,
    Object? profit30days = null,
  }) {
    return _then(
      _$FinanceStatsImpl(
        income30days: null == income30days
            ? _value.income30days
            : income30days // ignore: cast_nullable_to_non_nullable
                  as double,
        expenses30days: null == expenses30days
            ? _value.expenses30days
            : expenses30days // ignore: cast_nullable_to_non_nullable
                  as double,
        profit30days: null == profit30days
            ? _value.profit30days
            : profit30days // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinanceStatsImpl implements _FinanceStats {
  const _$FinanceStatsImpl({
    @DoubleConverter() required this.income30days,
    @DoubleConverter() required this.expenses30days,
    @DoubleConverter() required this.profit30days,
  });

  factory _$FinanceStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinanceStatsImplFromJson(json);

  @override
  @DoubleConverter()
  final double income30days;
  @override
  @DoubleConverter()
  final double expenses30days;
  @override
  @DoubleConverter()
  final double profit30days;

  @override
  String toString() {
    return 'FinanceStats(income30days: $income30days, expenses30days: $expenses30days, profit30days: $profit30days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinanceStatsImpl &&
            (identical(other.income30days, income30days) ||
                other.income30days == income30days) &&
            (identical(other.expenses30days, expenses30days) ||
                other.expenses30days == expenses30days) &&
            (identical(other.profit30days, profit30days) ||
                other.profit30days == profit30days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, income30days, expenses30days, profit30days);

  /// Create a copy of FinanceStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinanceStatsImplCopyWith<_$FinanceStatsImpl> get copyWith =>
      __$$FinanceStatsImplCopyWithImpl<_$FinanceStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinanceStatsImplToJson(this);
  }
}

abstract class _FinanceStats implements FinanceStats {
  const factory _FinanceStats({
    @DoubleConverter() required final double income30days,
    @DoubleConverter() required final double expenses30days,
    @DoubleConverter() required final double profit30days,
  }) = _$FinanceStatsImpl;

  factory _FinanceStats.fromJson(Map<String, dynamic> json) =
      _$FinanceStatsImpl.fromJson;

  @override
  @DoubleConverter()
  double get income30days;
  @override
  @DoubleConverter()
  double get expenses30days;
  @override
  @DoubleConverter()
  double get profit30days;

  /// Create a copy of FinanceStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinanceStatsImplCopyWith<_$FinanceStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskStats _$TaskStatsFromJson(Map<String, dynamic> json) {
  return _TaskStats.fromJson(json);
}

/// @nodoc
mixin _$TaskStats {
  @IntConverter()
  int get pending => throw _privateConstructorUsedError;
  @IntConverter()
  int get overdue => throw _privateConstructorUsedError;

  /// Serializes this TaskStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskStatsCopyWith<TaskStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskStatsCopyWith<$Res> {
  factory $TaskStatsCopyWith(TaskStats value, $Res Function(TaskStats) then) =
      _$TaskStatsCopyWithImpl<$Res, TaskStats>;
  @useResult
  $Res call({@IntConverter() int pending, @IntConverter() int overdue});
}

/// @nodoc
class _$TaskStatsCopyWithImpl<$Res, $Val extends TaskStats>
    implements $TaskStatsCopyWith<$Res> {
  _$TaskStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pending = null, Object? overdue = null}) {
    return _then(
      _value.copyWith(
            pending: null == pending
                ? _value.pending
                : pending // ignore: cast_nullable_to_non_nullable
                      as int,
            overdue: null == overdue
                ? _value.overdue
                : overdue // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskStatsImplCopyWith<$Res>
    implements $TaskStatsCopyWith<$Res> {
  factory _$$TaskStatsImplCopyWith(
    _$TaskStatsImpl value,
    $Res Function(_$TaskStatsImpl) then,
  ) = __$$TaskStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@IntConverter() int pending, @IntConverter() int overdue});
}

/// @nodoc
class __$$TaskStatsImplCopyWithImpl<$Res>
    extends _$TaskStatsCopyWithImpl<$Res, _$TaskStatsImpl>
    implements _$$TaskStatsImplCopyWith<$Res> {
  __$$TaskStatsImplCopyWithImpl(
    _$TaskStatsImpl _value,
    $Res Function(_$TaskStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pending = null, Object? overdue = null}) {
    return _then(
      _$TaskStatsImpl(
        pending: null == pending
            ? _value.pending
            : pending // ignore: cast_nullable_to_non_nullable
                  as int,
        overdue: null == overdue
            ? _value.overdue
            : overdue // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskStatsImpl implements _TaskStats {
  const _$TaskStatsImpl({
    @IntConverter() required this.pending,
    @IntConverter() required this.overdue,
  });

  factory _$TaskStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskStatsImplFromJson(json);

  @override
  @IntConverter()
  final int pending;
  @override
  @IntConverter()
  final int overdue;

  @override
  String toString() {
    return 'TaskStats(pending: $pending, overdue: $overdue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskStatsImpl &&
            (identical(other.pending, pending) || other.pending == pending) &&
            (identical(other.overdue, overdue) || other.overdue == overdue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pending, overdue);

  /// Create a copy of TaskStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskStatsImplCopyWith<_$TaskStatsImpl> get copyWith =>
      __$$TaskStatsImplCopyWithImpl<_$TaskStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskStatsImplToJson(this);
  }
}

abstract class _TaskStats implements TaskStats {
  const factory _TaskStats({
    @IntConverter() required final int pending,
    @IntConverter() required final int overdue,
  }) = _$TaskStatsImpl;

  factory _TaskStats.fromJson(Map<String, dynamic> json) =
      _$TaskStatsImpl.fromJson;

  @override
  @IntConverter()
  int get pending;
  @override
  @IntConverter()
  int get overdue;

  /// Create a copy of TaskStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskStatsImplCopyWith<_$TaskStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryStats _$InventoryStatsFromJson(Map<String, dynamic> json) {
  return _InventoryStats.fromJson(json);
}

/// @nodoc
mixin _$InventoryStats {
  @IntConverter()
  int get lowStockFeeds => throw _privateConstructorUsedError;

  /// Serializes this InventoryStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryStatsCopyWith<InventoryStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryStatsCopyWith<$Res> {
  factory $InventoryStatsCopyWith(
    InventoryStats value,
    $Res Function(InventoryStats) then,
  ) = _$InventoryStatsCopyWithImpl<$Res, InventoryStats>;
  @useResult
  $Res call({@IntConverter() int lowStockFeeds});
}

/// @nodoc
class _$InventoryStatsCopyWithImpl<$Res, $Val extends InventoryStats>
    implements $InventoryStatsCopyWith<$Res> {
  _$InventoryStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? lowStockFeeds = null}) {
    return _then(
      _value.copyWith(
            lowStockFeeds: null == lowStockFeeds
                ? _value.lowStockFeeds
                : lowStockFeeds // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InventoryStatsImplCopyWith<$Res>
    implements $InventoryStatsCopyWith<$Res> {
  factory _$$InventoryStatsImplCopyWith(
    _$InventoryStatsImpl value,
    $Res Function(_$InventoryStatsImpl) then,
  ) = __$$InventoryStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@IntConverter() int lowStockFeeds});
}

/// @nodoc
class __$$InventoryStatsImplCopyWithImpl<$Res>
    extends _$InventoryStatsCopyWithImpl<$Res, _$InventoryStatsImpl>
    implements _$$InventoryStatsImplCopyWith<$Res> {
  __$$InventoryStatsImplCopyWithImpl(
    _$InventoryStatsImpl _value,
    $Res Function(_$InventoryStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? lowStockFeeds = null}) {
    return _then(
      _$InventoryStatsImpl(
        lowStockFeeds: null == lowStockFeeds
            ? _value.lowStockFeeds
            : lowStockFeeds // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryStatsImpl implements _InventoryStats {
  const _$InventoryStatsImpl({@IntConverter() required this.lowStockFeeds});

  factory _$InventoryStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryStatsImplFromJson(json);

  @override
  @IntConverter()
  final int lowStockFeeds;

  @override
  String toString() {
    return 'InventoryStats(lowStockFeeds: $lowStockFeeds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryStatsImpl &&
            (identical(other.lowStockFeeds, lowStockFeeds) ||
                other.lowStockFeeds == lowStockFeeds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lowStockFeeds);

  /// Create a copy of InventoryStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryStatsImplCopyWith<_$InventoryStatsImpl> get copyWith =>
      __$$InventoryStatsImplCopyWithImpl<_$InventoryStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryStatsImplToJson(this);
  }
}

abstract class _InventoryStats implements InventoryStats {
  const factory _InventoryStats({
    @IntConverter() required final int lowStockFeeds,
  }) = _$InventoryStatsImpl;

  factory _InventoryStats.fromJson(Map<String, dynamic> json) =
      _$InventoryStatsImpl.fromJson;

  @override
  @IntConverter()
  int get lowStockFeeds;

  /// Create a copy of InventoryStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryStatsImplCopyWith<_$InventoryStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BreedingStats _$BreedingStatsFromJson(Map<String, dynamic> json) {
  return _BreedingStats.fromJson(json);
}

/// @nodoc
mixin _$BreedingStats {
  @IntConverter()
  int get recentBirths => throw _privateConstructorUsedError;

  /// Serializes this BreedingStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BreedingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreedingStatsCopyWith<BreedingStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreedingStatsCopyWith<$Res> {
  factory $BreedingStatsCopyWith(
    BreedingStats value,
    $Res Function(BreedingStats) then,
  ) = _$BreedingStatsCopyWithImpl<$Res, BreedingStats>;
  @useResult
  $Res call({@IntConverter() int recentBirths});
}

/// @nodoc
class _$BreedingStatsCopyWithImpl<$Res, $Val extends BreedingStats>
    implements $BreedingStatsCopyWith<$Res> {
  _$BreedingStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreedingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? recentBirths = null}) {
    return _then(
      _value.copyWith(
            recentBirths: null == recentBirths
                ? _value.recentBirths
                : recentBirths // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreedingStatsImplCopyWith<$Res>
    implements $BreedingStatsCopyWith<$Res> {
  factory _$$BreedingStatsImplCopyWith(
    _$BreedingStatsImpl value,
    $Res Function(_$BreedingStatsImpl) then,
  ) = __$$BreedingStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@IntConverter() int recentBirths});
}

/// @nodoc
class __$$BreedingStatsImplCopyWithImpl<$Res>
    extends _$BreedingStatsCopyWithImpl<$Res, _$BreedingStatsImpl>
    implements _$$BreedingStatsImplCopyWith<$Res> {
  __$$BreedingStatsImplCopyWithImpl(
    _$BreedingStatsImpl _value,
    $Res Function(_$BreedingStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreedingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? recentBirths = null}) {
    return _then(
      _$BreedingStatsImpl(
        recentBirths: null == recentBirths
            ? _value.recentBirths
            : recentBirths // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BreedingStatsImpl implements _BreedingStats {
  const _$BreedingStatsImpl({@IntConverter() required this.recentBirths});

  factory _$BreedingStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreedingStatsImplFromJson(json);

  @override
  @IntConverter()
  final int recentBirths;

  @override
  String toString() {
    return 'BreedingStats(recentBirths: $recentBirths)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreedingStatsImpl &&
            (identical(other.recentBirths, recentBirths) ||
                other.recentBirths == recentBirths));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, recentBirths);

  /// Create a copy of BreedingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreedingStatsImplCopyWith<_$BreedingStatsImpl> get copyWith =>
      __$$BreedingStatsImplCopyWithImpl<_$BreedingStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreedingStatsImplToJson(this);
  }
}

abstract class _BreedingStats implements BreedingStats {
  const factory _BreedingStats({
    @IntConverter() required final int recentBirths,
  }) = _$BreedingStatsImpl;

  factory _BreedingStats.fromJson(Map<String, dynamic> json) =
      _$BreedingStatsImpl.fromJson;

  @override
  @IntConverter()
  int get recentBirths;

  /// Create a copy of BreedingStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreedingStatsImplCopyWith<_$BreedingStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FarmReport _$FarmReportFromJson(Map<String, dynamic> json) {
  return _FarmReport.fromJson(json);
}

/// @nodoc
mixin _$FarmReport {
  ReportPeriod get period => throw _privateConstructorUsedError;
  PopulationData get population => throw _privateConstructorUsedError;
  FinancialData get financial => throw _privateConstructorUsedError;
  HealthData get health => throw _privateConstructorUsedError;
  BreedingData get breeding => throw _privateConstructorUsedError;
  FeedingData get feeding => throw _privateConstructorUsedError;

  /// Serializes this FarmReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FarmReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmReportCopyWith<FarmReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmReportCopyWith<$Res> {
  factory $FarmReportCopyWith(
    FarmReport value,
    $Res Function(FarmReport) then,
  ) = _$FarmReportCopyWithImpl<$Res, FarmReport>;
  @useResult
  $Res call({
    ReportPeriod period,
    PopulationData population,
    FinancialData financial,
    HealthData health,
    BreedingData breeding,
    FeedingData feeding,
  });

  $ReportPeriodCopyWith<$Res> get period;
  $PopulationDataCopyWith<$Res> get population;
  $FinancialDataCopyWith<$Res> get financial;
  $HealthDataCopyWith<$Res> get health;
  $BreedingDataCopyWith<$Res> get breeding;
  $FeedingDataCopyWith<$Res> get feeding;
}

/// @nodoc
class _$FarmReportCopyWithImpl<$Res, $Val extends FarmReport>
    implements $FarmReportCopyWith<$Res> {
  _$FarmReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FarmReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? population = null,
    Object? financial = null,
    Object? health = null,
    Object? breeding = null,
    Object? feeding = null,
  }) {
    return _then(
      _value.copyWith(
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as ReportPeriod,
            population: null == population
                ? _value.population
                : population // ignore: cast_nullable_to_non_nullable
                      as PopulationData,
            financial: null == financial
                ? _value.financial
                : financial // ignore: cast_nullable_to_non_nullable
                      as FinancialData,
            health: null == health
                ? _value.health
                : health // ignore: cast_nullable_to_non_nullable
                      as HealthData,
            breeding: null == breeding
                ? _value.breeding
                : breeding // ignore: cast_nullable_to_non_nullable
                      as BreedingData,
            feeding: null == feeding
                ? _value.feeding
                : feeding // ignore: cast_nullable_to_non_nullable
                      as FeedingData,
          )
          as $Val,
    );
  }

  /// Create a copy of FarmReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReportPeriodCopyWith<$Res> get period {
    return $ReportPeriodCopyWith<$Res>(_value.period, (value) {
      return _then(_value.copyWith(period: value) as $Val);
    });
  }

  /// Create a copy of FarmReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PopulationDataCopyWith<$Res> get population {
    return $PopulationDataCopyWith<$Res>(_value.population, (value) {
      return _then(_value.copyWith(population: value) as $Val);
    });
  }

  /// Create a copy of FarmReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FinancialDataCopyWith<$Res> get financial {
    return $FinancialDataCopyWith<$Res>(_value.financial, (value) {
      return _then(_value.copyWith(financial: value) as $Val);
    });
  }

  /// Create a copy of FarmReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HealthDataCopyWith<$Res> get health {
    return $HealthDataCopyWith<$Res>(_value.health, (value) {
      return _then(_value.copyWith(health: value) as $Val);
    });
  }

  /// Create a copy of FarmReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BreedingDataCopyWith<$Res> get breeding {
    return $BreedingDataCopyWith<$Res>(_value.breeding, (value) {
      return _then(_value.copyWith(breeding: value) as $Val);
    });
  }

  /// Create a copy of FarmReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeedingDataCopyWith<$Res> get feeding {
    return $FeedingDataCopyWith<$Res>(_value.feeding, (value) {
      return _then(_value.copyWith(feeding: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FarmReportImplCopyWith<$Res>
    implements $FarmReportCopyWith<$Res> {
  factory _$$FarmReportImplCopyWith(
    _$FarmReportImpl value,
    $Res Function(_$FarmReportImpl) then,
  ) = __$$FarmReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ReportPeriod period,
    PopulationData population,
    FinancialData financial,
    HealthData health,
    BreedingData breeding,
    FeedingData feeding,
  });

  @override
  $ReportPeriodCopyWith<$Res> get period;
  @override
  $PopulationDataCopyWith<$Res> get population;
  @override
  $FinancialDataCopyWith<$Res> get financial;
  @override
  $HealthDataCopyWith<$Res> get health;
  @override
  $BreedingDataCopyWith<$Res> get breeding;
  @override
  $FeedingDataCopyWith<$Res> get feeding;
}

/// @nodoc
class __$$FarmReportImplCopyWithImpl<$Res>
    extends _$FarmReportCopyWithImpl<$Res, _$FarmReportImpl>
    implements _$$FarmReportImplCopyWith<$Res> {
  __$$FarmReportImplCopyWithImpl(
    _$FarmReportImpl _value,
    $Res Function(_$FarmReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FarmReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? population = null,
    Object? financial = null,
    Object? health = null,
    Object? breeding = null,
    Object? feeding = null,
  }) {
    return _then(
      _$FarmReportImpl(
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as ReportPeriod,
        population: null == population
            ? _value.population
            : population // ignore: cast_nullable_to_non_nullable
                  as PopulationData,
        financial: null == financial
            ? _value.financial
            : financial // ignore: cast_nullable_to_non_nullable
                  as FinancialData,
        health: null == health
            ? _value.health
            : health // ignore: cast_nullable_to_non_nullable
                  as HealthData,
        breeding: null == breeding
            ? _value.breeding
            : breeding // ignore: cast_nullable_to_non_nullable
                  as BreedingData,
        feeding: null == feeding
            ? _value.feeding
            : feeding // ignore: cast_nullable_to_non_nullable
                  as FeedingData,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FarmReportImpl implements _FarmReport {
  const _$FarmReportImpl({
    required this.period,
    required this.population,
    required this.financial,
    required this.health,
    required this.breeding,
    required this.feeding,
  });

  factory _$FarmReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$FarmReportImplFromJson(json);

  @override
  final ReportPeriod period;
  @override
  final PopulationData population;
  @override
  final FinancialData financial;
  @override
  final HealthData health;
  @override
  final BreedingData breeding;
  @override
  final FeedingData feeding;

  @override
  String toString() {
    return 'FarmReport(period: $period, population: $population, financial: $financial, health: $health, breeding: $breeding, feeding: $feeding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmReportImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.population, population) ||
                other.population == population) &&
            (identical(other.financial, financial) ||
                other.financial == financial) &&
            (identical(other.health, health) || other.health == health) &&
            (identical(other.breeding, breeding) ||
                other.breeding == breeding) &&
            (identical(other.feeding, feeding) || other.feeding == feeding));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    period,
    population,
    financial,
    health,
    breeding,
    feeding,
  );

  /// Create a copy of FarmReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmReportImplCopyWith<_$FarmReportImpl> get copyWith =>
      __$$FarmReportImplCopyWithImpl<_$FarmReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FarmReportImplToJson(this);
  }
}

abstract class _FarmReport implements FarmReport {
  const factory _FarmReport({
    required final ReportPeriod period,
    required final PopulationData population,
    required final FinancialData financial,
    required final HealthData health,
    required final BreedingData breeding,
    required final FeedingData feeding,
  }) = _$FarmReportImpl;

  factory _FarmReport.fromJson(Map<String, dynamic> json) =
      _$FarmReportImpl.fromJson;

  @override
  ReportPeriod get period;
  @override
  PopulationData get population;
  @override
  FinancialData get financial;
  @override
  HealthData get health;
  @override
  BreedingData get breeding;
  @override
  FeedingData get feeding;

  /// Create a copy of FarmReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmReportImplCopyWith<_$FarmReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportPeriod _$ReportPeriodFromJson(Map<String, dynamic> json) {
  return _ReportPeriod.fromJson(json);
}

/// @nodoc
mixin _$ReportPeriod {
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;

  /// Serializes this ReportPeriod to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportPeriodCopyWith<ReportPeriod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportPeriodCopyWith<$Res> {
  factory $ReportPeriodCopyWith(
    ReportPeriod value,
    $Res Function(ReportPeriod) then,
  ) = _$ReportPeriodCopyWithImpl<$Res, ReportPeriod>;
  @useResult
  $Res call({String from, String to});
}

/// @nodoc
class _$ReportPeriodCopyWithImpl<$Res, $Val extends ReportPeriod>
    implements $ReportPeriodCopyWith<$Res> {
  _$ReportPeriodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? from = null, Object? to = null}) {
    return _then(
      _value.copyWith(
            from: null == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as String,
            to: null == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportPeriodImplCopyWith<$Res>
    implements $ReportPeriodCopyWith<$Res> {
  factory _$$ReportPeriodImplCopyWith(
    _$ReportPeriodImpl value,
    $Res Function(_$ReportPeriodImpl) then,
  ) = __$$ReportPeriodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String from, String to});
}

/// @nodoc
class __$$ReportPeriodImplCopyWithImpl<$Res>
    extends _$ReportPeriodCopyWithImpl<$Res, _$ReportPeriodImpl>
    implements _$$ReportPeriodImplCopyWith<$Res> {
  __$$ReportPeriodImplCopyWithImpl(
    _$ReportPeriodImpl _value,
    $Res Function(_$ReportPeriodImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? from = null, Object? to = null}) {
    return _then(
      _$ReportPeriodImpl(
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportPeriodImpl implements _ReportPeriod {
  const _$ReportPeriodImpl({required this.from, required this.to});

  factory _$ReportPeriodImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportPeriodImplFromJson(json);

  @override
  final String from;
  @override
  final String to;

  @override
  String toString() {
    return 'ReportPeriod(from: $from, to: $to)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportPeriodImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, from, to);

  /// Create a copy of ReportPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportPeriodImplCopyWith<_$ReportPeriodImpl> get copyWith =>
      __$$ReportPeriodImplCopyWithImpl<_$ReportPeriodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportPeriodImplToJson(this);
  }
}

abstract class _ReportPeriod implements ReportPeriod {
  const factory _ReportPeriod({
    required final String from,
    required final String to,
  }) = _$ReportPeriodImpl;

  factory _ReportPeriod.fromJson(Map<String, dynamic> json) =
      _$ReportPeriodImpl.fromJson;

  @override
  String get from;
  @override
  String get to;

  /// Create a copy of ReportPeriod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportPeriodImplCopyWith<_$ReportPeriodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PopulationData _$PopulationDataFromJson(Map<String, dynamic> json) {
  return _PopulationData.fromJson(json);
}

/// @nodoc
mixin _$PopulationData {
  @JsonKey(name: 'total_rabbits')
  @IntConverter()
  int get totalRabbits => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_breed')
  List<BreedCount> get byBreed => throw _privateConstructorUsedError;

  /// Serializes this PopulationData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PopulationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PopulationDataCopyWith<PopulationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PopulationDataCopyWith<$Res> {
  factory $PopulationDataCopyWith(
    PopulationData value,
    $Res Function(PopulationData) then,
  ) = _$PopulationDataCopyWithImpl<$Res, PopulationData>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_rabbits') @IntConverter() int totalRabbits,
    @JsonKey(name: 'by_breed') List<BreedCount> byBreed,
  });
}

/// @nodoc
class _$PopulationDataCopyWithImpl<$Res, $Val extends PopulationData>
    implements $PopulationDataCopyWith<$Res> {
  _$PopulationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PopulationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalRabbits = null, Object? byBreed = null}) {
    return _then(
      _value.copyWith(
            totalRabbits: null == totalRabbits
                ? _value.totalRabbits
                : totalRabbits // ignore: cast_nullable_to_non_nullable
                      as int,
            byBreed: null == byBreed
                ? _value.byBreed
                : byBreed // ignore: cast_nullable_to_non_nullable
                      as List<BreedCount>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PopulationDataImplCopyWith<$Res>
    implements $PopulationDataCopyWith<$Res> {
  factory _$$PopulationDataImplCopyWith(
    _$PopulationDataImpl value,
    $Res Function(_$PopulationDataImpl) then,
  ) = __$$PopulationDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_rabbits') @IntConverter() int totalRabbits,
    @JsonKey(name: 'by_breed') List<BreedCount> byBreed,
  });
}

/// @nodoc
class __$$PopulationDataImplCopyWithImpl<$Res>
    extends _$PopulationDataCopyWithImpl<$Res, _$PopulationDataImpl>
    implements _$$PopulationDataImplCopyWith<$Res> {
  __$$PopulationDataImplCopyWithImpl(
    _$PopulationDataImpl _value,
    $Res Function(_$PopulationDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PopulationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalRabbits = null, Object? byBreed = null}) {
    return _then(
      _$PopulationDataImpl(
        totalRabbits: null == totalRabbits
            ? _value.totalRabbits
            : totalRabbits // ignore: cast_nullable_to_non_nullable
                  as int,
        byBreed: null == byBreed
            ? _value._byBreed
            : byBreed // ignore: cast_nullable_to_non_nullable
                  as List<BreedCount>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PopulationDataImpl implements _PopulationData {
  const _$PopulationDataImpl({
    @JsonKey(name: 'total_rabbits') @IntConverter() required this.totalRabbits,
    @JsonKey(name: 'by_breed') required final List<BreedCount> byBreed,
  }) : _byBreed = byBreed;

  factory _$PopulationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PopulationDataImplFromJson(json);

  @override
  @JsonKey(name: 'total_rabbits')
  @IntConverter()
  final int totalRabbits;
  final List<BreedCount> _byBreed;
  @override
  @JsonKey(name: 'by_breed')
  List<BreedCount> get byBreed {
    if (_byBreed is EqualUnmodifiableListView) return _byBreed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byBreed);
  }

  @override
  String toString() {
    return 'PopulationData(totalRabbits: $totalRabbits, byBreed: $byBreed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PopulationDataImpl &&
            (identical(other.totalRabbits, totalRabbits) ||
                other.totalRabbits == totalRabbits) &&
            const DeepCollectionEquality().equals(other._byBreed, _byBreed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalRabbits,
    const DeepCollectionEquality().hash(_byBreed),
  );

  /// Create a copy of PopulationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PopulationDataImplCopyWith<_$PopulationDataImpl> get copyWith =>
      __$$PopulationDataImplCopyWithImpl<_$PopulationDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PopulationDataImplToJson(this);
  }
}

abstract class _PopulationData implements PopulationData {
  const factory _PopulationData({
    @JsonKey(name: 'total_rabbits')
    @IntConverter()
    required final int totalRabbits,
    @JsonKey(name: 'by_breed') required final List<BreedCount> byBreed,
  }) = _$PopulationDataImpl;

  factory _PopulationData.fromJson(Map<String, dynamic> json) =
      _$PopulationDataImpl.fromJson;

  @override
  @JsonKey(name: 'total_rabbits')
  @IntConverter()
  int get totalRabbits;
  @override
  @JsonKey(name: 'by_breed')
  List<BreedCount> get byBreed;

  /// Create a copy of PopulationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PopulationDataImplCopyWith<_$PopulationDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BreedCount _$BreedCountFromJson(Map<String, dynamic> json) {
  return _BreedCount.fromJson(json);
}

/// @nodoc
mixin _$BreedCount {
  @JsonKey(name: 'breed_id')
  @IntConverter()
  int get breedId => throw _privateConstructorUsedError;
  @IntConverter()
  int get count => throw _privateConstructorUsedError;

  /// Serializes this BreedCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BreedCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreedCountCopyWith<BreedCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreedCountCopyWith<$Res> {
  factory $BreedCountCopyWith(
    BreedCount value,
    $Res Function(BreedCount) then,
  ) = _$BreedCountCopyWithImpl<$Res, BreedCount>;
  @useResult
  $Res call({
    @JsonKey(name: 'breed_id') @IntConverter() int breedId,
    @IntConverter() int count,
  });
}

/// @nodoc
class _$BreedCountCopyWithImpl<$Res, $Val extends BreedCount>
    implements $BreedCountCopyWith<$Res> {
  _$BreedCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreedCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? breedId = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            breedId: null == breedId
                ? _value.breedId
                : breedId // ignore: cast_nullable_to_non_nullable
                      as int,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreedCountImplCopyWith<$Res>
    implements $BreedCountCopyWith<$Res> {
  factory _$$BreedCountImplCopyWith(
    _$BreedCountImpl value,
    $Res Function(_$BreedCountImpl) then,
  ) = __$$BreedCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'breed_id') @IntConverter() int breedId,
    @IntConverter() int count,
  });
}

/// @nodoc
class __$$BreedCountImplCopyWithImpl<$Res>
    extends _$BreedCountCopyWithImpl<$Res, _$BreedCountImpl>
    implements _$$BreedCountImplCopyWith<$Res> {
  __$$BreedCountImplCopyWithImpl(
    _$BreedCountImpl _value,
    $Res Function(_$BreedCountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreedCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? breedId = null, Object? count = null}) {
    return _then(
      _$BreedCountImpl(
        breedId: null == breedId
            ? _value.breedId
            : breedId // ignore: cast_nullable_to_non_nullable
                  as int,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BreedCountImpl implements _BreedCount {
  const _$BreedCountImpl({
    @JsonKey(name: 'breed_id') @IntConverter() required this.breedId,
    @IntConverter() required this.count,
  });

  factory _$BreedCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreedCountImplFromJson(json);

  @override
  @JsonKey(name: 'breed_id')
  @IntConverter()
  final int breedId;
  @override
  @IntConverter()
  final int count;

  @override
  String toString() {
    return 'BreedCount(breedId: $breedId, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreedCountImpl &&
            (identical(other.breedId, breedId) || other.breedId == breedId) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, breedId, count);

  /// Create a copy of BreedCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreedCountImplCopyWith<_$BreedCountImpl> get copyWith =>
      __$$BreedCountImplCopyWithImpl<_$BreedCountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreedCountImplToJson(this);
  }
}

abstract class _BreedCount implements BreedCount {
  const factory _BreedCount({
    @JsonKey(name: 'breed_id') @IntConverter() required final int breedId,
    @IntConverter() required final int count,
  }) = _$BreedCountImpl;

  factory _BreedCount.fromJson(Map<String, dynamic> json) =
      _$BreedCountImpl.fromJson;

  @override
  @JsonKey(name: 'breed_id')
  @IntConverter()
  int get breedId;
  @override
  @IntConverter()
  int get count;

  /// Create a copy of BreedCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreedCountImplCopyWith<_$BreedCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialData _$FinancialDataFromJson(Map<String, dynamic> json) {
  return _FinancialData.fromJson(json);
}

/// @nodoc
mixin _$FinancialData {
  List<dynamic> get transactions => throw _privateConstructorUsedError;
  FinancialSummary get summary => throw _privateConstructorUsedError;

  /// Serializes this FinancialData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialDataCopyWith<FinancialData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialDataCopyWith<$Res> {
  factory $FinancialDataCopyWith(
    FinancialData value,
    $Res Function(FinancialData) then,
  ) = _$FinancialDataCopyWithImpl<$Res, FinancialData>;
  @useResult
  $Res call({List<dynamic> transactions, FinancialSummary summary});

  $FinancialSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$FinancialDataCopyWithImpl<$Res, $Val extends FinancialData>
    implements $FinancialDataCopyWith<$Res> {
  _$FinancialDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? transactions = null, Object? summary = null}) {
    return _then(
      _value.copyWith(
            transactions: null == transactions
                ? _value.transactions
                : transactions // ignore: cast_nullable_to_non_nullable
                      as List<dynamic>,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as FinancialSummary,
          )
          as $Val,
    );
  }

  /// Create a copy of FinancialData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FinancialSummaryCopyWith<$Res> get summary {
    return $FinancialSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FinancialDataImplCopyWith<$Res>
    implements $FinancialDataCopyWith<$Res> {
  factory _$$FinancialDataImplCopyWith(
    _$FinancialDataImpl value,
    $Res Function(_$FinancialDataImpl) then,
  ) = __$$FinancialDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<dynamic> transactions, FinancialSummary summary});

  @override
  $FinancialSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$FinancialDataImplCopyWithImpl<$Res>
    extends _$FinancialDataCopyWithImpl<$Res, _$FinancialDataImpl>
    implements _$$FinancialDataImplCopyWith<$Res> {
  __$$FinancialDataImplCopyWithImpl(
    _$FinancialDataImpl _value,
    $Res Function(_$FinancialDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? transactions = null, Object? summary = null}) {
    return _then(
      _$FinancialDataImpl(
        transactions: null == transactions
            ? _value._transactions
            : transactions // ignore: cast_nullable_to_non_nullable
                  as List<dynamic>,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as FinancialSummary,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialDataImpl implements _FinancialData {
  const _$FinancialDataImpl({
    required final List<dynamic> transactions,
    required this.summary,
  }) : _transactions = transactions;

  factory _$FinancialDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialDataImplFromJson(json);

  final List<dynamic> _transactions;
  @override
  List<dynamic> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  final FinancialSummary summary;

  @override
  String toString() {
    return 'FinancialData(transactions: $transactions, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialDataImpl &&
            const DeepCollectionEquality().equals(
              other._transactions,
              _transactions,
            ) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_transactions),
    summary,
  );

  /// Create a copy of FinancialData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialDataImplCopyWith<_$FinancialDataImpl> get copyWith =>
      __$$FinancialDataImplCopyWithImpl<_$FinancialDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialDataImplToJson(this);
  }
}

abstract class _FinancialData implements FinancialData {
  const factory _FinancialData({
    required final List<dynamic> transactions,
    required final FinancialSummary summary,
  }) = _$FinancialDataImpl;

  factory _FinancialData.fromJson(Map<String, dynamic> json) =
      _$FinancialDataImpl.fromJson;

  @override
  List<dynamic> get transactions;
  @override
  FinancialSummary get summary;

  /// Create a copy of FinancialData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialDataImplCopyWith<_$FinancialDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialSummary _$FinancialSummaryFromJson(Map<String, dynamic> json) {
  return _FinancialSummary.fromJson(json);
}

/// @nodoc
mixin _$FinancialSummary {
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  double get totalIncome => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  double get totalExpenses => throw _privateConstructorUsedError;

  /// Serializes this FinancialSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialSummaryCopyWith<FinancialSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialSummaryCopyWith<$Res> {
  factory $FinancialSummaryCopyWith(
    FinancialSummary value,
    $Res Function(FinancialSummary) then,
  ) = _$FinancialSummaryCopyWithImpl<$Res, FinancialSummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_income') @DoubleConverter() double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() double totalExpenses,
  });
}

/// @nodoc
class _$FinancialSummaryCopyWithImpl<$Res, $Val extends FinancialSummary>
    implements $FinancialSummaryCopyWith<$Res> {
  _$FinancialSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalIncome = null, Object? totalExpenses = null}) {
    return _then(
      _value.copyWith(
            totalIncome: null == totalIncome
                ? _value.totalIncome
                : totalIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            totalExpenses: null == totalExpenses
                ? _value.totalExpenses
                : totalExpenses // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinancialSummaryImplCopyWith<$Res>
    implements $FinancialSummaryCopyWith<$Res> {
  factory _$$FinancialSummaryImplCopyWith(
    _$FinancialSummaryImpl value,
    $Res Function(_$FinancialSummaryImpl) then,
  ) = __$$FinancialSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_income') @DoubleConverter() double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() double totalExpenses,
  });
}

/// @nodoc
class __$$FinancialSummaryImplCopyWithImpl<$Res>
    extends _$FinancialSummaryCopyWithImpl<$Res, _$FinancialSummaryImpl>
    implements _$$FinancialSummaryImplCopyWith<$Res> {
  __$$FinancialSummaryImplCopyWithImpl(
    _$FinancialSummaryImpl _value,
    $Res Function(_$FinancialSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalIncome = null, Object? totalExpenses = null}) {
    return _then(
      _$FinancialSummaryImpl(
        totalIncome: null == totalIncome
            ? _value.totalIncome
            : totalIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        totalExpenses: null == totalExpenses
            ? _value.totalExpenses
            : totalExpenses // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialSummaryImpl implements _FinancialSummary {
  const _$FinancialSummaryImpl({
    @JsonKey(name: 'total_income') @DoubleConverter() required this.totalIncome,
    @JsonKey(name: 'total_expenses')
    @DoubleConverter()
    required this.totalExpenses,
  });

  factory _$FinancialSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  final double totalIncome;
  @override
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  final double totalExpenses;

  @override
  String toString() {
    return 'FinancialSummary(totalIncome: $totalIncome, totalExpenses: $totalExpenses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialSummaryImpl &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalIncome, totalExpenses);

  /// Create a copy of FinancialSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialSummaryImplCopyWith<_$FinancialSummaryImpl> get copyWith =>
      __$$FinancialSummaryImplCopyWithImpl<_$FinancialSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialSummaryImplToJson(this);
  }
}

abstract class _FinancialSummary implements FinancialSummary {
  const factory _FinancialSummary({
    @JsonKey(name: 'total_income')
    @DoubleConverter()
    required final double totalIncome,
    @JsonKey(name: 'total_expenses')
    @DoubleConverter()
    required final double totalExpenses,
  }) = _$FinancialSummaryImpl;

  factory _FinancialSummary.fromJson(Map<String, dynamic> json) =
      _$FinancialSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  double get totalIncome;
  @override
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  double get totalExpenses;

  /// Create a copy of FinancialSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialSummaryImplCopyWith<_$FinancialSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HealthData _$HealthDataFromJson(Map<String, dynamic> json) {
  return _HealthData.fromJson(json);
}

/// @nodoc
mixin _$HealthData {
  @IntConverter()
  int get vaccinations => throw _privateConstructorUsedError;
  @JsonKey(name: 'medical_records')
  @IntConverter()
  int get medicalRecords => throw _privateConstructorUsedError;

  /// Serializes this HealthData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthDataCopyWith<HealthData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthDataCopyWith<$Res> {
  factory $HealthDataCopyWith(
    HealthData value,
    $Res Function(HealthData) then,
  ) = _$HealthDataCopyWithImpl<$Res, HealthData>;
  @useResult
  $Res call({
    @IntConverter() int vaccinations,
    @JsonKey(name: 'medical_records') @IntConverter() int medicalRecords,
  });
}

/// @nodoc
class _$HealthDataCopyWithImpl<$Res, $Val extends HealthData>
    implements $HealthDataCopyWith<$Res> {
  _$HealthDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vaccinations = null, Object? medicalRecords = null}) {
    return _then(
      _value.copyWith(
            vaccinations: null == vaccinations
                ? _value.vaccinations
                : vaccinations // ignore: cast_nullable_to_non_nullable
                      as int,
            medicalRecords: null == medicalRecords
                ? _value.medicalRecords
                : medicalRecords // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HealthDataImplCopyWith<$Res>
    implements $HealthDataCopyWith<$Res> {
  factory _$$HealthDataImplCopyWith(
    _$HealthDataImpl value,
    $Res Function(_$HealthDataImpl) then,
  ) = __$$HealthDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int vaccinations,
    @JsonKey(name: 'medical_records') @IntConverter() int medicalRecords,
  });
}

/// @nodoc
class __$$HealthDataImplCopyWithImpl<$Res>
    extends _$HealthDataCopyWithImpl<$Res, _$HealthDataImpl>
    implements _$$HealthDataImplCopyWith<$Res> {
  __$$HealthDataImplCopyWithImpl(
    _$HealthDataImpl _value,
    $Res Function(_$HealthDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HealthData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vaccinations = null, Object? medicalRecords = null}) {
    return _then(
      _$HealthDataImpl(
        vaccinations: null == vaccinations
            ? _value.vaccinations
            : vaccinations // ignore: cast_nullable_to_non_nullable
                  as int,
        medicalRecords: null == medicalRecords
            ? _value.medicalRecords
            : medicalRecords // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthDataImpl implements _HealthData {
  const _$HealthDataImpl({
    @IntConverter() required this.vaccinations,
    @JsonKey(name: 'medical_records')
    @IntConverter()
    required this.medicalRecords,
  });

  factory _$HealthDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthDataImplFromJson(json);

  @override
  @IntConverter()
  final int vaccinations;
  @override
  @JsonKey(name: 'medical_records')
  @IntConverter()
  final int medicalRecords;

  @override
  String toString() {
    return 'HealthData(vaccinations: $vaccinations, medicalRecords: $medicalRecords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthDataImpl &&
            (identical(other.vaccinations, vaccinations) ||
                other.vaccinations == vaccinations) &&
            (identical(other.medicalRecords, medicalRecords) ||
                other.medicalRecords == medicalRecords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vaccinations, medicalRecords);

  /// Create a copy of HealthData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthDataImplCopyWith<_$HealthDataImpl> get copyWith =>
      __$$HealthDataImplCopyWithImpl<_$HealthDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthDataImplToJson(this);
  }
}

abstract class _HealthData implements HealthData {
  const factory _HealthData({
    @IntConverter() required final int vaccinations,
    @JsonKey(name: 'medical_records')
    @IntConverter()
    required final int medicalRecords,
  }) = _$HealthDataImpl;

  factory _HealthData.fromJson(Map<String, dynamic> json) =
      _$HealthDataImpl.fromJson;

  @override
  @IntConverter()
  int get vaccinations;
  @override
  @JsonKey(name: 'medical_records')
  @IntConverter()
  int get medicalRecords;

  /// Create a copy of HealthData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthDataImplCopyWith<_$HealthDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BreedingData _$BreedingDataFromJson(Map<String, dynamic> json) {
  return _BreedingData.fromJson(json);
}

/// @nodoc
mixin _$BreedingData {
  @IntConverter()
  int get breedings => throw _privateConstructorUsedError;
  @IntConverter()
  int get births => throw _privateConstructorUsedError;

  /// Serializes this BreedingData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BreedingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreedingDataCopyWith<BreedingData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreedingDataCopyWith<$Res> {
  factory $BreedingDataCopyWith(
    BreedingData value,
    $Res Function(BreedingData) then,
  ) = _$BreedingDataCopyWithImpl<$Res, BreedingData>;
  @useResult
  $Res call({@IntConverter() int breedings, @IntConverter() int births});
}

/// @nodoc
class _$BreedingDataCopyWithImpl<$Res, $Val extends BreedingData>
    implements $BreedingDataCopyWith<$Res> {
  _$BreedingDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreedingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? breedings = null, Object? births = null}) {
    return _then(
      _value.copyWith(
            breedings: null == breedings
                ? _value.breedings
                : breedings // ignore: cast_nullable_to_non_nullable
                      as int,
            births: null == births
                ? _value.births
                : births // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreedingDataImplCopyWith<$Res>
    implements $BreedingDataCopyWith<$Res> {
  factory _$$BreedingDataImplCopyWith(
    _$BreedingDataImpl value,
    $Res Function(_$BreedingDataImpl) then,
  ) = __$$BreedingDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@IntConverter() int breedings, @IntConverter() int births});
}

/// @nodoc
class __$$BreedingDataImplCopyWithImpl<$Res>
    extends _$BreedingDataCopyWithImpl<$Res, _$BreedingDataImpl>
    implements _$$BreedingDataImplCopyWith<$Res> {
  __$$BreedingDataImplCopyWithImpl(
    _$BreedingDataImpl _value,
    $Res Function(_$BreedingDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreedingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? breedings = null, Object? births = null}) {
    return _then(
      _$BreedingDataImpl(
        breedings: null == breedings
            ? _value.breedings
            : breedings // ignore: cast_nullable_to_non_nullable
                  as int,
        births: null == births
            ? _value.births
            : births // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BreedingDataImpl implements _BreedingData {
  const _$BreedingDataImpl({
    @IntConverter() required this.breedings,
    @IntConverter() required this.births,
  });

  factory _$BreedingDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreedingDataImplFromJson(json);

  @override
  @IntConverter()
  final int breedings;
  @override
  @IntConverter()
  final int births;

  @override
  String toString() {
    return 'BreedingData(breedings: $breedings, births: $births)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreedingDataImpl &&
            (identical(other.breedings, breedings) ||
                other.breedings == breedings) &&
            (identical(other.births, births) || other.births == births));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, breedings, births);

  /// Create a copy of BreedingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreedingDataImplCopyWith<_$BreedingDataImpl> get copyWith =>
      __$$BreedingDataImplCopyWithImpl<_$BreedingDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreedingDataImplToJson(this);
  }
}

abstract class _BreedingData implements BreedingData {
  const factory _BreedingData({
    @IntConverter() required final int breedings,
    @IntConverter() required final int births,
  }) = _$BreedingDataImpl;

  factory _BreedingData.fromJson(Map<String, dynamic> json) =
      _$BreedingDataImpl.fromJson;

  @override
  @IntConverter()
  int get breedings;
  @override
  @IntConverter()
  int get births;

  /// Create a copy of BreedingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreedingDataImplCopyWith<_$BreedingDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedingData _$FeedingDataFromJson(Map<String, dynamic> json) {
  return _FeedingData.fromJson(json);
}

/// @nodoc
mixin _$FeedingData {
  @JsonKey(name: 'total_feeding_records')
  @IntConverter()
  int get totalFeedingRecords => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_feed_consumption')
  @DoubleConverter()
  double get totalFeedConsumption => throw _privateConstructorUsedError;

  /// Serializes this FeedingData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedingDataCopyWith<FeedingData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedingDataCopyWith<$Res> {
  factory $FeedingDataCopyWith(
    FeedingData value,
    $Res Function(FeedingData) then,
  ) = _$FeedingDataCopyWithImpl<$Res, FeedingData>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_feeding_records')
    @IntConverter()
    int totalFeedingRecords,
    @JsonKey(name: 'total_feed_consumption')
    @DoubleConverter()
    double totalFeedConsumption,
  });
}

/// @nodoc
class _$FeedingDataCopyWithImpl<$Res, $Val extends FeedingData>
    implements $FeedingDataCopyWith<$Res> {
  _$FeedingDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalFeedingRecords = null,
    Object? totalFeedConsumption = null,
  }) {
    return _then(
      _value.copyWith(
            totalFeedingRecords: null == totalFeedingRecords
                ? _value.totalFeedingRecords
                : totalFeedingRecords // ignore: cast_nullable_to_non_nullable
                      as int,
            totalFeedConsumption: null == totalFeedConsumption
                ? _value.totalFeedConsumption
                : totalFeedConsumption // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedingDataImplCopyWith<$Res>
    implements $FeedingDataCopyWith<$Res> {
  factory _$$FeedingDataImplCopyWith(
    _$FeedingDataImpl value,
    $Res Function(_$FeedingDataImpl) then,
  ) = __$$FeedingDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_feeding_records')
    @IntConverter()
    int totalFeedingRecords,
    @JsonKey(name: 'total_feed_consumption')
    @DoubleConverter()
    double totalFeedConsumption,
  });
}

/// @nodoc
class __$$FeedingDataImplCopyWithImpl<$Res>
    extends _$FeedingDataCopyWithImpl<$Res, _$FeedingDataImpl>
    implements _$$FeedingDataImplCopyWith<$Res> {
  __$$FeedingDataImplCopyWithImpl(
    _$FeedingDataImpl _value,
    $Res Function(_$FeedingDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalFeedingRecords = null,
    Object? totalFeedConsumption = null,
  }) {
    return _then(
      _$FeedingDataImpl(
        totalFeedingRecords: null == totalFeedingRecords
            ? _value.totalFeedingRecords
            : totalFeedingRecords // ignore: cast_nullable_to_non_nullable
                  as int,
        totalFeedConsumption: null == totalFeedConsumption
            ? _value.totalFeedConsumption
            : totalFeedConsumption // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedingDataImpl implements _FeedingData {
  const _$FeedingDataImpl({
    @JsonKey(name: 'total_feeding_records')
    @IntConverter()
    required this.totalFeedingRecords,
    @JsonKey(name: 'total_feed_consumption')
    @DoubleConverter()
    required this.totalFeedConsumption,
  });

  factory _$FeedingDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedingDataImplFromJson(json);

  @override
  @JsonKey(name: 'total_feeding_records')
  @IntConverter()
  final int totalFeedingRecords;
  @override
  @JsonKey(name: 'total_feed_consumption')
  @DoubleConverter()
  final double totalFeedConsumption;

  @override
  String toString() {
    return 'FeedingData(totalFeedingRecords: $totalFeedingRecords, totalFeedConsumption: $totalFeedConsumption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedingDataImpl &&
            (identical(other.totalFeedingRecords, totalFeedingRecords) ||
                other.totalFeedingRecords == totalFeedingRecords) &&
            (identical(other.totalFeedConsumption, totalFeedConsumption) ||
                other.totalFeedConsumption == totalFeedConsumption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalFeedingRecords, totalFeedConsumption);

  /// Create a copy of FeedingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedingDataImplCopyWith<_$FeedingDataImpl> get copyWith =>
      __$$FeedingDataImplCopyWithImpl<_$FeedingDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedingDataImplToJson(this);
  }
}

abstract class _FeedingData implements FeedingData {
  const factory _FeedingData({
    @JsonKey(name: 'total_feeding_records')
    @IntConverter()
    required final int totalFeedingRecords,
    @JsonKey(name: 'total_feed_consumption')
    @DoubleConverter()
    required final double totalFeedConsumption,
  }) = _$FeedingDataImpl;

  factory _FeedingData.fromJson(Map<String, dynamic> json) =
      _$FeedingDataImpl.fromJson;

  @override
  @JsonKey(name: 'total_feeding_records')
  @IntConverter()
  int get totalFeedingRecords;
  @override
  @JsonKey(name: 'total_feed_consumption')
  @DoubleConverter()
  double get totalFeedConsumption;

  /// Create a copy of FeedingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedingDataImplCopyWith<_$FeedingDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HealthReport _$HealthReportFromJson(Map<String, dynamic> json) {
  return _HealthReport.fromJson(json);
}

/// @nodoc
mixin _$HealthReport {
  VaccinationsData get vaccinations => throw _privateConstructorUsedError;
  @JsonKey(name: 'medical_records')
  MedicalRecordsData get medicalRecords => throw _privateConstructorUsedError;

  /// Serializes this HealthReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthReportCopyWith<HealthReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthReportCopyWith<$Res> {
  factory $HealthReportCopyWith(
    HealthReport value,
    $Res Function(HealthReport) then,
  ) = _$HealthReportCopyWithImpl<$Res, HealthReport>;
  @useResult
  $Res call({
    VaccinationsData vaccinations,
    @JsonKey(name: 'medical_records') MedicalRecordsData medicalRecords,
  });

  $VaccinationsDataCopyWith<$Res> get vaccinations;
  $MedicalRecordsDataCopyWith<$Res> get medicalRecords;
}

/// @nodoc
class _$HealthReportCopyWithImpl<$Res, $Val extends HealthReport>
    implements $HealthReportCopyWith<$Res> {
  _$HealthReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vaccinations = null, Object? medicalRecords = null}) {
    return _then(
      _value.copyWith(
            vaccinations: null == vaccinations
                ? _value.vaccinations
                : vaccinations // ignore: cast_nullable_to_non_nullable
                      as VaccinationsData,
            medicalRecords: null == medicalRecords
                ? _value.medicalRecords
                : medicalRecords // ignore: cast_nullable_to_non_nullable
                      as MedicalRecordsData,
          )
          as $Val,
    );
  }

  /// Create a copy of HealthReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VaccinationsDataCopyWith<$Res> get vaccinations {
    return $VaccinationsDataCopyWith<$Res>(_value.vaccinations, (value) {
      return _then(_value.copyWith(vaccinations: value) as $Val);
    });
  }

  /// Create a copy of HealthReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicalRecordsDataCopyWith<$Res> get medicalRecords {
    return $MedicalRecordsDataCopyWith<$Res>(_value.medicalRecords, (value) {
      return _then(_value.copyWith(medicalRecords: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HealthReportImplCopyWith<$Res>
    implements $HealthReportCopyWith<$Res> {
  factory _$$HealthReportImplCopyWith(
    _$HealthReportImpl value,
    $Res Function(_$HealthReportImpl) then,
  ) = __$$HealthReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    VaccinationsData vaccinations,
    @JsonKey(name: 'medical_records') MedicalRecordsData medicalRecords,
  });

  @override
  $VaccinationsDataCopyWith<$Res> get vaccinations;
  @override
  $MedicalRecordsDataCopyWith<$Res> get medicalRecords;
}

/// @nodoc
class __$$HealthReportImplCopyWithImpl<$Res>
    extends _$HealthReportCopyWithImpl<$Res, _$HealthReportImpl>
    implements _$$HealthReportImplCopyWith<$Res> {
  __$$HealthReportImplCopyWithImpl(
    _$HealthReportImpl _value,
    $Res Function(_$HealthReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HealthReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vaccinations = null, Object? medicalRecords = null}) {
    return _then(
      _$HealthReportImpl(
        vaccinations: null == vaccinations
            ? _value.vaccinations
            : vaccinations // ignore: cast_nullable_to_non_nullable
                  as VaccinationsData,
        medicalRecords: null == medicalRecords
            ? _value.medicalRecords
            : medicalRecords // ignore: cast_nullable_to_non_nullable
                  as MedicalRecordsData,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthReportImpl implements _HealthReport {
  const _$HealthReportImpl({
    required this.vaccinations,
    @JsonKey(name: 'medical_records') required this.medicalRecords,
  });

  factory _$HealthReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthReportImplFromJson(json);

  @override
  final VaccinationsData vaccinations;
  @override
  @JsonKey(name: 'medical_records')
  final MedicalRecordsData medicalRecords;

  @override
  String toString() {
    return 'HealthReport(vaccinations: $vaccinations, medicalRecords: $medicalRecords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthReportImpl &&
            (identical(other.vaccinations, vaccinations) ||
                other.vaccinations == vaccinations) &&
            (identical(other.medicalRecords, medicalRecords) ||
                other.medicalRecords == medicalRecords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vaccinations, medicalRecords);

  /// Create a copy of HealthReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthReportImplCopyWith<_$HealthReportImpl> get copyWith =>
      __$$HealthReportImplCopyWithImpl<_$HealthReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthReportImplToJson(this);
  }
}

abstract class _HealthReport implements HealthReport {
  const factory _HealthReport({
    required final VaccinationsData vaccinations,
    @JsonKey(name: 'medical_records')
    required final MedicalRecordsData medicalRecords,
  }) = _$HealthReportImpl;

  factory _HealthReport.fromJson(Map<String, dynamic> json) =
      _$HealthReportImpl.fromJson;

  @override
  VaccinationsData get vaccinations;
  @override
  @JsonKey(name: 'medical_records')
  MedicalRecordsData get medicalRecords;

  /// Create a copy of HealthReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthReportImplCopyWith<_$HealthReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VaccinationsData _$VaccinationsDataFromJson(Map<String, dynamic> json) {
  return _VaccinationsData.fromJson(json);
}

/// @nodoc
mixin _$VaccinationsData {
  @JsonKey(name: 'by_type')
  List<VaccineTypeCount> get byType => throw _privateConstructorUsedError;
  List<dynamic> get upcoming => throw _privateConstructorUsedError;

  /// Serializes this VaccinationsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VaccinationsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaccinationsDataCopyWith<VaccinationsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaccinationsDataCopyWith<$Res> {
  factory $VaccinationsDataCopyWith(
    VaccinationsData value,
    $Res Function(VaccinationsData) then,
  ) = _$VaccinationsDataCopyWithImpl<$Res, VaccinationsData>;
  @useResult
  $Res call({
    @JsonKey(name: 'by_type') List<VaccineTypeCount> byType,
    List<dynamic> upcoming,
  });
}

/// @nodoc
class _$VaccinationsDataCopyWithImpl<$Res, $Val extends VaccinationsData>
    implements $VaccinationsDataCopyWith<$Res> {
  _$VaccinationsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaccinationsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? byType = null, Object? upcoming = null}) {
    return _then(
      _value.copyWith(
            byType: null == byType
                ? _value.byType
                : byType // ignore: cast_nullable_to_non_nullable
                      as List<VaccineTypeCount>,
            upcoming: null == upcoming
                ? _value.upcoming
                : upcoming // ignore: cast_nullable_to_non_nullable
                      as List<dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VaccinationsDataImplCopyWith<$Res>
    implements $VaccinationsDataCopyWith<$Res> {
  factory _$$VaccinationsDataImplCopyWith(
    _$VaccinationsDataImpl value,
    $Res Function(_$VaccinationsDataImpl) then,
  ) = __$$VaccinationsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'by_type') List<VaccineTypeCount> byType,
    List<dynamic> upcoming,
  });
}

/// @nodoc
class __$$VaccinationsDataImplCopyWithImpl<$Res>
    extends _$VaccinationsDataCopyWithImpl<$Res, _$VaccinationsDataImpl>
    implements _$$VaccinationsDataImplCopyWith<$Res> {
  __$$VaccinationsDataImplCopyWithImpl(
    _$VaccinationsDataImpl _value,
    $Res Function(_$VaccinationsDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VaccinationsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? byType = null, Object? upcoming = null}) {
    return _then(
      _$VaccinationsDataImpl(
        byType: null == byType
            ? _value._byType
            : byType // ignore: cast_nullable_to_non_nullable
                  as List<VaccineTypeCount>,
        upcoming: null == upcoming
            ? _value._upcoming
            : upcoming // ignore: cast_nullable_to_non_nullable
                  as List<dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VaccinationsDataImpl implements _VaccinationsData {
  const _$VaccinationsDataImpl({
    @JsonKey(name: 'by_type') required final List<VaccineTypeCount> byType,
    required final List<dynamic> upcoming,
  }) : _byType = byType,
       _upcoming = upcoming;

  factory _$VaccinationsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaccinationsDataImplFromJson(json);

  final List<VaccineTypeCount> _byType;
  @override
  @JsonKey(name: 'by_type')
  List<VaccineTypeCount> get byType {
    if (_byType is EqualUnmodifiableListView) return _byType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byType);
  }

  final List<dynamic> _upcoming;
  @override
  List<dynamic> get upcoming {
    if (_upcoming is EqualUnmodifiableListView) return _upcoming;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upcoming);
  }

  @override
  String toString() {
    return 'VaccinationsData(byType: $byType, upcoming: $upcoming)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaccinationsDataImpl &&
            const DeepCollectionEquality().equals(other._byType, _byType) &&
            const DeepCollectionEquality().equals(other._upcoming, _upcoming));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_byType),
    const DeepCollectionEquality().hash(_upcoming),
  );

  /// Create a copy of VaccinationsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaccinationsDataImplCopyWith<_$VaccinationsDataImpl> get copyWith =>
      __$$VaccinationsDataImplCopyWithImpl<_$VaccinationsDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VaccinationsDataImplToJson(this);
  }
}

abstract class _VaccinationsData implements VaccinationsData {
  const factory _VaccinationsData({
    @JsonKey(name: 'by_type') required final List<VaccineTypeCount> byType,
    required final List<dynamic> upcoming,
  }) = _$VaccinationsDataImpl;

  factory _VaccinationsData.fromJson(Map<String, dynamic> json) =
      _$VaccinationsDataImpl.fromJson;

  @override
  @JsonKey(name: 'by_type')
  List<VaccineTypeCount> get byType;
  @override
  List<dynamic> get upcoming;

  /// Create a copy of VaccinationsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaccinationsDataImplCopyWith<_$VaccinationsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VaccineTypeCount _$VaccineTypeCountFromJson(Map<String, dynamic> json) {
  return _VaccineTypeCount.fromJson(json);
}

/// @nodoc
mixin _$VaccineTypeCount {
  @JsonKey(name: 'vaccine_name')
  String get vaccineName => throw _privateConstructorUsedError;
  @IntConverter()
  int get count => throw _privateConstructorUsedError;

  /// Serializes this VaccineTypeCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VaccineTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaccineTypeCountCopyWith<VaccineTypeCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaccineTypeCountCopyWith<$Res> {
  factory $VaccineTypeCountCopyWith(
    VaccineTypeCount value,
    $Res Function(VaccineTypeCount) then,
  ) = _$VaccineTypeCountCopyWithImpl<$Res, VaccineTypeCount>;
  @useResult
  $Res call({
    @JsonKey(name: 'vaccine_name') String vaccineName,
    @IntConverter() int count,
  });
}

/// @nodoc
class _$VaccineTypeCountCopyWithImpl<$Res, $Val extends VaccineTypeCount>
    implements $VaccineTypeCountCopyWith<$Res> {
  _$VaccineTypeCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaccineTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vaccineName = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            vaccineName: null == vaccineName
                ? _value.vaccineName
                : vaccineName // ignore: cast_nullable_to_non_nullable
                      as String,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VaccineTypeCountImplCopyWith<$Res>
    implements $VaccineTypeCountCopyWith<$Res> {
  factory _$$VaccineTypeCountImplCopyWith(
    _$VaccineTypeCountImpl value,
    $Res Function(_$VaccineTypeCountImpl) then,
  ) = __$$VaccineTypeCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'vaccine_name') String vaccineName,
    @IntConverter() int count,
  });
}

/// @nodoc
class __$$VaccineTypeCountImplCopyWithImpl<$Res>
    extends _$VaccineTypeCountCopyWithImpl<$Res, _$VaccineTypeCountImpl>
    implements _$$VaccineTypeCountImplCopyWith<$Res> {
  __$$VaccineTypeCountImplCopyWithImpl(
    _$VaccineTypeCountImpl _value,
    $Res Function(_$VaccineTypeCountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VaccineTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vaccineName = null, Object? count = null}) {
    return _then(
      _$VaccineTypeCountImpl(
        vaccineName: null == vaccineName
            ? _value.vaccineName
            : vaccineName // ignore: cast_nullable_to_non_nullable
                  as String,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VaccineTypeCountImpl implements _VaccineTypeCount {
  const _$VaccineTypeCountImpl({
    @JsonKey(name: 'vaccine_name') required this.vaccineName,
    @IntConverter() required this.count,
  });

  factory _$VaccineTypeCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaccineTypeCountImplFromJson(json);

  @override
  @JsonKey(name: 'vaccine_name')
  final String vaccineName;
  @override
  @IntConverter()
  final int count;

  @override
  String toString() {
    return 'VaccineTypeCount(vaccineName: $vaccineName, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaccineTypeCountImpl &&
            (identical(other.vaccineName, vaccineName) ||
                other.vaccineName == vaccineName) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vaccineName, count);

  /// Create a copy of VaccineTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaccineTypeCountImplCopyWith<_$VaccineTypeCountImpl> get copyWith =>
      __$$VaccineTypeCountImplCopyWithImpl<_$VaccineTypeCountImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VaccineTypeCountImplToJson(this);
  }
}

abstract class _VaccineTypeCount implements VaccineTypeCount {
  const factory _VaccineTypeCount({
    @JsonKey(name: 'vaccine_name') required final String vaccineName,
    @IntConverter() required final int count,
  }) = _$VaccineTypeCountImpl;

  factory _VaccineTypeCount.fromJson(Map<String, dynamic> json) =
      _$VaccineTypeCountImpl.fromJson;

  @override
  @JsonKey(name: 'vaccine_name')
  String get vaccineName;
  @override
  @IntConverter()
  int get count;

  /// Create a copy of VaccineTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaccineTypeCountImplCopyWith<_$VaccineTypeCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MedicalRecordsData _$MedicalRecordsDataFromJson(Map<String, dynamic> json) {
  return _MedicalRecordsData.fromJson(json);
}

/// @nodoc
mixin _$MedicalRecordsData {
  @JsonKey(name: 'by_type')
  List<RecordTypeCount> get byType => throw _privateConstructorUsedError;

  /// Serializes this MedicalRecordsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalRecordsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalRecordsDataCopyWith<MedicalRecordsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalRecordsDataCopyWith<$Res> {
  factory $MedicalRecordsDataCopyWith(
    MedicalRecordsData value,
    $Res Function(MedicalRecordsData) then,
  ) = _$MedicalRecordsDataCopyWithImpl<$Res, MedicalRecordsData>;
  @useResult
  $Res call({@JsonKey(name: 'by_type') List<RecordTypeCount> byType});
}

/// @nodoc
class _$MedicalRecordsDataCopyWithImpl<$Res, $Val extends MedicalRecordsData>
    implements $MedicalRecordsDataCopyWith<$Res> {
  _$MedicalRecordsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalRecordsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? byType = null}) {
    return _then(
      _value.copyWith(
            byType: null == byType
                ? _value.byType
                : byType // ignore: cast_nullable_to_non_nullable
                      as List<RecordTypeCount>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MedicalRecordsDataImplCopyWith<$Res>
    implements $MedicalRecordsDataCopyWith<$Res> {
  factory _$$MedicalRecordsDataImplCopyWith(
    _$MedicalRecordsDataImpl value,
    $Res Function(_$MedicalRecordsDataImpl) then,
  ) = __$$MedicalRecordsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'by_type') List<RecordTypeCount> byType});
}

/// @nodoc
class __$$MedicalRecordsDataImplCopyWithImpl<$Res>
    extends _$MedicalRecordsDataCopyWithImpl<$Res, _$MedicalRecordsDataImpl>
    implements _$$MedicalRecordsDataImplCopyWith<$Res> {
  __$$MedicalRecordsDataImplCopyWithImpl(
    _$MedicalRecordsDataImpl _value,
    $Res Function(_$MedicalRecordsDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MedicalRecordsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? byType = null}) {
    return _then(
      _$MedicalRecordsDataImpl(
        byType: null == byType
            ? _value._byType
            : byType // ignore: cast_nullable_to_non_nullable
                  as List<RecordTypeCount>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalRecordsDataImpl implements _MedicalRecordsData {
  const _$MedicalRecordsDataImpl({
    @JsonKey(name: 'by_type') required final List<RecordTypeCount> byType,
  }) : _byType = byType;

  factory _$MedicalRecordsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalRecordsDataImplFromJson(json);

  final List<RecordTypeCount> _byType;
  @override
  @JsonKey(name: 'by_type')
  List<RecordTypeCount> get byType {
    if (_byType is EqualUnmodifiableListView) return _byType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byType);
  }

  @override
  String toString() {
    return 'MedicalRecordsData(byType: $byType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalRecordsDataImpl &&
            const DeepCollectionEquality().equals(other._byType, _byType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_byType));

  /// Create a copy of MedicalRecordsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalRecordsDataImplCopyWith<_$MedicalRecordsDataImpl> get copyWith =>
      __$$MedicalRecordsDataImplCopyWithImpl<_$MedicalRecordsDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalRecordsDataImplToJson(this);
  }
}

abstract class _MedicalRecordsData implements MedicalRecordsData {
  const factory _MedicalRecordsData({
    @JsonKey(name: 'by_type') required final List<RecordTypeCount> byType,
  }) = _$MedicalRecordsDataImpl;

  factory _MedicalRecordsData.fromJson(Map<String, dynamic> json) =
      _$MedicalRecordsDataImpl.fromJson;

  @override
  @JsonKey(name: 'by_type')
  List<RecordTypeCount> get byType;

  /// Create a copy of MedicalRecordsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalRecordsDataImplCopyWith<_$MedicalRecordsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecordTypeCount _$RecordTypeCountFromJson(Map<String, dynamic> json) {
  return _RecordTypeCount.fromJson(json);
}

/// @nodoc
mixin _$RecordTypeCount {
  @JsonKey(name: 'record_type')
  String get recordType => throw _privateConstructorUsedError;
  @IntConverter()
  int get count => throw _privateConstructorUsedError;

  /// Serializes this RecordTypeCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecordTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordTypeCountCopyWith<RecordTypeCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordTypeCountCopyWith<$Res> {
  factory $RecordTypeCountCopyWith(
    RecordTypeCount value,
    $Res Function(RecordTypeCount) then,
  ) = _$RecordTypeCountCopyWithImpl<$Res, RecordTypeCount>;
  @useResult
  $Res call({
    @JsonKey(name: 'record_type') String recordType,
    @IntConverter() int count,
  });
}

/// @nodoc
class _$RecordTypeCountCopyWithImpl<$Res, $Val extends RecordTypeCount>
    implements $RecordTypeCountCopyWith<$Res> {
  _$RecordTypeCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? recordType = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            recordType: null == recordType
                ? _value.recordType
                : recordType // ignore: cast_nullable_to_non_nullable
                      as String,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecordTypeCountImplCopyWith<$Res>
    implements $RecordTypeCountCopyWith<$Res> {
  factory _$$RecordTypeCountImplCopyWith(
    _$RecordTypeCountImpl value,
    $Res Function(_$RecordTypeCountImpl) then,
  ) = __$$RecordTypeCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'record_type') String recordType,
    @IntConverter() int count,
  });
}

/// @nodoc
class __$$RecordTypeCountImplCopyWithImpl<$Res>
    extends _$RecordTypeCountCopyWithImpl<$Res, _$RecordTypeCountImpl>
    implements _$$RecordTypeCountImplCopyWith<$Res> {
  __$$RecordTypeCountImplCopyWithImpl(
    _$RecordTypeCountImpl _value,
    $Res Function(_$RecordTypeCountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecordTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? recordType = null, Object? count = null}) {
    return _then(
      _$RecordTypeCountImpl(
        recordType: null == recordType
            ? _value.recordType
            : recordType // ignore: cast_nullable_to_non_nullable
                  as String,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecordTypeCountImpl implements _RecordTypeCount {
  const _$RecordTypeCountImpl({
    @JsonKey(name: 'record_type') required this.recordType,
    @IntConverter() required this.count,
  });

  factory _$RecordTypeCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecordTypeCountImplFromJson(json);

  @override
  @JsonKey(name: 'record_type')
  final String recordType;
  @override
  @IntConverter()
  final int count;

  @override
  String toString() {
    return 'RecordTypeCount(recordType: $recordType, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordTypeCountImpl &&
            (identical(other.recordType, recordType) ||
                other.recordType == recordType) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, recordType, count);

  /// Create a copy of RecordTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordTypeCountImplCopyWith<_$RecordTypeCountImpl> get copyWith =>
      __$$RecordTypeCountImplCopyWithImpl<_$RecordTypeCountImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecordTypeCountImplToJson(this);
  }
}

abstract class _RecordTypeCount implements RecordTypeCount {
  const factory _RecordTypeCount({
    @JsonKey(name: 'record_type') required final String recordType,
    @IntConverter() required final int count,
  }) = _$RecordTypeCountImpl;

  factory _RecordTypeCount.fromJson(Map<String, dynamic> json) =
      _$RecordTypeCountImpl.fromJson;

  @override
  @JsonKey(name: 'record_type')
  String get recordType;
  @override
  @IntConverter()
  int get count;

  /// Create a copy of RecordTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordTypeCountImplCopyWith<_$RecordTypeCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialReport _$FinancialReportFromJson(Map<String, dynamic> json) {
  return _FinancialReport.fromJson(json);
}

/// @nodoc
mixin _$FinancialReport {
  FinancialReportSummary get summary => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_category')
  List<CategoryData> get byCategory => throw _privateConstructorUsedError;

  /// Serializes this FinancialReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialReportCopyWith<FinancialReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialReportCopyWith<$Res> {
  factory $FinancialReportCopyWith(
    FinancialReport value,
    $Res Function(FinancialReport) then,
  ) = _$FinancialReportCopyWithImpl<$Res, FinancialReport>;
  @useResult
  $Res call({
    FinancialReportSummary summary,
    @JsonKey(name: 'by_category') List<CategoryData> byCategory,
  });

  $FinancialReportSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$FinancialReportCopyWithImpl<$Res, $Val extends FinancialReport>
    implements $FinancialReportCopyWith<$Res> {
  _$FinancialReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? summary = null, Object? byCategory = null}) {
    return _then(
      _value.copyWith(
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as FinancialReportSummary,
            byCategory: null == byCategory
                ? _value.byCategory
                : byCategory // ignore: cast_nullable_to_non_nullable
                      as List<CategoryData>,
          )
          as $Val,
    );
  }

  /// Create a copy of FinancialReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FinancialReportSummaryCopyWith<$Res> get summary {
    return $FinancialReportSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FinancialReportImplCopyWith<$Res>
    implements $FinancialReportCopyWith<$Res> {
  factory _$$FinancialReportImplCopyWith(
    _$FinancialReportImpl value,
    $Res Function(_$FinancialReportImpl) then,
  ) = __$$FinancialReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    FinancialReportSummary summary,
    @JsonKey(name: 'by_category') List<CategoryData> byCategory,
  });

  @override
  $FinancialReportSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$FinancialReportImplCopyWithImpl<$Res>
    extends _$FinancialReportCopyWithImpl<$Res, _$FinancialReportImpl>
    implements _$$FinancialReportImplCopyWith<$Res> {
  __$$FinancialReportImplCopyWithImpl(
    _$FinancialReportImpl _value,
    $Res Function(_$FinancialReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? summary = null, Object? byCategory = null}) {
    return _then(
      _$FinancialReportImpl(
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as FinancialReportSummary,
        byCategory: null == byCategory
            ? _value._byCategory
            : byCategory // ignore: cast_nullable_to_non_nullable
                  as List<CategoryData>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialReportImpl implements _FinancialReport {
  const _$FinancialReportImpl({
    required this.summary,
    @JsonKey(name: 'by_category') required final List<CategoryData> byCategory,
  }) : _byCategory = byCategory;

  factory _$FinancialReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialReportImplFromJson(json);

  @override
  final FinancialReportSummary summary;
  final List<CategoryData> _byCategory;
  @override
  @JsonKey(name: 'by_category')
  List<CategoryData> get byCategory {
    if (_byCategory is EqualUnmodifiableListView) return _byCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byCategory);
  }

  @override
  String toString() {
    return 'FinancialReport(summary: $summary, byCategory: $byCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialReportImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(
              other._byCategory,
              _byCategory,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    summary,
    const DeepCollectionEquality().hash(_byCategory),
  );

  /// Create a copy of FinancialReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialReportImplCopyWith<_$FinancialReportImpl> get copyWith =>
      __$$FinancialReportImplCopyWithImpl<_$FinancialReportImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialReportImplToJson(this);
  }
}

abstract class _FinancialReport implements FinancialReport {
  const factory _FinancialReport({
    required final FinancialReportSummary summary,
    @JsonKey(name: 'by_category') required final List<CategoryData> byCategory,
  }) = _$FinancialReportImpl;

  factory _FinancialReport.fromJson(Map<String, dynamic> json) =
      _$FinancialReportImpl.fromJson;

  @override
  FinancialReportSummary get summary;
  @override
  @JsonKey(name: 'by_category')
  List<CategoryData> get byCategory;

  /// Create a copy of FinancialReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialReportImplCopyWith<_$FinancialReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialReportSummary _$FinancialReportSummaryFromJson(
  Map<String, dynamic> json,
) {
  return _FinancialReportSummary.fromJson(json);
}

/// @nodoc
mixin _$FinancialReportSummary {
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  double get totalIncome => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  double get totalExpenses => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_profit')
  @DoubleConverter()
  double get netProfit => throw _privateConstructorUsedError;

  /// Serializes this FinancialReportSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialReportSummaryCopyWith<FinancialReportSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialReportSummaryCopyWith<$Res> {
  factory $FinancialReportSummaryCopyWith(
    FinancialReportSummary value,
    $Res Function(FinancialReportSummary) then,
  ) = _$FinancialReportSummaryCopyWithImpl<$Res, FinancialReportSummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_income') @DoubleConverter() double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() double totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() double netProfit,
  });
}

/// @nodoc
class _$FinancialReportSummaryCopyWithImpl<
  $Res,
  $Val extends FinancialReportSummary
>
    implements $FinancialReportSummaryCopyWith<$Res> {
  _$FinancialReportSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? netProfit = null,
  }) {
    return _then(
      _value.copyWith(
            totalIncome: null == totalIncome
                ? _value.totalIncome
                : totalIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            totalExpenses: null == totalExpenses
                ? _value.totalExpenses
                : totalExpenses // ignore: cast_nullable_to_non_nullable
                      as double,
            netProfit: null == netProfit
                ? _value.netProfit
                : netProfit // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinancialReportSummaryImplCopyWith<$Res>
    implements $FinancialReportSummaryCopyWith<$Res> {
  factory _$$FinancialReportSummaryImplCopyWith(
    _$FinancialReportSummaryImpl value,
    $Res Function(_$FinancialReportSummaryImpl) then,
  ) = __$$FinancialReportSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_income') @DoubleConverter() double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() double totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() double netProfit,
  });
}

/// @nodoc
class __$$FinancialReportSummaryImplCopyWithImpl<$Res>
    extends
        _$FinancialReportSummaryCopyWithImpl<$Res, _$FinancialReportSummaryImpl>
    implements _$$FinancialReportSummaryImplCopyWith<$Res> {
  __$$FinancialReportSummaryImplCopyWithImpl(
    _$FinancialReportSummaryImpl _value,
    $Res Function(_$FinancialReportSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? netProfit = null,
  }) {
    return _then(
      _$FinancialReportSummaryImpl(
        totalIncome: null == totalIncome
            ? _value.totalIncome
            : totalIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        totalExpenses: null == totalExpenses
            ? _value.totalExpenses
            : totalExpenses // ignore: cast_nullable_to_non_nullable
                  as double,
        netProfit: null == netProfit
            ? _value.netProfit
            : netProfit // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialReportSummaryImpl implements _FinancialReportSummary {
  const _$FinancialReportSummaryImpl({
    @JsonKey(name: 'total_income') @DoubleConverter() required this.totalIncome,
    @JsonKey(name: 'total_expenses')
    @DoubleConverter()
    required this.totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() required this.netProfit,
  });

  factory _$FinancialReportSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialReportSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  final double totalIncome;
  @override
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  final double totalExpenses;
  @override
  @JsonKey(name: 'net_profit')
  @DoubleConverter()
  final double netProfit;

  @override
  String toString() {
    return 'FinancialReportSummary(totalIncome: $totalIncome, totalExpenses: $totalExpenses, netProfit: $netProfit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialReportSummaryImpl &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.netProfit, netProfit) ||
                other.netProfit == netProfit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalIncome, totalExpenses, netProfit);

  /// Create a copy of FinancialReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialReportSummaryImplCopyWith<_$FinancialReportSummaryImpl>
  get copyWith =>
      __$$FinancialReportSummaryImplCopyWithImpl<_$FinancialReportSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialReportSummaryImplToJson(this);
  }
}

abstract class _FinancialReportSummary implements FinancialReportSummary {
  const factory _FinancialReportSummary({
    @JsonKey(name: 'total_income')
    @DoubleConverter()
    required final double totalIncome,
    @JsonKey(name: 'total_expenses')
    @DoubleConverter()
    required final double totalExpenses,
    @JsonKey(name: 'net_profit')
    @DoubleConverter()
    required final double netProfit,
  }) = _$FinancialReportSummaryImpl;

  factory _FinancialReportSummary.fromJson(Map<String, dynamic> json) =
      _$FinancialReportSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  double get totalIncome;
  @override
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  double get totalExpenses;
  @override
  @JsonKey(name: 'net_profit')
  @DoubleConverter()
  double get netProfit;

  /// Create a copy of FinancialReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialReportSummaryImplCopyWith<_$FinancialReportSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) {
  return _CategoryData.fromJson(json);
}

/// @nodoc
mixin _$CategoryData {
  String get type => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  @DoubleConverter()
  double get total => throw _privateConstructorUsedError;
  @IntConverter()
  int get count => throw _privateConstructorUsedError;

  /// Serializes this CategoryData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryDataCopyWith<CategoryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryDataCopyWith<$Res> {
  factory $CategoryDataCopyWith(
    CategoryData value,
    $Res Function(CategoryData) then,
  ) = _$CategoryDataCopyWithImpl<$Res, CategoryData>;
  @useResult
  $Res call({
    String type,
    String category,
    @DoubleConverter() double total,
    @IntConverter() int count,
  });
}

/// @nodoc
class _$CategoryDataCopyWithImpl<$Res, $Val extends CategoryData>
    implements $CategoryDataCopyWith<$Res> {
  _$CategoryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? category = null,
    Object? total = null,
    Object? count = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryDataImplCopyWith<$Res>
    implements $CategoryDataCopyWith<$Res> {
  factory _$$CategoryDataImplCopyWith(
    _$CategoryDataImpl value,
    $Res Function(_$CategoryDataImpl) then,
  ) = __$$CategoryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String type,
    String category,
    @DoubleConverter() double total,
    @IntConverter() int count,
  });
}

/// @nodoc
class __$$CategoryDataImplCopyWithImpl<$Res>
    extends _$CategoryDataCopyWithImpl<$Res, _$CategoryDataImpl>
    implements _$$CategoryDataImplCopyWith<$Res> {
  __$$CategoryDataImplCopyWithImpl(
    _$CategoryDataImpl _value,
    $Res Function(_$CategoryDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? category = null,
    Object? total = null,
    Object? count = null,
  }) {
    return _then(
      _$CategoryDataImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryDataImpl implements _CategoryData {
  const _$CategoryDataImpl({
    required this.type,
    required this.category,
    @DoubleConverter() required this.total,
    @IntConverter() required this.count,
  });

  factory _$CategoryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryDataImplFromJson(json);

  @override
  final String type;
  @override
  final String category;
  @override
  @DoubleConverter()
  final double total;
  @override
  @IntConverter()
  final int count;

  @override
  String toString() {
    return 'CategoryData(type: $type, category: $category, total: $total, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryDataImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, category, total, count);

  /// Create a copy of CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryDataImplCopyWith<_$CategoryDataImpl> get copyWith =>
      __$$CategoryDataImplCopyWithImpl<_$CategoryDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryDataImplToJson(this);
  }
}

abstract class _CategoryData implements CategoryData {
  const factory _CategoryData({
    required final String type,
    required final String category,
    @DoubleConverter() required final double total,
    @IntConverter() required final int count,
  }) = _$CategoryDataImpl;

  factory _CategoryData.fromJson(Map<String, dynamic> json) =
      _$CategoryDataImpl.fromJson;

  @override
  String get type;
  @override
  String get category;
  @override
  @DoubleConverter()
  double get total;
  @override
  @IntConverter()
  int get count;

  /// Create a copy of CategoryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryDataImplCopyWith<_$CategoryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
