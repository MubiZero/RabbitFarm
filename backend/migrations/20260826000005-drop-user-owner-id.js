'use strict';

/**
 * Убираем `users.owner_id`.
 *
 * Колонка отвечала сразу на два вопроса: к какой ферме относится человек и
 * кто на ферме главный. Оба ответа теперь записаны отдельно и точнее —
 * `users.farm_id` и `farms.owner_id`. Пока старая колонка на месте, у
 * принадлежности два источника, и ничто не мешает им разойтись: запрос,
 * обновивший один, оставит второй прежним, и человек окажется в двух
 * хозяйствах сразу.
 */
module.exports = {
    up: async (queryInterface, Sequelize) => {
        const { sequelize } = queryInterface;

        // Расхождение здесь означало бы, что перенос ферм прочитал не то.
        // Лучше остановиться, чем потерять признак принадлежности.
        const [[{ mismatched }]] = await sequelize.query(`
            SELECT COUNT(*) AS mismatched FROM users
            WHERE farm_id <> COALESCE(owner_id, id)
        `);
        if (Number(mismatched) > 0) {
            throw new Error(
                `Удаление owner_id: у ${mismatched} пользователей farm_id и owner_id ` +
                'расходятся. Разберитесь, какое значение верное, прежде чем снимать колонку.'
            );
        }

        await dropForeignKeys(queryInterface, 'users', 'owner_id');
        await queryInterface.removeColumn('users', 'owner_id');
        void Sequelize;
    },

    down: async (queryInterface, Sequelize) => {
        const { sequelize } = queryInterface;

        await queryInterface.addColumn('users', 'owner_id', {
            type: Sequelize.INTEGER,
            allowNull: true
        });
        // Владелец сам себе не начальник — у него колонка снова пустая.
        await sequelize.query(`
            UPDATE users u
            JOIN farms f ON f.id = u.farm_id
            SET u.owner_id = CASE WHEN f.owner_id = u.id THEN NULL ELSE f.owner_id END
        `);
        await queryInterface.addConstraint('users', {
            fields: ['owner_id'],
            type: 'foreign key',
            name: 'fk_users_owner',
            references: { table: 'users', field: 'id' },
            onUpdate: 'CASCADE',
            onDelete: 'CASCADE'
        });
    }
};

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
