// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserModelImpl(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  fullName: json['full_name'] as String,
  role: json['role'] as String,
  phone: json['phone'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  isActive: json['is_active'] as bool,
  lastLoginAt: const NullableDateTimeConverter().fromJson(
    json['last_login_at'],
  ),
  createdAt: const DateTimeConverter().fromJson(json['created_at'] as Object),
  updatedAt: const DateTimeConverter().fromJson(json['updated_at'] as Object),
);

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'role': instance.role,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'is_active': instance.isActive,
      'last_login_at': const NullableDateTimeConverter().toJson(
        instance.lastLoginAt,
      ),
      'created_at': const DateTimeConverter().toJson(instance.createdAt),
      'updated_at': const DateTimeConverter().toJson(instance.updatedAt),
    };
