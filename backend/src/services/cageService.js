const { Cage, Rabbit } = require('../models');
const { Op } = require('sequelize');
const logger = require('../utils/logger');

const RABBIT_INCLUDE = {
  model: Rabbit,
  as: 'rabbits',
  required: false
};

function addOccupancy(cage) {
  const cageData = cage.toJSON ? cage.toJSON() : { ...cage };
  cageData.current_occupancy = cage.rabbits ? cage.rabbits.length : 0;
  cageData.is_full = cageData.current_occupancy >= cage.capacity;
  cageData.is_available = cageData.current_occupancy < cage.capacity && cage.condition === 'good';
  return cageData;
}

/**
 * Cage service
 * Business logic for cage management
 */
class CageService {
  async createCage(data) {
    try {
      const cage = await Cage.create(data);
      logger.info('Cage created', { cageId: cage.id });
      return cage;
    } catch (error) {
      logger.error('Create cage error', { error: error.message });
      throw error;
    }
  }

  async getCageById(id, userId) {
    const cage = await Cage.findOne({
      where: { id, user_id: userId },
      include: [{
        ...RABBIT_INCLUDE,
        attributes: ['id', 'name', 'tag_id', 'sex', 'status', 'breed_id', 'birth_date', 'purpose', 'created_at', 'updated_at'],
        where: { user_id: userId }
      }]
    });

    if (!cage) throw new Error('CAGE_NOT_FOUND');
    return addOccupancy(cage);
  }

  async listCages(userId, filters = {}, pagination = {}) {
    const {
      page = 1,
      limit = 50,
      sort_by = 'number',
      sort_order = 'ASC',
      type,
      condition,
      location,
      search,
      only_available
    } = { ...filters, ...pagination };

    const offset = (parseInt(page) - 1) * parseInt(limit);
    const where = { user_id: userId };

    if (type) where.type = type;
    if (condition) where.condition = condition;
    if (location) where.location = { [Op.like]: `%${location}%` };
    if (search) {
      where[Op.or] = [
        { number: { [Op.like]: `%${search}%` } },
        { location: { [Op.like]: `%${search}%` } },
        { notes: { [Op.like]: `%${search}%` } }
      ];
    }

    const cages = await Cage.findAndCountAll({
      where,
      include: [{ ...RABBIT_INCLUDE, where: { user_id: userId } }],
      limit: parseInt(limit),
      offset,
      order: [[sort_by, sort_order.toUpperCase()]],
      distinct: true
    });

    let items = cages.rows.map(addOccupancy);
    if (only_available === 'true') items = items.filter(c => c.is_available);
    const total = only_available === 'true' ? items.length : cages.count;

    return { items, total, page: parseInt(page), limit: parseInt(limit) };
  }

  async updateCage(id, userId, data) {
    const cage = await Cage.findOne({ where: { id, user_id: userId } });
    if (!cage) throw new Error('CAGE_NOT_FOUND');
    await cage.update(data);
    logger.info('Cage updated', { cageId: id });
    return cage;
  }

  async deleteCage(id, userId) {
    const cage = await Cage.findOne({
      where: { id, user_id: userId },
      include: [{ model: Rabbit, as: 'rabbits' }]
    });

    if (!cage) throw new Error('CAGE_NOT_FOUND');
    if (cage.rabbits && cage.rabbits.length > 0) throw new Error('CAGE_HAS_RABBITS');

    await cage.destroy();
    logger.info('Cage deleted', { cageId: id });
    return { success: true };
  }

  async getStatistics(userId) {
    const cages = await Cage.findAll({
      where: { user_id: userId },
      include: [{
        ...RABBIT_INCLUDE,
        attributes: ['id'],
        where: { user_id: userId }
      }]
    });

    const stats = {
      total_cages: cages.length,
      by_type: { single: 0, group: 0, maternity: 0 },
      by_condition: { good: 0, needs_repair: 0, broken: 0 },
      occupancy: {
        total_capacity: 0,
        current_occupancy: 0,
        available_spaces: 0,
        occupancy_rate: 0,
        full_cages: 0,
        empty_cages: 0
      }
    };

    cages.forEach(cage => {
      stats.by_type[cage.type]++;
      stats.by_condition[cage.condition]++;
      const current = cage.rabbits ? cage.rabbits.length : 0;
      stats.occupancy.total_capacity += cage.capacity;
      stats.occupancy.current_occupancy += current;
      if (current >= cage.capacity) stats.occupancy.full_cages++;
      if (current === 0) stats.occupancy.empty_cages++;
    });

    stats.occupancy.available_spaces = stats.occupancy.total_capacity - stats.occupancy.current_occupancy;
    stats.occupancy.occupancy_rate = stats.occupancy.total_capacity > 0
      ? Math.round((stats.occupancy.current_occupancy / stats.occupancy.total_capacity) * 100) : 0;

    return stats;
  }

  async markCleaned(id, userId) {
    const cage = await Cage.findOne({ where: { id, user_id: userId } });
    if (!cage) throw new Error('CAGE_NOT_FOUND');
    await cage.update({ last_cleaned_at: new Date() });
    logger.info('Cage marked cleaned', { cageId: id });
    return cage;
  }

  async getLayout(userId) {
    const cages = await Cage.findAll({
      where: { user_id: userId },
      include: [{ ...RABBIT_INCLUDE, where: { user_id: userId } }],
      order: [['location', 'ASC'], ['number', 'ASC']]
    });

    const layout = {};
    cages.forEach(cage => {
      const loc = cage.location || 'Без локации';
      if (!layout[loc]) layout[loc] = [];
      layout[loc].push(addOccupancy(cage));
    });

    return layout;
  }
}

module.exports = new CageService();
