import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/core/l10n/error_text.dart';
import 'package:mobile/l10n/generated/app_localizations_ru.dart';

DioException _response(int status, {Map<String, dynamic>? body}) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/x'),
        statusCode: status,
        data: body,
      ),
    );

/// Слой данных отдаёт причину, а не готовую фразу: раньше каждый репозиторий
/// подставлял свою русскую строку мимо переводов, а ошибки Dio уходили
/// пользователю английской технической простынёй.
void main() {
  final l10n = AppLocalizationsRu();

  group('Причина по ответу сервера', () {
    test('нет сети', () {
      final failure = ApiFailure.from(DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.connectionError,
      ));
      expect(failure.kind, ApiFailureKind.offline);
    });

    test('сервер не ответил вовремя', () {
      final failure = ApiFailure.from(DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.receiveTimeout,
      ));
      expect(failure.kind, ApiFailureKind.timeout);
    });

    test('коды состояния', () {
      expect(ApiFailure.from(_response(401)).kind, ApiFailureKind.unauthorized);
      expect(ApiFailure.from(_response(403)).kind, ApiFailureKind.forbidden);
      expect(ApiFailure.from(_response(404)).kind, ApiFailureKind.notFound);
      expect(ApiFailure.from(_response(422)).kind, ApiFailureKind.invalid);
      expect(ApiFailure.from(_response(500)).kind, ApiFailureKind.server);
    });

    test('код ошибки из конверта доезжает до экрана', () {
      final failure = ApiFailure.from(_response(409, body: {
        'error': {'code': 'USER_EXISTS', 'message': 'Почта уже занята'}
      }));
      expect(failure.code, 'USER_EXISTS');
    });
  });

  group('Текст для человека', () {
    test('подробность сервера важнее общего описания', () {
      final failure = ApiFailure.from(_response(400, body: {
        'error': {'message': 'Клетка №3 занята'}
      }));
      expect(errorText(l10n, failure), 'Клетка №3 занята');
    });

    test('без подробностей объясняем причину', () {
      expect(
        errorText(l10n, const ApiFailure(ApiFailureKind.offline)),
        'Нет связи — проверьте интернет',
      );
      expect(
        errorText(l10n, const ApiFailure(ApiFailureKind.forbidden)),
        'У вашей роли нет доступа к этому',
      );
    });

    test('пустой текст сервера не выдаётся за сообщение', () {
      final failure = ApiFailure.from(_response(500, body: {
        'error': {'message': '   '}
      }));
      expect(errorText(l10n, failure), 'На сервере сбой, попробуйте позже');
    });

    test('служебное слово Exception пользователю не показывается', () {
      expect(errorText(l10n, Exception('Разбор ответа не удался')),
          'Разбор ответа не удался');
    });

    test('пустая ошибка не оставляет пустой экран', () {
      expect(errorText(l10n, null), 'Неизвестная ошибка');
    });
  });
}
