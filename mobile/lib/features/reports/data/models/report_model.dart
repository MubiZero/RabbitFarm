import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/json/int_converter.dart';
import '../../../../core/json/double_converter.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

/// Dashboard Report Model
@freezed
class DashboardReport with _$DashboardReport {
  const factory DashboardReport({
    required RabbitStats rabbits,
    required CageStats cages,
    required HealthStats health,
    /// Деньги фермы приходят не всем: работнику сервер их не отдаёт вовсе.
    /// Пусто здесь означает «не для этой роли», а не «на ферме ноль» — нули
    /// читались бы как пустая касса.
    FinanceStats? finance,
    required TaskStats tasks,
    required InventoryStats inventory,
    required BreedingStats breeding,
    /// Потребление фермы против пределов тарифа. Пусто у ферм без тарифа —
    /// сервер в этом случае просто не присылает блок целиком.
    @JsonKey(name: 'plan_usage') PlanUsage? planUsage,
  }) = _DashboardReport;

  factory DashboardReport.fromJson(Map<String, dynamic> json) =>
      _$DashboardReportFromJson(json);
}

/// Потребление фермы против пределов тарифа: кролики и участники.
@freezed
class PlanUsage with _$PlanUsage {
  const factory PlanUsage({
    required ResourceUsage rabbits,
    required ResourceUsage staff,
  }) = _PlanUsage;

  factory PlanUsage.fromJson(Map<String, dynamic> json) =>
      _$PlanUsageFromJson(json);
}

/// Потребление одного ресурса тарифа. `limit: null` значит «без
/// ограничения» — та же семантика, что и в `planService` на сервере.
@freezed
class ResourceUsage with _$ResourceUsage {
  const factory ResourceUsage({
    @IntConverter() required int used,
    @NullableIntConverter() int? limit,
  }) = _ResourceUsage;

  factory ResourceUsage.fromJson(Map<String, dynamic> json) =>
      _$ResourceUsageFromJson(json);
}

@freezed
class RabbitStats with _$RabbitStats {
  const factory RabbitStats({
    @IntConverter() required int total,
    @IntConverter() required int male,
    @IntConverter() required int female,
    @Default([]) List<int> history,
  }) = _RabbitStats;

  factory RabbitStats.fromJson(Map<String, dynamic> json) =>
      _$RabbitStatsFromJson(json);
}

@freezed
class CageStats with _$CageStats {
  const factory CageStats({
    @IntConverter() required int total,
    @IntConverter() required int occupied,
    @IntConverter() required int available,
  }) = _CageStats;

  factory CageStats.fromJson(Map<String, dynamic> json) =>
      _$CageStatsFromJson(json);
}

@freezed
class HealthStats with _$HealthStats {
  const factory HealthStats({
    @IntConverter()
    required int upcomingVaccinations,
    @IntConverter()
    required int overdueVaccinations,
  }) = _HealthStats;

  factory HealthStats.fromJson(Map<String, dynamic> json) =>
      _$HealthStatsFromJson(json);
}

@freezed
class FinanceStats with _$FinanceStats {
  const factory FinanceStats({
    @DoubleConverter() required double income30days,
    @DoubleConverter() required double expenses30days,
    @DoubleConverter() required double profit30days,
  }) = _FinanceStats;

  factory FinanceStats.fromJson(Map<String, dynamic> json) =>
      _$FinanceStatsFromJson(json);
}

@freezed
class TaskStats with _$TaskStats {
  const factory TaskStats({
    @IntConverter() required int pending,
    @IntConverter() required int overdue,
    @IntConverter() required int urgent,
  }) = _TaskStats;

  factory TaskStats.fromJson(Map<String, dynamic> json) =>
      _$TaskStatsFromJson(json);
}

@freezed
class InventoryStats with _$InventoryStats {
  const factory InventoryStats({
    @IntConverter() required int lowStockFeeds,
  }) = _InventoryStats;

  factory InventoryStats.fromJson(Map<String, dynamic> json) =>
      _$InventoryStatsFromJson(json);
}

@freezed
class BreedingStats with _$BreedingStats {
  const factory BreedingStats({
    @IntConverter() required int recentBirths,
    @Default([]) List<int> history,
  }) = _BreedingStats;

  factory BreedingStats.fromJson(Map<String, dynamic> json) =>
      _$BreedingStatsFromJson(json);
}

/// Farm Report Model
@freezed
class FarmReport with _$FarmReport {
  const factory FarmReport({
    required ReportPeriod period,
    required PopulationData population,
    /// Как и в сводке «Сегодня»: работнику денежный блок не приходит.
    FinancialData? financial,
    required HealthData health,
    required BreedingData breeding,
    required FeedingData feeding,
  }) = _FarmReport;

  factory FarmReport.fromJson(Map<String, dynamic> json) =>
      _$FarmReportFromJson(json);
}

@freezed
class ReportPeriod with _$ReportPeriod {
  const factory ReportPeriod({
    required String from,
    required String to,
  }) = _ReportPeriod;

  factory ReportPeriod.fromJson(Map<String, dynamic> json) =>
      _$ReportPeriodFromJson(json);
}

@freezed
class PopulationData with _$PopulationData {
  const factory PopulationData({
    @JsonKey(name: 'total_rabbits') @IntConverter() required int totalRabbits,
    @JsonKey(name: 'by_breed') required List<BreedCount> byBreed,
  }) = _PopulationData;

  factory PopulationData.fromJson(Map<String, dynamic> json) =>
      _$PopulationDataFromJson(json);
}

@freezed
class BreedCount with _$BreedCount {
  const factory BreedCount({
    @JsonKey(name: 'breed_id') @IntConverter() required int breedId,
    @IntConverter() required int count,
  }) = _BreedCount;

