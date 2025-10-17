import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/api_response.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../models/cage_model.dart';

/// Репозиторий для работы с клетками
class CagesRepository {
  final ApiClient _apiClient;

  CagesRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Получить список клеток с фильтрацией и пагинацией
  Future<List<CageModel>> getCages({
    int page = 1,
    int limit = 50,
    String? type,
    String? condition,
    String? location,
    String? search,
    bool? onlyAvailable,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (type != null) 'type': type,
        if (condition != null) 'condition': condition,
        if (location != null) 'location': location,
        if (search != null) 'search': search,
        if (onlyAvailable != null) 'only_available': onlyAvailable.toString(),
      };

      final response = await _apiClient.dio.get(
        '/cages',
        queryParameters: queryParams,
      );

      // Backend возвращает { success, data: { items: [], pagination: {...} }, ... }
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      final data = apiResponse.data!;
      final itemsJson = data['items'];
      if (itemsJson is! List) {
        throw Exception('Некорректный формат ответа: items не является списком');
      }

      return itemsJson
          .map((item) => CageModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения списка клеток');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Получить клетку по ID
  Future<CageModel> getCageById(int id) async {
    try {
      final response = await _apiClient.dio.get('/cages/$id');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return CageModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения клетки');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Создать новую клетку
  Future<CageModel> createCage(Map<String, dynamic> cageData) async {
    try {
      final response = await _apiClient.dio.post(
        '/cages',
        data: cageData,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return CageModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка создания клетки');
    } catch (e) {
      throw Exception('Ошибка создания клетки: $e');
    }
  }

  /// Обновить клетку
  Future<CageModel> updateCage(int id, Map<String, dynamic> cageData) async {
    try {
      final response = await _apiClient.dio.put(
        '/cages/$id',
        data: cageData,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return CageModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка обновления клетки');
    } catch (e) {
      throw Exception('Ошибка обновления клетки: $e');
    }
  }

  /// Удалить клетку
  Future<void> deleteCage(int id) async {
    try {
      final response = await _apiClient.dio.delete('/cages/$id');

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка удаления клетки');
    } catch (e) {
      throw Exception('Ошибка удаления клетки: $e');
    }
  }

  /// Получить статистику клеток
  Future<CageStatistics> getStatistics() async {
    try {
      final response = await _apiClient.dio.get('/cages/statistics');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return CageStatistics.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения статистики');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Получить схему размещения клеток (группировка по локации)
  Future<Map<String, List<CageModel>>> getLayout() async {
    try {
      final response = await _apiClient.dio.get('/cages/layout');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      final Map<String, List<CageModel>> layout = {};

      apiResponse.data!.forEach((location, cagesJson) {
        if (cagesJson is List) {
          layout[location] = cagesJson
              .map((item) => CageModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      });

      return layout;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения схемы размещения');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Отметить клетку как убранную
  Future<CageModel> markCleaned(int id) async {
    try {
      final response = await _apiClient.dio.patch('/cages/$id/clean');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return CageModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка отметки об уборке');
    } catch (e) {
      throw Exception('Ошибка отметки об уборке: $e');
    }
  }
}

/// Provider для репозитория клеток
final cagesRepositoryProvider = Provider<CagesRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CagesRepository(apiClient: apiClient);
});
