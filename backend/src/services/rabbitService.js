const { Rabbit, Breed, Cage, RabbitWeight, Photo, sequelize } = require('../models');
const { Op, Sequelize } = require('sequelize');
const logger = require('../utils/logger');

/**
 * Rabbit service
 * Business logic for rabbit management
 */
class RabbitService {
  /**
   * Create new rabbit
   * @param {Object} rabbitData - Rabbit data
   * @returns {Object} Created rabbit
   */
  async createRabbit(rabbitData) {
    const transaction = await sequelize.transaction();
    try {
      // Check if breed exists (breeds are global in this app)
      const breed = await Breed.findByPk(rabbitData.breed_id);
      if (!breed) {
        throw new Error('BREED_NOT_FOUND');
      }

      // Check if cage exists and belongs to the user
      if (rabbitData.cage_id) {
        const cage = await Cage.findOne({
          where: { id: rabbitData.cage_id, user_id: rabbitData.user_id }
        });
        if (!cage) {
          throw new Error('CAGE_NOT_FOUND');
        }
      }

      // Check if father exists and belongs to the user
      if (rabbitData.father_id) {
        const father = await Rabbit.findOne({
          where: { id: rabbitData.father_id, user_id: rabbitData.user_id }
        });
        if (!father) {
          throw new Error('FATHER_NOT_FOUND');
        }
      }

      // Check if mother exists and belongs to the user
      if (rabbitData.mother_id) {
        const mother = await Rabbit.findOne({
          where: { id: rabbitData.mother_id, user_id: rabbitData.user_id }
        });
        if (!mother) {
          throw new Error('MOTHER_NOT_FOUND');
        }
      }

      // Check if tag_id is unique for THIS user
      if (rabbitData.tag_id) {
        const existing = await Rabbit.findOne({
          where: { tag_id: rabbitData.tag_id, user_id: rabbitData.user_id }
        });
        if (existing) {
          throw new Error('TAG_ID_EXISTS');
        }
      }

      // Create rabbit
      const rabbit = await Rabbit.create(rabbitData, { transaction });

      // Add initial weight if provided
      if (rabbitData.current_weight) {
        await RabbitWeight.create({
          rabbit_id: rabbit.id,
          weight: rabbitData.current_weight,
          measured_at: new Date()
        }, { transaction });
      }

      await transaction.commit();

      // Fetch rabbit with associations
      const createdRabbit = await this.getRabbitById(rabbit.id, rabbitData.user_id);

      logger.info('Rabbit created', { rabbitId: rabbit.id });
      return createdRabbit;
    } catch (error) {
      await transaction.rollback();
      logger.error('Create rabbit error', { error: error.message });
      throw error;
    }
  }

  /**
   * Get rabbit by ID
   * @param {Number} rabbitId - Rabbit ID
   * @param {Number} userId - User ID for ownership verification
   * @returns {Object} Rabbit with associations
   */
  async getRabbitById(rabbitId, userId) {
    try {
      const rabbit = await Rabbit.findOne({
        where: {
          id: rabbitId,
          user_id: userId
        },
        include: [
          { model: Breed, as: 'breed' },
          { model: Cage },
          { model: Rabbit, as: 'father' },
          { model: Rabbit, as: 'mother' }
        ]
      });

      if (!rabbit) {
        throw new Error('RABBIT_NOT_FOUND');
      }

      return rabbit;
    } catch (error) {
      logger.error('Get rabbit error', { error: error.message, rabbitId });
      throw error;
    }
  }

