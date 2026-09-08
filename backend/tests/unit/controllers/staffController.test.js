jest.mock('../../../src/services/staffService');
jest.mock('../../../src/services/authService');

const staffService = require('../../../src/services/staffService');
const authService = require('../../../src/services/authService');
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

describe('StaffController', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('createInvitation', () => {
    it('возвращает 400 при STAFF_LIMIT_REACHED', async () => {
      staffService.createInvitation.mockRejectedValue(new Error('STAFF_LIMIT_REACHED'));
      const res = mockRes();

      await staffController.createInvitation(mockReq({ body: { email: 'a@x.com', role: 'worker' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
      expect(res.json.mock.calls[0][0].error.code).toBe('STAFF_LIMIT_REACHED');
    });

    it('возвращает 409 при USER_EXISTS', async () => {
      staffService.createInvitation.mockRejectedValue(new Error('USER_EXISTS'));
      const res = mockRes();

      await staffController.createInvitation(mockReq({ body: { email: 'a@x.com', role: 'worker' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(409);
    });

    it('возвращает 201 с кодом приглашения при успехе', async () => {
      staffService.createInvitation.mockResolvedValue({
        invitation: { id: 1, email: 'a@x.com', role: 'worker', expires_at: '2026-01-01' },
        token: 'plain-code'
      });
      const res = mockRes();

      await staffController.createInvitation(mockReq({ body: { email: 'a@x.com', role: 'worker' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        data: expect.objectContaining({ code: 'plain-code' })
      }));
    });
  });

  describe('acceptInvitation', () => {
    it('возвращает 400 при STAFF_LIMIT_REACHED', async () => {
      staffService.acceptInvitation.mockRejectedValue(new Error('STAFF_LIMIT_REACHED'));
      const res = mockRes();

      await staffController.acceptInvitation(mockReq({ body: { code: 'x', password: 'pw' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(authService.issueTokens).not.toHaveBeenCalled();
      expect(res.json.mock.calls[0][0].error.code).toBe('STAFF_LIMIT_REACHED');
    });

    it('возвращает 400 при INVITATION_INVALID', async () => {
      staffService.acceptInvitation.mockRejectedValue(new Error('INVITATION_INVALID'));
      const res = mockRes();

      await staffController.acceptInvitation(mockReq({ body: { code: 'x', password: 'pw' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('выдаёт токены и возвращает 201 при успешной активации', async () => {
      const user = { toJSON: () => ({ id: 5, email: 'a@x.com' }) };
      staffService.acceptInvitation.mockResolvedValue(user);
      authService.issueTokens.mockResolvedValue({ accessToken: 'a', refreshToken: 'r' });
      const res = mockRes();

      await staffController.acceptInvitation(mockReq({ body: { code: 'x', password: 'pw' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(201);
      expect(authService.issueTokens).toHaveBeenCalledWith(user);
    });
  });
});
