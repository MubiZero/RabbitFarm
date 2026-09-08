jest.mock('../../../src/services/planService');
jest.mock('../../../src/services/platformAdminService');
jest.mock('../../../src/services/auditService');

const planService = require('../../../src/services/planService');
const platformAdminService = require('../../../src/services/platformAdminService');
const auditService = require('../../../src/services/auditService');
const platformAdminController = require('../../../src/controllers/platformAdminController');

const mockReq = (overrides = {}) => ({
  params: {}, body: {}, query: {}, user: { id: 1 }, ip: '127.0.0.1', ...overrides
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

    it('пишет в журнал после успешного создания', async () => {
      planService.create.mockResolvedValue({ id: 1, name: 'Pro' });
      const res = mockRes();

      await platformAdminController.createPlan(mockReq({ body: { name: 'Pro' } }), res, mockNext);

      expect(auditService.record).toHaveBeenCalledWith(expect.objectContaining({
        adminId: 1,
        action: 'plan.create',
        after: { id: 1, name: 'Pro' },
        ip: '127.0.0.1'
      }));
    });

    it('не пишет в журнал, если создание не удалось', async () => {
      planService.create.mockRejectedValue(new Error('PLAN_NAME_EXISTS'));
      const res = mockRes();

      await platformAdminController.createPlan(mockReq({ body: { name: 'Pro' } }), res, mockNext);

      expect(auditService.record).not.toHaveBeenCalled();
    });
  });

  describe('updatePlan', () => {
    it('возвращает 404 при PLAN_NOT_FOUND', async () => {
      planService.update.mockRejectedValue(new Error('PLAN_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.updatePlan(mockReq({ params: { id: 99 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('пишет в журнал старое и новое значение тарифа', async () => {
      planService.getById.mockResolvedValue({ id: 1, name: 'Pro', price: 10 });
      planService.update.mockResolvedValue({ id: 1, name: 'Pro', price: 20 });
      const res = mockRes();

      await platformAdminController.updatePlan(
        mockReq({ params: { id: 1 }, body: { price: 20 } }),
        res,
        mockNext
      );

      expect(auditService.record).toHaveBeenCalledWith(expect.objectContaining({
        adminId: 1,
        action: 'plan.update',
        before: { id: 1, name: 'Pro', price: 10 },
        after: { id: 1, name: 'Pro', price: 20 },
        ip: '127.0.0.1'
      }));
    });
  });

  describe('deletePlan', () => {
    it('возвращает 404 при PLAN_NOT_FOUND', async () => {
      planService.getById.mockRejectedValue(new Error('PLAN_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.deletePlan(mockReq({ params: { id: 99 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('возвращает 200 при успешном удалении', async () => {
      planService.getById.mockResolvedValue({ id: 1, name: 'Pro' });
      planService.delete.mockResolvedValue({ success: true });
      const res = mockRes();

      await platformAdminController.deletePlan(mockReq({ params: { id: 1 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('пишет в журнал удалённый тариф', async () => {
      planService.getById.mockResolvedValue({ id: 1, name: 'Pro' });
      planService.delete.mockResolvedValue({ success: true });
      const res = mockRes();

      await platformAdminController.deletePlan(mockReq({ params: { id: 1 } }), res, mockNext);

      expect(auditService.record).toHaveBeenCalledWith(expect.objectContaining({
        adminId: 1,
        action: 'plan.delete',
        before: { id: 1, name: 'Pro' },
        ip: '127.0.0.1'
      }));
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
      platformAdminService.getFarm.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.assignPlan(mockReq({ params: { id: 99 }, body: { plan_id: 1 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('возвращает 400 при попытке назначить выключенный тариф', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, plan_id: null });
      platformAdminService.assignPlan.mockRejectedValue(new Error('PLAN_INACTIVE'));
      const res = mockRes();

      await platformAdminController.assignPlan(mockReq({ params: { id: 1 }, body: { plan_id: 2 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('возвращает 200 при успешном назначении', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, plan_id: null });
      platformAdminService.assignPlan.mockResolvedValue({ id: 1, plan_id: 2 });
      const res = mockRes();

      await platformAdminController.assignPlan(mockReq({ params: { id: 1 }, body: { plan_id: 2 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('пишет в журнал старый и новый тариф фермы', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, plan_id: null });
      platformAdminService.assignPlan.mockResolvedValue({ id: 1, plan_id: 2 });
      const res = mockRes();

      await platformAdminController.assignPlan(mockReq({ params: { id: 1 }, body: { plan_id: 2 } }), res, mockNext);

      expect(auditService.record).toHaveBeenCalledWith({
        adminId: 1,
        action: 'plan.assign',
        farmId: 1,
        before: { plan_id: null },
        after: { plan_id: 2 },
        ip: '127.0.0.1'
      });
    });

    it('не пишет в журнал, если назначение не удалось', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, plan_id: null });
      platformAdminService.assignPlan.mockRejectedValue(new Error('PLAN_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.assignPlan(mockReq({ params: { id: 1 }, body: { plan_id: 999 } }), res, mockNext);

      expect(auditService.record).not.toHaveBeenCalled();
    });
  });

  describe('listAudit', () => {
    it('отдаёт постраничный журнал', async () => {
      auditService.list.mockResolvedValue({
        items: [{ id: 1, action: 'plan.assign' }],
        pagination: { page: 1, limit: 20, total: 1, totalPages: 1 }
      });
      const res = mockRes();

      await platformAdminController.listAudit(mockReq(), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: true,
        data: expect.objectContaining({ items: [{ id: 1, action: 'plan.assign' }] })
      }));
    });

    it('передаёт фильтр по farm_id из query', async () => {
      auditService.list.mockResolvedValue({
        items: [],
        pagination: { page: 1, limit: 20, total: 0, totalPages: 0 }
      });
      const res = mockRes();

      await platformAdminController.listAudit(mockReq({ query: { farm_id: '7' } }), res, mockNext);

      expect(auditService.list).toHaveBeenCalledWith(expect.objectContaining({ farmId: '7' }));
    });
  });
});
