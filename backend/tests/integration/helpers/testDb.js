const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const { sequelize } = require('../../../src/models');

const BACKEND_ROOT = path.resolve(__dirname, '../../..');
const MIGRATIONS_DIR = path.join(BACKEND_ROOT, 'migrations');
const SEQUELIZE_CLI = path.join(BACKEND_ROOT, 'node_modules', '.bin', 'sequelize-cli');

/**
 * Тестовая база строится теми же миграциями, что и продакшен.
 *
 * Раньше здесь был sequelize.sync({ force: true }) — схема бралась из моделей,
 * а в продакшене из миграций. Две разные схемы никто не сравнивал, поэтому
 * расхождения (отсутствующая таблица, значение ENUM, которого нет в базе)
 * проходили CI зелёными и падали только после деплоя.
 */

/** Ронять таблицы можно только в базе, которая заведомо тестовая. */
const assertTestDatabase = () => {
  const database = sequelize.config.database;

  if (process.env.NODE_ENV !== 'test' || !/test/i.test(database || '')) {
    throw new Error(
      `Отказ выполнять сброс: база "${database}" не выглядит тестовой ` +
      `(NODE_ENV=${process.env.NODE_ENV}). Проверьте DB_TEST_NAME.`
    );
  }
};

const listTables = async () => {
  const [rows] = await sequelize.query(
    "SELECT TABLE_NAME AS name FROM information_schema.TABLES " +
    "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_TYPE = 'BASE TABLE'"
  );
  return rows.map((row) => row.name);
};

const withoutForeignKeyChecks = async (action) => {
  await sequelize.query('SET FOREIGN_KEY_CHECKS = 0');
  try {
    await action();
  } finally {
    await sequelize.query('SET FOREIGN_KEY_CHECKS = 1');
  }
};

const expectedMigrationCount = () =>
  fs.readdirSync(MIGRATIONS_DIR).filter((file) => file.endsWith('.js')).length;

const appliedMigrationCount = async () => {
  try {
    const [rows] = await sequelize.query('SELECT COUNT(*) AS applied FROM `SequelizeMeta`');
    return Number(rows[0].applied);
  } catch (error) {
    return -1; // SequelizeMeta ещё нет — база пустая
  }
};

const dropAllTables = async () => {
  const tables = await listTables();
  if (tables.length === 0) return;

  await withoutForeignKeyChecks(async () => {
    for (const table of tables) {
      await sequelize.query(`DROP TABLE IF EXISTS \`${table}\``);
    }
  });
};

const truncateAllTables = async () => {
  const tables = (await listTables()).filter((table) => table !== 'SequelizeMeta');

  await withoutForeignKeyChecks(async () => {
    for (const table of tables) {
      await sequelize.query(`TRUNCATE TABLE \`${table}\``);
    }
  });
};

const runMigrations = () => {
  execFileSync(SEQUELIZE_CLI, ['db:migrate', '--env', 'test'], {
    cwd: BACKEND_ROOT,
    env: process.env,
    stdio: 'pipe'
  });
};

/**
 * Приводит тестовую базу к актуальной схеме и очищает данные.
 * Миграции прогоняются один раз за прогон — дальше достаточно TRUNCATE.
 */
const syncTestDb = async () => {
  assertTestDatabase();

  if (await appliedMigrationCount() !== expectedMigrationCount()) {
    await dropAllTables();
    runMigrations();
  }

  await truncateAllTables();
};

const closeTestDb = async () => {
  await sequelize.close();
};

module.exports = { syncTestDb, closeTestDb };
