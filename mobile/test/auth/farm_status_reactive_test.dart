import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/providers/api_providers.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import '../support/fake_storage.dart';

/// Вход всегда удаётся с профилем на активной ферме; любой другой запрос —
/// заранее заданный отказ (см. docs/plans/PLATFORM-ADMIN.md, 4.2: узнать
/// про read_only/suspended можно и по ответу на обычный запрос, не
/// дожидаясь следующего обновления профиля).
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({this.otherStatus = 200, this.otherCode, this.otherMessage});

  final int otherStatus;
  final String? otherCode;
  final String? otherMessage;

  ResponseBody _json(Map<String, dynamic> body, int status) =>
      ResponseBody.fromString(
        jsonEncode(body),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType]
        },
      );

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.path.contains('/auth/login')) {
      return _json({
        'success': true,
        'message': 'ok',
        'data': {
          'access_token': 'access',
          'refresh_token': 'refresh',
          'user': {
            'id': 1,
            'email': 'ivan@farm.test',
            'full_name': 'Иван',
            'role': 'owner',
            'is_active': true,
            'created_at': '2026-01-01T00:00:00.000Z',
            'updated_at': '2026-01-01T00:00:00.000Z',
            'farm': {'id': 7, 'status': 'active'}
          }
        }
      }, 200);
    }

    if (otherCode == null) {
      return _json({'success': true, 'message': 'ok', 'data': <String, dynamic>{}}, otherStatus);
    }
    return _json({
      'error': {'code': otherCode, 'message': otherMessage ?? 'Ошибка'}
    }, otherStatus);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  Future<ProviderContainer> buildContainer(_FakeAdapter adapter) async {
    // Один и тот же экземпляр — клиенту (там читает `AuthInterceptor`) и
    // репозиторию (там кладёт токены `AuthRepository`) нужно одно и то же
    // хранилище, а не два независимых.
    final storage = FakeStorage();
    final client = ApiClient(storage: storage);
    client.dio.httpClientAdapter = adapter;

    final container = ProviderContainer(overrides: [
      storageProvider.overrideWithValue(storage),
      apiClientProvider.overrideWithValue(client),
    ]);
    addTearDown(container.dispose);

    await container.read(authProvider.notifier).login(
          email: 'ivan@farm.test',
          password: 'password123',
        );
    return container;
  }

  test('узнаёт про read_only по ответу на обычный запрос, не дожидаясь следующего профиля', () async {
    final container = await buildContainer(_FakeAdapter(
      otherStatus: 403,
      otherCode: 'FARM_READ_ONLY',
      otherMessage: 'Хозяйство доступно только для чтения',
    ));
    expect(container.read(authProvider).user?.farm?.status, 'active');

    await expectLater(
      container.read(apiClientProvider).get('/rabbits'),
      throwsA(isA<DioException>()),
    );

    expect(container.read(authProvider).user?.farm?.status, 'read_only');
  });

  test('узнаёт про suspended тем же путём', () async {
    final container = await buildContainer(_FakeAdapter(
      otherStatus: 403,
      otherCode: 'FARM_SUSPENDED',
      otherMessage: 'Хозяйство приостановлено',
    ));

    await expectLater(
      container.read(apiClientProvider).get('/rabbits'),
      throwsA(isA<DioException>()),
    );

    expect(container.read(authProvider).user?.farm?.status, 'suspended');
  });

  test('посторонняя ошибка не трогает статус фермы', () async {
    final container = await buildContainer(_FakeAdapter(
      otherStatus: 400,
      otherCode: 'RABBIT_LIMIT_REACHED',
      otherMessage: 'Предел кроликов исчерпан',
    ));

    await expectLater(
      container.read(apiClientProvider).get('/rabbits'),
      throwsA(isA<DioException>()),
    );

    expect(container.read(authProvider).user?.farm?.status, 'active');
  });
}
