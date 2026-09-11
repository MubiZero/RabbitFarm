import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository.dart';
import '../support/fake_storage.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.profile);

  final Map<String, dynamic> profile;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? _,
      Future<void>? __) async {
    final body = options.path.contains('me')
        ? {'success': true, 'message': 'ok', 'data': profile}
        : {'success': true, 'message': 'ok', 'data': <String, dynamic>{}};
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Map<String, dynamic> _profile({required int id, required String fullName}) => {
      'id': id,
      'email': '$fullName@farm.test',
      'full_name': fullName,
      'role': 'owner',
      'is_active': true,
      'created_at': '2026-01-01T00:00:00.000Z',
      'updated_at': '2026-01-01T00:00:00.000Z',
    };

/// Вход под клиентом, только чтение (см. docs/plans/PLATFORM-ADMIN.md, 3.2):
/// собственная сессия админа откладывается на диске, а не стирается — её
/// нужно вернуть по кнопке «Выйти» или когда истечёт 15-минутный токен.
void main() {
  AuthRepository build(FakeStorage storage, Map<String, dynamic> profile) {
    final client = ApiClient(storage: storage);
    client.dio.httpClientAdapter = _FakeAdapter(profile);
    return AuthRepository(apiClient: client, storage: storage);
  }

  test('вход под клиентом откладывает токены и профиль админа', () async {
    final storage = FakeStorage({
      'access_token': 'admin-access',
      'refresh_token': 'admin-refresh',
      'profile': jsonEncode(_profile(id: 1, fullName: 'Админ')),
    });
    final repository = build(storage, _profile(id: 5, fullName: 'Иван'));

    await repository.startImpersonation(
      accessToken: 'owner-access',
      farmName: 'Ферма Иванова',
    );

    expect(storage.values['access_token'], 'owner-access');
    // Без refresh-токена: как только он перестанет приниматься, обновиться
    // им нечем — это и есть сигнал конца сеанса просмотра.
    expect(storage.values.containsKey('refresh_token'), isFalse);
    expect(storage.values['admin_access_token'], 'admin-access');
    expect(storage.values['admin_refresh_token'], 'admin-refresh');
    expect(storage.values['admin_profile'], isNotNull);
    expect(await repository.impersonatedFarmName(), 'Ферма Иванова');
    expect(await repository.isImpersonating(), isTrue);
  });

  test('без сохранённого refresh-токена админа не путает его отсутствие с чужим', () async {
    // У админа мог не быть refresh-токена на момент входа под клиентом
    // (маловероятно, но откладывать нечего — значит и не пишем).
    final storage = FakeStorage({
      'access_token': 'admin-access',
      'profile': jsonEncode(_profile(id: 1, fullName: 'Админ')),
    });
    final repository = build(storage, _profile(id: 5, fullName: 'Иван'));

    await repository.startImpersonation(
      accessToken: 'owner-access',
      farmName: 'Ферма Иванова',
    );

    expect(storage.values.containsKey('admin_refresh_token'), isFalse);
  });

  test('восстановление возвращает токены и профиль админа, снимает пометки просмотра', () async {
    final storage = FakeStorage({
      'access_token': 'owner-access',
      'admin_access_token': 'admin-access',
      'admin_refresh_token': 'admin-refresh',
      'admin_profile': jsonEncode(_profile(id: 1, fullName: 'Админ')),
      'impersonation_farm_name': 'Ферма Иванова',
    });
    final repository = build(storage, _profile(id: 1, fullName: 'Админ'));

    final restored = await repository.restoreFromImpersonation();

    expect(restored, isTrue);
    expect(storage.values['access_token'], 'admin-access');
    expect(storage.values['refresh_token'], 'admin-refresh');
    expect(jsonDecode(storage.values['profile']!)['full_name'], 'Админ');
    expect(storage.values.containsKey('admin_access_token'), isFalse);
    expect(storage.values.containsKey('admin_refresh_token'), isFalse);
    expect(storage.values.containsKey('admin_profile'), isFalse);
    expect(storage.values.containsKey('impersonation_farm_name'), isFalse);
    expect(await repository.isImpersonating(), isFalse);
  });

  test('восстанавливать нечего — вне сеанса просмотра', () async {
    final repository = build(FakeStorage(), _profile(id: 1, fullName: 'Админ'));

    expect(await repository.restoreFromImpersonation(), isFalse);
    expect(await repository.isImpersonating(), isFalse);
  });

  test('обычный выход стирает и отложенную сессию просмотра — не только текущую', () async {
    final storage = FakeStorage({
      'access_token': 'owner-access',
      'refresh_token': 'r',
      'profile': 'p',
      'admin_access_token': 'admin-access',
      'admin_refresh_token': 'admin-refresh',
      'admin_profile': 'admin-p',
      'impersonation_farm_name': 'Ферма Иванова',
    });
    final repository = build(storage, _profile(id: 1, fullName: 'Админ'));

    await repository.logout();

    expect(storage.values, isEmpty);
  });
}
