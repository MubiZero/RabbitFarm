import '../../l10n/generated/app_localizations.dart';
import '../api/api_failure.dart';

/// Текст ошибки для человека.
///
/// Порядок такой: сначала перевод по коду отказа, затем подробность сервера,
/// и только потом общее описание по виду ошибки.
///
/// Код вперёд текста — потому что тексты сервера написаны по-русски
/// (`utils/apiResponse.js`, `validators/messages.js`), и на таджикском или
/// узбекском экране человек получал русскую фразу. Язык читателя сервер
/// знает, но пользуется им только для push-уведомлений.
///
/// Подробность сервера остаётся запасной, а не выбрасывается: он знает про
/// ферму то, чего не знает клиент («Недостаточно места в клетке матери,
/// свободно: 2»), и для кода, которого мы ещё не перевели, русская
/// конкретика полезнее общего «не удалось».
///
/// Переводы передаются значением, а не через `BuildContext`: текст ошибки
/// собирается после `await`, когда обращаться к контексту уже небезопасно.
String errorText(AppLocalizations l10n, Object? error) {
  if (error is ApiFailure) {
    final byCode = _byCode(l10n, error.code);
    if (byCode != null) return byCode;

    final serverText = error.serverText?.trim();
    if (serverText != null && serverText.isNotEmpty) return serverText;

    return switch (error.kind) {
      ApiFailureKind.offline => l10n.errorOffline,
      ApiFailureKind.timeout => l10n.errorTimeout,
      ApiFailureKind.unauthorized => l10n.errorUnauthorized,
      ApiFailureKind.forbidden => l10n.errorForbidden,
      ApiFailureKind.notFound => l10n.errorNotFound,
      ApiFailureKind.invalid => l10n.errorInvalid,
      ApiFailureKind.server => l10n.errorServer,
      ApiFailureKind.unknown => l10n.commonUnknownError,
    };
  }

  // Часть ошибок приходит не с сервера — например сбой разбора ответа.
  // Служебная обёртка Dart для фермера ничего не значит и выглядит поломкой.
  var text = (error?.toString() ?? '').trim();
  for (final prefix in const ['Exception: ', 'DioException: ', 'Error: ']) {
    if (text.startsWith(prefix)) text = text.substring(prefix.length);
  }
  return text.isEmpty ? l10n.commonUnknownError : text;
}

/// Перевод по коду отказа. `null` — код незнакомый, дальше пробуем текст
/// сервера.
String? _byCode(AppLocalizations l10n, String? code) => switch (code) {
      'RABBIT_NOT_FOUND' => l10n.errorCodeRabbitNotFound,
      'CAGE_NOT_FOUND' => l10n.errorCodeCageNotFound,
      'BREED_NOT_FOUND' => l10n.errorCodeBreedNotFound,
      'FEED_NOT_FOUND' => l10n.errorCodeFeedNotFound,
      'TASK_NOT_FOUND' => l10n.errorCodeTaskNotFound,
      'CAGE_FULL' => l10n.errorCodeCageFull,
      'TAG_ID_EXISTS' => l10n.errorCodeTagIdExists,
      'RABBIT_LIMIT_REACHED' => l10n.errorCodeRabbitLimitReached,
      'STAFF_LIMIT_REACHED' => l10n.errorCodeStaffLimitReached,
      'INSUFFICIENT_STOCK' => l10n.errorCodeInsufficientStock,
      'USER_EXISTS' => l10n.errorCodeUserExists,
      'PHONE_EXISTS' => l10n.errorCodePhoneExists,
      'PHONE_LOGIN_UNAVAILABLE' => l10n.errorCodePhoneLoginUnavailable,
      'PAYMENTS_UNAVAILABLE_IN_COUNTRY' =>
        l10n.errorCodePaymentsUnavailableInCountry,
      _ => null,
    };
