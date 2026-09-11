import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/phone_utils.dart';
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
        content: Text(context.l10n.staffRevokeBody(invitation.contact)),
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
    final phoneController = TextEditingController();
    final nameController = TextEditingController();
    var role = FarmRole.worker;
    // Телефон первым: вход в приложение теперь по номеру и коду из SMS, и
    // приглашение по почте нужно только тем, кого зовут к паролю.
    var byPhone = true;
    // Состояние отправки живёт снаружи builder: внутри оно пересоздавалось
    // на каждой перерисовке, кнопка не блокировалась, и приглашение можно
    // было выписать дважды подряд.
    var isSending = false;
    String? fieldError;

    final created = await showDialog<CreatedInvitation>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          Future<void> submit() async {
            final l10n = context.l10n;
            final email = emailController.text.trim();
            final phone = normalizeTjPhone(phoneController.text);
            final fullName = nameController.text.trim();

            if (byPhone) {
              if (!isTjPhone(phone)) {
                setDialogState(() => fieldError = l10n.staffInvitePhoneInvalid);
                return;
              }
              if (fullName.isEmpty) {
                setDialogState(() => fieldError = l10n.staffInviteNameEmpty);
                return;
              }
            } else if (email.isEmpty || !email.contains('@')) {
              setDialogState(() => fieldError = l10n.loginEmailInvalid);
              return;
            }

            // Берём до отправки: после await диалог может быть уже закрыт.
            final messenger = ScaffoldMessenger.of(dialogContext);
            final navigator = Navigator.of(dialogContext);

            setDialogState(() {
              isSending = true;
              fieldError = null;
            });
            try {
              final invitation =
                  await ref.read(staffRepositoryProvider).createInvitation(
                        email: byPhone ? null : email,
                        phone: byPhone ? phone : null,
                        fullName: byPhone ? fullName : null,
                        role: role,
                      );
              navigator.pop(invitation);
            } catch (e) {
              // Лимит тарифа не лечится другим адресом — приглашать больше
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
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(
                        value: true,
                        label: Text(context.l10n.staffInviteChannelPhone),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text(context.l10n.staffInviteChannelEmail),
                      ),
                    ],
                    selected: {byPhone},
                    onSelectionChanged: isSending
                        ? null
                        : (selection) => setDialogState(() {
                              byPhone = selection.first;
                              fieldError = null;
                            }),
                  ),
                  const SizedBox(height: 16),
                  if (byPhone) ...[
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      autofocus: true,
                      enabled: !isSending,
                      decoration: InputDecoration(
                        labelText: context.l10n.loginPhoneLabel,
                        hintText: context.l10n.staffInvitePhoneHint,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      enabled: !isSending,
                      decoration: InputDecoration(
                        labelText: context.l10n.staffInviteNameLabel,
                        hintText: context.l10n.staffInviteNameHint,
                      ),
                    ),
                  ] else
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      enabled: !isSending,
                      decoration: InputDecoration(
                        labelText: context.l10n.commonEmail,
                        hintText: context.l10n.staffInviteEmailHint,
                      ),
                    ),
                  if (fieldError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      fieldError!,
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.error),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    context.l10n.staffRole,
                    style: AppTypography.labelSm.copyWith(
                      color:
                          Theme.of(dialogContext).colorScheme.onSurfaceVariant,
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
    await _showInvitedDialog(context, created);
  }

  /// Приглашение выписано: объясняем владельцу, что делать работнику.
  /// Диктовать нечего — код придёт самому работнику, когда он введёт свой
  /// номер или почту на экране входа.
  Future<void> _showInvitedDialog(
    BuildContext context,
    CreatedInvitation invitation,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.staffInvitedTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              invitation.phone != null
                  ? context.l10n
                      .staffInvitedPhoneBody(formatTjPhone(invitation.phone!))
                  : context.l10n.staffInvitedEmailBody(invitation.contact),
              style: AppTypography.bodyMd.copyWith(
                color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.staffValidUntil(
                  DateFormat('d MMMM', 'ru').format(invitation.expiresAt)),
              style: AppTypography.labelSm.copyWith(
                color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.commonClose),
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
  final VoidCallback? onTransferOwnership;

  const _MemberCard({
    required this.member,
    this.onChangeRole,
    this.onToggleAccess,
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
                    member.contact,
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
            Icon(
              invitation.phone != null
                  ? Icons.sms_outlined
                  : Icons.mark_email_unread_outlined,
              color: cs.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invitation.contact,
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
