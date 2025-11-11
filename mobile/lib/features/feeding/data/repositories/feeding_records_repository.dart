import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/feeding_record_model.dart';

/// Repository for feeding records operations
class FeedingRecordsRepository {
  final ApiClient _apiClient;

  FeedingRecordsRepository(this._apiClient);

  /// Get list of feeding records with optional filters
  Future<List<FeedingRecord>> getFeedingRecords({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    int? rabbitId,
    int? feedId,
    int? cageId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;
      if (rabbitId != null) queryParams['rabbit_id'] = rabbitId;
      if (feedId != null) queryParams['feed_id'] = feedId;
      if (cageId != null) queryParams['cage_id'] = cageId;
      if (fromDate != null) {
        queryParams['from_date'] = fromDate.toIso8601String().split('T')[0];
      }
      if (toDate != null) {
        queryParams['to_date'] = toDate.toIso8601String().split('T')[0];
      }

      final response = await _apiClient.get(
        '${ApiEndpoints.feeds}/feeding-records',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map && data.containsKey('rows')) {
          // Paginated response
          final List<dynamic> rows = data['rows'];
          return rows.map((json) => FeedingRecord.fromJson(json)).toList();
        } else if (data is List) {
          // Direct list response
          return data.map((json) => FeedingRecord.fromJson(json)).toList();
        }
      }

      return [];
    } on DioException catch (e) {
      throw Exception(
          'Failed to get feeding records: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Get feeding record by ID
  Future<FeedingRecord> getFeedingRecordById(int id) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.feeds}/feeding-records/$id',
      );

      if (response.data['success'] == true) {
        return FeedingRecord.fromJson(response.data['data']);
      }

      throw Exception('Failed to get feeding record');
    } on DioException catch (e) {
      throw Exception(
          'Failed to get feeding record: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Get feeding records for specific rabbit
  Future<List<FeedingRecord>> getRabbitFeedingRecords(int rabbitId) async {
    try {
      final response = await _apiClient.get(
        '/rabbits/$rabbitId/feeding-records',
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => FeedingRecord.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(
          'Failed to get rabbit feeding records: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Create new feeding record
  Future<FeedingRecord> createFeedingRecord(
      FeedingRecordCreate feedingRecord) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.feeds}/feeding-records',
        data: feedingRecord.toJson(),
      );

      if (response.data['success'] == true) {
        return FeedingRecord.fromJson(response.data['data']);
      }

      throw Exception('Failed to create feeding record');
    } on DioException catch (e) {
      throw Exception(
          'Failed to create feeding record: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Update feeding record
  Future<FeedingRecord> updateFeedingRecord(
      int id, FeedingRecordUpdate feedingRecord) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.feeds}/feeding-records/$id',
        data: feedingRecord.toJson(),
      );

      if (response.data['success'] == true) {
        return FeedingRecord.fromJson(response.data['data']);
      }

      throw Exception('Failed to update feeding record');
    } on DioException catch (e) {
      throw Exception(
          'Failed to update feeding record: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Delete feeding record
  Future<void> deleteFeedingRecord(int id) async {
    try {
      final response = await _apiClient.delete(
        '${ApiEndpoints.feeds}/feeding-records/$id',
      );

      if (response.data['success'] != true) {
        throw Exception('Failed to delete feeding record');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to delete feeding record: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Get feeding statistics
  Future<FeedingStatistics> getStatistics({
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
        '${ApiEndpoints.feeds}/feeding-records/statistics',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        return FeedingStatistics.fromJson(response.data['data']);
      }

      throw Exception('Failed to get statistics');
    } on DioException catch (e) {
      throw Exception(
          'Failed to get statistics: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// Get recent feeding records
  Future<List<FeedingRecord>> getRecentFeedingRecords({int? limit}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiClient.get(
        '${ApiEndpoints.feeds}/feeding-records/recent',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => FeedingRecord.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(
          'Failed to get recent feeding records: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
