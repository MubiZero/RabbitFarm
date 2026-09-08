jest.mock('../../../src/services/planService');
jest.mock('../../../src/services/platformAdminService');

const planService = require('../../../src/services/planService');
const platformAdminService = require('../../../src/services/platformAdminService');
const platformAdminController = require('../../../src/controllers/platformAdminController');

const mockReq = (overrides = {}) => ({
  params: {}, body: {}, query: {}, ...overrides
});
const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
};
const mockNext = jest.fn();

describe('PlatformAdminController', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('createPlan', () => {
    it('возвращает 409 при PLAN_NAME_EXISTS', async () => {
      planService.create.mockRejectedValue(new Error('PLAN_NAME_EXISTS'));
      const res = mockRes();

      await platformAdminController.createPlan(mockReq({ body: { name: 'Pro' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(409);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('возвращает 201 при успешном создании', async () => {
      planService.create.mockResolvedValue({ id: 1, name: 'Pro' });
      const res = mockRes();

      await platformAdminController.createPlan(mockReq({ body: { name: 'Pro' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(201);
    });
  });

  describe('updatePlan', () => {
    it('возвращает 404 при PLAN_NOT_FOUND', async () => {
      planService.update.mockRejectedValue(new Error('PLAN_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.updatePlan(mockReq({ params: { id: 99 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });
  });

  describe('deletePlan', () => {
    it('возвращает 404 при PLAN_NOT_FOUND', async () => {
      planService.delete.mockRejectedValue(new Error('PLAN_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.deletePlan(mockReq({ params: { id: 99 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('возвращает 200 при успешном удалении', async () => {
      planService.delete.mockResolvedValue({ success: true });
      const res = mockRes();

      await platformAdminController.deletePlan(mockReq({ params: { id: 1 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });
  });

  describe('listFarms', () => {
    it('отдаёт постраничный список', async () => {
      platformAdminService.listFarms.mockResolvedValue({
        items: [{ id: 1 }],
        pagination: { page: 1, limit: 20, total: 1, totalPages: 1 }
      });
      const res = mockRes();

      await platformAdminController.listFarms(mockReq(), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: true,
        data: expect.objectContaining({ items: [{ id: 1 }] })
      }));
    });
  });

  describe('assignPlan', () => {
    it('возвращает 404 при FARM_NOT_FOUND', async () => {
      platformAdminService.assignPlan.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.assignPlan(mockReq({ params: { id: 99 }, body: { plan_id: 1 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('возвращает 400 при попытке назначить выключенный тариф', async () => {
      platformAdminService.assignPlan.mockRejectedValue(new Error('PLAN_INACTIVE'));
      const res = mockRes();

      await platformAdminController.assignPlan(mockReq({ params: { id: 1 }, body: { plan_id: 2 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('возвращает 200 при успешном назначении', async () => {
      platformAdminService.assignPlan.mockResolvedValue({ id: 1, plan_id: 2 });
      const res = mockRes();

      await platformAdminController.assignPlan(mockReq({ params: { id: 1 }, body: { plan_id: 2 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });
  });
});
