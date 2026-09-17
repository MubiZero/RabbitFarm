import 'package:dio/dio.dart';

import 'api_failure.dart';

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

/// Выполнить запрос, превратив ошибку Dio в разобранный отказ.
///
/// Без обёртки наружу уходит сырой DioException, и экран показывает
/// «Ошибка: DioException [bad response]: This exception was thrown because…»
/// — техническую английскую простыню вместо сообщения сервера.
///
/// Бросается `ApiFailure`, а не обычный `Exception`: тот терял и вид отказа,
/// и код. Из-за этого при пропавшей связи человек читал «Не удалось
/// загрузить задачи» — приложение знало, что сети нет, но сказать об этом не
/// могло: обёртка уже подменила отказ строкой. Остальные репозитории давно
/// бросают `ApiFailure`, здесь миграцию просто не довели.
///
/// `fallbackMessage` остаётся запасным текстом на случай, когда сервер не
/// сказал ничего вразумительного.
Future<T> guardRequest<T>(
  Future<T> Function() request,
  String fallbackMessage,
) async {
  try {
    return await request();
  } on DioException catch (e) {
    final failure = ApiFailure.from(e);
    // Свой текст подставляем, только если сервер промолчал: его подробность
    // конкретнее нашей заготовки.
    if (failure.serverText != null && failure.serverText!.trim().isNotEmpty) {
      throw failure;
    }
    throw ApiFailure(
      failure.kind,
      serverText: failure.kind == ApiFailureKind.offline ||
              failure.kind == ApiFailureKind.timeout
          // Для пропавшей связи заготовка экрана («не удалось загрузить»)
          // хуже, чем честное «нет связи» из общего словаря: подставлять её
          // нечего.
          ? null
          : fallbackMessage,
      code: failure.code,
    );
  }
}
