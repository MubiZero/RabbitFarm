// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_admin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlanImpl _$$PlanImplFromJson(Map<String, dynamic> json) => _$PlanImpl(
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

Map<String, dynamic> _$$PlanImplToJson(_$PlanImpl instance) =>
    <String, dynamic>{
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

_$PlanDraftImpl _$$PlanDraftImplFromJson(Map<String, dynamic> json) =>
    _$PlanDraftImpl(
      name: json['name'] as String,
      maxRabbits: (json['max_rabbits'] as num?)?.toInt(),
      maxStaff: (json['max_staff'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool,
      isDefault: json['is_default'] as bool? ?? false,
    );

Map<String, dynamic> _$$PlanDraftImplToJson(_$PlanDraftImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'max_rabbits': instance.maxRabbits,
      'max_staff': instance.maxStaff,
      'price': instance.price,
      'is_active': instance.isActive,
      'is_default': instance.isDefault,
    };

_$PlatformFarmImpl _$$PlatformFarmImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformFarmImpl(
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

Map<String, dynamic> _$$PlatformFarmImplToJson(_$PlatformFarmImpl instance) =>
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

_$FarmStaffMemberImpl _$$FarmStaffMemberImplFromJson(
  Map<String, dynamic> json,
) => _$FarmStaffMemberImpl(
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

Map<String, dynamic> _$$FarmStaffMemberImplToJson(
  _$FarmStaffMemberImpl instance,
) => <String, dynamic>{
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

_$FarmPaymentImpl _$$FarmPaymentImplFromJson(Map<String, dynamic> json) =>
    _$FarmPaymentImpl(
      id: const IntConverter().fromJson(json['id'] as Object),
      amount: json['amount'] as String,
      currency: json['currency'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      createdAt: const DateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
    );

Map<String, dynamic> _$$FarmPaymentImplToJson(_$FarmPaymentImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'description': instance.description,
      'created_at': const DateTimeConverter().toJson(instance.createdAt),
    };

_$PlatformFarmDetailImpl _$$PlatformFarmDetailImplFromJson(
  Map<String, dynamic> json,
) => _$PlatformFarmDetailImpl(
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

Map<String, dynamic> _$$PlatformFarmDetailImplToJson(
  _$PlatformFarmDetailImpl instance,
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
