const staffService = require('../services/staffService');
const farmAuditService = require('../services/farmAuditService');
const ApiResponse = require('../utils/apiResponse');
const appConfig = require('../config/app');

/**
 * Приглашение в том виде, в котором его получает приложение.
 *
 * `invite_link` — публичный адрес приглашения, один на всех: с
 * установленным приложением его перехватывает приложение, без него
 * открывается страница с магазинами и веб-версией. Ничего секретного и
 * ничего личного в нём нет — ни кода, ни номера: код придёт отдельно и
 * только самому работнику.
 *
 * `message_sent` говорит, ушло ли сообщение приглашённому. От этого
 * зависит, что приложение скажет владельцу — «мы позвали» или «перешлите
 * сами»: сообщение может не уйти и на почту (нет SMTP), и на телефон (пока
 * не заведён шаблон у payom), и владельцу в обоих случаях нужен способ
 * позвать руками.
 */
const invitationPayload = (invitation, messageSent) => ({
  id: invitation.id,
  email: invitation.email,
  phone: invitation.phone,
  full_name: invitation.full_name,
  role: invitation.role,
  expires_at: invitation.expires_at,
  invite_link: appConfig.inviteUrl,
  message_sent: messageSent
});

/** Что на самом деле произошло — одной строкой для владельца. */
const invitationMessage = (invitation, messageSent) => {
  if (messageSent) {
    return invitation.phone
      ? 'Приглашение создано, SMS работнику отправлена.'
      : 'Приглашение создано, письмо работнику отправлено.';
  }
  // Канал называется прямо: «сообщение не ушло» одинаково звучит и когда
  // нет SMTP, и когда у SMS-шлюза не заведён шаблон, а чинить это разные
  // люди и в разных местах.
  return invitation.phone
    ? 'Приглашение создано, но SMS работнику не ушла — перешлите ему ссылку сами.'
    : 'Приглашение создано, но письмо отправить не удалось — перешлите работнику ссылку сами.';
};

/**
 * Staff Controller
 * Работники фермы и приглашения.
 */
class StaffController {
  /** GET /staff — состав фермы */
  async listMembers(req, res, next) {
    try {
      const members = await staffService.listMembers(req.farmId);
      return ApiResponse.success(res, members, 'Состав фермы получен');
    } catch (error) {
      next(error);
    }
  }

  /** PATCH /staff/:id — роль и доступ работника */
  async updateMember(req, res, next) {
    try {
      const member = await staffService.updateMember(
        req.farmId,
        req.user.id,
        req.params.id,
        req.body
      );
      return ApiResponse.success(res, member, 'Работник обновлён');
    } catch (error) {
      if (error.message === 'MEMBER_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Работник не найден');
      }
      next(error);
    }
  }

  /** POST /staff/:id/transfer-ownership — передать хозяйство фермы */
  async transferOwnership(req, res, next) {
    try {
      const newOwner = await staffService.transferOwnership(
        req.farmId,
        req.user,
        req.params.id
      );
      return ApiResponse.success(res, newOwner, 'Хозяйство передано');
    } catch (error) {
      if (error.message === 'MEMBER_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Работник не найден');
      }
      next(error);
    }
  }

  /** POST /staff/invitations — выписать приглашение (email или телефон) */
  async createInvitation(req, res, next) {
    try {
      const { invitation, messageSent } = await staffService.createInvitation(
        req.farmId,
        req.user,
        req.body
      );

      // Кода в ответе нет: приглашённый входит обычным кодом на свой
      // контакт, и этот вход сам активирует приглашение. Владельцу
      // диктовать нечего — но ссылку, если SMS не ушла, переслать нужно.
      return ApiResponse.created(
        res,
        invitationPayload(invitation, messageSent),
        invitationMessage(invitation, messageSent)
      );
    } catch (error) {
      if (error.message === 'STAFF_LIMIT_REACHED') {
        return ApiResponse.badRequest(res, 'Достигнут лимит участников по тарифу фермы', 'STAFF_LIMIT_REACHED');
      }
      if (error.message === 'USER_EXISTS') {
        return ApiResponse.conflict(
          res,
          req.body.phone
            ? 'Работник с таким телефоном уже есть в ферме'
            : 'Пользователь с таким email уже существует',
          'USER_EXISTS'
        );
      }
      next(error);
    }
  }

  /** GET /staff/audit — журнал кадровых действий фермы */
  async listAudit(req, res, next) {
    try {
      const result = await farmAuditService.list(req.farmId, {
        page: req.query.page,
        limit: req.query.limit,
        scope: req.query.scope
      });

      return ApiResponse.paginated(
        res,
        result.items,
        result.pagination.page,
        result.pagination.limit,
        result.pagination.total,
        'Журнал действий получен'
      );
    } catch (error) {
      next(error);
    }
  }

  /** POST /staff/invitations/:id/resend — позвать ещё раз, продлив срок */
  async resendInvitation(req, res, next) {
    try {
      const { invitation, messageSent } = await staffService.resendInvitation(
        req.farmId,
        req.user,
        req.params.id
      );

      return ApiResponse.success(
        res,
        invitationPayload(invitation, messageSent),
        invitationMessage(invitation, messageSent)
      );
    } catch (error) {
      if (error.message === 'INVITATION_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Приглашение не найдено');
      }
      if (error.message === 'STAFF_LIMIT_REACHED') {
        return ApiResponse.badRequest(res, 'Достигнут лимит участников по тарифу фермы', 'STAFF_LIMIT_REACHED');
      }
      next(error);
    }
  }

  /** GET /staff/invitations — приглашения, которыми не воспользовались */
  async listInvitations(req, res, next) {
    try {
      const invitations = await staffService.listInvitations(req.farmId);
      return ApiResponse.success(res, invitations, 'Приглашения получены');
    } catch (error) {
      next(error);
    }
  }

  /** DELETE /staff/invitations/:id — отозвать приглашение */
  async revokeInvitation(req, res, next) {
    try {
      await staffService.revokeInvitation(req.farmId, req.params.id);
      return ApiResponse.success(res, null, 'Приглашение отозвано');
    } catch (error) {
      if (error.message === 'INVITATION_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Приглашение не найдено');
      }
      next(error);
    }
  }

}

module.exports = new StaffController();
