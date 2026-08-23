const Joi = require('joi');
const listQuery = require('./listQuery');

/**
 * Породы — единственная пара create/update в API, у которой не было схемы.
 *
 * Тело запроса уходило в Breed.create как есть: клиент мог задать собственный
 * идентификатор записи, а неверное значение purpose возвращалось общей
 * пятисоткой от базы вместо понятного объяснения, какое поле не так.
 */
const createBreedSchema = Joi.object({
  name: Joi.string()
    .max(100)
    .required()
    .messages({
      'string.empty': 'Название породы обязательно',
      'string.max': 'Название породы должно быть максимум 100 символов',
      'any.required': 'Название породы обязательно'
    }),

  description: Joi.string()
    .max(2000)
    .allow(null, '')
    .messages({
      'string.max': 'Описание не может превышать 2000 символов'
    }),

  average_weight: Joi.number()
    .precision(2)
    .min(0)
    .max(30)
    .allow(null)
    .messages({
      'number.base': 'Средний вес должен быть числом',
      'number.min': 'Средний вес не может быть отрицательным',
      'number.max': 'Средний вес не может превышать 30 кг'
    }),

  average_litter_size: Joi.number()
    .integer()
    .min(0)
    .max(30)
    .allow(null)
    .messages({
      'number.base': 'Средний размер помёта должен быть числом',
      'number.min': 'Средний размер помёта не может быть отрицательным'
    }),

  purpose: Joi.string()
    .valid('meat', 'fur', 'decorative', 'combined')
    .default('combined')
    .messages({
      'any.only': 'Назначение должно быть: meat, fur, decorative или combined'
    }),

  photo_url: Joi.string()
    .max(500)
    .allow(null, '')
    .messages({
      'string.max': 'Ссылка на фото слишком длинная'
    })
});

const updateBreedSchema = createBreedSchema.fork(
  ['name'],
  (schema) => schema.optional()
);

const listBreedsQuerySchema = Joi.object({
  page: listQuery.page,
  limit: listQuery.limit,
  sort_by: listQuery.sortBy(['name', 'average_weight', 'purpose', 'created_at'], 'name'),
  sort_order: listQuery.sortOrder.default('ASC'),
  purpose: Joi.string().valid('meat', 'fur', 'decorative', 'combined').optional(),
  search: Joi.string().allow('').optional()
});

module.exports = {
  createBreedSchema,
  updateBreedSchema,
  listBreedsQuerySchema
};
