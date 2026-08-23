import 'package:intl/intl.dart';

final _money = NumberFormat('#,##0', 'ru_RU');
final _quantity = NumberFormat('#,##0.##', 'ru_RU');

/// Денежная сумма с разделителями разрядов: «1 250 ₽».
/// Копейки в отчётах не показываем — на суммах фермы они только мешают читать.
String formatMoney(num amount) => '${_money.format(amount)} ₽';

/// Количество с разделителями и до двух знаков после запятой: «12,5 кг».
String formatQuantity(num value, [String? unit]) {
  final formatted = _quantity.format(value);
  return unit == null ? formatted : '$formatted $unit';
}

/// «1 операция» / «3 операции» / «37 операций».
/// Плюрализацию отдаём intl, а не собственной таблице окончаний.
String formatOperations(int count) => Intl.plural(
      count,
      one: '$count операция',
      few: '$count операции',
      many: '$count операций',
      other: '$count операции',
      locale: 'ru',
    );

/// «1 задача» / «3 задачи» / «12 задач».
String formatTasks(int count) => Intl.plural(
      count,
      one: '$count задача',
      few: '$count задачи',
      many: '$count задач',
      other: '$count задачи',
      locale: 'ru',
    );

/// «1 прививка» / «2 прививки» / «5 прививок».
String formatVaccinations(int count) => Intl.plural(
      count,
      one: '$count прививка',
      few: '$count прививки',
      many: '$count прививок',
      other: '$count прививки',
      locale: 'ru',
    );

/// «1 вид корма» / «2 вида корма» / «5 видов корма».
String formatFeedKinds(int count) => Intl.plural(
      count,
      one: '$count вид корма',
      few: '$count вида корма',
      many: '$count видов корма',
      other: '$count вида корма',
      locale: 'ru',
    );

/// «1 кролик» / «2 кролика» / «7 кроликов».
String formatRabbits(int count) => Intl.plural(
      count,
      one: '$count кролик',
      few: '$count кролика',
      many: '$count кроликов',
      other: '$count кролика',
      locale: 'ru',
    );

/// «1 запись» / «2 записи» / «9 записей».
String formatRecords(int count) => Intl.plural(
      count,
      one: '$count запись',
      few: '$count записи',
      many: '$count записей',
      other: '$count записи',
      locale: 'ru',
    );
