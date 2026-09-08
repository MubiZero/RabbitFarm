const cron = require('node-cron');
const { Op } = require('sequelize');
const { Farm, Rabbit, Breeding, Birth, FeedingRecord } = require('../models');
const fileStorage = require('../utils/fileStorage');
const logger = require('../utils/logger');

// Раз в сутки ночью — физическая зачистка не бьёт по нагрузке рабочего дня.
const CRON_SCHEDULE = '30 3 * * *';
const RETENTION_DAYS = 30;
const MS_PER_DAY = 24 * 60 * 60 * 1000;

/**
 * Таблицы, которые нужно снести самим — до удаления строки фермы.
 *
 * Каскада `farms` для них недостаточно, и это проверено живьём: внутри одной
 * фермы есть встречные RESTRICT-ключи (`rabbits.breed_id -> breeds`,
 * `breedings.male_id`/`female_id` и `births.mother_id -> rabbits`,
 * `feeding_records.feed_id -> feeds`). Каскад сносит дочерние таблицы в
 * произвольном порядке, и `DELETE FROM farms` падает с «Cannot delete or
 * update a parent row», как только у фермы есть хотя бы один кролик. RESTRICT
 * при этом правильный — он про удаление одной записи («нельзя убрать породу,
 * на которой висят кролики»), и менять его на CASCADE значило бы, что
 * удаление кролика тихо уносит его спаривания.
 *
 * Порядок — снизу вверх по этим ссылкам: сначала то, что мешает, потом то,
 * что мешали удалить. Остальное (породы, корма, клетки, люди, платежи, фото,
 * заметки, задачи) уносит уже каскад самой фермы.
 */
const BLOCKING_TABLES = [FeedingRecord, Birth, Breeding, Rabbit];

/**
 * Физическое удаление одной фермы, чей срок мягкого удаления истёк.
 *
 * Порядок важен: сперва файлы в MinIO (у записи ещё есть `id`, без него
 * префикс не собрать), потом записи, мешающие каскаду, и только потом сама
 * ферма.
 */
async function purgeFarm(farm) {
  await fileStorage.deleteByPrefix(`farm-${farm.id}/`);

  for (const Model of BLOCKING_TABLES) {
    await Model.destroy({ where: { farm_id: farm.id } });
  }

  await farm.destroy();
}

/**
 * Обход всех ферм, удалённых больше 30 дней назад. Одна упавшая ферма не
 * останавливает остальные: сбой на чужих данных не должен превращаться в
 * бессрочно растущее хранилище.
 */
async function runPurge() {
  const cutoff = new Date(Date.now() - RETENTION_DAYS * MS_PER_DAY);
  const farms = await Farm.findAll({ where: { deleted_at: { [Op.lt]: cutoff } } });

  for (const farm of farms) {
    try {
      await purgeFarm(farm);
      logger.info('Farm purged', { farmId: farm.id });
    } catch (error) {
      logger.error('Farm purge failed', { farmId: farm.id, error: error.message });
    }
  }
}

function startFarmPurgeJob() {
  const task = cron.schedule(CRON_SCHEDULE, () => {
    runPurge().catch(error => logger.error('Farm purge job failed', { error: error.message }));
  });

  logger.info('Farm purge job started', { schedule: CRON_SCHEDULE });
  return task;
}

module.exports = { startFarmPurgeJob, runPurge, purgeFarm };
