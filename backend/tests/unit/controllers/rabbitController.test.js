jest.mock('../../../src/services/rabbitService');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn()
}));

const rabbitService = require('../../../src/services/rabbitService');
const rabbitController = require('../../../src/controllers/rabbitController');

const mockReq = (overrides = {}) => ({
  user: { id: 1 },
  params: {},
  body: {},
  query: {},
  file: null,
  ...overrides
});

const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  res.send = jest.fn().mockReturnValue(res);
  return res;
};

const mockNext = jest.fn();

describe('RabbitController', () => {
  beforeEach(() => jest.clearAllMocks());

  // ─── create ────────────────────────────────────────────────────────

  describe('create', () => {
    it('should create rabbit and return 201', async () => {
      const rabbit = { id: 1, name: 'Bunny' };
      rabbitService.createRabbit.mockResolvedValue(rabbit);
      const req = mockReq({ body: { name: 'Bunny', breed_id: 1 } });
      const res = mockRes();

      await rabbitController.create(req, res, mockNext);

      expect(rabbitService.createRabbit).toHaveBeenCalledWith({
        name: 'Bunny',
        breed_id: 1,
        user_id: 1
      });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: rabbit }));
    });

    it('should attach photo_url when file is uploaded', async () => {
      const rabbit = { id: 1, name: 'Bunny', photo_url: '/uploads/rabbits/photo.jpg' };
      rabbitService.createRabbit.mockResolvedValue(rabbit);
      const req = mockReq({
        body: { name: 'Bunny' },
        file: { filename: 'photo.jpg' }
      });
      const res = mockRes();

      await rabbitController.create(req, res, mockNext);

      expect(rabbitService.createRabbit).toHaveBeenCalledWith(
        expect.objectContaining({ photo_url: '/uploads/rabbits/photo.jpg' })
      );
      expect(res.status).toHaveBeenCalledWith(201);
    });

    it('should return 404 when BREED_NOT_FOUND', async () => {
      rabbitService.createRabbit.mockRejectedValue(new Error('BREED_NOT_FOUND'));
      const req = mockReq({ body: { breed_id: 999 } });
      const res = mockRes();

      await rabbitController.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 404 when CAGE_NOT_FOUND', async () => {
      rabbitService.createRabbit.mockRejectedValue(new Error('CAGE_NOT_FOUND'));
      const req = mockReq({ body: { cage_id: 999 } });
      const res = mockRes();

      await rabbitController.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when TAG_ID_EXISTS', async () => {
      rabbitService.createRabbit.mockRejectedValue(new Error('TAG_ID_EXISTS'));
      const req = mockReq({ body: { tag_id: 'DUP' } });
      const res = mockRes();

      await rabbitController.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      rabbitService.createRabbit.mockRejectedValue(err);
      const req = mockReq({ body: {} });
      const res = mockRes();

      await rabbitController.create(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  // ─── getById ───────────────────────────────────────────────────────

  describe('getById', () => {
    it('should return rabbit with 200', async () => {
      const rabbit = { id: 1, name: 'Bunny' };
      rabbitService.getRabbitById.mockResolvedValue(rabbit);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.getById(req, res, mockNext);

      expect(rabbitService.getRabbitById).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: rabbit }));
    });

    it('should return 404 when RABBIT_NOT_FOUND', async () => {
      rabbitService.getRabbitById.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await rabbitController.getById(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      rabbitService.getRabbitById.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.getById(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  // ─── list ──────────────────────────────────────────────────────────

  describe('list', () => {
    it('should return paginated list with 200', async () => {
      const result = {
        items: [{ id: 1 }],
        pagination: { page: 1, limit: 10, total: 1 }
      };
      rabbitService.listRabbits.mockResolvedValue(result);
      const req = mockReq({ query: { page: '1', limit: '10', sort_by: 'name', sort_order: 'asc', sex: 'male' } });
      const res = mockRes();

      await rabbitController.list(req, res, mockNext);

      expect(rabbitService.listRabbits).toHaveBeenCalledWith(
        1,
        { sex: 'male' },
        { page: '1', limit: '10', sort_by: 'name', sort_order: 'asc' }
      );
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true }));
    });

    it('should pass empty filters when no query filters provided', async () => {
      const result = {
        items: [],
        pagination: { page: 1, limit: 10, total: 0 }
      };
      rabbitService.listRabbits.mockResolvedValue(result);
      const req = mockReq({ query: {} });
      const res = mockRes();

      await rabbitController.list(req, res, mockNext);

      expect(rabbitService.listRabbits).toHaveBeenCalledWith(
        1,
        {},
        { page: undefined, limit: undefined, sort_by: undefined, sort_order: undefined }
      );
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      rabbitService.listRabbits.mockRejectedValue(err);
      const req = mockReq({});
      const res = mockRes();

      await rabbitController.list(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  // ─── update ────────────────────────────────────────────────────────

  describe('update', () => {
    it('should update rabbit and return 200', async () => {
      const rabbit = { id: 1, name: 'Updated' };
      rabbitService.updateRabbit.mockResolvedValue(rabbit);
      const req = mockReq({ params: { id: '1' }, body: { name: 'Updated' } });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(rabbitService.updateRabbit).toHaveBeenCalledWith('1', 1, { name: 'Updated' });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: rabbit }));
    });

    it('should attach photo_url when file is uploaded', async () => {
      const rabbit = { id: 1, photo_url: '/uploads/rabbits/new.jpg' };
      rabbitService.updateRabbit.mockResolvedValue(rabbit);
      const req = mockReq({
        params: { id: '1' },
        body: { name: 'Updated' },
        file: { filename: 'new.jpg' }
      });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(rabbitService.updateRabbit).toHaveBeenCalledWith('1', 1, expect.objectContaining({
        photo_url: '/uploads/rabbits/new.jpg'
      }));
    });

    it('should return 404 when RABBIT_NOT_FOUND', async () => {
      rabbitService.updateRabbit.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' }, body: {} });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 404 when BREED_NOT_FOUND', async () => {
      rabbitService.updateRabbit.mockRejectedValue(new Error('BREED_NOT_FOUND'));
      const req = mockReq({ params: { id: '1' }, body: { breed_id: 999 } });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 404 when CAGE_NOT_FOUND', async () => {
      rabbitService.updateRabbit.mockRejectedValue(new Error('CAGE_NOT_FOUND'));
      const req = mockReq({ params: { id: '1' }, body: { cage_id: 999 } });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when TAG_ID_EXISTS', async () => {
      rabbitService.updateRabbit.mockRejectedValue(new Error('TAG_ID_EXISTS'));
      const req = mockReq({ params: { id: '1' }, body: { tag_id: 'DUP' } });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when CANNOT_CHANGE_SEX_WITH_HISTORY', async () => {
      rabbitService.updateRabbit.mockRejectedValue(new Error('CANNOT_CHANGE_SEX_WITH_HISTORY'));
      const req = mockReq({ params: { id: '1' }, body: { sex: 'female' } });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when FATHER_NOT_FOUND_OR_INVALID_SEX', async () => {
      rabbitService.updateRabbit.mockRejectedValue(new Error('FATHER_NOT_FOUND_OR_INVALID_SEX'));
      const req = mockReq({ params: { id: '1' }, body: { father_id: 5 } });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when MOTHER_NOT_FOUND_OR_INVALID_SEX', async () => {
      rabbitService.updateRabbit.mockRejectedValue(new Error('MOTHER_NOT_FOUND_OR_INVALID_SEX'));
      const req = mockReq({ params: { id: '1' }, body: { mother_id: 5 } });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when CAGE_FULL', async () => {
      rabbitService.updateRabbit.mockRejectedValue(new Error('CAGE_FULL'));
      const req = mockReq({ params: { id: '1' }, body: { cage_id: 2 } });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when CANNOT_BE_OWN_FATHER', async () => {
      rabbitService.updateRabbit.mockRejectedValue(new Error('CANNOT_BE_OWN_FATHER'));
      const req = mockReq({ params: { id: '1' }, body: { father_id: 1 } });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when CANNOT_BE_OWN_MOTHER', async () => {
      rabbitService.updateRabbit.mockRejectedValue(new Error('CANNOT_BE_OWN_MOTHER'));
      const req = mockReq({ params: { id: '1' }, body: { mother_id: 1 } });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      rabbitService.updateRabbit.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' }, body: {} });
      const res = mockRes();

      await rabbitController.update(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  // ─── delete ────────────────────────────────────────────────────────

  describe('delete', () => {
    it('should delete rabbit and return 200', async () => {
      rabbitService.deleteRabbit.mockResolvedValue();
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.delete(req, res, mockNext);

      expect(rabbitService.deleteRabbit).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: null }));
    });

    it('should return 404 when RABBIT_NOT_FOUND', async () => {
      rabbitService.deleteRabbit.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await rabbitController.delete(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when RABBIT_HAS_OFFSPRING', async () => {
      rabbitService.deleteRabbit.mockRejectedValue(new Error('RABBIT_HAS_OFFSPRING'));
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.delete(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when RABBIT_HAS_BREEDING_HISTORY', async () => {
      rabbitService.deleteRabbit.mockRejectedValue(new Error('RABBIT_HAS_BREEDING_HISTORY'));
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.delete(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when RABBIT_HAS_BIRTH_HISTORY', async () => {
      rabbitService.deleteRabbit.mockRejectedValue(new Error('RABBIT_HAS_BIRTH_HISTORY'));
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.delete(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when RABBIT_HAS_HEALTH_HISTORY', async () => {
      rabbitService.deleteRabbit.mockRejectedValue(new Error('RABBIT_HAS_HEALTH_HISTORY'));
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.delete(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when RABBIT_HAS_FINANCIAL_HISTORY', async () => {
      rabbitService.deleteRabbit.mockRejectedValue(new Error('RABBIT_HAS_FINANCIAL_HISTORY'));
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.delete(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      rabbitService.deleteRabbit.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.delete(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  // ─── getWeightHistory ──────────────────────────────────────────────

  describe('getWeightHistory', () => {
    it('should return weight history with 200', async () => {
      const weights = [{ id: 1, weight: 2.5 }];
      rabbitService.getWeightHistory.mockResolvedValue(weights);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.getWeightHistory(req, res, mockNext);

      expect(rabbitService.getWeightHistory).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: weights }));
    });

    it('should return 404 when RABBIT_NOT_FOUND', async () => {
      rabbitService.getWeightHistory.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await rabbitController.getWeightHistory(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      rabbitService.getWeightHistory.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.getWeightHistory(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  // ─── addWeight ─────────────────────────────────────────────────────

  describe('addWeight', () => {
    it('should add weight and return 201', async () => {
      const weight = { id: 1, weight: 3.0 };
      rabbitService.addWeightRecord.mockResolvedValue(weight);
      const req = mockReq({ params: { id: '1' }, body: { weight: 3.0, date: '2025-01-01' } });
      const res = mockRes();

      await rabbitController.addWeight(req, res, mockNext);

      expect(rabbitService.addWeightRecord).toHaveBeenCalledWith('1', 1, { weight: 3.0, date: '2025-01-01' });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: weight }));
    });

    it('should return 404 when RABBIT_NOT_FOUND', async () => {
      rabbitService.addWeightRecord.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' }, body: { weight: 3.0 } });
      const res = mockRes();

      await rabbitController.addWeight(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      rabbitService.addWeightRecord.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' }, body: {} });
      const res = mockRes();

      await rabbitController.addWeight(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  // ─── getStatistics ─────────────────────────────────────────────────

  describe('getStatistics', () => {
    it('should return statistics with 200', async () => {
      const stats = { total: 50, males: 20, females: 30 };
      rabbitService.getStatistics.mockResolvedValue(stats);
      const req = mockReq({});
      const res = mockRes();

      await rabbitController.getStatistics(req, res, mockNext);

      expect(rabbitService.getStatistics).toHaveBeenCalledWith(1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: stats }));
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      rabbitService.getStatistics.mockRejectedValue(err);
      const req = mockReq({});
      const res = mockRes();

      await rabbitController.getStatistics(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  // ─── getPedigree ───────────────────────────────────────────────────

  describe('getPedigree', () => {
    it('should return pedigree with 200 and default 3 generations', async () => {
      const pedigree = { id: 1, parents: {} };
      rabbitService.getPedigree.mockResolvedValue(pedigree);
      const req = mockReq({ params: { id: '1' }, query: {} });
      const res = mockRes();

      await rabbitController.getPedigree(req, res, mockNext);

      expect(rabbitService.getPedigree).toHaveBeenCalledWith('1', 1, 3);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: pedigree }));
    });

    it('should parse generations query parameter', async () => {
      const pedigree = { id: 1, parents: {} };
      rabbitService.getPedigree.mockResolvedValue(pedigree);
      const req = mockReq({ params: { id: '1' }, query: { generations: '5' } });
      const res = mockRes();

      await rabbitController.getPedigree(req, res, mockNext);

      expect(rabbitService.getPedigree).toHaveBeenCalledWith('1', 1, 5);
    });

    it('should default to 3 when generations is not a number', async () => {
      const pedigree = { id: 1, parents: {} };
      rabbitService.getPedigree.mockResolvedValue(pedigree);
      const req = mockReq({ params: { id: '1' }, query: { generations: 'abc' } });
      const res = mockRes();

      await rabbitController.getPedigree(req, res, mockNext);

      expect(rabbitService.getPedigree).toHaveBeenCalledWith('1', 1, 3);
    });

    it('should return 404 when RABBIT_NOT_FOUND', async () => {
      rabbitService.getPedigree.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' }, query: {} });
      const res = mockRes();

      await rabbitController.getPedigree(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      rabbitService.getPedigree.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' }, query: {} });
      const res = mockRes();

      await rabbitController.getPedigree(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  // ─── uploadPhoto ───────────────────────────────────────────────────

  describe('uploadPhoto', () => {
    it('should upload photo and return 200', async () => {
      const rabbit = { id: 1, photo_url: '/uploads/rabbits/img.jpg' };
      rabbitService.updateRabbit.mockResolvedValue(rabbit);
      const req = mockReq({ params: { id: '1' }, file: { filename: 'img.jpg' } });
      const res = mockRes();

      await rabbitController.uploadPhoto(req, res, mockNext);

      expect(rabbitService.updateRabbit).toHaveBeenCalledWith('1', 1, {
        photo_url: '/uploads/rabbits/img.jpg'
      });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: rabbit }));
    });

    it('should return 400 when no file uploaded', async () => {
      const req = mockReq({ params: { id: '1' }, file: null });
      const res = mockRes();

      await rabbitController.uploadPhoto(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(rabbitService.updateRabbit).not.toHaveBeenCalled();
    });

    it('should return 400 when file is undefined', async () => {
      const req = mockReq({ params: { id: '1' } });
      delete req.file;
      const res = mockRes();

      await rabbitController.uploadPhoto(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should return 404 when RABBIT_NOT_FOUND', async () => {
      rabbitService.updateRabbit.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' }, file: { filename: 'img.jpg' } });
      const res = mockRes();

      await rabbitController.uploadPhoto(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      rabbitService.updateRabbit.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' }, file: { filename: 'img.jpg' } });
      const res = mockRes();

      await rabbitController.uploadPhoto(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  // ─── deletePhoto ───────────────────────────────────────────────────

  describe('deletePhoto', () => {
    it('should delete photo and return 200', async () => {
      const rabbit = { id: 1, photo_url: null };
      rabbitService.updateRabbit.mockResolvedValue(rabbit);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.deletePhoto(req, res, mockNext);

      expect(rabbitService.updateRabbit).toHaveBeenCalledWith('1', 1, { photo_url: null });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: rabbit }));
    });

    it('should return 404 when RABBIT_NOT_FOUND', async () => {
      rabbitService.updateRabbit.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await rabbitController.deletePhoto(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      rabbitService.updateRabbit.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await rabbitController.deletePhoto(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });
});
