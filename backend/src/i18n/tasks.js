'use strict';

const { LANGUAGES, DEFAULT_LANGUAGE } = require('./notifications');

/**
 * Заголовки и описания задач, которые сервер заводит сам.
 *
 * Отдельно от уведомлений (`i18n/notifications`), потому что живут иначе:
 * уведомление отправили и забыли, а задача лежит в базе месяцами, и прочитать
 * её может кто угодно из фермы — на своём языке. Поэтому в базу едет ключ и
 * подстановки, а текст собирается в момент выдачи.
 *
 * Все шесть задач — про одну самку, поэтому подстановка всюду одна: `doe`.
 */
const TASKS = {
  palpation: {
    ru: {
      title: ({ doe }) => `Пальпация: ${doe}`,
      description: ({ doe, buck }) =>
        `Проверить на беременность самку ${doe} после случки с ${buck}`
    },
    en: {
      title: ({ doe }) => `Palpation: ${doe}`,
      description: ({ doe, buck }) =>
        `Check doe ${doe} for pregnancy after mating with ${buck}`
    },
    tg: {
      title: ({ doe }) => `Палпатсия: ${doe}`,
      description: ({ doe, buck }) =>
        `Модаи ${doe}-ро пас аз ҷуфтшавӣ бо ${buck} ба ҳомиладорӣ санҷед`
    },
    uz: {
      title: ({ doe }) => `Palpatsiya: ${doe}`,
      description: ({ doe, buck }) =>
        `${doe} urgʻochisini ${buck} bilan juftlashdan keyin homiladorlikka tekshiring`
    }
  },

  nestBox: {
    ru: {
      title: ({ doe }) => `Поставить маточник: ${doe}`,
      description: ({ doe }) =>
        `Подготовить клетку и поставить гнездовой ящик для ${doe}`
    },
    en: {
      title: ({ doe }) => `Put in the nest box: ${doe}`,
      description: ({ doe }) => `Prepare the cage and put the nest box in for ${doe}`
    },
    tg: {
      title: ({ doe }) => `Лона гузоштан: ${doe}`,
      description: ({ doe }) =>
        `Қафасро тайёр кунед ва барои ${doe} лонаи зоиш гузоред`
    },
    uz: {
      title: ({ doe }) => `Uya qoʻyish: ${doe}`,
      description: ({ doe }) =>
        `Katakni tayyorlang va ${doe} uchun bolalash uyasini qoʻying`
    }
  },

  expectedKindling: {
    ru: {
      title: ({ doe }) => `Ожидаемый окрол: ${doe}`,
      description: ({ doe, buck }) =>
        `Ожидается окрол у самки ${doe} (случка с ${buck})`
    },
    en: {
      title: ({ doe }) => `Kindling due: ${doe}`,
      description: ({ doe, buck }) =>
        `Doe ${doe} is due to kindle (mated with ${buck})`
    },
    tg: {
      title: ({ doe }) => `Зоиши интизоршаванда: ${doe}`,
      description: ({ doe, buck }) =>
        `Аз модаи ${doe} зоиш интизор аст (ҷуфтшавӣ бо ${buck})`
    },
    uz: {
      title: ({ doe }) => `Kutilayotgan bolalash: ${doe}`,
      description: ({ doe, buck }) =>
        `${doe} urgʻochisidan bolalash kutilmoqda (${buck} bilan juftlangan)`
    }
  },

  weighKits: {
    ru: {
      title: ({ doe }) => `Взвесить крольчат: ${doe}`,
      description: ({ doe }) => `Первое взвешивание крольчат от самки ${doe}`
    },
    en: {
      title: ({ doe }) => `Weigh the kits: ${doe}`,
      description: ({ doe }) => `First weighing of the kits from doe ${doe}`
    },
    tg: {
      title: ({ doe }) => `Харгӯшчаҳоро баркашед: ${doe}`,
      description: ({ doe }) =>
        `Баркашии аввалини харгӯшчаҳои модаи ${doe}`
    },
    uz: {
      title: ({ doe }) => `Bolalarni tortish: ${doe}`,
      description: ({ doe }) =>
        `${doe} urgʻochisidan olingan bolalarni birinchi marta tortish`
    }
  },

  eyesOpen: {
    ru: {
      title: ({ doe }) => `Проверить глаза: ${doe}`,
      description: ({ doe }) =>
        `Проверить, открылись ли глаза у крольчат самки ${doe}`
    },
    en: {
      title: ({ doe }) => `Check the eyes: ${doe}`,
      description: ({ doe }) => `Check whether the kits of doe ${doe} have opened their eyes`
    },
    tg: {
      title: ({ doe }) => `Чашмонро санҷед: ${doe}`,
      description: ({ doe }) =>
        `Санҷед, оё чашмони харгӯшчаҳои модаи ${doe} кушода шудаанд`
    },
    uz: {
      title: ({ doe }) => `Koʻzlarni tekshirish: ${doe}`,
      description: ({ doe }) =>
        `${doe} urgʻochisining bolalari koʻzini ochgan-ochmaganini tekshiring`
    }
  },

  weaning: {
    ru: {
      title: ({ doe }) => `Отсадка (отъём): ${doe}`,
      description: ({ doe }) => `Пора отсаживать крольчат от самки ${doe}`
    },
    en: {
      title: ({ doe }) => `Weaning: ${doe}`,
      description: ({ doe }) => `Time to wean the kits from doe ${doe}`
    },
    tg: {
      title: ({ doe }) => `Ҷудо кардан: ${doe}`,
      description: ({ doe }) =>
        `Вақти ҷудо кардани харгӯшчаҳо аз модаи ${doe} расид`
    },
    uz: {
      title: ({ doe }) => `Ajratish: ${doe}`,
      description: ({ doe }) =>
        `${doe} urgʻochisidan bolalarni ajratish vaqti keldi`
    }
  }
};

/**
 * Заголовок и описание задачи на нужном языке.
 *
 * Возвращает `null` для задачи без ключа — её написал человек, и подменять
 * его слова переводом нельзя.
 */
function taskText(key, language, params = {}) {
  if (!key) return null;

  const task = TASKS[key];
  if (!task) throw new Error(`Unknown task key: ${key}`);

  const localized = task[language] || task[DEFAULT_LANGUAGE];
  return {
    title: localized.title(params),
    description: localized.description(params)
  };
}

/**
 * Подставить в задачу текст на языке читателя.
 *
 * Работает и с моделью Sequelize, и с обычным объектом: списки задач ходят
 * и так, и так.
 */
function localizeTask(task, language) {
  if (!task) return task;

  const plain = typeof task.toJSON === 'function' ? task.toJSON() : { ...task };
  const text = taskText(plain.title_key, language, plain.title_params || {});
  if (!text) return plain;

  return { ...plain, title: text.title, description: text.description };
}

/**
 * Название задачи так, как его увидит читатель на своём языке.
 *
 * Для задачи, написанной человеком, возвращает его же слова.
 */
function taskTitle(task, language) {
  const text = taskText(task.title_key, language, task.title_params || {});
  return text ? text.title : task.title;
}

module.exports = { taskText, taskTitle, localizeTask, TASKS, LANGUAGES };
