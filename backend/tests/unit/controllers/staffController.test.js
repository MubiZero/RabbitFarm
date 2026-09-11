jest.mock('../../../src/services/staffService');

const staffService = require('../../../src/services/staffService');
const staffController = require('../../../src/controllers/staffController');

const mockReq = (overrides = {}) => ({
  user: { id: 1 }, farmId: 1, params: {}, body: {}, query: {}, ...overrides
});
const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
};
const mockNext = jest.fn();

// Имя приглашённого называет владелец: активация идёт кодом на экране входа,
// формы, где человек представился бы сам, больше нет.
const inviteBody = (overrides = {}) => ({
  email: 'a@x.com', role: 'worker', full_name: 'Пётр Иванов', ...overrides
});

describe('StaffController', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('createInvitation', () => {
    it('возвращает 400 при STAFF_LIMIT_REACHED', async () => {
      staffService.createInvitation.mockRejectedValue(new Error('STAFF_LIMIT_REACHED'));
      const res = mockRes();

      await staffController.createInvitation(mockReq({ body: inviteBody() }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
      expect(res.json.mock.calls[0][0].error.code).toBe('STAFF_LIMIT_REACHED');
    });

    it('возвращает 409 при USER_EXISTS', async () => {
      staffService.createInvitation.mockRejectedValue(new Error('USER_EXISTS'));
      const res = mockRes();

      await staffController.createInvitation(mockReq({ body: inviteBody() }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(409);
    });

    it('возвращает 201 и не показывает никакого кода — его больше нет',
      async () => {
      staffService.createInvitation.mockResolvedValue({
        invitation: {
          id: 1,
          email: 'a@x.com',
          full_name: 'Пётр',
          role: 'worker',
          expires_at: '2026-01-01'
        }
      });
      const res = mockRes();
      const req = mockReq({ body: inviteBody() });

      await staffController.createInvitation(req, res, mockNext);

      expect(staffService.createInvitation).toHaveBeenCalledWith(1, 1, req.body);
      expect(res.status).toHaveBeenCalledWith(201);
      const payload = res.json.mock.calls[0][0];
      expect(payload.data).toEqual({
        id: 1,
        email: 'a@x.com',
        phone: undefined,
        full_name: 'Пётр',
        role: 'worker',
        expires_at: '2026-01-01',
        invite_link: null
      });
      // Диктовать работнику нечего: он войдёт кодом на свой же контакт.
      expect(payload.message).toContain('код придёт письмом');
    });
  });
});
