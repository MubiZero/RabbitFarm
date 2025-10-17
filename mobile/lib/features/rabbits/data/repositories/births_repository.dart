import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/api_response.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../models/birth_model.dart';
import '../models/rabbit_model.dart';

/// Репозиторий для работы с окролами
class BirthsRepository {
  final ApiClient _apiClient;

  BirthsRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Получить список всех окролов
  Future<List<BirthModel>> getBirths() async {
    try {
      final response = await _apiClient.dio.get('/births');

      // Проверяем структуру ответа
      if (response.data is! Map<String, dynamic>) {
        throw Exception('Неверный формат ответа сервера');
      }

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw Exception(responseData['message'] ?? 'Ошибка получения окролов');
      }

      final data = responseData['data'];
      if (data == null || data is! List) {
        throw Exception('Данные окролов отсутствуют или имеют неверный формат');
      }

      return (data as List)
          .map((item) => BirthModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения списка окролов');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Получить окрол по ID
  Future<BirthModel> getBirthById(int id) async {
    try {
      final response = await _apiClient.dio.get('/births/$id');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return BirthModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения окрола');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Получить окролы самки
  Future<List<BirthModel>> getBirthsByMother(int motherId) async {
    try {
      final response = await _apiClient.dio.get('/rabbits/$motherId/births');

      // Проверяем структуру ответа
      if (response.data is! Map<String, dynamic>) {
        throw Exception('Неверный формат ответа сервера');
      }

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw Exception(responseData['message'] ?? 'Ошибка получения окролов');
      }

      final data = responseData['data'];
      if (data == null || data is! List) {
        throw Exception('Данные окролов отсутствуют или имеют неверный формат');
      }

      return (data as List)
          .map((item) => BirthModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения окролов самки');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Создать новый окрол
  Future<BirthModel> createBirth(Map<String, dynamic> birthData) async {
    try {
      final response = await _apiClient.dio.post(
        '/births',
        data: birthData,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return BirthModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка создания окрола');
    } catch (e) {
      throw Exception('Ошибка создания окрола: $e');
    }
  }

  /// Обновить окрол
  Future<BirthModel> updateBirth(int id, Map<String, dynamic> birthData) async {
    try {
      final response = await _apiClient.dio.put(
        '/births/$id',
        data: birthData,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return BirthModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка обновления окрола');
    } catch (e) {
      throw Exception('Ошибка обновления окрола: $e');
    }
  }

  /// Удалить окрол
  Future<void> deleteBirth(int id) async {
    try {
      final response = await _apiClient.dio.delete('/births/$id');

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка удаления окрола');
    } catch (e) {
      throw Exception('Ошибка удаления окрола: $e');
    }
  }

  /// Создать крольчат из окрола
  ///
  /// Автоматически создает карточки кроликов на основе данных окрола
  Future<List<RabbitModel>> createKitsFromBirth({
    required int birthId,
    required int motherId,
    required int? fatherId,
    required int breedId,
    required String birthDate,
    required int count,
    String? namePrefix,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/births/$birthId/create-kits',
        data: {
          'mother_id': motherId,
          if (fatherId != null) 'father_id': fatherId,
          'breed_id': breedId,
          'birth_date': birthDate,
          'count': count,
          if (namePrefix != null) 'name_prefix': namePrefix,
        },
      );

      // Проверяем структуру ответа
      if (response.data is! Map<String, dynamic>) {
        throw Exception('Неверный формат ответа сервера');
      }

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw Exception(responseData['message'] ?? 'Ошибка создания крольчат');
      }

      final data = responseData['data'];
      if (data == null || data is! List) {
        throw Exception('Данные крольчат отсутствуют или имеют неверный формат');
      }

      return (data as List)
          .map((item) => RabbitModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Ошибка создания крольчат',
      );
    } catch (e) {
      throw Exception('Ошибка создания крольчат: $e');
    }
  }
}

/// Provider для репозитория окролов
final birthsRepositoryProvider = Provider<BirthsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BirthsRepository(apiClient: apiClient);
});
