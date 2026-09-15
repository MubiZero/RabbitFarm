// Транспорт подменён намеренно: проверяется, что и с каким шаблоном уходит
// в шлюз, а не сам шлюз. Наружу тесты не ходят (см. `tests/setup.js`), и
// без подмены здесь сработала бы ветка «не настроено».
jest.mock('../../src/services/notifications/payomSmsTransport', () => ({
  sendTemplateSms: jest.fn().mockResolvedValue({ id: 'msg-1', deliveryStatus: 'ACCEPTED' }),
  truncate: (value) => String(value),
  MAX_VARIABLE_LENGTH: 40
}));

const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');
const { User } = require('../../src/models');
const payomSmsTransport = require('../../src/services/notifications/payomSmsTransport');
const payomConfig = require('../../src/config/payom');
const appConfig = require('../../src/config/app');

/**
 * SMS-приглашение работнику.
 *
 * Кода в этой SMS нет: у приглашения нет своего кода, человек входит
 * обычным кодом на свой номер, и этот же вход активирует приглашение.
 * Сообщение говорит только «вас ждут» и куда идти.
 */
describe('Приглашение работника по SMS', () => {
  let ownerToken;
  let ownerId;

  beforeAll(async () => {
    await syncTestDb();
    const owner = await registerFarm(app, {
      email: 'sms_owner@example.com',
      full_name: 'Владелец'
    });
    ownerToken = owner.accessToken;
    ownerId = owner.user.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  beforeEach(() => {
    payomSmsTransport.sendTemplateSms.mockClear();
    // Карта шаблонов — состояние настроек, а не кода: каждый тест ставит
    // своё и убирает за собой.
    delete payomConfig.templateIds['staff.invitation'];
    delete payomConfig.templateIds['staff.invitation.tg'];
  });

  const invite = (phone) =>
    request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ phone, full_name: 'Новый Работник', role: 'worker' });

  it('с заведённым шаблоном уходит SMS — без кода, со ссылкой на приложение', async () => {
    payomConfig.templateIds['staff.invitation'] = 'tpl-invite';

    const res = await invite('+992900000101');

    expect(res.status).toBe(201);
    expect(res.body.data.message_sent).toBe(true);
    expect(payomSmsTransport.sendTemplateSms).toHaveBeenCalledWith({
      templateKey: 'staff.invitation',
      telephone: '+992900000101',
      variables: {
        'text-1': payomConfig.senderLabel,
        'text-2': appConfig.inviteUrl
      }
    });

    // Одноразовому коду в приглашении взяться неоткуда, и попасть он сюда
    // не должен ни при какой правке: шлюз принимает код только в `code-1`,
    // а шаблон приглашения такого плейсхолдера не имеет вовсе.
    const { variables } = payomSmsTransport.sendTemplateSms.mock.calls[0][0];
    expect(Object.keys(variables)).not.toContain('code-1');
  });

  it('пока шаблон не заведён, приглашение создаётся, но сообщение не уходит', async () => {
    const res = await invite('+992900000102');

    expect(res.status).toBe(201);
    expect(res.body.data.message_sent).toBe(false);
    expect(payomSmsTransport.sendTemplateSms).not.toHaveBeenCalled();
    // Владельцу нужно чем-то позвать человека руками — ссылка есть всегда.
    expect(res.body.data.invite_link).toBe(appConfig.inviteUrl);
  });

  it('язык позвавшего выбирает свой шаблон, если он заведён', async () => {
    payomConfig.templateIds['staff.invitation'] = 'tpl-invite';
    payomConfig.templateIds['staff.invitation.tg'] = 'tpl-invite-tg';
    await User.update({ language: 'tg' }, { where: { id: ownerId } });

    await invite('+992900000103');

    expect(payomSmsTransport.sendTemplateSms).toHaveBeenCalledWith(
      expect.objectContaining({ templateKey: 'staff.invitation.tg' })
    );

    await User.update({ language: 'ru' }, { where: { id: ownerId } });
  });

  it('ссылка не несёт ни номера, ни кода — её можно переслать кому угодно', async () => {
    const res = await invite('+992900000104');

    expect(res.body.data.invite_link).toBe(appConfig.inviteUrl);
    expect(res.body.data.invite_link).not.toContain('900000104');
    expect(res.body.data.invite_link.startsWith('https://')).toBe(true);
  });
});
