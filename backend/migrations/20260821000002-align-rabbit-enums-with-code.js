'use strict';

/**
 * Приводим ENUM'ы кроликов к тому, что реально пишет код.
 *
 * Модель и валидатор давно допускают status='active' и sex='unknown', а в
 * схеме этих значений нет. MySQL в strict-режиме отвергает такую запись, из-за
 * чего регистрация окрола (birthController ставит матери 'active') и заведение
 * крольчонка без определённого пола падают уже после деплоя — тесты этого не
 * видят, потому что строят базу из моделей, а не из миграций.
 */
module.exports = {
    up: async (queryInterface, Sequelize) => {
        await queryInterface.changeColumn('rabbits', 'status', {
            type: Sequelize.ENUM('healthy', 'active', 'sick', 'quarantine', 'pregnant', 'sold', 'dead'),
            allowNull: false,
            defaultValue: 'healthy'
        });

        await queryInterface.changeColumn('rabbits', 'sex', {
            type: Sequelize.ENUM('male', 'female', 'unknown'),
            allowNull: false,
            defaultValue: 'unknown'
        });
    },

    down: async (queryInterface, Sequelize) => {
        // Откат сузит набор значений, поэтому сначала переводим уже
        // существующие строки в значения, которые старая схема принимает.
        await queryInterface.sequelize.query(
            "UPDATE `rabbits` SET `status` = 'healthy' WHERE `status` = 'active'"
        );
        await queryInterface.sequelize.query(
            "UPDATE `rabbits` SET `sex` = 'female' WHERE `sex` = 'unknown'"
        );

        await queryInterface.changeColumn('rabbits', 'status', {
            type: Sequelize.ENUM('healthy', 'sick', 'quarantine', 'pregnant', 'sold', 'dead'),
            allowNull: false,
            defaultValue: 'healthy'
        });
        await queryInterface.changeColumn('rabbits', 'sex', {
            type: Sequelize.ENUM('male', 'female'),
            allowNull: false
        });
    }
};
