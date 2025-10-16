// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rabbit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RabbitModelImpl _$$RabbitModelImplFromJson(Map<String, dynamic> json) =>
    _$RabbitModelImpl(
      id: (json['id'] as num).toInt(),
      tagId: json['tag_id'] as String,
      name: json['name'] as String,
      breedId: (json['breed_id'] as num).toInt(),
      sex: json['sex'] as String,
      birthDate: DateTime.parse(json['birth_date'] as String),
      color: json['color'] as String?,
      cageId: (json['cage_id'] as num?)?.toInt(),
      fatherId: (json['father_id'] as num?)?.toInt(),
      motherId: (json['mother_id'] as num?)?.toInt(),
      status: json['status'] as String,
      purpose: json['purpose'] as String,
      acquiredDate: json['acquired_date'] == null
          ? null
          : DateTime.parse(json['acquired_date'] as String),
      soldDate: json['sold_date'] == null
          ? null
          : DateTime.parse(json['sold_date'] as String),
      deathDate: json['death_date'] == null
          ? null
          : DateTime.parse(json['death_date'] as String),
      deathReason: json['death_reason'] as String?,
      currentWeight: (json['current_weight'] as num?)?.toDouble(),
      temperament: json['temperament'] as String?,
      notes: json['notes'] as String?,
      photoUrl: json['photo_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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

Map<String, dynamic> _$$RabbitModelImplToJson(_$RabbitModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag_id': instance.tagId,
      'name': instance.name,
      'breed_id': instance.breedId,
      'sex': instance.sex,
      'birth_date': instance.birthDate.toIso8601String(),
      'color': instance.color,
      'cage_id': instance.cageId,
      'father_id': instance.fatherId,
      'mother_id': instance.motherId,
      'status': instance.status,
      'purpose': instance.purpose,
      'acquired_date': instance.acquiredDate?.toIso8601String(),
      'sold_date': instance.soldDate?.toIso8601String(),
      'death_date': instance.deathDate?.toIso8601String(),
      'death_reason': instance.deathReason,
      'current_weight': instance.currentWeight,
      'temperament': instance.temperament,
      'notes': instance.notes,
      'photo_url': instance.photoUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'Breed': instance.breed,
      'Cage': instance.cage,
      'father': instance.father,
      'mother': instance.mother,
    };

_$CageInfoImpl _$$CageInfoImplFromJson(Map<String, dynamic> json) =>
    _$CageInfoImpl(
      id: (json['id'] as num).toInt(),
      number: json['number'] as String,
      type: json['type'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$CageInfoImplToJson(_$CageInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'type': instance.type,
      'location': instance.location,
    };

_$ParentInfoImpl _$$ParentInfoImplFromJson(Map<String, dynamic> json) =>
    _$ParentInfoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      tagId: json['tag_id'] as String,
    );

Map<String, dynamic> _$$ParentInfoImplToJson(_$ParentInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tag_id': instance.tagId,
    };
