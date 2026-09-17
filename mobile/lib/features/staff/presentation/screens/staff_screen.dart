import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../data/models/staff_models.dart';
import '../providers/staff_provider.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/l10n/date_locale.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/l10n/error_text.dart';
import '../../../../core/api/api_failure.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Роль словами языка приложения. Раньше названия ролей лежали русскими
/// строками прямо в модели — таджикский фермер видел их по-русски.
String _roleLabel(BuildContext context, FarmRole role) => switch (role) {
      FarmRole.owner => context.l10n.roleOwner,
      FarmRole.manager => context.l10n.roleManager,
      FarmRole.worker => context.l10n.roleWorker,
    };

/// Дата дня и месяца на языке приложения («5 марта»).
String _dayLabel(BuildContext context, DateTime date) =>
    DateFormat('d MMMM', dateSymbolsLocale(Localizations.localeOf(context)))
        .format(date);

/// Кто работает на ферме: состав, приглашения и доступы.
class StaffScreen extends ConsumerWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(farmMembersProvider);
    // Управляющий видит, кто работает на ферме, но состав меняет только
    // владелец — так же, как на сервере. Поэтому здесь спрятаны не сами
    // карточки, а всё, что состав меняет: приглашение, роли, доступ, передача
    // хозяйства.
    final canManage = ref.watch(canProvider(FarmCapability.manageStaff));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.staffTitle)),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => _inviteDialog(context, ref),
              icon: const Icon(Icons.person_add_alt),
              label: Text(context.l10n.staffInvite),
            )
          : null,
      body: membersAsync.when(
        loading: () => const _StaffSkeleton(),
        error: (error, _) => AppErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(farmMembersProvider),
        ),
        data: (members) => _buildContent(context, ref, members, canManage),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<FarmMember> members,
    bool canManage,
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
                onChangeRole: canManage
                    ? (role) => _updateMember(context, ref, member, role: role)
                    : null,
                onToggleAccess: canManage
                    ? () => _updateMember(
                          context,
                          ref,
                          member,
                          isActive: !member.isActive,
                        )
                    : null,
                onTransferOwnership: canManage
                    ? () => _transferOwnership(context, ref, member)
                    : null,
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
            data: (invitations) =>
                _buildInvitations(context, ref, invitations, canManage),
          ),
        ],
      ),
    );
  }

  /// Приглашения двумя группами.
  ///
  /// Просроченное приглашение выглядело как живое — с датой в прошлом и
  /// единственным действием «Отозвать»; владелец видел, что человека
  /// «ждут», а войти тот уже не мог. Теперь просроченные стоят отдельно, и
  /// у обеих групп есть «Пригласить заново»: живое приглашение тоже нужно
  /// звать повторно — хотя бы чтобы снова достать ссылку, которую владелец
  /// закрыл, не переслав.
  Widget _buildInvitations(
    BuildContext context,
    WidgetRef ref,
    List<FarmInvitation> invitations,
    bool canManage,
  ) {
    if (invitations.isEmpty) return const SizedBox.shrink();

    final live = invitations.where((i) => !i.isExpired).toList();
    final expired = invitations.where((i) => i.isExpired).toList();

    Widget card(FarmInvitation invitation) => _InvitationCard(
          invitation: invitation,
          onRevoke: canManage
              ? () => _revokeInvitation(context, ref, invitation)
              : null,
          onResend: canManage
              ? () => _resendInvitation(context, ref, invitation)
              : null,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (live.isNotEmpty) ...[
          AppGroupLabel(context.l10n.staffPendingInvites),
          const SizedBox(height: AppSpacing.md),
          for (final invitation in live) card(invitation),
        ],
        if (expired.isNotEmpty) ...[
          if (live.isNotEmpty) const SizedBox(height: AppSpacing.md),
          AppGroupLabel(context.l10n.staffExpiredInvites),
          const SizedBox(height: AppSpacing.md),
          for (final invitation in expired) card(invitation),
        ],
      ],
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

  /// Позвать того же человека ещё раз: сервер продлевает срок и повторяет
  /// отправку, а владелец снова видит ссылку — ту самую, которую нужно
  /// переслать, если SMS не уходит.
  Future<void> _resendInvitation(
    BuildContext context,
    WidgetRef ref,
    FarmInvitation invitation,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      final created = await ref
          .read(staffRepositoryProvider)
          .resendInvitation(invitation.id);
      ref.invalidate(farmInvitationsProvider);
      if (!context.mounted) return;
      await _showInvitedDialog(context, created);
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
            } else if (email.isEmpty || !email.contains('@')) {
              setDialogState(() => fieldError = l10n.loginEmailInvalid);
              return;
            }

            // Имя нужно для обоих способов: сервер требует его всегда
            // (staffValidator.createInvitationSchema). Пока поле показывали
            // только для телефона, приглашение по почте отвечало отказом про
            // поле, которого человек не видел.
            if (fullName.isEmpty) {
              setDialogState(() => fieldError = l10n.staffInviteNameEmpty);
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
                        fullName: fullName,
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
                  if (byPhone)
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      autofocus: true,
                      enabled: !isSending,
                      decoration: InputDecoration(
                        labelText: context.l10n.loginPhoneLabel,
                        hintText: context.l10n.staffInvitePhoneHint,
                      ),
                    )
                  else
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
                  const SizedBox(height: 12),
                  // Имя спрашиваем независимо от способа приглашения: сервер
                  // требует его всегда, а показывали поле только в ветке
                  // «по телефону» — приглашение по почте отвечало отказом про
                  // невидимое поле и не проходило ни разу.
                  TextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    enabled: !isSending,
                    decoration: InputDecoration(
                      labelText: context.l10n.staffInviteNameLabel,
                      hintText: context.l10n.staffInviteNameHint,
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
                          subtitle: Text(context.l10n.roleWorkerDescription),
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<FarmRole>(
                          value: FarmRole.manager,
                          title: Text(context.l10n.roleManager),
                          subtitle: Text(context.l10n.roleManagerDescription),
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

  /// Приглашение выписано: говорим владельцу, что на самом деле произошло.
  ///
  /// Раньше здесь стояло «ничего передавать не нужно» — и это было неправдой
  /// для приглашения по телефону: SMS не уходила вовсе (шлюз принимает
  /// только заранее одобренные шаблоны), работник ничего не получал и ждал.
  /// На телефон сообщение не уходит вовсе, на почту — уходит письмо.
  /// Ушло — сказать об этом и замолчать: ссылка под «мы уже позвали» только
  /// заставляет гадать, нужно ли ещё что-то сделать. Не ушло — дать ссылку
  /// для пересылки руками, в тот мессенджер, которым человек пользуется.
  Future<void> _showInvitedDialog(
    BuildContext context,
    CreatedInvitation invitation,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final link = invitation.messageSent ? null : invitation.inviteLink;

    final body = invitation.phone != null
        ? l10n.staffInvitedPhoneBody(formatTjPhone(invitation.phone!))
        : (invitation.messageSent
            ? l10n.staffInvitedEmailBody(invitation.contact)
            : l10n.staffInvitedEmailFailedBody(invitation.contact));

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.staffInvitedTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                body,
                style: AppTypography.bodyMd
                    .copyWith(color: dialogContext.colors.onSurfaceVariant),
              ),
              if (link != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.staffInviteLinkLabel,
                  style: AppTypography.labelSm
                      .copyWith(color: dialogContext.colors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs),
                // Ссылка видна целиком: владелец может продиктовать или
                // набрать её руками, если копировать некуда.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: dialogContext.colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: SelectableText(
                    link,
                    style: AppTypography.labelSm
                        .copyWith(color: dialogContext.colors.onSurface),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.staffValidUntil(
                    _dayLabel(dialogContext, invitation.expiresAt)),
                style: AppTypography.labelSm
                    .copyWith(color: dialogContext.colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
        actions: [
          if (link != null)
            TextButton.icon(
              // Диалог закрывается сразу: дальше владелец идёт вставлять
              // приглашение в мессенджер, а подтверждение под открытым
              // диалогом всё равно оказалось бы за затемнением.
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: l10n.staffInviteMessage(link)),
                );
                if (dialogContext.mounted) Navigator.pop(dialogContext);
                messenger.showSnackBar(
                  SnackBar(content: Text(l10n.staffInviteCopied)),
                );
              },
              icon: const Icon(Icons.copy_outlined),
              label: Text(l10n.staffInviteCopy),
            ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonClose),
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
                        ? '${_roleLabel(context, member.role)} · '
                            '${context.l10n.staffAccessClosedBadge}'
                        : _roleLabel(context, member.role),
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
                    child: Text(inactive
                        ? context.l10n.staffOpenAccess
                        : context.l10n.staffCloseAccess),
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
  final VoidCallback? onRevoke;
  final VoidCallback? onResend;

  const _InvitationCard({
    required this.invitation,
    this.onRevoke,
    this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final expired = invitation.isExpired;
    final day = _dayLabel(context, invitation.expiresAt);
    final role = _roleLabel(context, invitation.role);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  // У просроченного приглашения свой значок: строку с датой
                  // на карточке читают не всегда, а «песочные часы» видно
                  // сразу.
                  expired
                      ? Icons.hourglass_disabled_outlined
                      : (invitation.phone != null
                          ? Icons.sms_outlined
                          : Icons.mark_email_unread_outlined),
                  color: expired ? AppColors.warning : cs.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invitation.contact,
                        style:
                            AppTypography.bodyMd.copyWith(color: cs.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        expired
                            ? context.l10n.staffInviteCardExpired(role, day)
                            : context.l10n.staffInviteCardLive(role, day),
                        style: AppTypography.labelSm.copyWith(
                          color:
                              expired ? AppColors.warning : cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (onResend != null || onRevoke != null)
              // Кнопки под строкой, а не в ней: два действия рядом с
              // контактом сжимали бы его до многоточия на первом же длинном
              // адресе.
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: AppSpacing.sm,
                  children: [
                    if (onRevoke != null)
                      TextButton(
                        onPressed: onRevoke,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                        ),
                        child: Text(context.l10n.staffRevoke),
                      ),
                    if (onResend != null)
                      TextButton(
                        onPressed: onResend,
                        child: Text(context.l10n.staffInviteAgain),
                      ),
                  ],
                ),
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
