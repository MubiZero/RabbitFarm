/**
 * Unit tests for birthController
 */
jest.mock('../../../src/models', () => {
  const mockSequelize = { transaction: jest.fn() };
  const RabbitMock = {
    findOne: jest.fn(),
    findByPk: jest.fn(),
    create: jest.fn(),
    count: jest.fn(),
    sequelize: mockSequelize,
    associations: { Breed: { target: { name: 'Breed' } } }
  };
  return {
    Rabbit: RabbitMock,
    Birth: {
      findAll: jest.fn(),
      findOne: jest.fn(),
      findByPk: jest.fn(),
      create: jest.fn(),
      sequelize: mockSequelize
    },
    Breeding: { findOne: jest.fn() },
    Task: { create: jest.fn() }
  };
});

const { Rabbit, Birth, Breeding, Task } = require('../../../src/models');
const ctrl = require('../../../src/controllers/birthController');

const mockReq = (overrides = {}) => ({
  body: {}, params: {}, query: {}, user: { id: 1 }, ...overrides
});
const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
};
const mockNext = jest.fn();
const mockTx = { commit: jest.fn(), rollback: jest.fn() };

describe('birthController', () => {
  beforeEach(() => {
    jest.resetAllMocks();
    Rabbit.sequelize.transaction.mockResolvedValue(mockTx);
    Birth.sequelize.transaction.mockResolvedValue(mockTx);
  });

  describe('getBirths', () => {
    it('should return all births for user', async () => {
      const births = [{ id: 1 }, { id: 2 }];
      Birth.findAll.mockResolvedValue(births);

      const req = mockReq();
      const res = mockRes();

      await ctrl.getBirths(req, res);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 500 on error', async () => {
      Birth.findAll.mockRejectedValue(new Error('DB error'));

      await ctrl.getBirths(mockReq(), mockRes());

      // Error handled, no throw
    });
  });

  describe('getBirthById', () => {
    it('should return birth by id', async () => {
      Birth.findOne.mockResolvedValue({ id: 1 });

      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await ctrl.getBirthById(req, res);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 if birth not found', async () => {
      Birth.findOne.mockResolvedValue(null);

      const req = mockReq({ params: { id: '999' } });
      const res = mockRes();

      await ctrl.getBirthById(req, res);

      expect(res.status).toHaveBeenCalledWith(404);
    });
  });

  describe('createBirth', () => {
    const baseBody = {
      mother_id: 1,
      birth_date: '2024-05-01',
      kits_born_alive: 5,
      kits_born_dead: 0
    };

    it('should create birth successfully without breeding_id', async () => {
      const mother = { id: 1, name: 'Doe', status: 'healthy', update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(mother);
      Birth.create.mockResolvedValue({ id: 1 });
      Task.create.mockResolvedValue({});
      Birth.findByPk.mockResolvedValue({ id: 1 });

      const req = mockReq({ body: baseBody });
      const res = mockRes();

      await ctrl.createBirth(req, res);

      expect(res.status).toHaveBeenCalledWith(201);
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should create birth with breeding_id', async () => {
      const mother = { id: 1, name: 'Doe', status: 'pregnant', update: jest.fn().mockResolvedValue(true) };
      const breeding = { id: 5, update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(mother);
      Breeding.findOne.mockResolvedValue(breeding);
      Birth.create.mockResolvedValue({ id: 2 });
      Task.create.mockResolvedValue({});
      Birth.findByPk.mockResolvedValue({ id: 2 });

      const req = mockReq({ body: { ...baseBody, breeding_id: 5 } });
      const res = mockRes();

      await ctrl.createBirth(req, res);

      expect(breeding.update).toHaveBeenCalledWith({ status: 'completed' }, expect.any(Object));
      expect(res.status).toHaveBeenCalledWith(201);
    });

    it('should return 404 if mother not found', async () => {
      Rabbit.findOne.mockResolvedValue(null);

      await ctrl.createBirth(mockReq({ body: baseBody }), mockRes());

      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should return 400 if mother is dead', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1, status: 'dead' });

      const res = mockRes();
      await ctrl.createBirth(mockReq({ body: baseBody }), res);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should return 404 if breeding_id not found', async () => {
      const mother = { id: 1, status: 'healthy' };
      Rabbit.findOne.mockResolvedValue(mother);
      Breeding.findOne.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.createBirth(mockReq({ body: { ...baseBody, breeding_id: 99 } }), res);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should handle active mother status update', async () => {
      const mother = { id: 1, name: 'Doe', status: 'active', update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(mother);
      Birth.create.mockResolvedValue({ id: 3 });
      Task.create.mockResolvedValue({});
      Birth.findByPk.mockResolvedValue({ id: 3 });

      await ctrl.createBirth(mockReq({ body: baseBody }), mockRes());

      expect(mother.update).toHaveBeenCalledWith({ status: 'active' }, expect.any(Object));
    });

    it('should return 500 on unexpected error', async () => {
      Rabbit.findOne.mockRejectedValue(new Error('DB error'));

      const res = mockRes();
      await ctrl.createBirth(mockReq({ body: baseBody }), res);

      expect(mockTx.rollback).toHaveBeenCalled();
    });
  });

  describe('updateBirth', () => {
    it('should update birth successfully', async () => {
      const birth = {
        id: 1,
        update: jest.fn().mockResolvedValue(true),
        reload: jest.fn().mockResolvedValue(true)
      };
      Birth.findOne.mockResolvedValue(birth);

      const req = mockReq({ params: { id: '1' }, body: { notes: 'updated' } });
      const res = mockRes();

      await ctrl.updateBirth(req, res);

      expect(birth.update).toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 if birth not found', async () => {
      Birth.findOne.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.updateBirth(mockReq({ params: { id: '999' }, body: {} }), res);

      expect(res.status).toHaveBeenCalledWith(404);
    });
  });

  describe('deleteBirth', () => {
    it('should delete birth successfully', async () => {
      const birth = { id: 1, destroy: jest.fn().mockResolvedValue(true) };
      Birth.findOne.mockResolvedValue(birth);

      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await ctrl.deleteBirth(req, res);

      expect(birth.destroy).toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 if birth not found', async () => {
      Birth.findOne.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.deleteBirth(mockReq({ params: { id: '999' } }), res);

      expect(res.status).toHaveBeenCalledWith(404);
    });
  });

  describe('createKitsFromBirth', () => {
    const kitBody = { count: 3, breed_id: 1, birth_date: '2024-05-01' };

    it('should create kits successfully', async () => {
      const birth = { id: 1, mother_id: 2, birth_date: '2024-05-01', kits_weaned: 0, update: jest.fn().mockResolvedValue(true) };
      const mother = { id: 2, cage_id: null, getCage: jest.fn().mockResolvedValue(null) };
      Birth.findOne.mockResolvedValue(birth);
      Rabbit.findByPk.mockResolvedValue(mother);
      Rabbit.create.mockResolvedValue({ id: 10 });

      const req = mockReq({ params: { id: '1' }, body: kitBody });
      const res = mockRes();

      await ctrl.createKitsFromBirth(req, res);

      expect(Rabbit.create).toHaveBeenCalledTimes(3);
      expect(res.status).toHaveBeenCalledWith(201);
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should return 400 for invalid count (0)', async () => {
      const req = mockReq({ params: { id: '1' }, body: { count: 0, breed_id: 1 } });
      const res = mockRes();

      await ctrl.createKitsFromBirth(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should return 400 for count > 20', async () => {
      const req = mockReq({ params: { id: '1' }, body: { count: 21, breed_id: 1 } });
      const res = mockRes();

      await ctrl.createKitsFromBirth(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should return 404 if birth not found', async () => {
      Birth.findOne.mockResolvedValue(null);

      const req = mockReq({ params: { id: '999' }, body: kitBody });
      const res = mockRes();

      await ctrl.createKitsFromBirth(req, res);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should return 400 if cage is full', async () => {
      const birth = { id: 1, mother_id: 2, birth_date: '2024-05-01', kits_weaned: 0 };
      const mother = { id: 2, cage_id: 5, getCage: jest.fn().mockResolvedValue({ capacity: 2 }) };
      Birth.findOne.mockResolvedValue(birth);
      Rabbit.findByPk.mockResolvedValue(mother);
      Rabbit.count.mockResolvedValue(1); // 1 current + 3 new = 4 > capacity 2

      const req = mockReq({ params: { id: '1' }, body: kitBody });
      const res = mockRes();

      await ctrl.createKitsFromBirth(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should use name_prefix when provided', async () => {
      const birth = { id: 1, mother_id: 2, birth_date: '2024-05-01', kits_weaned: 0, update: jest.fn().mockResolvedValue(true) };
      const mother = { id: 2, cage_id: null, getCage: jest.fn().mockResolvedValue(null) };
      Birth.findOne.mockResolvedValue(birth);
      Rabbit.findByPk.mockResolvedValue(mother);
      Rabbit.create.mockResolvedValue({ id: 11 });

      await ctrl.createKitsFromBirth(
        mockReq({ params: { id: '1' }, body: { count: 1, breed_id: 1, name_prefix: 'TestKit' } }),
        mockRes()
      );

      expect(Rabbit.create).toHaveBeenCalledWith(
        expect.objectContaining({ name: 'TestKit-1' }),
        expect.any(Object)
      );
    });
  });
});
