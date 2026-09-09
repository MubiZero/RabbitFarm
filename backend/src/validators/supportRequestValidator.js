const Joi = require('joi');

/**
 * Обращение в поддержку — одно поле: текст.
 *
 * Ни темы, ни категории: выбирать раздел в форме на два поля означало бы
 * заставить ферму классифицировать собственную проблему за поддержку.
 */
const createSupportRequestSchema = Joi.object({
  text: Joi.string()
    .trim()
    .min(10)
    .max(2000)
    .required()
    .messages({
      'string.base': 'Текст обращения должен быть строкой',
      'string.empty': 'Опишите, что случилось',
      'string.min': 'Опишите проблему подробнее — хотя бы 10 символов',
      'string.max': 'Текст обращения не может превышать 2000 символов',
      'any.required': 'Текст обращения обязателен'
    })
});

module.exports = { createSupportRequestSchema };
