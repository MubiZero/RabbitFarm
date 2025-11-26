const { Breeding, Rabbit } = require('../models');
const { Op } = require('sequelize');
const logger = require('../utils/logger');

/**
 * Breeding service
 * Business logic for breeding management
 */
class BreedingService {
    /**
     * Create new breeding record
     * @param {Object} data - Breeding data
     * @returns {Object} Created breeding record
     */
    async createBreeding(data) {
        try {
            // Check if male exists and is male
            const male = await Rabbit.findByPk(data.male_id);
            if (!male) {
                throw new Error('MALE_NOT_FOUND');
            }
            if (male.sex !== 'male') {
                throw new Error('INVALID_MALE_SEX');
            }

            // Check if female exists and is female
            const female = await Rabbit.findByPk(data.female_id);
            if (!female) {
                throw new Error('FEMALE_NOT_FOUND');
            }
            if (female.sex !== 'female') {
                throw new Error('INVALID_FEMALE_SEX');
            }

            // Calculate expected birth date (31 days after breeding)
            if (!data.expected_birth_date && data.breeding_date) {
                const breedingDate = new Date(data.breeding_date);
                breedingDate.setDate(breedingDate.getDate() + 31);
                data.expected_birth_date = breedingDate.toISOString().split('T')[0];
            }

            const breeding = await Breeding.create(data);

            // Fetch with associations
            const createdBreeding = await this.getBreedingById(breeding.id);

            logger.info('Breeding created', { breedingId: breeding.id });
            return createdBreeding;
        } catch (error) {
            logger.error('Create breeding error', { error: error.message });
            throw error;
        }
    }

    /**
     * Get breeding by ID
     * @param {Number} id - Breeding ID
     * @returns {Object} Breeding record with associations
     */
    async getBreedingById(id) {
        try {
            const breeding = await Breeding.findByPk(id, {
                include: [
                    { model: Rabbit, as: 'male', attributes: ['id', 'name', 'tag_id', 'breed_id'] },
                    { model: Rabbit, as: 'female', attributes: ['id', 'name', 'tag_id', 'breed_id'] }
                ]
            });

            if (!breeding) {
                throw new Error('BREEDING_NOT_FOUND');
            }

            return breeding;
        } catch (error) {
            logger.error('Get breeding error', { error: error.message, id });
            throw error;
        }
    }

    /**
     * List breedings with filters
     * @param {Object} filters - Filter options
     * @param {Object} pagination - Pagination options
     */
    async listBreedings(filters = {}, pagination = {}) {
        try {
            const { page = 1, limit = 20, sort_by = 'created_at', sort_order = 'desc' } = pagination;
            const offset = (page - 1) * limit;

            const where = {};

            if (filters.status) {
                where.status = filters.status;
            }

            if (filters.male_id) {
                where.male_id = filters.male_id;
            }

            if (filters.female_id) {
                where.female_id = filters.female_id;
            }

            if (filters.from_date || filters.to_date) {
                where.breeding_date = {};
                if (filters.from_date) {
                    where.breeding_date[Op.gte] = filters.from_date;
                }
                if (filters.to_date) {
                    where.breeding_date[Op.lte] = filters.to_date;
                }
            }

            const total = await Breeding.count({ where });

            const items = await Breeding.findAll({
                where,
                include: [
                    { model: Rabbit, as: 'male', attributes: ['id', 'name', 'tag_id'] },
                    { model: Rabbit, as: 'female', attributes: ['id', 'name', 'tag_id'] }
                ],
                order: [[sort_by, sort_order.toUpperCase()]],
                limit: parseInt(limit),
                offset: parseInt(offset)
            });

            return {
                items,
                pagination: {
                    page: parseInt(page),
                    limit: parseInt(limit),
                    total,
                    totalPages: Math.ceil(total / limit)
                }
            };
        } catch (error) {
            logger.error('List breedings error', { error: error.message });
            throw error;
        }
    }

    /**
     * Update breeding record
     * @param {Number} id - Breeding ID
     * @param {Object} data - Update data
     */
    async updateBreeding(id, data) {
        try {
            const breeding = await Breeding.findByPk(id);
            if (!breeding) {
                throw new Error('BREEDING_NOT_FOUND');
            }

            // If updating male/female, check existence
            if (data.male_id) {
                const male = await Rabbit.findByPk(data.male_id);
                if (!male || male.sex !== 'male') throw new Error('INVALID_MALE');
            }
            if (data.female_id) {
                const female = await Rabbit.findByPk(data.female_id);
                if (!female || female.sex !== 'female') throw new Error('INVALID_FEMALE');
            }

            await breeding.update(data);

            const updated = await this.getBreedingById(id);
            logger.info('Breeding updated', { breedingId: id });
            return updated;
        } catch (error) {
            logger.error('Update breeding error', { error: error.message, id });
            throw error;
        }
    }

    /**
     * Delete breeding record
     * @param {Number} id - Breeding ID
     */
    async deleteBreeding(id) {
        try {
            const breeding = await Breeding.findByPk(id);
            if (!breeding) {
                throw new Error('BREEDING_NOT_FOUND');
            }

            await breeding.destroy();
            logger.info('Breeding deleted', { breedingId: id });
            return { success: true };
        } catch (error) {
            logger.error('Delete breeding error', { error: error.message, id });
            throw error;
        }
    }

    /**
     * Get breeding statistics
     */
    async getStatistics() {
        try {
            const total = await Breeding.count();
            const planned = await Breeding.count({ where: { status: 'planned' } });
            const completed = await Breeding.count({ where: { status: 'completed' } });
            const failed = await Breeding.count({ where: { status: 'failed' } });

            // Success rate (completed / (completed + failed)) * 100
            const totalFinished = completed + failed;
            const successRate = totalFinished > 0 ? Math.round((completed / totalFinished) * 100) : 0;

            return {
                total,
                planned,
                completed,
                failed,
                success_rate: successRate
            };
        } catch (error) {
            logger.error('Get breeding stats error', { error: error.message });
            throw error;
        }
    }
}

module.exports = new BreedingService();
