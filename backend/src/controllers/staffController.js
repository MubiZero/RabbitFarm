const staffService = require('../services/staffService');
const farmAuditService = require('../services/farmAuditService');
const ApiResponse = require('../utils/apiResponse');

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
      const { invitation } = await staffService.createInvitation(
        req.farmId,
        req.user.id,
        req.body
      );

      // Кода в ответе нет: приглашённый входит обычным кодом на свой
      // контакт, и этот вход сам активирует приглашение. Владельцу
      // показывать и диктовать нечего.
      return ApiResponse.created(
        res,
        {
          id: invitation.id,
          email: invitation.email,
          phone: invitation.phone,
          full_name: invitation.full_name,
          role: invitation.role,
          expires_at: invitation.expires_at,
          // Ссылка открывает приложение на экране входа с подставленным
          // номером — ничего секретного в ней нет.
          invite_link: invitation.phone
            ? `rabbitfarm://join?phone=${encodeURIComponent(invitation.phone)}`
            : null
        },
        invitation.phone
          ? 'Приглашение создано. Работник войдёт по своему номеру — код придёт ему в SMS.'
          : 'Приглашение создано. Работник войдёт по своей почте — код придёт письмом.'
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
        limit: req.query.limit
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

  /** GET /staff/invitations — действующие приглашения */
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
