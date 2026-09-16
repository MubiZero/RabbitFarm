'use strict';

/**
 * Тексты уведомлений на языках приложения.
 *
 * Приложение говорит на четырёх языках, а сервер до сих пор слал пуши и
 * письма одним русским текстом: таджикский фермер получал сообщение, которое
 * не читает. Язык берётся из профиля (`users.language`), который приложение
 * присылает при входе и при каждой смене языка в настройках.
 *
 * Языки лежат рядом под одним ключом, а не отдельными файлами: так при
 * добавлении сообщения сразу видно, какой перевод забыт, — и это же
 * проверяет тест.
 */
const LANGUAGES = ['ru', 'en', 'tg', 'uz'];
const DEFAULT_LANGUAGE = 'ru';

const MESSAGES = {
  vaccinationDigest: {
    ru: {
      title: 'Просроченные прививки',
      body: ({ count }) => `Просрочено: ${count}`
    },
    en: {
      title: 'Overdue vaccinations',
      body: ({ count }) => `Overdue: ${count}`
    },
    tg: {
      title: 'Эмгузаронии мӯҳлаташ гузашта',
      body: ({ count }) => `Мӯҳлаташ гузашта: ${count}`
    },
    uz: {
      title: 'Muddati oʻtgan emlashlar',
      body: ({ count }) => `Muddati oʻtgan: ${count}`
    }
  },

  feedDigest: {
    ru: {
      title: 'Мало корма',
      body: ({ count }) => `Кормов ниже минимума: ${count}`
    },
    en: {
      title: 'Feed running low',
      body: ({ count }) => `Feeds below the minimum: ${count}`
    },
    tg: {
      title: 'Хӯрок кам мондааст',
      body: ({ count }) => `Хӯроки аз ҳадди ақал камтар: ${count}`
    },
    uz: {
      title: 'Ozuqa kam qoldi',
      body: ({ count }) => `Eng kam miqdordan past ozuqalar: ${count}`
    }
  },

  taskOverdue: {
    ru: { title: 'Просроченная задача', body: ({ task }) => task },
    en: { title: 'Overdue task', body: ({ task }) => task },
    tg: { title: 'Вазифаи мӯҳлаташ гузашта', body: ({ task }) => task },
    uz: { title: 'Muddati oʻtgan vazifa', body: ({ task }) => task }
  },

  // Напоминание заранее — в отличие от taskOverdue, оно приходит ДО срока и
  // ради того, чтобы срок не пропустили.
  taskReminder: {
    ru: {
      title: 'Скоро срок',
      body: ({ task, minutes }) => `${task} — через ${minutes}`
    },
    en: {
      title: 'Due soon',
      body: ({ task, minutes }) => `${task} — in ${minutes}`
    },
    tg: {
      title: 'Мӯҳлат наздик',
      body: ({ task, minutes }) => `${task} — пас аз ${minutes}`
    },
    uz: {
      title: 'Muddat yaqin',
      body: ({ task, minutes }) => `${task} — ${minutes} dan keyin`
    }
  },

  taskDigest: {
    ru: {
      title: 'Просроченные задачи без исполнителя',
      body: ({ count }) => `Просрочено: ${count}`
    },
    en: {
      title: 'Overdue tasks with nobody assigned',
      body: ({ count }) => `Overdue: ${count}`
    },
    tg: {
      title: 'Вазифаҳои бе иҷрокунанда мӯҳлаташон гузашта',
      body: ({ count }) => `Мӯҳлаташ гузашта: ${count}`
    },
    uz: {
      title: 'Bajaruvchisi yoʻq muddati oʻtgan vazifalar',
      body: ({ count }) => `Muddati oʻtgan: ${count}`
    }
  },

  // «Послезавтра» вместо «через 2 дня» намеренно: так не нужно склонять
  // число ни в одном из четырёх языков, а смысл для человека тот же.
  //
  // Номер клетки и кличка приходят порознь, а не готовой строкой: слово
  // «клетка» тоже переводится, и собери его вызывающий — половина текста
  // осталась бы русской.
  kindlingSoon: {
    ru: {
      title: 'Скоро окрол',
      body: ({ cageNumber, femaleName }) =>
        `${cageNumber ? `Клетка ${cageNumber}` : femaleName} — окрол послезавтра. Поставьте маточник`
    },
    en: {
      title: 'Kindling coming up',
      body: ({ cageNumber, femaleName }) =>
        `${cageNumber ? `Cage ${cageNumber}` : femaleName} kindles the day after tomorrow. Put the nest box in`
    },
    tg: {
      title: 'Ба зудӣ зоиш',
      body: ({ cageNumber, femaleName }) =>
        `${cageNumber ? `Қафаси ${cageNumber}` : femaleName} — зоиш пасфардо. Лонаро гузоред`
    },
    uz: {
      title: 'Tez orada bolalash',
      body: ({ cageNumber, femaleName }) =>
        `${cageNumber ? `${cageNumber}-katak` : femaleName} — indinga bolalaydi. Uyani qoʻying`
    }
  },

  taskAssigned: {
    ru: { title: 'Вам назначена задача', body: ({ task }) => task },
    en: { title: 'A task is assigned to you', body: ({ task }) => task },
    tg: { title: 'Ба шумо вазифа таъин шуд', body: ({ task }) => task },
    uz: { title: 'Sizga vazifa berildi', body: ({ task }) => task }
  },

  noteCreated: {
    ru: { title: 'Новая запись в дневнике', body: ({ excerpt }) => excerpt },
    en: { title: 'New journal entry', body: ({ excerpt }) => excerpt },
    tg: { title: 'Қайди нав дар рӯзнома', body: ({ excerpt }) => excerpt },
    uz: { title: 'Kundalikda yangi yozuv', body: ({ excerpt }) => excerpt }
  },

  winbackTwoWeeks: {
    ru: {
      title: 'Давно вас не было',
      body: ({ farm }) =>
        `В хозяйство «${farm}» не заходили две недели. Загляните в приложение: отметьте кормления, взвешивания и окролы, чтобы записи не отстали от жизни фермы.`
    },
    en: {
      title: 'It has been a while',
      body: ({ farm }) =>
        `Nobody has opened "${farm}" for two weeks. Drop in and log feedings, weights and kindlings so the records keep up with the farm.`
    },
    tg: {
      title: 'Кайҳо набудед',
      body: ({ farm }) =>
        `Ба хоҷагии «${farm}» ду ҳафта касе надаромадааст. Ба барнома нигаред: хӯрокдиҳӣ, вазнкашӣ ва зоишро қайд кунед, то сабтҳо аз ҳаёти хоҷагӣ ақиб намонанд.`
    },
    uz: {
      title: 'Anchadan beri yoʻqsiz',
      body: ({ farm }) =>
        `«${farm}» xoʻjaligiga ikki hafta hech kim kirmadi. Ilovaga kiring: oziqlantirish, vazn va bolalashni yozib qoʻying, yozuvlar xoʻjalikdan ortda qolmasin.`
    }
  },

  winbackMonth: {
    ru: {
      title: 'Ферма ждёт вас',
      body: ({ farm }) =>
        `В хозяйстве «${farm}» не были уже месяц. Все ваши записи на месте — откройте приложение и продолжите с того, на чём остановились.`
    },
    en: {
      title: 'Your farm is waiting',
      body: ({ farm }) =>
        `You have not been to "${farm}" for a month. All your records are still there, so open the app and pick up where you left off.`
    },
    tg: {
      title: 'Хоҷагӣ шуморо интизор аст',
      body: ({ farm }) =>
        `Дар хоҷагии «${farm}» як моҳ набудед. Ҳамаи сабтҳои шумо дар ҷояшон — барномаро кушоед ва аз ҳамон ҷое, ки монда будед, давом диҳед.`
    },
    uz: {
      title: 'Xoʻjaligingiz kutmoqda',
      body: ({ farm }) =>
        `«${farm}» xoʻjaligida bir oydan beri boʻlmadingiz. Barcha yozuvlaringiz joyida — ilovani oching va toʻxtagan joyingizdan davom eting.`
    }
  },

  planExpiringWeek: {
    ru: {
      title: 'Тариф скоро закончится',
      body: ({ plan }) =>
        `Тариф «${plan}» действует ещё 7 дней. Продлите его в приложении, раздел «Тариф».`
    },
    en: {
      title: 'Your plan ends soon',
      body: ({ plan }) =>
        `The "${plan}" plan runs for 7 more days. Renew it in the app, under Plan.`
    },
    tg: {
      title: 'Таъриф ба зудӣ тамом мешавад',
      body: ({ plan }) =>
        `Таърифи «${plan}» боз 7 рӯз эътибор дорад. Онро дар барнома, бахши «Таъриф», тамдид кунед.`
    },
    uz: {
      title: 'Tarif tez orada tugaydi',
      body: ({ plan }) =>
        `«${plan}» tarifi yana 7 kun amal qiladi. Uni ilovadagi «Tarif» boʻlimida uzaytiring.`
    }
  },

  planExpiringTomorrow: {
    ru: {
      title: 'Тариф заканчивается завтра',
      body: ({ plan }) =>
        `Тариф «${plan}» истекает завтра. Продлите его в приложении, раздел «Тариф», чтобы не потерять доступ к записи.`
    },
    en: {
      title: 'Your plan ends tomorrow',
      body: ({ plan }) =>
        `The "${plan}" plan expires tomorrow. Renew it in the app, under Plan, to keep adding records.`
    },
    tg: {
      title: 'Таъриф фардо тамом мешавад',
      body: ({ plan }) =>
        `Таърифи «${plan}» фардо тамом мешавад. Онро дар барнома, бахши «Таъриф», тамдид кунед, то имкони сабт аз даст наравад.`
    },
    uz: {
      title: 'Tarif ertaga tugaydi',
      body: ({ plan }) =>
        `«${plan}» tarifi ertaga tugaydi. Yozuv kiritish imkoni yoʻqolmasligi uchun uni ilovadagi «Tarif» boʻlimida uzaytiring.`
    }
  },

  /**
   * Квитанция об оплате.
   *
   * Раньше она собиралась прямо в контроллере русской строкой и не уходила
   * никуда: вызов передавал `{title, body}`, а отправка ждёт `{key, params}`
   * — внутри падало на неизвестном ключе, и ошибка тихо оседала в логе.
   * Единственным подтверждением оплаты оставалась зелёная карточка на
   * экране, которая исчезала при выходе.
   */
  paymentReceipt: {
    ru: {
      title: 'Оплата получена',
      body: ({ amount, orderId, until }) =>
        `${amount} сомони, заказ №${orderId}. Тариф продлён до ${until}.`
    },
    en: {
      title: 'Payment received',
      body: ({ amount, orderId, until }) =>
        `${amount} somoni, order No. ${orderId}. Your plan is extended until ${until}.`
    },
    tg: {
      title: 'Пардохт қабул шуд',
      body: ({ amount, orderId, until }) =>
        `${amount} сомонӣ, фармоиши №${orderId}. Таъриф то ${until} тамдид шуд.`
    },
    uz: {
      title: 'Toʻlov qabul qilindi',
      body: ({ amount, orderId, until }) =>
        `${amount} somoni, buyurtma №${orderId}. Tarif ${until} gacha uzaytirildi.`
    }
  },

  /**
   * Владелец зовёт человека работать на своей ферме.
   *
   * Единственное сообщение здесь, которое уходит тому, у кого учётки ещё
   * нет: язык взять неоткуда, поэтому пишем на языке позвавшего — он знает,
   * кого зовёт, и на каком языке с ним разговаривать.
   *
   * Срок назван словом «неделя», а не числом дней: так его не нужно
   * склонять ни в одном из четырёх языков (тот же приём, что и
   * «послезавтра» выше).
   */
  staffInvitation: {
    ru: {
      title: 'Приглашение на ферму',
      body: ({ inviter, farm, contact, link }) =>
        `${inviter} зовёт вас работать в хозяйстве «${farm}» в приложении RabbitFarm. Приложение здесь: ${link} — на экране входа введите ${contact}, код для входа придёт сюда же. Приглашение действует неделю.`
    },
    en: {
      title: 'An invitation to a farm',
      body: ({ inviter, farm, contact, link }) =>
        `${inviter} invites you to work at the "${farm}" farm in RabbitFarm. Get the app here: ${link} — enter ${contact} on the sign-in screen, and the login code will arrive here. The invitation is valid for a week.`
    },
    tg: {
      title: 'Даъват ба хоҷагӣ',
      body: ({ inviter, farm, contact, link }) =>
        `${inviter} шуморо ба кор дар хоҷагии «${farm}» дар барномаи RabbitFarm даъват мекунад. Барнома дар ин ҷо: ${link} — дар саҳифаи даромад ${contact}-ро ворид кунед, рамзи даромад ба ҳамин ҷо меояд. Даъват як ҳафта эътибор дорад.`
    },
    uz: {
      title: 'Xoʻjalikka taklif',
      body: ({ inviter, farm, contact, link }) =>
        `${inviter} sizni RabbitFarm ilovasidagi «${farm}» xoʻjaligida ishlashga taklif qilmoqda. Ilova shu yerda: ${link} — kirish sahifasida ${contact} ni kiriting, kirish kodi shu yerga keladi. Taklif bir hafta amal qiladi.`
    }
  },

  /** Поддержка ответила на обращение. */
  supportAnswered: {
    ru: {
      title: 'Поддержка ответила',
      body: ({ answer }) => answer
    },
    en: {
      title: 'Support replied',
      body: ({ answer }) => answer
    },
    tg: {
      title: 'Дастгирӣ ҷавоб дод',
      body: ({ answer }) => answer
    },
    uz: {
      title: 'Qoʻllab-quvvatlash javob berdi',
      body: ({ answer }) => answer
    }
  },

  planExpired: {
    ru: {
      title: 'Тариф истёк',
      body: ({ plan }) =>
        `Тариф «${plan}» истёк — доступ переведён в режим только для чтения. Продлите тариф в приложении, раздел «Тариф», чтобы снова вносить записи.`
    },
    en: {
      title: 'Your plan has expired',
      body: ({ plan }) =>
        `The "${plan}" plan has expired and the farm is now read-only. Renew it in the app, under Plan, to add records again.`
    },
    tg: {
      title: 'Таъриф тамом шуд',
      body: ({ plan }) =>
        `Таърифи «${plan}» тамом шуд — дастрасӣ танҳо ба хондан гузашт. Барои дубора сабт кардан таърифро дар барнома, бахши «Таъриф», тамдид кунед.`
    },
    uz: {
      title: 'Tarif tugadi',
      body: ({ plan }) =>
        `«${plan}» tarifi tugadi — endi faqat oʻqish mumkin. Yana yozuv kiritish uchun tarifni ilovadagi «Tarif» boʻlimida uzaytiring.`
    }
  },

  planReadOnlyThreeDays: {
    ru: {
      title: 'Ферма работает только на чтение',
      body: ({ plan }) =>
        `Тариф «${plan}» истёк 3 дня назад — новые записи не сохраняются. Продлите тариф в приложении, раздел «Тариф».`
    },
    en: {
      title: 'The farm is read-only',
      body: ({ plan }) =>
        `The "${plan}" plan expired 3 days ago and new records are not being saved. Renew it in the app, under Plan.`
    },
    tg: {
      title: 'Хоҷагӣ танҳо барои хондан кор мекунад',
      body: ({ plan }) =>
        `Таърифи «${plan}» 3 рӯз пеш тамом шуд — сабтҳои нав нигоҳ дошта намешаванд. Таърифро дар барнома, бахши «Таъриф», тамдид кунед.`
    },
    uz: {
      title: 'Xoʻjalik faqat oʻqish rejimida',
      body: ({ plan }) =>
        `«${plan}» tarifi 3 kun oldin tugadi — yangi yozuvlar saqlanmayapti. Tarifni ilovadagi «Tarif» boʻlimida uzaytiring.`
    }
  },

  planUnpaidTwoWeeks: {
    ru: {
      title: 'Тариф не продлён две недели',
      body: ({ plan }) =>
        `Тариф «${plan}» истёк 14 дней назад, ферма всё это время работает только на чтение. Продлите тариф в приложении, раздел «Тариф», чтобы снова вносить записи.`
    },
    en: {
      title: 'Two weeks without a plan',
      body: ({ plan }) =>
        `The "${plan}" plan expired 14 days ago and the farm has been read-only ever since. Renew it in the app, under Plan, to add records again.`
    },
    tg: {
      title: 'Таъриф ду ҳафта тамдид нашуд',
      body: ({ plan }) =>
        `Таърифи «${plan}» 14 рӯз пеш тамом шуд ва хоҷагӣ ин тамоми муддат танҳо барои хондан кор мекунад. Барои дубора сабт кардан таърифро дар барнома, бахши «Таъриф», тамдид кунед.`
    },
    uz: {
      title: 'Tarif ikki haftadan beri uzaytirilmagan',
      body: ({ plan }) =>
        `«${plan}» tarifi 14 kun oldin tugadi va xoʻjalik shu vaqtdan beri faqat oʻqish rejimida. Yana yozuv kiritish uchun tarifni ilovadagi «Tarif» boʻlimida uzaytiring.`
    }
  }
};

/**
 * Текст уведомления на языке человека.
 *
 * Незнакомый язык и незнакомый ключ ведут себя по-разному: язык мог просто
 * появиться в приложении раньше, чем здесь перевод, и русский текст лучше
 * молчания; а вот отсутствующий ключ — это опечатка в вызове, и её надо
 * увидеть, а не разослать людям пустое уведомление.
 */
function notificationText(key, language, params = {}) {
  const message = MESSAGES[key];
  if (!message) throw new Error(`Unknown notification key: ${key}`);

  const localized = message[language] || message[DEFAULT_LANGUAGE];
  // Параметр может сам зависеть от языка — так приходит название задачи,
  // которое сервер тоже переводит (см. `i18n/tasks`). Вызывающему в этот
  // момент язык получателя ещё неизвестен, поэтому он передаёт не значение,
  // а способ его получить.
  const resolved = typeof params === 'function' ? params(language) : params;
  return {
    title: localized.title,
    body: localized.body(resolved)
  };
}

module.exports = { notificationText, LANGUAGES, DEFAULT_LANGUAGE, MESSAGES };
