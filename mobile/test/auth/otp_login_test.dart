import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/core/providers/api_providers.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

/// Хранилище в памяти — как в farm_status_reactive_test.dart.
class _FakeStorage extends FlutterSecureStorage {
  _FakeStorage() : super();

  final values = <String, String>{};

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      values[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    values.remove(key);
  }
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({this.verifyStatus = 200, this.verifyCode, this.verifyMessage});

  final int verifyStatus;
  final String? verifyCode;
  final String? verifyMessage;

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
    if (options.path.contains('/auth/otp/request')) {
      return _json({'success': true, 'message': 'ok', 'data': null}, 200);
    }

    if (options.path.contains('/auth/otp/verify')) {
      if (verifyCode != null) {
        return _json({
          'error': {'code': verifyCode, 'message': verifyMessage ?? 'Ошибка'}
        }, verifyStatus);
      }
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

    return _json({'success': true, 'message': 'ok', 'data': <String, dynamic>{}}, 200);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  ProviderContainer buildContainer(_FakeAdapter adapter) {
    final storage = _FakeStorage();
    final client = ApiClient(storage: storage);
    client.dio.httpClientAdapter = adapter;

    final container = ProviderContainer(overrides: [
      storageProvider.overrideWithValue(storage),
      apiClientProvider.overrideWithValue(client),
    ]);
    addTearDown(container.dispose);
    return container;
  }

  test('requestOtp не бросает на успешный ответ сервера', () async {
    final container = buildContainer(_FakeAdapter());

    await container.read(authProvider.notifier).requestOtp('+992901234567');

    expect(container.read(authProvider).error, isNull);
    expect(container.read(authProvider).isAuthenticated, isFalse);
  });

  test('verifyOtp с верным кодом авторизует и сохраняет профиль', () async {
    final container = buildContainer(_FakeAdapter());

    await container.read(authProvider.notifier).verifyOtp(
          phone: '+992901234567',
          code: '123456',
        );

    final state = container.read(authProvider);
    expect(state.isAuthenticated, isTrue);
    expect(state.user?.email, 'ivan@farm.test');
  });

  test('verifyOtp с неверным кодом пробрасывает текст сервера, не логинит', () async {
    final container = buildContainer(_FakeAdapter(
      verifyStatus: 400,
      verifyCode: 'OTP_INVALID',
      verifyMessage: 'Неверный код',
    ));

    await expectLater(
      container.read(authProvider.notifier).verifyOtp(
            phone: '+992901234567',
            code: '000000',
          ),
      throwsA(isA<ApiFailure>()
          .having((e) => e.serverText, 'serverText', 'Неверный код')),
    );

    expect(container.read(authProvider).isAuthenticated, isFalse);
  });
}
