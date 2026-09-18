/// Таджикские названия месяцев и дней недели.
///
/// В таблицах CLDR, из которых `intl` берёт календарь, таджикского нет
/// вовсе. До сих пор мы подставляли вместо него русский: на таджикском
/// экране рядом с таджикскими подписями стояло «14 сентября». Читаемо, но
/// это ровно то место, где приложение переставало быть таджикским.
///
/// `intl` умеет принимать чужую локаль — [initializeDateFormattingCustom].
/// Вызывать её нужно **после** обычной инициализации: она заполняет таблицы
/// только если те ещё пусты, и обратный порядок стёр бы все встроенные
/// языки.
///
/// Изафет учтён механизмом самого `intl`: [DateSymbols.MONTHS] — форма в
/// составе даты («14 сентябри 2026»), [DateSymbols.STANDALONEMONTHS] — форма
/// сама по себе («Сентябр 2026»). Это разные слова в таджикском, и раньше
/// выбрать между ними было нечем.
library;

import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbols.dart';


/// Месяц в составе даты: после числа он берёт изафетное «-и».
const _months = [
  'январи',
  'феврали',
  'марти',
  'апрели',
  'майи',
  'июни',
  'июли',
  'августи',
  'сентябри',
  'октябри',
  'ноябри',
  'декабри',
];

/// Месяц сам по себе — в заголовке листа, в выборе месяца.
const _standaloneMonths = [
  'Январ',
  'Феврал',
  'Март',
  'Апрел',
  'Май',
  'Июн',
  'Июл',
  'Август',
  'Сентябр',
  'Октябр',
  'Ноябр',
  'Декабр',
];

const _shortMonths = [
  'янв',
  'фев',
  'мар',
  'апр',
  'май',
  'июн',
  'июл',
  'авг',
  'сен',
  'окт',
  'ноя',
  'дек',
];

const _narrowMonths = [
  'Я',
  'Ф',
  'М',
  'А',
  'М',
  'И',
  'И',
  'А',
  'С',
  'О',
  'Н',
  'Д',
];

/// Дни недели, начиная с воскресенья, — так их ждёт `intl`.
const _weekdays = [
  'якшанбе',
  'душанбе',
  'сешанбе',
  'чоршанбе',
  'панҷшанбе',
  'ҷумъа',
  'шанбе',
];

const _standaloneWeekdays = [
  'Якшанбе',
  'Душанбе',
  'Сешанбе',
  'Чоршанбе',
  'Панҷшанбе',
  'Ҷумъа',
  'Шанбе',
];

const _shortWeekdays = ['яшб', 'дшб', 'сшб', 'чшб', 'пшб', 'ҷум', 'шнб'];

const _narrowWeekdays = ['Я', 'Д', 'С', 'Ч', 'П', 'Ҷ', 'Ш'];

/// Формы записи даты. За основу взяты русские — порядок «день месяц год» в
/// Таджикистане тот же, — но без русского «г.» в конце: год по-таджикски
/// сокращается «с.» (сол), а в короткой записи не подписывается вовсе.
const _patterns = {
  'd': 'd',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
  'LLLL': 'LLLL',
  'M': 'L',
  'Md': 'dd.MM',
  'MEd': 'EEE, dd.MM',
  'MMM': 'LLL',
  'MMMd': 'd MMM',
  'MMMEd': 'ccc, d MMM',
  'MMMM': 'LLLL',
  'MMMMd': 'd MMMM',
  'MMMMEEEEd': 'cccc, d MMMM',
  'QQQ': 'QQQ',
  'QQQQ': 'QQQQ',
  'y': 'y',
  'yM': 'MM.y',
  'yMd': 'dd.MM.y',
  'yMEd': 'ccc, dd.MM.y',
  'yMMM': 'LLL y',
  'yMMMd': 'd MMM y',
  'yMMMEd': 'EEE, d MMM y',
  'yMMMM': 'LLLL y',
  'yMMMMd': 'd MMMM y',
  'yMMMMEEEEd': 'EEEE, d MMMM y',
  'yQQQ': 'QQQ y',
  'yQQQQ': 'QQQQ y',
  'H': 'HH',
  'Hm': 'HH:mm',
  'Hms': 'HH:mm:ss',
  'j': 'HH',
  'jm': 'HH:mm',
  'jms': 'HH:mm:ss',
  'jmv': 'HH:mm v',
  'jmz': 'HH:mm z',
  'jz': 'HH z',
  'm': 'm',
  'ms': 'mm:ss',
  's': 's',
  'v': 'v',
  'z': 'z',
  'zzzz': 'zzzz',
  'ZZZZ': 'ZZZZ',
};

/// Научить `intl` таджикскому календарю.
///
/// Вызывается один раз при запуске — **после** `initializeDateFormatting`,
/// иначе встроенные языки будут стёрты. Повторный вызов безвреден: данные
/// просто перезаписываются теми же.
void registerTajikDates() {
  initializeDateFormattingCustom(
    locale: 'tg',
    patterns: _patterns,
    symbols: DateSymbols(
      NAME: 'tg',
      ERAS: const ['п.м.', 'м.'],
      ERANAMES: const ['пеш аз милод', 'милодӣ'],
      NARROWMONTHS: _narrowMonths,
      STANDALONENARROWMONTHS: _narrowMonths,
      MONTHS: _months,
      STANDALONEMONTHS: _standaloneMonths,
      SHORTMONTHS: _shortMonths,
      STANDALONESHORTMONTHS: _shortMonths,
      WEEKDAYS: _weekdays,
      STANDALONEWEEKDAYS: _standaloneWeekdays,
      SHORTWEEKDAYS: _shortWeekdays,
      STANDALONESHORTWEEKDAYS: _shortWeekdays,
      NARROWWEEKDAYS: _narrowWeekdays,
      STANDALONENARROWWEEKDAYS: _narrowWeekdays,
      SHORTQUARTERS: const ['С1', 'С2', 'С3', 'С4'],
      QUARTERS: const [
        'Семоҳаи 1',
        'Семоҳаи 2',
        'Семоҳаи 3',
        'Семоҳаи 4',
      ],
      // Время в приложении везде 24-часовое, но поля обязательны.
      AMPMS: const ['ПН', 'БН'],
      DATEFORMATS: const [
        'EEEE, d MMMM y',
        'd MMMM y',
        'd MMM y',
        'dd.MM.y',
      ],
      TIMEFORMATS: const [
        'HH:mm:ss zzzz',
        'HH:mm:ss z',
        'HH:mm:ss',
        'HH:mm',
      ],
      DATETIMEFORMATS: const ['{1}, {0}', '{1}, {0}', '{1}, {0}', '{1}, {0}'],
      // Неделя начинается с понедельника, выходные — суббота и воскресенье
      // (нумерация `intl`: понедельник — ноль).
      FIRSTDAYOFWEEK: 0,
      WEEKENDRANGE: const [5, 6],
      FIRSTWEEKCUTOFFDAY: 3,
    ),
  );
}
