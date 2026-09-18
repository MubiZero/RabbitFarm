import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:mobile/core/l10n/date_locale.dart';
import 'package:mobile/core/l10n/tajik_dates.dart';

/// Таджикского календаря в `intl` нет, и до сих пор мы подставляли русский:
/// на таджикском экране рядом с таджикскими подписями стояло «14 сентября».
void main() {
  setUpAll(() {
    // Порядок важен: свой язык добавляется только после обычной
    // инициализации, иначе она сотрёт встроенные.
    initializeDateFormatting('ru');
    registerTajikDates();
  });

  final september = DateTime(2026, 9, 14);

  test('месяц в составе даты стоит в изафете', () {
    // «14 сентябри 2026» — так дату и читают вслух; «14 сентябр 2026» было бы
    // сломанной грамматикой, а «14 сентября» — чужим языком.
    expect(
      DateFormat('d MMMM y', 'tg').format(september),
      '14 сентябри 2026',
    );
  });

  test('месяц сам по себе стоит в основной форме', () {
    // Заголовок листа и выбор месяца — это не дата, и изафет там не нужен.
    expect(DateFormat('LLLL y', 'tg').format(september), 'Сентябр 2026');
  });

  test('день недели назван по-таджикски', () {
    // Сам по себе — с большой буквы, в составе даты — с маленькой: это те же
    // две формы, что у месяца, и `intl` их различает.
    expect(DateFormat('EEEE', 'tg').format(september), 'Душанбе');
    expect(
      DateFormat('EEEE, d MMMM', 'tg').format(september),
      'душанбе, 14 сентябри',
    );
    expect(DateFormat('d MMM', 'tg').format(september), '14 сен');
  });

  test('русский не подставляется вместо таджикского', () {
    final tg = DateFormat('d MMMM y', 'tg').format(september);
    final ru = DateFormat('d MMMM y', 'ru').format(september);

    expect(tg, isNot(ru));
    expect(tg, isNot(contains('сентября')));
  });

  test('встроенные языки при этом не пострадали', () {
    // Своя локаль регистрируется тем же механизмом, который умеет стереть
    // все остальные, если вызвать его раньше времени.
    expect(DateFormat('d MMMM y', 'ru').format(september), '14 сентября 2026');
    expect(DateFormat('d MMMM y', 'en').format(september), '14 September 2026');
  });

  test('помощник локали больше не уводит таджикский в русский', () {
    expect(dateSymbolsLocale(const Locale('tg')), 'tg');
    expect(dateSymbolsLocale(const Locale('uz')), 'uz');
  });
}
