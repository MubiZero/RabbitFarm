const { Op } = require('sequelize');
const { Task } = require('../models');
const logger = require('../utils/logger');

/**
 * Закрыть задачи, которые сервер завёл сам, когда дело уже сделано.
 *
 * Сервер заводит шесть видов задач по ходу цикла: прощупать, поставить
 * маточник, ожидаемый окрол, взвесить, глаза открылись, отсадка. Закрыть их
 * до сих пор мог только человек галочкой — и почти никогда не закрывал,
 * потому что дело он делает не через задачу, а через запись. Записал окрол —
 * «прощупать» и «ожидаемый окрол» остаются просроченными навсегда и каждое
 * утро в 08:00 уходят пушем. Кролик пал или продан — его задачи тоже
 * остаются.
 *
 * Закрываются только автоматические (`title_key` заполнен): задачу, которую
 * человек завёл руками, снимать за него нельзя — мы не знаем, что он имел в
 * виду.
 */
async function closeAutoTasks({ farmId, rabbitId, keys = null }) {
  if (!farmId || !rabbitId) return 0;

  const where = {
    farm_id: farmId,
    rabbit_id: rabbitId,
    status: { [Op.in]: ['pending', 'in_progress'] },
    title_key: keys ? { [Op.in]: keys } : { [Op.ne]: null }
  };

  try {
    const [count] = await Task.update(
      { status: 'completed', completed_at: new Date() },
      { where }
    );
    if (count > 0) {
      logger.info('Auto tasks closed by event', { farmId, rabbitId, keys, count });
    }
    return count;
  } catch (error) {
    // Закрытие задачи — следствие, а не само действие: сбой здесь не должен
    // отменять запись окрола или отметку падежа.
    logger.error('Failed to close auto tasks', {
      farmId,
      rabbitId,
      error: error.message
    });
    return 0;
  }
}

module.exports = { closeAutoTasks };
