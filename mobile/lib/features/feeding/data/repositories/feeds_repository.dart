import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/feed_model.dart';
import '../../../../core/api/api_error.dart';

/// Repository for feeds operations
class FeedsRepository {
  final ApiClient _apiClient;

  FeedsRepository(this._apiClient);

  /// Get list of feeds with optional filters
  Future<List<Feed>> getFeeds({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    String? type,
    bool? lowStock,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;
      if (type != null) queryParams['type'] = type;
      if (lowStock != null) queryParams['low_stock'] = lowStock.toString();
      if (search != null) queryParams['search'] = search;

      final response = await _apiClient.get(
        ApiEndpoints.feeds,
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map && data.containsKey('rows')) {
          // Paginated response
          final List<dynamic> rows = data['rows'];
          return rows.map((json) => Feed.fromJson(json)).toList();
        } else if (data is List) {
          // Direct list response
          return data.map((json) => Feed.fromJson(json)).toList();
        }
      }

      return [];
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось загрузить корма');
    }
  }

  /// Get feed by ID
  Future<Feed> getFeedById(int id) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.feeds}/$id',
      );

      if (response.data['success'] == true) {
        return Feed.fromJson(response.data['data']);
      }

      throw Exception('Не удалось загрузить корм');
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось загрузить корм');
    }
  }

  /// Create new feed
  Future<Feed> createFeed(FeedCreate feed) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.feeds,
        data: feed.toJson(),
      );

      if (response.data['success'] == true) {
        return Feed.fromJson(response.data['data']);
      }

      throw Exception('Не удалось создать корм');
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось создать корм');
    }
  }

  /// Update feed
  Future<Feed> updateFeed(int id, FeedUpdate feed) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.feeds}/$id',
        data: feed.toJson(),
      );

      if (response.data['success'] == true) {
        return Feed.fromJson(response.data['data']);
      }

      throw Exception('Не удалось обновить корм');
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось обновить корм');
    }
  }

  /// Delete feed
  Future<void> deleteFeed(int id) async {
    try {
      final response = await _apiClient.delete(
        '${ApiEndpoints.feeds}/$id',
      );

      if (response.data['success'] != true) {
        throw Exception('Не удалось удалить корм');
      }
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось удалить корм');
    }
  }

  /// Get feeds statistics
  Future<FeedStatistics> getStatistics() async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.feeds}/statistics',
      );

      if (response.data['success'] == true) {
        return FeedStatistics.fromJson(response.data['data']);
      }

      throw Exception('Не удалось загрузить статистику склада');
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось загрузить статистику склада');
    }
  }

  /// Get low stock feeds
  Future<List<Feed>> getLowStockFeeds() async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.feeds}/low-stock',
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Feed.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось загрузить список заканчивающихся кормов');
    }
  }

  /// Adjust feed stock
  Future<Feed> adjustStock(int id, StockAdjustment adjustment) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.feeds}/$id/adjust-stock',
        data: adjustment.toJson(),
      );

      if (response.data['success'] == true) {
        return Feed.fromJson(response.data['data']);
      }

      throw Exception('Не удалось изменить остаток');
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось изменить остаток');
    }
  }
}
