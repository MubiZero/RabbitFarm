// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Feed _$FeedFromJson(Map<String, dynamic> json) => _Feed(
  id: const IntConverter().fromJson(json['id'] as Object),
  name: json['name'] as String,
  type: $enumDecode(_$FeedTypeEnumMap, json['type']),
  brand: json['brand'] as String?,
  unit: $enumDecodeNullable(_$FeedUnitEnumMap, json['unit']) ?? FeedUnit.kg,
  currentStock: const DoubleConverter().fromJson(
    json['current_stock'] as Object,
  ),
  minStock: const DoubleConverter().fromJson(json['min_stock'] as Object),
  costPerUnit: _$JsonConverterFromJson<Object, double>(
    json['cost_per_unit'],
    const DoubleConverter().fromJson,
  ),
  notes: json['notes'] as String?,
  createdAt: const NullableDateTimeConverter().fromJson(json['created_at']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updated_at']),
);

Map<String, dynamic> _$FeedToJson(_Feed instance) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'name': instance.name,
  'type': _$FeedTypeEnumMap[instance.type]!,
  'brand': instance.brand,
  'unit': _$FeedUnitEnumMap[instance.unit]!,
  'current_stock': const DoubleConverter().toJson(instance.currentStock),
  'min_stock': const DoubleConverter().toJson(instance.minStock),
  'cost_per_unit': _$JsonConverterToJson<Object, double>(
    instance.costPerUnit,
    const DoubleConverter().toJson,
  ),
  'notes': instance.notes,
  'created_at': const NullableDateTimeConverter().toJson(instance.createdAt),
  'updated_at': const NullableDateTimeConverter().toJson(instance.updatedAt),
};

const _$FeedTypeEnumMap = {
  FeedType.pellets: 'pellets',
  FeedType.hay: 'hay',
  FeedType.vegetables: 'vegetables',
  FeedType.grain: 'grain',
  FeedType.supplements: 'supplements',
  FeedType.other: 'other',
};

const _$FeedUnitEnumMap = {
  FeedUnit.kg: 'kg',
  FeedUnit.liter: 'liter',
  FeedUnit.piece: 'piece',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_FeedCreate _$FeedCreateFromJson(Map<String, dynamic> json) => _FeedCreate(
  name: json['name'] as String,
  type: json['type'] as String,
  brand: json['brand'] as String?,
  unit: json['unit'] as String? ?? 'kg',
  currentStock: (json['current_stock'] as num?)?.toDouble(),
  minStock: (json['min_stock'] as num?)?.toDouble(),
  costPerUnit: (json['cost_per_unit'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$FeedCreateToJson(_FeedCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'brand': instance.brand,
      'unit': instance.unit,
      'current_stock': instance.currentStock,
      'min_stock': instance.minStock,
      'cost_per_unit': instance.costPerUnit,
      'notes': instance.notes,
    };

_FeedUpdate _$FeedUpdateFromJson(Map<String, dynamic> json) => _FeedUpdate(
  name: json['name'] as String?,
  type: json['type'] as String?,
  brand: json['brand'] as String?,
  unit: json['unit'] as String?,
  currentStock: (json['current_stock'] as num?)?.toDouble(),
  minStock: (json['min_stock'] as num?)?.toDouble(),
  costPerUnit: (json['cost_per_unit'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$FeedUpdateToJson(_FeedUpdate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'brand': instance.brand,
      'unit': instance.unit,
      'current_stock': instance.currentStock,
      'min_stock': instance.minStock,
      'cost_per_unit': instance.costPerUnit,
      'notes': instance.notes,
    };

_StockAdjustment _$StockAdjustmentFromJson(Map<String, dynamic> json) =>
    _StockAdjustment(
      quantity: (json['quantity'] as num).toDouble(),
      operation: json['operation'] as String,
    );

Map<String, dynamic> _$StockAdjustmentToJson(_StockAdjustment instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'operation': instance.operation,
    };

_FeedStatistics _$FeedStatisticsFromJson(Map<String, dynamic> json) =>
    _FeedStatistics(
      totalFeeds: (json['total_feeds'] as num).toInt(),
      byType: FeedTypeStats.fromJson(json['by_type'] as Map<String, dynamic>),
      lowStockCount: (json['low_stock_count'] as num).toInt(),
      lowStockItems: (json['low_stock_items'] as List<dynamic>)
          .map((e) => LowStockItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalStockValue: (json['total_stock_value'] as num).toDouble(),
    );

Map<String, dynamic> _$FeedStatisticsToJson(_FeedStatistics instance) =>
    <String, dynamic>{
      'total_feeds': instance.totalFeeds,
      'by_type': instance.byType,
      'low_stock_count': instance.lowStockCount,
      'low_stock_items': instance.lowStockItems,
      'total_stock_value': instance.totalStockValue,
    };

_FeedTypeStats _$FeedTypeStatsFromJson(Map<String, dynamic> json) =>
    _FeedTypeStats(
      pellets: (json['pellets'] as num?)?.toInt() ?? 0,
      hay: (json['hay'] as num?)?.toInt() ?? 0,
      vegetables: (json['vegetables'] as num?)?.toInt() ?? 0,
      grain: (json['grain'] as num?)?.toInt() ?? 0,
      supplements: (json['supplements'] as num?)?.toInt() ?? 0,
      other: (json['other'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FeedTypeStatsToJson(_FeedTypeStats instance) =>
    <String, dynamic>{
      'pellets': instance.pellets,
      'hay': instance.hay,
      'vegetables': instance.vegetables,
      'grain': instance.grain,
      'supplements': instance.supplements,
      'other': instance.other,
    };

_LowStockItem _$LowStockItemFromJson(Map<String, dynamic> json) =>
    _LowStockItem(
      id: const IntConverter().fromJson(json['id'] as Object),
      name: json['name'] as String,
      currentStock: const DoubleConverter().fromJson(
        json['current_stock'] as Object,
      ),
      minStock: const DoubleConverter().fromJson(json['min_stock'] as Object),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$LowStockItemToJson(_LowStockItem instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'name': instance.name,
      'current_stock': const DoubleConverter().toJson(instance.currentStock),
      'min_stock': const DoubleConverter().toJson(instance.minStock),
      'unit': instance.unit,
    };
