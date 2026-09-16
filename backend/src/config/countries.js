/**
 * Страны, в которых работает сервис, и что из страны следует.
 *
 * Страна — это не строка в профиле, а четыре решения сразу: в какой валюте
 * хозяйство считает деньги, по какому поясу у него кончаются сутки, можно ли
 * прислать ему код по СМС и на каком языке с ним говорить по умолчанию.
 * Держать их порознь означало бы, что они разъедутся.
 *
 * Список короткий намеренно: это соседи, где кролиководство — знакомое дело,
 * а не все страны мира. Добавить строку сюда дешевле, чем поддерживать
 * справочник, которым никто не пользуется.
 *
 * `sms` — доходит ли до этой страны код подтверждения. Шлюз у нас таджикский
 * (gateway.payom.tj), и за пределы Таджикистана сообщение не уходит. Там, где
 * `sms: false`, экран входа не должен предлагать телефон вовсе — иначе
 * человек ждёт код, который не придёт.
 *
 * `payments` — принимаем ли мы здесь оплату картой. Эквайер — банк «Эсхата»,
 * и карта другой страны через него не пройдёт. Где `false`, подписка
 * продлевается через поддержку, и на экране это сказано прямо.
 */
const COUNTRIES = {
  TJ: {
    code: 'TJ',
    currency: 'TJS',
    timezone: 'Asia/Dushanbe',
    phonePrefix: '+992',
    language: 'tg',
    sms: true,
    payments: true
  },
  UZ: {
    code: 'UZ',
    currency: 'UZS',
    timezone: 'Asia/Tashkent',
    phonePrefix: '+998',
    language: 'uz',
    sms: false,
    payments: false
  },
  KG: {
    code: 'KG',
    currency: 'KGS',
    timezone: 'Asia/Bishkek',
    phonePrefix: '+996',
    language: 'ru',
    sms: false,
    payments: false
  },
  KZ: {
    code: 'KZ',
    currency: 'KZT',
    timezone: 'Asia/Almaty',
    phonePrefix: '+7',
    language: 'ru',
    sms: false,
    payments: false
  },
  RU: {
    code: 'RU',
    currency: 'RUB',
    timezone: 'Europe/Moscow',
    phonePrefix: '+7',
    language: 'ru',
    sms: false,
    payments: false
  },
  AF: {
    code: 'AF',
    currency: 'AFN',
    timezone: 'Asia/Kabul',
    phonePrefix: '+93',
    language: 'tg',
    sms: false,
    payments: false
  }
};

/** Страна по умолчанию: сервис вырос из таджикских хозяйств. */
const DEFAULT_COUNTRY = 'TJ';

/**
 * Настройки страны. Незнакомый код не роняет запрос и не выдумывает
 * значения — отдаёт таджикские, потому что все существующие фермы такие.
 */
const countryConfig = (code) =>
  COUNTRIES[String(code || '').toUpperCase()] || COUNTRIES[DEFAULT_COUNTRY];

/** Коды всех поддерживаемых стран — для проверки входящих значений. */
const COUNTRY_CODES = Object.keys(COUNTRIES);

module.exports = {
  COUNTRIES,
  COUNTRY_CODES,
  DEFAULT_COUNTRY,
  countryConfig
};
