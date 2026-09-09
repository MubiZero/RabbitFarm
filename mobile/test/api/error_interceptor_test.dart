import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/api/api_interceptors.dart';

/// Сервер-заглушка: отвечает заранее заданным телом ошибки на любой запрос.
class _FakeServer implements HttpClientAdapter {
  _FakeServer(this.status, this.body);

  final int status;
  final Map<String, dynamic> body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _buildDio(int status, String code, String message) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'));
  dio.httpClientAdapter = _FakeServer(status, {
    'error': {'code': code, 'message': message}
  });
  dio.interceptors.add(ErrorInterceptor());
  return dio;
}

void main() {
  group('ErrorInterceptor', () {
    test('сообщает о переходе в read_only по коду FARM_READ_ONLY', () async {
      final dio = _buildDio(403, 'FARM_READ_ONLY', 'Хозяйство доступно только для чтения');
      final interceptor = dio.interceptors.whereType<ErrorInterceptor>().first;
      String? seenStatus;
      interceptor.onFarmAccessChanged = (status) => seenStatus = status;

      await expectLater(dio.get('/rabbits'), throwsA(isA<DioException>()));

      expect(seenStatus, 'read_only');
    });

    test('сообщает о переходе в suspended по коду FARM_SUSPENDED', () async {
      final dio = _buildDio(403, 'FARM_SUSPENDED', 'Хозяйство приостановлено');
      final interceptor = dio.interceptors.whereType<ErrorInterceptor>().first;
      String? seenStatus;
      interceptor.onFarmAccessChanged = (status) => seenStatus = status;

      await expectLater(dio.get('/rabbits'), throwsA(isA<DioException>()));

      expect(seenStatus, 'suspended');
    });

    test('сообщает об устаревшей версии по коду UPGRADE_REQUIRED', () async {
      final dio = _buildDio(426, 'UPGRADE_REQUIRED', 'Обновитесь до 1.2.0 или новее');
      final interceptor = dio.interceptors.whereType<ErrorInterceptor>().first;
      var called = false;
      interceptor.onUpgradeRequired = () => called = true;

      await expectLater(dio.get('/rabbits'), throwsA(isA<DioException>()));

      expect(called, isTrue);
    });

    test('не срабатывает на посторонние коды ошибок', () async {
      final dio = _buildDio(400, 'RABBIT_LIMIT_REACHED', 'Предел кроликов исчерпан');
      final interceptor = dio.interceptors.whereType<ErrorInterceptor>().first;
      var called = false;
      interceptor.onFarmAccessChanged = (_) => called = true;

      await expectLater(dio.get('/rabbits'), throwsA(isA<DioException>()));

      expect(called, isFalse);
    });

    test('сообщение сервера доезжает до исключения как обычно', () async {
      final dio = _buildDio(403, 'FARM_READ_ONLY', 'Обратитесь в поддержку');

      try {
        await dio.get('/rabbits');
        fail('ожидалось исключение');
      } on DioException catch (e) {
        expect(e.message, 'Обратитесь в поддержку');
      }
    });
  });
}
