import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_error.dart';
import '../models/staff_models.dart';

/// Работники фермы и приглашения.
class StaffRepository {
  final ApiClient _apiClient;

  StaffRepository(this._apiClient);

  /// Состав фермы: владелец и сотрудники.
  Future<List<FarmMember>> getMembers() async {
    try {
      final response = await _apiClient.get('/staff');
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((json) => FarmMember.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось загрузить состав фермы');
    }
  }

  /// Действующие приглашения.
  Future<List<FarmInvitation>> getInvitations() async {
    try {
      final response = await _apiClient.get('/staff/invitations');
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((json) => FarmInvitation.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось загрузить приглашения');
    }
  }

  /// Выписать приглашение. Код в ответе приходит один раз — сервер его не хранит.
  Future<CreatedInvitation> createInvitation({
    required String email,
    required FarmRole role,
  }) async {
    try {
      final response = await _apiClient.post('/staff/invitations', data: {
        'email': email,
        'role': role.name,
      });
      return CreatedInvitation.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось создать приглашение');
    }
  }

  Future<void> revokeInvitation(int id) async {
    try {
      await _apiClient.delete('/staff/invitations/$id');
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось отозвать приглашение');
    }
  }

  /// Изменить роль сотрудника или закрыть ему доступ.
  Future<FarmMember> updateMember(
    int id, {
    FarmRole? role,
    bool? isActive,
  }) async {
    try {
      final response = await _apiClient.patch('/staff/$id', data: {
        if (role != null) 'role': role.name,
        if (isActive != null) 'is_active': isActive,
      });
      return FarmMember.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось изменить доступ');
    }
  }

  /// Присоединиться к ферме по коду. Вызывается до авторизации.
  Future<Map<String, dynamic>> acceptInvitation({
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
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(serverMessage(e) ?? 'Не удалось присоединиться к ферме');
    }
  }
}
