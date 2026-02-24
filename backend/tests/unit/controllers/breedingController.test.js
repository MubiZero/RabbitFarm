jest.mock('../../../src/services/breedingService');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const breedingService = require('../../../src/services/breedingService');
const breedingController = require('../../../src/controllers/breedingController');

const mockReq = (overrides = {}) => ({
  user: { id: 1 }, params: {}, body: {}, query: {}, ...overrides
});
const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
};
const mockNext = jest.fn();

describe('BreedingController', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('create', () => {
    it('should create breeding and return 201', async () => {
      const breeding = { id: 1, male_id: 1, female_id: 2 };
      breedingService.createBreeding.mockResolvedValue(breeding);
      const req = mockReq({ body: { male_id: 1, female_id: 2 } });
      const res = mockRes();

      await breedingController.create(req, res, mockNext);

      expect(breedingService.createBreeding).toHaveBeenCalledWith({ male_id: 1, female_id: 2, user_id: 1 });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: breeding }));
    });

    it('should return 404 on MALE_NOT_FOUND', async () => {
      breedingService.createBreeding.mockRejectedValue(new Error('MALE_NOT_FOUND'));
      const res = mockRes();
      await breedingController.create(mockReq(), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 404 on FEMALE_NOT_FOUND', async () => {
      breedingService.createBreeding.mockRejectedValue(new Error('FEMALE_NOT_FOUND'));
      const res = mockRes();
      await breedingController.create(mockReq(), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should return 400 on INVALID_MALE_SEX', async () => {
      breedingService.createBreeding.mockRejectedValue(new Error('INVALID_MALE_SEX'));
      const res = mockRes();
      await breedingController.create(mockReq(), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should return 400 on INVALID_FEMALE_SEX', async () => {
      breedingService.createBreeding.mockRejectedValue(new Error('INVALID_FEMALE_SEX'));
      const res = mockRes();
      await breedingController.create(mockReq(), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should call next on unexpected error', async () => {
      const err = new Error('DB error');
      breedingService.createBreeding.mockRejectedValue(err);
      await breedingController.create(mockReq(), mockRes(), mockNext);
      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getById', () => {
    it('should return breeding by id', async () => {
      const breeding = { id: 5 };
      breedingService.getBreedingById.mockResolvedValue(breeding);
      const req = mockReq({ params: { id: '5' } });
      const res = mockRes();

      await breedingController.getById(req, res, mockNext);

      expect(breedingService.getBreedingById).toHaveBeenCalledWith('5', 1);
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 on BREEDING_NOT_FOUND', async () => {
      breedingService.getBreedingById.mockRejectedValue(new Error('BREEDING_NOT_FOUND'));
      const res = mockRes();
      await breedingController.getById(mockReq({ params: { id: '99' } }), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next on unexpected error', async () => {
      const err = new Error('DB error');
      breedingService.getBreedingById.mockRejectedValue(err);
      await breedingController.getById(mockReq({ params: { id: '1' } }), mockRes(), mockNext);
      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('list', () => {
    it('should return paginated breeding list', async () => {
      breedingService.listBreedings.mockResolvedValue({
        items: [{ id: 1 }],
        pagination: { page: 1, limit: 20, total: 1 }
      });
      const req = mockReq({ query: { page: '1', limit: '20' } });
      const res = mockRes();

      await breedingController.list(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true }));
    });

    it('should call next on error', async () => {
      const err = new Error('DB error');
      breedingService.listBreedings.mockRejectedValue(err);
      await breedingController.list(mockReq({ query: {} }), mockRes(), mockNext);
      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('update', () => {
    it('should update breeding and return 200', async () => {
      const updated = { id: 1, status: 'completed' };
      breedingService.updateBreeding.mockResolvedValue(updated);
      const req = mockReq({ params: { id: '1' }, body: { status: 'completed' } });
      const res = mockRes();

      await breedingController.update(req, res, mockNext);

      expect(breedingService.updateBreeding).toHaveBeenCalledWith('1', 1, { status: 'completed' });
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 on BREEDING_NOT_FOUND', async () => {
      breedingService.updateBreeding.mockRejectedValue(new Error('BREEDING_NOT_FOUND'));
      const res = mockRes();
      await breedingController.update(mockReq({ params: { id: '99' } }), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should return 400 on INVALID_MALE', async () => {
      breedingService.updateBreeding.mockRejectedValue(new Error('INVALID_MALE'));
      const res = mockRes();
      await breedingController.update(mockReq({ params: { id: '1' } }), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should return 400 on INVALID_FEMALE', async () => {
      breedingService.updateBreeding.mockRejectedValue(new Error('INVALID_FEMALE'));
      const res = mockRes();
      await breedingController.update(mockReq({ params: { id: '1' } }), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should call next on unexpected error', async () => {
      const err = new Error('DB error');
      breedingService.updateBreeding.mockRejectedValue(err);
      await breedingController.update(mockReq({ params: { id: '1' } }), mockRes(), mockNext);
      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('delete', () => {
    it('should delete breeding and return 200', async () => {
      breedingService.deleteBreeding.mockResolvedValue(true);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await breedingController.delete(req, res, mockNext);

      expect(breedingService.deleteBreeding).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 on BREEDING_NOT_FOUND', async () => {
      breedingService.deleteBreeding.mockRejectedValue(new Error('BREEDING_NOT_FOUND'));
      const res = mockRes();
      await breedingController.delete(mockReq({ params: { id: '99' } }), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should call next on unexpected error', async () => {
      const err = new Error('DB error');
      breedingService.deleteBreeding.mockRejectedValue(err);
      await breedingController.delete(mockReq({ params: { id: '1' } }), mockRes(), mockNext);
      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getStatistics', () => {
    it('should return statistics', async () => {
      const stats = { total: 10, successful: 7 };
      breedingService.getStatistics.mockResolvedValue(stats);
      const res = mockRes();

      await breedingController.getStatistics(mockReq(), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ data: stats }));
    });

    it('should call next on error', async () => {
      const err = new Error('DB error');
      breedingService.getStatistics.mockRejectedValue(err);
      await breedingController.getStatistics(mockReq(), mockRes(), mockNext);
      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });
});
