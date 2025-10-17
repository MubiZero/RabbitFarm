const { Rabbit, Birth, Breeding } = require('../models');
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

    // Проверяем, что мать принадлежит пользователю
    const mother = await Rabbit.findOne({
      where: { id: mother_id, user_id: userId },
    });

    if (!mother) {
      return ApiResponse.notFound(res, 'Мать не найдена');
    }

    // Если указана случка, проверяем её
    if (breeding_id) {
      const breeding = await Breeding.findOne({
        where: { id: breeding_id },
        include: [
          {
            model: Rabbit,
            as: 'female',
            where: { user_id: userId },
          },
        ],
      });

      if (!breeding) {
        return ApiResponse.notFound(res, 'Случка не найдена');
      }
    }

    const birth = await Birth.create({
      breeding_id: breeding_id || null,
      mother_id,
      birth_date,
      kits_born_alive: kits_born_alive || 0,
      kits_born_dead: kits_born_dead || 0,
      complications,
      notes,
    });

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
    });

    if (!birth) {
      return ApiResponse.notFound(res, 'Окрол не найден');
    }

    // Создаём крольчат
    const kits = [];
    const prefix = name_prefix || 'Крольчонок';

    for (let i = 1; i <= count; i++) {
      const kit = await Rabbit.create({
        user_id: userId,
        tag_id: `${prefix}-${Date.now()}-${i}`,
        name: `${prefix}-${i}`,
        breed_id,
        sex: 'unknown',
        birth_date,
        mother_id,
        father_id: father_id || null,
        status: 'active',
        purpose: 'breeding',
      });
      kits.push(kit);
    }

    return ApiResponse.created(res, kits, 'Крольчата успешно созданы');
  } catch (error) {
    console.error('Error creating kits:', error);
    return ApiResponse.serverError(res, 'Не удалось создать крольчат');
  }
};
