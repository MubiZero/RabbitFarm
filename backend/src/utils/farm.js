const { Op } = require('sequelize');
const { User } = require('../models');

/**
 * Идентификаторы всех, кто работает на ферме: владелец и его работники.
 *
 * Часть таблиц (кормления, транзакции, задачи) не имеет собственной колонки
 * фермы и опирается на «кто внёс запись» — fed_by, created_by, assigned_to.
 * Раньше это совпадало с владельцем, потому что пользователь был один.
 * С появлением работников такой фильтр нужно расширять до всей фермы,
 * иначе владелец не увидит работу работника, а работник — работу владельца.
 *
 * @param {Number} farmId - идентификатор фермы (id владельца)
 * @returns {Promise<Number[]>} id владельца и его работников
 */
async function farmMemberIds(farmId) {
  const members = await User.findAll({
    where: { [Op.or]: [{ id: farmId }, { owner_id: farmId }] },
    attributes: ['id']
  });

  return members.map((m) => m.id);
}

module.exports = { farmMemberIds };
