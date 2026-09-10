const { User, Farm, Invitation, LoginOtp } = require('../models');
const authService = require('./authService');
const planService = require('./planService');
const logger = require('../utils/logger');
const { generateOtp, hashOtp } = require('../utils/otp');
const { normalizeTjPhone, isTjPhone } = require('../utils/phone');
const payomSmsTransport = require('./notifications/payomSmsTransport');

const OTP_TTL_MINUTES = 10;
const OTP_MAX_ATTEMPTS = 5;
const OTP_REQUEST_WINDOW_MINUTES = 10;
const OTP_REQUEST_MAX_PER_WINDOW = 3;

/**
 * Вход по телефону. Основной способ для всех — и для владельца, и для
 * работника, приглашённого по номеру: код с SMS активирует приглашение сам,
 * без отдельного шага «код приглашения» на `/join`.
 *
 * Отдельный сервис, не часть `authService.js`: там уже пароль, профиль и
 * refresh-токены, а вход по телефону — самостоятельный сценарий с другим
 * набором ошибок и своей таблицей (`login_otps`).
 */
class OtpAuthService {
  /**
   * Запросить код. Отвечает успехом независимо от того, что нашлось за
   * номером — как `authService.forgotPassword` для email, только код и
   * правда уходит лишь тогда, когда за номером есть кому его показать
   * (иначе это и утечка данных о составе фермы, и трата SMS на пустоту).
   * @param {String} rawPhone
   */
  async requestOtp(rawPhone) {
    const phone = normalizeTjPhone(rawPhone);
    if (!isTjPhone(phone)) {
      throw new Error('INVALID_PHONE');
    }

    const windowStart = new Date();
    windowStart.setMinutes(windowStart.getMinutes() - OTP_REQUEST_WINDOW_MINUTES);
    const recentRequests = await LoginOtp.count({
      where: { phone, created_at: { [require('sequelize').Op.gte]: windowStart } }
    });
    if (recentRequests >= OTP_REQUEST_MAX_PER_WINDOW) {
      throw new Error('OTP_RATE_LIMITED');
    }

    const user = await User.findOne({ where: { phone } });
    const invitation = user
      ? null
      : await Invitation.findOne({
          where: { phone, accepted_at: null },
          tenantScope: 'all'
        });
    const validInvitation = invitation && invitation.expires_at > new Date() ? invitation : null;

    if (!user && !validInvitation) {
      logger.info('OTP requested for unknown phone', { phone });
      return { success: true };
    }

    if (user && !user.is_active) {
      // Отключённый аккаунт не должен узнавать о себе через рассылку кода —
      // тот же принцип, что и в `authService.login`.
      return { success: true };
    }

    await LoginOtp.destroy({ where: { phone } });

    const code = generateOtp();
    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + OTP_TTL_MINUTES);

    await LoginOtp.create({ phone, token_hash: hashOtp(code), expires_at: expiresAt });

    try {
      await payomSmsTransport.sendTemplateSms({
        templateKey: 'user.verification_code',
        telephone: phone,
        variables: { 'text-1': 'RabbitFarm', 'code-1': code }
      });
    } catch (dispatchError) {
      // Best-effort, как и у сброса пароля: код всё равно создан, SMS могла
      // не дойти по причинам на стороне шлюза — форма не должна на этом
      // спотыкаться.
      logger.warn('Login OTP dispatch failed', { phone, error: dispatchError.message });
    }

    logger.info('Login OTP created', { phone, matched: user ? 'user' : 'invitation' });
    return { success: true };
  }

  /**
   * Проверить код и войти. Успех — либо вход в уже существующий аккаунт,
   * либо (для нового номера с активным приглашением) создание работника на
   * лету и немедленный вход, без отдельного шага активации.
   * @param {String} rawPhone
   * @param {String} code - 6-значный код
   */
  async verifyOtp(rawPhone, code) {
    const phone = normalizeTjPhone(rawPhone);
    if (!isTjPhone(phone)) {
      throw new Error('INVALID_PHONE');
    }

    const record = await LoginOtp.findOne({ where: { phone }, order: [['created_at', 'DESC']] });
    if (!record) {
      throw new Error('OTP_INVALID');
    }

    // Как и в `authService.resetPassword`: снос/инкремент должны пережить
    // неудачную попытку, поэтому идут не в транзакции с созданием юзера.
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

    const user = await User.findOne({
      where: { phone },
      include: [{ model: Farm, as: 'farm', attributes: ['id', 'status'] }]
    });

    if (user) {
      if (!user.is_active) {
        throw new Error('USER_INACTIVE');
      }
      await user.update({ last_login_at: new Date() });
      const tokens = await authService.issueTokens(user);
      logger.info('User logged in via OTP', { userId: user.id, phone });
      return { user: user.toJSON(), ...tokens };
    }

    const invitation = await Invitation.findOne({
      where: { phone, accepted_at: null },
      tenantScope: 'all'
    });
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
        phone,
        // Владелец вводит имя при создании приглашения по телефону — форма
        // требует его для новых приглашений. Пустым оно может остаться только
        // у приглашения, выписанного до этой возможности.
        full_name: invitation.full_name || phone,
        role: invitation.role,
        farm_id: invitation.farm_id
      });
    } catch (error) {
      // Приглашения на один телефон в двух разных фермах `createInvitation`
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
}

module.exports = new OtpAuthService();
