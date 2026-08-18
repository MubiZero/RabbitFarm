/**
 * Русские формулировки по умолчанию для Joi.
 *
 * Подключаются один раз в middleware валидации, поэтому каждое правило
 * отвечает по-русски без блока `.messages()` на каждое поле. Собственные
 * сообщения в схемах имеют приоритет — они точнее общей формулировки.
 */
const ruMessages = {
  'any.required': '{{#label}} — обязательное поле',
  'any.only': '{{#label}} имеет недопустимое значение',
  'any.unknown': 'Поле {{#label}} не поддерживается',
  'any.invalid': '{{#label}} имеет недопустимое значение',

  'string.base': '{{#label}} должно быть строкой',
  'string.empty': '{{#label}} не может быть пустым',
  'string.min': '{{#label}} должно быть не короче {{#limit}} символов',
  'string.max': '{{#label}} должно быть не длиннее {{#limit}} символов',
  'string.length': '{{#label}} должно содержать ровно {{#limit}} символов',
  'string.email': '{{#label}} должно быть корректным email',
  'string.uri': '{{#label}} должно быть корректной ссылкой',
  'string.pattern.base': '{{#label}} имеет неверный формат',

  'number.base': '{{#label}} должно быть числом',
  'number.integer': '{{#label}} должно быть целым числом',
  'number.min': '{{#label}} должно быть не меньше {{#limit}}',
  'number.max': '{{#label}} должно быть не больше {{#limit}}',
  'number.positive': '{{#label}} должно быть больше нуля',
  'number.negative': '{{#label}} должно быть меньше нуля',
  'number.greater': '{{#label}} должно быть больше {{#limit}}',
  'number.less': '{{#label}} должно быть меньше {{#limit}}',

  'date.base': '{{#label}} должно быть датой',
  'date.format': '{{#label}} должно быть датой в формате {{#format}}',
  'date.min': '{{#label}} не может быть раньше {{#limit}}',
  'date.max': '{{#label}} не может быть позже {{#limit}}',

  'boolean.base': '{{#label}} должно быть true или false',

  'array.base': '{{#label}} должно быть списком',
  'array.min': '{{#label}} должно содержать хотя бы {{#limit}} элементов',
  'array.max': '{{#label}} должно содержать не больше {{#limit}} элементов',

  'object.base': '{{#label}} должно быть объектом',
  'object.unknown': 'Поле {{#label}} не поддерживается',
  'object.missing': 'Нужно заполнить хотя бы одно поле',

  'alternatives.match': '{{#label}} имеет недопустимое значение'
};

module.exports = ruMessages;
