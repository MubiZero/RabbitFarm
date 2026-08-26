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
 * Ферма расхода — та же, что у записи о здоровье: `userId` здесь автор
 * записи, участник фермы, и книга фермы читается по составу участников
 * (`farmScope` в transactionService). Класть сюда владельца вместо автора
 * нельзя — тогда в графе «кто внёс» у лечения, заведённого сотрудником,
 * оказывался хозяин.
 */
async function syncAutoExpense({
  link,
  cost,
  rabbitId,
  transactionDate,
  description,
  userId,
  transaction
}) {
  const amount = cost === null || cost === undefined || cost === '' ? 0 : parseFloat(cost);
  const existing = await Transaction.findOne({ where: link, transaction });

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
    { ...fields, ...link, created_by: userId },
    { transaction }
  );
}

module.exports = { syncAutoExpense };
