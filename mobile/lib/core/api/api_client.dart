import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_endpoints.dart';
import 'api_interceptors.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient({
    required FlutterSecureStorage storage,
    String? baseUrl,
  }) : _storage = storage {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(AuthInterceptor(storage: _storage));
    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
  }

  Dio get dio => _dio;

  // Auth endpoints
  Future<Response> login(String email, String password) {
    return _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register(Map<String, dynamic> data) {
    return _dio.post(ApiEndpoints.register, data: data);
  }

  Future<Response> logout() {
    return _dio.post(ApiEndpoints.logout);
  }

  Future<Response> getProfile() {
    return _dio.get(ApiEndpoints.profile);
  }

  Future<Response> updateProfile(Map<String, dynamic> data) {
    return _dio.put(ApiEndpoints.profile, data: data);
  }

  Future<Response> refreshToken(String refreshToken) {
    return _dio.post(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
    );
  }

  // Rabbits endpoints
  Future<Response> getRabbits({
    int page = 1,
    int limit = 10,
    String? search,
    String? sex,
    String? status,
    int? breedId,
  }) {
    return _dio.get(
      ApiEndpoints.rabbits,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (sex != null) 'sex': sex,
        if (status != null) 'status': status,
        if (breedId != null) 'breed_id': breedId,
      },
    );
  }

  Future<Response> getRabbitById(int id) {
    return _dio.get('${ApiEndpoints.rabbits}/$id');
  }

  Future<Response> createRabbit(Map<String, dynamic> data) {
    return _dio.post(ApiEndpoints.rabbits, data: data);
  }

  Future<Response> updateRabbit(int id, Map<String, dynamic> data) {
    return _dio.put('${ApiEndpoints.rabbits}/$id', data: data);
  }

  Future<Response> deleteRabbit(int id) {
    return _dio.delete('${ApiEndpoints.rabbits}/$id');
  }

  Future<Response> getRabbitStatistics() {
    return _dio.get(ApiEndpoints.rabbitStatistics);
  }

  Future<Response> addWeightRecord(int rabbitId, Map<String, dynamic> data) {
    return _dio.post('${ApiEndpoints.rabbits}/$rabbitId/weights', data: data);
  }

  Future<Response> getWeightHistory(int rabbitId) {
    return _dio.get('${ApiEndpoints.rabbits}/$rabbitId/weights');
  }

  Future<Response> uploadPhoto(int rabbitId, String filePath) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(filePath),
    });
    return _dio.post(
      '${ApiEndpoints.rabbits}/$rabbitId/photo',
      data: formData,
    );
  }

  // Breeds endpoints
  Future<Response> getBreeds() {
    return _dio.get(ApiEndpoints.breeds);
  }
}
