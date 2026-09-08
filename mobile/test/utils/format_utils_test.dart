import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/utils/date_labels.dart';
import 'package:mobile/core/utils/format_utils.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ru'));

  group('Ввод чисел', () {
    test('запятая как разделитель — обычный русский ввод', () {
      expect(parseDecimal('150,50'), 150.5);
      expect(parseDecimal('0,5'), 0.5);
    });

    test('точка тоже принимается', () {
      expect(parseDecimal('150.50'), 150.5);
      expect(parseDecimal('42'), 42);
    });

    test('разделители разрядов не мешают', () {
      expect(parseDecimal('1 250,75'), 1250.75);
      expect(parseDecimal('1 250'), 1250);
    });

    test('пустая строка — это отсутствие значения, а не ошибка', () {
      expect(parseDecimal(''), isNull);
      expect(parseDecimal('   '), isNull);
      expect(parseDecimal(null), isNull);
    });

    test('мусор не превращается в число', () {
      expect(parseDecimal('сто рублей'), isNull);
      expect(parseDecimal('12abc'), isNull);
    });
  });

  group('Просроченность считается по дню', () {
    final now = DateTime(2026, 8, 23, 8, 0);

    test('задача на сегодняшнюю полночь утром ещё не просрочена', () {
      expect(isOverdue(DateTime(2026, 8, 23), now: now), isFalse);
    });

    test('вчерашняя задача просрочена', () {
      expect(isOverdue(DateTime(2026, 8, 22, 23, 59), now: now), isTrue);
    });

    test('завтрашняя — нет', () {
      expect(isOverdue(DateTime(2026, 8, 24), now: now), isFalse);
    });
  });

  group('Денежный формат', () {
    test('разряды разделены, копейки не показываются', () {
      expect(formatMoney(1250), '1${' '}250 с');
      expect(formatMoney(0), '0 с');
    });

    test('валюта сервиса — сомони, и знак берётся из одного места', () {
      // Знак был вписан руками в четырёх местах и везде стоял рубль.
      // Проверка привязывает формат к константе: поменяется она — поменяются
      // и суммы, а не разъедутся с формами.
      expect(kCurrencySymbol, 'с');
      expect(formatMoney(42), endsWith(kCurrencySymbol));
    });
  });
}
