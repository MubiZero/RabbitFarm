jest.mock('../../../src/models', () => ({
  AdminAuditLog: {
    create: jest.fn(),
    findAndCountAll: jest.fn()
  }
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { AdminAuditLog } = require('../../../src/models');
const logger = require('../../../src/utils/logger');
const auditService = require('../../../src/services/auditService');

describe('AuditService', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('record', () => {
    it('пишет строку журнала с переданными полями', async () => {
      AdminAuditLog.create.mockResolvedValue({ id: 1 });

      await auditService.record({
        adminId: 5,
        action: 'plan.assign',
        farmId: 3,
        before: { plan_id: null },
        after: { plan_id: 2 },
        ip: '127.0.0.1'
      });

      expect(AdminAuditLog.create).toHaveBeenCalledWith({
        admin_id: 5,
        action: 'plan.assign',
        farm_id: 3,
        before: { plan_id: null },
        after: { plan_id: 2 },
        ip: '127.0.0.1'
      });
    });

    it('подставляет значения по умолчанию для необязательных полей', async () => {
      AdminAuditLog.create.mockResolvedValue({ id: 1 });

      await auditService.record({ adminId: 5, action: 'plan.create' });

      expect(AdminAuditLog.create).toHaveBeenCalledWith({
        admin_id: 5,
        action: 'plan.create',
        farm_id: null,
        before: null,
        after: null,
        ip: null
      });
    });

    it('не бросает исключение, если запись в журнал не удалась', async () => {
      AdminAuditLog.create.mockRejectedValue(new Error('DB down'));

      await expect(
        auditService.record({ adminId: 5, action: 'plan.create' })
      ).resolves.toBeUndefined();

      expect(logger.error).toHaveBeenCalled();
    });
  });

  describe('list', () => {
    it('отдаёт постраничный список, свежие сверху', async () => {
      AdminAuditLog.findAndCountAll.mockResolvedValue({
        count: 2,
        rows: [{ id: 2 }, { id: 1 }]
      });

      const result = await auditService.list({ page: 1, limit: 20 });

      expect(AdminAuditLog.findAndCountAll).toHaveBeenCalledWith(
        expect.objectContaining({
          where: {},
          order: [['created_at', 'DESC']],
          limit: 20,
          offset: 0
        })
      );
      expect(result.items).toEqual([{ id: 2 }, { id: 1 }]);
      expect(result.pagination).toEqual({ page: 1, limit: 20, total: 2, totalPages: 1 });
    });

    it('фильтрует по farm_id, если он передан', async () => {
      AdminAuditLog.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      await auditService.list({ farmId: 7 });

      expect(AdminAuditLog.findAndCountAll).toHaveBeenCalledWith(
        expect.objectContaining({ where: { farm_id: 7 } })
      );
    });

    it('не фильтрует по ферме, если farmId не передан', async () => {
      AdminAuditLog.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      await auditService.list();

      expect(AdminAuditLog.findAndCountAll).toHaveBeenCalledWith(
        expect.objectContaining({ where: {} })
      );
    });
  });
});
