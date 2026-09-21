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
    // Незнакомый код показываем как есть, а не подменяем Таджикистаном:
    // назвать чужую страну чужим именем хуже, чем показать две буквы.
    _ => code,
  };
}

/// Подпись под названием страны — о том, что человеку с этого будет.
///
/// Раньше здесь стояло «с · Телефон»: знак валюты и способ входа через
/// точку. Это запись для нас, а не ответ человеку, который первый раз видит
/// приложение. Валюта из страны и так следует, а вот куда придёт код —
/// единственное, что меняет его следующий шаг.
String countryHint(BuildContext context, Country country) {
  return country.sms ? context.l10n.onbCountrySms : context.l10n.onbCountryEmail;
}
