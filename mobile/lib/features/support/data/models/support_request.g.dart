// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportRequest _$SupportRequestFromJson(
  Map<String, dynamic> json,
) => _SupportRequest(
  id: const IntConverter().fromJson(json['id'] as Object),
  text: json['text'] as String,
  status: json['status'] as String? ?? 'new',
  answer: json['answer'] as String?,
  resolvedAt: const NullableDateTimeConverter().fromJson(json['resolved_at']),
  author: json['author'] == null
      ? null
      : UserRef.fromJson(json['author'] as Map<String, dynamic>),
  createdAt: const DateTimeConverter().fromJson(json['created_at'] as Object),
);

Map<String, dynamic> _$SupportRequestToJson(
  _SupportRequest instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'text': instance.text,
  'status': instance.status,
  'answer': instance.answer,
  'resolved_at': const NullableDateTimeConverter().toJson(instance.resolvedAt),
  'author': instance.author,
  'created_at': const DateTimeConverter().toJson(instance.createdAt),
};
