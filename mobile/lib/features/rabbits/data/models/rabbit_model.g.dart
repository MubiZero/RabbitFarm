// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rabbit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RabbitModelImpl _$$RabbitModelImplFromJson(
  Map<String, dynamic> json,
) => _$RabbitModelImpl(
  id: const IntConverter().fromJson(json['id'] as Object),
  tagId: json['tag_id'] as String,
  name: json['name'] as String,
  breedId: const IntConverter().fromJson(json['breed_id'] as Object),
  sex: json['sex'] as String,
  birthDate: const DateTimeConverter().fromJson(json['birth_date'] as Object),
  color: json['color'] as String?,
  cageId: _$JsonConverterFromJson<Object, int>(
    json['cage_id'],
    const IntConverter().fromJson,
  ),
  fatherId: _$JsonConverterFromJson<Object, int>(
    json['father_id'],
    const IntConverter().fromJson,
  ),
  motherId: _$JsonConverterFromJson<Object, int>(
    json['mother_id'],
    const IntConverter().fromJson,
  ),
  status: json['status'] as String,
  purpose: json['purpose'] as String,
  acquiredDate: const NullableDateTimeConverter().fromJson(
    json['acquired_date'],
  ),
  soldDate: const NullableDateTimeConverter().fromJson(json['sold_date']),
  deathDate: const NullableDateTimeConverter().fromJson(json['death_date']),
  deathReason: json['death_reason'] as String?,
  currentWeight: (json['current_weight'] as num?)?.toDouble(),
  temperament: json['temperament'] as String?,
  notes: json['notes'] as String?,
  photoUrl: json['photo_url'] as String?,
  createdAt: const DateTimeConverter().fromJson(json['created_at'] as Object),
  updatedAt: const DateTimeConverter().fromJson(json['updated_at'] as Object),
  breed: json['Breed'] == null
      ? null
      : BreedModel.fromJson(json['Breed'] as Map<String, dynamic>),
  cage: json['Cage'] == null
      ? null
      : CageInfo.fromJson(json['Cage'] as Map<String, dynamic>),
  father: json['father'] == null
      ? null
      : ParentInfo.fromJson(json['father'] as Map<String, dynamic>),
  mother: json['mother'] == null
      ? null
      : ParentInfo.fromJson(json['mother'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$RabbitModelImplToJson(
  _$RabbitModelImpl instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'tag_id': instance.tagId,
  'name': instance.name,
  'breed_id': const IntConverter().toJson(instance.breedId),
  'sex': instance.sex,
  'birth_date': const DateTimeConverter().toJson(instance.birthDate),
  'color': instance.color,
  'cage_id': _$JsonConverterToJson<Object, int>(
    instance.cageId,
    const IntConverter().toJson,
  ),
  'father_id': _$JsonConverterToJson<Object, int>(
    instance.fatherId,
    const IntConverter().toJson,
  ),
  'mother_id': _$JsonConverterToJson<Object, int>(
    instance.motherId,
    const IntConverter().toJson,
  ),
  'status': instance.status,
  'purpose': instance.purpose,
  'acquired_date': const NullableDateTimeConverter().toJson(
    instance.acquiredDate,
  ),
  'sold_date': const NullableDateTimeConverter().toJson(instance.soldDate),
  'death_date': const NullableDateTimeConverter().toJson(instance.deathDate),
  'death_reason': instance.deathReason,
  'current_weight': instance.currentWeight,
  'temperament': instance.temperament,
  'notes': instance.notes,
  'photo_url': instance.photoUrl,
  'created_at': const DateTimeConverter().toJson(instance.createdAt),
  'updated_at': const DateTimeConverter().toJson(instance.updatedAt),
  'Breed': instance.breed,
  'Cage': instance.cage,
  'father': instance.father,
  'mother': instance.mother,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_$CageInfoImpl _$$CageInfoImplFromJson(Map<String, dynamic> json) =>
    _$CageInfoImpl(
      id: const IntConverter().fromJson(json['id'] as Object),
      number: json['number'] as String,
      type: json['type'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$CageInfoImplToJson(_$CageInfoImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'number': instance.number,
      'type': instance.type,
      'location': instance.location,
    };

_$ParentInfoImpl _$$ParentInfoImplFromJson(Map<String, dynamic> json) =>
    _$ParentInfoImpl(
      id: const IntConverter().fromJson(json['id'] as Object),
      name: json['name'] as String,
      tagId: json['tag_id'] as String,
    );

Map<String, dynamic> _$$ParentInfoImplToJson(_$ParentInfoImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'name': instance.name,
      'tag_id': instance.tagId,
    };
