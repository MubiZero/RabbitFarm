// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BreedModelImpl _$$BreedModelImplFromJson(Map<String, dynamic> json) =>
    _$BreedModelImpl(
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
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$BreedModelImplToJson(_$BreedModelImpl instance) =>
    <String, dynamic>{
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
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
