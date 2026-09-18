import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/core/l10n/error_text.dart';
import 'package:mobile/l10n/generated/app_localizations.dart';

/// Сервер пишет отказы по-русски: «Токен не передан», «Кролик не найден».
/// Узбекскому фермеру это стена, и узнать из неё, что делать дальше, нельзя.
///
/// Поэтому каждый отказ уезжает с машинным кодом, а слова подбирает
/// приложение — на языке того, кто читает. Тест сторожит ровно это: новый
/// код на сервере без перевода снова покажет русскую фразу узбекскому
/// экрану, и заметить это глазами некому.
///
/// Коды, которых здесь нет намеренно, перечислены в [_dynamic]: там текст
/// собирает не наш код (шлюз оплаты, проверки моделей), и подменять его
/// общей фразой значило бы потерять единственную подробность.
void main() {
  final backend = Directory('../backend/src');

  Set<String> serverCodes() {
    final codes = <String>{};
    final call = RegExp(
      r"ApiResponse\.(?:badRequest|conflict|forbidden|notFound|unauthorized|"
      r"error)\(\s*res,[\s\S]{0,400}?'([A-Z][A-Z_0-9]{3,})'\s*[,)]",
      multiLine: true,
    );

    for (final file in backend.listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.js')) continue;
      for (final match in call.allMatches(file.readAsStringSync())) {
        codes.add(match.group(1)!);
      }
    }
    return codes;
  }

  test('каждый отказ сервера читается на языке интерфейса', () async {
    final codes = serverCodes();
    // Сторож самого сторожа: если разбор файлов сервера сломается, тест
    // позеленеет на пустом списке и дыру покажет уже фермер.
    expect(codes.length, greaterThan(90),
        reason: 'кодов нашлось подозрительно мало — сломался разбор');

    // Узбекский — язык, на котором дыра видна сразу: в нём нет ни одного
    // русского слова, в отличие от таджикского экрана.
    final l10n = await AppLocalizations.delegate.load(const Locale('uz'));
    const serverText = 'русский текст сервера';

    final untranslated = <String>[];
    for (final code in codes) {
      if (_dynamic.contains(code)) continue;
      final shown = errorText(
        l10n,
        ApiFailure(ApiFailureKind.invalid, code: code, serverText: serverText),
      );
      if (shown == serverText) untranslated.add(code);
    }

    expect(
      untranslated..sort(),
      isEmpty,
      reason: 'эти коды сервер шлёт, а перевода к ним нет — узбекский экран '
          'покажет русскую фразу',
    );
  });
}

/// Отказы, текст которых сервер не пишет сам.
const _dynamic = {
  // Ответ платёжного шлюза: там своя формулировка отказа по карте.
  'ORDER_DECLINED',
  // Проверки модели Sequelize: сообщение собирается из имени поля и предела.
  'VALIDATION_ERROR',
  // Общая ошибка сервера: наружу уходит либо «внутренняя ошибка», либо
  // подробность из окружения разработчика.
  'SERVER_ERROR',
  'CONFLICT',
};
