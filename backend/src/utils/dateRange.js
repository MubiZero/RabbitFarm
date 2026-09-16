/**
 * Границы суток — в часовом поясе хозяйства.
 *
 * Клиент задаёт период календарными датами: «с 1 по 24 августа». Превратить
 * их в моменты времени можно только зная, чьи это сутки. Раньше границы
 * считались в UTC, и для фермы в Душанбе «сегодня» начиналось в 5 утра по её
 * же часам: запись, сделанная до рассвета, попадала во вчерашний день, а
 * отчёты за «сегодня» расходились между собой.
 *
 * Пояс берётся из `farms.timezone` — своё поле у каждого хозяйства. До
 * появления выбора страны пояс был один на весь сервис, и в нём же стоял
 * процесс (`TZ=Asia/Dushanbe`), поэтому расхождение замечали только в
 * предрассветные часы. С фермами в других странах оно стало бы постоянным.
 *
 * Считаем через `Intl`, без внешних библиотек: он знает и смещения, и
 * переходы на летнее время, и остаётся правым, когда правила меняются.
 */

/** Пояс по умолчанию: сервис вырос из таджикских хозяйств. */
const DEFAULT_TIMEZONE = 'Asia/Dushanbe';

const formatterCache = new Map();

const zoneFormatter = (timeZone) => {
  let formatter = formatterCache.get(timeZone);
  if (!formatter) {
    formatter = new Intl.DateTimeFormat('en-US', {
      timeZone,
      hour12: false,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    });
    formatterCache.set(timeZone, formatter);
  }
  return formatter;
};

/** Безопасный пояс: незнакомый роняет Intl, поэтому проверяем заранее. */
const safeZone = (timeZone) => {
  if (!timeZone) return DEFAULT_TIMEZONE;
  try {
    zoneFormatter(timeZone).format(new Date());
    return timeZone;
  } catch {
    return DEFAULT_TIMEZONE;
  }
};

/** Смещение пояса в конкретный момент, в миллисекундах. */
const zoneOffsetMs = (utcMs, timeZone) => {
  const parts = Object.fromEntries(
    zoneFormatter(timeZone)
      .formatToParts(new Date(utcMs))
      .filter((part) => part.type !== 'literal')
      .map((part) => [part.type, Number(part.value)])
  );

  // hour === 24 бывает в полночь у части реализаций hour12: false.
  const asIfUtc = Date.UTC(
    parts.year,
    parts.month - 1,
    parts.day,
    parts.hour % 24,
    parts.minute,
    parts.second
  );

  return asIfUtc - utcMs;
};

/** Календарные части значения («2026-08-21» или Date) в поясе хозяйства. */
const zonedParts = (value, timeZone) => {
  const parsed = value instanceof Date ? value : new Date(value);
  if (Number.isNaN(parsed.getTime())) return null;

  // Для «2026-08-21» Date уже даёт полночь UTC — календарный день читается
  // прямо оттуда. Для момента времени день зависит от пояса.
  const isPlainDate = typeof value === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(value);
  if (isPlainDate) {
    const [year, month, day] = value.split('-').map(Number);
    return { year, month, day };
  }

  const parts = Object.fromEntries(
    zoneFormatter(timeZone)
      .formatToParts(parsed)
      .filter((part) => part.type !== 'literal')
      .map((part) => [part.type, Number(part.value)])
  );
  return { year: parts.year, month: parts.month, day: parts.day };
};

/**
 * Начало календарного дня в поясе хозяйства, как момент UTC.
 *
 * Смещение считается дважды: первое приближение берётся на полночь UTC, но у
 * поясов с переходом на летнее время оно может относиться к соседнему дню —
 * второй проход уточняет по уже найденному моменту.
 */
const startOfDayInZone = (value, timeZone = DEFAULT_TIMEZONE) => {
  const zone = safeZone(timeZone);
  const parts = zonedParts(value, zone);
  if (!parts) return null;

  const naive = Date.UTC(parts.year, parts.month - 1, parts.day);
  const firstGuess = naive - zoneOffsetMs(naive, zone);
  const corrected = naive - zoneOffsetMs(firstGuess, zone);

  return new Date(corrected);
};

/**
 * Начало следующего дня в поясе хозяйства.
 * Сравнивать с ним нужно строгим `Op.lt`, а не `Op.lte`: приведение к
 * 23:59:59 теряет последнюю секунду, а «раньше следующего дня» — ничего.
 */
const nextDayInZone = (value, timeZone = DEFAULT_TIMEZONE) => {
  const zone = safeZone(timeZone);
  const parts = zonedParts(value, zone);
  if (!parts) return null;

  const naive = Date.UTC(parts.year, parts.month - 1, parts.day + 1);
  const firstGuess = naive - zoneOffsetMs(naive, zone);
  const corrected = naive - zoneOffsetMs(firstGuess, zone);

  return new Date(corrected);
};

/**
 * Сегодняшняя календарная дата хозяйства в виде «2026-08-21».
 *
 * Нужна там, где день сравнивается с колонкой DATEONLY: у неё нет времени, и
 * сравнивать её с моментом бессмысленно. `toISOString()` для этого не годится
 * — он даёт день по Гринвичу, то есть до рассвета показывает вчерашний.
 */
const todayInZone = (timeZone = DEFAULT_TIMEZONE, now = new Date()) => {
  const parts = zonedParts(now, safeZone(timeZone));
  return [
    parts.year,
    String(parts.month).padStart(2, '0'),
    String(parts.day).padStart(2, '0')
  ].join('-');
};

/**
 * Который сейчас час у хозяйства, 0–23.
 *
 * Нужен фоновым задачам: утренняя сводка должна приходить в восемь утра
 * хозяйства, а не сервера. Пока час брался у процесса, ферма в другом поясе
 * получала «доброе утро» ночью.
 */
const hourInZone = (timeZone = DEFAULT_TIMEZONE, now = new Date()) => {
  const parts = Object.fromEntries(
    zoneFormatter(safeZone(timeZone))
      .formatToParts(now)
      .filter((part) => part.type !== 'literal')
      .map((part) => [part.type, Number(part.value)])
  );
  return parts.hour % 24;
};

/** Календарная дата за `days` дней до сегодняшней, в поясе хозяйства. */
const daysAgoInZone = (days, timeZone = DEFAULT_TIMEZONE, now = new Date()) => {
  const zone = safeZone(timeZone);
  const parts = zonedParts(now, zone);
  const shifted = new Date(Date.UTC(parts.year, parts.month - 1, parts.day - days));

  return [
    shifted.getUTCFullYear(),
    String(shifted.getUTCMonth() + 1).padStart(2, '0'),
    String(shifted.getUTCDate()).padStart(2, '0')
  ].join('-');
};

module.exports = {
  DEFAULT_TIMEZONE,
  startOfDayInZone,
  nextDayInZone,
  todayInZone,
  daysAgoInZone,
  hourInZone
};
