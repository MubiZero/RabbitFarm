import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_failure.dart';

/// Регистрация и снятие FCM-токена этого устройства для push-уведомлений.
class DeviceTokensRepository {
  final ApiClient _apiClient;

  DeviceTokensRepository(this._apiClient);

  Future<void> register(String token, String platform) async {
    try {
      await _apiClient.post(
        ApiEndpoints.deviceTokens,
        data: {'token': token, 'platform': platform},
      );
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  Future<void> unregister(String token) async {
    try {
      await _apiClient.delete(
        ApiEndpoints.deviceTokens,
        data: {'token': token},
      );
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }
}
