jest.mock('../../../src/services/authService');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn(),
  debug: jest.fn()
}));

const authService = require('../../../src/services/authService');
const authController = require('../../../src/controllers/authController');

const mockReq = (overrides = {}) => ({
  user: { id: 1 },
  params: {},
  body: {},
  query: {},
  headers: {},
  ...overrides
});

const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  res.send = jest.fn().mockReturnValue(res);
  return res;
};

const mockNext = jest.fn();

describe('AuthController', () => {
  beforeEach(() => jest.clearAllMocks());

  // ─── register ───────────────────────────────────────────────
  describe('register', () => {
    it('should register user and return 201', async () => {
      const result = { user: { id: 1, email: 'a@b.com' }, token: 'tok' };
      authService.register.mockResolvedValue(result);
      const req = mockReq({ body: { email: 'a@b.com', password: '123456' } });
      const res = mockRes();

      await authController.register(req, res, mockNext);

      expect(authService.register).toHaveBeenCalledWith(req.body);
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: result }));
    });

    it('should return 400 when USER_EXISTS error thrown', async () => {
      authService.register.mockRejectedValue(new Error('USER_EXISTS'));
      const req = mockReq({ body: { email: 'a@b.com' } });
      const res = mockRes();

      await authController.register(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when SequelizeUniqueConstraintError thrown', async () => {
      const err = new Error('Unique');
      err.name = 'SequelizeUniqueConstraintError';
      authService.register.mockRejectedValue(err);
      const req = mockReq({ body: { email: 'a@b.com' } });
      const res = mockRes();

      await authController.register(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      authService.register.mockRejectedValue(new Error('DB down'));
      const req = mockReq({ body: {} });
      const res = mockRes();

      await authController.register(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  // ─── login ──────────────────────────────────────────────────
  describe('login', () => {
    it('should login and return 200', async () => {
      const result = { token: 'tok', user: { id: 1 } };
      authService.login.mockResolvedValue(result);
      const req = mockReq({ body: { email: 'a@b.com', password: 'pass' } });
      const res = mockRes();

      await authController.login(req, res, mockNext);

      expect(authService.login).toHaveBeenCalledWith('a@b.com', 'pass');
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: result }));
    });

    it('should return 401 for INVALID_CREDENTIALS', async () => {
      authService.login.mockRejectedValue(new Error('INVALID_CREDENTIALS'));
      const req = mockReq({ body: { email: 'a@b.com', password: 'wrong' } });
      const res = mockRes();

      await authController.login(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(401);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 403 for USER_INACTIVE', async () => {
      authService.login.mockRejectedValue(new Error('USER_INACTIVE'));
      const req = mockReq({ body: { email: 'a@b.com', password: 'pass' } });
      const res = mockRes();

      await authController.login(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(403);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      authService.login.mockRejectedValue(new Error('Unknown'));
      const req = mockReq({ body: { email: 'a@b.com', password: 'pass' } });
      const res = mockRes();

      await authController.login(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  // ─── refresh ────────────────────────────────────────────────
  describe('refresh', () => {
    it('should refresh token and return 200', async () => {
      const result = { token: 'new_tok' };
      authService.refreshAccessToken.mockResolvedValue(result);
      const req = mockReq({ body: { refresh_token: 'rt' } });
      const res = mockRes();

      await authController.refresh(req, res, mockNext);

      expect(authService.refreshAccessToken).toHaveBeenCalledWith('rt');
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: result }));
    });

    it('should return 401 for INVALID_REFRESH_TOKEN', async () => {
      authService.refreshAccessToken.mockRejectedValue(new Error('INVALID_REFRESH_TOKEN'));
      const req = mockReq({ body: { refresh_token: 'bad' } });
      const res = mockRes();

      await authController.refresh(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(401);
    });

    it('should return 401 for REFRESH_TOKEN_EXPIRED', async () => {
      authService.refreshAccessToken.mockRejectedValue(new Error('REFRESH_TOKEN_EXPIRED'));
      const req = mockReq({ body: { refresh_token: 'old' } });
      const res = mockRes();

      await authController.refresh(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(401);
    });

    it('should return 403 for USER_INACTIVE', async () => {
      authService.refreshAccessToken.mockRejectedValue(new Error('USER_INACTIVE'));
      const req = mockReq({ body: { refresh_token: 'rt' } });
      const res = mockRes();

      await authController.refresh(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(403);
    });

    it('should call next for unexpected errors', async () => {
      authService.refreshAccessToken.mockRejectedValue(new Error('oops'));
      const req = mockReq({ body: { refresh_token: 'rt' } });
      const res = mockRes();

      await authController.refresh(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  // ─── logout ─────────────────────────────────────────────────
  describe('logout', () => {
    it('should logout and return 200', async () => {
      authService.logout.mockResolvedValue();
      const req = mockReq({
        body: { refresh_token: 'rt' },
        headers: { authorization: 'Bearer access_tok' }
      });
      const res = mockRes();

      await authController.logout(req, res, mockNext);

      expect(authService.logout).toHaveBeenCalledWith('rt', 'access_tok');
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: null }));
    });

    it('should pass null accessToken when no auth header', async () => {
      authService.logout.mockResolvedValue();
      const req = mockReq({ body: { refresh_token: 'rt' }, headers: {} });
      const res = mockRes();

      await authController.logout(req, res, mockNext);

      expect(authService.logout).toHaveBeenCalledWith('rt', null);
    });

    it('should call next for unexpected errors', async () => {
      authService.logout.mockRejectedValue(new Error('fail'));
      const req = mockReq({ body: { refresh_token: 'rt' }, headers: {} });
      const res = mockRes();

      await authController.logout(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  // ─── getMe ──────────────────────────────────────────────────
  describe('getMe', () => {
    it('should return current user profile', async () => {
      const user = { id: 1, email: 'a@b.com' };
      authService.getProfile.mockResolvedValue(user);
      const req = mockReq();
      const res = mockRes();

      await authController.getMe(req, res, mockNext);

      expect(authService.getProfile).toHaveBeenCalledWith(1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: user }));
    });

    it('should return 404 for USER_NOT_FOUND', async () => {
      authService.getProfile.mockRejectedValue(new Error('USER_NOT_FOUND'));
      const req = mockReq();
      const res = mockRes();

      await authController.getMe(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should call next for unexpected errors', async () => {
      authService.getProfile.mockRejectedValue(new Error('oops'));
      const req = mockReq();
      const res = mockRes();

      await authController.getMe(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  // ─── updateProfile ──────────────────────────────────────────
  describe('updateProfile', () => {
    it('should update profile and return 200', async () => {
      const user = { id: 1, name: 'New Name' };
      authService.updateProfile.mockResolvedValue(user);
      const req = mockReq({ body: { name: 'New Name' } });
      const res = mockRes();

      await authController.updateProfile(req, res, mockNext);

      expect(authService.updateProfile).toHaveBeenCalledWith(1, { name: 'New Name' });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: user }));
    });

    it('should return 404 for USER_NOT_FOUND', async () => {
      authService.updateProfile.mockRejectedValue(new Error('USER_NOT_FOUND'));
      const req = mockReq({ body: { name: 'X' } });
      const res = mockRes();

      await authController.updateProfile(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should call next for unexpected errors', async () => {
      authService.updateProfile.mockRejectedValue(new Error('oops'));
      const req = mockReq({ body: {} });
      const res = mockRes();

      await authController.updateProfile(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  // ─── forgotPassword ─────────────────────────────────────────
  describe('forgotPassword', () => {
    it('should always return 200 to prevent email enumeration', async () => {
      authService.forgotPassword.mockResolvedValue();
      const req = mockReq({ body: { email: 'a@b.com' } });
      const res = mockRes();

      await authController.forgotPassword(req, res, mockNext);

      expect(authService.forgotPassword).toHaveBeenCalledWith('a@b.com');
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should call next for unexpected errors', async () => {
      authService.forgotPassword.mockRejectedValue(new Error('mail fail'));
      const req = mockReq({ body: { email: 'a@b.com' } });
      const res = mockRes();

      await authController.forgotPassword(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  // ─── resetPassword ──────────────────────────────────────────
  describe('resetPassword', () => {
    it('should reset password and return 200', async () => {
      authService.resetPassword.mockResolvedValue();
      const req = mockReq({ body: { token: 'tok', new_password: 'newpass' } });
      const res = mockRes();

      await authController.resetPassword(req, res, mockNext);

      expect(authService.resetPassword).toHaveBeenCalledWith('tok', 'newpass');
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 400 for INVALID_RESET_TOKEN', async () => {
      authService.resetPassword.mockRejectedValue(new Error('INVALID_RESET_TOKEN'));
      const req = mockReq({ body: { token: 'bad', new_password: 'x' } });
      const res = mockRes();

      await authController.resetPassword(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should return 400 for RESET_TOKEN_EXPIRED', async () => {
      authService.resetPassword.mockRejectedValue(new Error('RESET_TOKEN_EXPIRED'));
      const req = mockReq({ body: { token: 'old', new_password: 'x' } });
      const res = mockRes();

      await authController.resetPassword(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should return 403 for USER_INACTIVE', async () => {
      authService.resetPassword.mockRejectedValue(new Error('USER_INACTIVE'));
      const req = mockReq({ body: { token: 't', new_password: 'x' } });
      const res = mockRes();

      await authController.resetPassword(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(403);
    });

    it('should call next for unexpected errors', async () => {
      authService.resetPassword.mockRejectedValue(new Error('oops'));
      const req = mockReq({ body: { token: 't', new_password: 'x' } });
      const res = mockRes();

      await authController.resetPassword(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  // ─── changePassword ─────────────────────────────────────────
  describe('changePassword', () => {
    it('should change password and return 200', async () => {
      authService.changePassword.mockResolvedValue();
      const req = mockReq({ body: { current_password: 'old', new_password: 'new' } });
      const res = mockRes();

      await authController.changePassword(req, res, mockNext);

      expect(authService.changePassword).toHaveBeenCalledWith(1, 'old', 'new');
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 for USER_NOT_FOUND', async () => {
      authService.changePassword.mockRejectedValue(new Error('USER_NOT_FOUND'));
      const req = mockReq({ body: { current_password: 'old', new_password: 'new' } });
      const res = mockRes();

      await authController.changePassword(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should return 400 for INVALID_CURRENT_PASSWORD', async () => {
      authService.changePassword.mockRejectedValue(new Error('INVALID_CURRENT_PASSWORD'));
      const req = mockReq({ body: { current_password: 'wrong', new_password: 'new' } });
      const res = mockRes();

      await authController.changePassword(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should call next for unexpected errors', async () => {
      authService.changePassword.mockRejectedValue(new Error('oops'));
      const req = mockReq({ body: { current_password: 'o', new_password: 'n' } });
      const res = mockRes();

      await authController.changePassword(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });
});
