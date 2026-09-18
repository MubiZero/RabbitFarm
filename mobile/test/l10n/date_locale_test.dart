import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:mobile/core/l10n/date_locale.dart';

/// Даты обязаны говорить на языке читателя.
///
/// Помощник `date_locale.dart` лежал в проекте с самого начала и применялся
/// в шести местах из тридцати восьми: в остальных локаль была написана
/// строкой `'ru'`, и узбекский экран показывал «14 сентября» рядом с
/// узбекскими подписями.
void main() {
  setUpAll(() => initializeDateFormatting('ru'));

  testWidgets('месяц называется на языке экрана', (tester) async {
    final byLocale = <String, String>{};

    for (final code in ['ru', 'uz', 'en']) {
      await tester.pumpWidget(
        Localizations(
          locale: Locale(code),
          delegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          child: Builder(
            builder: (context) {
              byLocale[code] = DateFormat('d MMMM', dateLocaleOf(context))
                  .format(DateTime(2026, 9, 14));
              return const SizedBox();
            },
          ),
        ),
      );
    }

    expect(byLocale['ru'], contains('сентября'));
    expect(byLocale['uz'], isNot(byLocale['ru']));
    expect(byLocale['en'], contains('September'));
  });

  test('жёсткая русская локаль в экранах не заводится заново', () {
    // Сторож на класс ошибок, а не на один экран: локаль дописывали строкой
    // по одному месту за раз, и глазами такое не ловится.
    final offenders = <String>[];
    final pattern = RegExp(r"DateFormat\([^)]*'ru'\)");

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path.contains('generated')) continue;

      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (pattern.hasMatch(lines[i])) {
          offenders.add('${entity.path}:${i + 1}: ${lines[i].trim()}');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'возьмите локаль читателя — dateLocaleOf(context):\n'
          '${offenders.join('\n')}',
    );
  });

  test('сторож действительно ловит строку, а не смотрит мимо', () {
    // Проверка от обратного: предыдущий сторож в этом репозитории — на
    // узбекские апострофы — был зелёным и пропускал строку.
    final pattern = RegExp(r"DateFormat\([^)]*'ru'\)");

    expect(pattern.hasMatch("DateFormat('d MMMM', 'ru').format(date)"), isTrue);
    expect(
      pattern.hasMatch("DateFormat('d MMMM', dateLocaleOf(context))"),
      isFalse,
    );
  });
}
