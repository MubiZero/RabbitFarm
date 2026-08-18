import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/api/api_error.dart';

DioException _error(dynamic body) => DioException(
      requestOptions: RequestOptions(path: '/breeds'),
      response: Response(
        requestOptions: RequestOptions(path: '/breeds'),
        statusCode: 409,
        data: body,
      ),
    );

void main() {
  group('serverMessage', () {
    test('берёт текст из стандартного конверта ошибок', () {
      final e = _error({
        'success': false,
        'error': {
          'code': 'CONFLICT',
          'message': 'Порода с таким названием уже существует',
        },
      });

      expect(serverMessage(e), 'Порода с таким названием уже существует');
    });

    test('понимает сообщение верхним уровнем', () {
      expect(serverMessage(_error({'message': 'Что-то не так'})), 'Что-то не так');
    });

    test('не падает на не-JSON ответе', () {
      expect(serverMessage(_error('<html>502 Bad Gateway</html>')), isNull);
    });

    test('возвращает null, когда ответа нет совсем', () {
      final e = DioException(requestOptions: RequestOptions(path: '/breeds'));
      expect(serverMessage(e), isNull);
    });
  });

  group('serverErrorCode', () {
    test('достаёт код для ветвления в UI', () {
      final e = _error({
        'error': {'code': 'USER_EXISTS', 'message': 'Пользователь уже есть'},
      });

      expect(serverErrorCode(e), 'USER_EXISTS');
    });

    test('возвращает null, если конверт без кода', () {
      expect(serverErrorCode(_error({'message': 'нет кода'})), isNull);
    });
  });
}
