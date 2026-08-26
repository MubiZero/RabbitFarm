'use strict';

/**
 * Ферма появляется у таблиц, которые до сих пор жили на связях.
 *
 * Кормления, прививки, лечение, окролы, задачи, операции, фото, заметки и
 * взвешивания не имели собственной колонки хозяйства. Принадлежность
 * восстанавливали по соседям: чей кролик, чья клетка, кто внёс запись. Пока
 * ферма одна, разницы нет. Для сервиса это два разных отказа.
 *
 * Первый: фильтр по «кто внёс» — не фильтр по ферме. Именно так операции
 * работника пропадали из ведомости владельца, хотя лежали в той же таблице.
 *
 * Второй: связь, по которой восстанавливали принадлежность, обнуляема.
 * `fed_by`, `created_by` и `assigned_to` объявлены с ON DELETE SET NULL —
 * увольняем работника, и его кормления теряют единственный признак фермы.
 * Строка остаётся ничьей: её не увидит настоящий владелец и не отфильтрует
 * ни один запрос.
 *
 * После этой миграции принадлежность записана прямо в строке, а внешний ключ
 * не даст сослаться на несуществующую ферму.
 */

/**
 * Откуда берётся ферма для уже существующих строк — по убыванию надёжности.
 * Кролик и клетка принадлежат ферме сами; автор записи идёт последним, потому
 * что он и есть та обнуляемая связь, от которой мы уходим.
 */
const BACKFILL = [
    { table: 'rabbit_weights', from: [['rabbit_id', 'rabbits']] },
    { table: 'vaccinations', from: [['rabbit_id', 'rabbits']] },
    { table: 'medical_records', from: [['rabbit_id', 'rabbits']] },
    { table: 'births', from: [['mother_id', 'rabbits']] },
    { table: 'photos', from: [['rabbit_id', 'rabbits'], ['uploaded_by', 'users']] },
    { table: 'notes', from: [['rabbit_id', 'rabbits'], ['cage_id', 'cages'], ['created_by', 'users']] },
    { table: 'feeding_records', from: [['rabbit_id', 'rabbits'], ['cage_id', 'cages'], ['feed_id', 'feeds'], ['fed_by', 'users']] },
    { table: 'tasks', from: [['rabbit_id', 'rabbits'], ['cage_id', 'cages'], ['created_by', 'users'], ['assigned_to', 'users']] },
    { table: 'transactions', from: [['rabbit_id', 'rabbits'], ['created_by', 'users']] }
];

module.exports = {
    up: async (queryInterface, Sequelize) => {
        const { sequelize } = queryInterface;

        const [[{ farms }]] = await sequelize.query('SELECT COUNT(*) AS farms FROM farms');
        // Строка, у которой все связи оборваны. Если хозяйство в базе ровно
        // одно, принадлежность известна без догадок. Если ферм несколько —
        // угадывать нельзя: ошибка припишет данные чужому клиенту, а это
        // ровно то, от чего мы уходим.
        const onlyFarm = Number(farms) === 1
            ? (await sequelize.query('SELECT id FROM farms'))[0][0].id
            : null;

        // Сначала считаем, потом меняем. MySQL не откатывает DDL: если
        // остановиться на середине списка, часть таблиц окажется перенесена,
        // часть нет, и повторный запуск упадёт на уже добавленной колонке.
        if (onlyFarm === null) {
            const unresolved = [];

            for (const { table, from } of BACKFILL) {
                if (await hasColumn(queryInterface, table, 'farm_id')) continue;

                const missing = from
                    .map(([column, source]) =>
                        `NOT EXISTS (SELECT 1 FROM \`${source}\` s WHERE s.id = t.\`${column}\`)`)
                    .join(' AND ');
                const [[{ count }]] = await sequelize.query(
                    `SELECT COUNT(*) AS count FROM \`${table}\` t WHERE ${missing}`
                );

                if (Number(count) > 0) unresolved.push(`${table}: ${count}`);
            }

            if (unresolved.length > 0) {
                throw new Error(
                    'Перенос ферм: у части строк нет ни одной связи, по которой можно ' +
                    `определить хозяйство (${unresolved.join(', ')}). Ферм в базе несколько, ` +
                    'поэтому догадка недопустима. Восстановите у этих строк любую связь ' +
                    '(кролика, клетку или автора) либо удалите их, если запись потеряна, ' +
                    'и повторите миграцию. Схема не тронута.'
                );
            }
        }

        for (const { table, from } of BACKFILL) {
            // Повторный запуск после исправления данных не должен спотыкаться
            // о таблицы, которые прошлый прогон успел перенести.
            if (await hasColumn(queryInterface, table, 'farm_id')) continue;

            await queryInterface.addColumn(table, 'farm_id', {
                type: Sequelize.INTEGER,
                allowNull: true
            });

            for (const [column, source] of from) {
                await sequelize.query(`
                    UPDATE \`${table}\` t
                    JOIN \`${source}\` s ON s.id = t.\`${column}\`
                    SET t.farm_id = s.farm_id
                    WHERE t.farm_id IS NULL
                `);
            }

            if (onlyFarm !== null) {
                await sequelize.query(
                    `UPDATE \`${table}\` SET farm_id = ${Number(onlyFarm)} WHERE farm_id IS NULL`
                );
            }

            await sequelize.query(
                `ALTER TABLE \`${table}\` MODIFY COLUMN \`farm_id\` INT NOT NULL`
            );
            // Собственный индекс по ферме заводим до внешнего ключа. Иначе
            // MySQL привяжет ключ к первому подходящему индексу — например к
            // составному из следующей миграции, — и тот станет несущим:
            // откатить его будет уже нельзя.
            await queryInterface.addIndex(table, ['farm_id'], { name: `idx_${table}_farm` });

            await queryInterface.addConstraint(table, {
                fields: ['farm_id'],
                type: 'foreign key',
                name: `fk_${table}_farm`,
                references: { table: 'farms', field: 'id' },
                onUpdate: 'CASCADE',
                onDelete: 'CASCADE'
            });
        }
    },

    down: async (queryInterface) => {
        for (const { table } of [...BACKFILL].reverse()) {
            if (!await hasColumn(queryInterface, table, 'farm_id')) continue;
            await queryInterface.removeConstraint(table, `fk_${table}_farm`);
            await queryInterface.removeColumn(table, 'farm_id');
        }
    }
};

async function hasColumn(queryInterface, table, column) {
    const describe = await queryInterface.describeTable(table);
    return Object.prototype.hasOwnProperty.call(describe, column);
}
