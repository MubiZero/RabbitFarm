const { Breed, Rabbit } = require('../models');
const logger = require('../utils/logger');

/**
 * Breed service
 * Business logic for breed management
 *
 * Породы принадлежат ферме: каждый запрос ограничен farm_id хозяйства,
 * поэтому чужую породу нельзя ни увидеть, ни изменить, ни удалить.
 */
class BreedService {
  /**
   * Get all breeds of a farm
   * @param {Number} farmId - id хозяйства
   * @returns {Array} Breeds
   */
  async getAllBreeds(farmId) {
    try {
      const breeds = await Breed.findAll({
        where: { farm_id: farmId },
        order: [['name', 'ASC']]
      });

      return breeds;
    } catch (error) {
      logger.error('Get all breeds error', { error: error.message, farmId });
      throw error;
    }
  }

  /**
   * Get breed by ID
   * @param {Number} breedId - Breed ID
   * @param {Number} farmId - id хозяйства
   * @returns {Object} Breed
   */
  async getBreedById(breedId, farmId) {
    try {
      const breed = await Breed.findOne({
        where: { id: breedId, farm_id: farmId }
      });

      if (!breed) {
        throw new Error('BREED_NOT_FOUND');
      }

      return breed;
    } catch (error) {
      logger.error('Get breed error', { error: error.message, breedId, farmId });
      throw error;
    }
  }

  /**
   * Create new breed
   * @param {Object} breedData - Breed data
   * @param {Number} farmId - id хозяйства
   * @returns {Object} Created breed
   */
  async createBreed(breedData, farmId) {
    try {
      // Имя уникально в пределах фермы: у соседа может быть порода
      // с таким же названием, и это не конфликт.
      const existing = await Breed.findOne({
        where: { name: breedData.name, farm_id: farmId }
      });
      if (existing) {
        throw new Error('BREED_NAME_EXISTS');
      }

      const breed = await Breed.create({ ...breedData, farm_id: farmId });

      logger.info('Breed created', { breedId: breed.id, farmId });
      return breed;
    } catch (error) {
      logger.error('Create breed error', { error: error.message, farmId });
      throw error;
    }
  }

  /**
   * Update breed
   * @param {Number} breedId - Breed ID
   * @param {Object} updateData - Data to update
   * @param {Number} farmId - id хозяйства
   * @returns {Object} Updated breed
   */
  async updateBreed(breedId, updateData, farmId) {
    try {
      const breed = await Breed.findOne({
        where: { id: breedId, farm_id: farmId }
      });

      if (!breed) {
        throw new Error('BREED_NOT_FOUND');
      }

      if (updateData.name && updateData.name !== breed.name) {
        const existing = await Breed.findOne({
          where: { name: updateData.name, farm_id: farmId }
        });
        if (existing) {
          throw new Error('BREED_NAME_EXISTS');
        }
      }

      // farm_id не берём из тела запроса: породу нельзя переписать на чужую ферму.
      const { farm_id: _ignored, ...safeData } = updateData;
      await breed.update(safeData);

      logger.info('Breed updated', { breedId, farmId });
      return breed;
    } catch (error) {
      logger.error('Update breed error', { error: error.message, breedId, farmId });
      throw error;
    }
  }

  /**
   * Delete breed
   * @param {Number} breedId - Breed ID
   * @param {Number} farmId - id хозяйства
   */
  async deleteBreed(breedId, farmId) {
    try {
      const breed = await Breed.findOne({
        where: { id: breedId, farm_id: farmId }
      });

      if (!breed) {
        throw new Error('BREED_NOT_FOUND');
      }

      const rabbitCount = await Rabbit.count({
        where: { breed_id: breedId, farm_id: farmId }
      });
      if (rabbitCount > 0) {
        throw new Error('BREED_HAS_RABBITS');
      }

      await breed.destroy();

      logger.info('Breed deleted', { breedId, farmId });
      return { success: true };
    } catch (error) {
      logger.error('Delete breed error', { error: error.message, breedId, farmId });
      throw error;
    }
  }
}

module.exports = new BreedService();
