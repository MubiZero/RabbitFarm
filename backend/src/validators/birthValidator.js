const Joi = require('joi');
const listQuery = require('./listQuery');

/**
 * Окролы шли вообще без валидации: тело запроса разбиралось прямо в
 * контроллере. Количество крольчат приходило строкой, дата — чем угодно, а
 * ошибка типа возвращалась общей пятисоткой от базы.
 */
const kitsCount = Joi.number()
  .integer()
  .min(0)
  .max(30)
  .messages({
    'number.base': 'Количество крольчат должно быть числом',
    'number.min': 'Количество крольчат не может быть отрицательным',
    'number.max': 'Количество крольчат в одном окроле не может превышать 30'
  });

const createBirthSchema = Joi.object({
  mother_id: Joi.number()
    .integer()
    .required()
    .messages({
      'number.base': 'ID матери должен быть числом',
      'any.required': 'Мать обязательна'
    }),

  breeding_id: Joi.number()
    .integer()
    .allow(null)
    .messages({
      'number.base': 'ID случки должен быть числом'
    }),

  birth_date: Joi.date()
    .max('now')
    .required()
    .messages({
      'date.base': 'Неверная дата окрола',
      'date.max': 'Дата окрола не может быть в будущем',
      'any.required': 'Дата окрола обязательна'
    }),

  kits_born_alive: kitsCount.default(0),
  kits_born_dead: kitsCount.default(0),
  kits_died: kitsCount.default(0),

  complications: Joi.string().max(2000).allow(null, ''),
  notes: Joi.string().max(2000).allow(null, '')
});

const updateBirthSchema = Joi.object({
  // Мать и случка обязаны быть в схеме правки: форма шлёт их всегда, а
  // незнакомый ключ здесь не отвергается, а вырезается (stripUnknown в
  // middleware/validation.js). Смена матери или привязки к случке молча
  // пропадала — приложение отвечало «сохранено», а в окроле оставалась
  // прежняя мать.
  mother_id: Joi.number().integer().messages({
    'number.base': 'ID матери должен быть числом'
  }),
  breeding_id: Joi.number().integer().allow(null).messages({
    'number.base': 'ID случки должен быть числом'
  }),

  birth_date: Joi.date().max('now').messages({
    'date.base': 'Неверная дата окрола',
    'date.max': 'Дата окрола не может быть в будущем'
  }),
  kits_born_alive: kitsCount,
  kits_born_dead: kitsCount,
  kits_died: kitsCount,
  kits_weaned: kitsCount,

  // Отсадка не может случиться раньше окрола или в будущем: крольчата
  // отсаживаются в месяц-полтора, и дата вперёд календаря означает опечатку,
  // которую потом никто не найдёт.
  weaning_date: Joi.date().max('now').allow(null).messages({
    'date.base': 'Неверная дата отсадки',
    'date.max': 'Дата отсадки не может быть в будущем'
  }),
  complications: Joi.string().max(2000).allow(null, ''),
  notes: Joi.string().max(2000).allow(null, '')
});

/** Карточки крольчат из окрола. */
const createKitsSchema = Joi.object({
  // Потолок тот же, что у «родилось живыми» (kitsCount выше). Пока здесь
  // стояло 20, окрол на 21–30 живых крольчат нельзя было завести в карточки
  // вовсе, хотя записать такой окрол приложение позволяло.
  count: Joi.number()
    .integer()
    .min(1)
    .max(30)
    .required()
    .messages({
      'number.base': 'Количество должно быть числом',
      'number.min': 'Нужно создать хотя бы одну карточку',
      'number.max': 'За раз можно создать не больше 30 карточек',
      'any.required': 'Количество обязательно'
    }),

  mother_id: Joi.number().integer().messages({
    'number.base': 'ID матери должен быть числом'
  }),
  father_id: Joi.number().integer().allow(null).messages({
    'number.base': 'ID отца должен быть числом'
  }),
  breed_id: Joi.number().integer().allow(null).messages({
    'number.base': 'ID породы должен быть числом'
  }),
  birth_date: Joi.date().max('now').messages({
    'date.base': 'Неверная дата рождения',
    'date.max': 'Дата рождения не может быть в будущем'
  }),
  name_prefix: Joi.string().max(50).allow(null, '').messages({
    'string.max': 'Префикс имени должен быть максимум 50 символов'
  })
});

const listBirthsQuerySchema = Joi.object({
  page: listQuery.page,
  limit: listQuery.limit,
  mother_id: Joi.number().integer().optional(),
  from_date: listQuery.fromDate,
  to_date: listQuery.toDate
});

module.exports = {
  createBirthSchema,
  updateBirthSchema,
  createKitsSchema,
  listBirthsQuerySchema
};
