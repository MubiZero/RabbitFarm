// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FarmMember _$FarmMemberFromJson(Map<String, dynamic> json) => _FarmMember(
  id: const IntConverter().fromJson(json['id'] as Object),
  email: json['email'] as String,
  fullName: json['full_name'] as String,
  phone: json['phone'] as String?,
  role: $enumDecode(_$FarmRoleEnumMap, json['role']),
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$FarmMemberToJson(_FarmMember instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'email': instance.email,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'role': _$FarmRoleEnumMap[instance.role]!,
      'is_active': instance.isActive,
    };

const _$FarmRoleEnumMap = {
  FarmRole.owner: 'owner',
  FarmRole.manager: 'manager',
  FarmRole.worker: 'worker',
};

_FarmInvitation _$FarmInvitationFromJson(Map<String, dynamic> json) =>
    _FarmInvitation(
      id: const IntConverter().fromJson(json['id'] as Object),
      email: json['email'] as String,
      role: $enumDecode(_$FarmRoleEnumMap, json['role']),
      expiresAt: const DateTimeConverter().fromJson(
        json['expires_at'] as Object,
      ),
    );

Map<String, dynamic> _$FarmInvitationToJson(_FarmInvitation instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'email': instance.email,
      'role': _$FarmRoleEnumMap[instance.role]!,
      'expires_at': const DateTimeConverter().toJson(instance.expiresAt),
    };

_CreatedInvitation _$CreatedInvitationFromJson(Map<String, dynamic> json) =>
    _CreatedInvitation(
      id: const IntConverter().fromJson(json['id'] as Object),
      email: json['email'] as String,
      role: $enumDecode(_$FarmRoleEnumMap, json['role']),
      code: json['code'] as String,
      expiresAt: const DateTimeConverter().fromJson(
        json['expires_at'] as Object,
      ),
    );

Map<String, dynamic> _$CreatedInvitationToJson(_CreatedInvitation instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'email': instance.email,
      'role': _$FarmRoleEnumMap[instance.role]!,
      'code': instance.code,
      'expires_at': const DateTimeConverter().toJson(instance.expiresAt),
    };
