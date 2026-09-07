jest.mock('../../../src/services/paymentService');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), warn: jest.fn(), error: jest.fn()
}));

const paymentService = require('../../../src/services/paymentService');
const paymentController = require('../../../src/controllers/paymentController');

const mockReq = (overrides = {}) => ({
  farmId: 1,
  body: {},
  ...overrides
});

const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  res.sendStatus = jest.fn().mockReturnValue(res);
  return res;
};

const mockNext = jest.fn();

describe('PaymentController', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('create', () => {
    it('returns 201 with qr/invoice_url/deep_link on success', async () => {
      paymentService.createPayment.mockResolvedValue({
        success: true,
        payment: { invoice_id: 'inv1' },
        qr: 'qr-data',
        invoiceUrl: 'https://x/invoices/1',
        deepLink: 'eskhata://pay/1'
      });
      const req = mockReq({ body: { amount: 100, description: 'Подписка' } });
      const res = mockRes();

      await paymentController.create(req, res, mockNext);

      expect(paymentService.createPayment).toHaveBeenCalledWith(1, { amount: 100, description: 'Подписка' });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: true,
        data: expect.objectContaining({
          invoice_id: 'inv1',
          qr: 'qr-data',
          invoice_url: 'https://x/invoices/1',
          deep_link: 'eskhata://pay/1'
        })
      }));
    });

    it('returns 400 when the bank declines at creation', async () => {
      paymentService.createPayment.mockResolvedValue({ success: false, message: 'Отсутствует свободная касса' });
      const req = mockReq({ body: { amount: 100 } });
      const res = mockRes();

      await paymentController.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('calls next on unexpected errors', async () => {
      const err = new Error('boom');
      paymentService.createPayment.mockRejectedValue(err);
      const req = mockReq({ body: { amount: 100 } });
      const res = mockRes();

      await paymentController.create(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('webhook', () => {
    it('reconciles the invoice and always answers 200', async () => {
      paymentService.reconcile.mockResolvedValue({ found: true, payment: {}, changed: true });
      const req = mockReq({ body: { invoiceId: 'inv1', orderId: 'o1' } });
      const res = mockRes();

      await paymentController.webhook(req, res, mockNext);

      expect(paymentService.reconcile).toHaveBeenCalledWith('inv1');
      expect(res.sendStatus).toHaveBeenCalledWith(200);
    });

    it('answers 200 without calling reconcile when the body has no invoiceId (foreign event)', async () => {
      const req = mockReq({ body: { somethingElse: true } });
      const res = mockRes();

      await paymentController.webhook(req, res, mockNext);

      expect(paymentService.reconcile).not.toHaveBeenCalled();
      expect(res.sendStatus).toHaveBeenCalledWith(200);
    });

    it('answers 200 even for an invoice we do not recognize', async () => {
      paymentService.reconcile.mockResolvedValue({ found: false });
      const req = mockReq({ body: { invoiceId: 'unknown' } });
      const res = mockRes();

      await paymentController.webhook(req, res, mockNext);

      expect(res.sendStatus).toHaveBeenCalledWith(200);
    });

    it('calls next on unexpected errors instead of answering 200 (bank should retry)', async () => {
      const err = new Error('db down');
      paymentService.reconcile.mockRejectedValue(err);
      const req = mockReq({ body: { invoiceId: 'inv1' } });
      const res = mockRes();

      await paymentController.webhook(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
      expect(res.sendStatus).not.toHaveBeenCalled();
    });
  });
});
