import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_model.freezed.dart';
part 'feed_model.g.dart';

/// Feed types
enum FeedType {
  @JsonValue('pellets')
  pellets,
  @JsonValue('hay')
  hay,
  @JsonValue('vegetables')
  vegetables,
  @JsonValue('grain')
  grain,
  @JsonValue('supplements')
  supplements,
  @JsonValue('other')
  other,
}

/// Extension to get display names for feed types
extension FeedTypeDisplay on FeedType {
  String get displayName {
    switch (this) {
      case FeedType.pellets:
        return 'Гранулы';
      case FeedType.hay:
        return 'Сено';
      case FeedType.vegetables:
        return 'Овощи';
      case FeedType.grain:
        return 'Зерно';
      case FeedType.supplements:
        return 'Добавки';
      case FeedType.other:
        return 'Другое';
    }
  }
}

/// Feed unit types
enum FeedUnit {
  @JsonValue('kg')
  kg,
  @JsonValue('liter')
  liter,
  @JsonValue('piece')
  piece,
}

/// Extension to get display names for feed units
extension FeedUnitDisplay on FeedUnit {
  String get displayName {
    switch (this) {
      case FeedUnit.kg:
        return 'кг';
      case FeedUnit.liter:
        return 'л';
      case FeedUnit.piece:
        return 'шт';
    }
  }
}

/// Feed model
@freezed
class Feed with _$Feed {
  const factory Feed({
    @IntConverter() required int id,
    required String name,
    required FeedType type,
    String? brand,
    @JsonKey(defaultValue: FeedUnit.kg) required FeedUnit unit,
    @JsonKey(name: 'current_stock') @DoubleConverter() required double currentStock,
    @JsonKey(name: 'min_stock') @DoubleConverter() required double minStock,
    @JsonKey(name: 'cost_per_unit') @DoubleConverter() double? costPerUnit,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Feed;

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);
}

/// Feed Create DTO
@freezed
class FeedCreate with _$FeedCreate {
  const factory FeedCreate({
    required String name,
    required String type,
    String? brand,
    @JsonKey(defaultValue: 'kg') String? unit,
    @JsonKey(name: 'current_stock') double? currentStock,
    @JsonKey(name: 'min_stock') double? minStock,
    @JsonKey(name: 'cost_per_unit') double? costPerUnit,
    String? notes,
  }) = _FeedCreate;

  factory FeedCreate.fromJson(Map<String, dynamic> json) =>
      _$FeedCreateFromJson(json);
}

/// Feed Update DTO
@freezed
class FeedUpdate with _$FeedUpdate {
  const factory FeedUpdate({
    String? name,
    String? type,
    String? brand,
    String? unit,
    @JsonKey(name: 'current_stock') double? currentStock,
    @JsonKey(name: 'min_stock') double? minStock,
    @JsonKey(name: 'cost_per_unit') double? costPerUnit,
    String? notes,
  }) = _FeedUpdate;

  factory FeedUpdate.fromJson(Map<String, dynamic> json) =>
      _$FeedUpdateFromJson(json);
}

/// Stock Adjustment DTO
@freezed
class StockAdjustment with _$StockAdjustment {
  const factory StockAdjustment({
    required double quantity,
    required String operation, // 'add' or 'subtract'
  }) = _StockAdjustment;

  factory StockAdjustment.fromJson(Map<String, dynamic> json) =>
      _$StockAdjustmentFromJson(json);
}

/// Feed Statistics
@freezed
class FeedStatistics with _$FeedStatistics {
  const factory FeedStatistics({
    @JsonKey(name: 'total_feeds') required int totalFeeds,
    @JsonKey(name: 'by_type') required FeedTypeStats byType,
    @JsonKey(name: 'low_stock_count') required int lowStockCount,
    @JsonKey(name: 'low_stock_items') required List<LowStockItem> lowStockItems,
    @JsonKey(name: 'total_stock_value') required double totalStockValue,
  }) = _FeedStatistics;

  factory FeedStatistics.fromJson(Map<String, dynamic> json) =>
      _$FeedStatisticsFromJson(json);
}

/// Feed type statistics
@freezed
class FeedTypeStats with _$FeedTypeStats {
  const factory FeedTypeStats({
    @JsonKey(defaultValue: 0) required int pellets,
    @JsonKey(defaultValue: 0) required int hay,
    @JsonKey(defaultValue: 0) required int vegetables,
    @JsonKey(defaultValue: 0) required int grain,
    @JsonKey(defaultValue: 0) required int supplements,
    @JsonKey(defaultValue: 0) required int other,
  }) = _FeedTypeStats;

  factory FeedTypeStats.fromJson(Map<String, dynamic> json) =>
      _$FeedTypeStatsFromJson(json);
}

/// Low stock item
@freezed
class LowStockItem with _$LowStockItem {
  const factory LowStockItem({
    @IntConverter() required int id,
    required String name,
    @JsonKey(name: 'current_stock') @DoubleConverter() required double currentStock,
    @JsonKey(name: 'min_stock') @DoubleConverter() required double minStock,
    required String unit,
  }) = _LowStockItem;

  factory LowStockItem.fromJson(Map<String, dynamic> json) =>
      _$LowStockItemFromJson(json);
}

/// Custom converter for int values that might come as strings
class IntConverter implements JsonConverter<int, dynamic> {
  const IntConverter();

  @override
  int fromJson(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw ArgumentError('Cannot convert $value to int');
  }

  @override
  dynamic toJson(int value) => value;
}

/// Custom converter for double values that might come as strings
class DoubleConverter implements JsonConverter<double, dynamic> {
  const DoubleConverter();

  @override
  double fromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    throw ArgumentError('Cannot convert $value to double');
  }

  @override
  dynamic toJson(double value) => value;
}
