const crypto = require('crypto');
const { Op } = require('sequelize');
const { User, Invitation, RefreshToken } = require('../models');
const PasswordUtil = require('../utils/password');
const logger = require('../utils/logger');

const INVITE_TTL_DAYS = 7;

/**
 * Работники фермы и приглашения.
 *
 * Почты у сервиса нет, поэтому приглашение — код, который владелец передаёт
 * человеку сам. В базе лежит только хеш кода: показывается он один раз,
 * при создании. Потерянное приглашение отзывается и выписывается заново.
 */
class StaffService {
  /** Хеш кода: тот же алгоритм при создании и при активации. */
  hashToken(token) {
    return crypto.createHash('sha256').update(token).digest('hex');
  }

  /**
   * Состав фермы: владелец и его работники.
   * @param {Number} farmId - id владельца
   */
  async listMembers(farmId) {
    return User.findAll({
      where: { [Op.or]: [{ id: farmId }, { owner_id: farmId }] },
      attributes: ['id', 'email', 'full_name', 'phone', 'role', 'is_active', 'owner_id', 'created_at'],
      order: [['created_at', 'ASC']]
    });
  }

  /**
   * Создать приглашение.
   * @returns {Object} приглашение и код — код возвращается единственный раз
   */
  async createInvitation(farmId, authorId, { email, role }) {
    const normalizedEmail = email.trim().toLowerCase();

    const existingUser = await User.findOne({ where: { email: normalizedEmail } });
    if (existingUser) {
      throw new Error('USER_EXISTS');
    }

    // Второе действующее приглашение на тот же адрес только путает:
    // старое отзываем молча.
    await Invitation.destroy({
      where: { farm_id: farmId, email: normalizedEmail, accepted_at: null }
    });

    const token = crypto.randomBytes(24).toString('base64url');
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + INVITE_TTL_DAYS);

    const invitation = await Invitation.create({
      farm_id: farmId,
      email: normalizedEmail,
      role,
      token_hash: this.hashToken(token),
      expires_at: expiresAt,
      created_by: authorId
    });

    logger.info('Invitation created', { invitationId: invitation.id, farmId, role });
    return { invitation, token };
  }

  /** Действующие приглашения фермы. */
  async listInvitations(farmId) {
    return Invitation.findAll({
      where: { farm_id: farmId, accepted_at: null },
      attributes: ['id', 'email', 'role', 'expires_at', 'created_at'],
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
  async acceptInvitation(token, { password, full_name: fullName, phone }) {
    const invitation = await Invitation.findOne({
      where: { token_hash: this.hashToken(token), accepted_at: null }
    });

    // Просроченное и несуществующее приглашение неотличимы снаружи:
    // так код нельзя подобрать перебором.
    if (!invitation || invitation.expires_at < new Date()) {
      throw new Error('INVITATION_INVALID');
    }

    const existingUser = await User.findOne({ where: { email: invitation.email } });
    if (existingUser) {
      throw new Error('USER_EXISTS');
    }

    const user = await User.create({
      email: invitation.email,
      password_hash: await PasswordUtil.hash(password),
      full_name: fullName,
      phone: phone || null,
      role: invitation.role,
      owner_id: invitation.farm_id
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
      where: { id: memberId, owner_id: farmId }
    });
    if (!member) {
      throw new Error('MEMBER_NOT_FOUND');
    }

    const temporaryPassword = crypto.randomBytes(9).toString('base64url');
    await member.update({ password_hash: await PasswordUtil.hash(temporaryPassword) });

    // Старые сессии работника перестают действовать: иначе смена пароля
    // не отбирает доступ у того, кто уже вошёл.
    await RefreshToken.destroy({ where: { user_id: member.id } });

    logger.info('Staff password reset', { memberId, farmId });
    return { member, temporaryPassword };
  }

  /**
   * Изменить работника: роль или доступ.
   * Владельца через этот метод менять нельзя — иначе ферма может остаться
   * без хозяина или работник поднимет сам себя.
   */
  async updateMember(farmId, memberId, { role, is_active: isActive }) {
    const member = await User.findOne({
      where: { id: memberId, owner_id: farmId }
    });
    if (!member) {
      throw new Error('MEMBER_NOT_FOUND');
    }

    const changes = {};
    if (role !== undefined) changes.role = role;
    if (isActive !== undefined) changes.is_active = isActive;

    await member.update(changes);
    logger.info('Staff member updated', { memberId, farmId, changes });
    return member;
  }
}

module.exports = new StaffService();
