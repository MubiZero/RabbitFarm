import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_failure.dart';
import '../../../../core/api/paginated.dart';
import '../models/platform_admin_models.dart';

/// Одна страница списка ферм: сами фермы и сведения о том, есть ли ещё.
typedef FarmsPage = ({List<PlatformFarm> items, PageInfo page});

/// Тарифы и фермы всего сервиса — то, чем распоряжается платформенный админ.
///
/// Единственный репозиторий приложения, который работает не внутри одной
/// фермы: остальные видят только своё хозяйство, этот — весь сервис. Сервер
/// пускает сюда по флагу суперадмина, поэтому обычному пользователю все эти
/// вызовы вернут отказ.
class PlatformAdminRepository {
  final ApiClient _apiClient;

  PlatformAdminRepository(this._apiClient);

  /// Все тарифы, включая выключенные: админ должен видеть и их, чтобы
  /// включить обратно.
  Future<List<Plan>> getPlans() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.platformPlans);
      return [
        for (final item in itemsOf(response.data['data']))
          Plan.fromJson(item as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  Future<Plan> createPlan(PlanDraft draft) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.platformPlans,
        data: draft.toJson(),
      );
      return Plan.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  Future<Plan> updatePlan(int id, PlanDraft draft) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.platformPlan(id),
        data: draft.toJson(),
      );
      return Plan.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Удалить тариф. Фермы на нём не блокируются — они становятся
  /// безлимитными, так решено на сервере.
  Future<void> deletePlan(int id) async {
    try {
      await _apiClient.delete(ApiEndpoints.platformPlan(id));
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  Future<FarmsPage> getFarms({
    int page = 1,
    int limit = 20,
    String? search,
    String? filter,
    String? sort,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.platformFarms,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null && search.isNotEmpty) 'search': search,
          if (filter != null) 'filter': filter,
          if (sort != null) 'sort': sort,
        },
      );

      final data = response.data['data'];
      final items = [
        for (final item in itemsOf(data))
          PlatformFarm.fromJson(item as Map<String, dynamic>),
      ];
      return (items: items, page: PageInfo.of(data, fallbackCount: items.length));
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Назначить ферме тариф или снять его (`planId: null` — без ограничений).
  Future<PlatformFarm> assignPlan(int farmId, int? planId) async {
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.platformFarmPlan(farmId),
        data: {'plan_id': planId},
      );
      return PlatformFarm.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }
}
