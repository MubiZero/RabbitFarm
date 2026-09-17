import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/core/l10n/error_text.dart';
import 'package:mobile/l10n/generated/app_localizations.dart';
import 'package:mobile/l10n/generated/app_localizations_ru.dart';
import 'package:mobile/l10n/generated/app_localizations_tg.dart';

/// Ошибка должна быть на языке читателя.
///
/// Тексты отказов сервер пишет по-русски (`utils/apiResponse.js`), а клиент
/// показывал их дословно — на таджикском и узбекском экране человек получал
/// русскую фразу. При этом язык читателя сервер знает, но пользуется им
/// только для push-уведомлений.
void main() {
  final ru = AppLocalizationsRu();
  final tg = AppLocalizationsTg();

  group('перевод по коду отказа', () {
    test('знакомый код переводится, русский текст сервера не показывается', () {
      const failure = ApiFailure(
        ApiFailureKind.invalid,
        serverText: 'Достигнут лимит кроликов по тарифу фермы',
        code: 'RABBIT_LIMIT_REACHED',
      );

      expect(errorText(tg, failure), tg.errorCodeRabbitLimitReached);
      expect(errorText(tg, failure), isNot(contains('лимит')));
    });

    test('на русском выходит русский перевод, а не текст сервера', () {
      const failure = ApiFailure(
        ApiFailureKind.notFound,
        serverText: 'Клетка не найдена',
        code: 'CAGE_NOT_FOUND',
      );

      expect(errorText(ru, failure), ru.errorCodeCageNotFound);
    });
  });

  group('конкретика не теряется', () {
    test('незнакомый код — показываем подробность сервера', () {
      // Она конкретнее нашей заготовки: «свободно: 2» знает только сервер.
      const failure = ApiFailure(
        ApiFailureKind.invalid,
        serverText: 'Недостаточно места в клетке матери (свободно: 2)',
        code: 'SOME_NEW_CODE',
      );

      expect(errorText(ru, failure), contains('свободно: 2'));
    });

    test('ни кода, ни текста — общее описание по виду отказа', () {
      const failure = ApiFailure(ApiFailureKind.offline);
      expect(errorText(ru, failure), ru.errorOffline);
    });
  });

  group('служебные слова наружу не выходят', () {
    test('обёртка Dart снимается', () {
      final text = errorText(ru, Exception('что-то пошло не так'));
      expect(text, 'что-то пошло не так');
      expect(text, isNot(contains('Exception')));
    });

    test('пустая ошибка не даёт пустой строки на экране', () {
      expect(errorText(ru, null), ru.commonUnknownError);
    });
  });

  test('все переведённые коды и правда разные на разных языках', () {
    // Защита от копии: если перевод забыли и подставили русский, тест это
    // покажет — именно так в этом репозитории уже жил «паритет» из копий.
    final pairs = <String, String>{
      ru.errorCodeCageFull: tg.errorCodeCageFull,
      ru.errorCodeTagIdExists: tg.errorCodeTagIdExists,
      ru.errorCodeInsufficientStock: tg.errorCodeInsufficientStock,
    };

    for (final entry in pairs.entries) {
      expect(entry.key, isNot(entry.value));
    }
  });
}
