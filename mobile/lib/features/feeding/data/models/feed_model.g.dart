// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedImpl _$$FeedImplFromJson(Map<String, dynamic> json) => _$FeedImpl(
  id: const IntConverter().fromJson(json['id']),
  name: json['name'] as String,
  type: $enumDecode(_$FeedTypeEnumMap, json['type']),
  brand: json['brand'] as String?,
  unit: $enumDecodeNullable(_$FeedUnitEnumMap, json['unit']) ?? FeedUnit.kg,
  currentStock: const DoubleConverter().fromJson(json['current_stock']),
  minStock: const DoubleConverter().fromJson(json['min_stock']),
  costPerUnit: const DoubleConverter().fromJson(json['cost_per_unit']),
  notes: json['notes'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$FeedImplToJson(_$FeedImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'name': instance.name,
      'type': _$FeedTypeEnumMap[instance.type]!,
      'brand': instance.brand,
      'unit': _$FeedUnitEnumMap[instance.unit]!,
      'current_stock': const DoubleConverter().toJson(instance.currentStock),
      'min_stock': const DoubleConverter().toJson(instance.minStock),
      'cost_per_unit': _$JsonConverterToJson<dynamic, double>(
        instance.costPerUnit,
        const DoubleConverter().toJson,
      ),
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
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

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_$FeedCreateImpl _$$FeedCreateImplFromJson(Map<String, dynamic> json) =>
    _$FeedCreateImpl(
      name: json['name'] as String,
      type: json['type'] as String,
      brand: json['brand'] as String?,
      unit: json['unit'] as String? ?? 'kg',
      currentStock: (json['current_stock'] as num?)?.toDouble(),
      minStock: (json['min_stock'] as num?)?.toDouble(),
      costPerUnit: (json['cost_per_unit'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$FeedCreateImplToJson(_$FeedCreateImpl instance) =>
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

_$FeedUpdateImpl _$$FeedUpdateImplFromJson(Map<String, dynamic> json) =>
    _$FeedUpdateImpl(
      name: json['name'] as String?,
      type: json['type'] as String?,
      brand: json['brand'] as String?,
      unit: json['unit'] as String?,
      currentStock: (json['current_stock'] as num?)?.toDouble(),
      minStock: (json['min_stock'] as num?)?.toDouble(),
      costPerUnit: (json['cost_per_unit'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$FeedUpdateImplToJson(_$FeedUpdateImpl instance) =>
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

_$StockAdjustmentImpl _$$StockAdjustmentImplFromJson(
  Map<String, dynamic> json,
) => _$StockAdjustmentImpl(
  quantity: (json['quantity'] as num).toDouble(),
  operation: json['operation'] as String,
);

Map<String, dynamic> _$$StockAdjustmentImplToJson(
  _$StockAdjustmentImpl instance,
) => <String, dynamic>{
  'quantity': instance.quantity,
  'operation': instance.operation,
};

_$FeedStatisticsImpl _$$FeedStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$FeedStatisticsImpl(
      totalFeeds: (json['total_feeds'] as num).toInt(),
      byType: FeedTypeStats.fromJson(json['by_type'] as Map<String, dynamic>),
      lowStockCount: (json['low_stock_count'] as num).toInt(),
      lowStockItems: (json['low_stock_items'] as List<dynamic>)
          .map((e) => LowStockItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalStockValue: (json['total_stock_value'] as num).toDouble(),
    );

Map<String, dynamic> _$$FeedStatisticsImplToJson(
  _$FeedStatisticsImpl instance,
) => <String, dynamic>{
  'total_feeds': instance.totalFeeds,
  'by_type': instance.byType,
  'low_stock_count': instance.lowStockCount,
  'low_stock_items': instance.lowStockItems,
  'total_stock_value': instance.totalStockValue,
};

_$FeedTypeStatsImpl _$$FeedTypeStatsImplFromJson(Map<String, dynamic> json) =>
    _$FeedTypeStatsImpl(
      pellets: (json['pellets'] as num?)?.toInt() ?? 0,
      hay: (json['hay'] as num?)?.toInt() ?? 0,
      vegetables: (json['vegetables'] as num?)?.toInt() ?? 0,
      grain: (json['grain'] as num?)?.toInt() ?? 0,
      supplements: (json['supplements'] as num?)?.toInt() ?? 0,
      other: (json['other'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FeedTypeStatsImplToJson(_$FeedTypeStatsImpl instance) =>
    <String, dynamic>{
      'pellets': instance.pellets,
      'hay': instance.hay,
      'vegetables': instance.vegetables,
      'grain': instance.grain,
      'supplements': instance.supplements,
      'other': instance.other,
    };

_$LowStockItemImpl _$$LowStockItemImplFromJson(Map<String, dynamic> json) =>
    _$LowStockItemImpl(
      id: const IntConverter().fromJson(json['id']),
      name: json['name'] as String,
      currentStock: const DoubleConverter().fromJson(json['current_stock']),
      minStock: const DoubleConverter().fromJson(json['min_stock']),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$$LowStockItemImplToJson(_$LowStockItemImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'name': instance.name,
      'current_stock': const DoubleConverter().toJson(instance.currentStock),
      'min_stock': const DoubleConverter().toJson(instance.minStock),
      'unit': instance.unit,
    };
