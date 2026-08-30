const { Note, Rabbit, Cage, User } = require('../models');
const { Op } = require('sequelize');
const logger = require('../utils/logger');
const { startOfDayUtc, nextDayUtc } = require('../utils/dateRange');

const NOTE_INCLUDE = [
  { model: Rabbit, as: 'rabbit', attributes: ['id', 'name', 'tag_id'] },
  { model: Cage, as: 'cage', attributes: ['id', 'number', 'location'] },
  { model: User, as: 'author', attributes: ['id', 'full_name', 'email'] }
];

/**
 * Note service
 *
 * Заметка — короткая запись, необязательно привязанная к кролику или
 * клетке: и то и другое можно оставить пустым, тогда это заметка по ферме
 * в целом.
 */
class NoteService {
  async createNote(data) {
    const { farm_id, author_id, content, rabbit_id, cage_id } = data;

    if (rabbit_id) {
      const rabbit = await Rabbit.findOne({ where: { id: rabbit_id, farm_id } });
      if (!rabbit) throw new Error('RABBIT_NOT_FOUND');
    }

    if (cage_id) {
      const cage = await Cage.findOne({ where: { id: cage_id, farm_id } });
      if (!cage) throw new Error('CAGE_NOT_FOUND');
    }

    const note = await Note.create({
      farm_id,
      content,
      rabbit_id,
      cage_id,
      created_by: author_id
    });

    const created = await Note.findOne({ where: { id: note.id, farm_id }, include: NOTE_INCLUDE });
    logger.info('Note created', { noteId: note.id, farmId: farm_id });
    return created;
  }

  async getNoteById(id, farmId) {
    const note = await Note.findOne({ where: { id, farm_id: farmId }, include: NOTE_INCLUDE });
    if (!note) throw new Error('NOTE_NOT_FOUND');
    return note;
  }

  async listNotes(farmId, filters = {}) {
    const {
      page = 1,
      limit = 50,
      sort_by = 'created_at',
      sort_order = 'DESC',
      rabbit_id,
      cage_id,
      from_date,
      to_date
    } = filters;

    const offset = (page - 1) * limit;
    const where = { farm_id: farmId };

    if (rabbit_id) where.rabbit_id = rabbit_id;
    if (cage_id) where.cage_id = cage_id;

    if (from_date || to_date) {
      where.created_at = {};
      if (from_date) where.created_at[Op.gte] = startOfDayUtc(from_date);
      if (to_date) where.created_at[Op.lt] = nextDayUtc(to_date);
    }

    const { count, rows } = await Note.findAndCountAll({
      where,
      include: NOTE_INCLUDE,
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [[sort_by, sort_order.toUpperCase()]],
      distinct: true
    });

    return { items: rows, total: count, page: parseInt(page), limit: parseInt(limit) };
  }

  async updateNote(id, farmId, data) {
    const note = await Note.findOne({ where: { id, farm_id: farmId } });
    if (!note) throw new Error('NOTE_NOT_FOUND');

    const { rabbit_id, cage_id } = data;

    if (rabbit_id && rabbit_id !== note.rabbit_id) {
      const rabbit = await Rabbit.findOne({ where: { id: rabbit_id, farm_id: farmId } });
      if (!rabbit) throw new Error('RABBIT_NOT_FOUND');
    }

    if (cage_id && cage_id !== note.cage_id) {
      const cage = await Cage.findOne({ where: { id: cage_id, farm_id: farmId } });
      if (!cage) throw new Error('CAGE_NOT_FOUND');
    }

    await note.update(data);

    const updated = await Note.findOne({ where: { id, farm_id: farmId }, include: NOTE_INCLUDE });
    logger.info('Note updated', { noteId: id });
    return updated;
  }

  async deleteNote(id, farmId) {
    const note = await Note.findOne({ where: { id, farm_id: farmId } });
    if (!note) throw new Error('NOTE_NOT_FOUND');
    await note.destroy();
    logger.info('Note deleted', { noteId: id });
  }
}

module.exports = new NoteService();
