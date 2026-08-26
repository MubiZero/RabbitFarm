const { randomUUID } = require('crypto');
const { Op } = require('sequelize');
const { Rabbit, Birth, Breeding, Task, Breed, Cage } = require('../models');
const ApiResponse = require('../utils/apiResponse');
const logger = require('../utils/logger');

/**
 * Получить список всех окролов для текущего пользователя
 */
exports.getBirths = async (req, res, next) => {
  try {
    const farmId = req.farmId;
    const { page, limit, mother_id: motherId, from_date: fromDate, to_date: toDate } = req.query;

    // Раньше отдавались все окролы фермы разом, без страниц и фильтров: у
    // хозяйства с трёхлетней историей это многомегабайтный ответ на мобильной
    // связи. Свой параметр page при этом был описан в Swagger и не работал.
    const where = { farm_id: farmId };
    if (motherId) where.mother_id = motherId;
    if (fromDate || toDate) {
      where.birth_date = {};
      if (fromDate) where.birth_date[Op.gte] = fromDate;
      if (toDate) where.birth_date[Op.lte] = toDate;
    }

    const offset = (page - 1) * limit;

    const { count, rows } = await Birth.findAndCountAll({
      where,
      include: [
        {
          model: Rabbit,
          as: 'mother',
          attributes: ['id', 'name', 'tag_id'],
        },
        {
          model: Breeding,
          as: 'breeding',
          required: false,
          attributes: ['id', 'male_id', 'female_id', 'breeding_date'],
        },
      ],
      order: [['birth_date', 'DESC']],
      limit,
      offset,
      distinct: true
    });

    return ApiResponse.paginated(res, rows, page, limit, count, 'Список окролов получен успешно');
  } catch (error) {
    logger.error('Error fetching births', { error: error.message });
    // Дальше решает общий обработчик: он различает ошибки валидации
    // Sequelize и отвечает понятным 422, а не общей пятисоткой.
    return next(error);
  }
};

/**
 * Получить окрол по ID
 */
exports.getBirthById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const farmId = req.farmId;

    const birth = await Birth.findOne({
      where: { id, farm_id: farmId },
      include: [
        {
          model: Rabbit,
          as: 'mother',
          attributes: ['id', 'name', 'tag_id', 'breed_id'],
          include: [
            {
              model: Breed,
              as: 'breed',
              attributes: ['id', 'name'],
            },
          ],
        },
        {
          model: Breeding,
          as: 'breeding',
          required: false,
          attributes: ['id', 'male_id', 'female_id', 'breeding_date'],
        },
      ],
    });

    if (!birth) {
      return ApiResponse.notFound(res, 'Окрол не найден');
    }

    return ApiResponse.success(res, birth);
  } catch (error) {
    logger.error('Error fetching birth', { error: error.message });
    // Дальше решает общий обработчик: он различает ошибки валидации
    // Sequelize и отвечает понятным 422, а не общей пятисоткой.
    return next(error);
  }
};

/**
 * Создать новый окрол
 */
