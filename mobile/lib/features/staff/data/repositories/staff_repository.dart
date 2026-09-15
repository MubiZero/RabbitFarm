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

  /// Приглашения, которыми ещё не воспользовались, — вместе с просроченными
  /// (`FarmInvitation.isExpired` отличает одно от другого).
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

  /// Выписать приглашение — на почту или на телефон.
  ///
  /// Приглашённый входит обычным кодом на свой контакт, и этот вход
  /// активирует приглашение. Имя ему взять неоткуда, поэтому его называет
  /// владелец здесь ([fullName] обязателен именно для этого случая, так же
  /// требует и сервер).
  ///
  /// В ответе — `messageSent` (позвал ли работника сервер) и `inviteLink`
  /// для приглашения по телефону: SMS шлюз отправить не даёт, и ссылку
  /// пересылает сам владелец.
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

  /// Позвать того же человека ещё раз: сервер продлевает срок приглашения
  /// и повторяет отправку. Новой записи не заводит — контакт и роль те же.
  Future<CreatedInvitation> resendInvitation(int id) async {
    try {
      final response = await _apiClient.post('/staff/invitations/$id/resend');
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
}
