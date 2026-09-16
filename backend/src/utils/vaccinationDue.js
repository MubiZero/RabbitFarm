const { Op } = require('sequelize');
const { Vaccination, Rabbit, sequelize } = require('../models');

/**
 * Сколько кроликов просрочено по прививкам — и сколько ждут прививки скоро.
 *
 * Считаются животные, а не строки истории. Раньше сводка и утренний дайджест
 * складывали записи вакцинаций: кролик, привитый пять раз, давал пять
 * «просрочек», а павшие и проданные считались наравне с живыми. Число не
 * уменьшалось никогда, принять по нему решение было нельзя — и каждое утро
 * оно уходило пушем.
 *
 * Просрочен тот, у кого срок следующей прививки прошёл и **впереди ничего не
 * назначено**: иначе повторно привитый кролик оставался бы в просрочке из-за
 * своей же старой строки.
 */
const ALIVE_STATUS = { [Op.notIn]: ['dead', 'sold'] };

/** Кролики фермы, у которых впереди уже назначена прививка. */
function scheduledAheadSubquery(farmId) {
  return sequelize.literal(
    '(SELECT v2.rabbit_id FROM vaccinations v2 '
    + `WHERE v2.farm_id = ${Number(farmId)} `
    + 'AND v2.rabbit_id IS NOT NULL '
    + 'AND v2.next_vaccination_date >= NOW())'
  );
}

const aliveRabbit = {
  model: Rabbit,
  as: 'rabbit',
  attributes: [],
  required: true,
  where: { status: ALIVE_STATUS }
};

async function overdueRabbits(farmId) {
  return Vaccination.count({
    distinct: true,
    col: 'rabbit_id',
    include: [aliveRabbit],
    where: {
      farm_id: farmId,
      rabbit_id: { [Op.ne]: null, [Op.notIn]: scheduledAheadSubquery(farmId) },
      next_vaccination_date: { [Op.lt]: new Date() }
    }
  });
}

async function upcomingRabbits(farmId, days = 30) {
  const until = new Date(Date.now() + days * 24 * 60 * 60 * 1000);

  return Vaccination.count({
    distinct: true,
    col: 'rabbit_id',
    include: [aliveRabbit],
    where: {
      farm_id: farmId,
      rabbit_id: { [Op.ne]: null },
      next_vaccination_date: { [Op.between]: [new Date(), until] }
    }
  });
}

module.exports = { overdueRabbits, upcomingRabbits };
