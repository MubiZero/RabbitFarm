import 'package:dio/dio.dart';

import 'api_error.dart';

/// Что именно пошло не так с запросом.
///
/// Слой данных не знает языка интерфейса и не должен его знать: раньше каждый
/// репозиторий подставлял свою русскую строку («Не удалось загрузить корма»),
/// и две сотни таких строк жили мимо переводов. Теперь наружу уходит причина,
/// а текст выбирает экран.
enum ApiFailureKind {
  /// Сети нет: связь не установилась.
  offline,

  /// Сервер не ответил вовремя.
  timeout,

  /// Сессия истекла или её нет.
  unauthorized,

  /// Роль не позволяет это действие.
  forbidden,

  /// Записи не существует — или она принадлежит другой ферме.
  notFound,

  /// Данные не приняты: нарушены правила (занятый номер, занятая клетка).
  invalid,

  /// Сервер ответил ошибкой.
  server,

  /// Всё остальное.
  unknown,
}

/// Неудачный запрос к серверу.
class ApiFailure implements Exception {
  const ApiFailure(this.kind, {this.serverText, this.code});

  final ApiFailureKind kind;

  /// Текст от сервера. Сервер отвечает на языке фермы и знает подробности,
  /// которых у клиента нет («Клетка №3 занята»), поэтому он важнее общего
  /// описания причины.
  final String? serverText;

  /// Машинный код из конверта ошибки — когда экран различает случаи
  /// (например `USER_EXISTS`, чтобы предложить перейти ко входу).
  final String? code;

  factory ApiFailure.from(DioException e) => ApiFailure(
        _kindOf(e),
        serverText: serverMessage(e),
        code: serverErrorCode(e),
      );

  static ApiFailureKind _kindOf(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return ApiFailureKind.offline;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiFailureKind.timeout;
      case DioExceptionType.badResponse:
        return _kindOfStatus(e.response?.statusCode);
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return ApiFailureKind.unknown;
    }
  }

  static ApiFailureKind _kindOfStatus(int? status) {
    if (status == null) return ApiFailureKind.unknown;
    if (status == 401) return ApiFailureKind.unauthorized;
    if (status == 403) return ApiFailureKind.forbidden;
    if (status == 404) return ApiFailureKind.notFound;
    if (status >= 500) return ApiFailureKind.server;
    if (status >= 400) return ApiFailureKind.invalid;
    return ApiFailureKind.unknown;
  }

  /// Только для журналов и отладки: пользователю показывается текст,
  /// собранный экраном через `errorText`.
  @override
  String toString() => 'ApiFailure(${kind.name}${code == null ? '' : ', $code'})';
}
