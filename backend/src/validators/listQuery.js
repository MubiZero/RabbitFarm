const Joi = require('joi');

/**
 * Общие правила для постраничных списков.
 *
 * Несколько эндпоинтов брали page, limit и sort_by прямо из строки запроса.
 * Неизвестное поле сортировки уходило в SQL и возвращалось общей пятисоткой
 * вместо понятной ошибки, а limit не был ограничен ничем: ?limit=500000
 * поднимал в память всю таблицу вместе со связями.
 */

const page = Joi.number()
  .integer()
  .min(1)
  .default(1)
  .messages({
    'number.base': 'Страница должна быть числом',
    'number.min': 'Страница должна быть минимум 1'
  });

const limit = Joi.number()
  .integer()
  .min(1)
  .max(100)
  .default(50)
  .messages({
    'number.base': 'Лимит должен быть числом',
    'number.min': 'Лимит должен быть минимум 1',
    'number.max': 'Лимит должен быть максимум 100'
  });

const sortOrder = Joi.string()
  .valid('asc', 'desc', 'ASC', 'DESC')
  .default('DESC')
  .messages({
    'any.only': 'Порядок должен быть: asc или desc'
  });

/** Поле сортировки только из перечисленных — остальные до SQL не доходят. */
const sortBy = (allowed, fallback) =>
  Joi.string()
    .valid(...allowed)
    .default(fallback)
    .messages({
      'any.only': `Сортировка должна быть одной из: ${allowed.join(', ')}`
    });

const fromDate = Joi.date().optional().messages({
  'date.base': 'Неверная дата начала периода'
});

/**
 * Ограничение «конец не раньше начала» имеет смысл только когда начало задано.
 * Безусловный min(ref('from_date')) ронял Joi ошибкой any.ref на запросах вида
 * ?to_date=2026-08-01 — то есть «покажи всё по 1 августа» было невозможно.
 */
const toDate = Joi.date()
  .when('from_date', {
    is: Joi.exist(),
    then: Joi.date().min(Joi.ref('from_date'))
  })
  .optional()
  .messages({
    'date.base': 'Неверная дата окончания периода',
    'date.min': 'Дата окончания должна быть после даты начала'
  });

module.exports = { page, limit, sortOrder, sortBy, fromDate, toDate };
