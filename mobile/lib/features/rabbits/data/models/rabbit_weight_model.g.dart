// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rabbit_weight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RabbitWeightImpl _$$RabbitWeightImplFromJson(Map<String, dynamic> json) =>
    _$RabbitWeightImpl(
      id: const IntConverter().fromJson(json['id'] as Object),
      rabbitId: const IntConverter().fromJson(json['rabbit_id'] as Object),
      weight: const DoubleConverter().fromJson(json['weight'] as Object),
      measuredAt: const DateTimeConverter().fromJson(
        json['measured_at'] as Object,
      ),
      notes: json['notes'] as String?,
      createdAt: const NullableDateTimeConverter().fromJson(json['created_at']),
    );

Map<String, dynamic> _$$RabbitWeightImplToJson(
  _$RabbitWeightImpl instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'rabbit_id': const IntConverter().toJson(instance.rabbitId),
  'weight': const DoubleConverter().toJson(instance.weight),
  'measured_at': const DateTimeConverter().toJson(instance.measuredAt),
  'notes': instance.notes,
  'created_at': const NullableDateTimeConverter().toJson(instance.createdAt),
};
