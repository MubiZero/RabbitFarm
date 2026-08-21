import 'package:dio/dio.dart';

/// Сообщение сервера из стандартного конверта ошибок API:
/// `{ success: false, error: { code, message } }`.
///
/// Возвращает `null`, если внятного текста нет — тогда вызывающий код
/// подставляет свой контекстный («Не удалось создать породу»), который
/// полезнее общего «Произошла ошибка».
String? serverMessage(DioException e) {
  final data = e.response?.data;
  if (data is! Map) return null;

  final error = data['error'];
  if (error is Map && error['message'] is String) {
    return error['message'] as String;
  }
  // Некоторые ответы кладут текст верхним уровнем.
  if (data['message'] is String) return data['message'] as String;
  return null;
}

/// Код ошибки из того же конверта — когда UI различает случаи
/// (например `USER_EXISTS`, чтобы предложить перейти ко входу).
String? serverErrorCode(DioException e) {
  final data = e.response?.data;
  if (data is! Map) return null;
  final error = data['error'];
  return error is Map ? error['code'] as String? : null;
}

/// Выполнить запрос, превратив ошибку Dio в понятное пользователю исключение.
///
/// Без обёртки наружу уходит сырой DioException, и экран показывает
/// «Ошибка: DioException [bad response]: This exception was thrown because…»
/// — техническую английскую простыню вместо сообщения сервера.
Future<T> guardRequest<T>(
  Future<T> Function() request,
  String fallbackMessage,
) async {
  try {
    return await request();
  } on DioException catch (e) {
    throw Exception(serverMessage(e) ?? fallbackMessage);
  }
}
