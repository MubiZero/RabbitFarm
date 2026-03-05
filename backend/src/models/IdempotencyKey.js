const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
    return sequelize.define('IdempotencyKey', {
        key: {
            type: DataTypes.STRING(255),
            primaryKey: true,
        },
        user_id: {
            type: DataTypes.INTEGER,
            allowNull: false
        },
        request_path: {
            type: DataTypes.STRING(255),
            allowNull: false
        },
        request_method: {
            type: DataTypes.STRING(10),
            allowNull: false
        },
        response_status: {
            type: DataTypes.INTEGER,
            allowNull: true
        },
        response_body: {
            type: DataTypes.JSON,
            allowNull: true
        }
    }, {
        tableName: 'idempotency_keys',
        underscored: true,
        timestamps: true,
        createdAt: 'created_at',
        updatedAt: 'updated_at',
    });
};
