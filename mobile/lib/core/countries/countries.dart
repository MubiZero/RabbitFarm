/// Страны, в которых работает сервис.
///
/// Тот же список, что в `backend/src/config/countries.js`, — и это не
/// дублирование ради удобства: страну спрашивают на первом экране, когда
/// приложение ещё ни разу не ходило на сервер, и список должен быть под
/// рукой без сети. Сервер остаётся авторитетом: при регистрации уезжает
/// только код страны, валюту и пояс хозяйству проставляет он.
///
/// Чтобы два списка не разъехались, паритет кодов сторожит тест
/// (`test/countries/country_parity_test.dart`).
///
/// Названия стран лежат в переводах, а не здесь: писать их латиницей в коде
/// значило бы показывать таджикскому фермеру «Tajikistan».
class Country {
  final String code;

  /// Знак валюты — тот, что человек видит рядом с суммой.
  final String currencySymbol;

  /// ISO-код валюты; по нему сервер узнаёт, в чём считает хозяйство.
  final String currencyCode;

  /// Префикс телефона — для маски поля ввода.
  final String phonePrefix;

  /// Язык, который предлагается по умолчанию. Предлагается, а не
  /// назначается: узбекская семья из Согдийской области живёт в
  /// Таджикистане, и язык у неё свой.
  final String defaultLanguage;

  /// Доходит ли сюда код подтверждения. Шлюз таджикский, за пределы страны
  /// сообщение не уходит — там, где `false`, вход по телефону не предлагаем
  /// вовсе, иначе человек ждёт код, который не придёт.
  final bool sms;

  /// Принимаем ли здесь оплату картой. Эквайер — банк «Эсхата», карта
  /// другой страны через него не пройдёт: подписка продлевается через
  /// поддержку, и на экране это сказано прямо.
  final bool payments;

  const Country({
    required this.code,
    required this.currencySymbol,
    required this.currencyCode,
    required this.phonePrefix,
    required this.defaultLanguage,
    required this.sms,
    required this.payments,
  });
}

const kCountries = <Country>[
  Country(
    code: 'TJ',
    currencySymbol: 'с',
    currencyCode: 'TJS',
    phonePrefix: '+992',
    defaultLanguage: 'tg',
    sms: true,
    payments: true,
  ),
  Country(
    code: 'UZ',
    currencySymbol: 'soʻm',
    currencyCode: 'UZS',
    phonePrefix: '+998',
    defaultLanguage: 'uz',
    sms: false,
    payments: false,
  ),
  Country(
    code: 'KG',
    currencySymbol: 'сом',
    currencyCode: 'KGS',
    phonePrefix: '+996',
    defaultLanguage: 'ru',
    sms: false,
    payments: false,
  ),
  Country(
    code: 'KZ',
    currencySymbol: '₸',
    currencyCode: 'KZT',
    phonePrefix: '+7',
    defaultLanguage: 'ru',
    sms: false,
    payments: false,
  ),
  Country(
    code: 'RU',
    currencySymbol: '₽',
    currencyCode: 'RUB',
    phonePrefix: '+7',
    defaultLanguage: 'ru',
    sms: false,
    payments: false,
  ),
  Country(
    code: 'AF',
    currencySymbol: '؋',
    currencyCode: 'AFN',
    phonePrefix: '+93',
    defaultLanguage: 'tg',
    sms: false,
    payments: false,
  ),
];

/// Страна по умолчанию: сервис вырос из таджикских хозяйств.
const kDefaultCountryCode = 'TJ';

/// Страна по коду. Незнакомый код не роняет экран и не выдумывает значений —
/// отдаёт таджикские, как и сервер.
Country countryByCode(String? code) {
  final wanted = (code ?? '').toUpperCase();
  for (final country in kCountries) {
    if (country.code == wanted) return country;
  }
  return kCountries.firstWhere((c) => c.code == kDefaultCountryCode);
}

/// Знак валюты по её ISO-коду — для сумм хозяйства, чья страна неизвестна.
String currencySymbolByCode(String? currencyCode) {
  final wanted = (currencyCode ?? '').toUpperCase();
  for (final country in kCountries) {
    if (country.currencyCode == wanted) return country.currencySymbol;
  }
  return countryByCode(kDefaultCountryCode).currencySymbol;
}
