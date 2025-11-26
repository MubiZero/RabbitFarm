import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/api_response.dart';
import '../../../rabbits/data/models/breeding_model.dart';

class BreedingRepository {
  final ApiClient _apiClient;

  BreedingRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<PaginatedResponse<BreedingModel>> getBreedings({
    int page = 1,
    int limit = 20,
    String? status,
    int? maleId,
    int? femaleId,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final response = await _apiClient.getBreedings(
        page: page,
        limit: limit,
        status: status,
        maleId: maleId,
        femaleId: femaleId,
        fromDate: fromDate,
        toDate: toDate,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      final paginatedData = apiResponse.data!;
      final items = (paginatedData['items'] as List)
          .map((item) => BreedingModel.fromJson(item as Map<String, dynamic>))
          .toList();

      final pagination = (paginatedData['pagination'] ?? const <String, dynamic>{})
          as Map<String, dynamic>;

      int _toInt(dynamic v) {
        if (v is int) return v;
        if (v is double) return v.toInt();
        if (v is String) return int.tryParse(v) ?? 0;
        return 0;
      }

      final total = pagination.containsKey('total')
          ? _toInt(pagination['total'])
          : _toInt(paginatedData['total']);
      final currentPage = pagination.containsKey('page')
          ? _toInt(pagination['page'])
          : _toInt(paginatedData['page']);
      final currentLimit = pagination.containsKey('limit')
          ? _toInt(pagination['limit'])
          : _toInt(paginatedData['limit']);
      final totalPages = pagination.containsKey('totalPages')
          ? _toInt(pagination['totalPages'])
          : _toInt(paginatedData['total_pages']);

      return PaginatedResponse<BreedingModel>(
        items: items,
        total: total,
        page: currentPage,
        limit: currentLimit,
        totalPages: totalPages,
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка загрузки списка случек');
    }
  }

  Future<BreedingModel> getBreedingById(int id) async {
    try {
      final response = await _apiClient.getBreedingById(id);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return BreedingModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка загрузки данных случки');
    }
  }

  Future<BreedingModel> createBreeding(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.createBreeding(data);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return BreedingModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка создания записи о случке');
    }
  }

  Future<BreedingModel> updateBreeding(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.updateBreeding(id, data);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return BreedingModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка обновления записи о случке');
    }
  }

  Future<void> deleteBreeding(int id) async {
    try {
      await _apiClient.deleteBreeding(id);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка удаления записи о случке');
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await _apiClient.getBreedingStatistics();

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка загрузки статистики');
    }
  }
}
