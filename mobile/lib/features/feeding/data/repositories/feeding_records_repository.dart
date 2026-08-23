import 'package:dio/dio.dart';
import '../../../../core/api/paginated.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/feeding_record_model.dart';
import '../../../../core/api/api_failure.dart';

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
        ApiEndpoints.feedingRecords,
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        return itemsOf(data)
            .map((json) => FeedingRecord.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Get feeding record by ID
  Future<FeedingRecord> getFeedingRecordById(int id) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.feedingRecords}/$id',
      );

      if (response.data['success'] == true) {
        return FeedingRecord.fromJson(response.data['data']);
      }

      throw const ApiFailure(ApiFailureKind.server);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
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
      throw ApiFailure.from(e);
    }
  }

  /// Create new feeding record
  Future<FeedingRecord> createFeedingRecord(
      FeedingRecordCreate feedingRecord) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.feedingRecords,
        data: feedingRecord.toJson(),
      );

      if (response.data['success'] == true) {
        return FeedingRecord.fromJson(response.data['data']);
      }

      throw const ApiFailure(ApiFailureKind.server);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Update feeding record
  Future<FeedingRecord> updateFeedingRecord(
      int id, FeedingRecordUpdate feedingRecord) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.feedingRecords}/$id',
        data: feedingRecord.toJson(),
      );

      if (response.data['success'] == true) {
        return FeedingRecord.fromJson(response.data['data']);
      }

      throw const ApiFailure(ApiFailureKind.server);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Delete feeding record
  Future<void> deleteFeedingRecord(int id) async {
    try {
      final response = await _apiClient.delete(
        '${ApiEndpoints.feedingRecords}/$id',
      );

      if (response.data['success'] != true) {
        throw const ApiFailure(ApiFailureKind.server);
      }
    } on DioException catch (e) {
      throw ApiFailure.from(e);
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
        '${ApiEndpoints.feedingRecords}/statistics',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        return FeedingStatistics.fromJson(response.data['data']);
      }

      throw const ApiFailure(ApiFailureKind.server);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Get recent feeding records
  Future<List<FeedingRecord>> getRecentFeedingRecords({int? limit}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiClient.get(
        '${ApiEndpoints.feedingRecords}/recent',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => FeedingRecord.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }
}
