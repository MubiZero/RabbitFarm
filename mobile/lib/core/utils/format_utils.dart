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

// Счётные фразы («1 задача» / «5 задач») переехали в файл переводов:
// окончания зависят от языка, и в приложении для них есть ICU-плюрал —
// `context.l10n.countTasks(n)`. Держать их здесь значило бы вести
// собственную таблицу окончаний параллельно готовому механизму.

/// Разбирает число, введённое человеком.
///
/// На русской раскладке дробную часть отделяют запятой, и `double.parse`
/// на «150,50» падал: форма отвечала «введите корректное число» на совершенно
/// нормальный ввод. Пробелы-разделители разрядов тоже допустимы.
double? parseDecimal(String? raw) {
  if (raw == null) return null;
  final normalized = raw
      .replaceAll('\u00A0', '')
      .replaceAll(' ', '')
      .replaceAll(',', '.')
      .trim();
  if (normalized.isEmpty) return null;
  return double.tryParse(normalized);
}
