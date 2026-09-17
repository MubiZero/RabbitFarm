const models = require('../models');
const ApiResponse = require('../utils/apiResponse');

/**
 * Свою запись работник правит сам, чужую — только старший.
 *
 * Правка кормления не проверяла роль вовсе: любой работник мог переписать
 * чужую запись, и до журнала изменений след от этого не оставался нигде.
 * Запретить работнику правку целиком тоже нельзя — опечатку в собственной
 * записи человек должен исправить сам, а не искать управляющего.
 *
 * Удаление — отдельный разговор и остаётся за `authorize(['manager',
 * 'owner'])`: исправленную запись видно, удалённую нет.
 */
const SENIOR_ROLES = ['manager', 'owner'];

const allowOwnRecord = (modelName, authorField) => async (req, res, next) => {
  try {
    if (SENIOR_ROLES.includes(req.user?.role)) return next();

    const record = await models[modelName].findOne({
      where: { id: req.params.id, farm_id: req.farmId },
      attributes: ['id', authorField]
    });

    // Записи нет или она чужой фермы — пусть отвечает контроллер своим 404:
    // иначе один и тот же промах получал бы два разных ответа.
    if (!record) return next();

    if (record.get(authorField) === req.user.id) return next();

    return ApiResponse.forbidden(
      res,
      'Чужую запись может исправить только управляющий или владелец',
      'NOT_RECORD_AUTHOR'
    );
  } catch (error) {
    next(error);
  }
};

module.exports = { allowOwnRecord };
