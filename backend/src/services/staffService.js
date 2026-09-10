const crypto = require('crypto');
const { Op } = require('sequelize');
const { User, Farm, Invitation, RefreshToken } = require('../models');
const PasswordUtil = require('../utils/password');
const planService = require('./planService');
const farmAuditService = require('./farmAuditService');
const payomSmsTransport = require('./notifications/payomSmsTransport');
const logger = require('../utils/logger');

const INVITE_TTL_DAYS = 7;

/**
 * Работники фермы и приглашения.
 *
 * Приглашение — код, который приглашённый вводит при вступлении. В базе
 * лежит только хеш кода: сам код показывается один раз, при создании.
 * Потерянное приглашение отзывается и выписывается заново.
 *
 * Код доходит до человека двумя путями. Если приглашение выписано на
 * телефон — уходит SMS-кой через шлюз Payom; если на email — владелец
 * передаёт его сам, как и раньше (рассылки приглашений по почте нет).
 * Целевой работник фермы чаще имеет телефон, чем почтовый ящик, поэтому
 * телефон — полноценная альтернатива адресу, а не довесок к нему.
 *
 * Кадровые изменения (роль, доступ, передача хозяйства) пишутся в журнал
 * фермы (`farmAuditService`): владельцу нужен ответ на «кто и когда понизил
 * Петра», а стдаут сервера ему недоступен.
 */
class StaffService {
  /** Хеш кода: тот же алгоритм при создании и при активации. */
  hashToken(token) {
    return crypto.createHash('sha256').update(token).digest('hex');
  }

  /**
   * Состав фермы: владелец и его работники.
   * @param {Number} farmId - id хозяйства
   */
  async listMembers(farmId) {
    return User.findAll({
      where: { farm_id: farmId },
      attributes: ['id', 'email', 'full_name', 'phone', 'role', 'is_active', 'farm_id', 'created_at'],
      order: [['created_at', 'ASC']]
    });
  }

  /**
   * Создать приглашение — на email или на телефон.
   *
   * Валидатор пропускает ровно одно из двух и приводит номер к виду
   * `+992XXXXXXXXX`, который принимает шлюз (см. `utils/phone.js`).
   *
   * @returns {Object} приглашение, код (возвращается единственный раз) и
   *   `smsSent` — ушла ли SMS. Код отдаётся всегда, в том числе когда SMS не
   *   ушла: тогда владелец передаёт его сам, как при приглашении по почте.
   */
  async createInvitation(farmId, authorId, { email, phone, role, full_name: fullName }) {
    await planService.assertStaffLimit(farmId);

    const normalizedEmail = email ? email.trim().toLowerCase() : null;
    const normalizedPhone = phone ? phone.trim() : null;

    // И адрес, и номер уникальны на всю базу — телефон стал основным
    // способом входа (OTP), у `users.phone` теперь тоже глобальный
    // unique-индекс, второго пользователя с ним не создать. Раньше здесь
    // была только проверка в пределах фермы («у семьи бывает один телефон») —
    // это было верно, пока номер был просто каналом доставки кода, а не
    // идентификатором аккаунта; теперь та же логика пустила бы приглашение,
    // которое на активации упало бы конфликтом уникальности.
    const existingUser = await User.findOne({
      where: normalizedEmail ? { email: normalizedEmail } : { phone: normalizedPhone }
    });
    if (existingUser) {
      throw new Error('USER_EXISTS');
    }

    // Второе действующее приглашение на тот же контакт только путает:
    // старое отзываем молча.
    await Invitation.destroy({
      where: normalizedEmail
        ? { farm_id: farmId, email: normalizedEmail, accepted_at: null }
        : { farm_id: farmId, phone: normalizedPhone, accepted_at: null }
    });

    const token = crypto.randomBytes(24).toString('base64url');
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + INVITE_TTL_DAYS);

    const invitation = await Invitation.create({
      farm_id: farmId,
      email: normalizedEmail,
      phone: normalizedPhone,
      role,
      full_name: fullName ? fullName.trim() : null,
      token_hash: this.hashToken(token),
      expires_at: expiresAt,
      created_by: authorId
    });

    logger.info('Invitation created', {
      invitationId: invitation.id,
      farmId,
      role,
      channel: normalizedPhone ? 'sms' : 'manual'
    });

