const { Op } = require('sequelize');
const { User, Farm, Invitation, LoginOtp } = require('../models');
const authService = require('./authService');
const planService = require('./planService');
const logger = require('../utils/logger');
const { generateOtp, hashOtp } = require('../utils/otp');
const { normalizeTjPhone, isTjPhone } = require('../utils/phone');
const payomSmsTransport = require('./notifications/payomSmsTransport');
const emailTransport = require('./notifications/emailTransport');

const OTP_TTL_MINUTES = 10;
const OTP_MAX_ATTEMPTS = 5;
const OTP_REQUEST_WINDOW_MINUTES = 10;
const OTP_REQUEST_MAX_PER_WINDOW = 3;

/**
 * Вход по коду — единственный способ попасть в аккаунт.
 *
 * Телефон основной, почта запасная, но ведут себя они одинаково: человек
 * называет контакт, получает шестизначный код и входит. Пароля в сервисе нет
 * вовсе; короткий ПИН, которым закрывается приложение, живёт на самом
 * устройстве и сюда не доходит (см. README, «Accounts»).
 *
 * Приглашение сотрудника активируется тем же кодом: отдельного экрана
 * «введите код приглашения» нет ни для телефона, ни для почты.
 */
class OtpAuthService {
  /**
   * Привести контакт к виду, в котором он хранится и ищется.
   *
   * Телефон — строго `+992XXXXXXXXX` (см. `utils/phone.js`), почта — без
   * регистра и пробелов по краям: человек, набравший `Ivan@Farm.TJ` на
   * телефоне с автозаглавной, должен попасть в свой аккаунт, а не в пустоту.
   * @param {Object} contact
   * @param {String} [contact.phone]
   * @param {String} [contact.email]
   */
  resolveContact({ phone, email } = {}) {
    const hasPhone = typeof phone === 'string' && phone.trim() !== '';
    const hasEmail = typeof email === 'string' && email.trim() !== '';

    if (hasPhone === hasEmail) {
      // И пусто, и «оба сразу» — одинаково непонятно, куда слать код.
      throw new Error('CONTACT_REQUIRED');
    }

    if (hasPhone) {
      const normalized = normalizeTjPhone(phone);
      if (!isTjPhone(normalized)) {
        throw new Error('INVALID_PHONE');
      }
      return { identifier: normalized, channel: 'phone' };
    }

    const normalized = email.trim().toLowerCase();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalized)) {
      throw new Error('INVALID_EMAIL');
    }
    return { identifier: normalized, channel: 'email' };
  }

  /**
   * Запросить код. Отвечает успехом независимо от того, что нашлось за
   * контактом, но сам код создаётся и уходит только когда есть кому его
   * показать: иначе это и утечка данных о составе фермы, и трата SMS на
   * пустоту.
   * @param {Object} contact - `{ phone }` или `{ email }`
   */
  async requestOtp(contact) {
    const { identifier, channel } = this.resolveContact(contact);

    const windowStart = new Date();
    windowStart.setMinutes(windowStart.getMinutes() - OTP_REQUEST_WINDOW_MINUTES);
    const recentRequests = await LoginOtp.count({
      where: { identifier, created_at: { [Op.gte]: windowStart } }
    });
    if (recentRequests >= OTP_REQUEST_MAX_PER_WINDOW) {
      throw new Error('OTP_RATE_LIMITED');
    }

    const user = await this.findUserByContact(identifier, channel);
    const invitation = user ? null : await this.findInvitationByContact(identifier, channel);
    const validInvitation = invitation && invitation.expires_at > new Date() ? invitation : null;

    if (!user && !validInvitation) {
      logger.info('OTP requested for unknown contact', { channel });
      return { success: true };
    }

    if (user && !user.is_active) {
      // Отключённый аккаунт не должен узнавать о себе через рассылку кода.
      return { success: true };
    }

    // Прежние коды по этому контакту не удаляем: `verifyOtp` всё равно
    // смотрит только на самый свежий, а вот счётчик запросов выше считается
    // именно по этим записям. Снос делал его бессмысленным — в таблице
    // никогда не оказывалось больше одной строки, и `OTP_RATE_LIMITED` был
    // недостижим: ферму можно было засыпать SMS без ограничений.
    const code = generateOtp();
    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + OTP_TTL_MINUTES);

    await LoginOtp.create({
      identifier,
      channel,
      token_hash: hashOtp(code),
      expires_at: expiresAt
    });

    try {
      if (channel === 'phone') {
        await payomSmsTransport.sendTemplateSms({
          templateKey: 'user.verification_code',
          telephone: identifier,
          variables: { 'text-1': 'RabbitFarm', 'code-1': code }
        });
      } else {
        await emailTransport.sendLoginCodeEmail({ to: identifier, code });
      }
    } catch (dispatchError) {
      // Best-effort: код всё равно создан, доставка могла не дойти по
      // причинам на стороне шлюза — форма не должна на этом спотыкаться.
      logger.warn('Login OTP dispatch failed', { channel, error: dispatchError.message });
    }

    logger.info('Login OTP created', { channel, matched: user ? 'user' : 'invitation' });
    return { success: true };
  }

  /**
   * Проверить код и войти. Успех — либо вход в существующий аккаунт, либо
   * (для контакта с активным приглашением) создание работника на лету и
   * немедленный вход.
   * @param {Object} contact - `{ phone }` или `{ email }`
   * @param {String} code - 6-значный код
   */
  async verifyOtp(contact, code) {
    const { identifier, channel } = this.resolveContact(contact);

    const record = await LoginOtp.findOne({
      where: { identifier },
      order: [['created_at', 'DESC']]
    });
    if (!record) {
      throw new Error('OTP_INVALID');
    }

    // Снос и инкремент попыток должны пережить неудачную попытку, поэтому
    // идут не в транзакции с созданием пользователя.
    if (record.attempts >= OTP_MAX_ATTEMPTS) {
      await record.destroy();
      throw new Error('OTP_LOCKED');
    }

    if (new Date() > record.expires_at) {
      await record.destroy();
      throw new Error('OTP_EXPIRED');
    }

    if (hashOtp(code) !== record.token_hash) {
      await record.increment('attempts');
      throw new Error('OTP_INVALID');
    }

    await record.destroy();

    const user = await this.findUserByContact(identifier, channel, {
      include: [{ model: Farm, as: 'farm', attributes: ['id', 'status'] }]
    });

    if (user) {
      if (!user.is_active) {
        throw new Error('USER_INACTIVE');
      }
      await user.update({ last_login_at: new Date() });
      const tokens = await authService.issueTokens(user);
      logger.info('User logged in via OTP', { userId: user.id, channel });
      return { user: user.toJSON(), ...tokens };
    }

    const invitation = await this.findInvitationByContact(identifier, channel);
    if (!invitation || invitation.expires_at < new Date()) {
      // Состояние успело измениться между запросом кода и его вводом
      // (например, владелец отозвал приглашение) — код формально верный,
      // но активировать уже нечего.
      throw new Error('OTP_INVALID');
    }

    await planService.assertStaffLimit(invitation.farm_id);

    let newUser;
    try {
      newUser = await User.create({
        [channel === 'phone' ? 'phone' : 'email']: identifier,
        // Имя вводит владелец при создании приглашения — форма требует его.
        // Пустым оно может остаться только у приглашения, выписанного до
        // того, как имя стало обязательным.
        full_name: invitation.full_name || identifier,
        role: invitation.role,
        farm_id: invitation.farm_id
      });
    } catch (error) {
      // Приглашения на один контакт в двух разных фермах `createInvitation`
      // отклоняет заранее (см. `staffService`), но приглашение могло быть
      // выписано до этой проверки — не даём гонке дойти до 500.
      if (error.name === 'SequelizeUniqueConstraintError') {
        throw new Error('OTP_INVALID');
      }
      throw error;
    }
    await invitation.update({ accepted_at: new Date() });

    const farm = await Farm.findByPk(invitation.farm_id, { attributes: ['id', 'status'] });
    const userJson = newUser.toJSON();
    userJson.farm = farm ? { id: farm.id, status: farm.status } : null;

    const tokens = await authService.issueTokens(newUser);
    logger.info('Invitation activated via OTP', { invitationId: invitation.id, userId: newUser.id });
    return { user: userJson, ...tokens };
  }

  /** @private */
  async findUserByContact(identifier, channel, options = {}) {
    return User.findOne({
      where: { [channel === 'phone' ? 'phone' : 'email']: identifier },
      ...options
    });
  }

  /** @private */
  async findInvitationByContact(identifier, channel) {
    return Invitation.findOne({
      where: { [channel === 'phone' ? 'phone' : 'email']: identifier, accepted_at: null },
      tenantScope: 'all'
    });
  }
}

module.exports = new OtpAuthService();
