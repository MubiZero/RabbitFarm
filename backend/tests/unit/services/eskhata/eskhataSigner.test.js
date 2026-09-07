const crypto = require('crypto');
const { sha256Hex, formatAmount, signCreateOrder, signStatus } = require('../../../../src/services/eskhata/eskhataSigner');

describe('eskhataSigner', () => {
  describe('formatAmount', () => {
    it('formats a whole number with two decimals', () => {
      expect(formatAmount(125)).toBe('125.00');
    });

    it('formats a number that already has one decimal', () => {
      expect(formatAmount(125.5)).toBe('125.50');
    });

    it('rounds a number with more than two decimals', () => {
      expect(formatAmount(125.456)).toBe('125.46');
    });

    it('formats a string amount', () => {
      expect(formatAmount('99')).toBe('99.00');
    });
  });

  describe('signCreateOrder', () => {
    const order = {
      invoiceId: 'inv1',
      amount: 125,
      currency: '972',
      description: 'test',
      posId: 0,
      orderTypeId: 3,
      merchantId: 4368
    };

    it('matches a manually-built SHA-256 of the concatenated fields, not HMAC', () => {
      const expected = crypto
        .createHash('sha256')
        .update('inv1' + '125.00' + '972' + 'test' + '0' + '3' + '4368' + '.' + 'secretkey', 'utf8')
        .digest('hex');

      expect(signCreateOrder(order, 'secretkey')).toBe(expected);
    });

    it('changes when the hash key changes', () => {
      const a = signCreateOrder(order, 'key-a');
      const b = signCreateOrder(order, 'key-b');
      expect(a).not.toBe(b);
    });

    it('changes when any signed field changes', () => {
      const base = signCreateOrder(order, 'secretkey');
      const changed = signCreateOrder({ ...order, description: 'other' }, 'secretkey');
      expect(base).not.toBe(changed);
    });

    it('is not affected by fields outside the signed set (e.g. an items array)', () => {
      const base = signCreateOrder(order, 'secretkey');
      const withExtra = signCreateOrder({ ...order, items: [{ sku: 'x' }] }, 'secretkey');
      expect(base).toBe(withExtra);
    });

    it('produces a lowercase hex string', () => {
      const hash = signCreateOrder(order, 'secretkey');
      expect(hash).toMatch(/^[0-9a-f]{64}$/);
    });
  });

  describe('signStatus', () => {
    it('matches a manually-built SHA-256 of invoiceId·orderId·amount·currency·posId', () => {
      const expected = crypto
        .createHash('sha256')
        .update('inv1' + 'ord1' + '125.00' + '972' + '12' + '.' + 'secretkey', 'utf8')
        .digest('hex');

      const actual = signStatus(
        { invoiceId: 'inv1', orderId: 'ord1', amount: 125, currency: '972', posId: 12 },
        'secretkey'
      );

      expect(actual).toBe(expected);
    });
  });

  describe('sha256Hex', () => {
    it('is a plain SHA-256 hex digest, not HMAC', () => {
      expect(sha256Hex('abc')).toBe(crypto.createHash('sha256').update('abc', 'utf8').digest('hex'));
    });
  });
});