  factory BreedCount.fromJson(Map<String, dynamic> json) =>
      _$BreedCountFromJson(json);
}

@freezed
class FinancialData with _$FinancialData {
  const factory FinancialData({
    required List<dynamic> transactions,
    required FinancialSummary summary,
  }) = _FinancialData;

  factory FinancialData.fromJson(Map<String, dynamic> json) =>
      _$FinancialDataFromJson(json);
}

@freezed
class FinancialSummary with _$FinancialSummary {
  const factory FinancialSummary({
    @JsonKey(name: 'total_income') @DoubleConverter() required double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() required double totalExpenses,
  }) = _FinancialSummary;

  factory FinancialSummary.fromJson(Map<String, dynamic> json) =>
      _$FinancialSummaryFromJson(json);
}

@freezed
class HealthData with _$HealthData {
  const factory HealthData({
    @IntConverter() required int vaccinations,
    @JsonKey(name: 'medical_records') @IntConverter() required int medicalRecords,
  }) = _HealthData;

  factory HealthData.fromJson(Map<String, dynamic> json) =>
      _$HealthDataFromJson(json);
}

@freezed
class BreedingData with _$BreedingData {
  const factory BreedingData({
    @IntConverter() required int breedings,
    @IntConverter() required int births,
  }) = _BreedingData;

  factory BreedingData.fromJson(Map<String, dynamic> json) =>
      _$BreedingDataFromJson(json);
}

@freezed
class FeedingData with _$FeedingData {
  const factory FeedingData({
    @JsonKey(name: 'total_feeding_records')
    @IntConverter()
    required int totalFeedingRecords,

    /// Расход по каждой единице измерения отдельно.
    ///
    /// Модель требовала одно общее число `total_feed_consumption`, которого
    /// сервер никогда не отдавал, — на настоящем ответе разбор всего отчёта
    /// падал. Не отдавал он его намеренно: складывать килограммы со штуками
    /// нельзя, сумма получилась бы бессмысленной.
    @JsonKey(name: 'consumption_by_unit')
    @Default([])
    List<FeedConsumption> consumptionByUnit,
  }) = _FeedingData;

  factory FeedingData.fromJson(Map<String, dynamic> json) =>
      _$FeedingDataFromJson(json);
}

@freezed
class FeedConsumption with _$FeedConsumption {
  const factory FeedConsumption({
    required String unit,
    @DoubleConverter() required double total,
  }) = _FeedConsumption;

  factory FeedConsumption.fromJson(Map<String, dynamic> json) =>
      _$FeedConsumptionFromJson(json);
}

/// Health Report Model
@freezed
class HealthReport with _$HealthReport {
  const factory HealthReport({
    required VaccinationsData vaccinations,
    @JsonKey(name: 'medical_records') required MedicalRecordsData medicalRecords,
  }) = _HealthReport;

  factory HealthReport.fromJson(Map<String, dynamic> json) =>
      _$HealthReportFromJson(json);
}

@freezed
class VaccinationsData with _$VaccinationsData {
  const factory VaccinationsData({
    @JsonKey(name: 'by_type') required List<VaccineTypeCount> byType,
    required List<dynamic> upcoming,
  }) = _VaccinationsData;

  factory VaccinationsData.fromJson(Map<String, dynamic> json) =>
      _$VaccinationsDataFromJson(json);
}

@freezed
class VaccineTypeCount with _$VaccineTypeCount {
  const factory VaccineTypeCount({
    @JsonKey(name: 'vaccine_name') required String vaccineName,
    @IntConverter() required int count,
  }) = _VaccineTypeCount;

  factory VaccineTypeCount.fromJson(Map<String, dynamic> json) =>
      _$VaccineTypeCountFromJson(json);
}

@freezed
class MedicalRecordsData with _$MedicalRecordsData {
  /// Сервер группирует лечение по исходу, а не по виду записи. Модель ждала
  /// `by_type` с полем `record_type` — таких полей в ответе нет, и отчёт по
  /// здоровью падал при разборе целиком.
  const factory MedicalRecordsData({
    @JsonKey(name: 'by_outcome')
    @Default([])
    List<RecordOutcomeCount> byOutcome,
  }) = _MedicalRecordsData;

  factory MedicalRecordsData.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordsDataFromJson(json);
}

@freezed
class RecordOutcomeCount with _$RecordOutcomeCount {
  /// Исход может быть не проставлен — в базе поле необязательное, и такие
  /// записи приходят отдельной группой с пустым исходом.
  const factory RecordOutcomeCount({
    String? outcome,
    @IntConverter() required int count,
  }) = _RecordOutcomeCount;

  factory RecordOutcomeCount.fromJson(Map<String, dynamic> json) =>
      _$RecordOutcomeCountFromJson(json);
}

/// Financial Report Model
@freezed
class FinancialReport with _$FinancialReport {
  const factory FinancialReport({
    required FinancialReportSummary summary,
    @JsonKey(name: 'by_category') required List<CategoryData> byCategory,
  }) = _FinancialReport;

  factory FinancialReport.fromJson(Map<String, dynamic> json) =>
      _$FinancialReportFromJson(json);
}

@freezed
class FinancialReportSummary with _$FinancialReportSummary {
  const factory FinancialReportSummary({
    @JsonKey(name: 'total_income') @DoubleConverter() required double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() required double totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() required double netProfit,
  }) = _FinancialReportSummary;

  factory FinancialReportSummary.fromJson(Map<String, dynamic> json) =>
      _$FinancialReportSummaryFromJson(json);
}

@freezed
class CategoryData with _$CategoryData {
  const factory CategoryData({
    required String type,
    required String category,
    @DoubleConverter() required double total,
    @IntConverter() required int count,
  }) = _CategoryData;

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);
}
