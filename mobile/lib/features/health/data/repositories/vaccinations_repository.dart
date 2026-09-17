import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../../../../shared/models/api_response.dart';
import '../models/vaccination_model.dart';
import '../../../../core/api/api_failure.dart';

/// Репозиторий для работы с вакцинациями
class VaccinationsRepository {
  final ApiClient _apiClient;

  VaccinationsRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  /// Получить список вакцинаций с фильтрацией и пагинацией
  /// Страница прививок вместе со сведениями о том, есть ли следующая.
  ///
  /// Раньше метод возвращал только записи, а `pagination` из ответа
  /// выбрасывал — список молча обрывался на пятидесятой записи, и узнать об
  /// этом было неоткуда: ни счётчика, ни «показать ещё». На ферме, где
  /// прививки идут третий год, половина истории просто не показывалась.
  Future<PaginatedResponse<Vaccination>> getVaccinations({
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
        throw ApiFailure(ApiFailureKind.server,
            serverText: apiResponse.message);
      }

      final data = apiResponse.data!;
      final itemsJson = data['items'];
      if (itemsJson is! List) {
        throw const ApiFailure(ApiFailureKind.server);
      }

      final items = itemsJson
          .map((item) => Vaccination.fromJson(item as Map<String, dynamic>))
          .toList();

      // Сервер отдаёт страницы всегда; если поля не пришли, считаем, что
      // список кончился, — иначе экран звал бы следующую страницу без конца.
      final pagination = data['pagination'] as Map<String, dynamic>?;
      return PaginatedResponse<Vaccination>(
        items: items,
        total: (pagination?['total'] as num?)?.toInt() ?? items.length,
        page: (pagination?['page'] as num?)?.toInt() ?? page,
        limit: (pagination?['limit'] as num?)?.toInt() ?? limit,
        totalPages: (pagination?['total_pages'] as num?)?.toInt() ?? 1,
      );
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
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
        throw ApiFailure(ApiFailureKind.server,
            serverText: apiResponse.message);
      }

      return Vaccination.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
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
        throw ApiFailure(ApiFailureKind.server,
            serverText: apiResponse.message);
      }

      return apiResponse.data!
          .map((item) => Vaccination.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
    }
  }

  /// Создать новую запись о вакцинации
  Future<Vaccination> createVaccination(VaccinationRequest request) =>
      createVaccinationFromJson(request.toJson());

  /// То же, но из готового тела запроса.
  ///
  /// Нужно отложенной очереди: она хранит запись на диске уже
  /// сериализованной и собирать из неё обратно типизированный объект
  /// незачем — тип вакцины пришлось бы разбирать вторым парсером, который
  /// разойдётся с первым при первой же правке перечисления.
  Future<Vaccination> createVaccinationFromJson(
      Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post(
        '/vaccinations',
        data: data,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server,
            serverText: apiResponse.message);
      }

      return Vaccination.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
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
        throw ApiFailure(ApiFailureKind.server,
            serverText: apiResponse.message);
      }

      return Vaccination.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
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
        throw ApiFailure(ApiFailureKind.server,
            serverText: apiResponse.message);
      }
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
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
        throw ApiFailure(ApiFailureKind.server,
            serverText: apiResponse.message);
      }

      return VaccinationStatistics.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
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
        throw ApiFailure(ApiFailureKind.server,
            serverText: apiResponse.message);
      }

      return apiResponse.data!
          .map((item) => Vaccination.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw const ApiFailure(ApiFailureKind.server);
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
        throw ApiFailure(ApiFailureKind.server,
            serverText: apiResponse.message);
      }

      return apiResponse.data!
          .map((item) => Vaccination.fromJson(item as Map<String, dynamic>))
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

/// Provider для репозитория вакцинаций
final vaccinationsRepositoryProvider = Provider<VaccinationsRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  final apiClient = ref.watch(apiClientProvider);
  return VaccinationsRepository(apiClient: apiClient);
});
