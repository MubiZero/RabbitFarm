import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Auth interceptor - adds JWT token to requests
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  /// Вызывается, когда сессию восстановить не удалось и нужно выйти.
  /// Без этого приложение стирало токены, но продолжало считать себя
  /// авторизованным: все экраны писали «не авторизован», а выйти было нельзя
  /// иначе как перезапуском.
  void Function()? onSessionExpired;

  /// Основной клиент — повтор запроса должен идти через него, чтобы работали
  /// таймауты и разбор ошибок, а не через одноразовый Dio без настроек.
  Dio? client;

  /// Единственное обновление токена на все параллельные 401.
  ///
  /// Экран может отправить несколько запросов сразу; когда срок токена
  /// истекал, каждый начинал собственное обновление. Сервер выдаёт новый
  /// refresh-токен и гасит старый, поэтому второе обновление приходило с уже
  /// погашенным токеном, падало — и стирало только что полученные рабочие
  /// токены. Со стороны это выглядело как случайные выходы из аккаунта.
  Future<String?>? _refreshing;

  static const _retriedMarker = 'auth_retried';

  AuthInterceptor({required this.storage});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.read(key: 'access_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await storage.read(key: 'refresh_token');
    if (refreshToken == null) return null;

    // Через основной клиент, а не через одноразовый Dio: иначе теряются
    // таймауты, разбор ошибок и настройка адреса. Рекурсии здесь нет — 401 на
    // самом /auth/refresh не считается поводом для повтора.
    final response = await (client ?? Dio()).post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    if (response.statusCode != 200) return null;

    final data = response.data['data'];
    await storage.write(key: 'access_token', value: data['access_token']);
    await storage.write(key: 'refresh_token', value: data['refresh_token']);
    return data['access_token'] as String;
  }

  Future<void> _dropSession() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
    onSessionExpired?.call();
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    final isRetryable = err.response?.statusCode == 401 &&
        request.extra[_retriedMarker] != true &&
        !request.path.contains('/auth/refresh');

    if (!isRetryable) {
      handler.next(err);
      return;
    }

    // Тело FormData — одноразовый поток, повторно отправить его нельзя.
    // Такой запрос честно возвращаем с ошибкой, а не роняем непонятно где.
    if (request.data is FormData) {
      handler.next(err);
      return;
    }

    String? newToken;
    try {
      newToken = await (_refreshing ??= _refreshToken());
    } catch (_) {
      newToken = null;
    } finally {
      _refreshing = null;
    }

    if (newToken == null) {
      await _dropSession();
      handler.next(err);
      return;
    }

    try {
      request.headers['Authorization'] = 'Bearer $newToken';
      request.extra[_retriedMarker] = true;

      final retried = await (client ?? Dio()).fetch(request);
      handler.resolve(retried);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}

// Logging interceptor - logs requests and responses (dev mode only)
class LoggingInterceptor extends Interceptor {
  // Токены и пароли не должны попадать в системный лог даже в отладке:
  // логи устройства читают сторонние приложения и краш-репортеры.
  static const _redactedKeys = {
    'authorization',
    'password',
    'current_password',
    'new_password',
    'password_confirmation',
    'access_token',
    'refresh_token',
    'token',
  };

  static Object? _redact(Object? value) {
    if (value is Map) {
      return {
        for (final entry in value.entries)
          entry.key: _redactedKeys.contains(entry.key.toString().toLowerCase())
              ? '***'
              : _redact(entry.value),
      };
    }
    if (value is List) return value.map(_redact).toList();
    return value;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
      debugPrint('📤 Data: ${_redact(options.data)}');
      debugPrint('🔑 Headers: ${_redact(options.headers)}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
      debugPrint('📥 Data: ${_redact(response.data)}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
      debugPrint('🚨 Message: ${err.message}');
      debugPrint('📛 Response: ${_redact(err.response?.data)}');
    }
    handler.next(err);
  }
}

// Error interceptor - handles common errors
class ErrorInterceptor extends Interceptor {
  /// Код ошибки говорит, что состояние доступа хозяйства изменилось с
  /// прошлого раза, когда клиент об этом знал (см. `FarmStatusBanner`) —
  /// админ мог приостановить ферму, или истёк тариф, пока сеанс уже был
  /// открыт. Разбирается здесь, а не в каждом экране: это тот же глобальный
  /// признак, что и обновление токена в `AuthInterceptor`, только про доступ
  /// фермы, а не пользователя.
  void Function(String status)? onFarmAccessChanged;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = '';

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Время ожидания истекло. Проверьте подключение.';
        break;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;

        if (data is Map) {
          // Handle standardized API error response
          if (data['error'] is Map) {
            final errorObj = data['error'];
            errorMessage = errorObj['message'] ?? 'Произошла ошибка';

            switch (errorObj['code']) {
              case 'FARM_READ_ONLY':
                onFarmAccessChanged?.call('read_only');
                break;
              case 'FARM_SUSPENDED':
                onFarmAccessChanged?.call('suspended');
                break;
            }

            // Handle validation details
            if (errorObj['details'] is List) {
              final details = errorObj['details'] as List;
              if (details.isNotEmpty) {
                final detailsMessages = details
                    .map((d) => d['message']?.toString() ?? '')
                    .where((m) => m.isNotEmpty)
                    .join('\n');
                if (detailsMessages.isNotEmpty) {
                  errorMessage = '$errorMessage:\n$detailsMessages';
                }
              }
            }

            // Attach error code to the exception for handling in UI
            err = err.copyWith(
              error: {'code': errorObj['code'], 'message': errorMessage},
            );
          } else if (data.containsKey('message')) {
            errorMessage = data['message'];
          }
        }

        // If no error message found yet, use default messages based on status code
        // ignore: unnecessary_null_comparison
        if (errorMessage.isEmpty) {
          switch (statusCode) {
            case 400:
              errorMessage = 'Неверный запрос';
              break;
            case 401:
              errorMessage = 'Не авторизован';
              break;
            case 403:
              errorMessage = 'Доступ запрещен';
              break;
            case 404:
              errorMessage = 'Не найдено';
              break;
            case 409:
              errorMessage = 'Такая запись уже существует';
              break;
            case 422:
              errorMessage = 'Ошибка валидации';
              break;
            case 500:
              errorMessage = 'Ошибка сервера';
              break;
            default:
              errorMessage = 'Произошла ошибка ($statusCode)';
          }
        }
        break;

      case DioExceptionType.cancel:
        errorMessage = 'Запрос отменен';
        break;

      case DioExceptionType.unknown:
        if (err.error.toString().contains('SocketException')) {
          errorMessage = 'Нет подключения к интернету';
        } else {
          errorMessage = 'Неизвестная ошибка: ${err.error}';
        }
        break;

      default:
        errorMessage = 'Произошла ошибка';
    }

    // Add custom error message to the error
    err = err.copyWith(
      message: errorMessage,
    );

    handler.next(err);
  }
}
