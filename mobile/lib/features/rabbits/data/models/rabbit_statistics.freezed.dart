// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rabbit_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RabbitStatistics _$RabbitStatisticsFromJson(Map<String, dynamic> json) {
  return _RabbitStatistics.fromJson(json);
}

/// @nodoc
mixin _$RabbitStatistics {
  @IntConverter()
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'alive_count')
  @IntConverter()
  int get aliveCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'male_count')
  @IntConverter()
  int get maleCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'female_count')
  @IntConverter()
  int get femaleCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'pregnant_count')
  @IntConverter()
  int get pregnantCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'sick_count')
  @IntConverter()
  int get sickCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'for_sale_count')
  @IntConverter()
  int get forSaleCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_breed')
  List<BreedStats> get byBreed => throw _privateConstructorUsedError;
  @JsonKey(name: 'dead_count')
  @IntConverter()
  int get deadCount => throw _privateConstructorUsedError;

  /// Serializes this RabbitStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RabbitStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RabbitStatisticsCopyWith<RabbitStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RabbitStatisticsCopyWith<$Res> {
  factory $RabbitStatisticsCopyWith(
    RabbitStatistics value,
    $Res Function(RabbitStatistics) then,
  ) = _$RabbitStatisticsCopyWithImpl<$Res, RabbitStatistics>;
  @useResult
  $Res call({
    @IntConverter() int total,
    @JsonKey(name: 'alive_count') @IntConverter() int aliveCount,
    @JsonKey(name: 'male_count') @IntConverter() int maleCount,
    @JsonKey(name: 'female_count') @IntConverter() int femaleCount,
    @JsonKey(name: 'pregnant_count') @IntConverter() int pregnantCount,
    @JsonKey(name: 'sick_count') @IntConverter() int sickCount,
    @JsonKey(name: 'for_sale_count') @IntConverter() int forSaleCount,
    @JsonKey(name: 'by_breed') List<BreedStats> byBreed,
    @JsonKey(name: 'dead_count') @IntConverter() int deadCount,
  });
}

/// @nodoc
class _$RabbitStatisticsCopyWithImpl<$Res, $Val extends RabbitStatistics>
    implements $RabbitStatisticsCopyWith<$Res> {
  _$RabbitStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RabbitStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? aliveCount = null,
    Object? maleCount = null,
    Object? femaleCount = null,
    Object? pregnantCount = null,
    Object? sickCount = null,
    Object? forSaleCount = null,
    Object? byBreed = null,
    Object? deadCount = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            aliveCount: null == aliveCount
                ? _value.aliveCount
                : aliveCount // ignore: cast_nullable_to_non_nullable
                      as int,
            maleCount: null == maleCount
                ? _value.maleCount
                : maleCount // ignore: cast_nullable_to_non_nullable
                      as int,
            femaleCount: null == femaleCount
                ? _value.femaleCount
                : femaleCount // ignore: cast_nullable_to_non_nullable
                      as int,
            pregnantCount: null == pregnantCount
                ? _value.pregnantCount
                : pregnantCount // ignore: cast_nullable_to_non_nullable
                      as int,
            sickCount: null == sickCount
                ? _value.sickCount
                : sickCount // ignore: cast_nullable_to_non_nullable
                      as int,
            forSaleCount: null == forSaleCount
                ? _value.forSaleCount
                : forSaleCount // ignore: cast_nullable_to_non_nullable
                      as int,
            byBreed: null == byBreed
                ? _value.byBreed
                : byBreed // ignore: cast_nullable_to_non_nullable
                      as List<BreedStats>,
            deadCount: null == deadCount
                ? _value.deadCount
                : deadCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RabbitStatisticsImplCopyWith<$Res>
    implements $RabbitStatisticsCopyWith<$Res> {
  factory _$$RabbitStatisticsImplCopyWith(
    _$RabbitStatisticsImpl value,
    $Res Function(_$RabbitStatisticsImpl) then,
  ) = __$$RabbitStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int total,
    @JsonKey(name: 'alive_count') @IntConverter() int aliveCount,
    @JsonKey(name: 'male_count') @IntConverter() int maleCount,
    @JsonKey(name: 'female_count') @IntConverter() int femaleCount,
    @JsonKey(name: 'pregnant_count') @IntConverter() int pregnantCount,
    @JsonKey(name: 'sick_count') @IntConverter() int sickCount,
    @JsonKey(name: 'for_sale_count') @IntConverter() int forSaleCount,
    @JsonKey(name: 'by_breed') List<BreedStats> byBreed,
    @JsonKey(name: 'dead_count') @IntConverter() int deadCount,
  });
}

