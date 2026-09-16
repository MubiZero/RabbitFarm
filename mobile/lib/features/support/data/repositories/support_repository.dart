import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_failure.dart';
import '../../../../core/api/paginated.dart';
import '../../../../core/models/support_contact.dart';
import '../models/support_request.dart';

/// Одна страница собственных обращений фермы.
typedef SupportRequestsPage = ({List<SupportRequest> items, PageInfo page});

/// Обращения фермы в поддержку — отправка и своя переписка.
///
/// Доступно любой роли, включая ферму с закрытым доступом (`suspended`,
/// `read_only`) — эндпоинт не проверяет статус хозяйства (см.
/// `backend/src/middleware/auth.js`, `authenticateEvenIfFarmBlocked`).
class SupportRepository {
  final ApiClient _apiClient;

  SupportRepository(this._apiClient);

  Future<void> create(String text) async {
    try {
      await _apiClient.post(ApiEndpoints.supportRequests, data: {'text': text});
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Свои обращения, свежие сверху. Чужих ферма не видит — срез по хозяйству
  /// делает сервер.
  Future<SupportRequestsPage> list({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.supportRequests,
        queryParameters: {'page': page, 'limit': limit},
      );

      final data = response.data['data'];
      final items = [
        for (final item in itemsOf(data))
          SupportRequest.fromJson(item as Map<String, dynamic>),
      ];
      return (
        items: items,
        page: PageInfo.of(data, fallbackCount: items.length),
      );
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Официальный email/телефон поддержки, если платформенный админ их задал.
  /// Пустые поля — норма, не ошибка: контакт может быть не настроен.
  Future<SupportContact> getContact() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.supportContact);
      return SupportContact.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }
}
