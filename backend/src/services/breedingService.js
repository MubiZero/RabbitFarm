const { Breeding, Rabbit, Task, Birth, Cage } = require('../models');
const { GESTATION_DAYS, NEST_BOX_DAY } = require('../utils/breedingCycle');
const { closeAutoTasks } = require('./autoTaskService');
const { Op } = require('sequelize');
const { taskText } = require('../i18n/tasks');
const { DEFAULT_LANGUAGE } = require('../i18n/notifications');
const logger = require('../utils/logger');

/** Ассоциация Breeding.hasMany(Birth) объявлена без псевдонима. */
const BIRTHS_ALIAS = 'Births';

/**
 * Строка списка случек: прежние поля плюс связанный окрол.
 *
 * Отсадку молодняка отсчитывают от настоящего дня окрола, а не от ожидаемого,
 * — иначе срок уезжает на столько же, на сколько окрол случился раньше или
 * позже ожидания. Формально окролов у случки много, поэтому Sequelize отдаёт
 * их массивом `Births`; наружу уходит один окрол под понятным именем `birth`,
 * а прежние поля остаются на своих местах — старые сборки приложения читают
 * ответ как раньше и про `birth` просто не знают.
 */
const withLinkedBirth = (breeding) => {
    const row = breeding.toJSON ? breeding.toJSON() : { ...breeding };
    const births = Array.isArray(row[BIRTHS_ALIAS]) ? row[BIRTHS_ALIAS] : [];
    delete row[BIRTHS_ALIAS];

    // Окрол на случку бывает один. Если их всё же несколько, берём самый
    // ранний: именно от него считают отсадку.
    const [earliest] = [...births].sort(
        (a, b) => String(a.birth_date).localeCompare(String(b.birth_date))
    );

    row.birth = earliest || null;
    return row;
};

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

            // Check if male exists and is male and belongs to farm
            const male = await Rabbit.findOne({
                where: { id: data.male_id, farm_id: data.farm_id },
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

            // Check if female exists and is female and belongs to farm
            const female = await Rabbit.findOne({
                where: { id: data.female_id, farm_id: data.farm_id },
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
                breedingDate.setDate(breedingDate.getDate() + GESTATION_DAYS);
                data.expected_birth_date = breedingDate.toISOString().split('T')[0];
            }

            const breeding = await Breeding.create(data, { transaction });

            // Automation: Create tasks for the breeding process
            if (data.breeding_date) {
                const breedingDate = new Date(data.breeding_date);

                // 1. Palpation Task (+14 days)
                const palpationDate = new Date(breedingDate);
                palpationDate.setDate(palpationDate.getDate() + 14);

                // Задачи по случке заводит сервер, а не человек, поэтому
                // автора и исполнителя нет. Раньше в оба поля писали id
                // владельца — только потому, что «ферма» и была этим id;
                // теперь ферма записана в farm_id, и подставлять хозяина
                // автором чужой работы незачем: список фермы всё равно
                // видит задачу.
                const taskParams = { doe: female.name, buck: male.name };

                await Task.create({
                    farm_id: data.farm_id,
                    // Текст пишется дважды: ключ с подстановками — чтобы
                    // собрать заголовок на языке читателя, и готовая строка —
                    // как запасной вариант для сборок, которые ключей ещё не
                    // понимают (см. `i18n/tasks`).
                    title_key: 'palpation',
                    title_params: taskParams,
                    ...taskText('palpation', DEFAULT_LANGUAGE, taskParams),
                    type: 'checkup',
                    priority: 'medium',
                    due_date: palpationDate,
                    rabbit_id: female.id,
                    status: 'pending'
                }, { transaction });

                // 2. Nest Box Box Task (+28 days)
                const nestBoxDate = new Date(breedingDate);
                nestBoxDate.setDate(nestBoxDate.getDate() + NEST_BOX_DAY);

                await Task.create({
                    farm_id: data.farm_id,
                    title_key: 'nestBox',
                    title_params: taskParams,
                    ...taskText('nestBox', DEFAULT_LANGUAGE, taskParams),
                    type: 'breeding',
                    priority: 'high',
                    due_date: nestBoxDate,
                    rabbit_id: female.id,
                    cage_id: female.cage_id,
                    status: 'pending'
                }, { transaction });

                // 3. Expected Birth Task (+31 days)
                const birthDate = new Date(breedingDate);
                birthDate.setDate(birthDate.getDate() + GESTATION_DAYS);

                await Task.create({
                    farm_id: data.farm_id,
                    title_key: 'expectedKindling',
                    title_params: taskParams,
                    ...taskText('expectedKindling', DEFAULT_LANGUAGE, taskParams),
                    type: 'breeding',
                    priority: 'urgent',
                    due_date: birthDate,
                    rabbit_id: female.id,
                    status: 'pending'
                }, { transaction });
            }

            await transaction.commit();

            // Fetch with associations
            const createdBreeding = await this.getBreedingById(breeding.id, data.farm_id);

            logger.info('Breeding created', { breedingId: breeding.id });
            return createdBreeding;
        } catch (error) {
            // Откат ровно один и здесь. Раньше каждая ветка отказа
            // откатывала транзакцию сама, а потом её откатывал этот же
            // обработчик — Sequelize бросал «transaction has been finished»,
            // и эта ошибка подменяла осмысленную. Наружу вместо «некорректный
            // самец» уходила «внутренняя ошибка сервера».
            if (transaction && !transaction.finished) await transaction.rollback();
            logger.error('Create breeding error', { error: error.message });
            throw error;
        }
    }

    /**
     * Get breeding by ID
     * @param {Number} id - Breeding ID
     * @param {Number} farmId - Farm ID for ownership verification
     * @returns {Object} Breeding record with associations
     */
    async getBreedingById(id, farmId) {
        try {
            const breeding = await Breeding.findOne({
                where: {
                    id,
                    farm_id: farmId
                },
                include: [
                    {
                        model: Rabbit,
                        as: 'male',
                        where: { farm_id: farmId },
                        required: false
                    },
                    {
                        model: Rabbit,
                        as: 'female',
                        where: { farm_id: farmId },
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
     * @param {Number} farmId - Farm ID for filtering
     * @param {Object} filters - Filter options
     * @param {Object} pagination - Pagination options
     */
    async listBreedings(farmId, filters = {}, pagination = {}) {
        try {
            const { page = 1, limit = 20, sort_by = 'created_at', sort_order = 'desc' } = pagination;
            const offset = (page - 1) * limit;

            const where = {
                farm_id: farmId  // Filter by farm
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
                        where: { farm_id: farmId },
                        required: false
                    },
                    {
                        model: Rabbit,
                        as: 'female',
                        where: { farm_id: farmId },
                        required: false,
                        // Клетка самки — то, куда фермер идёт ставить
                        // маточник. В бумажном плане окролов эта колонка без
                        // номера клетки бесполезна, а больше взять его
                        // неоткуда: список случек про клетки не спрашивал.
                        include: [
                            {
                                model: Cage,
                                required: false,
                                attributes: ['id', 'number', 'type', 'location']
                            }
                        ]
                    },
                    {
                        // Списку нужен один вопрос к окролу — когда он был и
                        // отсадили ли уже молодняк, — поэтому тянем четыре
                        // поля, а не окрол целиком.
                        model: Birth,
                        as: BIRTHS_ALIAS,
                        required: false,
                        attributes: ['id', 'breeding_id', 'birth_date', 'weaning_date']
                    }
                ],
                order: [[sort_by, sort_order.toUpperCase()]],
                limit: parseInt(limit),
                offset: parseInt(offset)
            });

            return {
                items: items.map(withLinkedBirth),
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
     * @param {Number} farmId - Farm ID for ownership verification
     * @param {Object} data - Update data
     */
    async updateBreeding(id, farmId, data) {
        const transaction = await Breeding.sequelize.transaction();
        try {
            const breeding = await Breeding.findOne({
                where: { id, farm_id: farmId },
                transaction
            });

            if (!breeding) {
                throw new Error('BREEDING_NOT_FOUND');
            }

            // If updating male/female, check existence and ownership
            if (data.male_id) {
                const male = await Rabbit.findOne({
                    where: { id: data.male_id, farm_id: farmId, sex: 'male' },
                    transaction
                });
                if (!male) {
                    throw new Error('INVALID_MALE');
                }
            }
            if (data.female_id) {
                if (data.female_id === (data.male_id || breeding.male_id)) {
                    throw new Error('CANNOT_BREED_SAME_RABBIT');
                }
                const female = await Rabbit.findOne({
                    where: { id: data.female_id, farm_id: farmId, sex: 'female' },
                    transaction
                });
                if (!female) {
                    throw new Error('INVALID_FEMALE');
                }
                if (['dead', 'sold'].includes(female.status)) {
                    throw new Error('FEMALE_NOT_AVAILABLE');
                }
            }

            await breeding.update(data, { transaction });

            // Automation: Update female status to 'pregnant' if is_pregnant is true
            // Самку ищем в пределах фермы: findByPk брал её по всей базе, и
            // чужой кролик, подставленный в female_id, менял статус.
            if (data.is_pregnant === true) {
                const female = await Rabbit.findOne({
                    where: { id: data.female_id || breeding.female_id, farm_id: farmId },
                    transaction
                });
                if (female) {
                    await female.update({ status: 'pregnant' }, { transaction });
                }
            } else if (data.is_pregnant === false || data.status === 'failed') {
                const female = await Rabbit.findOne({
                    where: { id: breeding.female_id, farm_id: farmId },
                    transaction
                });
                if (female && female.status === 'pregnant') {
                    await female.update({ status: 'active' }, { transaction });
                }
            }

            await transaction.commit();

            // Прощупали — значит задача «прощупать» сделана, чем бы ни
            // кончилось. Без этого она оставалась просроченной навсегда и
            // каждое утро уходила пушем.
            //
            // Раньше это стояло в создании случки, где прощупывания не
            // бывает: валидатор создания таких полей не принимает вовсе,
            // и ветка не выполнялась ни разу. Отметить прощупывание можно
            // только здесь.
            if (data.is_pregnant !== undefined || data.palpation_date) {
              await closeAutoTasks({
                farmId,
                rabbitId: breeding.female_id,
                keys: ['palpation']
              });
            }

            const updated = await this.getBreedingById(id, farmId);
            logger.info('Breeding updated', { breedingId: id });
            return updated;
        } catch (error) {
            // Откат ровно один и здесь. Раньше каждая ветка отказа
            // откатывала транзакцию сама, а потом её откатывал этот же
            // обработчик — Sequelize бросал «transaction has been finished»,
            // и эта ошибка подменяла осмысленную. Наружу вместо «некорректный
            // самец» уходила «внутренняя ошибка сервера».
            if (transaction && !transaction.finished) await transaction.rollback();
            logger.error('Update breeding error', { error: error.message, id });
            throw error;
        }
    }

    /**
     * Delete breeding record
     * @param {Number} id - Breeding ID
     * @param {Number} farmId - Farm ID for ownership verification
     */
    async deleteBreeding(id, farmId) {
        try {
            const breeding = await Breeding.findOne({
                where: {
                    id,
                    farm_id: farmId
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
     * @param {Number} farmId - Farm ID for filtering
     */
    async getStatistics(farmId) {
        try {
            const where = { farm_id: farmId };

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
