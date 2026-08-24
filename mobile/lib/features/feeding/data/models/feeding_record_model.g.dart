// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeding_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedingRecordImpl _$$FeedingRecordImplFromJson(Map<String, dynamic> json) =>
    _$FeedingRecordImpl(
      id: const IntConverter().fromJson(json['id'] as Object),
      rabbitId: const NullableIntConverter().fromJson(json['rabbit_id']),
      feedId: const IntConverter().fromJson(json['feed_id'] as Object),
      cageId: const NullableIntConverter().fromJson(json['cage_id']),
      quantity: const DoubleConverter().fromJson(json['quantity'] as Object),
      fedAt: const DateTimeConverter().fromJson(json['fed_at'] as Object),
      fedBy: const NullableIntConverter().fromJson(json['fed_by']),
      notes: json['notes'] as String?,
      createdAt: const NullableDateTimeConverter().fromJson(json['created_at']),
      feed: json['feed'] == null
          ? null
          : Feed.fromJson(json['feed'] as Map<String, dynamic>),
      rabbit: json['rabbit'] == null
          ? null
          : RabbitModel.fromJson(json['rabbit'] as Map<String, dynamic>),
      cage: json['cage'] == null
          ? null
          : CageModel.fromJson(json['cage'] as Map<String, dynamic>),
      author: json['fedBy'] == null
          ? null
          : UserRef.fromJson(json['fedBy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FeedingRecordImplToJson(
  _$FeedingRecordImpl instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'rabbit_id': const NullableIntConverter().toJson(instance.rabbitId),
  'feed_id': const IntConverter().toJson(instance.feedId),
  'cage_id': const NullableIntConverter().toJson(instance.cageId),
  'quantity': const DoubleConverter().toJson(instance.quantity),
  'fed_at': const DateTimeConverter().toJson(instance.fedAt),
  'fed_by': const NullableIntConverter().toJson(instance.fedBy),
  'notes': instance.notes,
  'created_at': const NullableDateTimeConverter().toJson(instance.createdAt),
  'feed': instance.feed,
  'rabbit': instance.rabbit,
  'cage': instance.cage,
  'fedBy': instance.author,
};

_$FeedingRecordCreateImpl _$$FeedingRecordCreateImplFromJson(
  Map<String, dynamic> json,
) => _$FeedingRecordCreateImpl(
  rabbitId: (json['rabbit_id'] as num?)?.toInt(),
  feedId: (json['feed_id'] as num).toInt(),
  cageId: (json['cage_id'] as num?)?.toInt(),
  quantity: (json['quantity'] as num).toDouble(),
  fedAt: const DateTimeConverter().fromJson(json['fed_at'] as Object),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$FeedingRecordCreateImplToJson(
  _$FeedingRecordCreateImpl instance,
) => <String, dynamic>{
  'rabbit_id': instance.rabbitId,
  'feed_id': instance.feedId,
  'cage_id': instance.cageId,
  'quantity': instance.quantity,
  'fed_at': const DateTimeConverter().toJson(instance.fedAt),
  'notes': instance.notes,
};

_$FeedingRecordUpdateImpl _$$FeedingRecordUpdateImplFromJson(
  Map<String, dynamic> json,
) => _$FeedingRecordUpdateImpl(
  rabbitId: (json['rabbit_id'] as num?)?.toInt(),
  feedId: (json['feed_id'] as num?)?.toInt(),
  cageId: (json['cage_id'] as num?)?.toInt(),
  quantity: (json['quantity'] as num?)?.toDouble(),
  fedAt: const NullableDateTimeConverter().fromJson(json['fed_at']),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$FeedingRecordUpdateImplToJson(
  _$FeedingRecordUpdateImpl instance,
) => <String, dynamic>{
  'rabbit_id': instance.rabbitId,
  'feed_id': instance.feedId,
  'cage_id': instance.cageId,
  'quantity': instance.quantity,
  'fed_at': const NullableDateTimeConverter().toJson(instance.fedAt),
  'notes': instance.notes,
};

_$FeedingStatisticsImpl _$$FeedingStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$FeedingStatisticsImpl(
  totalFeedings: (json['total_feedings'] as num).toInt(),
  quantityByUnit:
      (json['quantity_by_unit'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  byFeedType:
      (json['by_feed_type'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ),
        ),
      ) ??
      const {},
  byFeed:
      (json['by_feed'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, FeedingByFeed.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  totalCost: (json['total_cost'] as num).toDouble(),
);

Map<String, dynamic> _$$FeedingStatisticsImplToJson(
  _$FeedingStatisticsImpl instance,
) => <String, dynamic>{
  'total_feedings': instance.totalFeedings,
  'quantity_by_unit': instance.quantityByUnit,
  'by_feed_type': instance.byFeedType,
  'by_feed': instance.byFeed,
  'total_cost': instance.totalCost,
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