  /**
   * Get list of rabbits with filters and pagination
   * @param {Number} userId - User ID for filtering
   * @param {Object} filters - Filter options
   * @param {Object} pagination - Pagination options
   * @returns {Object} Rabbits list with pagination info
   */
  async listRabbits(userId, filters = {}, pagination = {}) {
    try {
      const { page = 1, limit = 20, sort_by = 'created_at', sort_order = 'desc' } = pagination;
      const offset = (page - 1) * limit;

      // Build where clause
      const where = {
        user_id: userId  // Filter by user
      };

      if (filters.breed_id) {
        where.breed_id = filters.breed_id;
      }

      if (filters.sex) {
        where.sex = filters.sex;
      }

      if (filters.status) {
        where.status = filters.status;
      }

      if (filters.purpose) {
        where.purpose = filters.purpose;
      }

      if (filters.cage_id) {
        where.cage_id = filters.cage_id;
      }

      if (filters.search) {
        where[Op.or] = [
          { name: { [Op.like]: `%${filters.search}%` } },
          { tag_id: { [Op.like]: `%${filters.search}%` } }
        ];
      }

      // Count total
      const total = await Rabbit.count({ where });

      // Fetch rabbits
      const rabbits = await Rabbit.findAll({
        where,
        include: [
          { model: Breed, as: 'breed' },
          { model: Cage }
        ],
        order: [[sort_by, sort_order.toUpperCase()]],
        limit: parseInt(limit),
        offset: parseInt(offset)
      });

      return {
        items: rabbits,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          totalPages: Math.ceil(total / limit)
        }
      };
    } catch (error) {
      logger.error('List rabbits error', { error: error.message });
      throw error;
    }
  }

  /**
   * Update rabbit
   * @param {Number} rabbitId - Rabbit ID
   * @param {Number} userId - User ID for ownership verification
   * @param {Object} updateData - Data to update
   * @returns {Object} Updated rabbit
   */
  async updateRabbit(rabbitId, userId, updateData) {
    const transaction = await sequelize.transaction();
    try {
      const rabbit = await Rabbit.findOne({
        where: {
          id: rabbitId,
          user_id: userId
        }
      });

      if (!rabbit) {
        throw new Error('RABBIT_NOT_FOUND');
      }

      // Check if breed exists (if being updated)
      if (updateData.breed_id) {
        const breed = await Breed.findByPk(updateData.breed_id);
        if (!breed) {
          throw new Error('BREED_NOT_FOUND');
        }
      }

      // Check if cage exists and belongs to the user (if being updated)
      if (updateData.cage_id) {
        const cage = await Cage.findOne({
          where: { id: updateData.cage_id, user_id: userId }
        });
        if (!cage) {
          throw new Error('CAGE_NOT_FOUND');
        }
      }

      // Check if father exists and belongs to the user
      if (updateData.father_id) {
        const father = await Rabbit.findOne({
          where: { id: updateData.father_id, user_id: userId }
        });
        if (!father) {
          throw new Error('FATHER_NOT_FOUND');
        }
      }

      // Check if mother exists and belongs to the user
      if (updateData.mother_id) {
        const mother = await Rabbit.findOne({
          where: { id: updateData.mother_id, user_id: userId }
        });
        if (!mother) {
          throw new Error('MOTHER_NOT_FOUND');
        }
      }

      // Check if tag_id is unique for THIS user (if being updated)
      if (updateData.tag_id && updateData.tag_id !== rabbit.tag_id) {
        const existing = await Rabbit.findOne({
          where: { tag_id: updateData.tag_id, user_id: userId }
        });
        if (existing) {
          throw new Error('TAG_ID_EXISTS');
        }
      }

      // Update rabbit
      await rabbit.update(updateData, { transaction });

      // If weight is being updated, add weight record
      if (updateData.current_weight && updateData.current_weight !== rabbit.current_weight) {
        await RabbitWeight.create({
          rabbit_id: rabbit.id,
          weight: updateData.current_weight,
          measured_at: new Date()
        }, { transaction });
      }

      await transaction.commit();

      // Fetch updated rabbit with associations
      const updatedRabbit = await this.getRabbitById(rabbit.id, userId);

      logger.info('Rabbit updated', { rabbitId });
      return updatedRabbit;
    } catch (error) {
      await transaction.rollback();
      logger.error('Update rabbit error', { error: error.message, rabbitId });
      throw error;
    }
  }

  /**
   * Delete rabbit
   * @param {Number} rabbitId - Rabbit ID
   * @param {Number} userId - User ID for ownership verification
   */
  async deleteRabbit(rabbitId, userId) {
    try {
      const rabbit = await Rabbit.findOne({
        where: {
          id: rabbitId,
          user_id: userId
        }
      });

      if (!rabbit) {
        throw new Error('RABBIT_NOT_FOUND');
      }

      // Check if rabbit has offspring
      const offspring = await Rabbit.count({
        where: {
          [Op.or]: [
            { father_id: rabbitId },
            { mother_id: rabbitId }
          ]
        }
      });

      if (offspring > 0) {
        throw new Error('RABBIT_HAS_OFFSPRING');
      }

      await rabbit.destroy();

      logger.info('Rabbit deleted', { rabbitId });
      return { success: true };
    } catch (error) {
      logger.error('Delete rabbit error', { error: error.message, rabbitId });
      throw error;
    }
  }

  /**
   * Get rabbit weight history
   * @param {Number} rabbitId - Rabbit ID
   * @param {Number} userId - User ID for ownership verification
   * @returns {Array} Weight records
   */
  async getWeightHistory(rabbitId, userId) {
    try {
      const rabbit = await Rabbit.findOne({
        where: {
          id: rabbitId,
          user_id: userId
        }
      });

      if (!rabbit) {
        throw new Error('RABBIT_NOT_FOUND');
      }

      const weights = await RabbitWeight.findAll({
        where: { rabbit_id: rabbitId },
        order: [['measured_at', 'DESC']]
      });

      return weights;
    } catch (error) {
      logger.error('Get weight history error', { error: error.message, rabbitId });
      throw error;
    }
  }

  /**
   * Add weight record
   * @param {Number} rabbitId - Rabbit ID
   * @param {Number} userId - User ID for ownership verification
   * @param {Object} weightData - Weight data
   * @returns {Object} Weight record
   */
  async addWeightRecord(rabbitId, userId, weightData) {
    try {
      const rabbit = await Rabbit.findOne({
        where: {
          id: rabbitId,
          user_id: userId
        }
      });

      if (!rabbit) {
        throw new Error('RABBIT_NOT_FOUND');
      }

      const weightRecord = await RabbitWeight.create({
        rabbit_id: rabbitId,
        ...weightData
      });

      // Update current_weight on rabbit
      await rabbit.update({ current_weight: weightData.weight });

      logger.info('Weight record added', { rabbitId, weight: weightData.weight });
      return weightRecord;
    } catch (error) {
      logger.error('Add weight record error', { error: error.message, rabbitId });
      throw error;
    }
  }

  /**
   * Get rabbit statistics
   * @param {Number} userId - User ID for filtering
   * @returns {Object} Statistics
   */
  async getStatistics(userId) {
    try {
      const where = { user_id: userId };

      const total = await Rabbit.count({ where });
      const deadCount = await Rabbit.count({ where: { ...where, status: 'dead' } });
      const aliveCount = total - deadCount;
      const maleCount = await Rabbit.count({ where: { ...where, sex: 'male', status: { [Op.ne]: 'dead' } } });
      const femaleCount = await Rabbit.count({ where: { ...where, sex: 'female', status: { [Op.ne]: 'dead' } } });
      const pregnantCount = await Rabbit.count({ where: { ...where, status: 'pregnant' } });
      const sickCount = await Rabbit.count({ where: { ...where, status: 'sick' } });
      const forSaleCount = await Rabbit.count({ where: { ...where, purpose: 'sale', status: { [Op.notIn]: ['sold', 'dead'] } } });

      // Get breed distribution
      const breedDistribution = await Rabbit.findAll({
        attributes: [
          'breed_id',
          [Sequelize.fn('COUNT', '*'), 'count']
        ],
        include: [{ model: Breed, as: 'breed', attributes: ['name'] }],
        group: ['breed_id', 'breed.id', 'breed.name'],
        where: { ...where, status: { [Op.notIn]: ['sold', 'dead'] } },
        raw: false
      });

      // Format breed distribution to match mobile model
      const byBreed = breedDistribution.map(item => ({
        breed_id: item.breed_id,
        breed_name: item.breed?.name || null,
        count: parseInt(item.get('count'))
      }));

      return {
        total,
        alive_count: aliveCount,
        male_count: maleCount,
        female_count: femaleCount,
        pregnant_count: pregnantCount,
        sick_count: sickCount,
        for_sale_count: forSaleCount,
        dead_count: deadCount,
        by_breed: byBreed
      };
    } catch (error) {
      logger.error('Get statistics error', { error: error.message });
      throw error;
    }
  }

  /**
   * Get rabbit pedigree (parents tree)
   * @param {Number} rabbitId - Rabbit ID
   * @param {Number} userId - User ID for ownership verification
   * @param {Number} generations - Number of generations (default: 3)
   * @returns {Object} Pedigree tree
   */
  async getPedigree(rabbitId, userId, generations = 3) {
    try {
      const rabbit = await this.getRabbitById(rabbitId, userId);

      const buildPedigree = async (currentRabbit, level) => {
        if (!currentRabbit || level >= generations) {
          return currentRabbit;
        }

        const result = {
          id: currentRabbit.id,
          name: currentRabbit.name || 'Без имени',
          tag_id: currentRabbit.tag_id || null,
          sex: currentRabbit.sex || 'unknown',
          birth_date: currentRabbit.birth_date || null,
          breed: currentRabbit.Breed?.name || null
        };

        if (currentRabbit.father_id) {
          try {
            const father = await this.getRabbitById(currentRabbit.father_id, userId);
            result.father = await buildPedigree(father, level + 1);
          } catch (error) {
            // Родитель не найден - пропускаем
            logger.warn('Father not found for pedigree', {
              rabbitId: currentRabbit.id,
              fatherId: currentRabbit.father_id
            });
          }
        }

        if (currentRabbit.mother_id) {
          try {
            const mother = await this.getRabbitById(currentRabbit.mother_id, userId);
            result.mother = await buildPedigree(mother, level + 1);
          } catch (error) {
            // Родитель не найден - пропускаем
            logger.warn('Mother not found for pedigree', {
              rabbitId: currentRabbit.id,
              motherId: currentRabbit.mother_id
            });
          }
        }

        return result;
      };

      return await buildPedigree(rabbit, 0);
    } catch (error) {
      logger.error('Get pedigree error', { error: error.message, rabbitId });
      throw error;
    }
  }
}

module.exports = new RabbitService();
