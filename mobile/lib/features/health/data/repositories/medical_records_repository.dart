import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/medical_record_model.dart';

/// Repository for medical records operations
class MedicalRecordsRepository {
  final ApiClient _apiClient;

  MedicalRecordsRepository(this._apiClient);

  /// Get list of medical records with optional filters
  Future<List<MedicalRecord>> getMedicalRecords({
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
        if (data is Map && data.containsKey('rows')) {
          // Paginated response
          final List<dynamic> rows = data['rows'];
          return rows.map((json) => MedicalRecord.fromJson(json)).toList();
        } else if (data is List) {
          // Direct list response
          return data.map((json) => MedicalRecord.fromJson(json)).toList();
        }
      }

      return [];
    } on DioException catch (e) {
      throw Exception(
          'Failed to get medical records: ${e.response?.data['message'] ?? e.message}');
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

      throw Exception('Failed to get medical record');
    } on DioException catch (e) {
      throw Exception(
          'Failed to get medical record: ${e.response?.data['message'] ?? e.message}');
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
      throw Exception(
          'Failed to get rabbit medical records: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Create new medical record
  Future<MedicalRecord> createMedicalRecord(
      MedicalRecordCreate medicalRecord) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.medicalRecords,
        data: medicalRecord.toJson(),
      );

      if (response.data['success'] == true) {
        return MedicalRecord.fromJson(response.data['data']);
      }

      throw Exception('Failed to create medical record');
    } on DioException catch (e) {
      throw Exception(
          'Failed to create medical record: ${e.response?.data['message'] ?? e.message}');
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

      throw Exception('Failed to update medical record');
    } on DioException catch (e) {
      throw Exception(
          'Failed to update medical record: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Delete medical record
  Future<void> deleteMedicalRecord(int id) async {
    try {
      final response = await _apiClient.delete(
        '${ApiEndpoints.medicalRecords}/$id',
      );

      if (response.data['success'] != true) {
        throw Exception('Failed to delete medical record');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to delete medical record: ${e.response?.data['message'] ?? e.message}');
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

      throw Exception('Failed to get statistics');
    } on DioException catch (e) {
      throw Exception(
          'Failed to get statistics: ${e.response?.data['message'] ?? e.message}');
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
      throw Exception(
          'Failed to get ongoing treatments: ${e.response?.data['message'] ?? e.message}');
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

      throw Exception('Failed to get cost report');
    } on DioException catch (e) {
      throw Exception(
          'Failed to get cost report: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
