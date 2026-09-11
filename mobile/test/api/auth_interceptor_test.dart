import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/api/api_interceptors.dart';
import '../support/fake_storage.dart';

/// Сервер-заглушка: защищённый маршрут отвечает 401, пока не предъявлен
/// свежий токен; обновление считает свои вызовы.
class _FakeServer implements HttpClientAdapter {
  _FakeServer({this.refreshSucceeds = true});

  final bool refreshSucceeds;
  int refreshCalls = 0;
  int protectedCalls = 0;
  final Completer<void> refreshGate = Completer<void>();

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
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.path.contains('/auth/refresh')) {
      refreshCalls++;
      // Держим обновление, пока тест не отпустит: так проверяется, что
      // параллельные 401 ждут одно обновление, а не начинают своё.
      await refreshGate.future;

      if (!refreshSucceeds) {
        return _json({
          'error': {'code': 'INVALID_TOKEN', 'message': 'Просрочен'}
        }, 401);
      }

      return _json({
        'data': {'access_token': 'fresh', 'refresh_token': 'fresh-refresh'}
      }, 200);
    }

    protectedCalls++;
    final auth = options.headers['Authorization'];
    if (auth == 'Bearer fresh') {
      return _json({'data': 'ок'}, 200);
    }
    return _json({
      'error': {'code': 'UNAUTHORIZED', 'message': 'Не авторизован'}
    }, 401);
  }

  @override
  void close({bool force = false}) {}
}

Dio _buildDio(_FakeServer server, AuthInterceptor interceptor) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'));
  dio.httpClientAdapter = server;
  interceptor.client = dio;
  dio.interceptors.add(interceptor);
  return dio;
}

void main() {
  group('AuthInterceptor', () {
    test('несколько одновременных 401 обновляют токен один раз', () async {
      final storage = FakeStorage({
        'access_token': 'stale',
        'refresh_token': 'valid-refresh',
      });
      final server = _FakeServer();
      final interceptor = AuthInterceptor(storage: storage);
      final dio = _buildDio(server, interceptor);

      final requests = Future.wait([
        dio.get('/rabbits'),
        dio.get('/cages'),
        dio.get('/tasks'),
      ]);

      // Даём всем трём запросам упереться в 401 и в общее обновление.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      server.refreshGate.complete();

      final responses = await requests;

      expect(server.refreshCalls, 1,
          reason: 'каждый 401 не должен начинать своё обновление: '
              'сервер гасит старый refresh-токен, и второе обновление '
              'стирало бы только что полученные рабочие токены');
      expect(responses.every((r) => r.statusCode == 200), isTrue);
      expect(await storage.read(key: 'access_token'), 'fresh');
      expect(await storage.read(key: 'refresh_token'), 'fresh-refresh');
    });

    test('неудачное обновление сообщает о потере сессии и чистит токены',
        () async {
      final storage = FakeStorage({
        'access_token': 'stale',
        'refresh_token': 'expired-refresh',
      });
      final server = _FakeServer(refreshSucceeds: false);
      final interceptor = AuthInterceptor(storage: storage);
      var expired = false;
      interceptor.onSessionExpired = () => expired = true;
      final dio = _buildDio(server, interceptor);

      server.refreshGate.complete();

      await expectLater(dio.get('/rabbits'), throwsA(isA<DioException>()));

      expect(expired, isTrue,
          reason: 'без сигнала приложение считало себя авторизованным без '
              'токенов: экраны писали «не авторизован», а выйти было нельзя');
      expect(await storage.read(key: 'access_token'), isNull);
      expect(await storage.read(key: 'refresh_token'), isNull);
    });

    test('повторный 401 после обновления не уходит в бесконечный круг',
        () async {
      final storage = FakeStorage({
        'access_token': 'stale',
        'refresh_token': 'valid-refresh',
      });
      // Сервер продолжает отвечать 401 даже на свежий токен.
      final server = _AlwaysUnauthorized();
      final interceptor = AuthInterceptor(storage: storage);
      final dio = _buildDio(server, interceptor);

      await expectLater(dio.get('/rabbits'), throwsA(isA<DioException>()));

      expect(server.refreshCalls, 1);
      expect(server.protectedCalls, 2,
          reason: 'один исходный запрос и ровно один повтор');
    });
  });
}

class _AlwaysUnauthorized extends _FakeServer {
  _AlwaysUnauthorized() : super() {
    refreshGate.complete();
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.path.contains('/auth/refresh')) {
      refreshCalls++;
      return _json({
        'data': {'access_token': 'still-bad', 'refresh_token': 'r'}
      }, 200);
    }
    protectedCalls++;
    return _json({
      'error': {'code': 'UNAUTHORIZED', 'message': 'Не авторизован'}
    }, 401);
  }
}
