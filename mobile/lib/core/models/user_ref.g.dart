// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRefImpl _$$UserRefImplFromJson(Map<String, dynamic> json) =>
    _$UserRefImpl(
      id: const IntConverter().fromJson(json['id'] as Object),
      fullName: json['full_name'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$UserRefImplToJson(_$UserRefImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'full_name': instance.fullName,
      'email': instance.email,
    };
