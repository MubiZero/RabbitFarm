import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_error.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/report_model.dart';

/// Reports repository
class ReportsRepository {
  final ApiClient _apiClient;

  ReportsRepository(this._apiClient);

  /// Get dashboard report
  Future<DashboardReport> getDashboard() async {
    return guardRequest(() async {
      final response = await _apiClient.get(ApiEndpoints.reportDashboard);
      return DashboardReport.fromJson(response.data['data']);
    }, 'Не удалось загрузить сводку');
  }

  /// Get farm report
  Future<FarmReport> getFarmReport({String? fromDate, String? toDate}) async {
    return guardRequest(() async {
      final queryParams = <String, dynamic>{
        if (fromDate != null) 'from_date': fromDate,
        if (toDate != null) 'to_date': toDate,
      };

      final response = await _apiClient.get(
        ApiEndpoints.reportFarm,
        queryParameters: queryParams,
      );
      return FarmReport.fromJson(response.data['data']);
    }, 'Не удалось загрузить отчёт по ферме');
  }

  /// Get health report
  Future<HealthReport> getHealthReport({
    String? fromDate,
    String? toDate,
  }) async {
    return guardRequest(() async {
      final queryParams = <String, dynamic>{
        if (fromDate != null) 'from_date': fromDate,
        if (toDate != null) 'to_date': toDate,
      };

      final response = await _apiClient.get(
        ApiEndpoints.reportHealth,
        queryParameters: queryParams,
      );
      return HealthReport.fromJson(response.data['data']);
    }, 'Не удалось загрузить отчёт по здоровью');
  }

  /// Get financial report
  Future<FinancialReport> getFinancialReport({
    String? fromDate,
    String? toDate,
    String? groupBy,
  }) async {
    return guardRequest(() async {
      final queryParams = <String, dynamic>{
        if (fromDate != null) 'from_date': fromDate,
        if (toDate != null) 'to_date': toDate,
        if (groupBy != null) 'groupBy': groupBy,
      };

      final response = await _apiClient.get(
        ApiEndpoints.reportFinancial,
        queryParameters: queryParams,
      );
      return FinancialReport.fromJson(response.data['data']);
    }, 'Не удалось загрузить финансовый отчёт');
  }
}
