// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteModelImpl _$$NoteModelImplFromJson(Map<String, dynamic> json) =>
    _$NoteModelImpl(
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

Map<String, dynamic> _$$NoteModelImplToJson(
  _$NoteModelImpl instance,
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

_$NoteCreateImpl _$$NoteCreateImplFromJson(Map<String, dynamic> json) =>
    _$NoteCreateImpl(
      content: json['content'] as String,
      rabbitId: (json['rabbit_id'] as num?)?.toInt(),
      cageId: (json['cage_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$NoteCreateImplToJson(_$NoteCreateImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'rabbit_id': instance.rabbitId,
      'cage_id': instance.cageId,
    };

_$NoteUpdateImpl _$$NoteUpdateImplFromJson(Map<String, dynamic> json) =>
    _$NoteUpdateImpl(
      content: json['content'] as String?,
      rabbitId: (json['rabbit_id'] as num?)?.toInt(),
      cageId: (json['cage_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$NoteUpdateImplToJson(_$NoteUpdateImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'rabbit_id': instance.rabbitId,
      'cage_id': instance.cageId,
    };
