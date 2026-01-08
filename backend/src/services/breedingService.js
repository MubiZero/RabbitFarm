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
            // Check if male exists and is male and belongs to user
            const male = await Rabbit.findOne({
                where: { id: data.male_id, user_id: data.user_id }
            });
            if (!male) {
                throw new Error('MALE_NOT_FOUND');
            }
            if (male.sex !== 'male') {
                throw new Error('INVALID_MALE_SEX');
            }

            // Check if female exists and is female and belongs to user
            const female = await Rabbit.findOne({
                where: { id: data.female_id, user_id: data.user_id }
            });
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
            const createdBreeding = await this.getBreedingById(breeding.id, data.user_id);

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
     * @param {Number} userId - User ID for ownership verification
     * @returns {Object} Breeding record with associations
     */
    async getBreedingById(id, userId) {
        try {
            const breeding = await Breeding.findOne({
                where: {
                    id,
                    user_id: userId
                },
                include: [
                    {
                        model: Rabbit,
                        as: 'male',
                        where: { user_id: userId },
                        required: false
                    },
                    {
                        model: Rabbit,
                        as: 'female',
                        where: { user_id: userId },
                        required: false
                    }
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
     * @param {Number} userId - User ID for filtering
     * @param {Object} filters - Filter options
     * @param {Object} pagination - Pagination options
     */
    async listBreedings(userId, filters = {}, pagination = {}) {
        try {
            const { page = 1, limit = 20, sort_by = 'created_at', sort_order = 'desc' } = pagination;
            const offset = (page - 1) * limit;

            const where = {
                user_id: userId  // Filter by user
            };

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
                    {
                        model: Rabbit,
                        as: 'male',
                        where: { user_id: userId },
                        required: false
                    },
                    {
                        model: Rabbit,
                        as: 'female',
                        where: { user_id: userId },
                        required: false
                    }
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
     * @param {Number} userId - User ID for ownership verification
     * @param {Object} data - Update data
     */
    async updateBreeding(id, userId, data) {
        try {
            const breeding = await Breeding.findOne({
                where: {
                    id,
                    user_id: userId
                }
            });

            if (!breeding) {
                throw new Error('BREEDING_NOT_FOUND');
            }

            // If updating male/female, check existence and ownership
            if (data.male_id) {
                const male = await Rabbit.findOne({
                    where: { id: data.male_id, user_id: userId, sex: 'male' }
                });
                if (!male) throw new Error('INVALID_MALE');
            }
            if (data.female_id) {
                const female = await Rabbit.findOne({
                    where: { id: data.female_id, user_id: userId, sex: 'female' }
                });
                if (!female) throw new Error('INVALID_FEMALE');
            }

            await breeding.update(data);

            const updated = await this.getBreedingById(id, userId);
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
     * @param {Number} userId - User ID for ownership verification
     */
    async deleteBreeding(id, userId) {
        try {
            const breeding = await Breeding.findOne({
                where: {
                    id,
                    user_id: userId
                }
            });

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
     * @param {Number} userId - User ID for filtering
     */
    async getStatistics(userId) {
        try {
            const where = { user_id: userId };

            const total = await Breeding.count({ where });
            const planned = await Breeding.count({ where: { ...where, status: 'planned' } });
            const completed = await Breeding.count({ where: { ...where, status: 'completed' } });
            const failed = await Breeding.count({ where: { ...where, status: 'failed' } });

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
