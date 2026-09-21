const { randomUUID } = require('crypto');
const { Op } = require('sequelize');
const { Rabbit, Birth, Breeding, Task, Breed, Cage, Farm } = require('../models');
const ApiResponse = require('../utils/apiResponse');
const logger = require('../utils/logger');
const { taskText } = require('../i18n/tasks');
const { DEFAULT_LANGUAGE } = require('../i18n/notifications');
const { closeAutoTasks } = require('../services/autoTaskService');
const planService = require('../services/planService');

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
      return ApiResponse.notFound(res, 'Окрол не найден', 'BIRTH_NOT_FOUND');
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
      kits_died,
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
      return ApiResponse.notFound(res, 'Мать не найдена', 'MOTHER_NOT_FOUND');
    }

    if (mother.status === 'dead') {
      await transaction.rollback();
      return ApiResponse.error(res, 'Мертвый кролик не может принести потомство', 400, 'RABBIT_NOT_ACTIVE');
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
        return ApiResponse.notFound(res, 'Случка не найдена', 'BREEDING_NOT_FOUND');
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
      kits_died: Math.max(0, kits_died || 0),
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
    // Ключ с подстановками — чтобы собрать заголовок на языке читателя;
    // готовая строка рядом — запасной вариант для сборок, которые ключей ещё
    // не понимают (см. `i18n/tasks`).
    const taskParams = { doe: mother.name };

    await Task.create({
      farm_id: farmId,
      created_by: authorId,
      assigned_to: authorId,
      title_key: 'weighKits',
      title_params: taskParams,
      ...taskText('weighKits', DEFAULT_LANGUAGE, taskParams),
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
      title_key: 'eyesOpen',
      title_params: taskParams,
      ...taskText('eyesOpen', DEFAULT_LANGUAGE, taskParams),
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
      title_key: 'weaning',
      title_params: taskParams,
      ...taskText('weaning', DEFAULT_LANGUAGE, taskParams),
      type: 'breeding',
      priority: 'high',
      due_date: weaningDate,
      rabbit_id: mother.id,
      status: 'pending'
    }, { transaction });

    await transaction.commit();

    // Окрол случился — три задачи вокруг него потеряли смысл разом:
    // прощупать (ответ уже очевиден), поставить маточник и ждать окрола.
    await closeAutoTasks({
      farmId,
      rabbitId: mother_id,
      keys: ['palpation', 'nestBox', 'expectedKindling']
    });

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
      mother_id,
      breeding_id,
      birth_date,
      kits_born_alive,
      kits_born_dead,
      kits_died,
      kits_weaned,
      weaning_date,
      complications,
      notes,
    } = req.body;

    const birth = await Birth.findOne({ where: { id, farm_id: farmId } });

    if (!birth) {
      return ApiResponse.notFound(res, 'Окрол не найден', 'BIRTH_NOT_FOUND');
    }

    // Когда карточки заведены, крольчата считаются по ним — и падёж с
    // отсадкой отмечают на карточке. Правка чисел выводка в этот момент
    // создаёт вторую правду: в выводке «пало двое», в поголовье те же двое
    // живы, и какая из половин права, не знает никто.
    const countsTouched = [kits_born_alive, kits_born_dead, kits_died, kits_weaned]
      .some((value) => value !== undefined);
    if (birth.kits_carded_at && countsTouched) {
      return ApiResponse.error(
        res,
        'По этому окролу заведены карточки — отмечайте падёж и отсадку на карточке крольчонка',
        409, 'BIRTH_HAS_KIT_CARDS'
      );
    }

    // Смена матери раньше пропадала молча: форма шлёт mother_id всегда, но
    // контроллер его не читал, а приложение показывало «сохранено».
    // Разрешаем менять, пока карточки не заведены, — иначе крольчата
    // остались бы записаны на прежнюю мать, и родословная разъехалась бы.
    const motherChanged = mother_id !== undefined && mother_id !== birth.mother_id;
    if (motherChanged) {
      if (birth.kits_carded_at) {
        return ApiResponse.error(
          res,
          'По этому окролу заведены карточки — мать уже не поменять',
          409, 'BIRTH_HAS_KIT_CARDS'
        );
      }

      const mother = await Rabbit.findOne({
        where: { id: mother_id, farm_id: farmId, sex: 'female' }
      });
      if (!mother) {
        return ApiResponse.notFound(res, 'Мать не найдена', 'MOTHER_NOT_FOUND');
      }
    }

    // Дата отсадки не может быть раньше самого окрола. Проверить это в схеме
    // нельзя: при частичной правке дата окрола может не прийти вовсе, и
    // сравнивать надо с уже сохранённой.
    const effectiveBirthDate = birth_date || birth.birth_date;
    if (weaning_date && effectiveBirthDate &&
        new Date(weaning_date) < new Date(effectiveBirthDate)) {
      return ApiResponse.error(
        res,
        'Дата отсадки не может быть раньше окрола',
        400, 'WEANING_BEFORE_BIRTH'
      );
    }

    await birth.update({
      mother_id,
      breeding_id,
      birth_date,
      kits_born_alive,
      kits_born_dead,
      kits_died,
      kits_weaned,
      weaning_date,
      complications,
      notes,
    });

    // Отсадили — задача «отсадка» сделана.
    if (kits_weaned !== undefined || weaning_date) {
      await closeAutoTasks({
        farmId,
        rabbitId: birth.mother_id,
        keys: ['weaning']
      });
    }

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
      return ApiResponse.notFound(res, 'Окрол не найден', 'BIRTH_NOT_FOUND');
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
  //
  // Потолок поднят с 20 до 30 под тот же предел, что у «родилось живыми»
  // (kitsCount в birthValidator): окрол на 21–30 живых крольчат в карточки
  // не заводился вовсе, хотя записать такой окрол приложение позволяло.
  const kitCount = parseInt(count);
  if (isNaN(kitCount) || kitCount <= 0 || kitCount > 30) {
    return ApiResponse.error(res, 'Некорректное количество крольчат (макс 30)', 400, 'KITS_COUNT_INVALID');
  }

  const transaction = await Birth.sequelize.transaction();
  try {
    const birth = await Birth.findOne({
      where: { id, farm_id: farmId },
      transaction
    });

    if (!birth) {
      await transaction.rollback();
      return ApiResponse.notFound(res, 'Окрол не найден', 'BIRTH_NOT_FOUND');
    }

    // Второй раз карточки по тому же выводку не заводятся. Ничто не мешало
    // нажать кнопку дважды: оба вызова отвечали 201, шесть крольчат
    // становились двенадцатью карточками, а `kits_born_alive` так и
    // оставался шестью. Ферма после этого платила за поголовье, которого у
    // неё нет.
    if (birth.kits_carded_at) {
      await transaction.rollback();
      return ApiResponse.error(
        res,
        'По этому окролу карточки уже заведены — крольчата есть в поголовье',
        409, 'BIRTH_HAS_KIT_CARDS'
      );
    }

    // Карточек не может быть больше, чем родилось живыми: два числа про один
    // выводок обязаны сходиться. Иначе «родилось 6» соседствует с восемью
    // карточками, и ни одному из них уже нельзя верить.
    if (birth.kits_born_alive && kitCount > birth.kits_born_alive) {
      await transaction.rollback();
      return ApiResponse.error(
        res,
        `В окроле родилось живыми ${birth.kits_born_alive} — карточек не может быть больше`,
        400, 'KITS_MORE_THAN_BORN'
      );
    }

    // Лимит тарифа проверяется на всю пачку сразу. Одиночное добавление
    // кролика лимит соблюдало, а заведение карточек из окрола его обходило:
    // ферма уходила за предел тарифа целым выводком.
    try {
      await planService.assertRabbitLimit(farmId, kitCount);
    } catch (limitError) {
      if (limitError.message === 'RABBIT_LIMIT_REACHED') {
        await transaction.rollback();
        return ApiResponse.badRequest(
          res,
          'Достигнут лимит кроликов по тарифу фермы',
          'RABBIT_LIMIT_REACHED'
        );
      }
      throw limitError;
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
      return ApiResponse.notFound(res, 'Мать не найдена', 'MOTHER_NOT_FOUND');
    }

    let father = null;
    if (father_id) {
      father = await Rabbit.findOne({
        where: { id: father_id, farm_id: farmId },
        transaction
      });

      if (!father) {
        await transaction.rollback();
        return ApiResponse.notFound(res, 'Отец не найден', 'FATHER_NOT_FOUND');
      }

      if (father.sex !== 'male') {
        await transaction.rollback();
        return ApiResponse.error(res, 'Отцом может быть только самец', 400, 'NOT_A_MALE');
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
        return ApiResponse.notFound(res, 'Порода не найдена', 'BREED_NOT_FOUND');
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
          return ApiResponse.error(res, `Недостаточно места в клетке матери (свободно: ${cage.capacity - currentCount})`, 400, 'CAGE_FULL');
        }
      }
    }

    // Назначение берётся то же, что у кролика, заведённого вручную
    // (см. rabbitService.createRabbit): хозяйство называет его своим один
    // раз. Вписанное в код 'meat' означало, что настройка фермы работает
    // для меньшинства поголовья — рождённые крольчата её не наследовали.
    const farm = await Farm.findByPk(farmId, {
      attributes: ['default_purpose'],
      transaction
    });
    const kitPurpose = farm?.default_purpose || 'breeding';

    // Кличка даётся, только если фермер сам задал начало имени. Раньше сюда
    // подставлялось русское слово «Крольчонок», и оно попадало в базу
    // независимо от языка хозяйства: на узбекском экране триста голов
    // назывались бы «Крольчонок-N», и переводом это уже не исправить —
    // портятся сами данные. Без клички карточка показывает бирку, ровно как
    // у кролика, заведённого без имени (RabbitModel.label).
    const kits = [];

    for (let i = 1; i <= kitCount; i++) {
      const kit = await Rabbit.create({
        farm_id: farmId,
        tag_id: `kit-${randomUUID().slice(0, 8)}`,
        name: name_prefix ? `${name_prefix}-${i}` : null,
        breed_id: kitBreedId,
        sex: 'unknown',
        birth_date: birth_date || birth.birth_date,
        mother_id: mother.id,
        father_id: father ? father.id : null,
        status: 'active',
        cage_id: cageId,
        purpose: kitPurpose,
      }, { transaction });
      kits.push(kit);
    }

    await birth.update({ kits_carded_at: new Date() }, { transaction });

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
