import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Auth interceptor - adds JWT token to requests
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  AuthInterceptor({required this.storage});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get access token from secure storage
    final token = await storage.read(key: 'access_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If 401 Unauthorized, try to refresh token
    if (err.response?.statusCode == 401) {
      final refreshToken = await storage.read(key: 'refresh_token');

      if (refreshToken != null) {
        try {
          // Try to refresh token
          final dio = Dio(BaseOptions(
            baseUrl: err.requestOptions.baseUrl,
          ));

          final response = await dio.post(
            '/auth/refresh',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['data']['access_token'];
            final newRefreshToken = response.data['data']['refresh_token'];

            // Save new tokens
            await storage.write(key: 'access_token', value: newAccessToken);
            await storage.write(key: 'refresh_token', value: newRefreshToken);

            // Retry the original request with new token
            err.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';

            final opts = Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            );

            final retryResponse = await dio.request(
              err.requestOptions.path,
              options: opts,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
            );

            return handler.resolve(retryResponse);
          }
        } catch (e) {
          // Refresh failed, clear tokens
          await storage.delete(key: 'access_token');
          await storage.delete(key: 'refresh_token');
        }
      }
    }

    handler.next(err);
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
