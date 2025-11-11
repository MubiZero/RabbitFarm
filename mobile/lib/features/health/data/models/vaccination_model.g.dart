// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VaccinationImpl _$$VaccinationImplFromJson(Map<String, dynamic> json) =>
    _$VaccinationImpl(
      id: const IntConverter().fromJson(json['id'] as Object),
      rabbitId: const IntConverter().fromJson(json['rabbit_id'] as Object),
      vaccineName: json['vaccine_name'] as String,
      vaccineType: $enumDecode(_$VaccineTypeEnumMap, json['vaccine_type']),
      vaccinationDate: DateTime.parse(json['vaccination_date'] as String),
      nextVaccinationDate: json['next_vaccination_date'] == null
          ? null
          : DateTime.parse(json['next_vaccination_date'] as String),
      batchNumber: json['batch_number'] as String?,
      veterinarian: json['veterinarian'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      daysUntil: (json['days_until'] as num?)?.toInt(),
      daysOverdue: (json['days_overdue'] as num?)?.toInt(),
      isOverdue: json['is_overdue'] as bool?,
    );

Map<String, dynamic> _$$VaccinationImplToJson(_$VaccinationImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'rabbit_id': const IntConverter().toJson(instance.rabbitId),
      'vaccine_name': instance.vaccineName,
      'vaccine_type': _$VaccineTypeEnumMap[instance.vaccineType]!,
      'vaccination_date': instance.vaccinationDate.toIso8601String(),
      'next_vaccination_date': instance.nextVaccinationDate?.toIso8601String(),
      'batch_number': instance.batchNumber,
      'veterinarian': instance.veterinarian,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'days_until': instance.daysUntil,
      'days_overdue': instance.daysOverdue,
      'is_overdue': instance.isOverdue,
    };

const _$VaccineTypeEnumMap = {
  VaccineType.vhd: 'vhd',
  VaccineType.myxomatosis: 'myxomatosis',
  VaccineType.pasteurellosis: 'pasteurellosis',
  VaccineType.other: 'other',
};

_$VaccinationStatisticsImpl _$$VaccinationStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$VaccinationStatisticsImpl(
  totalVaccinations: (json['total_vaccinations'] as num).toInt(),
  byVaccineType: Map<String, int>.from(json['by_vaccine_type'] as Map),
  upcoming: VaccinationUpcoming.fromJson(
    json['upcoming'] as Map<String, dynamic>,
  ),
  thisYear: (json['this_year'] as num).toInt(),
  last30Days: (json['last_30_days'] as num).toInt(),
);

Map<String, dynamic> _$$VaccinationStatisticsImplToJson(
  _$VaccinationStatisticsImpl instance,
) => <String, dynamic>{
  'total_vaccinations': instance.totalVaccinations,
  'by_vaccine_type': instance.byVaccineType,
  'upcoming': instance.upcoming,
  'this_year': instance.thisYear,
  'last_30_days': instance.last30Days,
};

_$VaccinationUpcomingImpl _$$VaccinationUpcomingImplFromJson(
  Map<String, dynamic> json,
) => _$VaccinationUpcomingImpl(
  total: (json['total'] as num).toInt(),
  next30Days: (json['next_30_days'] as num).toInt(),
  overdue: (json['overdue'] as num).toInt(),
  list: (json['list'] as List<dynamic>)
      .map((e) => UpcomingVaccinationItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$VaccinationUpcomingImplToJson(
  _$VaccinationUpcomingImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'next_30_days': instance.next30Days,
  'overdue': instance.overdue,
  'list': instance.list,
};

_$UpcomingVaccinationItemImpl _$$UpcomingVaccinationItemImplFromJson(
  Map<String, dynamic> json,
) => _$UpcomingVaccinationItemImpl(
  id: const IntConverter().fromJson(json['id'] as Object),
  rabbitId: const IntConverter().fromJson(json['rabbit_id'] as Object),
  rabbitName: json['rabbit_name'] as String?,
  vaccineName: json['vaccine_name'] as String,
  vaccineType: $enumDecode(_$VaccineTypeEnumMap, json['vaccine_type']),
  nextVaccinationDate: DateTime.parse(json['next_vaccination_date'] as String),
  daysUntil: (json['days_until'] as num).toInt(),
  isOverdue: json['is_overdue'] as bool?,
);

Map<String, dynamic> _$$UpcomingVaccinationItemImplToJson(
  _$UpcomingVaccinationItemImpl instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'rabbit_id': const IntConverter().toJson(instance.rabbitId),
  'rabbit_name': instance.rabbitName,
  'vaccine_name': instance.vaccineName,
  'vaccine_type': _$VaccineTypeEnumMap[instance.vaccineType]!,
  'next_vaccination_date': instance.nextVaccinationDate.toIso8601String(),
  'days_until': instance.daysUntil,
  'is_overdue': instance.isOverdue,
};