/// @nodoc
class __$$RabbitStatisticsImplCopyWithImpl<$Res>
    extends _$RabbitStatisticsCopyWithImpl<$Res, _$RabbitStatisticsImpl>
    implements _$$RabbitStatisticsImplCopyWith<$Res> {
  __$$RabbitStatisticsImplCopyWithImpl(
    _$RabbitStatisticsImpl _value,
    $Res Function(_$RabbitStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RabbitStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? aliveCount = null,
    Object? maleCount = null,
    Object? femaleCount = null,
    Object? pregnantCount = null,
    Object? sickCount = null,
    Object? forSaleCount = null,
    Object? byBreed = null,
    Object? deadCount = null,
  }) {
    return _then(
      _$RabbitStatisticsImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        aliveCount: null == aliveCount
            ? _value.aliveCount
            : aliveCount // ignore: cast_nullable_to_non_nullable
                  as int,
        maleCount: null == maleCount
            ? _value.maleCount
            : maleCount // ignore: cast_nullable_to_non_nullable
                  as int,
        femaleCount: null == femaleCount
            ? _value.femaleCount
            : femaleCount // ignore: cast_nullable_to_non_nullable
                  as int,
        pregnantCount: null == pregnantCount
            ? _value.pregnantCount
            : pregnantCount // ignore: cast_nullable_to_non_nullable
                  as int,
        sickCount: null == sickCount
            ? _value.sickCount
            : sickCount // ignore: cast_nullable_to_non_nullable
                  as int,
        forSaleCount: null == forSaleCount
            ? _value.forSaleCount
            : forSaleCount // ignore: cast_nullable_to_non_nullable
                  as int,
        byBreed: null == byBreed
            ? _value._byBreed
            : byBreed // ignore: cast_nullable_to_non_nullable
                  as List<BreedStats>,
        deadCount: null == deadCount
            ? _value.deadCount
            : deadCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RabbitStatisticsImpl implements _RabbitStatistics {
  const _$RabbitStatisticsImpl({
    @IntConverter() this.total = 0,
    @JsonKey(name: 'alive_count') @IntConverter() this.aliveCount = 0,
    @JsonKey(name: 'male_count') @IntConverter() this.maleCount = 0,
    @JsonKey(name: 'female_count') @IntConverter() this.femaleCount = 0,
    @JsonKey(name: 'pregnant_count') @IntConverter() this.pregnantCount = 0,
    @JsonKey(name: 'sick_count') @IntConverter() this.sickCount = 0,
    @JsonKey(name: 'for_sale_count') @IntConverter() this.forSaleCount = 0,
    @JsonKey(name: 'by_breed') final List<BreedStats> byBreed = const [],
    @JsonKey(name: 'dead_count') @IntConverter() this.deadCount = 0,
  }) : _byBreed = byBreed;

  factory _$RabbitStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RabbitStatisticsImplFromJson(json);

  @override
  @JsonKey()
  @IntConverter()
  final int total;
  @override
  @JsonKey(name: 'alive_count')
  @IntConverter()
  final int aliveCount;
  @override
  @JsonKey(name: 'male_count')
  @IntConverter()
  final int maleCount;
  @override
  @JsonKey(name: 'female_count')
  @IntConverter()
  final int femaleCount;
  @override
  @JsonKey(name: 'pregnant_count')
  @IntConverter()
  final int pregnantCount;
  @override
  @JsonKey(name: 'sick_count')
  @IntConverter()
  final int sickCount;
  @override
  @JsonKey(name: 'for_sale_count')
  @IntConverter()
  final int forSaleCount;
  final List<BreedStats> _byBreed;
  @override
  @JsonKey(name: 'by_breed')
  List<BreedStats> get byBreed {
    if (_byBreed is EqualUnmodifiableListView) return _byBreed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byBreed);
  }

  @override
  @JsonKey(name: 'dead_count')
  @IntConverter()
  final int deadCount;

  @override
  String toString() {
    return 'RabbitStatistics(total: $total, aliveCount: $aliveCount, maleCount: $maleCount, femaleCount: $femaleCount, pregnantCount: $pregnantCount, sickCount: $sickCount, forSaleCount: $forSaleCount, byBreed: $byBreed, deadCount: $deadCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RabbitStatisticsImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.aliveCount, aliveCount) ||
                other.aliveCount == aliveCount) &&
            (identical(other.maleCount, maleCount) ||
                other.maleCount == maleCount) &&
            (identical(other.femaleCount, femaleCount) ||
                other.femaleCount == femaleCount) &&
            (identical(other.pregnantCount, pregnantCount) ||
                other.pregnantCount == pregnantCount) &&
            (identical(other.sickCount, sickCount) ||
                other.sickCount == sickCount) &&
            (identical(other.forSaleCount, forSaleCount) ||
                other.forSaleCount == forSaleCount) &&
            const DeepCollectionEquality().equals(other._byBreed, _byBreed) &&
            (identical(other.deadCount, deadCount) ||
                other.deadCount == deadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    total,
    aliveCount,
    maleCount,
    femaleCount,
    pregnantCount,
    sickCount,
    forSaleCount,
    const DeepCollectionEquality().hash(_byBreed),
    deadCount,
  );

  /// Create a copy of RabbitStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RabbitStatisticsImplCopyWith<_$RabbitStatisticsImpl> get copyWith =>
      __$$RabbitStatisticsImplCopyWithImpl<_$RabbitStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RabbitStatisticsImplToJson(this);
  }
}

abstract class _RabbitStatistics implements RabbitStatistics {
  const factory _RabbitStatistics({
    @IntConverter() final int total,
    @JsonKey(name: 'alive_count') @IntConverter() final int aliveCount,
    @JsonKey(name: 'male_count') @IntConverter() final int maleCount,
    @JsonKey(name: 'female_count') @IntConverter() final int femaleCount,
    @JsonKey(name: 'pregnant_count') @IntConverter() final int pregnantCount,
    @JsonKey(name: 'sick_count') @IntConverter() final int sickCount,
    @JsonKey(name: 'for_sale_count') @IntConverter() final int forSaleCount,
    @JsonKey(name: 'by_breed') final List<BreedStats> byBreed,
    @JsonKey(name: 'dead_count') @IntConverter() final int deadCount,
  }) = _$RabbitStatisticsImpl;

  factory _RabbitStatistics.fromJson(Map<String, dynamic> json) =
      _$RabbitStatisticsImpl.fromJson;

  @override
  @IntConverter()
  int get total;
  @override
  @JsonKey(name: 'alive_count')
  @IntConverter()
  int get aliveCount;
  @override
  @JsonKey(name: 'male_count')
  @IntConverter()
  int get maleCount;
  @override
  @JsonKey(name: 'female_count')
  @IntConverter()
  int get femaleCount;
  @override
  @JsonKey(name: 'pregnant_count')
  @IntConverter()
  int get pregnantCount;
  @override
  @JsonKey(name: 'sick_count')
  @IntConverter()
  int get sickCount;
  @override
  @JsonKey(name: 'for_sale_count')
  @IntConverter()
  int get forSaleCount;
  @override
  @JsonKey(name: 'by_breed')
  List<BreedStats> get byBreed;
  @override
  @JsonKey(name: 'dead_count')
  @IntConverter()
  int get deadCount;

  /// Create a copy of RabbitStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RabbitStatisticsImplCopyWith<_$RabbitStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BreedStats _$BreedStatsFromJson(Map<String, dynamic> json) {
  return _BreedStats.fromJson(json);
}

/// @nodoc
mixin _$BreedStats {
  @JsonKey(name: 'breed_id')
  @IntConverter()
  int? get breedId => throw _privateConstructorUsedError;
  @JsonKey(name: 'breed_name')
  String? get breedName => throw _privateConstructorUsedError;
  @IntConverter()
  int get count => throw _privateConstructorUsedError;

  /// Serializes this BreedStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BreedStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreedStatsCopyWith<BreedStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreedStatsCopyWith<$Res> {
  factory $BreedStatsCopyWith(
    BreedStats value,
    $Res Function(BreedStats) then,
  ) = _$BreedStatsCopyWithImpl<$Res, BreedStats>;
  @useResult
  $Res call({
    @JsonKey(name: 'breed_id') @IntConverter() int? breedId,
    @JsonKey(name: 'breed_name') String? breedName,
    @IntConverter() int count,
  });
}

/// @nodoc
class _$BreedStatsCopyWithImpl<$Res, $Val extends BreedStats>
    implements $BreedStatsCopyWith<$Res> {
  _$BreedStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreedStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breedId = freezed,
    Object? breedName = freezed,
    Object? count = null,
  }) {
    return _then(
      _value.copyWith(
            breedId: freezed == breedId
                ? _value.breedId
                : breedId // ignore: cast_nullable_to_non_nullable
                      as int?,
            breedName: freezed == breedName
                ? _value.breedName
                : breedName // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$BreedStatsImplCopyWith<$Res>
    implements $BreedStatsCopyWith<$Res> {
  factory _$$BreedStatsImplCopyWith(
    _$BreedStatsImpl value,
    $Res Function(_$BreedStatsImpl) then,
  ) = __$$BreedStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'breed_id') @IntConverter() int? breedId,
    @JsonKey(name: 'breed_name') String? breedName,
    @IntConverter() int count,
  });
}

