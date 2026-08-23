import '../../l10n/generated/app_localizations.dart';
import '../api/api_failure.dart';

/// Текст ошибки для человека.
///
/// Подробность сервера идёт вперёд общего описания: он знает про ферму то,
/// чего не знает клиент («Клетка №3 занята» вместо «Сервер не принял данные»).
/// Переводы передаются значением, а не через `BuildContext`: текст ошибки
/// собирается после `await`, когда обращаться к контексту уже небезопасно.
String errorText(AppLocalizations l10n, Object? error) {
  if (error is ApiFailure) {
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
