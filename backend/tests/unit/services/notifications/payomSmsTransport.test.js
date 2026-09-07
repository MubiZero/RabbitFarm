jest.mock('../../../../src/config/payom', () => ({
  baseUrl: 'https://gateway.test',
  apiToken: 'test-token',
  senderName: 'AFK4.NET',
  timeoutSeconds: 15,
  templateIds: { 'user.verification_code': 'template-uuid-1' },
  isConfigured: true
}));
jest.mock('../../../../src/utils/logger', () => ({
  info: jest.fn(), warn: jest.fn(), error: jest.fn()
}));

const config = require('../../../../src/config/payom');
const { sendTemplateSms, truncate, MAX_VARIABLE_LENGTH } = require('../../../../src/services/notifications/payomSmsTransport');

describe('payomSmsTransport', () => {
  beforeEach(() => {
    global.fetch = jest.fn();
  });

  afterEach(() => {
    delete global.fetch;
  });

  describe('truncate', () => {
    it('leaves short values untouched', () => {
      expect(truncate('RabbitFarm')).toBe('RabbitFarm');
    });

    it('cuts values longer than the max length', () => {
      const long = 'x'.repeat(MAX_VARIABLE_LENGTH + 10);
      expect(truncate(long)).toHaveLength(MAX_VARIABLE_LENGTH);
    });
  });

  describe('sendTemplateSms', () => {
    it('posts the templateId from config, not a hardcoded one, with truncated variables', async () => {
      global.fetch.mockResolvedValue({
        status: 201,
        text: async () => JSON.stringify({ id: 'msg-1', deliveryStatus: 'ACCEPTED' })
      });

      const result = await sendTemplateSms({
        templateKey: 'user.verification_code',
        telephone: '+992937380070',
        variables: { 'text-1': 'RabbitFarm', 'code-1': '123456' }
      });

      expect(global.fetch).toHaveBeenCalledWith(
        'https://gateway.test/api/message',
        expect.objectContaining({
          method: 'POST',
          headers: expect.objectContaining({ Authorization: 'Bearer test-token' })
        })
      );
      const body = JSON.parse(global.fetch.mock.calls[0][1].body);
      expect(body.senderName).toBe('AFK4.NET');
      expect(body.templateMessage.templateId).toBe('template-uuid-1');
      expect(body.templateMessage.variables['code-1']).toBe('123456');
      expect(result).toEqual({ id: 'msg-1', deliveryStatus: 'ACCEPTED' });
    });

    it('throws a permanent error when the transport is not configured', async () => {
      config.isConfigured = false;
      await expect(sendTemplateSms({ templateKey: 'user.verification_code', telephone: 'x', variables: {} }))
        .rejects.toMatchObject({ permanent: true });
      config.isConfigured = true;
    });

    it('throws a permanent error when the notification key has no mapped template', async () => {
      await expect(sendTemplateSms({ templateKey: 'unknown.key', telephone: 'x', variables: {} }))
        .rejects.toMatchObject({ permanent: true });
      expect(global.fetch).not.toHaveBeenCalled();
    });

    it('treats 2xx without an id as a transient failure worth retrying', async () => {
      global.fetch.mockResolvedValue({ status: 201, text: async () => JSON.stringify({ deliveryStatus: 'ACCEPTED' }) });

      await expect(sendTemplateSms({ templateKey: 'user.verification_code', telephone: 'x', variables: {} }))
        .rejects.toMatchObject({ permanent: false });
    });

    it.each([401, 403, 422])('treats %i as a permanent failure (config/template issue)', async (status) => {
      global.fetch.mockResolvedValue({ status, text: async () => JSON.stringify({ detail: 'nope' }) });

      await expect(sendTemplateSms({ templateKey: 'user.verification_code', telephone: 'x', variables: {} }))
        .rejects.toMatchObject({ permanent: true, message: 'nope' });
    });

    it.each([429, 500, 503])('treats %i as a transient failure worth retrying', async (status) => {
      global.fetch.mockResolvedValue({ status, text: async () => '' });

      await expect(sendTemplateSms({ templateKey: 'user.verification_code', telephone: 'x', variables: {} }))
        .rejects.toMatchObject({ permanent: false });
    });

    it('reads the error detail in RFC7807 order: detail, then message, then error, then raw body', async () => {
      global.fetch.mockResolvedValue({ status: 422, text: async () => JSON.stringify({ message: 'bad template' }) });

      await expect(sendTemplateSms({ templateKey: 'user.verification_code', telephone: 'x', variables: {} }))
        .rejects.toMatchObject({ message: 'bad template' });
    });
  });
});
