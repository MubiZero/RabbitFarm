const { sequelize } = require('../../../src/models');

const syncTestDb = async () => {
  await sequelize.sync({ force: true }); // Пересоздаёт таблицы
};

const closeTestDb = async () => {
  await sequelize.close();
};

module.exports = { syncTestDb, closeTestDb };
