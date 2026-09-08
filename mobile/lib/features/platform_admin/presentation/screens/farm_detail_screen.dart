import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/models/user_ref.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import '../providers/platform_admin_provider.dart';
import '../widgets/farm_delete_dialog.dart';
import '../widgets/farm_extras_dialog.dart';
import '../widgets/farm_status_labels.dart';
import '../widgets/farm_status_sheet.dart';
import '../widgets/farm_usage_row.dart';
import '../widgets/plan_summary.dart';

final _dayFormat = DateFormat('dd.MM.yyyy');
final _momentFormat = DateFormat('dd.MM.yyyy HH:mm');

/// Карточка одной фермы — экран, на котором делается вся работа с клиентом:
/// с кем связаться, что у фермы с доступом, тарифом и пределами, кто в составе,
/// чем платила и сколько занимает.
///
/// Строка в списке отвечает на «кому пора менять тариф», а поддержка почти
/// всегда про одно хозяйство — поэтому его факты и рычаги собраны вместе.
class FarmDetailScreen extends ConsumerWidget {
  const FarmDetailScreen({super.key, required this.farmId});

  final int farmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(platformFarmDetailProvider(farmId));

    return Scaffold(
      appBar: AppBar(
        // Пока ферма грузится, названия ещё нет — но и пустой заголовок
        // оставлять нельзя.
        title: Text(value.valueOrNull?.name ?? context.l10n.platformFarmTitleFallback),
      ),
      body: AppAsyncView<PlatformFarmDetail>(
        value: value,
        onRetry: () => ref.invalidate(platformFarmDetailProvider(farmId)),
        skeleton: (context) => const SkeletonList(
          padding: EdgeInsets.all(AppSpacing.screenH),
        ),
        builder: (farm) => RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(platformFarmDetailProvider(farmId)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.lg,
              AppSpacing.screenH,
              AppSpacing.xxl,
            ),
            children: [
              _Section(
                title: context.l10n.platformFarmSectionOwner,
                child: _OwnerCard(owner: farm.owner),
              ),
              _Section(
                title: context.l10n.platformFarmSectionAccess,
                child: _AccessCard(
                  farm: farm,
                  // Ферма на пути к удалению: править её доступ и пределы
                  // незачем, пока не решено, что она останется.
                  onChange: farm.isDeleted
                      ? null
                      : () => _changeStatus(context, ref, farm),
                ),
              ),
              _Section(
                title: context.l10n.platformFarmSectionPlan,
                child: _PlanCard(farm: farm),
              ),
              _Section(
                title: context.l10n.platformFarmSectionExtras,
                child: _ExtrasCard(
                  farm: farm,
                  onEdit:
                      farm.isDeleted ? null : () => _editExtras(context, ref, farm),
                ),
              ),
              _Section(
                title: context.l10n.platformFarmSectionUsage,
                child: _UsageCard(farm: farm),
              ),
              _Section(
                title: context.l10n.platformFarmSectionStaff,
                child: _StaffList(staff: farm.staff),
              ),
              _Section(
                title: context.l10n.platformFarmSectionPayments,
                child: _PaymentsList(payments: farm.payments),
              ),
              _Section(
                title: context.l10n.platformFarmSectionFacts,
                child: _FactsCard(farm: farm),
              ),
              _Section(
                title: context.l10n.platformFarmSectionExport,
                child: _ExportCard(
                  onOpen: () => context.push(
                    '/platform-admin/farms/${farm.id}/export',
                    extra: farm.name,
                  ),
                ),
              ),
              // Удаление — последним и отдельно, тревожным цветом: до него
              // нельзя дотянуться, пока листаешь факты о ферме.
              _Section(
                title: context.l10n.platformFarmSectionDanger,
                titleColor: AppColors.error,
                child: farm.isDeleted
                    ? _DeletedCard(
                        farm: farm,
                        onRestore: () => _restore(context, ref, farm),
                      )
                    : _DeleteCard(onDelete: () => _delete(context, ref, farm)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Смена уровня доступа: выбор, затем подтверждение.
  ///
  /// Подтверждение здесь не формальность: ферма теряет возможность работать в
  /// тот же миг, и человек на другом конце этого не заказывал.
  Future<void> _changeStatus(
    BuildContext context,
    WidgetRef ref,
    PlatformFarmDetail farm,
  ) async {
    final l10n = context.l10n;

    final choice = await showFarmStatusPicker(
      context,
      farmName: farm.name,
      currentStatus: farm.status,
    );
    if (choice == null || !context.mounted) return;
    // Выбрали то же самое — запрос не нужен.
    if (choice == farm.status) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(farmStatusIcon(choice), color: farmStatusColor(context, choice)),
        title: Text(l10n.platformFarmStatusConfirmTitle),
        content: Text(
          l10n.platformFarmStatusConfirmBody(farmStatusLabel(context, choice)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(
              foregroundColor: farmStatusColor(context, choice),
            ),
            child: Text(l10n.platformFarmStatusApply),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final done = l10n.platformFarmStatusUpdated;

    final error = await ref
        .read(platformFarmDetailProvider(farm.id).notifier)
        .updateStatus(choice);

    _report(messenger, l10n, error: error, success: done);
  }

  Future<void> _editExtras(
    BuildContext context,
    WidgetRef ref,
    PlatformFarmDetail farm,
  ) async {
    final l10n = context.l10n;

    final choice = await showFarmExtrasDialog(context, farm: farm);
    if (choice == null || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    // Пустой выбор — это снятие поблажки, и сказать об этом надо именно так:
    // «обновлена» на снятие звучало бы как «что-то поменяли, а что — гадай».
    final cleared = choice.extraRabbits == null && choice.extraStaff == null;
    final done = cleared
        ? l10n.platformFarmExtrasCleared
        : l10n.platformFarmExtrasSaved;

    final error = await ref
        .read(platformFarmDetailProvider(farm.id).notifier)
        .updateExtras(
          extraRabbits: choice.extraRabbits,
          extraStaff: choice.extraStaff,
          extrasUntil: choice.extrasUntil,
        );

    _report(messenger, l10n, error: error, success: done);
  }

  /// Удаление с двойным подтверждением: последствия словами и название,
  /// набранное вручную.
  ///
  /// Сам запрос делает диалог — не совпавшее название он показывает под полем
  /// ввода, а не снекбаром: это ошибка формы, а не сбой.
  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    PlatformFarmDetail farm,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final done = l10n.platformFarmDeleted;

    final outcome = await showFarmDeleteDialog(
      context,
      farm: farm,
      onConfirm: (confirmName) => ref
          .read(platformFarmDetailProvider(farm.id).notifier)
          .deleteFarm(farm.id, confirmName),
    );
    // Диалог закрыли, ничего не решив.
    if (outcome == null) return;

    if (!outcome.deleted) {
      _report(messenger, l10n, error: outcome.error, success: done);
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(done)));
    // Дальше на карточке удалённой фермы делать нечего — админ пришёл сюда из
    // списка, туда и возвращается. `maybePop`, а не `context.pop()`: экран
    // монтируют и обычным Navigator (так он открывается в тестах), а пустой
    // стек — не повод падать.
    await navigator.maybePop();
  }

  /// Отмена удаления. Без подтверждения: это возврат к прежнему состоянию.
  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    PlatformFarmDetail farm,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final done = l10n.platformFarmRestored;

    final error = await ref
        .read(platformFarmDetailProvider(farm.id).notifier)
        .restoreFarm(farm.id);

    _report(messenger, l10n, error: error, success: done);
  }

  void _report(
    ScaffoldMessengerState messenger,
    AppLocalizations l10n, {
    required Object? error,
    required String success,
  }) {
    messenger.showSnackBar(
      error == null
          ? SnackBar(content: Text(success))
          : SnackBar(
              content: Text(errorText(l10n, error)),
              backgroundColor: AppColors.error,
            ),
    );
  }
}

/// Смысловой блок карточки: тихая подпись и содержимое под ней.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.titleColor});

  final String title;
  final Widget child;

  /// Цвет подписи — для блока, к которому подходят с осторожностью.
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppGroupLabel(title, color: titleColor),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _OwnerCard extends StatelessWidget {
  const _OwnerCard({required this.owner});

  final UserRef? owner;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (owner == null) {
      return AppCard(child: _Muted(l10n.platformOwnerMissing));
    }

    final contacts = [owner!.email, owner!.phone]
        .whereType<String>()
        .where((part) => part.trim().isNotEmpty)
        .toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            owner!.fullName,
            style: AppTypography.titleMd.copyWith(color: context.colors.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (contacts.isEmpty)
            _Muted(l10n.platformFarmContactMissing)
          else
            for (final contact in contacts)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Row(
                  children: [
                    Icon(
                      contact.contains('@')
                          ? Icons.alternate_email
                          : Icons.phone_outlined,
                      size: 16,
                      color: context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: SelectableText(
                        contact,
                        style: AppTypography.bodyMd
                            .copyWith(color: context.colors.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _AccessCard extends StatelessWidget {
  const _AccessCard({required this.farm, required this.onChange});

  final PlatformFarmDetail farm;

  /// Пусто — менять доступ сейчас нельзя (например ферма помечена на
  /// удаление): кнопка остаётся на месте, но не работает.
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    final color = farmStatusColor(context, farm.status);

    return AppCard(
      variant: farm.isActive ? AppCardVariant.default_ : AppCardVariant.error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(farmStatusIcon(farm.status), size: 18, color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  farmStatusLabel(context, farm.status),
                  style: AppTypography.titleMd.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _Muted(farmStatusHint(context, farm.status)),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onChange,
              icon: const Icon(Icons.tune, size: 18),
              label: Text(context.l10n.platformFarmStatusChange),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.farm});

  final PlatformFarmDetail farm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final plan = farm.plan;

    if (plan == null) {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.platformNoPlan,
              style: AppTypography.titleMd
                  .copyWith(color: context.colors.onSurface),
            ),
            const SizedBox(height: AppSpacing.xs),
            _Muted(l10n.platformNoPlanHint),
          ],
        ),
      );
    }

    final expires = farm.planExpiresAt;
    final expired = expires != null && expires.isBefore(DateTime.now());

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.isActive
                      ? plan.name
                      : '${plan.name} · ${l10n.platformPlanInactive}',
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                ),
              ),
              Text(
                planPriceLabel(context, plan),
                style: AppTypography.labelLg
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _Muted(planLimitsSummary(context, plan)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.event_outlined,
                size: 16,
                color: expired ? AppColors.warning : context.colors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  expires == null
                      ? l10n.platformFarmPlanForever
                      : expired
                          ? l10n.platformFarmPlanExpired(_dayFormat.format(expires))
                          : l10n.platformFarmPlanExpires(_dayFormat.format(expires)),
                  style: AppTypography.bodyMd.copyWith(
                    color: expired
                        ? AppColors.warning
                        : context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExtrasCard extends StatelessWidget {
  const _ExtrasCard({required this.farm, required this.onEdit});

  final PlatformFarmDetail farm;

  /// Пусто — поблажку сейчас не правят (см. [_AccessCard.onChange]).
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasSomething = farm.hasActiveExtras || farm.hasExpiredExtras;

    final parts = [
      if (farm.extraRabbits != null)
        l10n.platformFarmExtrasRabbits(farm.extraRabbits!),
      if (farm.extraStaff != null)
        l10n.platformFarmExtrasStaff(farm.extraStaff!),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!hasSomething)
            _Muted(l10n.platformFarmExtrasNone)
          else ...[
            Text(
              [
                parts.join(' · '),
                farm.extrasUntil == null
                    ? l10n.platformFarmExtrasEndless
                    : l10n.platformFarmExtrasUntil(
                        _dayFormat.format(farm.extrasUntil!)),
              ].join(' '),
              style: AppTypography.titleMd.copyWith(
                color: farm.hasActiveExtras
                    ? context.colors.onSurface
                    : context.colors.onSurfaceVariant,
              ),
            ),
            if (farm.hasExpiredExtras) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  const Icon(Icons.history_toggle_off,
                      size: 16, color: AppColors.warning),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.platformFarmExtrasExpired(
                        _dayFormat.format(farm.extrasUntil!),
                      ),
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: Text(hasSomething
                  ? l10n.platformFarmExtrasEdit
                  : l10n.platformFarmExtrasGrant),
            ),
          ),
        ],
      ),
    );
  }
}

class _UsageCard extends StatelessWidget {
  const _UsageCard({required this.farm});

  final PlatformFarmDetail farm;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: farm.isAtLimit ? AppCardVariant.error : AppCardVariant.default_,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Пределы — с поблажкой: ферма упрётся именно в них, а не в число
          // из тарифа.
          FarmUsageRow(
            icon: Icons.pets_outlined,
            label: context.l10n.platformRabbits,
            used: farm.rabbitsCount,
            limit: farm.effectiveRabbitsLimit,
          ),
          FarmUsageRow(
            icon: Icons.groups_outlined,
            label: context.l10n.platformStaff,
            used: farm.staffCount,
            limit: farm.effectiveStaffLimit,
          ),
          if (farm.isAtLimit) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 16, color: AppColors.error),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    context.l10n.platformAtLimit,
                    style: AppTypography.labelSm
                        .copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StaffList extends StatelessWidget {
  const _StaffList({required this.staff});

  final List<FarmStaffMember> staff;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // У живой фермы в составе есть хотя бы владелец — но пустой список тоже
    // состояние, и молчать о нём нельзя.
    if (staff.isEmpty) {
      return AppCard(child: _Muted(l10n.platformFarmStaffEmpty));
    }

    return Column(
      children: [
        for (final member in staff)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.fullName,
                          style: AppTypography.bodyLg
                              .copyWith(color: context.colors.onSurface),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _Muted([
                          _roleLabel(context, member.role),
                          ...[member.email, member.phone]
                              .whereType<String>()
                              .where((part) => part.trim().isNotEmpty),
                        ].join(' · ')),
                        const SizedBox(height: AppSpacing.xs),
                        _Muted(member.lastLoginAt == null
                            ? l10n.platformFarmStaffNever
                            : l10n.platformFarmStaffLastLogin(
                                _momentFormat.format(member.lastLoginAt!))),
                      ],
                    ),
                  ),
                  // Выключенный человек — не то же, что уволенный: он в
                  // составе, но войти не может, и это видно сразу.
                  if (!member.isActive)
                    Text(
                      l10n.platformFarmStaffBlocked,
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.error),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Роль читаемым словом. Разбор строки и подписи уже есть в `core/access` —
  /// свой перечень тех же трёх ролей расходился бы с ним.
  static String _roleLabel(BuildContext context, String role) =>
      switch (FarmRoleAccess.parse(role)) {
        FarmRoleAccess.owner => context.l10n.roleOwner,
        FarmRoleAccess.manager => context.l10n.roleManager,
        FarmRoleAccess.worker => context.l10n.roleWorker,
      };
}

class _PaymentsList extends StatelessWidget {
  const _PaymentsList({required this.payments});

  final List<FarmPayment> payments;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (payments.isEmpty) {
      return AppCard(child: _Muted(l10n.platformFarmPaymentsEmpty));
    }

    return AppCard(
      child: Column(
        children: [
          for (final payment in payments)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _amountLabel(payment),
                          style: AppTypography.bodyLg
                              .copyWith(color: context.colors.onSurface),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _Muted([
                          if (payment.description != null &&
                              payment.description!.trim().isNotEmpty)
                            payment.description!,
                          _dayFormat.format(payment.createdAt),
                        ].join(' · ')),
                      ],
                    ),
                  ),
                  Text(
                    _statusLabel(context, payment.status),
                    style: AppTypography.labelSm
                        .copyWith(color: _statusColor(context, payment.status)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Сумма со знаком валюты. Код валюты, отличный от сомони, показываем как
  /// есть: подставить «с» к чужой валюте значило бы соврать о сумме.
  static String _amountLabel(FarmPayment payment) {
    final amount = parseDecimal(payment.amount);
    if (amount == null) return '${payment.amount} ${payment.currency}';
    return payment.currency == '972'
        ? formatMoney(amount)
        : '${formatQuantity(amount)} ${payment.currency}';
  }

  static String _statusLabel(BuildContext context, String status) =>
      switch (status) {
        'completed' => context.l10n.platformFarmPaymentCompleted,
        'failed' => context.l10n.platformFarmPaymentFailed,
        _ => context.l10n.platformFarmPaymentNew,
      };

  static Color _statusColor(BuildContext context, String status) =>
      switch (status) {
        'completed' => AppColors.success,
        'failed' => AppColors.error,
        _ => context.colors.onSurfaceVariant,
      };
}

class _FactsCard extends StatelessWidget {
  const _FactsCard({required this.farm});

  final PlatformFarmDetail farm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCard(
      child: Column(
        children: [
          _Fact(
            icon: Icons.folder_outlined,
            label: l10n.platformFarmStorage,
            value: _storageLabel(context, farm.storageBytes),
          ),
          _Fact(
            icon: Icons.login_outlined,
            label: l10n.platformFarmLastActive,
            value: farm.lastActiveAt == null
                ? l10n.platformFarmNeverActive
                : _momentFormat.format(farm.lastActiveAt!),
          ),
          _Fact(
            icon: Icons.flag_outlined,
            label: l10n.platformFarmCreatedAt,
            value: _dayFormat.format(farm.createdAt),
          ),
        ],
      ),
    );
  }

  /// Место человеческим языком. Приставка — из словаря, деление — из общей
  /// утилиты: «МБ» на других языках пишется иначе, а сама арифметика нет.
  static String _storageLabel(BuildContext context, int bytes) {
    final scaled = scaleBytes(bytes);
    final unit = switch (scaled.power) {
      0 => context.l10n.storageUnitBytes,
      1 => context.l10n.storageUnitKb,
      2 => context.l10n.storageUnitMb,
      _ => context.l10n.storageUnitGb,
    };
    return formatQuantity(scaled.value, unit);
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 16, color: context.colors.onSurfaceVariant),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMd
                  .copyWith(color: context.colors.onSurface),
            ),
          ),
          Text(
            value,
            style: AppTypography.labelLg
                .copyWith(color: context.colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Выгрузка данных фермы. Отдельным экраном, а не диалогом: снимок бывает на
/// сотни строк, и его листают и копируют.
class _ExportCard extends StatelessWidget {
  const _ExportCard({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Muted(l10n.platformFarmExportHint),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onOpen,
              icon: const Icon(Icons.download_outlined, size: 18),
              label: Text(l10n.platformFarmExport),
            ),
          ),
        ],
      ),
    );
  }
}

/// Удаление фермы: что произойдёт и кнопка, ведущая к подтверждению.
class _DeleteCard extends StatelessWidget {
  const _DeleteCard({required this.onDelete});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Muted(l10n.platformFarmDeleteHint),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onDelete,
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: Text(l10n.platformFarmDelete),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ферма уже помечена на удаление: когда это случилось, что будет дальше и
/// как отменить.
class _DeletedCard extends StatelessWidget {
  const _DeletedCard({required this.farm, required this.onRestore});

  final PlatformFarmDetail farm;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCard(
      variant: AppCardVariant.error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.delete_forever_outlined,
                  size: 18, color: AppColors.error),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.platformFarmDeletedBanner(
                    _dayFormat.format(farm.deletedAt!),
                  ),
                  style: AppTypography.bodyMd.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _Muted(l10n.platformFarmDeletedLocked),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              // Восстановление подтверждения не требует: это отмена, а не
              // разрушение.
              onPressed: onRestore,
              icon: const Icon(Icons.restore_from_trash_outlined, size: 18),
              label: Text(l10n.platformFarmRestore),
            ),
          ),
        ],
      ),
    );
  }
}

/// Приглушённая строка-пояснение — их на этом экране много.
class _Muted extends StatelessWidget {
  const _Muted(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodyMd
          .copyWith(color: context.colors.onSurfaceVariant),
    );
  }
}
