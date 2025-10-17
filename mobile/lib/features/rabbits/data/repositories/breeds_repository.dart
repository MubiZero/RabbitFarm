import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/api_response.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../models/breed_model.dart';

/// Репозиторий для работы с породами кроликов
class BreedsRepository {
  final ApiClient _apiClient;

  BreedsRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Получить список всех пород
  Future<List<BreedModel>> getBreeds() async {
    try {
      final response = await _apiClient.dio.get('/breeds');

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return apiResponse.data!
          .map((item) => BreedModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения списка пород');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Получить породу по ID
  Future<BreedModel> getBreedById(int id) async {
    try {
      final response = await _apiClient.dio.get('/breeds/$id');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return BreedModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения породы');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Создать новую породу
  Future<BreedModel> createBreed(Map<String, dynamic> breedData) async {
    try {
      final response = await _apiClient.dio.post(
        '/breeds',
        data: breedData,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return BreedModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка создания породы');
    } catch (e) {
      throw Exception('Ошибка создания породы: $e');
    }
  }

  /// Обновить породу
  Future<BreedModel> updateBreed(int id, Map<String, dynamic> breedData) async {
    try {
      final response = await _apiClient.dio.put(
        '/breeds/$id',
        data: breedData,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return BreedModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка обновления породы');
    } catch (e) {
      throw Exception('Ошибка обновления породы: $e');
    }
  }

  /// Удалить породу
  Future<void> deleteBreed(int id) async {
    try {
      final response = await _apiClient.dio.delete('/breeds/$id');

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка удаления породы');
    } catch (e) {
      throw Exception('Ошибка удаления породы: $e');
    }
  }
}

/// Provider для репозитория пород
final breedsRepositoryProvider = Provider<BreedsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BreedsRepository(apiClient: apiClient);
});
