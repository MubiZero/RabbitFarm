import 'package:freezed_annotation/freezed_annotation.dart';

part 'rabbit_statistics.freezed.dart';
part 'rabbit_statistics.g.dart';

@freezed
class RabbitStatistics with _$RabbitStatistics {
  const factory RabbitStatistics({
    @Default(0) int total,
    @JsonKey(name: 'alive_count') @Default(0) int aliveCount,
    @JsonKey(name: 'male_count') @Default(0) int maleCount,
    @JsonKey(name: 'female_count') @Default(0) int femaleCount,
    @JsonKey(name: 'pregnant_count') @Default(0) int pregnantCount,
    @JsonKey(name: 'sick_count') @Default(0) int sickCount,
    @JsonKey(name: 'for_sale_count') @Default(0) int forSaleCount,
    @JsonKey(name: 'by_breed') @Default([]) List<BreedStats> byBreed,
    @JsonKey(name: 'dead_count') @Default(0) int deadCount,
  }) = _RabbitStatistics;

  factory RabbitStatistics.fromJson(Map<String, dynamic> json) =>
      _$RabbitStatisticsFromJson(json);
}

@freezed
class BreedStats with _$BreedStats {
  const factory BreedStats({
    @JsonKey(name: 'breed_id') int? breedId,
    @JsonKey(name: 'breed_name') String? breedName,
    @Default(0) int count,
  }) = _BreedStats;

  factory BreedStats.fromJson(Map<String, dynamic> json) =>
      _$BreedStatsFromJson(json);
}