exports.createBirth = async (req, res, next) => {
  const transaction = await Rabbit.sequelize.transaction();
  try {
    const farmId = req.farmId;
    const {
      breeding_id,
      mother_id,
      birth_date,
      kits_born_alive,
      kits_born_dead,
      complications,
      notes,
    } = req.body;

    // Проверяем, что мать принадлежит пользователю и жива
    const mother = await Rabbit.findOne({
      where: { id: mother_id, farm_id: farmId },
      transaction
    });

    if (!mother) {
      await transaction.rollback();
      return ApiResponse.notFound(res, 'Мать не найдена');
    }

    if (mother.status === 'dead') {
      await transaction.rollback();
      return ApiResponse.error(res, 'Мертвый кролик не может принести потомство', 400);
    }

    // Если указана случка, проверяем её и обновляем статус
    let breeding = null;
    if (breeding_id) {
      breeding = await Breeding.findOne({
        where: { id: breeding_id, farm_id: farmId },
        transaction
      });

      if (!breeding) {
        await transaction.rollback();
        return ApiResponse.notFound(res, 'Случка не найдена');
      }

      await breeding.update({ status: 'completed' }, { transaction });
    }

    const birth = await Birth.create({
      farm_id: farmId,
      breeding_id: breeding_id || null,
      mother_id,
      birth_date,
      kits_born_alive: Math.max(0, kits_born_alive || 0),
      kits_born_dead: Math.max(0, kits_born_dead || 0),
      complications,
      notes,
    }, { transaction });

    // Обновляем статус матери (если была беременна)
    if (mother.status === 'pregnant' || mother.status === 'active' || mother.status === 'healthy') {
      await mother.update({ status: 'active' }, { transaction });
    }

    // Automation: Create tasks for the nursing period.
    // Ферма задачи — в farm_id; в «кто завёл» и «на ком» идёт человек:
    // раньше туда клали id владельца, а теперь req.farmId — это id хозяйства,
    // и в колонке пользователя он указывал бы на постороннего.
    const authorId = req.user.id;
    const birthDateObj = new Date(birth_date || new Date());

    // 1. Weight kits (+7 days)
    const weightDate = new Date(birthDateObj);
    weightDate.setDate(weightDate.getDate() + 7);
    await Task.create({
      farm_id: farmId,
      created_by: authorId,
      assigned_to: authorId,
      title: `Взвесить крольчат: ${mother.name}`,
      description: `Первое взвешивание крольчат от самки ${mother.name}`,
      type: 'checkup',
      priority: 'medium',
      due_date: weightDate,
      rabbit_id: mother.id,
      status: 'pending'
    }, { transaction });

    // 2. Open eyes check (+10 days)
    const eyesDate = new Date(birthDateObj);
    eyesDate.setDate(eyesDate.getDate() + 10);
    await Task.create({
      farm_id: farmId,
      created_by: authorId,
      assigned_to: authorId,
      title: `Проверить глаза: ${mother.name}`,
      description: `Проверить, открылись ли глаза у крольчат самки ${mother.name}`,
      type: 'checkup',
      priority: 'medium',
      due_date: eyesDate,
      rabbit_id: mother.id,
      status: 'pending'
    }, { transaction });

    // 3. Weaning (+45 days)
    const weaningDate = new Date(birthDateObj);
    weaningDate.setDate(weaningDate.getDate() + 45);
    await Task.create({
      farm_id: farmId,
      created_by: authorId,
      assigned_to: authorId,
      title: `Отсадка (отъем): ${mother.name}`,
      description: `Пора отсаживать крольчат от самки ${mother.name}`,
      type: 'breeding',
      priority: 'high',
      due_date: weaningDate,
      rabbit_id: mother.id,
      status: 'pending'
    }, { transaction });

    await transaction.commit();

    // Загружаем созданный окрол с отношениями
    const createdBirth = await Birth.findOne({
      where: { id: birth.id, farm_id: farmId },
      include: [
        {
          model: Rabbit,
          as: 'mother',
          attributes: ['id', 'name', 'tag_id'],
        },
        {
          model: Breeding,
          as: 'breeding',
          required: false,
          attributes: ['id', 'male_id', 'female_id', 'breeding_date'],
        },
      ],
    });

    return ApiResponse.created(res, createdBirth, 'Окрол успешно создан');
  } catch (error) {
    await transaction.rollback();
    logger.error('Error creating birth', { error: error.message });
    // Дальше решает общий обработчик: он различает ошибки валидации
    // Sequelize и отвечает понятным 422, а не общей пятисоткой.
    return next(error);
  }
};

/**
 * Обновить окрол
 */
exports.updateBirth = async (req, res, next) => {
  try {
    const { id } = req.params;
    const farmId = req.farmId;
    const {
      birth_date,
      kits_born_alive,
      kits_born_dead,
      kits_weaned,
      weaning_date,
      complications,
      notes,
    } = req.body;

    const birth = await Birth.findOne({ where: { id, farm_id: farmId } });

    if (!birth) {
      return ApiResponse.notFound(res, 'Окрол не найден');
    }

    await birth.update({
      birth_date,
      kits_born_alive,
      kits_born_dead,
      kits_weaned,
      weaning_date,
      complications,
      notes,
    });

    // Связи подтягиваем отдельной выборкой, а не `reload`: тот жёстко
    // подставляет условие по одному первичному ключу, и хозяйство в него не
    // добавить. Правило одно на все выборки — без фермы запрос не идёт, и
    // исключений «этот запрос заведомо безопасен» мы не делаем: ровно из
    // такого рассуждения дыры и появлялись.
    const updated = await Birth.findOne({
      where: { id: birth.id, farm_id: farmId },
      include: [
        {
          model: Rabbit,
          as: 'mother',
          attributes: ['id', 'name', 'tag_id'],
        },
        {
          model: Breeding,
          as: 'breeding',
          required: false,
          attributes: ['id', 'male_id', 'female_id', 'breeding_date'],
        },
      ],
    });

    return ApiResponse.success(res, updated, 'Окрол успешно обновлен');
  } catch (error) {
    logger.error('Error updating birth', { error: error.message });
    // Дальше решает общий обработчик: он различает ошибки валидации
    // Sequelize и отвечает понятным 422, а не общей пятисоткой.
    return next(error);
  }
};

/**
 * Удалить окрол
 */
