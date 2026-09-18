/// Книга доходов и расходов за срок — лист, который носят в банк.
///
/// За кредитом и за субсидией просят бумагу: сколько пришло, сколько ушло,
/// чем подтверждается. До сих пор деньги из приложения не доставались ни
/// печатью, ни файлом — их переписывали в тетрадь руками.
///
/// Чистые функции: и бумага, и таблица проверяются тестом без принтера.
/// Разметка, а не виджеты пакета `pdf`, — в его встроенных шрифтах нет
/// кириллицы (см. `core/printing/print_html.dart`).
library;

import 'package:intl/intl.dart';

import '../../../../core/export/csv.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../data/models/transaction_model.dart';


class FinanceSheetTotals {
  const FinanceSheetTotals({
    required this.income,
    required this.expense,
  });

  final double income;
  final double expense;

  /// То, ради чего лист и читают: остаток за срок.
  double get balance => income - expense;
}

FinanceSheetTotals totalsOf(List<Transaction> transactions) {
  var income = 0.0;
  var expense = 0.0;
  for (final item in transactions) {
    if (item.type == TransactionType.income) {
      income += item.amount;
    } else {
      expense += item.amount;
    }
  }
  return FinanceSheetTotals(income: income, expense: expense);
}

String buildFinanceSheetHtml({
  required List<Transaction> transactions,
  required DateTime from,
  required DateTime to,
  required AppLocalizations l10n,
  required String dateLocale,
  required String currency,
  required String Function(TransactionCategory category) categoryLabel,
  DateTime? printedAt,
}) {
  final day = DateFormat('d MMM y', dateLocale);
  final totals = totalsOf(transactions);

  String money(double value) => '${csvNumber(value)} $currency';

  final rows = StringBuffer();
  for (final item in transactions) {
    final isIncome = item.type == TransactionType.income;
    rows.write(
      '<tr>'
      '<td class="day">${_esc(day.format(item.transactionDate))}</td>'
      '<td>${_esc(categoryLabel(item.category))}</td>'
      '<td>${_esc(item.description ?? _dash)}</td>'
      // Приход и расход в разных столбцах, а не одним со знаком: так их
      // складывают глазами, и так же устроена тетрадь, из которой сюда
      // пришли.
      '<td class="sum">${isIncome ? _esc(money(item.amount)) : ''}</td>'
      '<td class="sum">${isIncome ? '' : _esc(money(item.amount))}</td>'
      '</tr>',
    );
  }

  return '<!DOCTYPE html>'
      '<html><head><meta charset="utf-8"><style>$_css</style></head><body>'
      '<h1>${_esc(l10n.financeSheetTitle)}</h1>'
      '<p class="period">${_esc(l10n.financeSheetPeriod(day.format(from), day.format(to)))}</p>'
      '<table class="totals"><tbody>'
      '<tr><td>${_esc(l10n.financeIncome)}</td><td class="sum">${_esc(money(totals.income))}</td></tr>'
      '<tr><td>${_esc(l10n.financeExpenses)}</td><td class="sum">${_esc(money(totals.expense))}</td></tr>'
      '<tr class="balance"><td>${_esc(l10n.financeProfit)}</td><td class="sum">${_esc(money(totals.balance))}</td></tr>'
      '</tbody></table>'
      '${transactions.isEmpty ? '<p class="empty">${_esc(l10n.financeSheetEmpty)}</p>' : '<table>'
          '<thead><tr>'
          '<th>${_esc(l10n.financeDate)}</th>'
          '<th>${_esc(l10n.financeCategory)}</th>'
          '<th>${_esc(l10n.financeDescription)}</th>'
          '<th>${_esc(l10n.financeIncome)}</th>'
          '<th>${_esc(l10n.financeExpenses)}</th>'
          '</tr></thead><tbody>$rows</tbody></table>'}'
      '<p class="printed">${_esc(l10n.kindlingPlanPrintedAt(day.format(printedAt ?? DateTime.now())))}</p>'
      '</body></html>';
}

/// Те же операции таблицей — для тех, кто сводит своё в Excel.
String buildFinanceSheetCsv({
  required List<Transaction> transactions,
  required AppLocalizations l10n,
  required String Function(TransactionCategory category) categoryLabel,
  required String Function(TransactionType type) typeLabel,
}) {
  final day = DateFormat('dd.MM.yyyy');

  final rows = <List<String>>[
    [
      l10n.financeDate,
      l10n.financeSheetColKind,
      l10n.financeCategory,
      l10n.financeDescription,
      l10n.txFormAmount,
    ],
  ];

  for (final item in transactions) {
    rows.add([
      day.format(item.transactionDate),
      typeLabel(item.type),
      categoryLabel(item.category),
      item.description ?? '',
      csvNumber(item.amount),
    ]);
  }

  return buildCsv(rows);
}

const _dash = '—';

const _css = '''
@page { size: A4 portrait; margin: 12mm; }
/* Телефон часто в тёмной теме: без этого на бумагу уходит чёрный фон. */
:root { color-scheme: light; }
body { font-family: Arial, Helvetica, sans-serif; color: #000; background: #fff; margin: 0; }
h1 { font-size: 20pt; margin: 0 0 1mm; }
.period { font-size: 12pt; margin: 0 0 4mm; }
.empty { font-size: 11pt; font-style: italic; }
table { width: 100%; border-collapse: collapse; font-size: 11pt; }
thead { display: table-header-group; }
tr { page-break-inside: avoid; }
th, td { border: 1px solid #000; padding: 2mm; text-align: left; }
th { font-size: 10pt; text-transform: uppercase; }
.day { white-space: nowrap; }
.sum { text-align: right; white-space: nowrap; }
/* Итог — отдельной таблицей сверху: в банке смотрят на него, а список
   операций читают потом и не всегда. */
.totals { width: 70mm; margin-bottom: 5mm; font-size: 12pt; }
.totals .balance { font-weight: bold; }
.printed { font-size: 9pt; margin-top: 5mm; }
''';

String _esc(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
