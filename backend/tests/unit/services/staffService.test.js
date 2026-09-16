jest.mock('../../../src/models', () => ({
  User: {
    findOne: jest.fn(),
    findAll: jest.fn(),
    create: jest.fn()
  },
  Farm: {
    update: jest.fn(),
    findByPk: jest.fn()
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
jest.mock('../../../src/services/notifications/emailTransport', () => ({
  sendInvitationEmail: jest.fn()
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { User, Farm, Invitation } = require('../../../src/models');
const planService = require('../../../src/services/planService');
const emailTransport = require('../../../src/services/notifications/emailTransport');
const staffService = require('../../../src/services/staffService');

// Имя приглашённого обязательно: активация идёт кодом на экране входа, сам
// человек себя нигде не представляет.
const inviteData = (overrides = {}) => ({
  email: 'a@x.com', role: 'worker', full_name: 'Пётр Иванов', ...overrides
});

// Позвавший: его имя стоит в письме, его язык выбирает язык письма.
const owner = (overrides = {}) => ({
  id: 10, full_name: 'Пётр Владелец', language: 'ru', ...overrides
});

/** Приглашение так, как его возвращает Sequelize, — с `update()`. */
const invitationRow = (overrides = {}) => ({
  id: 1,
  farm_id: 1,
  email: 'a@x.com',
  phone: null,
  role: 'worker',
  update: jest.fn(),
  ...overrides
});

describe('StaffService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    Farm.findByPk.mockResolvedValue({ name: 'Ферма Петра' });
    emailTransport.sendInvitationEmail.mockResolvedValue({});
  });

  describe('createInvitation', () => {
    it('бросает STAFF_LIMIT_REACHED, не выписывая приглашение, если ферма упёрлась в лимит тарифа', async () => {
      planService.assertStaffLimit.mockRejectedValue(new Error('STAFF_LIMIT_REACHED'));

      await expect(staffService.createInvitation(1, owner(), inviteData()))
        .rejects.toThrow('STAFF_LIMIT_REACHED');

      expect(planService.assertStaffLimit).toHaveBeenCalledWith(1);
      expect(Invitation.create).not.toHaveBeenCalled();
    });

    it('бросает USER_EXISTS, если email уже занят', async () => {
      planService.assertStaffLimit.mockResolvedValue(undefined);
      User.findOne.mockResolvedValue({ id: 5 });

      await expect(staffService.createInvitation(1, owner(), inviteData()))
        .rejects.toThrow('USER_EXISTS');
    });

    it('создаёт приглашение с именем приглашённого, когда лимит не достигнут', async () => {
      planService.assertStaffLimit.mockResolvedValue(undefined);
      User.findOne.mockResolvedValue(null);
      Invitation.destroy.mockResolvedValue(0);
      Invitation.create.mockResolvedValue(invitationRow());

      const { invitation } = await staffService.createInvitation(
        1, owner(), inviteData({ full_name: '  Пётр Иванов  ' })
      );

      expect(invitation.id).toBe(1);
      expect(Invitation.create).toHaveBeenCalledWith(expect.objectContaining({
        farm_id: 1,
        email: 'a@x.com',
        full_name: 'Пётр Иванов',
        created_by: 10
      }));
    });

    // Главное, ради чего приглашение вообще существует: человек должен
    // узнать, что его позвали, не дожидаясь звонка владельца.
    it('зовёт приглашённого письмом — на языке позвавшего и от его имени', async () => {
      planService.assertStaffLimit.mockResolvedValue(undefined);
      User.findOne.mockResolvedValue(null);
      Invitation.destroy.mockResolvedValue(0);
      Invitation.create.mockResolvedValue(invitationRow());

      const { messageSent } = await staffService.createInvitation(
        1, owner({ language: 'tg' }), inviteData()
      );

      expect(messageSent).toBe(true);
      const letter = emailTransport.sendInvitationEmail.mock.calls[0][0];
      expect(letter.to).toBe('a@x.com');
      expect(letter.subject).toBe('Даъват ба хоҷагӣ');
      expect(letter.text).toContain('Пётр Владелец');
      expect(letter.text).toContain('Ферма Петра');
      expect(letter.text).toContain('a@x.com');
    });

    // SMS-шлюз принимает только заранее одобренные шаблоны, и приглашения
    // среди них нет — врать «работник получит SMS» нельзя.
    it('на телефон ничего не шлёт и честно говорит, что сообщение не ушло', async () => {
      planService.assertStaffLimit.mockResolvedValue(undefined);
      User.findOne.mockResolvedValue(null);
      Invitation.destroy.mockResolvedValue(0);
      Invitation.create.mockResolvedValue(
        invitationRow({ email: null, phone: '+992901234567' })
      );

      const { messageSent } = await staffService.createInvitation(
        1, owner(), inviteData({ email: undefined, phone: '+992901234567' })
      );

      expect(messageSent).toBe(false);
      expect(emailTransport.sendInvitationEmail).not.toHaveBeenCalled();
    });

    // Почта — опциональная интеграция: без SMTP приглашение всё равно
    // должно быть выписано, иначе владелец не может позвать вообще никого.
    it('не роняет приглашение, если письмо не ушло', async () => {
      planService.assertStaffLimit.mockResolvedValue(undefined);
      User.findOne.mockResolvedValue(null);
      Invitation.destroy.mockResolvedValue(0);
      Invitation.create.mockResolvedValue(invitationRow());
      emailTransport.sendInvitationEmail.mockRejectedValue(new Error('EMAIL_NOT_CONFIGURED'));

      const { invitation, messageSent } = await staffService.createInvitation(
        1, owner(), inviteData()
      );

      expect(invitation.id).toBe(1);
      expect(messageSent).toBe(false);
    });
  });

  describe('resendInvitation', () => {
    it('продлевает срок от «сейчас» и зовёт человека ещё раз', async () => {
      const invitation = invitationRow();
      Invitation.findOne.mockResolvedValue(invitation);
      planService.assertStaffLimit.mockResolvedValue(undefined);

      const { messageSent } = await staffService.resendInvitation(1, owner(), 1);

      expect(messageSent).toBe(true);
      const { expires_at: expiresAt } = invitation.update.mock.calls[0][0];
      expect(expiresAt.getTime()).toBeGreaterThan(Date.now());
      expect(emailTransport.sendInvitationEmail).toHaveBeenCalledTimes(1);
      // Второй записи на тот же контакт не заводим — список от неё только
      // запутался бы.
      expect(Invitation.create).not.toHaveBeenCalled();
    });

    it('бросает INVITATION_NOT_FOUND для чужого или уже принятого приглашения', async () => {
      Invitation.findOne.mockResolvedValue(null);

      await expect(staffService.resendInvitation(1, owner(), 99))
        .rejects.toThrow('INVITATION_NOT_FOUND');
      expect(emailTransport.sendInvitationEmail).not.toHaveBeenCalled();
    });

    // Пока приглашение лежало просроченным, тариф мог смениться: продлевать
    // приглашение туда, куда уже некого принять, — обещание, которое
    // сорвётся на входе работника.
    it('не продлевает приглашение, если места по тарифу кончились', async () => {
      const invitation = invitationRow();
      Invitation.findOne.mockResolvedValue(invitation);
      planService.assertStaffLimit.mockRejectedValue(new Error('STAFF_LIMIT_REACHED'));

      await expect(staffService.resendInvitation(1, owner(), 1))
        .rejects.toThrow('STAFF_LIMIT_REACHED');
      expect(invitation.update).not.toHaveBeenCalled();
    });
  });
});
