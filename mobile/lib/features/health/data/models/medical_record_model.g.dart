// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicalRecordImpl _$$MedicalRecordImplFromJson(Map<String, dynamic> json) =>
    _$MedicalRecordImpl(
      id: const IntConverter().fromJson(json['id']),
      rabbitId: const IntConverter().fromJson(json['rabbit_id']),
      symptoms: json['symptoms'] as String,
      diagnosis: json['diagnosis'] as String?,
      treatment: json['treatment'] as String?,
      medication: json['medication'] as String?,
      dosage: json['dosage'] as String?,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] == null
          ? null
          : DateTime.parse(json['ended_at'] as String),
      outcome:
          $enumDecodeNullable(_$MedicalOutcomeEnumMap, json['outcome']) ??
          MedicalOutcome.ongoing,
      cost: const DoubleConverter().fromJson(json['cost']),
      veterinarian: json['veterinarian'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MedicalRecordImplToJson(_$MedicalRecordImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'rabbit_id': const IntConverter().toJson(instance.rabbitId),
      'symptoms': instance.symptoms,
      'diagnosis': instance.diagnosis,
      'treatment': instance.treatment,
      'medication': instance.medication,
      'dosage': instance.dosage,
      'started_at': instance.startedAt.toIso8601String(),
      'ended_at': instance.endedAt?.toIso8601String(),
      'outcome': _$MedicalOutcomeEnumMap[instance.outcome]!,
      'cost': const DoubleConverter().toJson(instance.cost),
      'veterinarian': instance.veterinarian,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$MedicalOutcomeEnumMap = {
  MedicalOutcome.recovered: 'recovered',
  MedicalOutcome.ongoing: 'ongoing',
  MedicalOutcome.died: 'died',
  MedicalOutcome.euthanized: 'euthanized',
};

_$MedicalRecordCreateImpl _$$MedicalRecordCreateImplFromJson(
  Map<String, dynamic> json,
) => _$MedicalRecordCreateImpl(
  rabbitId: (json['rabbit_id'] as num).toInt(),
  symptoms: json['symptoms'] as String,
  diagnosis: json['diagnosis'] as String?,
  treatment: json['treatment'] as String?,
  medication: json['medication'] as String?,
  dosage: json['dosage'] as String?,
  startedAt: DateTime.parse(json['started_at'] as String),
  endedAt: json['ended_at'] == null
      ? null
      : DateTime.parse(json['ended_at'] as String),
  outcome: json['outcome'] as String? ?? 'ongoing',
  cost: (json['cost'] as num?)?.toDouble(),
  veterinarian: json['veterinarian'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$MedicalRecordCreateImplToJson(
  _$MedicalRecordCreateImpl instance,
) => <String, dynamic>{
  'rabbit_id': instance.rabbitId,
  'symptoms': instance.symptoms,
  'diagnosis': instance.diagnosis,
  'treatment': instance.treatment,
  'medication': instance.medication,
  'dosage': instance.dosage,
  'started_at': instance.startedAt.toIso8601String(),
  'ended_at': instance.endedAt?.toIso8601String(),
  'outcome': instance.outcome,
  'cost': instance.cost,
  'veterinarian': instance.veterinarian,
  'notes': instance.notes,
};

_$MedicalRecordUpdateImpl _$$MedicalRecordUpdateImplFromJson(
  Map<String, dynamic> json,
) => _$MedicalRecordUpdateImpl(
  rabbitId: (json['rabbit_id'] as num?)?.toInt(),
  symptoms: json['symptoms'] as String?,
  diagnosis: json['diagnosis'] as String?,
  treatment: json['treatment'] as String?,
  medication: json['medication'] as String?,
  dosage: json['dosage'] as String?,
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  endedAt: json['ended_at'] == null
      ? null
      : DateTime.parse(json['ended_at'] as String),
  outcome: json['outcome'] as String?,
  cost: (json['cost'] as num?)?.toDouble(),
  veterinarian: json['veterinarian'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$MedicalRecordUpdateImplToJson(
  _$MedicalRecordUpdateImpl instance,
) => <String, dynamic>{
  'rabbit_id': instance.rabbitId,
  'symptoms': instance.symptoms,
  'diagnosis': instance.diagnosis,
  'treatment': instance.treatment,
  'medication': instance.medication,
  'dosage': instance.dosage,
  'started_at': instance.startedAt?.toIso8601String(),
  'ended_at': instance.endedAt?.toIso8601String(),
  'outcome': instance.outcome,
  'cost': instance.cost,
  'veterinarian': instance.veterinarian,
  'notes': instance.notes,
};

_$MedicalStatisticsImpl _$$MedicalStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$MedicalStatisticsImpl(
  totalRecords: (json['total_records'] as num).toInt(),
  byOutcome: MedicalOutcomeStats.fromJson(
    json['by_outcome'] as Map<String, dynamic>,
  ),
  ongoingTreatments: (json['ongoing_treatments'] as List<dynamic>)
      .map((e) => OngoingTreatment.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCost: (json['total_cost'] as num).toDouble(),
  thisYear: (json['this_year'] as num).toInt(),
  lastMonth: (json['last_month'] as num).toInt(),
);

Map<String, dynamic> _$$MedicalStatisticsImplToJson(
  _$MedicalStatisticsImpl instance,
) => <String, dynamic>{
  'total_records': instance.totalRecords,
  'by_outcome': instance.byOutcome,
  'ongoing_treatments': instance.ongoingTreatments,
  'total_cost': instance.totalCost,
  'this_year': instance.thisYear,
  'last_month': instance.lastMonth,
};

_$MedicalOutcomeStatsImpl _$$MedicalOutcomeStatsImplFromJson(
  Map<String, dynamic> json,
) => _$MedicalOutcomeStatsImpl(
  recovered: (json['recovered'] as num?)?.toInt() ?? 0,
  ongoing: (json['ongoing'] as num?)?.toInt() ?? 0,
  died: (json['died'] as num?)?.toInt() ?? 0,
  euthanized: (json['euthanized'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$MedicalOutcomeStatsImplToJson(
  _$MedicalOutcomeStatsImpl instance,
) => <String, dynamic>{
  'recovered': instance.recovered,
  'ongoing': instance.ongoing,
  'died': instance.died,
  'euthanized': instance.euthanized,
};

_$OngoingTreatmentImpl _$$OngoingTreatmentImplFromJson(
  Map<String, dynamic> json,
) => _$OngoingTreatmentImpl(
  id: const IntConverter().fromJson(json['id']),
  rabbitId: const IntConverter().fromJson(json['rabbit_id']),
  rabbitName: json['rabbit_name'] as String?,
  diagnosis: json['diagnosis'] as String?,
  startedAt: DateTime.parse(json['started_at'] as String),
  daysOngoing: (json['days_ongoing'] as num).toInt(),
  symptoms: json['symptoms'] as String?,
);

Map<String, dynamic> _$$OngoingTreatmentImplToJson(
  _$OngoingTreatmentImpl instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'rabbit_id': const IntConverter().toJson(instance.rabbitId),
  'rabbit_name': instance.rabbitName,
  'diagnosis': instance.diagnosis,
  'started_at': instance.startedAt.toIso8601String(),
  'days_ongoing': instance.daysOngoing,
  'symptoms': instance.symptoms,
};

_$MedicalRecordWithDaysImpl _$$MedicalRecordWithDaysImplFromJson(
  Map<String, dynamic> json,
) => _$MedicalRecordWithDaysImpl(
  id: const IntConverter().fromJson(json['id']),
  rabbitId: const IntConverter().fromJson(json['rabbit_id']),
  symptoms: json['symptoms'] as String,
  diagnosis: json['diagnosis'] as String?,
  treatment: json['treatment'] as String?,
  medication: json['medication'] as String?,
  dosage: json['dosage'] as String?,
  startedAt: DateTime.parse(json['started_at'] as String),
  endedAt: json['ended_at'] == null
      ? null
      : DateTime.parse(json['ended_at'] as String),
  outcome:
      $enumDecodeNullable(_$MedicalOutcomeEnumMap, json['outcome']) ??
      MedicalOutcome.ongoing,
  cost: const DoubleConverter().fromJson(json['cost']),
  veterinarian: json['veterinarian'] as String?,
  notes: json['notes'] as String?,
  daysOngoing: (json['days_ongoing'] as num).toInt(),
);

Map<String, dynamic> _$$MedicalRecordWithDaysImplToJson(
  _$MedicalRecordWithDaysImpl instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'rabbit_id': const IntConverter().toJson(instance.rabbitId),
  'symptoms': instance.symptoms,
  'diagnosis': instance.diagnosis,
  'treatment': instance.treatment,
  'medication': instance.medication,
  'dosage': instance.dosage,
  'started_at': instance.startedAt.toIso8601String(),
  'ended_at': instance.endedAt?.toIso8601String(),
  'outcome': _$MedicalOutcomeEnumMap[instance.outcome]!,
  'cost': const DoubleConverter().toJson(instance.cost),
  'veterinarian': instance.veterinarian,
  'notes': instance.notes,
  'days_ongoing': instance.daysOngoing,
};

_$CostReportImpl _$$CostReportImplFromJson(Map<String, dynamic> json) =>
    _$CostReportImpl(
      records: (json['records'] as List<dynamic>)
          .map((e) => MedicalRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCost: (json['total_cost'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$CostReportImplToJson(_$CostReportImpl instance) =>
    <String, dynamic>{
      'records': instance.records,
      'total_cost': instance.totalCost,
      'count': instance.count,
    };
