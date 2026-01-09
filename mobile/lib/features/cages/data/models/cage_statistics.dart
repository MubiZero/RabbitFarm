import 'package:freezed_annotation/freezed_annotation.dart';

part 'cage_statistics.freezed.dart';
part 'cage_statistics.g.dart';

@freezed
class CageStatistics with _$CageStatistics {
  const factory CageStatistics({
    @JsonKey(name: 'total_cages') required int totalCages,
    @JsonKey(name: 'by_type') required Map<String, int> byType,
    @JsonKey(name: 'by_condition') required Map<String, int> byCondition,
    required CageOccupancyStats occupancy,
  }) = _CageStatistics;

  factory CageStatistics.fromJson(Map<String, dynamic> json) =>
      _$CageStatisticsFromJson(json);
}

@freezed
class CageOccupancyStats with _$CageOccupancyStats {
  const factory CageOccupancyStats({
    @JsonKey(name: 'total_capacity') required int totalCapacity,
    @JsonKey(name: 'current_occupancy') required int currentOccupancy,
    @JsonKey(name: 'available_spaces') required int availableSpaces,
    @JsonKey(name: 'occupancy_rate') required int occupancyRate,
    @JsonKey(name: 'full_cages') required int fullCages,
    @JsonKey(name: 'empty_cages') required int emptyCages,
  }) = _CageOccupancyStats;

  factory CageOccupancyStats.fromJson(Map<String, dynamic> json) =>
      _$CageOccupancyStatsFromJson(json);
}
