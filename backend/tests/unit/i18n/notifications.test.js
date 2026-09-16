const {
  notificationText,
  LANGUAGES,
  MESSAGES
} = require('../../../src/i18n/notifications');

/**
 * Перевод уведомлений нужен целиком: наполовину переведённое сообщение
 * молча подменяется русским, и дыра видна только адресату, который на неё
 * уже не пожалуется.
 */
describe('тексты уведомлений', () => {
  const keys = Object.keys(MESSAGES);

  it('есть хотя бы одно сообщение', () => {
    expect(keys.length).toBeGreaterThan(0);
  });

  describe.each(keys)('%s', (key) => {
    it.each(LANGUAGES)('переведено на %s', (language) => {
      const message = MESSAGES[key][language];
      expect(message).toBeDefined();
      expect(typeof message.title).toBe('string');
      expect(message.title.trim()).not.toHaveLength(0);
      expect(typeof message.body).toBe('function');
    });

    it('на разных языках заголовки разные, а не скопированный русский', () => {
      const titles = LANGUAGES.map((language) => MESSAGES[key][language].title);
      // Латиница узбекского и кириллица таджикского совпасть с русским не
      // могут — совпадение означало бы копию вместо перевода.
      expect(new Set(titles).size).toBe(LANGUAGES.length);
    });
  });

  it('подставляет параметры в текст', () => {
    const { title, body } = notificationText('vaccinationDigest', 'ru', { count: 3 });
    expect(title).toBe('Просроченные прививки');
    expect(body).toBe('Просрочено: 3');
  });

  it('окрол называет клетку, а на своём языке — своим словом', () => {
    const ru = notificationText('kindlingSoon', 'ru', { cageNumber: '14' });
    const tg = notificationText('kindlingSoon', 'tg', { cageNumber: '14' });

    expect(ru.body).toContain('Клетка 14');
    expect(tg.body).toContain('Қафаси 14');
  });

  it('без клетки зовёт самку по кличке', () => {
    const { body } = notificationText('kindlingSoon', 'uz', {
      cageNumber: null,
      femaleName: 'Mushka'
    });
    expect(body).toContain('Mushka');
  });

  it('незнакомый язык получает русский, а не пустоту', () => {
    const { title } = notificationText('planExpired', 'fr', { plan: 'Базовый' });
    expect(title).toBe('Тариф истёк');
  });

  it('неизвестный ключ — это опечатка в коде, а не пустое уведомление', () => {
    expect(() => notificationText('nope', 'ru')).toThrow(/Unknown notification key/);
  });
});
