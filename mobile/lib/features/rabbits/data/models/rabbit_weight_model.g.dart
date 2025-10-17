// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rabbit_weight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RabbitWeightImpl _$$RabbitWeightImplFromJson(Map<String, dynamic> json) =>
    _$RabbitWeightImpl(
      id: const IntConverter().fromJson(json['id'] as Object),
      rabbitId: const IntConverter().fromJson(json['rabbit_id'] as Object),
      weight: const WeightConverter().fromJson(json['weight'] as Object),
      measuredAt: DateTime.parse(json['measured_at'] as String),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$RabbitWeightImplToJson(_$RabbitWeightImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'rabbit_id': const IntConverter().toJson(instance.rabbitId),
      'weight': const WeightConverter().toJson(instance.weight),
      'measured_at': instance.measuredAt.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
    };
