const { Rabbit, Breed, Cage, RabbitWeight, Photo } = require('../models');
const { Op } = require('sequelize');
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
    try {
      // Check if breed exists
      const breed = await Breed.findByPk(rabbitData.breed_id);
      if (!breed) {
        throw new Error('BREED_NOT_FOUND');
      }

      // Check if cage exists (if provided)
      if (rabbitData.cage_id) {
        const cage = await Cage.findByPk(rabbitData.cage_id);
        if (!cage) {
          throw new Error('CAGE_NOT_FOUND');
        }
      }

      // Check if tag_id is unique (if provided)
      if (rabbitData.tag_id) {
        const existing = await Rabbit.findOne({ where: { tag_id: rabbitData.tag_id } });
        if (existing) {
          throw new Error('TAG_ID_EXISTS');
        }
      }

      // Create rabbit
      const rabbit = await Rabbit.create(rabbitData);

      // Add initial weight if provided
      if (rabbitData.current_weight) {
        await RabbitWeight.create({
          rabbit_id: rabbit.id,
          weight: rabbitData.current_weight,
          measured_at: new Date()
        });
      }

      // Fetch rabbit with associations
      const createdRabbit = await this.getRabbitById(rabbit.id);

      logger.info('Rabbit created', { rabbitId: rabbit.id });
      return createdRabbit;
    } catch (error) {
      logger.error('Create rabbit error', { error: error.message });
      throw error;
    }
  }

  /**
   * Get rabbit by ID
   * @param {Number} rabbitId - Rabbit ID
   * @returns {Object} Rabbit with associations
   */
  async getRabbitById(rabbitId) {
    try {
      const rabbit = await Rabbit.findByPk(rabbitId, {
        include: [
          { model: Breed, attributes: ['id', 'name', 'purpose'] },
          { model: Cage, attributes: ['id', 'number', 'type', 'location'] },
          { model: Rabbit, as: 'father', attributes: ['id', 'name', 'tag_id'] },
          { model: Rabbit, as: 'mother', attributes: ['id', 'name', 'tag_id'] }
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
   * @param {Object} filters - Filter options
   * @param {Object} pagination - Pagination options
   * @returns {Object} Rabbits list with pagination info
   */
  async listRabbits(filters = {}, pagination = {}) {
    try {
      const { page = 1, limit = 20, sort_by = 'created_at', sort_order = 'desc' } = pagination;
      const offset = (page - 1) * limit;

      // Build where clause
      const where = {};

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
          { model: Breed, attributes: ['id', 'name', 'purpose'] },
          { model: Cage, attributes: ['id', 'number', 'location'] }
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
   * @param {Object} updateData - Data to update
   * @returns {Object} Updated rabbit
   */
  async updateRabbit(rabbitId, updateData) {
    try {
      const rabbit = await Rabbit.findByPk(rabbitId);

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

      // Check if cage exists (if being updated)
      if (updateData.cage_id) {
        const cage = await Cage.findByPk(updateData.cage_id);
        if (!cage) {
          throw new Error('CAGE_NOT_FOUND');
        }
      }

      // Check if tag_id is unique (if being updated)
      if (updateData.tag_id && updateData.tag_id !== rabbit.tag_id) {
        const existing = await Rabbit.findOne({ where: { tag_id: updateData.tag_id } });
        if (existing) {
          throw new Error('TAG_ID_EXISTS');
        }
      }

      // Update rabbit
      await rabbit.update(updateData);

      // If weight is being updated, add weight record
      if (updateData.current_weight && updateData.current_weight !== rabbit.current_weight) {
        await RabbitWeight.create({
          rabbit_id: rabbit.id,
          weight: updateData.current_weight,
          measured_at: new Date()
        });
      }

      // Fetch updated rabbit with associations
      const updatedRabbit = await this.getRabbitById(rabbit.id);

      logger.info('Rabbit updated', { rabbitId });
      return updatedRabbit;
    } catch (error) {
      logger.error('Update rabbit error', { error: error.message, rabbitId });
      throw error;
    }
  }

  /**
   * Delete rabbit
   * @param {Number} rabbitId - Rabbit ID
   */
  async deleteRabbit(rabbitId) {
    try {
      const rabbit = await Rabbit.findByPk(rabbitId);

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
   * @returns {Array} Weight records
   */
  async getWeightHistory(rabbitId) {
    try {
      const rabbit = await Rabbit.findByPk(rabbitId);
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
   * @param {Object} weightData - Weight data
   * @returns {Object} Weight record
   */
  async addWeightRecord(rabbitId, weightData) {
    try {
      const rabbit = await Rabbit.findByPk(rabbitId);
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
   * @returns {Object} Statistics
   */
  async getStatistics() {
    try {
      const total = await Rabbit.count();
      const males = await Rabbit.count({ where: { sex: 'male', status: { [Op.ne]: 'dead' } } });
      const females = await Rabbit.count({ where: { sex: 'female', status: { [Op.ne]: 'dead' } } });
      const pregnant = await Rabbit.count({ where: { status: 'pregnant' } });
      const sick = await Rabbit.count({ where: { status: 'sick' } });
      const forSale = await Rabbit.count({ where: { purpose: 'sale', status: { [Op.notIn]: ['sold', 'dead'] } } });

      // Get breed distribution
      const breedDistribution = await Rabbit.findAll({
        attributes: [
          'breed_id',
          [require('sequelize').fn('COUNT', '*'), 'count']
        ],
        include: [{ model: Breed, attributes: ['name'] }],
        group: ['breed_id', 'Breed.id', 'Breed.name'],
        where: { status: { [Op.notIn]: ['sold', 'dead'] } },
        raw: false
      });

      return {
        total,
        alive: total - await Rabbit.count({ where: { status: 'dead' } }),
        males,
        females,
        pregnant,
        sick,
        forSale,
        breedDistribution
      };
    } catch (error) {
      logger.error('Get statistics error', { error: error.message });
      throw error;
    }
  }

  /**
   * Get rabbit pedigree (parents tree)
   * @param {Number} rabbitId - Rabbit ID
   * @param {Number} generations - Number of generations (default: 3)
   * @returns {Object} Pedigree tree
   */
  async getPedigree(rabbitId, generations = 3) {
    try {
      const rabbit = await this.getRabbitById(rabbitId);

      const buildPedigree = async (currentRabbit, level) => {
        if (!currentRabbit || level >= generations) {
          return currentRabbit;
        }

        const result = {
          id: currentRabbit.id,
          name: currentRabbit.name,
          tag_id: currentRabbit.tag_id,
          sex: currentRabbit.sex,
          birth_date: currentRabbit.birth_date,
          breed: currentRabbit.Breed?.name
        };

        if (currentRabbit.father_id) {
          const father = await this.getRabbitById(currentRabbit.father_id);
          result.father = await buildPedigree(father, level + 1);
        }

        if (currentRabbit.mother_id) {
          const mother = await this.getRabbitById(currentRabbit.mother_id);
          result.mother = await buildPedigree(mother, level + 1);
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
