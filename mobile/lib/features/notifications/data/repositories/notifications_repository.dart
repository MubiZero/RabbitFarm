import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_failure.dart';
import '../../../../core/api/paginated.dart';
import '../models/notification_model.dart';

/// Лента уведомлений с сервера.
///
/// Существует потому, что пуш — канал ненадёжный по устройству: человек мог
/// отказать в разрешении, удалить приложение, потерять токен. Раньше это
/// значило, что о просроченных прививках и скором окроле он не узнает вовсе.
class NotificationsRepository {
  NotificationsRepository(this._api);

  final ApiClient _api;

  Future<List<AppNotification>> load({int page = 1, int limit = 30}) async {
    try {
      final response = await _api.get(
        ApiEndpoints.notifications,
        queryParameters: {'page': page, 'limit': limit},
      );
      return [
        for (final item in itemsOf(response.data['data']))
          AppNotification.fromJson(item as Map<String, dynamic>),
      ];
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
