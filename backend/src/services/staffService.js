const { Op } = require('sequelize');
const { User, Farm, Invitation, RefreshToken } = require('../models');
const planService = require('./planService');
const farmAuditService = require('./farmAuditService');
const logger = require('../utils/logger');

const INVITE_TTL_DAYS = 7;

/**
 * Работники фермы и приглашения.
 *
 * Приглашение — это запись «такого-то человека ждут в этой ферме с такой-то
 * ролью», без собственного кода. Приглашённый входит обычным кодом на свой
 * контакт (`otpAuthService`), и первый же такой вход заводит ему учётку в
 * ферме, которая его позвала. Отдельного шага «введите код приглашения»
 * нет ни для телефона, ни для почты.
 *
 * Телефон — основной контакт: у работника фермы он есть чаще, чем почтовый
 * ящик, и код входа доходит SMS-кой.
 *
 * Кадровые изменения (роль, доступ, передача хозяйства) пишутся в журнал
 * фермы (`farmAuditService`): владельцу нужен ответ на «кто и когда понизил
 * Петра», а стдаут сервера ему недоступен.
 */
class StaffService {
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
   * Кода у приглашения нет: приглашённый входит обычным кодом на свой
   * контакт (`/auth/otp/*`), и этот же вход активирует приглашение. Раньше
   * здесь выписывался отдельный длинный токен, который показывался владельцу
   * и уходил SMS-кой, — вводить его стало некуда, и он только путал.
   *
   * @returns {Object} приглашение.
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

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + INVITE_TTL_DAYS);

    const invitation = await Invitation.create({
      farm_id: farmId,
      email: normalizedEmail,
      phone: normalizedPhone,
      role,
      full_name: fullName ? fullName.trim() : null,
      expires_at: expiresAt,
      created_by: authorId
    });

    logger.info('Invitation created', {
      invitationId: invitation.id,
      farmId,
      role,
      channel: normalizedPhone ? 'phone' : 'email'
    });

    return { invitation };
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
