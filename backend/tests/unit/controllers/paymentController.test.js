jest.mock('../../../src/services/paymentService');
jest.mock('../../../src/services/planService');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), warn: jest.fn(), error: jest.fn()
}));

const paymentService = require('../../../src/services/paymentService');
const planService = require('../../../src/services/planService');
const paymentController = require('../../../src/controllers/paymentController');

const mockReq = (overrides = {}) => ({
  farmId: 1,
  body: {},
  params: {},
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
    it('считает сумму по тарифу фермы и создаёт заказ на неё, а не на тело запроса', async () => {
      planService.getRenewalQuote.mockResolvedValue({ amount: 50, description: 'Тариф «Базовый»' });
      paymentService.createPayment.mockResolvedValue({
        success: true,
        payment: { invoice_id: 'inv1' },
        qr: 'qr-data',
        invoiceUrl: 'https://x/invoices/1',
        deepLink: 'eskhata://pay/1'
      });
      const req = mockReq({ body: { amount: 999999 } });
      const res = mockRes();

      await paymentController.create(req, res, mockNext);

      expect(planService.getRenewalQuote).toHaveBeenCalledWith(1);
      expect(paymentService.createPayment).toHaveBeenCalledWith(1, { amount: 50, description: 'Тариф «Базовый»' });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: true,
        data: expect.objectContaining({
          invoice_id: 'inv1',
          amount: 50,
          qr: 'qr-data',
          invoice_url: 'https://x/invoices/1',
          deep_link: 'eskhata://pay/1'
        })
      }));
    });

    it('returns 400 when the bank declines at creation', async () => {
      planService.getRenewalQuote.mockResolvedValue({ amount: 50, description: 'Тариф «Базовый»' });
      paymentService.createPayment.mockResolvedValue({ success: false, message: 'Отсутствует свободная касса' });
      const req = mockReq();
      const res = mockRes();

      await paymentController.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('returns 400 NO_PLAN when the farm has no plan assigned', async () => {
      planService.getRenewalQuote.mockRejectedValue(new Error('NO_PLAN'));
      const req = mockReq();
      const res = mockRes();

      await paymentController.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(paymentService.createPayment).not.toHaveBeenCalled();
    });

    it('returns 400 PLAN_FREE when the current plan has no price', async () => {
      planService.getRenewalQuote.mockRejectedValue(new Error('PLAN_FREE'));
      const req = mockReq();
      const res = mockRes();

      await paymentController.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(paymentService.createPayment).not.toHaveBeenCalled();
    });

    it('calls next on unexpected errors', async () => {
      const err = new Error('boom');
      planService.getRenewalQuote.mockRejectedValue(err);
      const req = mockReq();
      const res = mockRes();

      await paymentController.create(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('status', () => {
    it('продлевает тариф и отдаёт статус, если платёж своей фермы только что подтверждён', async () => {
      paymentService.reconcile.mockResolvedValue({
        found: true,
        changed: true,
        payment: { farm_id: 1, status: 'completed' }
      });
      const req = mockReq({ params: { invoiceId: 'inv1' } });
      const res = mockRes();

      await paymentController.status(req, res, mockNext);

      expect(planService.extendPlanExpiry).toHaveBeenCalledWith(1);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        data: expect.objectContaining({ status: 'completed' })
      }));
    });

    it('не продлевает тариф, если статус не менялся', async () => {
      paymentService.reconcile.mockResolvedValue({
        found: true,
        changed: false,
        payment: { farm_id: 1, status: 'new' }
      });
      const req = mockReq({ params: { invoiceId: 'inv1' } });
      const res = mockRes();

      await paymentController.status(req, res, mockNext);

      expect(planService.extendPlanExpiry).not.toHaveBeenCalled();
    });

    it('отвечает 404 на чужой платёж — по farm_id, не только по invoiceId', async () => {
      paymentService.reconcile.mockResolvedValue({
        found: true,
        changed: false,
        payment: { farm_id: 2, status: 'new' }
      });
      const req = mockReq({ params: { invoiceId: 'inv1' } });
      const res = mockRes();

      await paymentController.status(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('отвечает 404 на неизвестный платёж', async () => {
      paymentService.reconcile.mockResolvedValue({ found: false });
      const req = mockReq({ params: { invoiceId: 'unknown' } });
      const res = mockRes();

      await paymentController.status(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });
  });

  describe('webhook', () => {
    it('reconciles the invoice, extends the plan on completion, and always answers 200', async () => {
      paymentService.reconcile.mockResolvedValue({ found: true, payment: { farm_id: 1 }, changed: true });
      const req = mockReq({ body: { data: { invoiceId: 'inv1', orderId: 'o1' } } });
      const res = mockRes();

      await paymentController.webhook(req, res, mockNext);

      expect(paymentService.reconcile).toHaveBeenCalledWith('inv1');
      expect(planService.extendPlanExpiry).toHaveBeenCalledWith(1);
      expect(res.sendStatus).toHaveBeenCalledWith(200);
    });

    it('does not extend the plan when the status did not change', async () => {
      paymentService.reconcile.mockResolvedValue({ found: true, payment: { farm_id: 1 }, changed: false });
      const req = mockReq({ body: { data: { invoiceId: 'inv1' } } });
      const res = mockRes();

      await paymentController.webhook(req, res, mockNext);

      expect(planService.extendPlanExpiry).not.toHaveBeenCalled();
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
      const req = mockReq({ body: { data: { invoiceId: 'unknown' } } });
      const res = mockRes();

      await paymentController.webhook(req, res, mockNext);

      expect(res.sendStatus).toHaveBeenCalledWith(200);
    });

    it('calls next on unexpected errors instead of answering 200 (bank should retry)', async () => {
      const err = new Error('db down');
      paymentService.reconcile.mockRejectedValue(err);
      const req = mockReq({ body: { data: { invoiceId: 'inv1' } } });
      const res = mockRes();

      await paymentController.webhook(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
      expect(res.sendStatus).not.toHaveBeenCalled();
    });
  });
});
