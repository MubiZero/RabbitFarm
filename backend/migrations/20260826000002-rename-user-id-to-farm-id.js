'use strict';

/**
 * Колонка, хранящая ферму, начинает называться фермой.
 *
 * Кролики, клетки, корма, породы и случки уже разделены по хозяйствам, но
 * колонка называется `user_id` и ссылается на пользователя. Имя врёт: там
 * лежит не автор записи, а хозяйство, которому она принадлежит. Из-за этого
 * в сервисах регулярно путали «чьё» и «кто внёс» — так появилась ведомость,
 * которая показывала операции одного человека вместо операций фермы.
 *
 * Данные не переписываются: предыдущая миграция завела фермы с теми же
 * номерами, что у их владельцев, поэтому значения уже верные. Меняются имя
 * колонки, цель внешнего ключа и имена индексов.
 */
const TABLES = ['rabbits', 'cages', 'feeds', 'breeds', 'breedings'];

/** Индексы, чьи имена тоже говорили про пользователя. */
const INDEX_RENAMES = [
    { table: 'rabbits', columns: ['user_id', 'tag_id'], to: 'unique_farm_rabbit_tag' },
    { table: 'cages', columns: ['user_id', 'number'], to: 'unique_farm_cage_number' },
    { table: 'feeds', columns: ['user_id', 'name'], to: 'unique_farm_feed_name' },
    { table: 'breeds', columns: ['user_id', 'name'], to: 'unique_farm_breed_name' },
    { table: 'rabbits', columns: ['user_id'], to: 'idx_rabbits_farm' },
    { table: 'cages', columns: ['user_id'], to: 'idx_cages_farm' },
    { table: 'feeds', columns: ['user_id'], to: 'idx_feeds_farm' },
    { table: 'breeds', columns: ['user_id'], to: 'idx_breeds_farm' },
    { table: 'breedings', columns: ['user_id'], to: 'idx_breedings_farm' }
];

module.exports = {
    up: async (queryInterface) => {
        const { sequelize } = queryInterface;

        // Индексы переименовываем до колонки: искать их проще по старому
        // имени столбца, пока оно ещё старое.
        for (const rename of INDEX_RENAMES) {
            await renameIndexByColumns(queryInterface, rename.table, rename.columns, rename.to);
        }

        for (const table of TABLES) {
            await dropForeignKeys(queryInterface, table, 'user_id');
            await sequelize.query(
                `ALTER TABLE \`${table}\` RENAME COLUMN \`user_id\` TO \`farm_id\``
            );
            await queryInterface.addConstraint(table, {
                fields: ['farm_id'],
                type: 'foreign key',
                name: `fk_${table}_farm`,
                references: { table: 'farms', field: 'id' },
                onUpdate: 'CASCADE',
                // Удалили ферму — ушли её кролики, клетки и корма.
                onDelete: 'CASCADE'
            });
        }
    },

    down: async (queryInterface) => {
        const { sequelize } = queryInterface;

        for (const table of TABLES) {
            await dropForeignKeys(queryInterface, table, 'farm_id');
            await sequelize.query(
                `ALTER TABLE \`${table}\` RENAME COLUMN \`farm_id\` TO \`user_id\``
            );
            await queryInterface.addConstraint(table, {
                fields: ['user_id'],
                type: 'foreign key',
                name: `fk_${table}_user`,
                references: { table: 'users', field: 'id' },
                onUpdate: 'CASCADE',
                onDelete: 'CASCADE'
            });
        }

        for (const rename of INDEX_RENAMES) {
            const from = rename.to;
            const to = rename.columns.length > 1
                ? from.replace('unique_farm', 'unique_user')
                : `${rename.table}_user_id`;
            await renameIndexByName(queryInterface, rename.table, from, to);
        }
    }
};

/**
 * Ищет индекс по точному набору колонок и переименовывает.
 *
 * По имени искать нельзя: часть индексов создал Sequelize из модели, часть —
 * миграция с собственным именем, а инлайновые из createTable называет сам
 * MySQL. Набор колонок одинаков во всех трёх случаях.
 */
async function renameIndexByColumns(queryInterface, table, columns, to) {
    const indexes = await queryInterface.showIndex(table);

    const target = indexes.find((index) => {
        if (index.name === 'PRIMARY' || index.name === to) return false;
        const fields = index.fields.map((field) => field.attribute);
        return fields.length === columns.length &&
            fields.every((field, i) => field === columns[i]);
    });

    if (target) {
        await renameIndexByName(queryInterface, table, target.name, to);
    }
}

async function renameIndexByName(queryInterface, table, from, to) {
    if (from === to) return;
    const indexes = await queryInterface.showIndex(table);
    if (!indexes.some((index) => index.name === from)) return;
    if (indexes.some((index) => index.name === to)) return;

    await queryInterface.sequelize.query(
        `ALTER TABLE \`${table}\` RENAME INDEX \`${from}\` TO \`${to}\``
    );
}

async function dropForeignKeys(queryInterface, table, column) {
    const [keys] = await queryInterface.sequelize.query(`
        SELECT CONSTRAINT_NAME AS name
        FROM information_schema.KEY_COLUMN_USAGE
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = '${table}'
          AND COLUMN_NAME = '${column}'
          AND REFERENCED_TABLE_NAME IS NOT NULL
    `);

    for (const key of keys) {
        await queryInterface.removeConstraint(table, key.name);
    }
}
