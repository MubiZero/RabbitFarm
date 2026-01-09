const { MedicalRecord, Rabbit, Breed, Transaction, sequelize } = require('../models');
const ApiResponse = require('../utils/apiResponse');
const logger = require('../utils/logger');
const { Op } = require('sequelize');

/**
 * Medical Record controller
 * Handles HTTP requests for medical records management
 */
class MedicalRecordController {
  /**
   * Create new medical record
   * POST /api/v1/medical-records
   */
  async create(req, res, next) {
    const t = await sequelize.transaction();
    try {
      const { rabbit_id, outcome, cost, started_at, diagnosis } = req.body;

      // Check if rabbit exists and belongs to user
      const rabbit = await Rabbit.findOne({
        where: { id: rabbit_id, user_id: req.user.id },
        transaction: t
      });
      if (!rabbit) {
        await t.rollback();
        return ApiResponse.notFound(res, 'Кролик не найден');
      }

      // Check vitality
      if (rabbit.status === 'dead' || rabbit.status === 'sold') {
        await t.rollback();
        return ApiResponse.badRequest(res, 'Нельзя добавить запись для мертвого или проданного кролика');
      }

      const medicalRecord = await MedicalRecord.create(req.body, { transaction: t });

      // Automation 1: Status Update
      if (['died', 'euthanized'].includes(outcome)) {
        await rabbit.update({ status: 'dead', cage_id: null }, { transaction: t });
      } else if (outcome === 'ongoing') {
        await rabbit.update({ status: 'sick' }, { transaction: t });
      }

      // Automation 2: Financial Transaction
      if (cost && parseFloat(cost) > 0) {
        await Transaction.create({
          type: 'expense',
          category: 'Health',
          amount: cost,
          transaction_date: started_at || new Date(),
          rabbit_id: rabbit_id,
          description: `Medical: ${diagnosis || 'Treatment'}`,
          created_by: req.user.id
        }, { transaction: t });
      }

      await t.commit();

      // Fetch created record with rabbit info
      const result = await MedicalRecord.findByPk(medicalRecord.id, {
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            attributes: ['id', 'name', 'tag_id', 'sex', 'birth_date'],
            include: [{ model: Breed, as: 'breed', attributes: ['id', 'name'] }]
          }
        ]
      });

