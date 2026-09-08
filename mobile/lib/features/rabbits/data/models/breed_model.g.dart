// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BreedModel _$BreedModelFromJson(Map<String, dynamic> json) => _BreedModel(
  id: const IntConverter().fromJson(json['id'] as Object),
  name: json['name'] as String,
  description: json['description'] as String?,
  averageWeight: (json['average_weight'] as num?)?.toDouble(),
  averageLitterSize: _$JsonConverterFromJson<Object, int>(
    json['average_litter_size'],
    const IntConverter().fromJson,
  ),
  purpose: json['purpose'] as String?,
  photoUrl: json['photo_url'] as String?,
  createdAt: const NullableDateTimeConverter().fromJson(json['created_at']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updated_at']),
);

Map<String, dynamic> _$BreedModelToJson(
  _BreedModel instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'name': instance.name,
  'description': instance.description,
  'average_weight': instance.averageWeight,
  'average_litter_size': _$JsonConverterToJson<Object, int>(
    instance.averageLitterSize,
    const IntConverter().toJson,
  ),
  'purpose': instance.purpose,
  'photo_url': instance.photoUrl,
  'created_at': const NullableDateTimeConverter().toJson(instance.createdAt),
  'updated_at': const NullableDateTimeConverter().toJson(instance.updatedAt),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
