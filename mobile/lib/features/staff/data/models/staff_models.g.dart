// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FarmMember _$FarmMemberFromJson(Map<String, dynamic> json) => _FarmMember(
  id: const IntConverter().fromJson(json['id'] as Object),
  email: json['email'] as String?,
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
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: $enumDecode(_$FarmRoleEnumMap, json['role']),
      expiresAt: const DateTimeConverter().fromJson(
        json['expires_at'] as Object,
      ),
    );

Map<String, dynamic> _$FarmInvitationToJson(_FarmInvitation instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'email': instance.email,
      'phone': instance.phone,
      'role': _$FarmRoleEnumMap[instance.role]!,
      'expires_at': const DateTimeConverter().toJson(instance.expiresAt),
    };

_CreatedInvitation _$CreatedInvitationFromJson(Map<String, dynamic> json) =>
    _CreatedInvitation(
      id: const IntConverter().fromJson(json['id'] as Object),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      fullName: json['full_name'] as String?,
      role: $enumDecode(_$FarmRoleEnumMap, json['role']),
      expiresAt: const DateTimeConverter().fromJson(
        json['expires_at'] as Object,
      ),
      inviteLink: json['invite_link'] as String?,
      messageSent: json['message_sent'] as bool? ?? false,
    );

Map<String, dynamic> _$CreatedInvitationToJson(_CreatedInvitation instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'email': instance.email,
      'phone': instance.phone,
      'full_name': instance.fullName,
      'role': _$FarmRoleEnumMap[instance.role]!,
      'expires_at': const DateTimeConverter().toJson(instance.expiresAt),
      'invite_link': instance.inviteLink,
      'message_sent': instance.messageSent,
    };

_FarmAuditEntry _$FarmAuditEntryFromJson(Map<String, dynamic> json) =>
    _FarmAuditEntry(
      id: const IntConverter().fromJson(json['id'] as Object),
      action: json['action'] as String,
      at: const DateTimeConverter().fromJson(json['created_at'] as Object),
      actor: json['actor'] == null
          ? null
          : FarmMember.fromJson(json['actor'] as Map<String, dynamic>),
      target: json['target'] == null
          ? null
          : FarmMember.fromJson(json['target'] as Map<String, dynamic>),
      entityType: json['entity_type'] as String?,
      entityLabel: json['entity_label'] as String?,
      before: json['before'] as Map<String, dynamic>?,
      after: json['after'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$FarmAuditEntryToJson(_FarmAuditEntry instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'action': instance.action,
      'created_at': const DateTimeConverter().toJson(instance.at),
      'actor': instance.actor,
      'target': instance.target,
      'entity_type': instance.entityType,
      'entity_label': instance.entityLabel,
      'before': instance.before,
      'after': instance.after,
    };
