const { Breeding, Rabbit, Task } = require('../models');
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
        const transaction = await Breeding.sequelize.transaction();
        try {
            if (data.male_id === data.female_id) {
                throw new Error('CANNOT_BREED_SAME_RABBIT');
            }

            // Check if male exists and is male and belongs to user
            const male = await Rabbit.findOne({
                where: { id: data.male_id, user_id: data.user_id },
                transaction
            });
            if (!male) {
                throw new Error('MALE_NOT_FOUND');
            }
            if (male.sex !== 'male') {
                throw new Error('INVALID_MALE_SEX');
            }
            if (['dead', 'sold'].includes(male.status)) {
                throw new Error('MALE_NOT_AVAILABLE');
            }

            // Check if female exists and is female and belongs to user
            const female = await Rabbit.findOne({
                where: { id: data.female_id, user_id: data.user_id },
                transaction
            });
            if (!female) {
                throw new Error('FEMALE_NOT_FOUND');
            }
            if (female.sex !== 'female') {
                throw new Error('INVALID_FEMALE_SEX');
            }
            if (['dead', 'sold'].includes(female.status)) {
                throw new Error('FEMALE_NOT_AVAILABLE');
            }

            // Calculate expected birth date (31 days after breeding)
            if (!data.expected_birth_date && data.breeding_date) {
                const breedingDate = new Date(data.breeding_date);
                breedingDate.setDate(breedingDate.getDate() + 31);
                data.expected_birth_date = breedingDate.toISOString().split('T')[0];
            }

            const breeding = await Breeding.create(data, { transaction });

            // Automation: Create tasks for the breeding process
            if (data.breeding_date) {
                const breedingDate = new Date(data.breeding_date);

                // 1. Palpation Task (+14 days)
                const palpationDate = new Date(breedingDate);
                palpationDate.setDate(palpationDate.getDate() + 14);

                await Task.create({
                    created_by: data.user_id,
                    assigned_to: data.user_id,
                    title: `Пальпация: ${female.name}`,
                    description: `Проверить на беременность самку ${female.name} после случки с ${male.name}`,
                    type: 'checkup',
                    priority: 'medium',
                    due_date: palpationDate,
                    rabbit_id: female.id,
                    status: 'pending'
                }, { transaction });

                // 2. Nest Box Box Task (+28 days)
                const nestBoxDate = new Date(breedingDate);
                nestBoxDate.setDate(nestBoxDate.getDate() + 28);

                await Task.create({
                    created_by: data.user_id,
                    assigned_to: data.user_id,
                    title: `Поставить маточник: ${female.name}`,
                    description: `Подготовить клетку и поставить гнездовой ящик для ${female.name}`,
                    type: 'breeding',
                    priority: 'high',
                    due_date: nestBoxDate,
                    rabbit_id: female.id,
                    cage_id: female.cage_id,
                    status: 'pending'
                }, { transaction });

                // 3. Expected Birth Task (+31 days)
                const birthDate = new Date(breedingDate);
                birthDate.setDate(birthDate.getDate() + 31);

                await Task.create({
                    created_by: data.user_id,
                    assigned_to: data.user_id,
                    title: `Ожидаемый окрол: ${female.name}`,
                    description: `Ожидается окрол у самки ${female.name} (случка с ${male.name})`,
                    type: 'breeding',
                    priority: 'urgent',
                    due_date: birthDate,
                    rabbit_id: female.id,
                    status: 'pending'
                }, { transaction });
            }

            await transaction.commit();

            // Fetch with associations
            const createdBreeding = await this.getBreedingById(breeding.id, data.user_id);

            logger.info('Breeding created', { breedingId: breeding.id });
            return createdBreeding;
        } catch (error) {
            if (transaction) await transaction.rollback();
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
        const transaction = await Breeding.sequelize.transaction();
        try {
            const breeding = await Breeding.findOne({
                where: { id, user_id: userId },
                transaction
            });

            if (!breeding) {
                await transaction.rollback();
                throw new Error('BREEDING_NOT_FOUND');
            }

            // If updating male/female, check existence and ownership
            if (data.male_id) {
                const male = await Rabbit.findOne({
                    where: { id: data.male_id, user_id: userId, sex: 'male' },
                    transaction
                });
                if (!male) {
                    await transaction.rollback();
                    throw new Error('INVALID_MALE');
                }
            }
            if (data.female_id) {
                if (data.female_id === (data.male_id || breeding.male_id)) {
                    await transaction.rollback();
                    throw new Error('CANNOT_BREED_SAME_RABBIT');
                }
                const female = await Rabbit.findOne({
                    where: { id: data.female_id, user_id: userId, sex: 'female' },
                    transaction
                });
                if (!female) {
                    await transaction.rollback();
                    throw new Error('INVALID_FEMALE');
                }
                if (['dead', 'sold'].includes(female.status)) {
                    await transaction.rollback();
                    throw new Error('FEMALE_NOT_AVAILABLE');
                }
            }

            await breeding.update(data, { transaction });

            // Automation: Update female status to 'pregnant' if is_pregnant is true
            if (data.is_pregnant === true) {
                const female = await Rabbit.findByPk(data.female_id || breeding.female_id, { transaction });
                if (female) {
                    await female.update({ status: 'pregnant' }, { transaction });
                }
            } else if (data.is_pregnant === false || data.status === 'failed') {
                const female = await Rabbit.findByPk(breeding.female_id, { transaction });
                if (female && female.status === 'pregnant') {
                    await female.update({ status: 'active' }, { transaction });
                }
            }

            await transaction.commit();

            const updated = await this.getBreedingById(id, userId);
            logger.info('Breeding updated', { breedingId: id });
            return updated;
        } catch (error) {
            if (transaction) await transaction.rollback();
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
