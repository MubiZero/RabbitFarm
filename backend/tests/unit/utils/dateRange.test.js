const {
  DEFAULT_TIMEZONE,
  startOfDayInZone,
  nextDayInZone,
  todayInZone,
  daysAgoInZone
} = require('../../../src/utils/dateRange');

/**
 * Сутки у каждого хозяйства свои.
 *
 * Это та самая арифметика, из-за которой отчёты расходились: до появления
 * пояса фермы границы дня считались в UTC, и для Душанбе «сегодня»
 * начиналось в 5 утра по местным часам.
 */
describe('Границы суток в поясе хозяйства', () => {
  describe('startOfDayInZone', () => {
    it('в Душанбе (UTC+5) день начинается накануне в 19:00 UTC', () => {
      const start = startOfDayInZone('2026-08-21', 'Asia/Dushanbe');
      expect(start.toISOString()).toBe('2026-08-20T19:00:00.000Z');
    });

    it('в Ташкенте (UTC+5) — так же', () => {
      const start = startOfDayInZone('2026-08-21', 'Asia/Tashkent');
      expect(start.toISOString()).toBe('2026-08-20T19:00:00.000Z');
    });

    it('в Москве (UTC+3) — на два часа позже', () => {
      const start = startOfDayInZone('2026-08-21', 'Europe/Moscow');
      expect(start.toISOString()).toBe('2026-08-20T21:00:00.000Z');
    });

    it('в Кабуле (UTC+4:30) учитывает получасовое смещение', () => {
      const start = startOfDayInZone('2026-08-21', 'Asia/Kabul');
      expect(start.toISOString()).toBe('2026-08-20T19:30:00.000Z');
    });

    it('незнакомый пояс не роняет расчёт, а откатывается к таджикскому', () => {
      const start = startOfDayInZone('2026-08-21', 'Moon/Sea_of_Tranquility');
      expect(start.toISOString()).toBe(
        startOfDayInZone('2026-08-21', DEFAULT_TIMEZONE).toISOString()
      );
    });

    it('неразобранное значение даёт null, а не «сегодня»', () => {
      expect(startOfDayInZone('не дата', 'Asia/Dushanbe')).toBeNull();
    });
  });

  describe('nextDayInZone', () => {
    it('верхняя граница — начало следующего дня хозяйства', () => {
      const end = nextDayInZone('2026-08-21', 'Asia/Dushanbe');
      expect(end.toISOString()).toBe('2026-08-21T19:00:00.000Z');
    });

    it('сутки хозяйства длятся ровно 24 часа', () => {
      const start = startOfDayInZone('2026-08-21', 'Asia/Tashkent');
      const end = nextDayInZone('2026-08-21', 'Asia/Tashkent');
      expect(end - start).toBe(24 * 60 * 60 * 1000);
    });

    it('переход через конец месяца считается правильно', () => {
      const end = nextDayInZone('2026-08-31', 'Asia/Dushanbe');
      expect(end.toISOString()).toBe('2026-08-31T19:00:00.000Z');
    });
  });

  describe('todayInZone', () => {
    it('в предрассветный час показывает уже наступивший день хозяйства', () => {
      // 01:30 по Душанбе = 20:30 предыдущего дня по Гринвичу. Именно здесь
      // toISOString() давал вчерашнюю дату, и сегодняшние записи выпадали
      // из отчёта за «сегодня».
      const beforeDawn = new Date('2026-08-20T20:30:00.000Z');

      expect(todayInZone('Asia/Dushanbe', beforeDawn)).toBe('2026-08-21');
      expect(beforeDawn.toISOString().split('T')[0]).toBe('2026-08-20');
    });

    it('у хозяйств в разных поясах «сегодня» может отличаться', () => {
      // 23:00 UTC: в Москве ещё 21-е (02:00), в Лондоне уже наступило 21-е.
      const late = new Date('2026-08-20T23:30:00.000Z');

      expect(todayInZone('Asia/Dushanbe', late)).toBe('2026-08-21');
      expect(todayInZone('Europe/London', late)).toBe('2026-08-21');
      expect(todayInZone('America/New_York', late)).toBe('2026-08-20');
    });
  });

  describe('daysAgoInZone', () => {
    it('отсчитывает календарные дни хозяйства, а не 24-часовые отрезки', () => {
      const beforeDawn = new Date('2026-08-20T20:30:00.000Z'); // 21-е в Душанбе

      expect(daysAgoInZone(30, 'Asia/Dushanbe', beforeDawn)).toBe('2026-07-22');
      expect(daysAgoInZone(0, 'Asia/Dushanbe', beforeDawn)).toBe('2026-08-21');
    });

    it('переход через начало года считается правильно', () => {
      const newYear = new Date('2026-01-02T10:00:00.000Z');
      expect(daysAgoInZone(7, 'Asia/Dushanbe', newYear)).toBe('2025-12-26');
    });
  });
});
