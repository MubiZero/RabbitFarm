const { SupportContact } = require('../models');
const logger = require('../utils/logger');

/**
 * Официальный контакт поддержки — синглтон-строка id=1. Пока админ ничего не
 * задал, обе точки контакта просто `null`, и мобильный экран показывает
 * только фичу «Обращения» без внешнего канала.
 */
class SupportContactService {
  async get() {
    const [contact] = await SupportContact.findOrCreate({
      where: { id: 1 },
      defaults: { id: 1, email: null, phone: null }
    });
    return contact;
  }

  async update({ email, phone }) {
    const contact = await this.get();
    await contact.update({ email: email ?? null, phone: phone ?? null });
    logger.info('Support contact updated', { email: contact.email, phone: contact.phone });
    return contact;
  }
}

module.exports = new SupportContactService();
