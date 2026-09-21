const express = require('express');
const router = express.Router();
const planService = require('../services/planService');
const ApiResponse = require('../utils/apiResponse');

/**
 * Тарифы — публично, без входа.
 *
 * Про деньги спрашивают до регистрации, а не после: в знакомстве человек
 * говорит, сколько у него кроликов, и сразу видит, во что это обойдётся.
 * Узнать цену, уже заведя хозяйство и триста записей, — тот самый тупик,
 * который разбирал `docs/plans/DEAD-ENDS.md`.
 *
 * Отдаём только то, чем тарифы и различаются: предел поголовья, предел
 * работников и цену. `null` в пределах означает «без ограничения». Выключенные
 * тарифы наружу не идут — предлагать то, чего нельзя выбрать, незачем.
 *
 * Внутренние поля (сколько ферм на тарифе, флаг «по умолчанию») остаются в
 * платформенной админке: это наша кухня, а не ответ на вопрос покупателя.
 */
router.get('/', async (req, res, next) => {
  try {
    const plans = await planService.list();

    const offered = plans
      .filter((plan) => plan.is_active)
      .map((plan) => ({
        id: plan.id,
        name: plan.name,
        max_rabbits: plan.max_rabbits,
        max_staff: plan.max_staff,
        price: plan.price === null ? null : Number(plan.price)
      }))
      // От меньшего к большему: «без ограничения» — самый большой, и стоит
      // последним, а не первым, как вышло бы при сортировке с null.
      .sort((a, b) => {
        const left = a.max_rabbits === null ? Infinity : a.max_rabbits;
        const right = b.max_rabbits === null ? Infinity : b.max_rabbits;
        return left - right;
      });

    return ApiResponse.success(res, { plans: offered });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
