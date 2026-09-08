// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Vaccination _$VaccinationFromJson(Map<String, dynamic> json) => _Vaccination(
  id: const IntConverter().fromJson(json['id'] as Object),
  rabbitId: const IntConverter().fromJson(json['rabbit_id'] as Object),
  vaccineName: json['vaccine_name'] as String,
  vaccineType: $enumDecode(_$VaccineTypeEnumMap, json['vaccine_type']),
  vaccinationDate: const DateOnlyConverter().fromJson(
    json['vaccination_date'] as Object,
  ),
  nextVaccinationDate: const NullableDateOnlyConverter().fromJson(
    json['next_vaccination_date'],
  ),
  batchNumber: json['batch_number'] as String?,
  veterinarian: json['veterinarian'] as String?,
  notes: json['notes'] as String?,
  createdAt: const NullableDateTimeConverter().fromJson(json['created_at']),
  updatedAt: const NullableDateTimeConverter().fromJson(json['updated_at']),
  rabbit: json['rabbit'] == null
      ? null
      : RabbitRef.fromJson(json['rabbit'] as Map<String, dynamic>),
  daysUntil: (json['days_until'] as num?)?.toInt(),
  daysOverdue: (json['days_overdue'] as num?)?.toInt(),
  isOverdue: json['is_overdue'] as bool?,
);

Map<String, dynamic> _$VaccinationToJson(
  _Vaccination instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'rabbit_id': const IntConverter().toJson(instance.rabbitId),
  'vaccine_name': instance.vaccineName,
  'vaccine_type': _$VaccineTypeEnumMap[instance.vaccineType]!,
  'vaccination_date': const DateOnlyConverter().toJson(
    instance.vaccinationDate,
  ),
  'next_vaccination_date': const NullableDateOnlyConverter().toJson(
    instance.nextVaccinationDate,
  ),
  'batch_number': instance.batchNumber,
  'veterinarian': instance.veterinarian,
  'notes': instance.notes,
  'created_at': const NullableDateTimeConverter().toJson(instance.createdAt),
  'updated_at': const NullableDateTimeConverter().toJson(instance.updatedAt),
  'rabbit': instance.rabbit,
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

_VaccinationStatistics _$VaccinationStatisticsFromJson(
  Map<String, dynamic> json,
) => _VaccinationStatistics(
  totalVaccinations: (json['total_vaccinations'] as num).toInt(),
  byVaccineType: Map<String, int>.from(json['by_vaccine_type'] as Map),
  upcoming: VaccinationUpcoming.fromJson(
    json['upcoming'] as Map<String, dynamic>,
  ),
  thisYear: (json['this_year'] as num).toInt(),
  last30Days: (json['last_30_days'] as num).toInt(),
);

Map<String, dynamic> _$VaccinationStatisticsToJson(
  _VaccinationStatistics instance,
) => <String, dynamic>{
  'total_vaccinations': instance.totalVaccinations,
  'by_vaccine_type': instance.byVaccineType,
  'upcoming': instance.upcoming,
  'this_year': instance.thisYear,
  'last_30_days': instance.last30Days,
};

_VaccinationUpcoming _$VaccinationUpcomingFromJson(Map<String, dynamic> json) =>
    _VaccinationUpcoming(
      total: (json['total'] as num).toInt(),
      next30Days: (json['next_30_days'] as num).toInt(),
      overdue: (json['overdue'] as num).toInt(),
      list: (json['list'] as List<dynamic>)
          .map(
            (e) => UpcomingVaccinationItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$VaccinationUpcomingToJson(
  _VaccinationUpcoming instance,
) => <String, dynamic>{
  'total': instance.total,
  'next_30_days': instance.next30Days,
  'overdue': instance.overdue,
  'list': instance.list,
};

_UpcomingVaccinationItem _$UpcomingVaccinationItemFromJson(
  Map<String, dynamic> json,
) => _UpcomingVaccinationItem(
  id: const IntConverter().fromJson(json['id'] as Object),
  rabbitId: const IntConverter().fromJson(json['rabbit_id'] as Object),
  rabbitName: json['rabbit_name'] as String?,
  vaccineName: json['vaccine_name'] as String,
  vaccineType: $enumDecode(_$VaccineTypeEnumMap, json['vaccine_type']),
  nextVaccinationDate: const DateOnlyConverter().fromJson(
    json['next_vaccination_date'] as Object,
  ),
  daysUntil: (json['days_until'] as num).toInt(),
  isOverdue: json['is_overdue'] as bool?,
);

Map<String, dynamic> _$UpcomingVaccinationItemToJson(
  _UpcomingVaccinationItem instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'rabbit_id': const IntConverter().toJson(instance.rabbitId),
  'rabbit_name': instance.rabbitName,
  'vaccine_name': instance.vaccineName,
  'vaccine_type': _$VaccineTypeEnumMap[instance.vaccineType]!,
  'next_vaccination_date': const DateOnlyConverter().toJson(
    instance.nextVaccinationDate,
  ),
  'days_until': instance.daysUntil,
  'is_overdue': instance.isOverdue,
};
