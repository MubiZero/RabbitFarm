// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_admin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Plan _$PlanFromJson(Map<String, dynamic> json) => _Plan(
  id: const IntConverter().fromJson(json['id'] as Object),
  name: json['name'] as String,
  maxRabbits: const NullableIntConverter().fromJson(json['max_rabbits']),
  maxStaff: const NullableIntConverter().fromJson(json['max_staff']),
  price: _$JsonConverterFromJson<Object, double>(
    json['price'],
    const DoubleConverter().fromJson,
  ),
  isActive: json['is_active'] as bool? ?? true,
  isDefault: json['is_default'] as bool? ?? false,
);

Map<String, dynamic> _$PlanToJson(_Plan instance) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'name': instance.name,
  'max_rabbits': const NullableIntConverter().toJson(instance.maxRabbits),
  'max_staff': const NullableIntConverter().toJson(instance.maxStaff),
  'price': _$JsonConverterToJson<Object, double>(
    instance.price,
    const DoubleConverter().toJson,
  ),
  'is_active': instance.isActive,
  'is_default': instance.isDefault,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_PlanDraft _$PlanDraftFromJson(Map<String, dynamic> json) => _PlanDraft(
  name: json['name'] as String,
  maxRabbits: (json['max_rabbits'] as num?)?.toInt(),
  maxStaff: (json['max_staff'] as num?)?.toInt(),
  price: (json['price'] as num?)?.toDouble(),
  isActive: json['is_active'] as bool,
  isDefault: json['is_default'] as bool? ?? false,
);

Map<String, dynamic> _$PlanDraftToJson(_PlanDraft instance) =>
    <String, dynamic>{
      'name': instance.name,
      'max_rabbits': instance.maxRabbits,
      'max_staff': instance.maxStaff,
      'price': instance.price,
      'is_active': instance.isActive,
      'is_default': instance.isDefault,
    };

_PlatformFarm _$PlatformFarmFromJson(
  Map<String, dynamic> json,
) => _PlatformFarm(
  id: const IntConverter().fromJson(json['id'] as Object),
  name: json['name'] as String,
  owner: json['owner'] == null
      ? null
      : UserRef.fromJson(json['owner'] as Map<String, dynamic>),
  plan: json['plan'] == null
      ? null
      : Plan.fromJson(json['plan'] as Map<String, dynamic>),
  rabbitsCount: json['rabbits_count'] == null
      ? 0
      : const IntConverter().fromJson(json['rabbits_count'] as Object),
  staffCount: json['staff_count'] == null
      ? 0
      : const IntConverter().fromJson(json['staff_count'] as Object),
  createdAt: const DateTimeConverter().fromJson(json['created_at'] as Object),
  lastActiveAt: const NullableDateTimeConverter().fromJson(json['last_active']),
);

Map<String, dynamic> _$PlatformFarmToJson(_PlatformFarm instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'name': instance.name,
      'owner': instance.owner,
      'plan': instance.plan,
      'rabbits_count': const IntConverter().toJson(instance.rabbitsCount),
      'staff_count': const IntConverter().toJson(instance.staffCount),
      'created_at': const DateTimeConverter().toJson(instance.createdAt),
      'last_active': const NullableDateTimeConverter().toJson(
        instance.lastActiveAt,
      ),
    };

