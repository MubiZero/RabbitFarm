// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String?,
  fullName: json['full_name'] as String,
  role: json['role'] as String,
  phone: json['phone'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  isActive: json['is_active'] as bool,
  hasPassword: json['has_password'] as bool? ?? false,
  isPlatformAdmin: json['is_platform_admin'] as bool? ?? false,
  lastLoginAt: const NullableDateTimeConverter().fromJson(
    json['last_login_at'],
  ),
  digestEnabled: json['digest_enabled'] as bool? ?? true,
  createdAt: const DateTimeConverter().fromJson(json['created_at'] as Object),
  updatedAt: const DateTimeConverter().fromJson(json['updated_at'] as Object),
  farm: json['farm'] == null
      ? null
      : FarmRef.fromJson(json['farm'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'role': instance.role,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'is_active': instance.isActive,
      'has_password': instance.hasPassword,
      'is_platform_admin': instance.isPlatformAdmin,
      'last_login_at': const NullableDateTimeConverter().toJson(
        instance.lastLoginAt,
      ),
      'digest_enabled': instance.digestEnabled,
      'created_at': const DateTimeConverter().toJson(instance.createdAt),
      'updated_at': const DateTimeConverter().toJson(instance.updatedAt),
      'farm': instance.farm,
    };
