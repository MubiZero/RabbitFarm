// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FarmRef _$FarmRefFromJson(Map<String, dynamic> json) => _FarmRef(
  id: const IntConverter().fromJson(json['id'] as Object),
  status: json['status'] as String,
);

Map<String, dynamic> _$FarmRefToJson(_FarmRef instance) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'status': instance.status,
};
