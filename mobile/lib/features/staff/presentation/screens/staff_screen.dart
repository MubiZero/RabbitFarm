import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/staff_models.dart';
import '../providers/staff_provider.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/l10n/error_text.dart';
import '../../../../core/api/api_failure.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Кто работает на ферме: состав, приглашения и доступы.
class StaffScreen extends ConsumerWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(farmMembersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.staffTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _inviteDialog(context, ref),
        icon: const Icon(Icons.person_add_alt),
        label: Text(context.l10n.staffInvite),
      ),
      body: membersAsync.when(
        loading: () => const _StaffSkeleton(),
        error: (error, _) => AppErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(farmMembersProvider),
        ),
        data: (members) => _buildContent(context, ref, members),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<FarmMember> members,
  ) {
    final staff = members.where((m) => !m.isOwner).toList();
    final owner = members.where((m) => m.isOwner).toList();
    final invitationsAsync = ref.watch(farmInvitationsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(farmMembersProvider);
        ref.invalidate(farmInvitationsProvider);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          if (owner.isNotEmpty) ...[
            AppGroupLabel(context.l10n.staffOwner),
            const SizedBox(height: 12),
            for (final member in owner) _MemberCard(member: member),
            const SizedBox(height: 24),
          ],
          AppGroupLabel(context.l10n.staffMembers),
          const SizedBox(height: 12),
          if (staff.isEmpty)
            AppCard(
              child: Row(
                children: [
                  Icon(
                    Icons.groups_outlined,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.l10n.staffEmptyBody,
                      style: AppTypography.bodyMd.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            for (final member in staff)
              _MemberCard(
                member: member,
                onChangeRole: (role) => _updateMember(
                  context,
                  ref,
                  member,
                  role: role,
                ),
                onToggleAccess: () => _updateMember(
                  context,
                  ref,
                  member,
                  isActive: !member.isActive,
                ),
                onResetPassword: () => _resetPassword(context, ref, member),
                onTransferOwnership: () =>
                    _transferOwnership(context, ref, member),
              ),
          const SizedBox(height: 24),
          invitationsAsync.when(
            loading: () => const SkeletonBox(height: 80),
            error: (error, _) => AppCard(
              variant: AppCardVariant.error,
              child: Text(
                context.l10n.staffInvitesFailed,
                style: AppTypography.bodyMd.copyWith(color: AppColors.error),
              ),
            ),
            data: (invitations) => invitations.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppGroupLabel(context.l10n.staffPendingInvites),
                      const SizedBox(height: 12),
                      for (final invitation in invitations)
                        _InvitationCard(
                          invitation: invitation,
                          onRevoke: () =>
                              _revokeInvitation(context, ref, invitation),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateMember(
    BuildContext context,
    WidgetRef ref,
    FarmMember member, {
    FarmRole? role,
    bool? isActive,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    // Тексты снимаются до запроса: экран может закрыться, пока идёт ответ.
    final closed = context.l10n.staffAccessClosed(member.fullName);
    final saved = context.l10n.staffSaved;
    try {
      await ref
          .read(staffRepositoryProvider)
          .updateMember(member.id, role: role, isActive: isActive);
      ref.invalidate(farmMembersProvider);
      messenger.showSnackBar(
        SnackBar(content: Text(isActive == false ? closed : saved)),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// Сброс пароля работнику: почты у сервиса нет, поэтому владелец
  /// получает временный пароль и передаёт его сам.
  Future<void> _resetPassword(
    BuildContext context,
    WidgetRef ref,
    FarmMember member,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.staffResetPasswordTitle),
        content: Text(context.l10n.staffResetPasswordBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.staffReset),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final password =
          await ref.read(staffRepositoryProvider).resetMemberPassword(member.id);
      if (!context.mounted) return;
      await _showSecretDialog(
        context,
        title: context.l10n.staffTempPassword,
        explanation: context.l10n.staffTempPasswordBody(member.fullName),
        secret: password,
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// Передача хозяйства мгновенна и необратима действием одной кнопки —
  /// поэтому подтверждение здесь жёстче, чем у смены роли.
  Future<void> _transferOwnership(
    BuildContext context,
    WidgetRef ref,
    FarmMember member,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final transferred = context.l10n.staffTransferred(member.fullName);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.staffTransferTitle),
        content: Text(context.l10n.staffTransferBody(member.fullName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
              foregroundColor: Theme.of(dialogContext).colorScheme.onError,
            ),
            child: Text(context.l10n.staffTransferConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(staffRepositoryProvider).transferOwnership(member.id);
      // Наша собственная роль сменилась на «управляющий» — без этого
      // локальный профиль продолжал бы считать нас владельцем до
      // следующего перелогина.
      await ref.read(authProvider.notifier).refreshProfile();
      if (!context.mounted) return;
      ref.invalidate(farmMembersProvider);
      messenger.showSnackBar(SnackBar(content: Text(transferred)));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _revokeInvitation(
    BuildContext context,
    WidgetRef ref,
    FarmInvitation invitation,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final revoked = context.l10n.staffRevoked;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.staffRevokeTitle),
        content: Text(context.l10n.staffRevokeBody(invitation.email)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.staffKeep),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.staffRevoke),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(staffRepositoryProvider).revokeInvitation(invitation.id);
      ref.invalidate(farmInvitationsProvider);
      messenger.showSnackBar(SnackBar(content: Text(revoked)));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _inviteDialog(BuildContext context, WidgetRef ref) async {
    final emailController = TextEditingController();
    var role = FarmRole.worker;

    final created = await showDialog<CreatedInvitation>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          var isSending = false;

          Future<void> submit() async {
            final email = emailController.text.trim();
            if (email.isEmpty || !email.contains('@')) return;

            // Берём до отправки: после await диалог может быть уже закрыт.
            final messenger = ScaffoldMessenger.of(dialogContext);
            final navigator = Navigator.of(dialogContext);
            final l10n = context.l10n;

            setDialogState(() => isSending = true);
            try {
              final invitation = await ref
                  .read(staffRepositoryProvider)
                  .createInvitation(email: email, role: role);
              navigator.pop(invitation);
            } catch (e) {
              // Лимит тарифа не лечится другим email — приглашать больше
              // некуда, пока не сменится тариф. Диалог с полем ввода тут
              // бесполезен: закрываем его и объясняем отдельно.
              if (e is ApiFailure && e.code == 'STAFF_LIMIT_REACHED') {
                navigator.pop();
                if (context.mounted) {
                  showPlanLimitReachedDialog(
                    context,
                    title: l10n.planLimitStaffTitle,
                    body: l10n.planLimitStaffBody,
                  );
                }
                return;
              }
              setDialogState(() => isSending = false);
              messenger.showSnackBar(
                SnackBar(
                  content: Text(errorText(l10n, e)),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          }

          return AlertDialog(
            title: Text(context.l10n.staffInviteTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.commonEmail,
                    hintText: context.l10n.staffInviteEmailHint,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  context.l10n.staffRole,
                  style: AppTypography.labelSm.copyWith(
                    color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                RadioGroup<FarmRole>(
                  groupValue: role,
                  onChanged: (value) {
                    if (value != null) setDialogState(() => role = value);
                  },
                  child: Column(
                    children: [
                      RadioListTile<FarmRole>(
                        value: FarmRole.worker,
                        title: Text(context.l10n.roleWorker),
                        subtitle: Text(FarmRole.worker.description),
                        contentPadding: EdgeInsets.zero,
                      ),
                      RadioListTile<FarmRole>(
                        value: FarmRole.manager,
                        title: Text(context.l10n.roleManager),
                        subtitle: Text(FarmRole.manager.description),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed:
                    isSending ? null : () => Navigator.pop(dialogContext),
                child: Text(context.l10n.commonCancel),
              ),
              FilledButton(
                onPressed: isSending ? null : submit,
                child: isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.l10n.staffIssueCode),
              ),
            ],
          );
        },
      ),
    );

    if (created == null || !context.mounted) return;

    ref.invalidate(farmInvitationsProvider);
    await _showCodeDialog(context, created);
  }

  /// Код показывается единственный раз — сервер хранит только его хеш.
  Future<void> _showCodeDialog(
    BuildContext context,
    CreatedInvitation invitation,
  ) async {
    await _showSecretDialog(
      context,
      title: context.l10n.staffInviteCode,
      explanation: context.l10n.staffInviteCodeBody(invitation.email),
      secret: invitation.code,
      footnote: context.l10n.staffValidUntil(
          DateFormat('d MMMM', 'ru').format(invitation.expiresAt)),
    );
  }

  /// Одноразовый секрет: показать, дать скопировать и не обещать повтора.
  Future<void> _showSecretDialog(
    BuildContext context, {
    required String title,
    required String explanation,
    required String secret,
    String? footnote,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              explanation,
              style: AppTypography.bodyMd.copyWith(
                color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SelectableText(
              secret,
              style: AppTypography.titleMd.copyWith(
                fontFamily: 'monospace',
                color: Theme.of(dialogContext).colorScheme.onSurface,
              ),
            ),
            if (footnote != null) ...[
              const SizedBox(height: 8),
              Text(
                footnote,
                style: AppTypography.labelSm.copyWith(
                  color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.commonClose),
          ),
          FilledButton.icon(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(dialogContext);
              final copied = dialogContext.l10n.staffCopied;
              await Clipboard.setData(ClipboardData(text: secret));
              await HapticFeedback.lightImpact();
              messenger.showSnackBar(
                SnackBar(content: Text(copied)),
              );
            },
            icon: const Icon(Icons.copy_all_outlined),
            label: Text(context.l10n.staffCopy),
          ),
        ],
      ),
    );
  }
}


class _MemberCard extends StatelessWidget {
  final FarmMember member;
  final ValueChanged<FarmRole>? onChangeRole;
  final VoidCallback? onToggleAccess;
  final VoidCallback? onResetPassword;
  final VoidCallback? onTransferOwnership;

  const _MemberCard({
    required this.member,
    this.onChangeRole,
    this.onToggleAccess,
    this.onResetPassword,
    this.onTransferOwnership,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final inactive = !member.isActive;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: inactive
                  ? cs.surfaceContainerHighest
                  : cs.primary.withValues(alpha: 0.12),
              child: Icon(
                member.isOwner ? Icons.star_outline : Icons.person_outline,
                color: inactive ? cs.onSurfaceVariant : cs.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.fullName,
                    style: AppTypography.bodyLg.copyWith(
                      color: inactive ? cs.onSurfaceVariant : cs.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    member.email,
                    style: AppTypography.labelSm
                        .copyWith(color: cs.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    inactive
                        ? '${member.role.label} · доступ закрыт'
                        : member.role.label,
                    style: AppTypography.labelSm.copyWith(
                      color: inactive ? AppColors.warning : cs.primary,
                    ),
                  ),
                ],
              ),
            ),
            if (onToggleAccess != null)
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'worker':
                      onChangeRole?.call(FarmRole.worker);
                    case 'manager':
                      onChangeRole?.call(FarmRole.manager);
                    case 'access':
                      onToggleAccess?.call();
                    case 'password':
                      onResetPassword?.call();
                    case 'transfer-ownership':
                      onTransferOwnership?.call();
                  }
                },
                itemBuilder: (context) => [
                  if (member.role != FarmRole.manager)
                    PopupMenuItem(
                      value: 'manager',
                      child: Text(context.l10n.staffMakeManager),
                    ),
                  if (member.role != FarmRole.worker)
                    PopupMenuItem(
                      value: 'worker',
                      child: Text(context.l10n.staffMakeWorker),
                    ),
                  PopupMenuItem(
                    value: 'password',
                    child: Text(context.l10n.staffResetPassword),
                  ),
                  PopupMenuItem(
                    value: 'access',
                    child: Text(inactive ? context.l10n.staffOpenAccess : context.l10n.staffCloseAccess),
                  ),
                  if (!inactive) ...[
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'transfer-ownership',
                      child: Row(
                        children: [
                          Icon(Icons.swap_horizontal_circle_outlined,
                              color: cs.error, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            context.l10n.staffTransferOwnership,
                            style: TextStyle(color: cs.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _InvitationCard extends StatelessWidget {
  final FarmInvitation invitation;
  final VoidCallback onRevoke;

  const _InvitationCard({required this.invitation, required this.onRevoke});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Row(
          children: [
            Icon(Icons.mark_email_unread_outlined, color: cs.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invitation.email,
                    style: AppTypography.bodyMd.copyWith(color: cs.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${invitation.role.label} · до '
                    '${DateFormat('d MMMM', 'ru_RU').format(invitation.expiresAt)}',
                    style: AppTypography.labelSm
                        .copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onRevoke,
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(context.l10n.staffRevoke),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaffSkeleton extends StatelessWidget {
  const _StaffSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: const [
        SkeletonBox(width: 100, height: 12),
        SizedBox(height: 12),
        SkeletonBox(height: 88),
        SizedBox(height: 24),
        SkeletonBox(width: 120, height: 12),
        SizedBox(height: 12),
        SkeletonBox(height: 88),
        SizedBox(height: 12),
        SkeletonBox(height: 88),
      ],
    );
  }
}
