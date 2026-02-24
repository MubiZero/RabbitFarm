jest.mock('../../../src/services/breedService');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const breedService = require('../../../src/services/breedService');
const breedController = require('../../../src/controllers/breedController');

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

describe('BreedController', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('list', () => {
    it('should return all breeds', async () => {
      const breeds = [{ id: 1, name: 'Белый великан' }, { id: 2, name: 'Шиншилла' }];
      breedService.getAllBreeds.mockResolvedValue(breeds);
      const res = mockRes();

      await breedController.list(mockReq(), res, mockNext);

      expect(breedService.getAllBreeds).toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: breeds }));
    });

    it('should call next on error', async () => {
      const err = new Error('DB error');
      breedService.getAllBreeds.mockRejectedValue(err);
      await breedController.list(mockReq(), mockRes(), mockNext);
      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getById', () => {
    it('should return breed by id', async () => {
      const breed = { id: 3, name: 'Рекс' };
      breedService.getBreedById.mockResolvedValue(breed);
      const req = mockReq({ params: { id: '3' } });
      const res = mockRes();

      await breedController.getById(req, res, mockNext);

      expect(breedService.getBreedById).toHaveBeenCalledWith('3');
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 on BREED_NOT_FOUND', async () => {
      breedService.getBreedById.mockRejectedValue(new Error('BREED_NOT_FOUND'));
      const res = mockRes();
      await breedController.getById(mockReq({ params: { id: '99' } }), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next on unexpected error', async () => {
      const err = new Error('DB error');
      breedService.getBreedById.mockRejectedValue(err);
      await breedController.getById(mockReq({ params: { id: '1' } }), mockRes(), mockNext);
      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('create', () => {
    it('should create breed and return 201', async () => {
      const breed = { id: 4, name: 'Калифорниец' };
      breedService.createBreed.mockResolvedValue(breed);
      const req = mockReq({ body: { name: 'Калифорниец' } });
      const res = mockRes();

      await breedController.create(req, res, mockNext);

      expect(breedService.createBreed).toHaveBeenCalledWith({ name: 'Калифорниец' });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: breed }));
    });

    it('should return 400 on BREED_NAME_EXISTS', async () => {
      breedService.createBreed.mockRejectedValue(new Error('BREED_NAME_EXISTS'));
      const res = mockRes();
      await breedController.create(mockReq({ body: { name: 'Дубликат' } }), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next on unexpected error', async () => {
      const err = new Error('DB error');
      breedService.createBreed.mockRejectedValue(err);
      await breedController.create(mockReq({ body: {} }), mockRes(), mockNext);
      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('update', () => {
    it('should update breed and return 200', async () => {
      const updated = { id: 1, name: 'Обновлённый' };
      breedService.updateBreed.mockResolvedValue(updated);
      const req = mockReq({ params: { id: '1' }, body: { name: 'Обновлённый' } });
      const res = mockRes();

      await breedController.update(req, res, mockNext);

      expect(breedService.updateBreed).toHaveBeenCalledWith('1', { name: 'Обновлённый' });
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 on BREED_NOT_FOUND', async () => {
      breedService.updateBreed.mockRejectedValue(new Error('BREED_NOT_FOUND'));
      const res = mockRes();
      await breedController.update(mockReq({ params: { id: '99' } }), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should return 400 on BREED_NAME_EXISTS', async () => {
      breedService.updateBreed.mockRejectedValue(new Error('BREED_NAME_EXISTS'));
      const res = mockRes();
      await breedController.update(mockReq({ params: { id: '1' } }), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should call next on unexpected error', async () => {
      const err = new Error('DB error');
      breedService.updateBreed.mockRejectedValue(err);
      await breedController.update(mockReq({ params: { id: '1' } }), mockRes(), mockNext);
      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('delete', () => {
    it('should delete breed and return 200', async () => {
      breedService.deleteBreed.mockResolvedValue(true);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await breedController.delete(req, res, mockNext);

      expect(breedService.deleteBreed).toHaveBeenCalledWith('1');
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 on BREED_NOT_FOUND', async () => {
      breedService.deleteBreed.mockRejectedValue(new Error('BREED_NOT_FOUND'));
      const res = mockRes();
      await breedController.delete(mockReq({ params: { id: '99' } }), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should return 400 on BREED_HAS_RABBITS', async () => {
      breedService.deleteBreed.mockRejectedValue(new Error('BREED_HAS_RABBITS'));
      const res = mockRes();
      await breedController.delete(mockReq({ params: { id: '1' } }), res, mockNext);
      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should call next on unexpected error', async () => {
      const err = new Error('DB error');
      breedService.deleteBreed.mockRejectedValue(err);
      await breedController.delete(mockReq({ params: { id: '1' } }), mockRes(), mockNext);
      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });
});
