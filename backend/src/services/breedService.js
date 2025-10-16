const { Breed, Rabbit } = require('../models');
const logger = require('../utils/logger');

/**
 * Breed service
 * Business logic for breed management
 */
class BreedService {
  /**
   * Get all breeds
   * @returns {Array} All breeds
   */
  async getAllBreeds() {
    try {
      const breeds = await Breed.findAll({
        order: [['name', 'ASC']]
      });

      return breeds;
    } catch (error) {
      logger.error('Get all breeds error', { error: error.message });
      throw error;
    }
  }

  /**
   * Get breed by ID
   * @param {Number} breedId - Breed ID
   * @returns {Object} Breed
   */
  async getBreedById(breedId) {
    try {
      const breed = await Breed.findByPk(breedId);

      if (!breed) {
        throw new Error('BREED_NOT_FOUND');
      }

      return breed;
    } catch (error) {
      logger.error('Get breed error', { error: error.message, breedId });
      throw error;
    }
  }

  /**
   * Create new breed
   * @param {Object} breedData - Breed data
   * @returns {Object} Created breed
   */
  async createBreed(breedData) {
    try {
      // Check if breed name already exists
      const existing = await Breed.findOne({ where: { name: breedData.name } });
      if (existing) {
        throw new Error('BREED_NAME_EXISTS');
      }

      const breed = await Breed.create(breedData);

      logger.info('Breed created', { breedId: breed.id });
      return breed;
    } catch (error) {
      logger.error('Create breed error', { error: error.message });
      throw error;
    }
  }

  /**
   * Update breed
   * @param {Number} breedId - Breed ID
   * @param {Object} updateData - Data to update
   * @returns {Object} Updated breed
   */
  async updateBreed(breedId, updateData) {
    try {
      const breed = await Breed.findByPk(breedId);

      if (!breed) {
        throw new Error('BREED_NOT_FOUND');
      }

      // Check if new name is unique (if being updated)
      if (updateData.name && updateData.name !== breed.name) {
        const existing = await Breed.findOne({ where: { name: updateData.name } });
        if (existing) {
          throw new Error('BREED_NAME_EXISTS');
        }
      }

      await breed.update(updateData);

      logger.info('Breed updated', { breedId });
      return breed;
    } catch (error) {
      logger.error('Update breed error', { error: error.message, breedId });
      throw error;
    }
  }

  /**
   * Delete breed
   * @param {Number} breedId - Breed ID
   */
  async deleteBreed(breedId) {
    try {
      const breed = await Breed.findByPk(breedId);

      if (!breed) {
        throw new Error('BREED_NOT_FOUND');
      }

      // Check if breed has rabbits
      const rabbitCount = await Rabbit.count({ where: { breed_id: breedId } });
      if (rabbitCount > 0) {
        throw new Error('BREED_HAS_RABBITS');
      }

      await breed.destroy();

      logger.info('Breed deleted', { breedId });
      return { success: true };
    } catch (error) {
      logger.error('Delete breed error', { error: error.message, breedId });
      throw error;
    }
  }
}

module.exports = new BreedService();
