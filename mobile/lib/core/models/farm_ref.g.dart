// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FarmRef _$FarmRefFromJson(Map<String, dynamic> json) => _FarmRef(
  id: const IntConverter().fromJson(json['id'] as Object),
  name: json['name'] as String?,
  status: json['status'] as String,
  defaultPurpose: json['default_purpose'] as String?,
  country: json['country'] as String?,
  currency: json['currency'] as String?,
  timezone: json['timezone'] as String?,
);

Map<String, dynamic> _$FarmRefToJson(_FarmRef instance) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'name': instance.name,
  'status': instance.status,
  'default_purpose': instance.defaultPurpose,
  'country': instance.country,
  'currency': instance.currency,
  'timezone': instance.timezone,
};
