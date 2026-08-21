const { Breed, Rabbit } = require('../models');
const logger = require('../utils/logger');

/**
 * Breed service
 * Business logic for breed management
 *
 * Породы принадлежат ферме: каждый запрос ограничен user_id владельца,
 * поэтому чужую породу нельзя ни увидеть, ни изменить, ни удалить.
 */
class BreedService {
  /**
   * Get all breeds of a farm
   * @param {Number} userId - Owner ID
   * @returns {Array} Breeds
   */
  async getAllBreeds(userId) {
    try {
      const breeds = await Breed.findAll({
        where: { user_id: userId },
        order: [['name', 'ASC']]
      });

      return breeds;
    } catch (error) {
      logger.error('Get all breeds error', { error: error.message, userId });
      throw error;
    }
  }

  /**
   * Get breed by ID
   * @param {Number} breedId - Breed ID
   * @param {Number} userId - Owner ID
   * @returns {Object} Breed
   */
  async getBreedById(breedId, userId) {
    try {
      const breed = await Breed.findOne({
        where: { id: breedId, user_id: userId }
      });

      if (!breed) {
        throw new Error('BREED_NOT_FOUND');
      }

      return breed;
    } catch (error) {
      logger.error('Get breed error', { error: error.message, breedId, userId });
      throw error;
    }
  }

  /**
   * Create new breed
   * @param {Object} breedData - Breed data
   * @param {Number} userId - Owner ID
   * @returns {Object} Created breed
   */
  async createBreed(breedData, userId) {
    try {
      // Имя уникально в пределах фермы: у соседа может быть порода
      // с таким же названием, и это не конфликт.
      const existing = await Breed.findOne({
        where: { name: breedData.name, user_id: userId }
      });
      if (existing) {
        throw new Error('BREED_NAME_EXISTS');
      }

      const breed = await Breed.create({ ...breedData, user_id: userId });

      logger.info('Breed created', { breedId: breed.id, userId });
      return breed;
    } catch (error) {
      logger.error('Create breed error', { error: error.message, userId });
      throw error;
    }
  }

  /**
   * Update breed
   * @param {Number} breedId - Breed ID
   * @param {Object} updateData - Data to update
   * @param {Number} userId - Owner ID
   * @returns {Object} Updated breed
   */
  async updateBreed(breedId, updateData, userId) {
    try {
      const breed = await Breed.findOne({
        where: { id: breedId, user_id: userId }
      });

      if (!breed) {
        throw new Error('BREED_NOT_FOUND');
      }

      if (updateData.name && updateData.name !== breed.name) {
        const existing = await Breed.findOne({
          where: { name: updateData.name, user_id: userId }
        });
        if (existing) {
          throw new Error('BREED_NAME_EXISTS');
        }
      }

      // user_id не берём из тела запроса: породу нельзя переписать на чужую ферму.
      const { user_id: _ignored, ...safeData } = updateData;
      await breed.update(safeData);

      logger.info('Breed updated', { breedId, userId });
      return breed;
    } catch (error) {
      logger.error('Update breed error', { error: error.message, breedId, userId });
      throw error;
    }
  }

  /**
   * Delete breed
   * @param {Number} breedId - Breed ID
   * @param {Number} userId - Owner ID
   */
  async deleteBreed(breedId, userId) {
    try {
      const breed = await Breed.findOne({
        where: { id: breedId, user_id: userId }
      });

      if (!breed) {
        throw new Error('BREED_NOT_FOUND');
      }

      const rabbitCount = await Rabbit.count({
        where: { breed_id: breedId, user_id: userId }
      });
      if (rabbitCount > 0) {
        throw new Error('BREED_HAS_RABBITS');
      }

      await breed.destroy();

      logger.info('Breed deleted', { breedId, userId });
      return { success: true };
    } catch (error) {
      logger.error('Delete breed error', { error: error.message, breedId, userId });
      throw error;
    }
  }
}

module.exports = new BreedService();