/// @nodoc
class __$$BreedStatsImplCopyWithImpl<$Res>
    extends _$BreedStatsCopyWithImpl<$Res, _$BreedStatsImpl>
    implements _$$BreedStatsImplCopyWith<$Res> {
  __$$BreedStatsImplCopyWithImpl(
    _$BreedStatsImpl _value,
    $Res Function(_$BreedStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreedStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breedId = freezed,
    Object? breedName = freezed,
    Object? count = null,
  }) {
    return _then(
      _$BreedStatsImpl(
        breedId: freezed == breedId
            ? _value.breedId
            : breedId // ignore: cast_nullable_to_non_nullable
                  as int?,
        breedName: freezed == breedName
            ? _value.breedName
            : breedName // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$BreedStatsImpl implements _BreedStats {
  const _$BreedStatsImpl({
    @JsonKey(name: 'breed_id') @IntConverter() this.breedId,
    @JsonKey(name: 'breed_name') this.breedName,
    @IntConverter() this.count = 0,
  });

  factory _$BreedStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreedStatsImplFromJson(json);

  @override
  @JsonKey(name: 'breed_id')
  @IntConverter()
  final int? breedId;
  @override
  @JsonKey(name: 'breed_name')
  final String? breedName;
  @override
  @JsonKey()
  @IntConverter()
  final int count;

  @override
  String toString() {
    return 'BreedStats(breedId: $breedId, breedName: $breedName, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreedStatsImpl &&
            (identical(other.breedId, breedId) || other.breedId == breedId) &&
            (identical(other.breedName, breedName) ||
                other.breedName == breedName) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, breedId, breedName, count);

  /// Create a copy of BreedStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreedStatsImplCopyWith<_$BreedStatsImpl> get copyWith =>
      __$$BreedStatsImplCopyWithImpl<_$BreedStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreedStatsImplToJson(this);
  }
}

abstract class _BreedStats implements BreedStats {
  const factory _BreedStats({
    @JsonKey(name: 'breed_id') @IntConverter() final int? breedId,
    @JsonKey(name: 'breed_name') final String? breedName,
    @IntConverter() final int count,
  }) = _$BreedStatsImpl;

  factory _BreedStats.fromJson(Map<String, dynamic> json) =
      _$BreedStatsImpl.fromJson;

  @override
  @JsonKey(name: 'breed_id')
  @IntConverter()
  int? get breedId;
  @override
  @JsonKey(name: 'breed_name')
  String? get breedName;
  @override
  @IntConverter()
  int get count;

  /// Create a copy of BreedStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreedStatsImplCopyWith<_$BreedStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
