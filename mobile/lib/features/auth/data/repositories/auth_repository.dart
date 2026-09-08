import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../shared/models/api_response.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';
import '../../../../core/api/api_failure.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  AuthRepository({
    required ApiClient apiClient,
    required FlutterSecureStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  // Login
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.login(email, password);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      final authResponse = AuthResponse.fromJson(apiResponse.data!);

      // Save tokens to secure storage
      await _storage.write(
        key: 'access_token',
        value: authResponse.accessToken,
      );
      await _storage.write(
        key: 'refresh_token',
        value: authResponse.refreshToken,
      );
      await _cacheProfile(authResponse.user.toJson());

      return authResponse;
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  // Register
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String fullName,
    String? farmName,
    String? phone,
  }) async {
    try {
      final response = await _apiClient.register({
        'email': email,
        'password': password,
        'full_name': fullName,
        if (farmName != null) 'farm_name': farmName,
        if (phone != null) 'phone': phone,
      });

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      final authResponse = AuthResponse.fromJson(apiResponse.data!);

      // Save tokens to secure storage
      await _storage.write(
        key: 'access_token',
        value: authResponse.accessToken,
      );
      await _storage.write(
        key: 'refresh_token',
        value: authResponse.refreshToken,
      );
      await _cacheProfile(authResponse.user.toJson());

      return authResponse;
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Присоединиться к ферме по коду приглашения.
  /// Токены сохраняются так же, как при регистрации: человек сразу внутри.
  Future<AuthResponse> acceptInvitation({
    required String code,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _apiClient.post('/auth/accept-invitation', data: {
        'code': code,
        'password': password,
        'full_name': fullName,
      });

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
      }

      final authResponse = AuthResponse.fromJson(apiResponse.data!);

      await _storage.write(
        key: 'access_token',
        value: authResponse.accessToken,
      );
      await _storage.write(
        key: 'refresh_token',
        value: authResponse.refreshToken,
      );
      await _cacheProfile(authResponse.user.toJson());

      return authResponse;
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Запросить код сброса пароля — сервер сам решает, слать SMS или email,
  /// и ничего не сообщает о том, существует ли аккаунт (ответ всегда success).
  Future<void> forgotPassword({required String email}) async {
    try {
      await _apiClient.post(ApiEndpoints.forgotPassword, data: {'email': email});
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Сменить пароль по коду, присланному [forgotPassword]. Сессии нет —
  /// токены не сохраняются, дальше — обычный вход по новому паролю.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post(ApiEndpoints.resetPassword, data: {
        'email': email,
        'code': code,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  // Get current user profile
  Future<UserModel> getProfile() async {
    // DioException пробрасывается напрямую для корректной обработки в AuthNotifier
    final response = await _apiClient.getProfile();

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw ApiFailure(ApiFailureKind.server, serverText: apiResponse.message);
    }

    final user = UserModel.fromJson(apiResponse.data!);
    await _cacheProfile(apiResponse.data!);
    return user;
  }

  /// Профиль хранится рядом с токенами, чтобы приложение знало роль человека
  /// и без сети.
  ///
  /// Без него роль вычислялась из пустоты, а неизвестное значение трактуется
  /// как самая узкая роль: владелец, открывший приложение в сарае без связи,
  /// получал интерфейс работника — без стада, разведения и хозяйства.
  /// «Роль неизвестна» и «роль — работник» это разные вещи.
  static const _profileKey = 'profile';

  Future<void> _cacheProfile(Map<String, dynamic> json) async {
    await _storage.write(key: _profileKey, value: jsonEncode(json));
  }

  /// Последний известный профиль. Возвращает null, если его нет или он
  /// испорчен — гадать по обломкам хуже, чем честно не знать.
  Future<UserModel?> cachedProfile() async {
    final raw = await _storage.read(key: _profileKey);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      await clearCachedProfile();
      return null;
    }
  }

  Future<void> clearCachedProfile() => _storage.delete(key: _profileKey);

  // Logout
  Future<void> logout() async {
    try {
      // Сервер гасит именно тот refresh-токен, который ему передали. Раньше
      // запрос уходил с пустым телом, возвращал 422, ошибка глушилась — и
      // серверная сессия жила ещё семь дней после «Выйти».
      final refreshToken = await _storage.read(key: 'refresh_token');
      await _apiClient.logout(refreshToken: refreshToken);
    } on ApiFailure {
      rethrow;
    } catch (e) {
      // Ignore logout errors
    } finally {
      // Always clear tokens
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      // На общем планшете фермы профиль предыдущего работника не должен
      // пережить выход — как и его токены.
      await clearCachedProfile();
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }

  // Get stored access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // Get stored refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }
}