      return ApiResponse.created(res, result, 'Медицинская запись успешно создана');
    } catch (error) {
      await t.rollback();
      if (error.name === 'SequelizeValidationError') {
        return ApiResponse.badRequest(res, error.errors[0].message);
      }
      next(error);
    }
  }

  /**
   * Get medical record by ID
   * GET /api/v1/medical-records/:id
   */
  async getById(req, res, next) {
    try {
      const medicalRecord = await MedicalRecord.findByPk(req.params.id, {
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            where: { user_id: req.user.id }, // Filter by user
            attributes: ['id', 'name', 'tag_id', 'sex', 'birth_date', 'photo_url'],
            include: [
              {
                model: Breed,
                as: 'breed',
                attributes: ['id', 'name']
              }
            ]
          }
        ]
      });

      if (!medicalRecord) {
        return ApiResponse.notFound(res, 'Медицинская запись не найдена');
      }

      return ApiResponse.success(res, medicalRecord);
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get list of medical records
   * GET /api/v1/medical-records
   */
  async list(req, res, next) {
    try {
      const {
        page = 1,
        limit = 50,
        sort_by = 'started_at',
        sort_order = 'DESC',
        rabbit_id,
        outcome,
        from_date,
        to_date,
        ongoing // Filter for ongoing treatments
      } = req.query;

      const offset = (parseInt(page) - 1) * parseInt(limit);
      const where = {};

      // Filters
      if (rabbit_id) where.rabbit_id = rabbit_id;
      if (outcome) where.outcome = outcome;
      if (ongoing === 'true') {
        where.outcome = 'ongoing';
      }
      if (from_date) {
        where.started_at = {
          ...where.started_at,
          [Op.gte]: from_date
        };
      }
      if (to_date) {
        where.started_at = {
          ...where.started_at,
          [Op.lte]: to_date
        };
      }

      const medicalRecords = await MedicalRecord.findAndCountAll({
        where,
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            where: { user_id: req.user.id }, // Filter by user
            attributes: ['id', 'name', 'tag_id', 'sex', 'birth_date', 'photo_url', 'status'],
            include: [
              {
                model: Breed,
                as: 'breed',
                attributes: ['id', 'name']
              }
            ]
          }
        ],
        limit: parseInt(limit),
        offset,
        order: [[sort_by, sort_order.toUpperCase()]],
        distinct: true
      });

      return ApiResponse.paginated(
        res,
        medicalRecords.rows,
        parseInt(page),
        parseInt(limit),
        medicalRecords.count,
        'Список медицинских записей получен успешно'
      );
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get medical records for specific rabbit
   * GET /api/v1/rabbits/:rabbitId/medical-records
   */
  async getByRabbit(req, res, next) {
    try {
      const { rabbitId } = req.params;

      // Check if rabbit exists and belongs to user
      const rabbit = await Rabbit.findOne({
        where: {
          id: rabbitId,
          user_id: req.user.id
        }
      });
      if (!rabbit) {
        return ApiResponse.notFound(res, 'Кролик не найден');
      }

      const medicalRecords = await MedicalRecord.findAll({
        where: { rabbit_id: rabbitId },
        order: [['started_at', 'DESC']],
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            attributes: ['id', 'name', 'tag_id']
          }
        ]
      });

      return ApiResponse.success(res, medicalRecords, 'История болезней получена успешно');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Update medical record
   * PUT /api/v1/medical-records/:id
   */
  async update(req, res, next) {
    const t = await sequelize.transaction();
    try {
      const medicalRecord = await MedicalRecord.findByPk(req.params.id, {
        include: [{ model: Rabbit, as: 'rabbit' }],
        transaction: t
      });

      if (!medicalRecord || medicalRecord.rabbit.user_id !== req.user.id) {
        await t.rollback();
        return ApiResponse.notFound(res, 'Медицинская запись не найдена');
      }

      const oldOutcome = medicalRecord.outcome;
      const oldCost = medicalRecord.cost;

      // If rabbit_id is being updated, check if new rabbit exists and belongs to user
      if (req.body.rabbit_id && req.body.rabbit_id !== medicalRecord.rabbit_id) {
        const newRabbit = await Rabbit.findOne({
          where: { id: req.body.rabbit_id, user_id: req.user.id },
          transaction: t
        });
        if (!newRabbit) {
          await t.rollback();
          return ApiResponse.notFound(res, 'Кролик не найден');
        }
      }

      await medicalRecord.update(req.body, { transaction: t });

      // Automation: Status Update
      if (['died', 'euthanized'].includes(req.body.outcome) && oldOutcome !== req.body.outcome) {
        await medicalRecord.rabbit.update({ status: 'dead', cage_id: null }, { transaction: t });
      }

      await t.commit();

      // Fetch updated record with rabbit info
      const result = await MedicalRecord.findByPk(medicalRecord.id, {
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            attributes: ['id', 'name', 'tag_id', 'sex'],
            include: [{ model: Breed, as: 'breed', attributes: ['id', 'name'] }]
          }
        ]
      });

      return ApiResponse.success(res, result, 'Медицинская запись успешно обновлена');
    } catch (error) {
      await t.rollback();
      if (error.name === 'SequelizeValidationError') {
        return ApiResponse.badRequest(res, error.errors[0].message);
      }
      next(error);
    }
  }

  /**
   * Delete medical record
   * DELETE /api/v1/medical-records/:id
   */
  async delete(req, res, next) {
    try {
      const medicalRecord = await MedicalRecord.findOne({
        where: { id: req.params.id },
        include: [{
          model: Rabbit,
          where: { user_id: req.user.id },
          attributes: ['id']
        }]
      });

      if (!medicalRecord) {
        return ApiResponse.notFound(res, 'Медицинская запись не найдена');
      }

      await medicalRecord.destroy();

      return ApiResponse.success(res, null, 'Медицинская запись успешно удалена');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get medical records statistics
   * GET /api/v1/medical-records/statistics
   */
  async getStatistics(req, res, next) {
    try {
      const medicalRecords = await MedicalRecord.findAll({
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            where: { user_id: req.user.id }, // Filter by user
            attributes: ['id', 'status']
          }
        ]
      });

      const now = new Date();
      const thisYear = new Date(now.getFullYear(), 0, 1);
      const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, now.getDate());

      const stats = {
        total_records: medicalRecords.length,
        by_outcome: {
          recovered: 0,
          ongoing: 0,
          died: 0,
          euthanized: 0
        },
        ongoing_treatments: [],
        total_cost: 0,
        this_year: 0,
        last_month: 0
      };

      medicalRecords.forEach(record => {
        // Count by outcome
        if (record.outcome) {
          stats.by_outcome[record.outcome]++;
        }

        // Collect ongoing treatments
        if (record.outcome === 'ongoing') {
          const startDate = new Date(record.started_at);
          const daysOngoing = Math.floor((now - startDate) / (1000 * 60 * 60 * 24));

          stats.ongoing_treatments.push({
            id: record.id,
            rabbit_id: record.rabbit_id,
            rabbit_name: record.rabbit?.name,
            diagnosis: record.diagnosis,
            started_at: record.started_at,
            days_ongoing: daysOngoing,
            symptoms: record.symptoms
          });
        }

        // Sum costs
        if (record.cost) {
          stats.total_cost += parseFloat(record.cost);
        }

        // Count this year
        if (new Date(record.started_at) >= thisYear) {
          stats.this_year++;
        }

        // Count last month
        if (new Date(record.started_at) >= lastMonth) {
          stats.last_month++;
        }
      });

      // Sort ongoing treatments by days (longest first)
      stats.ongoing_treatments.sort((a, b) => b.days_ongoing - a.days_ongoing);

      // Round total cost
      stats.total_cost = Math.round(stats.total_cost * 100) / 100;

      return ApiResponse.success(res, stats, 'Статистика медицинских записей получена успешно');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get ongoing treatments
   * GET /api/v1/medical-records/ongoing
   */
  async getOngoing(req, res, next) {
    try {
      const medicalRecords = await MedicalRecord.findAll({
        where: {
          outcome: 'ongoing'
        },
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            attributes: ['id', 'name', 'tag_id', 'sex', 'status', 'photo_url'],
            where: {
              user_id: req.user.id, // Filter by user
              status: {
                [Op.in]: ['healthy', 'pregnant', 'sick'] // Exclude dead/sold
              }
            },
            include: [
              {
                model: Breed,
                as: 'breed',
                attributes: ['id', 'name']
              }
            ]
          }
        ],
        order: [['started_at', 'ASC']]
      });

      const now = new Date();
      const result = medicalRecords.map(record => {
        const rec = record.toJSON();
        const startDate = new Date(record.started_at);
        rec.days_ongoing = Math.floor((now - startDate) / (1000 * 60 * 60 * 24));
        return rec;
      });

      return ApiResponse.success(res, result, 'Текущие лечения');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get treatment history with costs
   * GET /api/v1/medical-records/costs
   */
  async getCosts(req, res, next) {
    try {
      const { from_date, to_date } = req.query;
      const where = {
        cost: { [Op.not]: null }
      };

      if (from_date) {
        where.started_at = {
          ...where.started_at,
          [Op.gte]: from_date
        };
      }
      if (to_date) {
        where.started_at = {
          ...where.started_at,
          [Op.lte]: to_date
        };
      }

      const medicalRecords = await MedicalRecord.findAll({
        where,
        attributes: [
          'id',
          'rabbit_id',
          'diagnosis',
          'started_at',
          'ended_at',
          'cost',
          'medication',
          'veterinarian'
        ],
        include: [
          {
            model: Rabbit,
            as: 'rabbit',
            where: { user_id: req.user.id }, // Filter by user
            attributes: ['id', 'name', 'tag_id']
          }
        ],
        order: [['started_at', 'DESC']]
      });

      const totalCost = medicalRecords.reduce((sum, record) => {
        return sum + (record.cost ? parseFloat(record.cost) : 0);
      }, 0);

      return ApiResponse.success(res, {
        records: medicalRecords,
        total_cost: Math.round(totalCost * 100) / 100,
        count: medicalRecords.length
      }, 'Расходы на лечение получены успешно');
    } catch (error) {
      next(error);
    }
  }
}

module.exports = new MedicalRecordController();
