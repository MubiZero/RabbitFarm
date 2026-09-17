import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_failure.dart';
import '../../../../core/api/paginated.dart';
import '../models/notification_model.dart';
import '../../../../shared/models/api_response.dart';

/// Лента уведомлений с сервера.
///
/// Существует потому, что пуш — канал ненадёжный по устройству: человек мог
/// отказать в разрешении, удалить приложение, потерять токен. Раньше это
/// значило, что о просроченных прививках и скором окроле он не узнает вовсе.
class NotificationsRepository {
  NotificationsRepository(this._api);

  final ApiClient _api;

  /// Страница ленты вместе со сведениями о следующей.
  ///
  /// Раньше метод отдавал только записи: лента показывала первые тридцать
  /// сообщений и дальше не листалась — всё, что старше, было не достать.
  Future<PaginatedResponse<AppNotification>> load({
    int page = 1,
    int limit = 30,
  }) async {
    try {
      final response = await _api.get(
        ApiEndpoints.notifications,
        queryParameters: {'page': page, 'limit': limit},
      );

      final items = [
        for (final item in itemsOf(response.data['data']))
          AppNotification.fromJson(item as Map<String, dynamic>),
      ];

      // Разбор страницы — общий (`core/api/paginated.dart`). Собранный
      // здесь вручную он молча врал: сервер называет поле `totalPages`, а
      // читали мы `total_pages`, и список всегда считал себя законченным на
      // первой странице.
      final info = PageInfo.of(response.data['data'], fallbackCount: items.length);

      return PaginatedResponse<AppNotification>(
        items: items,
        total: info.total,
        page: info.page,
        limit: info.limit,
        totalPages: info.totalPages,
      );
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  Future<int> unreadCount() async {
    try {
      final response = await _api.get(ApiEndpoints.notificationsUnreadCount);
      return (response.data['data']['count'] as num?)?.toInt() ?? 0;
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  Future<void> markAllRead() async {
    try {
      await _api.post(ApiEndpoints.notificationsRead);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }
}
