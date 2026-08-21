const staffService = require('../services/staffService');
const authService = require('../services/authService');
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
      const member = await staffService.updateMember(req.farmId, req.params.id, req.body);
      return ApiResponse.success(res, member, 'Работник обновлён');
    } catch (error) {
      if (error.message === 'MEMBER_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Работник не найден');
      }
      next(error);
    }
  }

  /** POST /staff/:id/reset-password — задать работнику временный пароль */
  async resetMemberPassword(req, res, next) {
    try {
      const { member, temporaryPassword } = await staffService.resetMemberPassword(
        req.farmId,
        req.params.id
      );

      return ApiResponse.success(
        res,
        { id: member.id, email: member.email, temporary_password: temporaryPassword },
        'Временный пароль создан. Передайте его — второй раз он не покажется.'
      );
    } catch (error) {
      if (error.message === 'MEMBER_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Работник не найден');
      }
      next(error);
    }
  }

  /** POST /staff/invitations — выписать приглашение */
  async createInvitation(req, res, next) {
    try {
      const { invitation, token } = await staffService.createInvitation(
        req.farmId,
        req.user.id,
        req.body
      );

      // Код отдаётся ровно один раз: в базе лежит только его хеш.
      return ApiResponse.created(
        res,
        {
          id: invitation.id,
          email: invitation.email,
          role: invitation.role,
          expires_at: invitation.expires_at,
          code: token
        },
        'Приглашение создано. Передайте код — второй раз он не покажется.'
      );
    } catch (error) {
      if (error.message === 'USER_EXISTS') {
        return ApiResponse.conflict(res, 'Пользователь с таким email уже существует', 'USER_EXISTS');
      }
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

  /** POST /auth/accept-invitation — вступить в ферму по коду (без авторизации) */
  async acceptInvitation(req, res, next) {
    try {
      const { code, ...userData } = req.body;
      const user = await staffService.acceptInvitation(code, userData);

      // Сразу выдаём токены: отдельный вход после активации — лишний шаг.
      const tokens = await authService.issueTokens(user);

      return ApiResponse.created(
        res,
        { user: { id: user.id, email: user.email, full_name: user.full_name, role: user.role }, ...tokens },
        'Вы присоединились к ферме'
      );
    } catch (error) {
      if (error.message === 'INVITATION_INVALID') {
        return ApiResponse.error(
          res,
          'Приглашение недействительно или истекло. Попросите владельца выписать новое.',
          400,
          'INVITATION_INVALID'
        );
      }
      if (error.message === 'USER_EXISTS') {
        return ApiResponse.conflict(res, 'Пользователь с таким email уже существует', 'USER_EXISTS');
      }
      next(error);
    }
  }
}

module.exports = new StaffController();
