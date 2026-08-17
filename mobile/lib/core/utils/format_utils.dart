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
