'use strict';

/**
 * Ферма становится сущностью.
 *
 * До сих пор фермы как записи не существовало: ею считался идентификатор
 * владельца, а принадлежность вычислялась в middleware выражением
 * `user.owner_id || user.id`. Пока хозяйство одно, это работает; для сервиса,
 * где ферм много, это выражение — единственное, что стоит между данными
 * разных клиентов, и оно живёт в коде, а не в схеме. База при этом не
 * возражает против строки, приписанной чужой ферме: ей нечего проверять.
 *
 * Здесь у фермы появляется собственная строка, имя и владелец, а у
 * пользователя — `farm_id`. Дальше по нему выстраиваются все остальные
 * таблицы, и целостность начинает держать внешний ключ, а не дисциплина
 * в сервисах.
 *
 * Идентификаторы существующих ферм намеренно совпадают с идентификаторами их
 * владельцев. Это не связь, а приём переноса: колонки `user_id` на кроликах,
 * клетках, кормах, породах и случках уже хранят именно это значение, и при
 * таком переносе следующая миграция переименовывает их, не переписывая ни
 * одной строки. Новые фермы получают номера из общего счётчика и с
 * пользователями уже никак не связаны.
 */
module.exports = {
    up: async (queryInterface, Sequelize) => {
        const { sequelize } = queryInterface;

        // Всё, что может помешать переносу, выясняем до первого ALTER.
        // MySQL не откатывает изменения схемы: упади миграция посередине,
        // база останется наполовину перенесённой, а повторный запуск
        // споткнётся уже о собственную работу.
        const [[{ dangling }]] = await sequelize.query(`
            SELECT COUNT(*) AS dangling FROM users u
            WHERE u.owner_id IS NOT NULL
              AND NOT EXISTS (SELECT 1 FROM users o WHERE o.id = u.owner_id)
        `);
        if (Number(dangling) > 0) {
            throw new Error(
                `Перенос ферм: у ${dangling} пользователей owner_id указывает на ` +
                'несуществующего владельца. Почините эти строки и повторите миграцию.'
            );
        }

        // Работник, чей владелец сам работник, ломает саму идею фермы:
        // хозяйство должно определяться одним шагом, а не цепочкой.
        const [[{ nested }]] = await sequelize.query(`
            SELECT COUNT(*) AS nested FROM users u
            JOIN users o ON o.id = u.owner_id
            WHERE o.owner_id IS NOT NULL
        `);
        if (Number(nested) > 0) {
            throw new Error(
                `Перенос ферм: у ${nested} пользователей владелец сам числится ` +
                'работником другой фермы. Такая цепочка не переносится однозначно.'
            );
        }

        await queryInterface.createTable('farms', {
            id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                autoIncrement: true
            },
            name: {
                type: Sequelize.STRING(255),
                allowNull: false
            },
            // Владелец заполняется вторым шагом: пользователь ссылается на
            // ферму, а ферма — на пользователя, и при регистрации кто-то из
            // двоих обязан появиться раньше.
            owner_id: {
                type: Sequelize.INTEGER,
                allowNull: true
            },
            created_at: {
                type: Sequelize.DATE,
                allowNull: false,
                defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
            },
            updated_at: {
                type: Sequelize.DATE,
                allowNull: false,
                defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
            }
        });

        // Одна ферма на каждого, у кого нет владельца: до этой миграции
        // именно `owner_id IS NULL` означало «сам себе хозяйство».
        await sequelize.query(`
            INSERT INTO farms (id, name, owner_id, created_at, updated_at)
            SELECT id, CONCAT('Ферма ', full_name), id, created_at, updated_at
            FROM users
            WHERE owner_id IS NULL
        `);

        // Счётчик после переноса указывает за самый большой занятый номер,
        // иначе первая же новая ферма попробует занять чужой.
        const [[{ next }]] = await sequelize.query(
            'SELECT COALESCE(MAX(id), 0) + 1 AS next FROM farms'
        );
        await sequelize.query(`ALTER TABLE farms AUTO_INCREMENT = ${Number(next)}`);

        await queryInterface.addConstraint('farms', {
            fields: ['owner_id'],
            type: 'foreign key',
            name: 'fk_farms_owner',
            references: { table: 'users', field: 'id' },
            onUpdate: 'CASCADE',
            // Ссылка обнуляется, а не запрещает удаление.
            //
            // Сначала здесь стоял RESTRICT — «владельца нельзя удалить
            // из-под фермы». Вместе со встречным CASCADE у `users.farm_id`
            // это делало невозможным удаление самой фермы: MySQL отказывался
            // рвать круг. Отключить клиента, выполнить требование об удалении
            // данных или прибрать брошенную регистрацию стало нельзя вовсе.
            //
            // Правило «у фермы должен быть хозяин» — это правило продукта, и
            // живёт оно в staffService, который отказывается трогать
            // владельца. Дело внешнего ключа — целостность ссылок, а не
            // политика.
            onDelete: 'SET NULL'
        });
        await queryInterface.addIndex('farms', ['owner_id'], { name: 'idx_farms_owner' });

        // NOT NULL сразу не поставить: колонку надо сперва заполнить.
        await queryInterface.addColumn('users', 'farm_id', {
            type: Sequelize.INTEGER,
            allowNull: true
        });
        await sequelize.query('UPDATE users SET farm_id = COALESCE(owner_id, id)');

        await sequelize.query(
            'ALTER TABLE users MODIFY COLUMN farm_id INT NOT NULL'
        );
        await queryInterface.addConstraint('users', {
            fields: ['farm_id'],
            type: 'foreign key',
            name: 'fk_users_farm',
            references: { table: 'farms', field: 'id' },
            onUpdate: 'CASCADE',
            // Удаление фермы уносит её людей: учётная запись работника вне
            // хозяйства не значит ничего.
            onDelete: 'CASCADE'
        });
        await queryInterface.addIndex('users', ['farm_id'], { name: 'idx_users_farm' });

        // Приглашение уже носит имя `farm_id`, но ссылается на пользователя.
        // Значение то же самое, меняется только цель внешнего ключа.
        await dropForeignKeys(queryInterface, 'invitations', 'farm_id');
        await queryInterface.addConstraint('invitations', {
            fields: ['farm_id'],
            type: 'foreign key',
            name: 'fk_invitations_farm',
            references: { table: 'farms', field: 'id' },
            onUpdate: 'CASCADE',
            onDelete: 'CASCADE'
        });
    },

    down: async (queryInterface) => {
        await dropForeignKeys(queryInterface, 'invitations', 'farm_id');
        await queryInterface.addConstraint('invitations', {
            fields: ['farm_id'],
            type: 'foreign key',
            name: 'invitations_farm_id_fkey',
            references: { table: 'users', field: 'id' },
            onUpdate: 'CASCADE',
            onDelete: 'CASCADE'
        });

        await dropForeignKeys(queryInterface, 'users', 'farm_id');
        await queryInterface.removeColumn('users', 'farm_id');
        await queryInterface.dropTable('farms');
    }
};

/**
 * Внешние ключи MySQL называет как придётся: на одной базе имя задал
 * Sequelize, на другой — сам сервер. Ищем по колонке, а не по имени.
 */
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
