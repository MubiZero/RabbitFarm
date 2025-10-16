import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/api_response.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

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
        throw Exception(apiResponse.message);
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

      return authResponse;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка входа');
    }
  }

  // Register
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final response = await _apiClient.register({
        'email': email,
        'password': password,
        'full_name': fullName,
        if (phone != null) 'phone': phone,
      });

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
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

      return authResponse;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка регистрации');
    }
  }

  // Get current user profile
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.getProfile();

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      return UserModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Ошибка загрузки профиля');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiClient.logout();
    } catch (e) {
      // Ignore logout errors
    } finally {
      // Always clear tokens
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
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
