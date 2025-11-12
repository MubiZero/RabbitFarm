import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/providers/api_providers.dart';
import '../../../../shared/models/api_response.dart';
import '../models/vaccination_model.dart';

/// Репозиторий для работы с вакцинациями
class VaccinationsRepository {
  final ApiClient _apiClient;

  VaccinationsRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  /// Получить список вакцинаций с фильтрацией и пагинацией
  Future<List<Vaccination>> getVaccinations({
    int page = 1,
    int limit = 50,
    int? rabbitId,
    VaccineType? vaccineType,
    DateTime? fromDate,
    DateTime? toDate,
    bool? upcoming,
    String sortBy = 'vaccination_date',
    String sortOrder = 'DESC',
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'sort_by': sortBy,
        'sort_order': sortOrder,
        if (rabbitId != null) 'rabbit_id': rabbitId.toString(),
        if (vaccineType != null) 'vaccine_type': vaccineType.name,
        if (fromDate != null)
          'from_date': fromDate.toIso8601String().split('T')[0],
        if (toDate != null) 'to_date': toDate.toIso8601String().split('T')[0],
        if (upcoming != null) 'upcoming': upcoming.toString(),
      };

      final response = await _apiClient.dio.get(
        '/vaccinations',
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
        throw Exception(
            'Некорректный формат ответа: items не является списком');
      }

      return itemsJson
          .map((item) => Vaccination.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения списка вакцинаций');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Получить вакцинацию по ID
  Future<Vaccination> getVaccinationById(int id) async {
    try {
      final response = await _apiClient.dio.get('/vaccinations/$id');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return Vaccination.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения вакцинации');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Получить историю вакцинаций для конкретного кролика
  Future<List<Vaccination>> getRabbitVaccinations(int rabbitId) async {
    try {
      final response =
          await _apiClient.dio.get('/rabbits/$rabbitId/vaccinations');

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return apiResponse.data!
          .map((item) => Vaccination.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения истории вакцинаций');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Создать новую запись о вакцинации
  Future<Vaccination> createVaccination(VaccinationRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/vaccinations',
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return Vaccination.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Ошибка создания записи о вакцинации');
    } catch (e) {
      throw Exception('Ошибка создания записи о вакцинации: $e');
    }
  }

  /// Обновить запись о вакцинации
  Future<Vaccination> updateVaccination(
      int id, VaccinationRequest request) async {
    try {
      final response = await _apiClient.dio.put(
        '/vaccinations/$id',
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return Vaccination.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          'Ошибка обновления записи о вакцинации');
    } catch (e) {
      throw Exception('Ошибка обновления записи о вакцинации: $e');
    }
  }

  /// Удалить запись о вакцинации
  Future<void> deleteVaccination(int id) async {
    try {
      final response = await _apiClient.dio.delete('/vaccinations/$id');

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          'Ошибка удаления записи о вакцинации');
    } catch (e) {
      throw Exception('Ошибка удаления записи о вакцинации: $e');
    }
  }

  /// Получить статистику вакцинаций
  Future<VaccinationStatistics> getStatistics() async {
    try {
      final response = await _apiClient.dio.get('/vaccinations/statistics');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return VaccinationStatistics.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения статистики');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Получить предстоящие вакцинации
  Future<List<Vaccination>> getUpcomingVaccinations({int days = 30}) async {
    try {
      final response = await _apiClient.dio.get(
        '/vaccinations/upcoming',
        queryParameters: {'days': days.toString()},
      );

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return apiResponse.data!
          .map((item) => Vaccination.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения предстоящих вакцинаций');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }

  /// Получить просроченные вакцинации
  Future<List<Vaccination>> getOverdueVaccinations() async {
    try {
      final response = await _apiClient.dio.get('/vaccinations/overdue');

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return apiResponse.data!
          .map((item) => Vaccination.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка получения просроченных вакцинаций');
    } catch (e) {
      throw Exception('Ошибка десериализации: $e');
    }
  }
}

/// Provider для репозитория вакцинаций
final vaccinationsRepositoryProvider = Provider<VaccinationsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VaccinationsRepository(apiClient: apiClient);
});
