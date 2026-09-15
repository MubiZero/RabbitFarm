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
        },
        messageSent: true
      });
      const res = mockRes();
      const req = mockReq({ body: inviteBody() });

      await staffController.createInvitation(req, res, mockNext);

      expect(staffService.createInvitation).toHaveBeenCalledWith(1, req.user, req.body);
      expect(res.status).toHaveBeenCalledWith(201);
      const payload = res.json.mock.calls[0][0];
      expect(payload.data).toEqual({
        id: 1,
        email: 'a@x.com',
        phone: undefined,
        full_name: 'Пётр',
        role: 'worker',
        expires_at: '2026-01-01',
        invite_link: require('../../../src/config/app').inviteUrl,
        message_sent: true
      });
      // Диктовать работнику нечего: он войдёт кодом на свой же контакт.
      expect(payload.message).toContain('письмо работнику отправлено');
    });

    // Пока у шлюза не заведён шаблон приглашения, SMS не уходит. Владельцу
    // нужна ссылка и прямой текст, а не обещание, что «работнику придёт
    // сообщение».
    it('не ушедшее сообщение называет прямо и отдаёт ссылку', async () => {
      staffService.createInvitation.mockResolvedValue({
        invitation: {
          id: 2,
          email: null,
          phone: '+992901234567',
          full_name: 'Пётр',
          role: 'worker',
          expires_at: '2026-01-01'
        },
        messageSent: false
      });
      const res = mockRes();

      await staffController.createInvitation(
        mockReq({ body: inviteBody({ email: undefined, phone: '+992901234567' }) }),
        res,
        mockNext
      );

      const payload = res.json.mock.calls[0][0];
      // Ссылка одна на всех и ничего личного не несёт: номер в ней больше
      // не ездит, пересылать её можно любым способом.
      expect(payload.data.invite_link).toBe(require('../../../src/config/app').inviteUrl);
      expect(payload.data.invite_link).not.toContain('901234567');
      expect(payload.data.message_sent).toBe(false);
      expect(payload.message).toContain('SMS работнику не ушла');
    });

    it('говорит прямо, когда письмо отправить не удалось', async () => {
      staffService.createInvitation.mockResolvedValue({
        invitation: { id: 3, email: 'a@x.com', role: 'worker', expires_at: '2026-01-01' },
        messageSent: false
      });
      const res = mockRes();

      await staffController.createInvitation(mockReq({ body: inviteBody() }), res, mockNext);

      expect(res.json.mock.calls[0][0].message).toContain('письмо отправить не удалось');
    });
  });

  describe('resendInvitation', () => {
    it('продлевает приглашение и отдаёт его тем же видом, что и создание', async () => {
      staffService.resendInvitation.mockResolvedValue({
        invitation: {
          id: 7,
          email: null,
          phone: '+992901234567',
          full_name: 'Пётр',
          role: 'worker',
          expires_at: '2026-02-01'
        },
        messageSent: false
      });
      const res = mockRes();
      const req = mockReq({ params: { id: '7' } });

      await staffController.resendInvitation(req, res, mockNext);

      expect(staffService.resendInvitation).toHaveBeenCalledWith(1, req.user, '7');
      expect(res.json.mock.calls[0][0].data.invite_link)
        .toBe(require('../../../src/config/app').inviteUrl);
    });

    it('возвращает 404, если приглашения уже нет', async () => {
      staffService.resendInvitation.mockRejectedValue(new Error('INVITATION_NOT_FOUND'));
      const res = mockRes();

      await staffController.resendInvitation(mockReq({ params: { id: '7' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });
  });
});
