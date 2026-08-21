// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FarmMemberImpl _$$FarmMemberImplFromJson(Map<String, dynamic> json) =>
    _$FarmMemberImpl(
      id: const IntConverter().fromJson(json['id'] as Object),
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      role: $enumDecode(_$FarmRoleEnumMap, json['role']),
      isActive: json['is_active'] as bool? ?? true,
      ownerId: const NullableIntConverter().fromJson(json['owner_id']),
    );

Map<String, dynamic> _$$FarmMemberImplToJson(_$FarmMemberImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'email': instance.email,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'role': _$FarmRoleEnumMap[instance.role]!,
      'is_active': instance.isActive,
      'owner_id': const NullableIntConverter().toJson(instance.ownerId),
    };

const _$FarmRoleEnumMap = {
  FarmRole.owner: 'owner',
  FarmRole.manager: 'manager',
  FarmRole.worker: 'worker',
};

_$FarmInvitationImpl _$$FarmInvitationImplFromJson(Map<String, dynamic> json) =>
    _$FarmInvitationImpl(
      id: const IntConverter().fromJson(json['id'] as Object),
      email: json['email'] as String,
      role: $enumDecode(_$FarmRoleEnumMap, json['role']),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$$FarmInvitationImplToJson(
  _$FarmInvitationImpl instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'email': instance.email,
  'role': _$FarmRoleEnumMap[instance.role]!,
  'expires_at': instance.expiresAt.toIso8601String(),
};

_$CreatedInvitationImpl _$$CreatedInvitationImplFromJson(
  Map<String, dynamic> json,
) => _$CreatedInvitationImpl(
  id: const IntConverter().fromJson(json['id'] as Object),
  email: json['email'] as String,
  role: $enumDecode(_$FarmRoleEnumMap, json['role']),
  code: json['code'] as String,
  expiresAt: DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$$CreatedInvitationImplToJson(
  _$CreatedInvitationImpl instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'email': instance.email,
  'role': _$FarmRoleEnumMap[instance.role]!,
  'code': instance.code,
  'expires_at': instance.expiresAt.toIso8601String(),
};
