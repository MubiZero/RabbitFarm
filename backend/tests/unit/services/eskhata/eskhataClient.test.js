jest.mock('../../../../src/config/eskhata', () => ({
  baseUrl: 'https://test.eskhata.example',
  companyId: 'company-123',
  hashKey: 'secretkey',
  merchantId: '4368',
  isConfigured: true
}));

const eskhataClient = require('../../../../src/services/eskhata/eskhataClient');

describe('eskhataClient', () => {
  beforeEach(() => {
    global.fetch = jest.fn();
  });

  afterEach(() => {
    delete global.fetch;
  });

  describe('companyIdHeader', () => {
    it('base64-encodes the company id', () => {
      expect(eskhataClient.companyIdHeader()).toBe(Buffer.from('company-123').toString('base64'));
    });
  });

  describe('createOrder', () => {
    it('posts to /merchant/api/v1/orders/create with posId 0 for the default orderTypeId', async () => {
      global.fetch.mockResolvedValue({
        status: 200,
        json: async () => ({ status: true, data: { orderId: 'o1', orderStatus: 'NEW', posId: 12, qr: 'qr', invoiceUrl: 'https://x/invoices/1' } })
      });

      const result = await eskhataClient.createOrder({
        invoiceId: 'inv1',
        amount: 125,
        description: 'Подписка'
      });

      expect(global.fetch).toHaveBeenCalledTimes(1);
      const [url, options] = global.fetch.mock.calls[0];
      expect(url).toBe('https://test.eskhata.example/merchant/api/v1/orders/create');
      expect(options.headers['X-CompanyId']).toBe(Buffer.from('company-123').toString('base64'));

      const body = JSON.parse(options.body);
      expect(body.posId).toBe(0);
      expect(body.orderTypeId).toBe(3);
      expect(body.merchantId).toBe(4368);
      expect(body.amount).toBe(125);
      expect(body.currency).toBe('972');
      expect(typeof body.hash).toBe('string');

      expect(result.httpStatus).toBe(200);
      expect(result.body.status).toBe(true);
    });

    it('returns the parsed body even when the bank declines with status:false', async () => {
      global.fetch.mockResolvedValue({
        status: 200,
        json: async () => ({ status: false, message: 'Отсутствует свободная касса' })
      });

      const result = await eskhataClient.createOrder({ invoiceId: 'inv2', amount: 10, description: 'x' });

      expect(result.httpStatus).toBe(200);
      expect(result.body.status).toBe(false);
      expect(result.body.message).toBe('Отсутствует свободная касса');
    });
  });

  describe('checkStatus', () => {
    it('posts to /merchant/api/v1/orders/status with the assigned posId', async () => {
      global.fetch.mockResolvedValue({
        status: 200,
        json: async () => ({ status: true, data: { orderStatus: 'COMPLETED' } })
      });

      const result = await eskhataClient.checkStatus({
        invoiceId: 'inv1',
        orderId: 'o1',
        amount: 125,
        posId: 12
      });

      const [url, options] = global.fetch.mock.calls[0];
      expect(url).toBe('https://test.eskhata.example/merchant/api/v1/orders/status');
      const body = JSON.parse(options.body);
      expect(body.posId).toBe(12);
      expect(body.orderId).toBe('o1');

      expect(result.body.data.orderStatus).toBe('COMPLETED');
    });
  });
});
