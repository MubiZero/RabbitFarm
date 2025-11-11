import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../rabbits/data/models/rabbit_model.dart';

part 'medical_record_model.freezed.dart';
part 'medical_record_model.g.dart';

/// Medical outcome types
enum MedicalOutcome {
  @JsonValue('recovered')
  recovered,
  @JsonValue('ongoing')
  ongoing,
  @JsonValue('died')
  died,
  @JsonValue('euthanized')
  euthanized,
}

/// Extension to get display names for medical outcomes
extension MedicalOutcomeDisplay on MedicalOutcome {
  String get displayName {
    switch (this) {
      case MedicalOutcome.recovered:
        return 'Выздоровел';
      case MedicalOutcome.ongoing:
        return 'Лечение продолжается';
      case MedicalOutcome.died:
        return 'Умер';
      case MedicalOutcome.euthanized:
        return 'Эвтаназия';
    }
  }
}

/// Medical Record model
@freezed
class MedicalRecord with _$MedicalRecord {
  const factory MedicalRecord({
    @IntConverter() required int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required int rabbitId,
    required String symptoms,
    String? diagnosis,
    String? treatment,
    String? medication,
    String? dosage,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(defaultValue: MedicalOutcome.ongoing) required MedicalOutcome outcome,
    @DoubleConverter() double? cost,
    String? veterinarian,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) Rabbit? rabbit,
  }) = _MedicalRecord;

  factory MedicalRecord.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordFromJson(json);
}

/// Medical Record Create DTO
@freezed
class MedicalRecordCreate with _$MedicalRecordCreate {
  const factory MedicalRecordCreate({
    @JsonKey(name: 'rabbit_id') required int rabbitId,
    required String symptoms,
    String? diagnosis,
    String? treatment,
    String? medication,
    String? dosage,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(defaultValue: 'ongoing') String? outcome,
    double? cost,
    String? veterinarian,
    String? notes,
  }) = _MedicalRecordCreate;

  factory MedicalRecordCreate.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordCreateFromJson(json);
}

/// Medical Record Update DTO
@freezed
class MedicalRecordUpdate with _$MedicalRecordUpdate {
  const factory MedicalRecordUpdate({
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    String? symptoms,
    String? diagnosis,
    String? treatment,
    String? medication,
    String? dosage,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    String? outcome,
    double? cost,
    String? veterinarian,
    String? notes,
  }) = _MedicalRecordUpdate;

  factory MedicalRecordUpdate.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordUpdateFromJson(json);
}

/// Medical Statistics model
@freezed
class MedicalStatistics with _$MedicalStatistics {
  const factory MedicalStatistics({
    @JsonKey(name: 'total_records') required int totalRecords,
    @JsonKey(name: 'by_outcome') required MedicalOutcomeStats byOutcome,
    @JsonKey(name: 'ongoing_treatments') required List<OngoingTreatment> ongoingTreatments,
    @JsonKey(name: 'total_cost') required double totalCost,
    @JsonKey(name: 'this_year') required int thisYear,
    @JsonKey(name: 'last_month') required int lastMonth,
  }) = _MedicalStatistics;

  factory MedicalStatistics.fromJson(Map<String, dynamic> json) =>
      _$MedicalStatisticsFromJson(json);
}

/// Medical outcome statistics
@freezed
class MedicalOutcomeStats with _$MedicalOutcomeStats {
  const factory MedicalOutcomeStats({
    @JsonKey(defaultValue: 0) required int recovered,
    @JsonKey(defaultValue: 0) required int ongoing,
    @JsonKey(defaultValue: 0) required int died,
    @JsonKey(defaultValue: 0) required int euthanized,
  }) = _MedicalOutcomeStats;

  factory MedicalOutcomeStats.fromJson(Map<String, dynamic> json) =>
      _$MedicalOutcomeStatsFromJson(json);
}

/// Ongoing treatment info
@freezed
class OngoingTreatment with _$OngoingTreatment {
  const factory OngoingTreatment({
    @IntConverter() required int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required int rabbitId,
    @JsonKey(name: 'rabbit_name') String? rabbitName,
    String? diagnosis,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'days_ongoing') required int daysOngoing,
    String? symptoms,
  }) = _OngoingTreatment;

  factory OngoingTreatment.fromJson(Map<String, dynamic> json) =>
      _$OngoingTreatmentFromJson(json);
}

/// Medical record with days ongoing info
@freezed
class MedicalRecordWithDays with _$MedicalRecordWithDays {
  const factory MedicalRecordWithDays({
    @IntConverter() required int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required int rabbitId,
    required String symptoms,
    String? diagnosis,
    String? treatment,
    String? medication,
    String? dosage,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(defaultValue: MedicalOutcome.ongoing) required MedicalOutcome outcome,
    @DoubleConverter() double? cost,
    String? veterinarian,
    String? notes,
    @JsonKey(name: 'days_ongoing') required int daysOngoing,
    @JsonKey(includeFromJson: false, includeToJson: false) Rabbit? rabbit,
  }) = _MedicalRecordWithDays;

  factory MedicalRecordWithDays.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordWithDaysFromJson(json);
}

/// Cost report model
@freezed
class CostReport with _$CostReport {
  const factory CostReport({
    required List<MedicalRecord> records,
    @JsonKey(name: 'total_cost') required double totalCost,
    required int count,
  }) = _CostReport;

  factory CostReport.fromJson(Map<String, dynamic> json) =>
      _$CostReportFromJson(json);
}

/// Custom converter for int values that might come as strings
class IntConverter implements JsonConverter<int, dynamic> {
  const IntConverter();

  @override
  int fromJson(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw ArgumentError('Cannot convert $value to int');
  }

  @override
  dynamic toJson(int value) => value;
}

/// Custom converter for double values that might come as strings
class DoubleConverter implements JsonConverter<double?, dynamic> {
  const DoubleConverter();

  @override
  double? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    throw ArgumentError('Cannot convert $value to double');
  }

  @override
  dynamic toJson(double? value) => value;
}
