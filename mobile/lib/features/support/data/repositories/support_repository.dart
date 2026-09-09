import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_failure.dart';

/// Обращение фермы в поддержку.
///
/// Доступно любой роли, включая ферму с закрытым доступом (`suspended`,
/// `read_only`) — эндпоинт не проверяет статус хозяйства (см.
/// `backend/src/middleware/auth.js`, `authenticateEvenIfFarmBlocked`).
/// Своей истории обращений у фермы нет: отвечает поддержка тем же способом,
/// каким связывалась бы и раньше, — читать список видит только платформенный
/// админ (см. `PlatformAdminRepository.getSupportRequests`).
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
}