    const smsSent = normalizedPhone ? await this._sendInvitationSms(invitation, token) : false;
    return { invitation, token, smsSent };
  }

  /**
   * Отправить код приглашения SMS-кой.
   *
   * Доставка best-effort, как у кода сброса пароля: не настроен шаблон или
   * шлюз отказал — приглашение всё равно выписано, а код владелец видит в
   * ответе и передаёт человеку сам. Поэтому же результат возвращается, а не
   * бросается: клиенту есть что сказать («SMS отправлена» или «продиктуйте
   * код»), вместо того чтобы гадать.
   *
   * Шаблон `staff.invitation` должен быть заведён в кабинете Payom и попасть
   * в `SMS_TEMPLATE_IDS` — шлюз свободный текст не принимает. Код длиннее
   * шестизначного, поэтому сообщение уходит двумя сегментами.
   */
  async _sendInvitationSms(invitation, token) {
    try {
      await payomSmsTransport.sendTemplateSms({
        templateKey: 'staff.invitation',
        telephone: invitation.phone,
        variables: { 'text-1': 'RabbitFarm', 'code-1': token }
      });
      logger.info('Invitation SMS sent', { invitationId: invitation.id });
      return true;
    } catch (error) {
      logger.warn('Invitation SMS dispatch failed', {
        invitationId: invitation.id,
        error: error.message
      });
      return false;
    }
  }

  /** Действующие приглашения фермы. */
  async listInvitations(farmId) {
    return Invitation.findAll({
      where: { farm_id: farmId, accepted_at: null },
      attributes: ['id', 'email', 'phone', 'role', 'expires_at', 'created_at'],
      order: [['created_at', 'DESC']]
    });
  }

  /** Отозвать приглашение. */
  async revokeInvitation(farmId, invitationId) {
    const invitation = await Invitation.findOne({
      where: { id: invitationId, farm_id: farmId, accepted_at: null }
    });
    if (!invitation) {
      throw new Error('INVITATION_NOT_FOUND');
    }

    await invitation.destroy();
    logger.info('Invitation revoked', { invitationId, farmId });
    return { success: true };
  }

  /**
   * Активировать приглашение: создаёт работника в ферме приглашающего.
   * @param {String} token - код из приглашения
   */
  async acceptInvitation(token, { email, password, full_name: fullName, phone }) {
    // Приглашённый ещё ни к одной ферме не привязан — искать его можно
    // только по коду, без условия по farm_id.
    const invitation = await Invitation.findOne({
      where: { token_hash: this.hashToken(token), accepted_at: null },
      tenantScope: 'all'
    });

    // Просроченное и несуществующее приглашение неотличимы снаружи:
    // так код нельзя подобрать перебором.
    if (!invitation || invitation.expires_at < new Date()) {
      throw new Error('INVITATION_INVALID');
    }

    // Приглашение по телефону адреса не несёт, а вход в сервис пока только
    // по email — поэтому его называет сам приглашённый. У приглашения по
    // почте адрес уже есть, и подменить его нельзя: иначе кодом, выписанным
    // на один адрес, заводили бы учётку на любой другой.
    const targetEmail = invitation.email || (email ? email.trim().toLowerCase() : null);
    if (!targetEmail) {
      throw new Error('EMAIL_REQUIRED');
    }

    const existingUser = await User.findOne({ where: { email: targetEmail } });
    if (existingUser) {
      throw new Error('USER_EXISTS');
    }

    // Лимит могли зачерпнуть уже после того, как приглашение выписали:
    // за неделю его действия ферма могла добрать штат другим путём.
    await planService.assertStaffLimit(invitation.farm_id);

    const user = await User.create({
      email: targetEmail,
      password_hash: await PasswordUtil.hash(password),
      full_name: fullName,
      // Номер, на который звали, уже проверен владельцем — он и остаётся у
      // работника, если тот не назвал другой.
      phone: phone || invitation.phone || null,
      role: invitation.role,
      farm_id: invitation.farm_id
    });

    await invitation.update({ accepted_at: new Date() });

    logger.info('Invitation accepted', { invitationId: invitation.id, userId: user.id });
    return user;
  }

  /**
   * Сбросить пароль работнику.
   *
   * Почтового сервера нет, поэтому самостоятельное восстановление невозможно:
   * временный пароль задаёт владелец и передаёт человеку сам. Возвращается
   * он один раз — в базе, как обычно, лежит только хеш.
   */
  async resetMemberPassword(farmId, memberId) {
    const member = await User.findOne({
      where: { id: memberId, farm_id: farmId, role: { [Op.ne]: 'owner' } }
    });
    if (!member) {
      throw new Error('MEMBER_NOT_FOUND');
    }

    const temporaryPassword = crypto.randomBytes(9).toString('base64url');

    // Старые сессии работника перестают действовать: иначе смена пароля
    // не отбирает доступ у того, кто уже вошёл. Отметка времени закрывает и
    // уже выданные access-токены, которые живут ещё несколько минут.
    await member.update({
      password_hash: await PasswordUtil.hash(temporaryPassword),
      token_version: (member.token_version || 0) + 1
    });
    await RefreshToken.destroy({ where: { user_id: member.id } });

    logger.info('Staff password reset', { memberId, farmId });
    return { member, temporaryPassword };
  }

  /**
   * Изменить работника: роль или доступ.
   * Владельца через этот метод менять нельзя — иначе ферма может остаться
   * без хозяина или работник поднимет сам себя. Раньше запрет выходил сам
   * собой: у владельца `owner_id` был пуст, и условие его не находило.
   * Теперь ферма записана у всех, включая хозяина, поэтому отказ явный.
   */
  async updateMember(farmId, actorId, memberId, { role, is_active: isActive }) {
    const member = await User.findOne({
      where: { id: memberId, farm_id: farmId, role: { [Op.ne]: 'owner' } }
    });
    if (!member) {
      throw new Error('MEMBER_NOT_FOUND');
    }

    const previous = { role: member.role, is_active: member.is_active };

    const changes = {};
    if (role !== undefined) changes.role = role;
    if (isActive !== undefined) changes.is_active = isActive;

    await member.update(changes);
    logger.info('Staff member updated', { memberId, farmId, changes });

    // В журнал идёт только то, что действительно поменялось: повторная
    // отправка той же роли — не событие, а шум, за которым потом не найти
    // настоящее понижение.
    if (changes.role !== undefined && changes.role !== previous.role) {
      await farmAuditService.record({
        farmId,
        actorId,
        action: 'staff.role_changed',
        targetUserId: member.id,
        before: { role: previous.role },
        after: { role: member.role }
      });
    }

    if (changes.is_active !== undefined && changes.is_active !== previous.is_active) {
      await farmAuditService.record({
        farmId,
        actorId,
        action: member.is_active ? 'staff.activated' : 'staff.deactivated',
        targetUserId: member.id,
        before: { is_active: previous.is_active },
        after: { is_active: member.is_active }
      });
    }

    return member;
  }

  /**
   * Передать хозяйство фермы активному работнику.
   *
   * Мгновенно, без подтверждения со стороны получателя: он уже
   * авторизованный участник этой же фермы, а не посторонний по коду, как в
   * приглашении. Прежний владелец становится управляющим — остаётся в
   * ферме с почти полным доступом, но без права передавать хозяйство
   * дальше или менять состав.
   */
  async transferOwnership(farmId, currentOwner, newOwnerId) {
    const newOwner = await User.findOne({
      where: { id: newOwnerId, farm_id: farmId, role: { [Op.ne]: 'owner' }, is_active: true }
    });
    if (!newOwner) {
      throw new Error('MEMBER_NOT_FOUND');
    }

    const previousRole = newOwner.role;

    const transaction = await User.sequelize.transaction();
    try {
      await Farm.update({ owner_id: newOwner.id }, { where: { id: farmId }, transaction });
      await newOwner.update({ role: 'owner' }, { transaction });
      await currentOwner.update({ role: 'manager' }, { transaction });
      await transaction.commit();
    } catch (error) {
      await transaction.rollback();
      throw error;
    }

    logger.info('Ownership transferred', {
      farmId,
      fromUserId: currentOwner.id,
      toUserId: newOwner.id
    });

    await farmAuditService.record({
      farmId,
      actorId: currentOwner.id,
      action: 'staff.ownership_transferred',
      targetUserId: newOwner.id,
      before: { owner_id: currentOwner.id, target_role: previousRole },
      after: { owner_id: newOwner.id, target_role: newOwner.role, actor_role: currentOwner.role }
    });

    return newOwner;
  }
}

module.exports = new StaffService();
