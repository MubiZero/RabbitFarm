jest.mock('../../../src/services/planService');
jest.mock('../../../src/services/platformAdminService');
jest.mock('../../../src/services/farmExportService');
jest.mock('../../../src/services/auditService');
jest.mock('../../../src/services/announcementService');

const planService = require('../../../src/services/planService');
const platformAdminService = require('../../../src/services/platformAdminService');
const farmExportService = require('../../../src/services/farmExportService');
const auditService = require('../../../src/services/auditService');
const announcementService = require('../../../src/services/announcementService');
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

  describe('getFarm', () => {
    it('возвращает ферму при успешном поиске', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, name: 'Ферма 1', last_active: null });
      const res = mockRes();

      await platformAdminController.getFarm(mockReq({ params: { id: 1 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: true,
        data: { id: 1, name: 'Ферма 1', last_active: null }
      }));
    });

    it('возвращает 404 при FARM_NOT_FOUND', async () => {
      platformAdminService.getFarm.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.getFarm(mockReq({ params: { id: 99 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
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

  describe('updateStatus', () => {
    it('возвращает 404 при FARM_NOT_FOUND', async () => {
      platformAdminService.getFarm.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.updateStatus(
        mockReq({ params: { id: 99 }, body: { status: 'suspended' } }),
        res,
        mockNext
      );

      expect(res.status).toHaveBeenCalledWith(404);
      expect(auditService.record).not.toHaveBeenCalled();
    });

    it('возвращает 200 и обновлённую ферму', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, status: 'active' });
      platformAdminService.updateStatus.mockResolvedValue({ id: 1, status: 'read_only' });
      const res = mockRes();

      await platformAdminController.updateStatus(
        mockReq({ params: { id: 1 }, body: { status: 'read_only' } }),
        res,
        mockNext
      );

      expect(platformAdminService.updateStatus).toHaveBeenCalledWith(1, 'read_only');
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: true,
        data: { id: 1, status: 'read_only' }
      }));
    });

    it('пишет в журнал старый и новый статус фермы', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, status: 'active' });
      platformAdminService.updateStatus.mockResolvedValue({ id: 1, status: 'suspended' });
      const res = mockRes();

      await platformAdminController.updateStatus(
        mockReq({ params: { id: 1 }, body: { status: 'suspended' } }),
        res,
        mockNext
      );

      expect(auditService.record).toHaveBeenCalledWith({
        adminId: 1,
        action: 'farm.status',
        farmId: 1,
        before: { status: 'active' },
        after: { status: 'suspended' },
        ip: '127.0.0.1'
      });
    });

    it('не пишет в журнал, если смена статуса не удалась', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, status: 'active' });
      platformAdminService.updateStatus.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.updateStatus(
        mockReq({ params: { id: 1 }, body: { status: 'suspended' } }),
        res,
        mockNext
      );

      expect(auditService.record).not.toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(404);
    });
  });

  describe('extendPlan', () => {
    it('возвращает 404 при FARM_NOT_FOUND', async () => {
      platformAdminService.getFarm.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.extendPlan(
        mockReq({ params: { id: 99 }, body: { plan_expires_at: '2026-11-01T00:00:00.000Z' } }),
        res,
        mockNext
      );

      expect(res.status).toHaveBeenCalledWith(404);
      expect(auditService.record).not.toHaveBeenCalled();
    });

    it('пишет в журнал старый и новый срок тарифа', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, plan_expires_at: '2026-10-01T00:00:00.000Z' });
      platformAdminService.extendPlan.mockResolvedValue({ id: 1, plan_expires_at: '2026-11-01T00:00:00.000Z' });
      const res = mockRes();

      await platformAdminController.extendPlan(
        mockReq({ params: { id: 1 }, body: { plan_expires_at: '2026-11-01T00:00:00.000Z' } }),
        res,
        mockNext
      );

      expect(platformAdminService.extendPlan).toHaveBeenCalledWith(1, '2026-11-01T00:00:00.000Z');
      expect(auditService.record).toHaveBeenCalledWith({
        adminId: 1,
        action: 'farm.extend_plan',
        farmId: 1,
        before: { plan_expires_at: '2026-10-01T00:00:00.000Z' },
        after: { plan_expires_at: '2026-11-01T00:00:00.000Z' },
        ip: '127.0.0.1'
      });
      expect(res.status).toHaveBeenCalledWith(200);
    });
  });

  describe('updateExtras', () => {
    it('возвращает 404 при FARM_NOT_FOUND', async () => {
      platformAdminService.getFarm.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.updateExtras(
        mockReq({ params: { id: 99 }, body: { extra_rabbits: 50 } }),
        res,
        mockNext
      );

      expect(res.status).toHaveBeenCalledWith(404);
      expect(auditService.record).not.toHaveBeenCalled();
    });

    it('возвращает 200 и ферму с записанной поблажкой', async () => {
      platformAdminService.getFarm.mockResolvedValue({
        id: 1, extra_rabbits: null, extra_staff: null, extras_until: null
      });
      platformAdminService.updateExtras.mockResolvedValue({
        id: 1, extra_rabbits: 50, extra_staff: null, extras_until: '2026-10-08T00:00:00.000Z'
      });
      const res = mockRes();

      await platformAdminController.updateExtras(
        mockReq({ params: { id: 1 }, body: { extra_rabbits: 50, extras_until: '2026-10-08T00:00:00.000Z' } }),
        res,
        mockNext
      );

      expect(platformAdminService.updateExtras).toHaveBeenCalledWith(1, {
        extra_rabbits: 50,
        extras_until: '2026-10-08T00:00:00.000Z'
      });
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('пишет в журнал прежнюю и новую поблажку', async () => {
      platformAdminService.getFarm.mockResolvedValue({
        id: 1, extra_rabbits: null, extra_staff: null, extras_until: null
      });
      platformAdminService.updateExtras.mockResolvedValue({
        id: 1, extra_rabbits: 50, extra_staff: 1, extras_until: '2026-10-08T00:00:00.000Z'
      });
      const res = mockRes();

      await platformAdminController.updateExtras(
        mockReq({ params: { id: 1 }, body: { extra_rabbits: 50, extra_staff: 1 } }),
        res,
        mockNext
      );

      expect(auditService.record).toHaveBeenCalledWith({
        adminId: 1,
        action: 'farm.extras',
        farmId: 1,
        before: { extra_rabbits: null, extra_staff: null, extras_until: null },
        after: { extra_rabbits: 50, extra_staff: 1, extras_until: '2026-10-08T00:00:00.000Z' },
        ip: '127.0.0.1'
      });
    });

    it('не пишет в журнал, если запись поблажки не удалась', async () => {
      platformAdminService.getFarm.mockResolvedValue({
        id: 1, extra_rabbits: null, extra_staff: null, extras_until: null
      });
      platformAdminService.updateExtras.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.updateExtras(
        mockReq({ params: { id: 1 }, body: { extra_rabbits: 50 } }),
        res,
        mockNext
      );

      expect(auditService.record).not.toHaveBeenCalled();
    });
  });

  describe('exportFarm', () => {
    it('возвращает 404 при FARM_NOT_FOUND', async () => {
      farmExportService.exportFarm.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.exportFarm(mockReq({ params: { id: 99 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(auditService.record).not.toHaveBeenCalled();
    });

    it('отдаёт слепок данных фермы', async () => {
      farmExportService.exportFarm.mockResolvedValue({ generated_at: 'now', farm: { id: 1 }, rabbits: [] });
      const res = mockRes();

      await platformAdminController.exportFarm(mockReq({ params: { id: 1 } }), res, mockNext);

      expect(farmExportService.exportFarm).toHaveBeenCalledWith(1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: true,
        data: expect.objectContaining({ farm: { id: 1 } })
      }));
    });

    it('пишет выгрузку в журнал — читающее действие, но отчётное', async () => {
      farmExportService.exportFarm.mockResolvedValue({ farm: { id: 1 } });
      const res = mockRes();

      await platformAdminController.exportFarm(mockReq({ params: { id: 1 } }), res, mockNext);

      expect(auditService.record).toHaveBeenCalledWith({
        adminId: 1,
        action: 'farm.export',
        farmId: 1,
        ip: '127.0.0.1'
      });
    });
  });

  describe('impersonateFarm', () => {
    it('возвращает 404 при FARM_NOT_FOUND и не пишет в журнал', async () => {
      platformAdminService.impersonate.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.impersonateFarm(
        mockReq({ params: { id: 99 }, body: { reason: 'проверка жалобы' } }),
        res,
        mockNext
      );

      expect(res.status).toHaveBeenCalledWith(404);
      expect(auditService.record).not.toHaveBeenCalled();
    });

    it('возвращает 400 с кодом FARM_NO_OWNER, если у фермы нет владельца', async () => {
      platformAdminService.impersonate.mockRejectedValue(new Error('FARM_NO_OWNER'));
      const res = mockRes();

      await platformAdminController.impersonateFarm(
        mockReq({ params: { id: 1 }, body: { reason: 'проверка жалобы' } }),
        res,
        mockNext
      );

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json.mock.calls[0][0].error.code).toBe('FARM_NO_OWNER');
    });

    it('выдаёт токен и пишет причину в журнал', async () => {
      platformAdminService.impersonate.mockResolvedValue({
        access_token: 'token123',
        farm: { id: 1, name: 'Ферма Иванова' },
        owner: { id: 42, full_name: 'Иван Иванов' }
      });
      const res = mockRes();

      await platformAdminController.impersonateFarm(
        mockReq({ params: { id: 1 }, body: { reason: 'проверка жалобы' } }),
        res,
        mockNext
      );

      expect(platformAdminService.impersonate).toHaveBeenCalledWith(1, 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(auditService.record).toHaveBeenCalledWith({
        adminId: 1,
        action: 'farm.impersonate',
        farmId: 1,
        after: { reason: 'проверка жалобы', owner_id: 42 },
        ip: '127.0.0.1'
      });
    });
  });

  describe('deleteFarm', () => {
    it('возвращает 404 при FARM_NOT_FOUND', async () => {
      platformAdminService.getFarm.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.deleteFarm(
        mockReq({ params: { id: 99 }, body: { confirm_name: 'Ферма' } }),
        res,
        mockNext
      );

      expect(res.status).toHaveBeenCalledWith(404);
      expect(auditService.record).not.toHaveBeenCalled();
    });

    it('возвращает 400 с кодом CONFIRM_NAME_MISMATCH, если название не совпало', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, deleted_at: null });
      platformAdminService.softDelete.mockRejectedValue(new Error('CONFIRM_NAME_MISMATCH'));
      const res = mockRes();

      await platformAdminController.deleteFarm(
        mockReq({ params: { id: 1 }, body: { confirm_name: 'не то название' } }),
        res,
        mockNext
      );

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json.mock.calls[0][0].error.code).toBe('CONFIRM_NAME_MISMATCH');
      expect(auditService.record).not.toHaveBeenCalled();
    });

    it('удаляет ферму и пишет в журнал прежний и новый deleted_at', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, deleted_at: null });
      platformAdminService.softDelete.mockResolvedValue({ id: 1, deleted_at: '2026-09-09T00:00:00.000Z' });
      const res = mockRes();

      await platformAdminController.deleteFarm(
        mockReq({ params: { id: 1 }, body: { confirm_name: 'Ферма Иванова' } }),
        res,
        mockNext
      );

      expect(platformAdminService.softDelete).toHaveBeenCalledWith(1, 'Ферма Иванова');
      expect(res.status).toHaveBeenCalledWith(200);
      expect(auditService.record).toHaveBeenCalledWith({
        adminId: 1,
        action: 'farm.delete',
        farmId: 1,
        before: { deleted_at: null },
        after: { deleted_at: '2026-09-09T00:00:00.000Z' },
        ip: '127.0.0.1'
      });
    });
  });

  describe('restoreFarm', () => {
    it('возвращает 404 при FARM_NOT_FOUND', async () => {
      platformAdminService.getFarm.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.restoreFarm(mockReq({ params: { id: 99 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(auditService.record).not.toHaveBeenCalled();
    });

    it('возвращает 400 с кодом FARM_NOT_DELETED, если ферма и не была удалена', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, deleted_at: null });
      platformAdminService.restore.mockRejectedValue(new Error('FARM_NOT_DELETED'));
      const res = mockRes();

      await platformAdminController.restoreFarm(mockReq({ params: { id: 1 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json.mock.calls[0][0].error.code).toBe('FARM_NOT_DELETED');
      expect(auditService.record).not.toHaveBeenCalled();
    });

    it('восстанавливает ферму и пишет в журнал', async () => {
      platformAdminService.getFarm.mockResolvedValue({ id: 1, deleted_at: '2026-09-09T00:00:00.000Z' });
      platformAdminService.restore.mockResolvedValue({ id: 1, deleted_at: null });
      const res = mockRes();

      await platformAdminController.restoreFarm(mockReq({ params: { id: 1 } }), res, mockNext);

      expect(platformAdminService.restore).toHaveBeenCalledWith(1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(auditService.record).toHaveBeenCalledWith({
        adminId: 1,
        action: 'farm.restore',
        farmId: 1,
        before: { deleted_at: '2026-09-09T00:00:00.000Z' },
        after: { deleted_at: null },
        ip: '127.0.0.1'
      });
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

  describe('createAnnouncement', () => {
    const announcementBody = {
      title: 'Плановые работы',
      body: 'В субботу сервис будет недоступен.',
      channels: ['push', 'email'],
      target_type: 'all'
    };
    const sentAnnouncement = {
      id: 4,
      target_type: 'all',
      farms_count: 3,
      recipients_count: 7,
      channels: ['push', 'email'],
      stats: { push: { sent: 5, failed: 1 }, email: { sent: 7, failed: 0 } }
    };

    it('возвращает 201 и статистику доставки', async () => {
      announcementService.create.mockResolvedValue(sentAnnouncement);
      const res = mockRes();

      await platformAdminController.createAnnouncement(mockReq({ body: announcementBody }), res, mockNext);

      expect(announcementService.create).toHaveBeenCalledWith({
        adminId: 1,
        title: announcementBody.title,
        body: announcementBody.body,
        channels: ['push', 'email'],
        targetType: 'all',
        targetFarmId: undefined,
        targetFilter: undefined
      });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: true,
        data: sentAnnouncement
      }));
    });

    it('передаёт сервису фильтр получателей', async () => {
      announcementService.create.mockResolvedValue({ ...sentAnnouncement, target_type: 'filter' });
      const res = mockRes();

      await platformAdminController.createAnnouncement(
        mockReq({ body: { ...announcementBody, target_type: 'filter', target_filter: 'no_plan' } }),
        res,
        mockNext
      );

      expect(announcementService.create).toHaveBeenCalledWith(expect.objectContaining({
        targetType: 'filter',
        targetFilter: 'no_plan'
      }));
    });

    it('возвращает 404 при FARM_NOT_FOUND', async () => {
      announcementService.create.mockRejectedValue(new Error('FARM_NOT_FOUND'));
      const res = mockRes();

      await platformAdminController.createAnnouncement(
        mockReq({ body: { ...announcementBody, target_type: 'farm', target_farm_id: 99 } }),
        res,
        mockNext
      );

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
      expect(auditService.record).not.toHaveBeenCalled();
    });

    it('возвращает 400 при NO_RECIPIENTS', async () => {
      announcementService.create.mockRejectedValue(new Error('NO_RECIPIENTS'));
      const res = mockRes();

      await platformAdminController.createAnnouncement(mockReq({ body: announcementBody }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
      expect(auditService.record).not.toHaveBeenCalled();
    });

    it('пишет в журнал отправленное объявление со статистикой', async () => {
      announcementService.create.mockResolvedValue(sentAnnouncement);
      const res = mockRes();

      await platformAdminController.createAnnouncement(mockReq({ body: announcementBody }), res, mockNext);

      expect(auditService.record).toHaveBeenCalledWith({
        adminId: 1,
        action: 'announcement.send',
        farmId: null,
        after: {
          id: 4,
          target_type: 'all',
          farms_count: 3,
          recipients_count: 7,
          channels: ['push', 'email'],
          stats: sentAnnouncement.stats
        },
        ip: '127.0.0.1'
      });
    });

    it('привязывает журнальную запись к ферме, если объявление адресное', async () => {
      announcementService.create.mockResolvedValue({
        ...sentAnnouncement, target_type: 'farm', farms_count: 1, recipients_count: 2
      });
      const res = mockRes();

      await platformAdminController.createAnnouncement(
        mockReq({ body: { ...announcementBody, target_type: 'farm', target_farm_id: 7 } }),
        res,
        mockNext
      );

      expect(auditService.record).toHaveBeenCalledWith(expect.objectContaining({
        action: 'announcement.send',
        farmId: 7
      }));
    });

    it('отдаёт неожидаемую ошибку в next и не пишет в журнал', async () => {
      announcementService.create.mockRejectedValue(new Error('DB down'));
      const res = mockRes();

      await platformAdminController.createAnnouncement(mockReq({ body: announcementBody }), res, mockNext);

      expect(mockNext).toHaveBeenCalled();
      expect(auditService.record).not.toHaveBeenCalled();
    });
  });

  describe('listAnnouncements', () => {
    it('отдаёт постраничную историю объявлений', async () => {
      announcementService.list.mockResolvedValue({
        items: [{ id: 1, title: 'Плановые работы' }],
        pagination: { page: 1, limit: 20, total: 1, totalPages: 1 }
      });
      const res = mockRes();

      await platformAdminController.listAnnouncements(mockReq(), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: true,
        data: expect.objectContaining({ items: [{ id: 1, title: 'Плановые работы' }] })
      }));
    });

    it('передаёт постраничные параметры из query', async () => {
      announcementService.list.mockResolvedValue({
        items: [],
        pagination: { page: 2, limit: 5, total: 0, totalPages: 0 }
      });
      const res = mockRes();

      await platformAdminController.listAnnouncements(
        mockReq({ query: { page: '2', limit: '5' } }),
        res,
        mockNext
      );

      expect(announcementService.list).toHaveBeenCalledWith({ page: '2', limit: '5' });
    });
  });
});
