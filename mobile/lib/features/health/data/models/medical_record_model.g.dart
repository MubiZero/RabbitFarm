// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicalRecord _$MedicalRecordFromJson(Map<String, dynamic> json) =>
    _MedicalRecord(
      id: const IntConverter().fromJson(json['id'] as Object),
      rabbitId: const IntConverter().fromJson(json['rabbit_id'] as Object),
      symptoms: json['symptoms'] as String,
      diagnosis: json['diagnosis'] as String?,
      treatment: json['treatment'] as String?,
      medication: json['medication'] as String?,
      dosage: json['dosage'] as String?,
      startedAt: const DateOnlyConverter().fromJson(
        json['started_at'] as Object,
      ),
      endedAt: const NullableDateOnlyConverter().fromJson(json['ended_at']),
      outcome:
          $enumDecodeNullable(_$MedicalOutcomeEnumMap, json['outcome']) ??
          MedicalOutcome.ongoing,
      cost: _$JsonConverterFromJson<Object, double>(
        json['cost'],
        const DoubleConverter().fromJson,
      ),
      veterinarian: json['veterinarian'] as String?,
      notes: json['notes'] as String?,
      createdAt: const NullableDateTimeConverter().fromJson(json['created_at']),
      updatedAt: const NullableDateTimeConverter().fromJson(json['updated_at']),
      rabbit: json['rabbit'] == null
          ? null
          : RabbitRef.fromJson(json['rabbit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MedicalRecordToJson(
  _MedicalRecord instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'rabbit_id': const IntConverter().toJson(instance.rabbitId),
  'symptoms': instance.symptoms,
  'diagnosis': instance.diagnosis,
  'treatment': instance.treatment,
  'medication': instance.medication,
  'dosage': instance.dosage,
  'started_at': const DateOnlyConverter().toJson(instance.startedAt),
  'ended_at': const NullableDateOnlyConverter().toJson(instance.endedAt),
  'outcome': _$MedicalOutcomeEnumMap[instance.outcome]!,
  'cost': _$JsonConverterToJson<Object, double>(
    instance.cost,
    const DoubleConverter().toJson,
  ),
  'veterinarian': instance.veterinarian,
  'notes': instance.notes,
  'created_at': const NullableDateTimeConverter().toJson(instance.createdAt),
  'updated_at': const NullableDateTimeConverter().toJson(instance.updatedAt),
  'rabbit': instance.rabbit,
};

const _$MedicalOutcomeEnumMap = {
  MedicalOutcome.recovered: 'recovered',
  MedicalOutcome.ongoing: 'ongoing',
  MedicalOutcome.died: 'died',
  MedicalOutcome.euthanized: 'euthanized',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_MedicalRecordCreate _$MedicalRecordCreateFromJson(Map<String, dynamic> json) =>
    _MedicalRecordCreate(
      rabbitId: (json['rabbit_id'] as num).toInt(),
      symptoms: json['symptoms'] as String,
      diagnosis: json['diagnosis'] as String?,
      treatment: json['treatment'] as String?,
      medication: json['medication'] as String?,
      dosage: json['dosage'] as String?,
      startedAt: const DateOnlyConverter().fromJson(
        json['started_at'] as Object,
      ),
      endedAt: const NullableDateOnlyConverter().fromJson(json['ended_at']),
      outcome: json['outcome'] as String? ?? 'ongoing',
      cost: (json['cost'] as num?)?.toDouble(),
      veterinarian: json['veterinarian'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$MedicalRecordCreateToJson(
  _MedicalRecordCreate instance,
) => <String, dynamic>{
  'rabbit_id': instance.rabbitId,
  'symptoms': instance.symptoms,
  'diagnosis': instance.diagnosis,
  'treatment': instance.treatment,
  'medication': instance.medication,
  'dosage': instance.dosage,
  'started_at': const DateOnlyConverter().toJson(instance.startedAt),
  'ended_at': const NullableDateOnlyConverter().toJson(instance.endedAt),
  'outcome': instance.outcome,
  'cost': instance.cost,
  'veterinarian': instance.veterinarian,
  'notes': instance.notes,
};

_MedicalRecordUpdate _$MedicalRecordUpdateFromJson(Map<String, dynamic> json) =>
    _MedicalRecordUpdate(
      rabbitId: (json['rabbit_id'] as num?)?.toInt(),
      symptoms: json['symptoms'] as String?,
      diagnosis: json['diagnosis'] as String?,
      treatment: json['treatment'] as String?,
      medication: json['medication'] as String?,
      dosage: json['dosage'] as String?,
      startedAt: const NullableDateOnlyConverter().fromJson(json['started_at']),
      endedAt: const NullableDateOnlyConverter().fromJson(json['ended_at']),
      outcome: json['outcome'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      veterinarian: json['veterinarian'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$MedicalRecordUpdateToJson(
  _MedicalRecordUpdate instance,
) => <String, dynamic>{
  'rabbit_id': instance.rabbitId,
  'symptoms': instance.symptoms,
  'diagnosis': instance.diagnosis,
  'treatment': instance.treatment,
  'medication': instance.medication,
  'dosage': instance.dosage,
  'started_at': const NullableDateOnlyConverter().toJson(instance.startedAt),
  'ended_at': const NullableDateOnlyConverter().toJson(instance.endedAt),
  'outcome': instance.outcome,
  'cost': instance.cost,
  'veterinarian': instance.veterinarian,
  'notes': instance.notes,
};

_MedicalStatistics _$MedicalStatisticsFromJson(Map<String, dynamic> json) =>
    _MedicalStatistics(
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

Map<String, dynamic> _$MedicalStatisticsToJson(_MedicalStatistics instance) =>
    <String, dynamic>{
      'total_records': instance.totalRecords,
      'by_outcome': instance.byOutcome,
      'ongoing_treatments': instance.ongoingTreatments,
      'total_cost': instance.totalCost,
      'this_year': instance.thisYear,
      'last_month': instance.lastMonth,
    };

_MedicalOutcomeStats _$MedicalOutcomeStatsFromJson(Map<String, dynamic> json) =>
    _MedicalOutcomeStats(
      recovered: (json['recovered'] as num?)?.toInt() ?? 0,
      ongoing: (json['ongoing'] as num?)?.toInt() ?? 0,
      died: (json['died'] as num?)?.toInt() ?? 0,
      euthanized: (json['euthanized'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MedicalOutcomeStatsToJson(
  _MedicalOutcomeStats instance,
) => <String, dynamic>{
  'recovered': instance.recovered,
  'ongoing': instance.ongoing,
  'died': instance.died,
  'euthanized': instance.euthanized,
};

_OngoingTreatment _$OngoingTreatmentFromJson(Map<String, dynamic> json) =>
    _OngoingTreatment(
      id: const IntConverter().fromJson(json['id'] as Object),
      rabbitId: const IntConverter().fromJson(json['rabbit_id'] as Object),
      rabbitName: json['rabbit_name'] as String?,
      diagnosis: json['diagnosis'] as String?,
      startedAt: const DateOnlyConverter().fromJson(
        json['started_at'] as Object,
      ),
      daysOngoing: (json['days_ongoing'] as num).toInt(),
      symptoms: json['symptoms'] as String?,
    );

Map<String, dynamic> _$OngoingTreatmentToJson(_OngoingTreatment instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'rabbit_id': const IntConverter().toJson(instance.rabbitId),
      'rabbit_name': instance.rabbitName,
      'diagnosis': instance.diagnosis,
      'started_at': const DateOnlyConverter().toJson(instance.startedAt),
      'days_ongoing': instance.daysOngoing,
      'symptoms': instance.symptoms,
    };

_MedicalRecordWithDays _$MedicalRecordWithDaysFromJson(
  Map<String, dynamic> json,
) => _MedicalRecordWithDays(
  id: const IntConverter().fromJson(json['id'] as Object),
  rabbitId: const IntConverter().fromJson(json['rabbit_id'] as Object),
  symptoms: json['symptoms'] as String,
  diagnosis: json['diagnosis'] as String?,
  treatment: json['treatment'] as String?,
  medication: json['medication'] as String?,
  dosage: json['dosage'] as String?,
  startedAt: const DateOnlyConverter().fromJson(json['started_at'] as Object),
  endedAt: const NullableDateOnlyConverter().fromJson(json['ended_at']),
  outcome:
      $enumDecodeNullable(_$MedicalOutcomeEnumMap, json['outcome']) ??
      MedicalOutcome.ongoing,
  cost: _$JsonConverterFromJson<Object, double>(
    json['cost'],
    const DoubleConverter().fromJson,
  ),
  veterinarian: json['veterinarian'] as String?,
  notes: json['notes'] as String?,
  daysOngoing: (json['days_ongoing'] as num).toInt(),
  rabbit: json['rabbit'] == null
      ? null
      : RabbitRef.fromJson(json['rabbit'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MedicalRecordWithDaysToJson(
  _MedicalRecordWithDays instance,
) => <String, dynamic>{
  'id': const IntConverter().toJson(instance.id),
  'rabbit_id': const IntConverter().toJson(instance.rabbitId),
  'symptoms': instance.symptoms,
  'diagnosis': instance.diagnosis,
  'treatment': instance.treatment,
  'medication': instance.medication,
  'dosage': instance.dosage,
  'started_at': const DateOnlyConverter().toJson(instance.startedAt),
  'ended_at': const NullableDateOnlyConverter().toJson(instance.endedAt),
  'outcome': _$MedicalOutcomeEnumMap[instance.outcome]!,
  'cost': _$JsonConverterToJson<Object, double>(
    instance.cost,
    const DoubleConverter().toJson,
  ),
  'veterinarian': instance.veterinarian,
  'notes': instance.notes,
  'days_ongoing': instance.daysOngoing,
  'rabbit': instance.rabbit,
};

_CostReport _$CostReportFromJson(Map<String, dynamic> json) => _CostReport(
  records: (json['records'] as List<dynamic>)
      .map((e) => MedicalRecord.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCost: (json['total_cost'] as num).toDouble(),
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$CostReportToJson(_CostReport instance) =>
    <String, dynamic>{
      'records': instance.records,
      'total_cost': instance.totalCost,
      'count': instance.count,
    };
