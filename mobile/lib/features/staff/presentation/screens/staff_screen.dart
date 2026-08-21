import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../data/models/staff_models.dart';
import '../providers/staff_provider.dart';

/// Кто работает на ферме: состав, приглашения и доступы.
class StaffScreen extends ConsumerWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(farmMembersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Работники')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _inviteDialog(context, ref),
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Пригласить'),
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
            _SectionTitle('Владелец'),
            const SizedBox(height: 12),
            for (final member in owner) _MemberCard(member: member),
            const SizedBox(height: 24),
          ],
          _SectionTitle('Сотрудники'),
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
                      'На ферме пока только вы. Пригласите помощника — '
                      'он получит доступ к этому же хозяйству.',
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
              ),
          const SizedBox(height: 24),
          invitationsAsync.when(
            loading: () => const SkeletonBox(height: 80),
            error: (error, _) => AppCard(
              variant: AppCardVariant.error,
              child: Text(
                'Не удалось загрузить приглашения',
                style: AppTypography.bodyMd.copyWith(color: AppColors.error),
              ),
            ),
            data: (invitations) => invitations.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle('Ждут ответа'),
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
    try {
      await ref
          .read(staffRepositoryProvider)
          .updateMember(member.id, role: role, isActive: isActive);
      ref.invalidate(farmMembersProvider);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            isActive == false
                ? 'Доступ для ${member.fullName} закрыт'
                : 'Изменения сохранены',
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Отозвать приглашение?'),
        content: Text(
          'Код для ${invitation.email} перестанет работать. '
          'Выписать новый можно в любой момент.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Оставить'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Отозвать'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(staffRepositoryProvider).revokeInvitation(invitation.id);
      ref.invalidate(farmInvitationsProvider);
      messenger.showSnackBar(
        const SnackBar(content: Text('Приглашение отозвано')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
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

            setDialogState(() => isSending = true);
            try {
              final invitation = await ref
                  .read(staffRepositoryProvider)
                  .createInvitation(email: email, role: role);
              navigator.pop(invitation);
            } catch (e) {
              setDialogState(() => isSending = false);
              messenger.showSnackBar(
                SnackBar(
                  content: Text(e.toString().replaceAll('Exception: ', '')),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          }

          return AlertDialog(
            title: const Text('Пригласить на ферму'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'на него человек и войдёт',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Роль',
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
                  child: const Column(
                    children: [
                      RadioListTile<FarmRole>(
                        value: FarmRole.worker,
                        title: Text('Работник'),
                        subtitle: Text('Смотрит данные и отмечает работу'),
                        contentPadding: EdgeInsets.zero,
                      ),
                      RadioListTile<FarmRole>(
                        value: FarmRole.manager,
                        title: Text('Управляющий'),
                        subtitle: Text('Ведёт поголовье, корма и финансы'),
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
                child: const Text('Отмена'),
              ),
              FilledButton(
                onPressed: isSending ? null : submit,
                child: isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Выписать код'),
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
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Код приглашения'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Передайте этот код ${invitation.email} любым удобным способом. '
              'Второй раз он не покажется: сервер хранит только его отпечаток.',
              style: AppTypography.bodyMd.copyWith(
                color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SelectableText(
              invitation.code,
              style: AppTypography.titleMd.copyWith(
                fontFamily: 'monospace',
                color: Theme.of(dialogContext).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Действует до ${DateFormat('d MMMM', 'ru_RU').format(invitation.expiresAt)}',
              style: AppTypography.labelSm.copyWith(
                color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Закрыть'),
          ),
          FilledButton.icon(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(dialogContext);
              await Clipboard.setData(ClipboardData(text: invitation.code));
              await HapticFeedback.lightImpact();
              messenger.showSnackBar(
                const SnackBar(content: Text('Код скопирован')),
              );
            },
            icon: const Icon(Icons.copy_all_outlined),
            label: const Text('Скопировать'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: AppTypography.labelSm.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final FarmMember member;
  final ValueChanged<FarmRole>? onChangeRole;
  final VoidCallback? onToggleAccess;

  const _MemberCard({
    required this.member,
    this.onChangeRole,
    this.onToggleAccess,
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
                  }
                },
                itemBuilder: (context) => [
                  if (member.role != FarmRole.manager)
                    const PopupMenuItem(
                      value: 'manager',
                      child: Text('Сделать управляющим'),
                    ),
                  if (member.role != FarmRole.worker)
                    const PopupMenuItem(
                      value: 'worker',
                      child: Text('Сделать работником'),
                    ),
                  PopupMenuItem(
                    value: 'access',
                    child: Text(inactive ? 'Открыть доступ' : 'Закрыть доступ'),
                  ),
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
              child: const Text('Отозвать'),
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
