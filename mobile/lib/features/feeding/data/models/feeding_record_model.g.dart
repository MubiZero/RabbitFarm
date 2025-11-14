// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeding_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedingRecordImpl _$$FeedingRecordImplFromJson(Map<String, dynamic> json) =>
    _$FeedingRecordImpl(
      id: const IntConverter().fromJson(json['id']),
      rabbitId: const NullableIntConverter().fromJson(json['rabbit_id']),
      feedId: const IntConverter().fromJson(json['feed_id']),
      cageId: const NullableIntConverter().fromJson(json['cage_id']),
      quantity: const DoubleConverter().fromJson(json['quantity']),
      fedAt: DateTime.parse(json['fed_at'] as String),
      fedBy: const NullableIntConverter().fromJson(json['fed_by']),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$FeedingRecordImplToJson(_$FeedingRecordImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'rabbit_id': const NullableIntConverter().toJson(instance.rabbitId),
      'feed_id': const IntConverter().toJson(instance.feedId),
      'cage_id': const NullableIntConverter().toJson(instance.cageId),
      'quantity': const DoubleConverter().toJson(instance.quantity),
      'fed_at': instance.fedAt.toIso8601String(),
      'fed_by': const NullableIntConverter().toJson(instance.fedBy),
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$FeedingRecordCreateImpl _$$FeedingRecordCreateImplFromJson(
  Map<String, dynamic> json,
) => _$FeedingRecordCreateImpl(
  rabbitId: (json['rabbit_id'] as num?)?.toInt(),
  feedId: (json['feed_id'] as num).toInt(),
  cageId: (json['cage_id'] as num?)?.toInt(),
  quantity: (json['quantity'] as num).toDouble(),
  fedAt: DateTime.parse(json['fed_at'] as String),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$FeedingRecordCreateImplToJson(
  _$FeedingRecordCreateImpl instance,
) => <String, dynamic>{
  'rabbit_id': instance.rabbitId,
  'feed_id': instance.feedId,
  'cage_id': instance.cageId,
  'quantity': instance.quantity,
  'fed_at': instance.fedAt.toIso8601String(),
  'notes': instance.notes,
};

_$FeedingRecordUpdateImpl _$$FeedingRecordUpdateImplFromJson(
  Map<String, dynamic> json,
) => _$FeedingRecordUpdateImpl(
  rabbitId: (json['rabbit_id'] as num?)?.toInt(),
  feedId: (json['feed_id'] as num?)?.toInt(),
  cageId: (json['cage_id'] as num?)?.toInt(),
  quantity: (json['quantity'] as num?)?.toDouble(),
  fedAt: json['fed_at'] == null
      ? null
      : DateTime.parse(json['fed_at'] as String),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$FeedingRecordUpdateImplToJson(
  _$FeedingRecordUpdateImpl instance,
) => <String, dynamic>{
  'rabbit_id': instance.rabbitId,
  'feed_id': instance.feedId,
  'cage_id': instance.cageId,
  'quantity': instance.quantity,
  'fed_at': instance.fedAt?.toIso8601String(),
  'notes': instance.notes,
};

_$FeedingStatisticsImpl _$$FeedingStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$FeedingStatisticsImpl(
  totalFeedings: (json['total_feedings'] as num).toInt(),
  totalQuantity: (json['total_quantity'] as num).toDouble(),
  byFeedType: FeedingByType.fromJson(
    json['by_feed_type'] as Map<String, dynamic>,
  ),
  byFeed: (json['by_feed'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, FeedingByFeed.fromJson(e as Map<String, dynamic>)),
  ),
  totalCost: (json['total_cost'] as num).toDouble(),
);

Map<String, dynamic> _$$FeedingStatisticsImplToJson(
  _$FeedingStatisticsImpl instance,
) => <String, dynamic>{
  'total_feedings': instance.totalFeedings,
  'total_quantity': instance.totalQuantity,
  'by_feed_type': instance.byFeedType,
  'by_feed': instance.byFeed,
  'total_cost': instance.totalCost,
};

_$FeedingByTypeImpl _$$FeedingByTypeImplFromJson(Map<String, dynamic> json) =>
    _$FeedingByTypeImpl(
      pellets: (json['pellets'] as num?)?.toDouble() ?? 0.0,
      hay: (json['hay'] as num?)?.toDouble() ?? 0.0,
      vegetables: (json['vegetables'] as num?)?.toDouble() ?? 0.0,
      grain: (json['grain'] as num?)?.toDouble() ?? 0.0,
      supplements: (json['supplements'] as num?)?.toDouble() ?? 0.0,
      other: (json['other'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$FeedingByTypeImplToJson(_$FeedingByTypeImpl instance) =>
    <String, dynamic>{
      'pellets': instance.pellets,
      'hay': instance.hay,
      'vegetables': instance.vegetables,
      'grain': instance.grain,
      'supplements': instance.supplements,
      'other': instance.other,
    };

_$FeedingByFeedImpl _$$FeedingByFeedImplFromJson(Map<String, dynamic> json) =>
    _$FeedingByFeedImpl(
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      cost: (json['cost'] as num).toDouble(),
    );

Map<String, dynamic> _$$FeedingByFeedImplToJson(_$FeedingByFeedImpl instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'unit': instance.unit,
      'cost': instance.cost,
    };
