const {
  taskText,
  taskTitle,
  localizeTask,
  TASKS,
  LANGUAGES
} = require('../../../src/i18n/tasks');

/**
 * Задача живёт в базе месяцами, и читать её может кто угодно из фермы — на
 * своём языке. Поэтому переводы проверяются так же строго, как у пушей:
 * дыра здесь означает работника, который видит русский текст в таджикском
 * приложении.
 */
describe('тексты автоматических задач', () => {
  const keys = Object.keys(TASKS);

  describe.each(keys)('%s', (key) => {
    it.each(LANGUAGES)('переведено на %s', (language) => {
      const { title, description } = taskText(key, language, {
        doe: 'Мушка',
        buck: 'Серый'
      });

      expect(title.trim()).not.toHaveLength(0);
      expect(description.trim()).not.toHaveLength(0);
      // Кличка подставлена, а не потеряна по дороге.
      expect(title).toContain('Мушка');
    });

    it('на разных языках заголовки разные, а не скопированный русский', () => {
      const titles = LANGUAGES.map(
        (language) => taskText(key, language, { doe: 'Мушка', buck: 'Серый' }).title
      );
      expect(new Set(titles).size).toBe(LANGUAGES.length);
    });
  });

  it('незнакомый язык получает русский, а не пустоту', () => {
    const { title } = taskText('nestBox', 'fr', { doe: 'Мушка' });
    expect(title).toBe('Поставить маточник: Мушка');
  });

  it('неизвестный ключ — это опечатка в коде', () => {
    expect(() => taskText('nope', 'ru', {})).toThrow(/Unknown task key/);
  });
});

describe('localizeTask', () => {
  const autoTask = {
    id: 1,
    title: 'Поставить маточник: Мушка',
    description: 'Подготовить клетку и поставить гнездовой ящик для Мушка',
    title_key: 'nestBox',
    title_params: { doe: 'Мушка' }
  };

  it('подменяет текст автозадачи на язык читателя', () => {
    const localized = localizeTask(autoTask, 'uz');

    expect(localized.title).toBe('Uya qoʻyish: Мушка');
    expect(localized.description).toContain('Katakni tayyorlang');
    // Остальные поля не теряются.
    expect(localized.id).toBe(1);
  });

  it('задачу, написанную человеком, не трогает', () => {
    const handmade = { id: 2, title: 'Купить сетку на рынке', description: null };

    expect(localizeTask(handmade, 'tg')).toEqual(handmade);
  });

  it('работает с моделью Sequelize, а не только с простым объектом', () => {
    const model = { toJSON: () => ({ ...autoTask }) };

    expect(localizeTask(model, 'en').title).toBe('Put in the nest box: Мушка');
  });

  it('задача, созданная до появления ключей, остаётся как есть', () => {
    const legacy = { id: 3, title: 'Пальпация: Мушка', title_key: null };

    expect(localizeTask(legacy, 'uz').title).toBe('Пальпация: Мушка');
  });
});

describe('taskTitle', () => {
  it('для автозадачи даёт перевод', () => {
    const title = taskTitle(
      { title: 'Отсадка (отъём): Мушка', title_key: 'weaning', title_params: { doe: 'Мушка' } },
      'tg'
    );
    expect(title).toBe('Ҷудо кардан: Мушка');
  });

  it('для задачи человека возвращает его же слова', () => {
    expect(taskTitle({ title: 'Починить поилку' }, 'en')).toBe('Починить поилку');
  });
});

describe('перевод автозадачи доезжает до уведомления', () => {
  const { notificationText } = require('../../../src/i18n/notifications');

  it('название задачи в пуше — на языке получателя', () => {
    const task = {
      title: 'Поставить маточник: Мушка',
      title_key: 'nestBox',
      title_params: { doe: 'Мушка' }
    };
    const params = (language) => ({ task: taskTitle(task, language) });

    expect(notificationText('taskOverdue', 'ru', params).body).toBe(
      'Поставить маточник: Мушка'
    );
    expect(notificationText('taskOverdue', 'uz', params).body).toBe(
      'Uya qoʻyish: Мушка'
    );
  });
});
