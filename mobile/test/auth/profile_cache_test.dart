import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository.dart';
import '../support/fake_storage.dart';

/// Сервер-заглушка: отдаёт профиль владельца на /auth/profile и принимает
/// выход.
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

Map<String, dynamic> _owner({String role = 'owner'}) => {
      'id': 1,
      'email': 'owner@farm.test',
      'full_name': 'Хозяин',
      'role': role,
      'is_active': true,
      'created_at': '2026-01-01T00:00:00.000Z',
      'updated_at': '2026-01-01T00:00:00.000Z',
    };

/// Роль человека нужна приложению и без сети: без сохранённого профиля она
/// вычислялась из пустоты, а неизвестная роль трактуется как самая узкая —
/// владелец без связи получал интерфейс работника.
void main() {
  AuthRepository build(FakeStorage storage, Map<String, dynamic> profile) {
    final client = ApiClient(storage: storage);
    client.dio.httpClientAdapter = _FakeAdapter(profile);
    return AuthRepository(apiClient: client, storage: storage);
  }

  test('успешный запрос профиля сохраняет его на устройстве', () async {
    final storage = FakeStorage();
    final repository = build(storage, _owner());

    await repository.getProfile();

    expect(storage.values.containsKey('profile'), isTrue);
    final cached = await repository.cachedProfile();
    expect(cached?.role, 'owner');
    expect(cached?.fullName, 'Хозяин');
  });

  test('без сохранённого профиля честно возвращает ничего', () async {
    final repository = build(FakeStorage(), _owner());
    expect(await repository.cachedProfile(), isNull);
  });

  test('испорченная запись не выдаётся за профиль и вычищается', () async {
    final storage = FakeStorage({'profile': 'не json'});
    final repository = build(storage, _owner());

    expect(await repository.cachedProfile(), isNull);
    expect(storage.values.containsKey('profile'), isFalse);
  });

  test('выход стирает профиль вместе с токенами', () async {
    final storage = FakeStorage({
      'access_token': 'a',
      'refresh_token': 'r',
      'profile': jsonEncode(_owner()),
    });
    final repository = build(storage, _owner());

    await repository.logout();

    expect(storage.values, isEmpty);
  });
}
