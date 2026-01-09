import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

/// Custom converter for int values
class IntConverter implements JsonConverter<int, dynamic> {
  const IntConverter();

  @override
  int fromJson(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw ArgumentError('Cannot convert $value to int');
  }

  @override
  int toJson(int value) => value;
}

/// Custom converter for double values
class DoubleConverter implements JsonConverter<double, dynamic> {
  const DoubleConverter();

  @override
  double fromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    throw ArgumentError('Cannot convert $value to double');
  }

  @override
  double toJson(double value) => value;
}

/// Dashboard Report Model
@freezed
class DashboardReport with _$DashboardReport {
  const factory DashboardReport({
    required RabbitStats rabbits,
    required CageStats cages,
    required HealthStats health,
    required FinanceStats finance,
    required TaskStats tasks,
    required InventoryStats inventory,
    required BreedingStats breeding,
  }) = _DashboardReport;

  factory DashboardReport.fromJson(Map<String, dynamic> json) =>
      _$DashboardReportFromJson(json);
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
    required FinancialData financial,
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
    @JsonKey(name: 'total_feed_consumption')
    @DoubleConverter()
    required double totalFeedConsumption,
  }) = _FeedingData;

  factory FeedingData.fromJson(Map<String, dynamic> json) =>
      _$FeedingDataFromJson(json);
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
  const factory MedicalRecordsData({
    @JsonKey(name: 'by_type') required List<RecordTypeCount> byType,
  }) = _MedicalRecordsData;

  factory MedicalRecordsData.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordsDataFromJson(json);
}

@freezed
class RecordTypeCount with _$RecordTypeCount {
  const factory RecordTypeCount({
    @JsonKey(name: 'record_type') required String recordType,
    @IntConverter() required int count,
  }) = _RecordTypeCount;

  factory RecordTypeCount.fromJson(Map<String, dynamic> json) =>
      _$RecordTypeCountFromJson(json);
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
