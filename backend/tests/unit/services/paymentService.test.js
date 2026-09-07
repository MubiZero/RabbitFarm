jest.mock('../../../src/models', () => ({
  Payment: { create: jest.fn(), findOne: jest.fn() }
}));
jest.mock('../../../src/services/eskhata/eskhataClient', () => ({
  createOrder: jest.fn(),
  checkStatus: jest.fn()
}));
jest.mock('../../../src/services/eskhata/eskhataDeepLink', () => ({
  buildDeepLink: jest.fn(() => 'eskhata://pay/mock')
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), warn: jest.fn(), error: jest.fn()
}));

const { Payment } = require('../../../src/models');
const eskhataClient = require('../../../src/services/eskhata/eskhataClient');
const paymentService = require('../../../src/services/paymentService');

describe('PaymentService', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('createPayment', () => {
    it('creates a Payment row and returns qr/invoiceUrl/deepLink when the bank accepts the order', async () => {
      eskhataClient.createOrder.mockResolvedValue({
        httpStatus: 200,
        body: { status: true, data: { orderId: 'o1', posId: 12, qr: 'qr-data', invoiceUrl: 'https://x/invoices/1' } }
      });
      const created = { id: 1, invoice_id: 'generated' };
      Payment.create.mockResolvedValue(created);

      const result = await paymentService.createPayment(5, { amount: 100, description: 'Подписка' });

      expect(Payment.create).toHaveBeenCalledWith(expect.objectContaining({
        farm_id: 5,
        order_id: 'o1',
        pos_id: 12,
        amount: 100,
        status: 'new'
      }));
      expect(result).toEqual({
        success: true,
        payment: created,
        qr: 'qr-data',
        invoiceUrl: 'https://x/invoices/1',
        deepLink: 'eskhata://pay/mock'
      });
    });

    it('does NOT create a Payment row when the bank declines at creation (status:false)', async () => {
      eskhataClient.createOrder.mockResolvedValue({
        httpStatus: 200,
        body: { status: false, message: 'Отсутствует свободная касса' }
      });

      const result = await paymentService.createPayment(5, { amount: 100, description: 'x' });

      expect(Payment.create).not.toHaveBeenCalled();
      expect(result).toEqual({ success: false, message: 'Отсутствует свободная касса' });
    });
  });

  describe('reconcile', () => {
    it('returns found:false for an invoice we do not know about (foreign/uninteresting webhook)', async () => {
      Payment.findOne.mockResolvedValue(null);

      const result = await paymentService.reconcile('unknown-invoice');

      expect(Payment.findOne).toHaveBeenCalledWith(
        expect.objectContaining({ where: { invoice_id: 'unknown-invoice' }, tenantScope: 'all' })
      );
      expect(result).toEqual({ found: false });
      expect(eskhataClient.checkStatus).not.toHaveBeenCalled();
    });

    it('is idempotent: does not re-check the bank for an already-completed payment', async () => {
      const payment = { status: 'completed', update: jest.fn() };
      Payment.findOne.mockResolvedValue(payment);

      const result = await paymentService.reconcile('inv1');

      expect(eskhataClient.checkStatus).not.toHaveBeenCalled();
      expect(result).toEqual({ found: true, payment, changed: false });
    });

    it('marks the payment completed only when the bank confirms COMPLETED via signed status check', async () => {
      const payment = {
        status: 'new',
        invoice_id: 'inv1',
        order_id: 'o1',
        amount: 100,
        currency: '972',
        pos_id: 12,
        update: jest.fn().mockResolvedValue(undefined)
      };
      Payment.findOne.mockResolvedValue(payment);
      eskhataClient.checkStatus.mockResolvedValue({
        httpStatus: 200,
        body: { status: true, data: { orderStatus: 'COMPLETED' } }
      });

      const result = await paymentService.reconcile('inv1');

      expect(payment.update).toHaveBeenCalledWith(expect.objectContaining({ status: 'completed' }));
      expect(result.changed).toBe(true);
    });

    it('does not complete the payment when the bank reports a non-COMPLETED status', async () => {
      const payment = {
        status: 'new',
        invoice_id: 'inv1',
        order_id: 'o1',
        amount: 100,
        currency: '972',
        pos_id: 12,
        update: jest.fn().mockResolvedValue(undefined)
      };
      Payment.findOne.mockResolvedValue(payment);
      eskhataClient.checkStatus.mockResolvedValue({
        httpStatus: 200,
        body: { status: true, data: { orderStatus: 'NEW' } }
      });

      const result = await paymentService.reconcile('inv1');

      expect(payment.update).not.toHaveBeenCalledWith(expect.objectContaining({ status: 'completed' }));
      expect(result.changed).toBe(false);
    });

    it('does not complete the payment when the status check itself is declined (status:false)', async () => {
      const payment = {
        status: 'new',
        invoice_id: 'inv1',
        order_id: 'o1',
        amount: 100,
        currency: '972',
        pos_id: 12,
        update: jest.fn()
      };
      Payment.findOne.mockResolvedValue(payment);
      eskhataClient.checkStatus.mockResolvedValue({
        httpStatus: 200,
        body: { status: false, message: 'boom' }
      });

      const result = await paymentService.reconcile('inv1');

      expect(payment.update).not.toHaveBeenCalled();
      expect(result.changed).toBe(false);
    });
  });
});
