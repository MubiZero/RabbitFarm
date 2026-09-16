import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Узбекский пишется латиницей, и в нём два разных знака, похожих на
/// апостроф: `ʻ` (U+02BB) в `oʻ`/`gʻ` — это часть буквы, и `ʼ` (U+02BC) —
/// гортанная смычка в словах вроде `maʼlum`. Обычная ASCII-кавычка `'` —
/// подмена, к тому же в ARB её приходится удваивать, и `Qo''shish` стоит
/// рядом с `Qoʻshish` в одном файле: одно слово выглядит по-разному на
/// разных экранах.
///
/// Тест сторожит файл целиком, а не отдельные строки: расхождение вносится
/// по одной строке за раз и глазами не ловится.
void main() {
  test('в узбекском нет ASCII-кавычки вместо ʻ и ʼ', () {
    final file = File('lib/l10n/app_uz.arb');
    expect(file.existsSync(), isTrue, reason: 'не найден lib/l10n/app_uz.arb');

    final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    // В ARB включено use-escaping, поэтому одиночная кавычка внутри текста
    // выглядит как две подряд.
    final wrong = RegExp(r"[a-zA-Z]''[a-zA-Z]");

    final offenders = <String>[];
    data.forEach((key, value) {
      if (key.startsWith('@') || value is! String) return;
      if (wrong.hasMatch(value)) offenders.add('$key: $value');
    });

    expect(
      offenders,
      isEmpty,
      reason:
          'используйте ʻ (U+02BB) в oʻ/gʻ и ʼ (U+02BC) для гортанной смычки:\n'
          '${offenders.join('\n')}',
    );
  });

  test('знаки не перепутаны местами', () {
    final data = jsonDecode(File('lib/l10n/app_uz.arb').readAsStringSync())
        as Map<String, dynamic>;

    final swapped = <String>[];
    data.forEach((key, value) {
      if (key.startsWith('@') || value is! String) return;
      // После o и g идёт только модификатор ʻ — гортанная смычка там
      // невозможна.
      if (RegExp('[oOgG]ʼ').hasMatch(value)) swapped.add('$key: $value');
    });

    expect(swapped, isEmpty,
        reason: 'после o и g должен стоять ʻ, а не ʼ:\n'
            '${swapped.join('\n')}');
  });
}
