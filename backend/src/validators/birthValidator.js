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

  complications: Joi.string().max(2000).allow(null, ''),
  notes: Joi.string().max(2000).allow(null, '')
});

const updateBirthSchema = Joi.object({
  birth_date: Joi.date().max('now').messages({
    'date.base': 'Неверная дата окрола',
    'date.max': 'Дата окрола не может быть в будущем'
  }),
  kits_born_alive: kitsCount,
  kits_born_dead: kitsCount,
  kits_weaned: kitsCount,
  weaning_date: Joi.date().allow(null).messages({
    'date.base': 'Неверная дата отсадки'
  }),
  complications: Joi.string().max(2000).allow(null, ''),
  notes: Joi.string().max(2000).allow(null, '')
});

/** Карточки крольчат из окрола. */
const createKitsSchema = Joi.object({
  count: Joi.number()
    .integer()
    .min(1)
    .max(20)
    .required()
    .messages({
      'number.base': 'Количество должно быть числом',
      'number.min': 'Нужно создать хотя бы одну карточку',
      'number.max': 'За раз можно создать не больше 20 карточек',
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
