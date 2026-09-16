const appConfig = require('../../../src/config/app');
const { MAX_VARIABLE_LENGTH } = require('../../../src/services/notifications/payomSmsTransport');

/**
 * Ссылка-приглашение уезжает в SMS плейсхолдером, а транспорт режет любое
 * подставляемое значение по `MAX_VARIABLE_LENGTH` — молча, как и задумано
 * для имён и подписей. Для ссылки обрезка означает мёртвый адрес в живом
 * сообщении: человек получит SMS, нажмёт и никуда не попадёт.
 *
 * Поэтому длина адреса — не косметика, а условие работы приглашения. Если
 * домен когда-нибудь станет длиннее, тест обязан упасть здесь, а не у
 * работника на телефоне.
 */
describe('Длина ссылки-приглашения', () => {
  it('влезает в подставляемое значение SMS целиком', () => {
    expect(appConfig.inviteUrl.length).toBeLessThanOrEqual(MAX_VARIABLE_LENGTH);
  });

  it('ведёт по https — кастомную схему SMS-клиент не сделает ссылкой', () => {
    expect(appConfig.inviteUrl.startsWith('https://')).toBe(true);
  });
});
