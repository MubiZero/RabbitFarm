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

describe('StaffService', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('createInvitation', () => {
    it('бросает STAFF_LIMIT_REACHED, не выписывая приглашение, если ферма упёрлась в лимит тарифа', async () => {
      planService.assertStaffLimit.mockRejectedValue(new Error('STAFF_LIMIT_REACHED'));

      await expect(staffService.createInvitation(1, 10, { email: 'a@x.com', role: 'worker' }))
        .rejects.toThrow('STAFF_LIMIT_REACHED');

      expect(planService.assertStaffLimit).toHaveBeenCalledWith(1);
      expect(Invitation.create).not.toHaveBeenCalled();
    });

    it('бросает USER_EXISTS, если email уже занят', async () => {
      planService.assertStaffLimit.mockResolvedValue(undefined);
      User.findOne.mockResolvedValue({ id: 5 });

      await expect(staffService.createInvitation(1, 10, { email: 'a@x.com', role: 'worker' }))
        .rejects.toThrow('USER_EXISTS');
    });

    it('создаёт приглашение, когда лимит не достигнут', async () => {
      planService.assertStaffLimit.mockResolvedValue(undefined);
      User.findOne.mockResolvedValue(null);
      Invitation.destroy.mockResolvedValue(0);
      Invitation.create.mockResolvedValue({ id: 1, email: 'a@x.com', role: 'worker' });

      const { invitation } = await staffService.createInvitation(1, 10, { email: 'a@x.com', role: 'worker' });

      expect(invitation.id).toBe(1);
      expect(Invitation.create).toHaveBeenCalledWith(expect.objectContaining({ farm_id: 1, email: 'a@x.com' }));
    });
  });

  describe('acceptInvitation', () => {
    const validInvitation = {
      id: 1,
      email: 'new@x.com',
      role: 'worker',
      farm_id: 7,
      expires_at: new Date(Date.now() + 86400000),
      update: jest.fn().mockResolvedValue(undefined)
    };

    it('бросает INVITATION_INVALID для несуществующего или просроченного кода', async () => {
      Invitation.findOne.mockResolvedValue(null);

      await expect(staffService.acceptInvitation('bad-token', { password: 'x', full_name: 'Имя' }))
        .rejects.toThrow('INVITATION_INVALID');
      expect(planService.assertStaffLimit).not.toHaveBeenCalled();
    });

    it('бросает STAFF_LIMIT_REACHED, если ферма упёрлась в лимит уже после выдачи приглашения', async () => {
      Invitation.findOne.mockResolvedValue(validInvitation);
      User.findOne.mockResolvedValue(null);
      planService.assertStaffLimit.mockRejectedValue(new Error('STAFF_LIMIT_REACHED'));

      await expect(staffService.acceptInvitation('good-token', { password: 'x', full_name: 'Имя' }))
        .rejects.toThrow('STAFF_LIMIT_REACHED');

      expect(planService.assertStaffLimit).toHaveBeenCalledWith(7);
      expect(User.create).not.toHaveBeenCalled();
    });

    it('создаёт работника, когда приглашение валидно и лимит не достигнут', async () => {
      Invitation.findOne.mockResolvedValue(validInvitation);
      User.findOne.mockResolvedValue(null);
      planService.assertStaffLimit.mockResolvedValue(undefined);
      User.create.mockResolvedValue({ id: 99, email: 'new@x.com' });

      const user = await staffService.acceptInvitation('good-token', { password: 'x', full_name: 'Имя' });

      expect(user.id).toBe(99);
      expect(validInvitation.update).toHaveBeenCalledWith(expect.objectContaining({ accepted_at: expect.any(Date) }));
    });
  });
});
