import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../models/staff_models.dart';
import '../../../../core/api/api_failure.dart';

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
      throw ApiFailure.from(e);
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
      throw ApiFailure.from(e);
    }
  }

  /// Выписать приглашение — на почту или на телефон. Код в ответе приходит
  /// один раз, сервер его не хранит.
  ///
  /// Приглашённый по телефону войдёт кодом из SMS прямо на экране входа —
  /// имя ему взять неоткуда, поэтому его называет владелец здесь ([fullName]
  /// обязателен именно для этого случая, так же требует и сервер).
  Future<CreatedInvitation> createInvitation({
    String? email,
    String? phone,
    String? fullName,
    required FarmRole role,
  }) async {
    assert((email == null) != (phone == null),
        'Приглашение выписывается либо на почту, либо на телефон');
    try {
      final response = await _apiClient.post('/staff/invitations', data: {
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (fullName != null) 'full_name': fullName,
        'role': role.name,
      });
      return CreatedInvitation.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  Future<void> revokeInvitation(int id) async {
    try {
      await _apiClient.delete('/staff/invitations/$id');
    } on DioException catch (e) {
      throw ApiFailure.from(e);
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
      throw ApiFailure.from(e);
    }
  }

  /// Задать работнику временный пароль. Возвращается один раз.
  Future<String> resetMemberPassword(int id) async {
    try {
      final response = await _apiClient.post('/staff/$id/reset-password');
      return response.data['data']['temporary_password'] as String;
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Передать хозяйство фермы работнику. Мгновенно, без подтверждения с
  /// его стороны — он уже участник этой же фермы.
  Future<FarmMember> transferOwnership(int id) async {
    try {
      final response = await _apiClient.post('/staff/$id/transfer-ownership');
      return FarmMember.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
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
      throw ApiFailure.from(e);
    }
  }
}