exports.deleteBirth = async (req, res, next) => {
  try {
    const { id } = req.params;
    const farmId = req.farmId;

    const birth = await Birth.findOne({ where: { id, farm_id: farmId } });

    if (!birth) {
      return ApiResponse.notFound(res, 'Окрол не найден');
    }

    await birth.destroy();

    return ApiResponse.success(res, null, 'Окрол успешно удален');
  } catch (error) {
    logger.error('Error deleting birth', { error: error.message });
    // Дальше решает общий обработчик: он различает ошибки валидации
    // Sequelize и отвечает понятным 422, а не общей пятисоткой.
    return next(error);
  }
};

/**
 * Создать карточки крольчат из окрола
 */
exports.createKitsFromBirth = async (req, res, next) => {
  const { id } = req.params;
  const farmId = req.farmId;
  const {
    mother_id,
    father_id,
    breed_id,
    birth_date,
    count,
    name_prefix,
  } = req.body;

  // Проверка количества стоит до открытия транзакции: раньше ранний return
  // оставлял её висеть и удерживал соединение из пула до таймаута.
  const kitCount = parseInt(count);
  if (isNaN(kitCount) || kitCount <= 0 || kitCount > 20) {
    return ApiResponse.error(res, 'Некорректное количество крольчат (макс 20)', 400);
  }

  const transaction = await Birth.sequelize.transaction();
  try {
    const birth = await Birth.findOne({
      where: { id, farm_id: farmId },
      transaction
    });

    if (!birth) {
      await transaction.rollback();
      return ApiResponse.notFound(res, 'Окрол не найден');
    }

    // Идентификаторы приходят из тела запроса, поэтому каждый проверяется на
    // принадлежность ферме: иначе крольчата уезжали в чужую клетку, а ответ
    // об оставшихся местах раскрывал заполненность чужого хозяйства.
    const mother = await Rabbit.findOne({
      where: { id: mother_id || birth.mother_id, farm_id: farmId },
      transaction
    });

    if (!mother) {
      await transaction.rollback();
      return ApiResponse.notFound(res, 'Мать не найдена');
    }

    let father = null;
    if (father_id) {
      father = await Rabbit.findOne({
        where: { id: father_id, farm_id: farmId },
        transaction
      });

      if (!father) {
        await transaction.rollback();
        return ApiResponse.notFound(res, 'Отец не найден');
      }

      if (father.sex !== 'male') {
        await transaction.rollback();
        return ApiResponse.error(res, 'Отцом может быть только самец', 400);
      }
    }

    // Порода по умолчанию наследуется от матери — так карточка крольчонка не
    // остаётся без обязательного поля.
    const kitBreedId = breed_id || mother.breed_id;
    if (breed_id) {
      const breed = await Breed.findOne({
        where: { id: breed_id, farm_id: farmId },
        transaction
      });

      if (!breed) {
        await transaction.rollback();
        return ApiResponse.notFound(res, 'Порода не найдена');
      }
    }

    const cageId = mother.cage_id;

    if (cageId) {
      // Клетка блокируется на время проверки: иначе два одновременных
      // создания помёта видят одни и те же свободные места и оба их занимают.
      const cage = await Cage.findOne({
        where: { id: cageId, farm_id: farmId },
        lock: transaction.LOCK.UPDATE,
        transaction
      });
      if (cage) {
        const currentCount = await Rabbit.count({
          where: { cage_id: cageId, farm_id: farmId },
          transaction
        });

        if (currentCount + kitCount > cage.capacity) {
          await transaction.rollback();
          return ApiResponse.error(res, `Недостаточно места в клетке матери (свободно: ${cage.capacity - currentCount})`, 400);
        }
      }
    }

    const kits = [];
    const prefix = name_prefix || 'Крольчонок';

    for (let i = 1; i <= kitCount; i++) {
      const kit = await Rabbit.create({
        farm_id: farmId,
        tag_id: `kit-${randomUUID().slice(0, 8)}`,
        name: `${prefix}-${i}`,
        breed_id: kitBreedId,
        sex: 'unknown',
        birth_date: birth_date || birth.birth_date,
        mother_id: mother.id,
        father_id: father ? father.id : null,
        status: 'active',
        cage_id: cageId,
        purpose: 'meat',
      }, { transaction });
      kits.push(kit);
    }

    await transaction.commit();
    return ApiResponse.created(res, kits, 'Крольчата успешно созданы');
  } catch (error) {
    if (!transaction.finished) await transaction.rollback();
    logger.error('Error creating kits', { error: error.message });
    // Дальше решает общий обработчик: он различает ошибки валидации
    // Sequelize и отвечает понятным 422, а не общей пятисоткой.
    return next(error);
  }
};
