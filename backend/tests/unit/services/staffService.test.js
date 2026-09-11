jest.mock('../../../src/models', () => ({
  User: {
    findOne: jest.fn(),
    findAll: jest.fn(),
    create: jest.fn()
  },
  Farm: {
    update: jest.fn()
  },
  Invitation: {
    findOne: jest.fn(),
    destroy: jest.fn(),
    create: jest.fn()
  },
  RefreshToken: {
    destroy: jest.fn()
  }
}));
jest.mock('../../../src/services/planService');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { User, Invitation } = require('../../../src/models');
const planService = require('../../../src/services/planService');
const staffService = require('../../../src/services/staffService');

// Имя приглашённого обязательно: активация идёт кодом на экране входа, сам
// человек себя нигде не представляет.
const inviteData = (overrides = {}) => ({
  email: 'a@x.com', role: 'worker', full_name: 'Пётр Иванов', ...overrides
});

describe('StaffService', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('createInvitation', () => {
    it('бросает STAFF_LIMIT_REACHED, не выписывая приглашение, если ферма упёрлась в лимит тарифа', async () => {
      planService.assertStaffLimit.mockRejectedValue(new Error('STAFF_LIMIT_REACHED'));

      await expect(staffService.createInvitation(1, 10, inviteData()))
        .rejects.toThrow('STAFF_LIMIT_REACHED');

      expect(planService.assertStaffLimit).toHaveBeenCalledWith(1);
      expect(Invitation.create).not.toHaveBeenCalled();
    });

    it('бросает USER_EXISTS, если email уже занят', async () => {
      planService.assertStaffLimit.mockResolvedValue(undefined);
      User.findOne.mockResolvedValue({ id: 5 });

      await expect(staffService.createInvitation(1, 10, inviteData()))
        .rejects.toThrow('USER_EXISTS');
    });

    it('создаёт приглашение с именем приглашённого, когда лимит не достигнут', async () => {
      planService.assertStaffLimit.mockResolvedValue(undefined);
      User.findOne.mockResolvedValue(null);
      Invitation.destroy.mockResolvedValue(0);
      Invitation.create.mockResolvedValue({ id: 1, email: 'a@x.com', role: 'worker' });

      const { invitation } = await staffService.createInvitation(1, 10, inviteData({ full_name: '  Пётр Иванов  ' }));

      expect(invitation.id).toBe(1);
      expect(Invitation.create).toHaveBeenCalledWith(expect.objectContaining({
        farm_id: 1,
        email: 'a@x.com',
        full_name: 'Пётр Иванов'
      }));
    });
  });
});
