jest.mock('../../../src/services/authService');
jest.mock('../../../src/services/otpAuthService');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn(),
  debug: jest.fn()
}));

const authService = require('../../../src/services/authService');
const otpAuthService = require('../../../src/services/otpAuthService');
const authController = require('../../../src/controllers/authController');

const mockReq = (overrides = {}) => ({
  user: { id: 1 },
  farmId: 1,
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
    it('заводит ферму по телефону и возвращает 201 с обещанием кода в SMS', async () => {
      const result = { user_id: 1, farm_id: 7, channel: 'phone' };
      authService.register.mockResolvedValue(result);
      const req = mockReq({ body: { phone: '+992901234567', full_name: 'Иван Петров' } });
      const res = mockRes();

      await authController.register(req, res, mockNext);

      expect(authService.register).toHaveBeenCalledWith(req.body);
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: result }));
      expect(res.json.mock.calls[0][0].message).toBe('Ферма создана. Код для входа отправлен по SMS.');
    });

    it('заводит ферму по почте и обещает код письмом', async () => {
      authService.register.mockResolvedValue({ user_id: 2, farm_id: 8, channel: 'email' });
      const req = mockReq({ body: { email: 'a@b.com', full_name: 'Иван Петров' } });
      const res = mockRes();

      await authController.register(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json.mock.calls[0][0].message).toBe('Ферма создана. Код для входа отправлен на почту.');
    });

    it('не отдаёт токенов: сессию открывает только код', async () => {
      authService.register.mockResolvedValue({ user_id: 1, farm_id: 7, channel: 'phone' });
      const req = mockReq({ body: { phone: '+992901234567', full_name: 'Иван Петров' } });
      const res = mockRes();

      await authController.register(req, res, mockNext);

      const { data } = res.json.mock.calls[0][0];
      expect(Object.keys(data)).toEqual(['user_id', 'farm_id', 'channel']);
      expect(data).not.toHaveProperty('token');
      expect(data).not.toHaveProperty('access_token');
      expect(data).not.toHaveProperty('refresh_token');
    });

    it('возвращает 403 при закрытой регистрации', async () => {
      authService.register.mockRejectedValue(new Error('REGISTRATION_CLOSED'));
      const req = mockReq({ body: { email: 'a@b.com', full_name: 'Иван' } });
      const res = mockRes();

      await authController.register(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(403);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('возвращает 409 при USER_EXISTS', async () => {
      authService.register.mockRejectedValue(new Error('USER_EXISTS'));
      const req = mockReq({ body: { email: 'a@b.com', full_name: 'Иван' } });
      const res = mockRes();

      await authController.register(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(409);
      expect(res.json.mock.calls[0][0].error.code).toBe('USER_EXISTS');
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('возвращает 409 при занятом телефоне', async () => {
      authService.register.mockRejectedValue(new Error('PHONE_EXISTS'));
      const req = mockReq({ body: { phone: '+992901234567', full_name: 'Иван' } });
      const res = mockRes();

      await authController.register(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(409);
      expect(res.json.mock.calls[0][0].error.code).toBe('PHONE_EXISTS');
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('возвращает 409 при SequelizeUniqueConstraintError', async () => {
      const err = new Error('Unique');
      err.name = 'SequelizeUniqueConstraintError';
      authService.register.mockRejectedValue(err);
      const req = mockReq({ body: { email: 'a@b.com', full_name: 'Иван' } });
      const res = mockRes();

      await authController.register(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(409);
      expect(res.json.mock.calls[0][0].error.code).toBe('USER_EXISTS');
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('передаёт неожиданные ошибки в next', async () => {
      authService.register.mockRejectedValue(new Error('DB down'));
      const req = mockReq({ body: {} });
      const res = mockRes();

      await authController.register(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  // ─── requestOtp ─────────────────────────────────────────────
  describe('requestOtp', () => {
    it('передаёт телефон сервису контактом-объектом', async () => {
      otpAuthService.requestOtp.mockResolvedValue(undefined);
      const req = mockReq({ body: { phone: '+992901234567' } });
      const res = mockRes();

      await authController.requestOtp(req, res, mockNext);

      expect(otpAuthService.requestOtp).toHaveBeenCalledWith({ phone: '+992901234567', email: undefined });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json.mock.calls[0][0].message).toBe('Если контакт известен, код отправлен');
    });

    it('передаёт почту сервису контактом-объектом', async () => {
      otpAuthService.requestOtp.mockResolvedValue(undefined);
      const req = mockReq({ body: { email: 'a@b.com' } });
      const res = mockRes();

      await authController.requestOtp(req, res, mockNext);

      expect(otpAuthService.requestOtp).toHaveBeenCalledWith({ phone: undefined, email: 'a@b.com' });
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('отвечает 200 и для неизвестного контакта — по ответу нельзя найти чужой аккаунт', async () => {
      otpAuthService.requestOtp.mockResolvedValue(undefined);
      const req = mockReq({ body: { phone: '+992900000000' } });
      const res = mockRes();

      await authController.requestOtp(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json.mock.calls[0][0].data).toBeNull();
    });

    it('возвращает 400 при INVALID_PHONE', async () => {
      otpAuthService.requestOtp.mockRejectedValue(new Error('INVALID_PHONE'));
      const req = mockReq({ body: { phone: '+79991234567' } });
      const res = mockRes();

      await authController.requestOtp(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json.mock.calls[0][0].error.code).toBe('INVALID_PHONE');
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('возвращает 400 при INVALID_EMAIL', async () => {
      otpAuthService.requestOtp.mockRejectedValue(new Error('INVALID_EMAIL'));
      const req = mockReq({ body: { email: 'не-почта' } });
      const res = mockRes();

      await authController.requestOtp(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json.mock.calls[0][0].error.code).toBe('INVALID_EMAIL');
      expect(res.json.mock.calls[0][0].error.message).toBe('Неверный формат почты');
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('возвращает 400 при CONTACT_REQUIRED, если не названы ни телефон, ни почта', async () => {
      otpAuthService.requestOtp.mockRejectedValue(new Error('CONTACT_REQUIRED'));
      const req = mockReq({ body: {} });
      const res = mockRes();

      await authController.requestOtp(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json.mock.calls[0][0].error.code).toBe('CONTACT_REQUIRED');
      expect(res.json.mock.calls[0][0].error.message).toBe('Укажите телефон или почту');
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('возвращает 429 при OTP_RATE_LIMITED', async () => {
      otpAuthService.requestOtp.mockRejectedValue(new Error('OTP_RATE_LIMITED'));
      const req = mockReq({ body: { phone: '+992901234567' } });
      const res = mockRes();

      await authController.requestOtp(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(429);
      expect(res.json.mock.calls[0][0].error.code).toBe('OTP_RATE_LIMITED');
    });

    it('передаёт неожиданные ошибки в next', async () => {
      otpAuthService.requestOtp.mockRejectedValue(new Error('gateway down'));
      const req = mockReq({ body: { phone: '+992901234567' } });
      const res = mockRes();

      await authController.requestOtp(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  // ─── verifyOtp ──────────────────────────────────────────────
  describe('verifyOtp', () => {
    it('проверяет код по контакту-объекту и возвращает токены', async () => {
      const result = { access_token: 'a', refresh_token: 'r', user: { id: 1 } };
      otpAuthService.verifyOtp.mockResolvedValue(result);
      const req = mockReq({ body: { phone: '+992901234567', code: '123456' } });
      const res = mockRes();

      await authController.verifyOtp(req, res, mockNext);

      expect(otpAuthService.verifyOtp).toHaveBeenCalledWith(
        { phone: '+992901234567', email: undefined },
        '123456'
      );
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: result }));
    });

    it('проверяет код, присланный на почту', async () => {
      otpAuthService.verifyOtp.mockResolvedValue({ access_token: 'a' });
      const req = mockReq({ body: { email: 'a@b.com', code: '123456' } });
      const res = mockRes();

      await authController.verifyOtp(req, res, mockNext);

      expect(otpAuthService.verifyOtp).toHaveBeenCalledWith(
        { phone: undefined, email: 'a@b.com' },
        '123456'
      );
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('возвращает 400 при неверном коде', async () => {
      otpAuthService.verifyOtp.mockRejectedValue(new Error('OTP_INVALID'));
      const req = mockReq({ body: { phone: '+992901234567', code: '000000' } });
      const res = mockRes();

      await authController.verifyOtp(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json.mock.calls[0][0].error.code).toBe('OTP_INVALID');
    });

    it('возвращает 400 при истёкшем коде', async () => {
      otpAuthService.verifyOtp.mockRejectedValue(new Error('OTP_EXPIRED'));
      const req = mockReq({ body: { phone: '+992901234567', code: '000000' } });
      const res = mockRes();

      await authController.verifyOtp(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json.mock.calls[0][0].error.code).toBe('OTP_EXPIRED');
    });

    it('возвращает 429 после перебора попыток', async () => {
      otpAuthService.verifyOtp.mockRejectedValue(new Error('OTP_LOCKED'));
      const req = mockReq({ body: { phone: '+992901234567', code: '000000' } });
      const res = mockRes();

      await authController.verifyOtp(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(429);
      expect(res.json.mock.calls[0][0].error.code).toBe('OTP_LOCKED');
    });

    it('возвращает 403 при отключённом аккаунте', async () => {
      otpAuthService.verifyOtp.mockRejectedValue(new Error('USER_INACTIVE'));
      const req = mockReq({ body: { phone: '+992901234567', code: '123456' } });
      const res = mockRes();

      await authController.verifyOtp(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(403);
      // Формулировка одна на все места, где встречается это состояние.
      expect(res.json.mock.calls[0][0].error.message).toBe('Аккаунт отключён. Обратитесь к владельцу фермы.');
    });

    it('возвращает 400, если приглашение не влезает в лимит тарифа', async () => {
      otpAuthService.verifyOtp.mockRejectedValue(new Error('STAFF_LIMIT_REACHED'));
      const req = mockReq({ body: { phone: '+992901234567', code: '123456' } });
      const res = mockRes();

      await authController.verifyOtp(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json.mock.calls[0][0].error.code).toBe('STAFF_LIMIT_REACHED');
    });

    it('передаёт неожиданные ошибки в next', async () => {
      otpAuthService.verifyOtp.mockRejectedValue(new Error('oops'));
      const req = mockReq({ body: { phone: '+992901234567', code: '123456' } });
      const res = mockRes();

      await authController.verifyOtp(req, res, mockNext);

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
      expect(res.json.mock.calls[0][0].error.message).toBe('Аккаунт отключён. Обратитесь к владельцу фермы.');
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
});
