// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rabbit_photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RabbitPhotoImpl _$$RabbitPhotoImplFromJson(Map<String, dynamic> json) =>
    _$RabbitPhotoImpl(
      id: const IntConverter().fromJson(json['id'] as Object),
      url: json['url'] as String,
      caption: json['caption'] as String?,
      takenAt: const NullableDateTimeConverter().fromJson(json['taken_at']),
      createdAt: const NullableDateTimeConverter().fromJson(json['created_at']),
      author: json['author'] == null
          ? null
          : UserRef.fromJson(json['author'] as Map<String, dynamic>),
      rabbitId: const NullableIntConverter().fromJson(json['rabbit_id']),
      rabbit: json['rabbit'] == null
          ? null
          : RabbitRef.fromJson(json['rabbit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RabbitPhotoImplToJson(
  _$RabbitPhotoImpl instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'url': instance.url,
  'caption': instance.caption,
  'taken_at': const NullableDateTimeConverter().toJson(instance.takenAt),
  'created_at': const NullableDateTimeConverter().toJson(instance.createdAt),
  'author': instance.author,
  'rabbit_id': const NullableIntConverter().toJson(instance.rabbitId),
  'rabbit': instance.rabbit,
};
