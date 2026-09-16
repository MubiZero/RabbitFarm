import 'package:flutter/widgets.dart';

import '../l10n/l10n_context.dart';
import 'countries.dart';

/// Название страны на языке экрана.
///
/// В справочнике стран названий нет намеренно: писать их там пришлось бы
/// латиницей, и таджикский фермер читал бы «Tajikistan» вместо
/// «Тоҷикистон». Переводы живут там же, где остальные слова приложения.
String countryName(BuildContext context, String code) {
  final l10n = context.l10n;
  return switch (code) {
    'TJ' => l10n.countryTJ,
    'UZ' => l10n.countryUZ,
    'KG' => l10n.countryKG,
    'KZ' => l10n.countryKZ,
    'RU' => l10n.countryRU,
    'AF' => l10n.countryAF,
    // Незнакомый код показываем как есть, а не подменяем Таджикистаном:
    // назвать чужую страну чужим именем хуже, чем показать две буквы.
    _ => code,
  };
}

/// Подпись под названием: чем считают деньги и как входят.
///
/// Человек выбирает страну один раз и последствия видит потом, поэтому
/// сказать о них лучше здесь, а не после регистрации.
String countryHint(BuildContext context, Country country) {
  final money = country.currencySymbol;
  return country.sms
      ? '$money · ${context.l10n.loginPhoneLabel}'
      : '$money · ${context.l10n.commonEmail}';
}
