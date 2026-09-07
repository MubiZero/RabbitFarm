const { buildDeepLink } = require('../../../../src/services/eskhata/eskhataDeepLink');

describe('eskhataDeepLink', () => {
  it('builds a deep link from the last path segment of the invoice URL', () => {
    const url = 'https://pay.eskhata.tj/api/v2.5/invoices/77.4368.some-guid';
    expect(buildDeepLink(url)).toBe('eskhata://pay/77.4368.some-guid');
  });

  it('ignores a trailing slash', () => {
    const url = 'https://pay.eskhata.tj/invoices/77.4368.guid/';
    expect(buildDeepLink(url)).toBe('eskhata://pay/77.4368.guid');
  });
});
