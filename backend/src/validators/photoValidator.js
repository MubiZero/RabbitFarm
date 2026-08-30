const Joi = require('joi');
const listQuery = require('./listQuery');

/** Параметры ленты фото по ферме — для Дневника. */
const listFarmPhotosQuerySchema = Joi.object({
  page: listQuery.page,
  limit: listQuery.limit.default(50),
  sort_by: listQuery.sortBy(['created_at'], 'created_at'),
  sort_order: listQuery.sortOrder.default('DESC'),
  from_date: listQuery.fromDate,
  to_date: listQuery.toDate
});

module.exports = { listFarmPhotosQuerySchema };
