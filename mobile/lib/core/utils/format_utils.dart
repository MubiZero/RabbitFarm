import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n_context.dart';

final _money = NumberFormat('#,##0', 'ru_RU');
final _quantity = NumberFormat('#,##0.##', 'ru_RU');

/// Валюта сервиса — сомони.
///
/// Это валюта, в которой хозяйство платит нам за подписку: тарифы считаются
/// в сомони всегда, независимо от страны фермы, потому что продаём мы отсюда.
///
/// Деньги самого хозяйства — другое дело: они считаются в валюте его страны
/// (см. `FarmCurrencyScope` и `context.money`). Раньше разницы не было —
/// сервис был одной страной, — и знак стоял здесь один на всё.
const String kCurrencySymbol = 'с';

/// Денежная сумма с разделителями разрядов: «1 250 с».
///
/// Знак передаётся явно: у хозяйства он свой, у тарифа — наш. Умолчание
/// оставлено сомони для тарифов и тех мест, где валюты хозяйства рядом нет.
/// Копейки в отчётах не показываем — на суммах фермы они только мешают читать.
String formatMoney(num amount, [String symbol = kCurrencySymbol]) =>
    '${_money.format(amount)} $symbol';

/// Количество с разделителями и до двух знаков после запятой: «12,5 кг».
String formatQuantity(num value, [String? unit]) {
  final formatted = _quantity.format(value);
  return unit == null ? formatted : '$formatted $unit';
}

// Счётные фразы («1 задача» / «5 задач») переехали в файл переводов:
// окончания зависят от языка, и в приложении для них есть ICU-плюрал —
// `context.l10n.countTasks(n)`. Держать их здесь значило бы вести
// собственную таблицу окончаний параллельно готовому механизму.

/// Раскладывает размер в байтах на число и степень 1024: 15 728 640 → (15, 2),
/// то есть «15 МБ».
///
/// Приставку подставляет вызывающая сторона из словаря: «МБ» на других языках
/// пишется иначе, а само деление от языка не зависит. Делим по 1024, а не по
/// 1000, — так же считает занятое место сама система, и расхождение с ней
/// читалось бы как ошибка учёта.
({double value, int power}) scaleBytes(int bytes) {
  var value = bytes.abs().toDouble();
  var power = 0;
  while (value >= 1024 && power < 3) {
    value /= 1024;
    power++;
  }
  return (value: bytes.isNegative ? -value : value, power: power);
}

/// Занятое место человеческим языком: «15 МБ». Приставка — из словаря
/// (на других языках пишется иначе), деление — [scaleBytes]. Общая для
/// карточки фермы и сводки платформы, чтобы одно и то же число не считалось
/// в двух местах по-разному после первой же правки одного из них.
String storageLabel(BuildContext context, int bytes) {
  final scaled = scaleBytes(bytes);
  final unit = switch (scaled.power) {
    0 => context.l10n.storageUnitBytes,
    1 => context.l10n.storageUnitKb,
    2 => context.l10n.storageUnitMb,
    _ => context.l10n.storageUnitGb,
  };
  return formatQuantity(scaled.value, unit);
}

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
