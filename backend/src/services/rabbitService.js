const {
  Rabbit,
  Breed,
  Cage,
  RabbitWeight,
  Breeding,
  Birth,
  Vaccination,
  MedicalRecord,
  Transaction,
  Photo,
  User,
  sequelize
} = require('../models');
const { Op, Sequelize } = require('sequelize');
const logger = require('../utils/logger');
const { deleteFile } = require('../utils/fileStorage');

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
      // Порода принадлежит ферме, а не сервису: без фильтра по farm_id
      // сюда проходил идентификатор чужой породы, и в карточке кролика
      // показывалось её название — данные соседней фермы.
      const breed = await Breed.findOne({
        where: { id: rabbitData.breed_id, farm_id: rabbitData.farm_id },
        transaction
      });
      if (!breed) {
        throw new Error('BREED_NOT_FOUND');
      }

      // Check if cage exists and has capacity
      if (rabbitData.cage_id) {
          // Блокируем строку клетки на время проверки: подсчёт и вставка
          // идут двумя запросами, и без блокировки двое сотрудников с двух
          // телефонов одновременно видят одно свободное место и оба его
          // занимают — в клетке оказывается больше кроликов, чем вмещает.
        const cage = await Cage.findOne({
          where: { id: rabbitData.cage_id, farm_id: rabbitData.farm_id },
          lock: transaction.LOCK.UPDATE,
          transaction
        });
        if (!cage) {
          throw new Error('CAGE_NOT_FOUND');
        }

        // Check capacity (skip for maternity types usually, but let's be strict or use capacity field)
        const currentCount = await Rabbit.count({
          where: { cage_id: rabbitData.cage_id, farm_id: rabbitData.farm_id },
          transaction
        });
        if (currentCount >= cage.capacity) {
          throw new Error('CAGE_FULL');
        }

        // If dead or sold, shouldn't be in a cage
        if (['dead', 'sold'].includes(rabbitData.status)) {
          rabbitData.cage_id = null;
        }
      }

      // Check if father exists and is male and belongs to the farm
      if (rabbitData.father_id) {
        const father = await Rabbit.findOne({
          where: { id: rabbitData.father_id, farm_id: rabbitData.farm_id, sex: 'male' },
          transaction
        });
        if (!father) {
          throw new Error('FATHER_NOT_FOUND_OR_INVALID_SEX');
        }
      }

      // Check if mother exists and is female and belongs to the farm
      if (rabbitData.mother_id) {
        const mother = await Rabbit.findOne({
          where: { id: rabbitData.mother_id, farm_id: rabbitData.farm_id, sex: 'female' },
          transaction
        });
        if (!mother) {
          throw new Error('MOTHER_NOT_FOUND_OR_INVALID_SEX');
        }
      }

      // Клеймо уникально в пределах фермы: у соседа может быть такое же
      if (rabbitData.tag_id) {
        const existing = await Rabbit.findOne({
          where: { tag_id: rabbitData.tag_id, farm_id: rabbitData.farm_id }
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
          farm_id: rabbitData.farm_id,
          weight: rabbitData.current_weight,
          measured_at: new Date()
        }, { transaction });
      }

      await transaction.commit();

      // Fetch rabbit with associations
      const createdRabbit = await this.getRabbitById(rabbit.id, rabbitData.farm_id);

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
   * @param {Number} farmId - id хозяйства: чужая запись не найдётся
   * @returns {Object} Rabbit with associations
   */
  async getRabbitById(rabbitId, farmId) {
    try {
      const rabbit = await Rabbit.findOne({
        where: {
          id: rabbitId,
          farm_id: farmId
        },
        // Ветки карточки фильтруем так же, как корень: связи проверяются
        // при записи, но записи бывают старше проверок. `required: false`
        // оставляет кролика в ответе — чужая связь просто не раскрывается.
        include: [
          { model: Breed, as: 'breed', where: { farm_id: farmId }, required: false },
          { model: Cage, where: { farm_id: farmId }, required: false },
          { model: Rabbit, as: 'father', where: { farm_id: farmId }, required: false },
          { model: Rabbit, as: 'mother', where: { farm_id: farmId }, required: false }
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
   * @param {Number} farmId - id хозяйства
   * @param {Object} filters - Filter options
   * @param {Object} pagination - Pagination options
   * @returns {Object} Rabbits list with pagination info
   */
  async listRabbits(farmId, filters = {}, pagination = {}) {
    try {
      const { page = 1, limit = 20, sort_by = 'created_at', sort_order = 'desc' } = pagination;
      const offset = (page - 1) * limit;

      // Build where clause
      const where = {
        farm_id: farmId
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
        // Колонки называем полями модели, а не голым `col('name')`: в выборку
        // подмешана порода, у которой тоже есть `name`, и MySQL отказывался
        // выполнять запрос — поиск по списку кроликов падал целиком.
        // Сравнение и так регистронезависимое: колонки в utf8mb4_unicode_ci.
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
          { model: Breed, as: 'breed', where: { farm_id: farmId }, required: false },
          { model: Cage, where: { farm_id: farmId }, required: false }
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
   * @param {Number} farmId - id хозяйства: чужая запись не найдётся
   * @param {Object} updateData - Data to update
   * @returns {Object} Updated rabbit
   */
  async updateRabbit(rabbitId, farmId, updateData) {
    const transaction = await sequelize.transaction();
    try {
      const rabbit = await Rabbit.findOne({
        where: {
          id: rabbitId,
          farm_id: farmId
        }
      });

      if (!rabbit) {
        throw new Error('RABBIT_NOT_FOUND');
      }

      // Sex change protection: cannot change sex if has history
      if (updateData.sex && updateData.sex !== rabbit.sex) {
        const offspringCount = await Rabbit.count({
          where: { farm_id: farmId, [Op.or]: [{ mother_id: rabbitId }, { father_id: rabbitId }] },
          transaction
        });
        const breedingCount = await Breeding.count({
          where: { farm_id: farmId, [Op.or]: [{ male_id: rabbitId }, { female_id: rabbitId }] },
          transaction
        });

        if (offspringCount > 0 || breedingCount > 0) {
          await transaction.rollback();
          throw new Error('CANNOT_CHANGE_SEX_WITH_HISTORY');
        }
      }

      // Порода должна быть своей — иначе правкой кролика можно было
      // подтянуть в карточку породу чужой фермы.
      if (updateData.breed_id) {
        const breed = await Breed.findOne({
          where: { id: updateData.breed_id, farm_id: farmId },
          transaction
        });
        if (!breed) {
          throw new Error('BREED_NOT_FOUND');
        }
      }

      // Check if cage exists and has capacity (if being updated)
      if (updateData.cage_id && updateData.cage_id !== rabbit.cage_id) {
          // Блокируем строку клетки на время проверки: подсчёт и вставка
          // идут двумя запросами, и без блокировки двое сотрудников с двух
          // телефонов одновременно видят одно свободное место и оба его
          // занимают — в клетке оказывается больше кроликов, чем вмещает.
        const cage = await Cage.findOne({
          where: { id: updateData.cage_id, farm_id: farmId },
          lock: transaction.LOCK.UPDATE,
          transaction
        });
        if (!cage) throw new Error('CAGE_NOT_FOUND');

        const currentCount = await Rabbit.count({
          where: { cage_id: updateData.cage_id, farm_id: farmId },
          transaction
        });
        if (currentCount >= cage.capacity) {
          throw new Error('CAGE_FULL');
        }
      }

      // If status updated to dead/sold, remove cage
      if (['dead', 'sold'].includes(updateData.status || rabbit.status)) {
        if (updateData.cage_id) updateData.cage_id = null;
        else if (!updateData.cage_id && rabbit.cage_id) updateData.cage_id = null;
      }

      // Check if father exists and is male
      if (updateData.father_id) {
        if (updateData.father_id === rabbitId) throw new Error('CANNOT_BE_OWN_FATHER');
        const father = await Rabbit.findOne({
          where: { id: updateData.father_id, farm_id: farmId, sex: 'male' },
          transaction
        });
        if (!father) throw new Error('FATHER_NOT_FOUND_OR_INVALID_SEX');
      }

      // Check if mother exists and is female
      if (updateData.mother_id) {
        if (updateData.mother_id === rabbitId) throw new Error('CANNOT_BE_OWN_MOTHER');
        const mother = await Rabbit.findOne({
          where: { id: updateData.mother_id, farm_id: farmId, sex: 'female' },
          transaction
        });
        if (!mother) throw new Error('MOTHER_NOT_FOUND_OR_INVALID_SEX');
      }

      // Клеймо уникально в пределах фермы (если его меняют)
      if (updateData.tag_id && updateData.tag_id !== rabbit.tag_id) {
        const existing = await Rabbit.findOne({
          where: { tag_id: updateData.tag_id, farm_id: farmId }
        });
        if (existing) {
          throw new Error('TAG_ID_EXISTS');
        }
      }

      // Update rabbit
      // File Cleanup: if photo is changing, delete old file — после коммита
      // (см. ниже): MinIO — сетевой вызов, и держать ради него открытой
      // транзакцию с захваченными блокировками строк смысла нет.
      const oldPhotoUrl =
        updateData.photo_url && rabbit.photo_url && updateData.photo_url !== rabbit.photo_url
          ? rabbit.photo_url
          : null;

      // Прежний вес нужно запомнить до update: после него экземпляр уже
      // хранит новое значение, сравнение всегда давало «не изменился», и
      // правка веса в карточке не попадала в историю — на графике роста
      // оставались дыры.
      const previousWeight = rabbit.current_weight;

      await rabbit.update(updateData, { transaction });

      if (updateData.current_weight !== undefined &&
          updateData.current_weight !== null &&
          Number(updateData.current_weight) !== Number(previousWeight)) {
        await RabbitWeight.create({
          rabbit_id: rabbit.id,
          farm_id: farmId,
          weight: updateData.current_weight,
          measured_at: new Date()
        }, { transaction });
      }

      await transaction.commit();

      if (oldPhotoUrl) {
        await deleteFile(oldPhotoUrl);
      }

      // Fetch updated rabbit with associations
      const updatedRabbit = await this.getRabbitById(rabbit.id, farmId);

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
   * @param {Number} farmId - id хозяйства: чужая запись не найдётся
   */
  async deleteRabbit(rabbitId, farmId) {
    try {
      const rabbit = await Rabbit.findOne({
        where: { id: rabbitId, farm_id: farmId }
      });

      if (!rabbit) throw new Error('RABBIT_NOT_FOUND');

      // Связанные записи считаем внутри своей фермы. Кролик и его история
      // всё равно лежат в одном хозяйстве, но без условия по farm_id запрос
      // ушёл бы по всей таблице — и отказ в удалении мог прийти из-за
      // совпадения id в чужих данных.
      const offspring = await Rabbit.count({
        where: { farm_id: farmId, [Op.or]: [{ father_id: rabbitId }, { mother_id: rabbitId }] }
      });
      if (offspring > 0) throw new Error('RABBIT_HAS_OFFSPRING');

      const breedings = await Breeding.count({
        where: { farm_id: farmId, [Op.or]: [{ male_id: rabbitId }, { female_id: rabbitId }] }
      });
      if (breedings > 0) throw new Error('RABBIT_HAS_BREEDING_HISTORY');

      const births = await Birth.count({ where: { farm_id: farmId, mother_id: rabbitId } });
      if (births > 0) throw new Error('RABBIT_HAS_BIRTH_HISTORY');

      const medical = await MedicalRecord.count({ where: { farm_id: farmId, rabbit_id: rabbitId } });
      const vaccinations = await Vaccination.count({ where: { farm_id: farmId, rabbit_id: rabbitId } });
      if (medical > 0 || vaccinations > 0) throw new Error('RABBIT_HAS_HEALTH_HISTORY');

      const transactions = await Transaction.count({ where: { farm_id: farmId, rabbit_id: rabbitId } });
      if (transactions > 0) throw new Error('RABBIT_HAS_FINANCIAL_HISTORY');

      // File Cleanup
      if (rabbit.photo_url) {
        await deleteFile(rabbit.photo_url);
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
   * @param {Number} farmId - id хозяйства: чужая запись не найдётся
   * @returns {Array} Weight records
   */
  async getWeightHistory(rabbitId, farmId) {
    try {
      const rabbit = await Rabbit.findOne({
        where: {
          id: rabbitId,
          farm_id: farmId
        }
      });

      if (!rabbit) {
        throw new Error('RABBIT_NOT_FOUND');
      }

      const weights = await RabbitWeight.findAll({
        where: { farm_id: farmId, rabbit_id: rabbitId },
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
   * @param {Number} farmId - id хозяйства: чужая запись не найдётся
   * @param {Object} weightData - Weight data
   * @returns {Object} Weight record
   */
  async addWeightRecord(rabbitId, farmId, weightData) {
    const transaction = await sequelize.transaction();
    try {
      const rabbit = await Rabbit.findOne({
        where: { id: rabbitId, farm_id: farmId },
        transaction
      });

      if (!rabbit) {
        throw new Error('RABBIT_NOT_FOUND');
      }

      // farm_id ставим сами, а не из weightData: тело запроса приходит
      // снаружи, и ферма записи должна совпадать с фермой кролика.
      const weightRecord = await RabbitWeight.create({
        ...weightData,
        rabbit_id: rabbitId,
        farm_id: farmId
      }, { transaction });

      // Update current_weight on rabbit
      await rabbit.update({ current_weight: weightData.weight }, { transaction });

      await transaction.commit();
      logger.info('Weight record added', { rabbitId, weight: weightData.weight });
      return weightRecord;
    } catch (error) {
      await transaction.rollback();
      logger.error('Add weight record error', { error: error.message, rabbitId });
      throw error;
    }
  }

  /**
   * Галерея кролика — в отличие от `photo_url`, снимков может быть много.
   * @param {Number} rabbitId - Rabbit ID
   * @param {Number} farmId - id хозяйства: чужая запись не найдётся
   * @returns {Array} Photo records
   */
  async listGalleryPhotos(rabbitId, farmId) {
    const rabbit = await Rabbit.findOne({ where: { id: rabbitId, farm_id: farmId } });
    if (!rabbit) throw new Error('RABBIT_NOT_FOUND');

    return Photo.findAll({
      where: { farm_id: farmId, rabbit_id: rabbitId },
      include: [{ model: User, as: 'author', attributes: ['id', 'full_name', 'email'] }],
      order: [['created_at', 'DESC']]
    });
  }

  /**
   * Добавить снимок в галерею.
   * @param {Number} rabbitId - Rabbit ID
   * @param {Number} farmId - id хозяйства: чужая запись не найдётся
   * @param {Object} data - { url, caption, taken_at, uploaded_by }
   * @returns {Object} Photo record
   */
  async addGalleryPhoto(rabbitId, farmId, data) {
    const rabbit = await Rabbit.findOne({ where: { id: rabbitId, farm_id: farmId } });
    if (!rabbit) throw new Error('RABBIT_NOT_FOUND');

    const photo = await Photo.create({
      farm_id: farmId,
      rabbit_id: rabbitId,
      url: data.url,
      caption: data.caption || null,
      taken_at: data.taken_at || null,
      uploaded_by: data.uploaded_by
    });

    const created = await Photo.findOne({
      where: { id: photo.id, farm_id: farmId },
      include: [{ model: User, as: 'author', attributes: ['id', 'full_name', 'email'] }]
    });

    logger.info('Gallery photo added', { rabbitId, photoId: photo.id });
    return created;
  }

  /**
   * Удалить снимок из галереи — вместе с файлом на диске.
   * @param {Number} rabbitId - Rabbit ID
   * @param {Number} photoId - Photo ID
   * @param {Number} farmId - id хозяйства: чужая запись не найдётся
   */
  async deleteGalleryPhoto(rabbitId, photoId, farmId) {
    const photo = await Photo.findOne({
      where: { id: photoId, rabbit_id: rabbitId, farm_id: farmId }
    });
    if (!photo) throw new Error('PHOTO_NOT_FOUND');

    await photo.destroy();
    deleteFile(photo.url);
    logger.info('Gallery photo deleted', { rabbitId, photoId });
  }

  /**
   * Get rabbit statistics
   * @param {Number} farmId - id хозяйства
   * @returns {Object} Statistics
   */
  async getStatistics(farmId) {
    try {
      const where = { farm_id: farmId };

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
        include: [{
          model: Breed,
          as: 'breed',
          attributes: ['name'],
          where: { farm_id: farmId },
          required: false
        }],
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
   * @param {Number} farmId - id хозяйства: чужая запись не найдётся
   * @param {Number} generations - Number of generations (default: 3)
   * @returns {Object} Pedigree tree
   */
  async getPedigree(rabbitId, farmId, generations = 3) {
    try {
      const rabbit = await this.getRabbitById(rabbitId, farmId);
      const buildPedigree = async (currentRabbit, level, pathVisited = new Set()) => {
        if (!currentRabbit) return null;
        if (pathVisited.has(currentRabbit.id)) return null;

        const result = {
          id: currentRabbit.id,
          // Подпись для безымянного кролика собирает приложение: готовый
          // русский текст с сервера нельзя ни перевести, ни поменять без
          // выката бэкенда.
          name: currentRabbit.name || null,
          tag_id: currentRabbit.tag_id || null,
          sex: currentRabbit.sex || 'unknown',
          birth_date: currentRabbit.birth_date || null,
          breed: currentRabbit.breed?.name || null
        };

        // Последнее поколение отдаём в том же виде, что и остальные узлы,
        // но родителей у него уже не раскрываем.
        if (level >= generations) return result;

        pathVisited.add(currentRabbit.id);

        if (currentRabbit.father_id) {
          try {
            const father = await this.getRabbitById(currentRabbit.father_id, farmId);
            result.father = await buildPedigree(father, level + 1, pathVisited);
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
            const mother = await this.getRabbitById(currentRabbit.mother_id, farmId);
            result.mother = await buildPedigree(mother, level + 1, pathVisited);
          } catch (error) {
            // Родитель не найден - пропускаем
            logger.warn('Mother not found for pedigree', {
              rabbitId: currentRabbit.id,
              motherId: currentRabbit.mother_id
            });
          }
        }

        pathVisited.delete(currentRabbit.id);
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
