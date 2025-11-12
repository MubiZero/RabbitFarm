import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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

  // Generic HTTP methods
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }

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

  // Vaccinations endpoints
  Future<Response> getVaccinations({
    int page = 1,
    int limit = 50,
    int? rabbitId,
    String? vaccineType,
    String? fromDate,
    String? toDate,
    bool upcoming = false,
    String sortBy = 'vaccination_date',
    String sortOrder = 'DESC',
  }) {
    return _dio.get(
      ApiEndpoints.vaccinations,
      queryParameters: {
        'page': page,
        'limit': limit,
        'sort_by': sortBy,
        'sort_order': sortOrder,
        if (rabbitId != null) 'rabbit_id': rabbitId,
        if (vaccineType != null) 'vaccine_type': vaccineType,
        if (fromDate != null) 'from_date': fromDate,
        if (toDate != null) 'to_date': toDate,
        if (upcoming) 'upcoming': 'true',
      },
    );
  }

  Future<Response> getVaccinationById(int id) {
    return _dio.get('${ApiEndpoints.vaccinations}/$id');
  }

  Future<Response> createVaccination(Map<String, dynamic> data) {
    return _dio.post(ApiEndpoints.vaccinations, data: data);
  }

  Future<Response> updateVaccination(int id, Map<String, dynamic> data) {
    return _dio.put('${ApiEndpoints.vaccinations}/$id', data: data);
  }

  Future<Response> deleteVaccination(int id) {
    return _dio.delete('${ApiEndpoints.vaccinations}/$id');
  }

  Future<Response> getRabbitVaccinations(int rabbitId) {
    return _dio.get('${ApiEndpoints.rabbits}/$rabbitId/vaccinations');
  }

  Future<Response> getVaccinationStatistics() {
    return _dio.get(ApiEndpoints.vaccinationStatistics);
  }

  Future<Response> getUpcomingVaccinations({int days = 30}) {
    return _dio.get(
      ApiEndpoints.vaccinationsUpcoming,
      queryParameters: {'days': days},
    );
  }

  Future<Response> getOverdueVaccinations() {
    return _dio.get(ApiEndpoints.vaccinationsOverdue);
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

  Future<Response> uploadPhoto(int rabbitId, String filePath, {Uint8List? bytes}) async {
    final MultipartFile file;

    if (kIsWeb && bytes != null) {
      // For web, use bytes
      file = MultipartFile.fromBytes(
        bytes,
        filename: 'photo.jpg',
      );
    } else {
      // For mobile/desktop, use file path
      file = await MultipartFile.fromFile(filePath);
    }

    final formData = FormData.fromMap({
      'photo': file,
    });

    return _dio.post(
      '${ApiEndpoints.rabbits}/$rabbitId/photo',
      data: formData,
    );
  }

  Future<Response> deletePhoto(int rabbitId) {
    return _dio.delete('${ApiEndpoints.rabbits}/$rabbitId/photo');
  }

  // Breeds endpoints
  Future<Response> getBreeds() {
    return _dio.get(ApiEndpoints.breeds);
  }
}
