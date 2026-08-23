import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/api_response.dart';
import '../models/rabbit_model.dart';
import '../models/rabbit_statistics.dart';
import '../models/rabbit_weight_model.dart';
import '../../../../core/api/api_failure.dart';

class RabbitsRepository {
  final ApiClient _apiClient;

  RabbitsRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  // Get rabbits list with pagination and filters
  Future<PaginatedResponse<RabbitModel>> getRabbits({
    int page = 1,
    int limit = 10,
    String? search,
    String? sex,
    String? status,
    int? breedId,
  }) async {
    try {
      final response = await _apiClient.getRabbits(
        page: page,
        limit: limit,
        search: search,
        sex: sex,
        status: status,
        breedId: breedId,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      final paginatedData = apiResponse.data!;
      final items = (paginatedData['items'] as List)
          .map((item) => RabbitModel.fromJson(item as Map<String, dynamic>))
          .toList();

      // Read pagination nested object returned by backend
      final pagination = (paginatedData['pagination'] ?? const <String, dynamic>{})
          as Map<String, dynamic>;

      int toInt(dynamic v) {
        if (v is int) return v;
        if (v is double) return v.toInt();
        if (v is String) return int.tryParse(v) ?? 0;
        return 0;
      }

      final total = pagination.containsKey('total')
          ? toInt(pagination['total'])
          : toInt(paginatedData['total']);
      final currentPage = pagination.containsKey('page')
          ? toInt(pagination['page'])
          : toInt(paginatedData['page']);
      final currentLimit = pagination.containsKey('limit')
          ? toInt(pagination['limit'])
          : toInt(paginatedData['limit']);
      final totalPages = pagination.containsKey('totalPages')
          ? toInt(pagination['totalPages'])
          : toInt(paginatedData['total_pages']);

      return PaginatedResponse<RabbitModel>(
        items: items,
        total: total,
        page: currentPage,
        limit: currentLimit,
        totalPages: totalPages,
      );
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  // Get rabbit by ID
  Future<RabbitModel> getRabbitById(int id) async {
    try {
      final response = await _apiClient.getRabbitById(id);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      return RabbitModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  // Create rabbit
  Future<RabbitModel> createRabbit(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.createRabbit(data);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      return RabbitModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  // Update rabbit
  Future<RabbitModel> updateRabbit(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.updateRabbit(id, data);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      return RabbitModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  // Delete rabbit
  Future<void> deleteRabbit(int id) async {
    try {
      await _apiClient.deleteRabbit(id);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  // Get statistics
  Future<RabbitStatistics> getStatistics() async {
    try {
      final response = await _apiClient.getRabbitStatistics();

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      return RabbitStatistics.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  // Get weight history
  Future<List<RabbitWeight>> getWeightHistory(int rabbitId) async {
    try {
      final response = await _apiClient.getWeightHistory(rabbitId);

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      return apiResponse.data!
          .map((item) => RabbitWeight.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  // Add weight record
  Future<RabbitWeight> addWeightRecord(int rabbitId, AddWeightRequest request) async {
    try {
      final response = await _apiClient.addWeightRecord(rabbitId, request.toJson());

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      return RabbitWeight.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  // Upload photo
  Future<RabbitModel> uploadPhoto(int rabbitId, String filePath, {Uint8List? bytes}) async {
    try {
      final response = await _apiClient.uploadPhoto(rabbitId, filePath, bytes: bytes);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      return RabbitModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  // Delete photo
  Future<RabbitModel> deletePhoto(int rabbitId) async {
    try {
      final response = await _apiClient.deletePhoto(rabbitId);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      return RabbitModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }
}
