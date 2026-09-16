import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../domain/kindling_plan.dart';

/// Бумажный план окролов на месяц — один лист, который вешают в сарае.
///
/// Лист собирается разметкой, а не виджетами пакета `pdf`: встроенные в PDF
/// шрифты кириллицы не знают, и таджикские строки вышли бы рядом пустых
/// прямоугольников. Разметку в PDF переводит сама платформа своими шрифтами,
/// поэтому русский, таджикский и узбекский печатаются как есть.
///
/// Чистая функция: то, что попадёт на бумагу, проверяется тестом без печати.
String buildKindlingPlanHtml({
  required List<KindlingPlanRow> rows,
  required DateTime month,
  required AppLocalizations l10n,
  required String dateLocale,
  DateTime? printedAt,
}) {
  final monthName = DateFormat('LLLL y', dateLocale).format(month);
  // Окрол ищут по дню недели не меньше, чем по числу: «в понедельник» — это
  // то, как фермер планирует свою неделю.
  final birthDay = DateFormat('d MMM, EEE', dateLocale);
  final shortDay = DateFormat('d MMM', dateLocale);
  final printedDay = DateFormat('d MMM y', dateLocale);

  final body = StringBuffer();
  for (final row in rows) {
    final bred = row.breedingDate;
    body.write(
      '<tr>'
      '<td class="day">${_esc(birthDay.format(row.birthDate))}</td>'
      '<td class="female">${_esc(row.female)}</td>'
      '<td class="center">${_esc(row.cage ?? _dash)}</td>'
      '<td class="center">${bred == null ? _dash : _esc(shortDay.format(bred))}</td>'
      '<td class="nest">${_esc(shortDay.format(row.nestBoxDate))}</td>'
      '<td class="tick"><span class="box"></span></td>'
      '</tr>',
    );
  }

  return '<!DOCTYPE html>'
      '<html><head><meta charset="utf-8">'
      '<style>$_css</style>'
      '</head><body>'
      '<h1>${_esc(l10n.kindlingPlanSheetTitle(monthName))}</h1>'
      '<p class="hint">${_esc(l10n.kindlingPlanNestHint)}</p>'
      '<table>'
      '<thead><tr>'
      '<th>${_esc(l10n.kindlingPlanColBirth)}</th>'
      '<th>${_esc(l10n.kindlingPlanColFemale)}</th>'
      '<th>${_esc(l10n.kindlingPlanColCage)}</th>'
      '<th>${_esc(l10n.kindlingPlanColBred)}</th>'
      '<th>${_esc(l10n.kindlingPlanColNest)}</th>'
      '<th>${_esc(l10n.kindlingPlanColMark)}</th>'
      '</tr></thead>'
      '<tbody>$body</tbody>'
      '</table>'
      '<p class="printed">'
      '${_esc(l10n.kindlingPlanPrintedAt(printedDay.format(printedAt ?? DateTime.now())))}'
      '</p>'
      '</body></html>';
}

/// Лист печатают на обычном чёрно-белом принтере, поэтому всё держится на
/// линиях и жирности, а не на цвете. Строки высокие — в них ставят галочку
/// карандашом, а читают лист издалека, от клетки.
const _css = '''
@page { size: A4 portrait; margin: 12mm; }
/* Лист печатают с телефона, а телефон часто в тёмной теме: без этих двух
   строк системный движок сам перекрашивает страницу и на бумагу уходит
   чёрный фон — целый картридж на один лист. */
:root { color-scheme: light; }
body { font-family: Arial, Helvetica, sans-serif; color: #000; background: #fff; margin: 0; }
h1 { font-size: 20pt; margin: 0 0 2mm; }
.hint { font-size: 11pt; margin: 0 0 5mm; }
table { width: 100%; border-collapse: collapse; font-size: 12pt; }
/* Шапка повторяется на каждом листе: план на месяц не всегда влезает в один. */
thead { display: table-header-group; }
tr { page-break-inside: avoid; }
th, td { border: 1px solid #000; padding: 3mm 2mm; text-align: left; }
th { font-size: 11pt; text-transform: uppercase; }
td { height: 9mm; }
.day { white-space: nowrap; font-weight: bold; }
.female { font-weight: bold; }
.center { text-align: center; white-space: nowrap; }
/* Срок маточника — главное, ради чего лист висит на гвозде. */
.nest { text-align: center; white-space: nowrap; font-weight: bold; }
.tick { width: 18mm; }
.box { display: block; width: 7mm; height: 7mm; border: 1px solid #000; margin: 0 auto; }
.printed { font-size: 9pt; margin-top: 4mm; }
''';

/// Прочерк вместо пустоты: пустая клетка на бумаге читается как «забыли
/// напечатать», прочерк — как «данных нет».
const _dash = '—';

/// Кличка кролика приходит из базы и может содержать любой символ — без
/// экранирования одна такая кличка развалила бы вёрстку всего листа.
String _esc(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
