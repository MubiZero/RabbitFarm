'use strict';

/**
 * Учёт занятого места в MinIO (docs/plans/PLATFORM-ADMIN.md, 1.6).
 *
 * Размер файла нигде не хранился — ни у одиночного фото кролика
 * (`rabbits.photo_url`), ни у снимков галереи (`photos`). Оба поля nullable:
 * новые загрузки пишут размер сразу (он и так есть в req.file.size из
 * multer.memoryStorage), а существующие записи заполняет разовый скрипт
 * scripts/backfillPhotoSizes.js через MinIO statObject.
 */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('photos', 'size_bytes', {
      type: Sequelize.INTEGER,
      allowNull: true
    });
    await queryInterface.addColumn('rabbits', 'photo_size_bytes', {
      type: Sequelize.INTEGER,
      allowNull: true
    });
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn('rabbits', 'photo_size_bytes');
    await queryInterface.removeColumn('photos', 'size_bytes');
  }
};
