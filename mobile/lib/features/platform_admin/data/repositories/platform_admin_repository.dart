import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_failure.dart';
import '../../../../core/api/paginated.dart';
import '../../../../core/json/date_time_converter.dart';
import '../models/platform_admin_models.dart';

/// Одна страница списка ферм: сами фермы и сведения о том, есть ли ещё.
typedef FarmsPage = ({List<PlatformFarm> items, PageInfo page});

/// То же для истории объявлений.
typedef AnnouncementsPage = ({List<Announcement> items, PageInfo page});

/// То же для обращений в поддержку.
typedef SupportRequestsPage = ({List<SupportRequest> items, PageInfo page});

/// Тарифы и фермы всего сервиса — то, чем распоряжается платформенный админ.
///
/// Единственный репозиторий приложения, который работает не внутри одной
/// фермы: остальные видят только своё хозяйство, этот — весь сервис. Сервер
/// пускает сюда по флагу суперадмина, поэтому обычному пользователю все эти
/// вызовы вернут отказ.
class PlatformAdminRepository {
  final ApiClient _apiClient;

  PlatformAdminRepository(this._apiClient);

  /// Сводка платформы целиком (см. docs/plans/PLATFORM-ADMIN.md, этап 5) —
  /// фермы по категориям, регистрации, поголовье, место в MinIO.
  Future<PlatformSummary> getSummary() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.platformSummary);
      return PlatformSummary.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

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

  /// Одна ферма целиком: владелец, состав, платежи, поблажки, место.
  Future<PlatformFarmDetail> getFarmDetail(int farmId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.platformFarm(farmId));
      return PlatformFarmDetail.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Уровень доступа фермы: `active`, `read_only` или `suspended`.
  ///
  /// Ответ — ферма целиком, той же формы, что у [getFarmDetail]: карточка
  /// обновляется из ответа, а не перезапрашивает всё заново.
  Future<PlatformFarmDetail> updateFarmStatus(int farmId, String status) async {
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.platformFarmStatus(farmId),
        data: {'status': status},
      );
      return PlatformFarmDetail.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Разовая поблажка сверх тарифа. Сам тариф при этом не меняется.
  ///
  /// Все три поля уходят всегда, включая пустые: форма поблажки показывает её
  /// целиком, поэтому пустое поле — это «добавки нет», а не «не менять».
  /// Отдельного «снять поблажку» на уровне запроса не нужно — это та же
  /// тройка пустых значений, и различать «не трогать» от «обнулить»
  /// значениями-метками не приходится.
  Future<PlatformFarmDetail> updateFarmExtras(
    int farmId, {
    int? extraRabbits,
    int? extraStaff,
    DateTime? extrasUntil,
  }) async {
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.platformFarmExtras(farmId),
        data: {
          'extra_rabbits': extraRabbits,
          'extra_staff': extraStaff,
          // Календарная дата без времени: срок поблажки — это день, и сдвиг
          // на часовой пояс превратил бы «до 15-го» в «до 14-го».
          'extras_until': const NullableDateOnlyConverter().toJson(extrasUntil),
        },
      );
      return PlatformFarmDetail.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Продлить платный тариф вручную (см. docs/plans/PLATFORM-ADMIN.md, 4.1) —
  /// например, клиент оплатил наличными, мимо `Payment`. Календарная дата,
  /// как и `extras_until`: срок — это день, а не момент времени.
  Future<PlatformFarmDetail> updateFarmPlanExpiry(
    int farmId,
    DateTime planExpiresAt,
  ) async {
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.platformFarmPlanExpiry(farmId),
        data: {
          'plan_expires_at': const DateOnlyConverter().toJson(planExpiresAt),
        },
      );
      return PlatformFarmDetail.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Токен входа под клиентом, только чтение (см.
  /// docs/plans/PLATFORM-ADMIN.md, 3.2). `reason` обязателен — это
  /// единственное, что отличает в журнале осмысленный вход от «зашёл
  /// посмотреть от скуки».
  Future<({String accessToken, String farmName})> impersonateFarm(
    int farmId,
    String reason,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.platformFarmImpersonate(farmId),
        data: {'reason': reason},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return (
        accessToken: data['access_token'] as String,
        farmName: (data['farm'] as Map<String, dynamic>)['name'] as String,
      );
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Все записи фермы одним JSON — для просьбы «отдайте мои данные».
  ///
  /// Содержимое сознательно не типизируется: это снимок восемнадцати таблиц,
  /// который никто не разбирает по полям — его показывают целиком и копируют.
  /// Восемнадцать моделей ради этого жили бы отдельной жизнью и расходились с
  /// сервером при первом же добавленном поле.
  Future<Map<String, dynamic>> exportFarm(int farmId) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.platformFarmExport(farmId));
      return Map<String, dynamic>.from(response.data['data'] as Map);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Мягкое удаление: доступ фермы закрывается сразу, записи физически уходят
  /// позже. Название подтверждения проверяет сервер — не клиент: отказ
  /// `CONFIRM_NAME_MISMATCH` приезжает как обычная ошибка формы.
  ///
  /// Ответ — ферма той же формы, что у [getFarmDetail], уже с `deleted_at`.
  Future<PlatformFarmDetail> deleteFarm(int farmId, String confirmName) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.platformFarm(farmId),
        data: {'confirm_name': confirmName},
      );
      return PlatformFarmDetail.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Отменить удаление, пока окно ожидания не вышло.
  Future<PlatformFarmDetail> restoreFarm(int farmId) async {
    try {
      final response =
          await _apiClient.post(ApiEndpoints.platformFarmRestore(farmId));
      return PlatformFarmDetail.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// История объявлений, свежие сверху.
  Future<AnnouncementsPage> getAnnouncements({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.platformAnnouncements,
        queryParameters: {'page': page, 'limit': limit},
      );

      final data = response.data['data'];
      final items = [
        for (final item in itemsOf(data))
          Announcement.fromJson(item as Map<String, dynamic>),
      ];
      return (items: items, page: PageInfo.of(data, fallbackCount: items.length));
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Отправить объявление. Отправка синхронная: ответ приходит уже со
  /// статистикой доставки, поэтому опрашивать сервер о результате не нужно.
  ///
  /// Действие необратимо и уходит наружу — подтверждение обязано случиться до
  /// вызова, здесь его уже не спросить.
  Future<Announcement> createAnnouncement(AnnouncementDraft draft) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.platformAnnouncements,
        data: draft.toJson(),
      );
      return Announcement.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Обращения ферм в поддержку — необработанные сверху (сервер сортирует по
  /// статусу, см. `supportRequestService.list`).
  Future<SupportRequestsPage> getSupportRequests({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.platformSupportRequests,
        queryParameters: {'page': page, 'limit': limit},
      );

      final data = response.data['data'];
      final items = [
        for (final item in itemsOf(data))
          SupportRequest.fromJson(item as Map<String, dynamic>),
      ];
      return (items: items, page: PageInfo.of(data, fallbackCount: items.length));
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Отметить обращение разобранным. Повторный вызов не ошибка — сервер
  /// просто возвращает то же обращение (см. `supportRequestService.resolve`).
  Future<SupportRequest> resolveSupportRequest(int id) async {
    try {
      final response =
          await _apiClient.patch(ApiEndpoints.platformSupportRequestResolve(id));
      return SupportRequest.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }
}
