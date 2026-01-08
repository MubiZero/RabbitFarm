import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/json/int_converter.dart';
import '../../../rabbits/data/models/rabbit_model.dart';

part 'cage_model.freezed.dart';
part 'cage_model.g.dart';

@freezed
class CageModel with _$CageModel {
  const factory CageModel({
    @IntConverter() required int id,
    required String number,
    required String type, // single, group, maternity
    String? size,
    @IntConverter() required int capacity,
    String? location,
    required String condition, // good, needs_repair, broken
    @JsonKey(name: 'last_cleaned_at') DateTime? lastCleanedAt,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    // Related data
    List<RabbitModel>? rabbits,
    @JsonKey(name: 'current_occupancy') @NullableIntConverter() int? currentOccupancy,
    @JsonKey(name: 'is_full') bool? isFull,
    @JsonKey(name: 'is_available') bool? isAvailable,
  }) = _CageModel;

  factory CageModel.fromJson(Map<String, dynamic> json) =>
      _$CageModelFromJson(json);
}

@freezed
class CageStatistics with _$CageStatistics {
  const factory CageStatistics({
    @JsonKey(name: 'total_cages') @IntConverter() required int totalCages,
    @JsonKey(name: 'by_type') required CageTypeStats byType,
    @JsonKey(name: 'by_condition') required CageConditionStats byCondition,
    required CageOccupancyStats occupancy,
  }) = _CageStatistics;

  factory CageStatistics.fromJson(Map<String, dynamic> json) =>
      _$CageStatisticsFromJson(json);
}

@freezed
class CageTypeStats with _$CageTypeStats {
  const factory CageTypeStats({
    @IntConverter() required int single,
    @IntConverter() required int group,
    @IntConverter() required int maternity,
  }) = _CageTypeStats;

  factory CageTypeStats.fromJson(Map<String, dynamic> json) =>
      _$CageTypeStatsFromJson(json);
}

@freezed
class CageConditionStats with _$CageConditionStats {
  const factory CageConditionStats({
    @IntConverter() required int good,
    @JsonKey(name: 'needs_repair') @IntConverter() required int needsRepair,
    @IntConverter() required int broken,
  }) = _CageConditionStats;

  factory CageConditionStats.fromJson(Map<String, dynamic> json) =>
      _$CageConditionStatsFromJson(json);
}

@freezed
class CageOccupancyStats with _$CageOccupancyStats {
  const factory CageOccupancyStats({
    @JsonKey(name: 'total_capacity') @IntConverter() required int totalCapacity,
    @JsonKey(name: 'current_occupancy') @IntConverter() required int currentOccupancy,
    @JsonKey(name: 'available_spaces') @IntConverter() required int availableSpaces,
    @JsonKey(name: 'occupancy_rate') @IntConverter() required int occupancyRate,
    @JsonKey(name: 'full_cages') @IntConverter() required int fullCages,
    @JsonKey(name: 'empty_cages') @IntConverter() required int emptyCages,
  }) = _CageOccupancyStats;

  factory CageOccupancyStats.fromJson(Map<String, dynamic> json) =>
      _$CageOccupancyStatsFromJson(json);
}
