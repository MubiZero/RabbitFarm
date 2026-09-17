import 'package:dio/dio.dart';
import '../../../../core/api/paginated.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/medical_record_model.dart';
import '../../../../core/api/api_failure.dart';
import '../../../../shared/models/api_response.dart';

/// Repository for medical records operations
class MedicalRecordsRepository {
  final ApiClient _apiClient;

  MedicalRecordsRepository(this._apiClient);

  /// Get list of medical records with optional filters
  /// Страница записей о лечении вместе со сведениями о следующей.
  ///
  /// Раньше метод отдавал только записи, а сведения о страницах терял —
  /// список молча обрывался и выглядел полным.
  Future<PaginatedResponse<MedicalRecord>> getMedicalRecords({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    int? rabbitId,
    String? outcome,
    DateTime? fromDate,
    DateTime? toDate,
    bool? ongoing,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;
      if (rabbitId != null) queryParams['rabbit_id'] = rabbitId;
      if (outcome != null) queryParams['outcome'] = outcome;
      if (fromDate != null) {
        queryParams['from_date'] = fromDate.toIso8601String().split('T')[0];
      }
      if (toDate != null) {
        queryParams['to_date'] = toDate.toIso8601String().split('T')[0];
      }
      if (ongoing != null) queryParams['ongoing'] = ongoing.toString();

      final response = await _apiClient.get(
        ApiEndpoints.medicalRecords,
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        final items = itemsOf(data)
            .map((json) => MedicalRecord.fromJson(json as Map<String, dynamic>))
            .toList();

        // Сведений о страницах может не быть у старого ответа — тогда
        // считаем список законченным, иначе экран звал бы следующую
        // страницу без конца.
        final pagination =
            data is Map<String, dynamic> ? data['pagination'] : null;
        final map = pagination is Map<String, dynamic> ? pagination : null;

        return PaginatedResponse<MedicalRecord>(
          items: items,
          total: (map?['total'] as num?)?.toInt() ?? items.length,
          page: (map?['page'] as num?)?.toInt() ?? (page ?? 1),
          limit: (map?['limit'] as num?)?.toInt() ?? (limit ?? items.length),
          totalPages: (map?['total_pages'] as num?)?.toInt() ?? 1,
        );
      }

      return PaginatedResponse<MedicalRecord>(
        items: const [],
        total: 0,
        page: page ?? 1,
        limit: limit ?? 0,
        totalPages: 0,
      );
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Get medical record by ID
  Future<MedicalRecord> getMedicalRecordById(int id) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.medicalRecords}/$id',
      );

      if (response.data['success'] == true) {
        return MedicalRecord.fromJson(response.data['data']);
      }

      throw const ApiFailure(ApiFailureKind.server);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Get medical records for specific rabbit
  Future<List<MedicalRecord>> getRabbitMedicalRecords(int rabbitId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.rabbitMedicalRecords(rabbitId),
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => MedicalRecord.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Create new medical record
  Future<MedicalRecord> createMedicalRecord(
          MedicalRecordCreate medicalRecord) =>
      createMedicalRecordFromJson(medicalRecord.toJson());

  /// То же, но из готового тела запроса — для отложенной очереди, которая
  /// хранит запись на диске уже сериализованной.
  Future<MedicalRecord> createMedicalRecordFromJson(
      Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.medicalRecords,
        data: data,
      );

      if (response.data['success'] == true) {
        return MedicalRecord.fromJson(response.data['data']);
      }

      throw const ApiFailure(ApiFailureKind.server);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Update medical record
  Future<MedicalRecord> updateMedicalRecord(
      int id, MedicalRecordUpdate medicalRecord) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.medicalRecords}/$id',
        data: medicalRecord.toJson(),
      );

      if (response.data['success'] == true) {
        return MedicalRecord.fromJson(response.data['data']);
      }

      throw const ApiFailure(ApiFailureKind.server);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Delete medical record
  Future<void> deleteMedicalRecord(int id) async {
    try {
      final response = await _apiClient.delete(
        '${ApiEndpoints.medicalRecords}/$id',
      );

      if (response.data['success'] != true) {
        throw const ApiFailure(ApiFailureKind.server);
      }
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Get medical records statistics
  Future<MedicalStatistics> getStatistics() async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.medicalRecords}/statistics',
      );

      if (response.data['success'] == true) {
        return MedicalStatistics.fromJson(response.data['data']);
      }

      throw const ApiFailure(ApiFailureKind.server);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Get ongoing treatments
  Future<List<MedicalRecordWithDays>> getOngoingTreatments() async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.medicalRecords}/ongoing',
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data
            .map((json) => MedicalRecordWithDays.fromJson(json))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Get cost report with optional date filters
  Future<CostReport> getCostReport({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (fromDate != null) {
        queryParams['from_date'] = fromDate.toIso8601String().split('T')[0];
      }
      if (toDate != null) {
        queryParams['to_date'] = toDate.toIso8601String().split('T')[0];
      }

      final response = await _apiClient.get(
        '${ApiEndpoints.medicalRecords}/costs',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        return CostReport.fromJson(response.data['data']);
      }

      throw const ApiFailure(ApiFailureKind.server);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }
}
