// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRef _$UserRefFromJson(Map<String, dynamic> json) => _UserRef(
  id: const IntConverter().fromJson(json['id'] as Object),
  fullName: json['full_name'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$UserRefToJson(_UserRef instance) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'full_name': instance.fullName,
  'email': instance.email,
  'phone': instance.phone,
};
