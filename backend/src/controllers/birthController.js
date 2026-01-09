const { Rabbit, Birth, Breeding, Task } = require('../models');
const ApiResponse = require('../utils/apiResponse');

/**
 * Получить список всех окролов для текущего пользователя
 */
exports.getBirths = async (req, res) => {
  try {
    const userId = req.user.id;

    const births = await Birth.findAll({
      include: [
        {
          model: Rabbit,
          as: 'mother',
          where: { user_id: userId },
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
    });

    return ApiResponse.success(res, births, 'Список окролов получен успешно');
  } catch (error) {
    console.error('Error fetching births:', error);
    return ApiResponse.serverError(res, 'Не удалось загрузить окролы');
  }
};

/**
 * Получить окрол по ID
 */
exports.getBirthById = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    const birth = await Birth.findOne({
      where: { id },
      include: [
        {
          model: Rabbit,
          as: 'mother',
          where: { user_id: userId },
          attributes: ['id', 'name', 'tag_id', 'breed_id'],
          include: [
            {
              model: Rabbit.associations.Breed.target,
              as: 'Breed',
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
    console.error('Error fetching birth:', error);
    return ApiResponse.serverError(res, 'Не удалось загрузить окрол');
  }
};

/**
 * Создать новый окрол
 */
exports.createBirth = async (req, res) => {
  const transaction = await Rabbit.sequelize.transaction();
  try {
    const userId = req.user.id;
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
      where: { id: mother_id, user_id: userId },
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
        where: { id: breeding_id, user_id: userId },
        transaction
      });

      if (!breeding) {
        await transaction.rollback();
        return ApiResponse.notFound(res, 'Случка не найдена');
      }

      await breeding.update({ status: 'completed' }, { transaction });
    }

    const birth = await Birth.create({
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

    // Automation: Create tasks for the nursing period
    const birthDateObj = new Date(birth_date || new Date());

    // 1. Weight kits (+7 days)
    const weightDate = new Date(birthDateObj);
    weightDate.setDate(weightDate.getDate() + 7);
    await Task.create({
      created_by: userId,
      assigned_to: userId,
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
      created_by: userId,
      assigned_to: userId,
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
      created_by: userId,
      assigned_to: userId,
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
    const createdBirth = await Birth.findByPk(birth.id, {
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
    console.error('Error creating birth:', error);
    return ApiResponse.serverError(res, 'Не удалось создать окрол');
  }
};

/**
 * Обновить окрол
 */
exports.updateBirth = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    const {
      birth_date,
      kits_born_alive,
      kits_born_dead,
      kits_weaned,
      weaning_date,
      complications,
      notes,
    } = req.body;

    const birth = await Birth.findOne({
      where: { id },
      include: [
        {
          model: Rabbit,
          as: 'mother',
          where: { user_id: userId },
        },
      ],
    });

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

    // Перезагружаем с отношениями
    await birth.reload({
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

    return ApiResponse.success(res, birth, 'Окрол успешно обновлен');
  } catch (error) {
    console.error('Error updating birth:', error);
    return ApiResponse.serverError(res, 'Не удалось обновить окрол');
  }
};

/**
 * Удалить окрол
 */
exports.deleteBirth = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    const birth = await Birth.findOne({
      where: { id },
      include: [
        {
          model: Rabbit,
          as: 'mother',
          where: { user_id: userId },
        },
      ],
    });

    if (!birth) {
      return ApiResponse.notFound(res, 'Окрол не найден');
    }

    await birth.destroy();

    return ApiResponse.success(res, null, 'Окрол успешно удален');
  } catch (error) {
    console.error('Error deleting birth:', error);
    return ApiResponse.serverError(res, 'Не удалось удалить окрол');
  }
};

/**
 * Создать карточки крольчат из окрола
 */
exports.createKitsFromBirth = async (req, res) => {
  const transaction = await Birth.sequelize.transaction();
  try {
    const { id } = req.params;
    const userId = req.user.id;
    const {
      mother_id,
      father_id,
      breed_id,
      birth_date,
      count,
      name_prefix,
    } = req.body;

    // Validate count
    const kitCount = parseInt(count);
    if (isNaN(kitCount) || kitCount <= 0 || kitCount > 20) {
      return ApiResponse.error(res, 'Некорректное количество крольчат (макс 20)', 400);
    }

    // Проверяем окрол
    const birth = await Birth.findOne({
      where: { id },
      include: [
        {
          model: Rabbit,
          as: 'mother',
          where: { user_id: userId },
        },
      ],
      transaction
    });

    if (!birth) {
      await transaction.rollback();
      return ApiResponse.notFound(res, 'Окрол не найден');
    }

    // Получаем клетку матери для размещения крольчат
    const mother = await Rabbit.findByPk(mother_id || birth.mother_id, { transaction });
    const cageId = mother ? mother.cage_id : null;

    if (cageId) {
      const cage = await mother.getCage({ transaction });
      if (cage) {
        const currentCount = await Rabbit.count({ where: { cage_id: cageId }, transaction });
        if (currentCount + kitCount > cage.capacity) {
          await transaction.rollback();
          return ApiResponse.error(res, `Недостаточно места в клетке матери (свободно: ${cage.capacity - currentCount})`, 400);
        }
      }
    }

    // Создаём крольчат
    const kits = [];
    const prefix = name_prefix || 'Крольчонок';

    for (let i = 1; i <= kitCount; i++) {
      // Find next available tag_id by checking existence
      // For simplicity, we use timestamp + index, but let's make it cleaner
      const kit = await Rabbit.create({
        user_id: userId,
        tag_id: `${prefix}-${Date.now()}-${i}`,
        name: `${prefix}-${i}`,
        breed_id,
        sex: 'unknown',
        birth_date: birth_date || birth.birth_date,
        mother_id: mother_id || birth.mother_id,
        father_id: father_id || null,
        status: 'active',
        cage_id: cageId,
        purpose: 'meat', // По умолчанию молодняк на откорм? Или breeding?
      }, { transaction });
      kits.push(kit);
    }

    // Update birth record if needed
    await birth.update({ kits_weaned: (birth.kits_weaned || 0) + kitCount }, { transaction });

    await transaction.commit();
    return ApiResponse.created(res, kits, 'Крольчата успешно созданы');
  } catch (error) {
    await transaction.rollback();
    console.error('Error creating kits:', error);
    return ApiResponse.serverError(res, 'Не удалось создать крольчат');
  }
};
