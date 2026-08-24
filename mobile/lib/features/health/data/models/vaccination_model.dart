import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/json/date_time_converter.dart';
import '../../../../core/json/int_converter.dart';
import '../../../rabbits/data/models/rabbit_model.dart';

part 'vaccination_model.freezed.dart';
part 'vaccination_model.g.dart';

/// Vaccine type enum
enum VaccineType {
  @JsonValue('vhd')
  vhd, // Вирусная геморрагическая болезнь кроликов
  @JsonValue('myxomatosis')
  myxomatosis, // Миксоматоз
  @JsonValue('pasteurellosis')
  pasteurellosis, // Пастереллез
  @JsonValue('other')
  other, // Другое
}

/// Extension for VaccineType display names
extension VaccineTypeExtension on VaccineType {
  String get displayName {
    switch (this) {
      case VaccineType.vhd:
        return 'ВГБК';
      case VaccineType.myxomatosis:
        return 'Миксоматоз';
      case VaccineType.pasteurellosis:
        return 'Пастереллез';
      case VaccineType.other:
        return 'Другое';
    }
  }

  String get fullName {
    switch (this) {
      case VaccineType.vhd:
        return 'Вирусная геморрагическая болезнь кроликов (ВГБК)';
      case VaccineType.myxomatosis:
        return 'Миксоматоз';
      case VaccineType.pasteurellosis:
        return 'Пастереллез';
      case VaccineType.other:
        return 'Другое';
    }
  }
}

@freezed
class Vaccination with _$Vaccination {
  const factory Vaccination({
    @IntConverter() required int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required int rabbitId,
    @JsonKey(name: 'vaccine_name') required String vaccineName,
    @JsonKey(name: 'vaccine_type') required VaccineType vaccineType,
    @JsonKey(name: 'vaccination_date') @DateOnlyConverter() required DateTime vaccinationDate,
    @JsonKey(name: 'next_vaccination_date') @NullableDateOnlyConverter() DateTime? nextVaccinationDate,
    @JsonKey(name: 'batch_number') String? batchNumber,
    String? veterinarian,
    String? notes,
    @JsonKey(name: 'created_at') @NullableDateTimeConverter() DateTime? createdAt,
    @JsonKey(name: 'updated_at') @NullableDateTimeConverter() DateTime? updatedAt,
    // Related rabbit info (from API) - не сериализуем, создаем вручную
    /// Кролик, которого лечили или прививали.
    ///
    /// Сервер шлёт его урезанным — id, кличка, бирка, пол, дата рождения, —
    /// и разбор в полную модель упал бы, поэтому связь просто выбрасывали.
    /// В списках при этом стояла ветка «показать кличку», которая не
    /// выполнялась никогда: данные приходили и не доезжали до экрана.
    @JsonKey(name: 'rabbit') RabbitRef? rabbit,
    // Calculated fields
    @JsonKey(name: 'days_until') int? daysUntil,
    @JsonKey(name: 'days_overdue') int? daysOverdue,
    @JsonKey(name: 'is_overdue') bool? isOverdue,
  }) = _Vaccination;

  factory Vaccination.fromJson(Map<String, dynamic> json) =>
      _$VaccinationFromJson(json);
}

/// Request model for creating/updating vaccination
class VaccinationRequest {
  final int rabbitId;
  final String vaccineName;
  final VaccineType vaccineType;
  final DateTime vaccinationDate;
  final DateTime? nextVaccinationDate;
  final String? batchNumber;
  final String? veterinarian;
  final String? notes;

  const VaccinationRequest({
    required this.rabbitId,
    required this.vaccineName,
    required this.vaccineType,
    required this.vaccinationDate,
    this.nextVaccinationDate,
    this.batchNumber,
    this.veterinarian,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'rabbit_id': rabbitId,
        'vaccine_name': vaccineName,
        'vaccine_type': vaccineType.name,
        'vaccination_date': const DateOnlyConverter().toJson(vaccinationDate),
        if (nextVaccinationDate != null)
          'next_vaccination_date':
              const DateOnlyConverter().toJson(nextVaccinationDate!),
        if (batchNumber != null && batchNumber!.isNotEmpty)
          'batch_number': batchNumber,
        if (veterinarian != null && veterinarian!.isNotEmpty)
          'veterinarian': veterinarian,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
      };
}

/// Vaccination statistics model
@freezed
class VaccinationStatistics with _$VaccinationStatistics {
  const factory VaccinationStatistics({
    @JsonKey(name: 'total_vaccinations') required int totalVaccinations,
    @JsonKey(name: 'by_vaccine_type') required Map<String, int> byVaccineType,
    required VaccinationUpcoming upcoming,
    @JsonKey(name: 'this_year') required int thisYear,
    @JsonKey(name: 'last_30_days') required int last30Days,
  }) = _VaccinationStatistics;

  factory VaccinationStatistics.fromJson(Map<String, dynamic> json) =>
      _$VaccinationStatisticsFromJson(json);
}

@freezed
class VaccinationUpcoming with _$VaccinationUpcoming {
  const factory VaccinationUpcoming({
    required int total,
    @JsonKey(name: 'next_30_days') required int next30Days,
    required int overdue,
    required List<UpcomingVaccinationItem> list,
  }) = _VaccinationUpcoming;

  factory VaccinationUpcoming.fromJson(Map<String, dynamic> json) =>
      _$VaccinationUpcomingFromJson(json);
}

@freezed
class UpcomingVaccinationItem with _$UpcomingVaccinationItem {
  const factory UpcomingVaccinationItem({
    @IntConverter() required int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required int rabbitId,
    @JsonKey(name: 'rabbit_name') String? rabbitName,
    @JsonKey(name: 'vaccine_name') required String vaccineName,
    @JsonKey(name: 'vaccine_type') required VaccineType vaccineType,
    @JsonKey(name: 'next_vaccination_date') @DateOnlyConverter() required DateTime nextVaccinationDate,
    @JsonKey(name: 'days_until') required int daysUntil,
    @JsonKey(name: 'is_overdue') bool? isOverdue,
  }) = _UpcomingVaccinationItem;

  factory UpcomingVaccinationItem.fromJson(Map<String, dynamic> json) =>
      _$UpcomingVaccinationItemFromJson(json);
}
