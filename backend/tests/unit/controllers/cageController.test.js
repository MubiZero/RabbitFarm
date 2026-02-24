jest.mock('../../../src/services/cageService');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn()
}));

const cageService = require('../../../src/services/cageService');
const cageController = require('../../../src/controllers/cageController');

const mockReq = (overrides = {}) => ({
  user: { id: 1 },
  params: {},
  body: {},
  query: {},
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

describe('CageController', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('create', () => {
    it('should create cage and return 201', async () => {
      const cage = { id: 1, number: 'A-001' };
      cageService.createCage.mockResolvedValue(cage);
      const req = mockReq({ body: { number: 'A-001', type: 'single' } });
      const res = mockRes();

      await cageController.create(req, res, mockNext);

      expect(cageService.createCage).toHaveBeenCalledWith({ number: 'A-001', type: 'single', user_id: 1 });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: cage }));
    });

    it('should delegate SequelizeUniqueConstraintError to next (global errorHandler)', async () => {
      const err = new Error('Unique constraint');
      err.name = 'SequelizeUniqueConstraintError';
      cageService.createCage.mockRejectedValue(err);
      const req = mockReq({ body: { number: 'A-001' } });
      const res = mockRes();

      await cageController.create(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });

    it('should delegate SequelizeValidationError to next (global errorHandler)', async () => {
      const err = new Error('Validation error');
      err.name = 'SequelizeValidationError';
      err.errors = [{ message: 'Number is required' }];
      cageService.createCage.mockRejectedValue(err);
      const req = mockReq({ body: {} });
      const res = mockRes();

      await cageController.create(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      cageService.createCage.mockRejectedValue(err);
      const req = mockReq({ body: {} });
      const res = mockRes();

      await cageController.create(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getById', () => {
    it('should return cage with 200', async () => {
      const cage = { id: 1, number: 'A-001' };
      cageService.getCageById.mockResolvedValue(cage);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await cageController.getById(req, res, mockNext);

      expect(cageService.getCageById).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: cage }));
    });

    it('should return 404 when CAGE_NOT_FOUND', async () => {
      cageService.getCageById.mockRejectedValue(new Error('CAGE_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await cageController.getById(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      cageService.getCageById.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await cageController.getById(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('list', () => {
    it('should return paginated cage list with 200', async () => {
      const result = { items: [{ id: 1 }], page: 1, limit: 10, total: 1 };
      cageService.listCages.mockResolvedValue(result);
      const req = mockReq({ query: { page: '1', limit: '10' } });
      const res = mockRes();

      await cageController.list(req, res, mockNext);

      expect(cageService.listCages).toHaveBeenCalledWith(1, { page: '1', limit: '10' });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true }));
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      cageService.listCages.mockRejectedValue(err);
      const req = mockReq({});
      const res = mockRes();

      await cageController.list(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('update', () => {
    it('should update cage and return 200', async () => {
      const cage = { id: 1, number: 'A-002' };
      cageService.updateCage.mockResolvedValue(cage);
      const req = mockReq({ params: { id: '1' }, body: { number: 'A-002' } });
      const res = mockRes();

      await cageController.update(req, res, mockNext);

      expect(cageService.updateCage).toHaveBeenCalledWith('1', 1, { number: 'A-002' });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: cage }));
    });

    it('should return 404 when CAGE_NOT_FOUND', async () => {
      cageService.updateCage.mockRejectedValue(new Error('CAGE_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' }, body: {} });
      const res = mockRes();

      await cageController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should delegate SequelizeUniqueConstraintError to next (global errorHandler)', async () => {
      const err = new Error('Unique'); err.name = 'SequelizeUniqueConstraintError';
      cageService.updateCage.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' }, body: {} });
      const res = mockRes();

      await cageController.update(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });

    it('should delegate SequelizeValidationError to next (global errorHandler)', async () => {
      const err = new Error('Validation'); err.name = 'SequelizeValidationError';
      err.errors = [{ message: 'Field invalid' }];
      cageService.updateCage.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' }, body: {} });
      const res = mockRes();

      await cageController.update(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      cageService.updateCage.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' }, body: {} });
      const res = mockRes();

      await cageController.update(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('delete', () => {
    it('should delete cage and return 200', async () => {
      cageService.deleteCage.mockResolvedValue();
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await cageController.delete(req, res, mockNext);

      expect(cageService.deleteCage).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: null }));
    });

    it('should return 404 when CAGE_NOT_FOUND', async () => {
      cageService.deleteCage.mockRejectedValue(new Error('CAGE_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await cageController.delete(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when CAGE_HAS_RABBITS', async () => {
      cageService.deleteCage.mockRejectedValue(new Error('CAGE_HAS_RABBITS'));
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await cageController.delete(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      cageService.deleteCage.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await cageController.delete(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getStatistics', () => {
    it('should return statistics with 200', async () => {
      const stats = { total: 10, occupied: 5 };
      cageService.getStatistics.mockResolvedValue(stats);
      const req = mockReq({});
      const res = mockRes();

      await cageController.getStatistics(req, res, mockNext);

      expect(cageService.getStatistics).toHaveBeenCalledWith(1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: stats }));
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      cageService.getStatistics.mockRejectedValue(err);
      const req = mockReq({});
      const res = mockRes();

      await cageController.getStatistics(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('markCleaned', () => {
    it('should mark cage as cleaned and return 200', async () => {
      const cage = { id: 1, last_cleaned_at: new Date() };
      cageService.markCleaned.mockResolvedValue(cage);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await cageController.markCleaned(req, res, mockNext);

      expect(cageService.markCleaned).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: cage }));
    });

    it('should return 404 when CAGE_NOT_FOUND', async () => {
      cageService.markCleaned.mockRejectedValue(new Error('CAGE_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await cageController.markCleaned(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      cageService.markCleaned.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await cageController.markCleaned(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getLayout', () => {
    it('should return layout with 200', async () => {
      const layout = [{ row: 1, cages: [] }];
      cageService.getLayout.mockResolvedValue(layout);
      const req = mockReq({});
      const res = mockRes();

      await cageController.getLayout(req, res, mockNext);

      expect(cageService.getLayout).toHaveBeenCalledWith(1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: layout }));
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      cageService.getLayout.mockRejectedValue(err);
      const req = mockReq({});
      const res = mockRes();

      await cageController.getLayout(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });
});
