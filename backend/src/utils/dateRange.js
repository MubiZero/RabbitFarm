/**
 * Границы периода для колонок, которые хранят момент времени (DATETIME).
 *
 * Клиент задаёт период календарными датами — «с 1 по 24 августа». Для колонок
 * DATEONLY этого достаточно: сравнение идёт день с днём. А колонка с временем
 * (`feeding_records.fed_at`) сравнивается с полуночью: `fed_at <= '2026-08-24'`
 * означает «не позже 2026-08-24 00:00:00», поэтому всё, записанное в последний
 * день периода, отсекается. Период по умолчанию заканчивается сегодняшним
 * днём — сегодняшние кормления не попадали в отчёт никогда.
 *
 * Правильная верхняя граница — строгое «раньше следующего дня». Приведение к
 * 23:59:59 теряет последнюю секунду и доли секунды, а границу дня всё равно
 * приходится считать; `< to_date + 1 день` не теряет ничего.
 *
 * Обе границы считаются в UTC — в том же поясе, в котором лежат сами записи
 * (sequelize настроен на timezone '+00:00'). Считать «конец дня» в поясе
 * процесса нельзя: сервер и база разъедутся на смещение пояса, и тот же баг
 * вернётся сдвигом на несколько часов.
 */

/** Календарный день значения (Date или 'YYYY-MM-DD') в виде полуночи UTC. */
const utcMidnight = (value) => {
  const parsed = value instanceof Date ? value : new Date(value);
  if (Number.isNaN(parsed.getTime())) return null;

  return new Date(Date.UTC(
    parsed.getUTCFullYear(),
    parsed.getUTCMonth(),
    parsed.getUTCDate()
  ));
};

/** Нижняя граница периода: начало указанного дня, включительно. */
const startOfDayUtc = (value) => utcMidnight(value);

/**
 * Верхняя граница периода: начало следующего дня.
 * Сравнивать с ней нужно строгим `Op.lt`, а не `Op.lte`.
 */
const nextDayUtc = (value) => {
  const midnight = utcMidnight(value);
  if (!midnight) return null;

  midnight.setUTCDate(midnight.getUTCDate() + 1);
  return midnight;
};

module.exports = { startOfDayUtc, nextDayUtc };
