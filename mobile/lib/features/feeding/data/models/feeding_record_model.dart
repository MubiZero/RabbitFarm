import 'package:freezed_annotation/freezed_annotation.dart';
import 'feed_model.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../cages/data/models/cage_model.dart';
import '../../../../core/json/int_converter.dart';
import '../../../../core/json/double_converter.dart';

part 'feeding_record_model.freezed.dart';
part 'feeding_record_model.g.dart';

/// Feeding Record model
@freezed
class FeedingRecord with _$FeedingRecord {
  const factory FeedingRecord({
    @IntConverter() required int id,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    @JsonKey(name: 'feed_id') @IntConverter() required int feedId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @DoubleConverter() required double quantity,
    @JsonKey(name: 'fed_at') required DateTime fedAt,
    @JsonKey(name: 'fed_by') @NullableIntConverter() int? fedBy,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) Feed? feed,
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
    @JsonKey(includeFromJson: false, includeToJson: false) CageModel? cage,
  }) = _FeedingRecord;

  factory FeedingRecord.fromJson(Map<String, dynamic> json) =>
      _$FeedingRecordFromJson(json);
}

/// Feeding Record Create DTO
@freezed
class FeedingRecordCreate with _$FeedingRecordCreate {
  const factory FeedingRecordCreate({
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    @JsonKey(name: 'feed_id') required int feedId,
    @JsonKey(name: 'cage_id') int? cageId,
    required double quantity,
    @JsonKey(name: 'fed_at') required DateTime fedAt,
    String? notes,
  }) = _FeedingRecordCreate;

  factory FeedingRecordCreate.fromJson(Map<String, dynamic> json) =>
      _$FeedingRecordCreateFromJson(json);
}

/// Feeding Record Update DTO
@freezed
class FeedingRecordUpdate with _$FeedingRecordUpdate {
  const factory FeedingRecordUpdate({
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    @JsonKey(name: 'feed_id') int? feedId,
    @JsonKey(name: 'cage_id') int? cageId,
    double? quantity,
    @JsonKey(name: 'fed_at') DateTime? fedAt,
    String? notes,
  }) = _FeedingRecordUpdate;

  factory FeedingRecordUpdate.fromJson(Map<String, dynamic> json) =>
      _$FeedingRecordUpdateFromJson(json);
}

/// Feeding Statistics
///
/// Количество всегда сгруппировано по единице измерения: килограммы, литры и
/// штуки — разные величины, общая сумма по ним ничего не значит. Ключи карт —
/// коды с сервера (`kg`, `piece`, `pellets`), подписи подбираются в UI.
@freezed
class FeedingStatistics with _$FeedingStatistics {
  const factory FeedingStatistics({
    @JsonKey(name: 'total_feedings') required int totalFeedings,
    @JsonKey(name: 'quantity_by_unit') @Default({}) Map<String, double> quantityByUnit,
    @JsonKey(name: 'by_feed_type') @Default({}) Map<String, Map<String, double>> byFeedType,
    @JsonKey(name: 'by_feed') @Default({}) Map<String, FeedingByFeed> byFeed,
    @JsonKey(name: 'total_cost') required double totalCost,
  }) = _FeedingStatistics;

  factory FeedingStatistics.fromJson(Map<String, dynamic> json) =>
      _$FeedingStatisticsFromJson(json);
}

/// Feeding by specific feed
@freezed
class FeedingByFeed with _$FeedingByFeed {
  const factory FeedingByFeed({
    required double quantity,
    required String unit,
    required double cost,
  }) = _FeedingByFeed;

  factory FeedingByFeed.fromJson(Map<String, dynamic> json) =>
      _$FeedingByFeedFromJson(json);
}

