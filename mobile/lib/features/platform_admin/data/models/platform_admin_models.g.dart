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

_$PlatformFarmImpl _$$PlatformFarmImplFromJson(Map<String, dynamic> json) =>
    _$PlatformFarmImpl(
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
      createdAt: const DateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
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
    };
