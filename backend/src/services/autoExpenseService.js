const { Transaction } = require('../models');

/**
 * Расход, созданный автоматически из медицинской записи или вакцинации.
 *
 * Стоимость лечения и прививки — это одновременно и запись о здоровье, и
 * трата фермы. Раньше расход создавался при заведении записи и дальше жил
 * сам по себе: правка стоимости его не трогала (найти нужную транзакцию было
 * нечем), а удаление записи оставляло его в ведомости сиротой. Здесь эта
 * связь ведётся целиком, во всех трёх направлениях.
 *
 * Удаление обрабатывает сама база: внешний ключ объявлен с CASCADE.
 *
 * `farmId` — хозяйство записи о здоровье, `userId` — человек, который её
 * завёл. Это разные вещи: в книгу расход попадает по ферме, а в графе «кто
 * внёс» стоит сотрудник, а не хозяин. По ферме же ищется и уже созданный
 * расход — иначе правка стоимости шарила бы по чужим строкам.
 */
async function syncAutoExpense({
  link,
  cost,
  rabbitId,
  transactionDate,
  description,
  farmId,
  userId,
  transaction
}) {
  const amount = cost === null || cost === undefined || cost === '' ? 0 : parseFloat(cost);
  const existing = await Transaction.findOne({ where: { ...link, farm_id: farmId }, transaction });

  // Стоимость убрали — расход тоже должен уйти, иначе в ведомости остаётся
  // трата, которой на карточке уже не видно.
  if (!(amount > 0)) {
    if (existing) await existing.destroy({ transaction });
    return null;
  }

  const fields = {
    type: 'expense',
    category: 'veterinary',
    amount,
    transaction_date: transactionDate || new Date(),
    rabbit_id: rabbitId,
    description
  };

  if (existing) {
    await existing.update(fields, { transaction });
    return existing;
  }

  return Transaction.create(
    { ...fields, ...link, farm_id: farmId, created_by: userId },
    { transaction }
  );
}

module.exports = { syncAutoExpense };
