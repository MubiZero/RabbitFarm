import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/paginated.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/api_response.dart';
import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../models/birth_model.dart';
import '../models/rabbit_model.dart';
import '../../../../core/api/api_failure.dart';

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
        throw const ApiFailure(ApiFailureKind.server);
      }

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ApiFailure(ApiFailureKind.server,
            serverText: responseData['message'] as String?);
      }

      return itemsOf(responseData['data'])
          .map((item) => BirthModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
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
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      return BirthModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
    }
  }

  /// Получить окролы самки
  Future<List<BirthModel>> getBirthsByMother(int motherId) async {
    try {
      final response = await _apiClient.dio.get('/births', queryParameters: {'mother_id': motherId});

      // Проверяем структуру ответа
      if (response.data is! Map<String, dynamic>) {
        throw const ApiFailure(ApiFailureKind.server);
      }

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ApiFailure(ApiFailureKind.server,
            serverText: responseData['message'] as String?);
      }

      return itemsOf(responseData['data'])
          .map((item) => BirthModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
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
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      return BirthModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
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
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      return BirthModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
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
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
    }
  }

  /// Создать крольчат из окрола
  ///
  /// Автоматически создает карточки кроликов на основе данных окрола
  Future<List<RabbitModel>> createKitsFromBirth({
    required int birthId,
    required int motherId,
    required int? fatherId,
    // Порода необязательна: сервер берёт её у матери, если не передана.
    int? breedId,
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
          if (breedId != null) 'breed_id': breedId,
          'birth_date': birthDate,
          'count': count,
          if (namePrefix != null) 'name_prefix': namePrefix,
        },
      );

      // Проверяем структуру ответа
      if (response.data is! Map<String, dynamic>) {
        throw const ApiFailure(ApiFailureKind.server);
      }

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ApiFailure(ApiFailureKind.server,
            serverText: responseData['message'] as String?);
      }

      final data = responseData['data'];
      if (data == null || data is! List) {
        throw const ApiFailure(ApiFailureKind.server);
      }

      return data
          .map((item) => RabbitModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
    }
  }
}

/// Provider для репозитория окролов
final birthsRepositoryProvider = Provider<BirthsRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  final apiClient = ref.watch(apiClientProvider);
  return BirthsRepository(apiClient: apiClient);
});
