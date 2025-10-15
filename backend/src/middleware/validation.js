const ApiResponse = require('../utils/apiResponse');

/**
 * Validation middleware factory
 * @param {Object} schema - Joi validation schema
 * @param {String} property - Property to validate (body, query, params)
 */
const validate = (schema, property = 'body') => {
  return (req, res, next) => {
    const { error, value } = schema.validate(req[property], {
      abortEarly: false,
      stripUnknown: true
    });

    if (error) {
      const details = error.details.map(detail => ({
        field: detail.path.join('.'),
        message: detail.message.replace(/"/g, '')
      }));

      return ApiResponse.validationError(res, details);
    }

    // Replace request property with validated value
    req[property] = value;
    next();
  };
};

module.exports = validate;
