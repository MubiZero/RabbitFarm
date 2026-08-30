const noteService = require('../services/noteService');
const ApiResponse = require('../utils/apiResponse');

/**
 * Note Controller
 * Заметки по кролику, клетке или ферме в целом
 */

exports.create = async (req, res, next) => {
  try {
    const note = await noteService.createNote({ ...req.body, farm_id: req.farmId, author_id: req.user.id });
    return ApiResponse.success(res, note, 'Заметка добавлена', 201);
  } catch (error) {
    if (error.message === 'RABBIT_NOT_FOUND') return ApiResponse.error(res, 'Кролик не найден', 404);
    if (error.message === 'CAGE_NOT_FOUND') return ApiResponse.error(res, 'Клетка не найдена', 404);
    next(error);
  }
};

exports.getById = async (req, res, next) => {
  try {
    const note = await noteService.getNoteById(req.params.id, req.farmId);
    return ApiResponse.success(res, note, 'Заметка получена');
  } catch (error) {
    if (error.message === 'NOTE_NOT_FOUND') return ApiResponse.error(res, 'Заметка не найдена', 404);
    next(error);
  }
};

exports.list = async (req, res, next) => {
  try {
    const result = await noteService.listNotes(req.farmId, req.query);
    return ApiResponse.paginated(res, result.items, result.page, result.limit, result.total, 'Список заметок получен');
  } catch (error) {
    next(error);
  }
};

exports.update = async (req, res, next) => {
  try {
    const note = await noteService.updateNote(req.params.id, req.farmId, req.body);
    return ApiResponse.success(res, note, 'Заметка обновлена');
  } catch (error) {
    if (error.message === 'NOTE_NOT_FOUND') return ApiResponse.error(res, 'Заметка не найдена', 404);
    if (error.message === 'RABBIT_NOT_FOUND') return ApiResponse.error(res, 'Кролик не найден', 404);
    if (error.message === 'CAGE_NOT_FOUND') return ApiResponse.error(res, 'Клетка не найдена', 404);
    next(error);
  }
};

exports.delete = async (req, res, next) => {
  try {
    await noteService.deleteNote(req.params.id, req.farmId);
    return ApiResponse.success(res, null, 'Заметка удалена');
  } catch (error) {
    if (error.message === 'NOTE_NOT_FOUND') return ApiResponse.error(res, 'Заметка не найдена', 404);
    next(error);
  }
};