_FarmStaffMember _$FarmStaffMemberFromJson(Map<String, dynamic> json) =>
    _FarmStaffMember(
      id: const IntConverter().fromJson(json['id'] as Object),
      fullName: json['full_name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      isActive: json['is_active'] as bool? ?? true,
      lastLoginAt: const NullableDateTimeConverter().fromJson(
        json['last_login_at'],
      ),
    );

Map<String, dynamic> _$FarmStaffMemberToJson(_FarmStaffMember instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'full_name': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'role': instance.role,
      'is_active': instance.isActive,
      'last_login_at': const NullableDateTimeConverter().toJson(
        instance.lastLoginAt,
      ),
    };

_FarmPayment _$FarmPaymentFromJson(Map<String, dynamic> json) => _FarmPayment(
  id: const IntConverter().fromJson(json['id'] as Object),
  amount: json['amount'] as String,
  currency: json['currency'] as String,
  status: json['status'] as String,
  description: json['description'] as String?,
  createdAt: const DateTimeConverter().fromJson(json['created_at'] as Object),
);

Map<String, dynamic> _$FarmPaymentToJson(_FarmPayment instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'description': instance.description,
      'created_at': const DateTimeConverter().toJson(instance.createdAt),
    };

_PlatformFarmDetail _$PlatformFarmDetailFromJson(
  Map<String, dynamic> json,
) => _PlatformFarmDetail(
  id: const IntConverter().fromJson(json['id'] as Object),
  name: json['name'] as String,
  owner: json['owner'] == null
      ? null
      : UserRef.fromJson(json['owner'] as Map<String, dynamic>),
  planId: const NullableIntConverter().fromJson(json['plan_id']),
  plan: json['plan'] == null
      ? null
      : Plan.fromJson(json['plan'] as Map<String, dynamic>),
  planExpiresAt: const NullableDateTimeConverter().fromJson(
    json['plan_expires_at'],
  ),
  status: json['status'] as String? ?? 'active',
  extraRabbits: const NullableIntConverter().fromJson(json['extra_rabbits']),
  extraStaff: const NullableIntConverter().fromJson(json['extra_staff']),
  extrasUntil: const NullableDateTimeConverter().fromJson(json['extras_until']),
  rabbitsCount: json['rabbits_count'] == null
      ? 0
      : const IntConverter().fromJson(json['rabbits_count'] as Object),
  staffCount: json['staff_count'] == null
      ? 0
      : const IntConverter().fromJson(json['staff_count'] as Object),
  createdAt: const DateTimeConverter().fromJson(json['created_at'] as Object),
  lastActiveAt: const NullableDateTimeConverter().fromJson(json['last_active']),
  staff:
      (json['staff'] as List<dynamic>?)
          ?.map((e) => FarmStaffMember.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  payments:
      (json['payments'] as List<dynamic>?)
          ?.map((e) => FarmPayment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  storageBytes: json['storage_bytes'] == null
      ? 0
      : const IntConverter().fromJson(json['storage_bytes'] as Object),
  deletedAt: const NullableDateTimeConverter().fromJson(json['deleted_at']),
);

Map<String, dynamic> _$PlatformFarmDetailToJson(
  _PlatformFarmDetail instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'name': instance.name,
  'owner': instance.owner,
  'plan_id': const NullableIntConverter().toJson(instance.planId),
  'plan': instance.plan,
  'plan_expires_at': const NullableDateTimeConverter().toJson(
    instance.planExpiresAt,
  ),
  'status': instance.status,
  'extra_rabbits': const NullableIntConverter().toJson(instance.extraRabbits),
  'extra_staff': const NullableIntConverter().toJson(instance.extraStaff),
  'extras_until': const NullableDateTimeConverter().toJson(
    instance.extrasUntil,
  ),
  'rabbits_count': const IntConverter().toJson(instance.rabbitsCount),
  'staff_count': const IntConverter().toJson(instance.staffCount),
  'created_at': const DateTimeConverter().toJson(instance.createdAt),
  'last_active': const NullableDateTimeConverter().toJson(
    instance.lastActiveAt,
  ),
  'staff': instance.staff,
  'payments': instance.payments,
  'storage_bytes': const IntConverter().toJson(instance.storageBytes),
  'deleted_at': const NullableDateTimeConverter().toJson(instance.deletedAt),
};

_PlatformFarmsSummary _$PlatformFarmsSummaryFromJson(
  Map<String, dynamic> json,
) => _PlatformFarmsSummary(
  total: json['total'] == null
      ? 0
      : const IntConverter().fromJson(json['total'] as Object),
  free: json['free'] == null
      ? 0
      : const IntConverter().fromJson(json['free'] as Object),
  paid: json['paid'] == null
      ? 0
      : const IntConverter().fromJson(json['paid'] as Object),
  noPlan: json['no_plan'] == null
      ? 0
      : const IntConverter().fromJson(json['no_plan'] as Object),
  expired: json['expired'] == null
      ? 0
      : const IntConverter().fromJson(json['expired'] as Object),
  suspended: json['suspended'] == null
      ? 0
      : const IntConverter().fromJson(json['suspended'] as Object),
  atLimit: json['at_limit'] == null
      ? 0
      : const IntConverter().fromJson(json['at_limit'] as Object),
);

Map<String, dynamic> _$PlatformFarmsSummaryToJson(
  _PlatformFarmsSummary instance,
) => <String, dynamic>{
  'total': const IntConverter().toJson(instance.total),
  'free': const IntConverter().toJson(instance.free),
  'paid': const IntConverter().toJson(instance.paid),
  'no_plan': const IntConverter().toJson(instance.noPlan),
  'expired': const IntConverter().toJson(instance.expired),
  'suspended': const IntConverter().toJson(instance.suspended),
  'at_limit': const IntConverter().toJson(instance.atLimit),
};

_PlatformSummary _$PlatformSummaryFromJson(Map<String, dynamic> json) =>
    _PlatformSummary(
      farms: json['farms'] == null
          ? const PlatformFarmsSummary()
          : PlatformFarmsSummary.fromJson(
              json['farms'] as Map<String, dynamic>,
            ),
      registrations30d: json['registrations_30d'] == null
          ? 0
          : const IntConverter().fromJson(json['registrations_30d'] as Object),
      inactive30d: json['inactive_30d'] == null
          ? 0
          : const IntConverter().fromJson(json['inactive_30d'] as Object),
      rabbitsTotal: json['rabbits_total'] == null
          ? 0
          : const IntConverter().fromJson(json['rabbits_total'] as Object),
      storageBytes: json['storage_bytes'] == null
          ? 0
          : const IntConverter().fromJson(json['storage_bytes'] as Object),
    );

Map<String, dynamic> _$PlatformSummaryToJson(
  _PlatformSummary instance,
) => <String, dynamic>{
  'farms': instance.farms,
  'registrations_30d': const IntConverter().toJson(instance.registrations30d),
  'inactive_30d': const IntConverter().toJson(instance.inactive30d),
  'rabbits_total': const IntConverter().toJson(instance.rabbitsTotal),
  'storage_bytes': const IntConverter().toJson(instance.storageBytes),
};

_ChannelDelivery _$ChannelDeliveryFromJson(Map<String, dynamic> json) =>
    _ChannelDelivery(
      sent: json['sent'] == null
          ? 0
          : const IntConverter().fromJson(json['sent'] as Object),
      failed: json['failed'] == null
          ? 0
          : const IntConverter().fromJson(json['failed'] as Object),
    );

Map<String, dynamic> _$ChannelDeliveryToJson(_ChannelDelivery instance) =>
    <String, dynamic>{
      'sent': const IntConverter().toJson(instance.sent),
      'failed': const IntConverter().toJson(instance.failed),
    };

_AnnouncementStats _$AnnouncementStatsFromJson(Map<String, dynamic> json) =>
    _AnnouncementStats(
      push: json['push'] == null
          ? null
          : ChannelDelivery.fromJson(json['push'] as Map<String, dynamic>),
      email: json['email'] == null
          ? null
          : ChannelDelivery.fromJson(json['email'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnnouncementStatsToJson(_AnnouncementStats instance) =>
    <String, dynamic>{'push': instance.push, 'email': instance.email};

_AnnouncementTargetFarm _$AnnouncementTargetFarmFromJson(
  Map<String, dynamic> json,
) => _AnnouncementTargetFarm(
  id: const IntConverter().fromJson(json['id'] as Object),
  name: json['name'] as String,
);

Map<String, dynamic> _$AnnouncementTargetFarmToJson(
  _AnnouncementTargetFarm instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'name': instance.name,
};

_Announcement _$AnnouncementFromJson(
  Map<String, dynamic> json,
) => _Announcement(
  id: const IntConverter().fromJson(json['id'] as Object),
  title: json['title'] as String,
  body: json['body'] as String,
  channels:
      (json['channels'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  targetType: json['target_type'] as String? ?? 'all',
  targetFarmId: const NullableIntConverter().fromJson(json['target_farm_id']),
  targetFarm: json['targetFarm'] == null
      ? null
      : AnnouncementTargetFarm.fromJson(
          json['targetFarm'] as Map<String, dynamic>,
        ),
  targetFilter: json['target_filter'] as String?,
  farmsCount: json['farms_count'] == null
      ? 0
      : const IntConverter().fromJson(json['farms_count'] as Object),
  recipientsCount: json['recipients_count'] == null
      ? 0
      : const IntConverter().fromJson(json['recipients_count'] as Object),
  stats: json['stats'] == null
      ? null
      : AnnouncementStats.fromJson(json['stats'] as Map<String, dynamic>),
  createdAt: const DateTimeConverter().fromJson(json['created_at'] as Object),
);

Map<String, dynamic> _$AnnouncementToJson(
  _Announcement instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'title': instance.title,
  'body': instance.body,
  'channels': instance.channels,
  'target_type': instance.targetType,
  'target_farm_id': const NullableIntConverter().toJson(instance.targetFarmId),
  'targetFarm': instance.targetFarm,
  'target_filter': instance.targetFilter,
  'farms_count': const IntConverter().toJson(instance.farmsCount),
  'recipients_count': const IntConverter().toJson(instance.recipientsCount),
  'stats': instance.stats,
  'created_at': const DateTimeConverter().toJson(instance.createdAt),
};

_SupportRequestFarm _$SupportRequestFarmFromJson(Map<String, dynamic> json) =>
    _SupportRequestFarm(
      id: const IntConverter().fromJson(json['id'] as Object),
      name: json['name'] as String,
    );

Map<String, dynamic> _$SupportRequestFarmToJson(_SupportRequestFarm instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'name': instance.name,
    };

_SupportRequest _$SupportRequestFromJson(Map<String, dynamic> json) =>
    _SupportRequest(
      id: const IntConverter().fromJson(json['id'] as Object),
      text: json['text'] as String,
      status: json['status'] as String? ?? 'new',
      farm: json['farm'] == null
          ? null
          : SupportRequestFarm.fromJson(json['farm'] as Map<String, dynamic>),
      author: json['author'] == null
          ? null
          : UserRef.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: const DateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
    );

Map<String, dynamic> _$SupportRequestToJson(_SupportRequest instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'text': instance.text,
      'status': instance.status,
      'farm': instance.farm,
      'author': instance.author,
      'created_at': const DateTimeConverter().toJson(instance.createdAt),
    };
