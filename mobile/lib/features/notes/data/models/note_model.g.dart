// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => _NoteModel(
  id: const IntConverter().fromJson(json['id'] as Object),
  content: json['content'] as String,
  rabbitId: const NullableIntConverter().fromJson(json['rabbit_id']),
  cageId: const NullableIntConverter().fromJson(json['cage_id']),
  createdAt: const NullableDateTimeConverter().fromJson(json['created_at']),
  rabbit: json['rabbit'] == null
      ? null
      : RabbitRef.fromJson(json['rabbit'] as Map<String, dynamic>),
  cage: json['cage'] == null
      ? null
      : CageInfo.fromJson(json['cage'] as Map<String, dynamic>),
  author: json['author'] == null
      ? null
      : UserRef.fromJson(json['author'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NoteModelToJson(
  _NoteModel instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'content': instance.content,
  'rabbit_id': const NullableIntConverter().toJson(instance.rabbitId),
  'cage_id': const NullableIntConverter().toJson(instance.cageId),
  'created_at': const NullableDateTimeConverter().toJson(instance.createdAt),
  'rabbit': instance.rabbit,
  'cage': instance.cage,
  'author': instance.author,
};

_NoteCreate _$NoteCreateFromJson(Map<String, dynamic> json) => _NoteCreate(
  content: json['content'] as String,
  rabbitId: (json['rabbit_id'] as num?)?.toInt(),
  cageId: (json['cage_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$NoteCreateToJson(_NoteCreate instance) =>
    <String, dynamic>{
      'content': instance.content,
      'rabbit_id': instance.rabbitId,
      'cage_id': instance.cageId,
    };

_NoteUpdate _$NoteUpdateFromJson(Map<String, dynamic> json) => _NoteUpdate(
  content: json['content'] as String?,
  rabbitId: (json['rabbit_id'] as num?)?.toInt(),
  cageId: (json['cage_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$NoteUpdateToJson(_NoteUpdate instance) =>
    <String, dynamic>{
      'content': instance.content,
      'rabbit_id': instance.rabbitId,
      'cage_id': instance.cageId,
    };
