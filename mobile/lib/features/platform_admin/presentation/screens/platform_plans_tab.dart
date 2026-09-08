import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import '../providers/platform_admin_provider.dart';
import '../widgets/plan_card.dart';

/// Тарифы сервиса: что вообще можно назначить ферме.
class PlatformPlansTab extends ConsumerWidget {
  const PlatformPlansTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppAsyncView<List<Plan>>(
      value: ref.watch(platformPlansProvider),
      onRetry: () => ref.invalidate(platformPlansProvider),
      skeleton: (context) => const SkeletonList(
        padding: EdgeInsets.all(AppSpacing.screenH),
      ),
      builder: (plans) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(platformPlansProvider),
        child: plans.isEmpty
            ? _EmptyPlans(onCreate: () => context.push('/platform-admin/plans/form'))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenH,
                  AppSpacing.lg,
                  AppSpacing.screenH,
                  AppSpacing.fabSafeBottom,
                ),
                itemCount: plans.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) => PlanCard(
                  plan: plans[i],
                  onEdit: () => context.push(
                    '/platform-admin/plans/form',
                    extra: plans[i],
                  ),
                  onDelete: () => _delete(context, ref, plans[i]),
                ),
              ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Plan plan) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final deleted = l10n.platformPlanDeleted;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.platformPlanDeleteTitle),
        content: Text(l10n.platformPlanDeleteBody(plan.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(platformAdminRepositoryProvider).deletePlan(plan.id);
      ref.invalidate(platformPlansProvider);
      // Фермы на удалённом тарифе стали безлимитными — их карточки в соседней
      // вкладке показывали бы прежние пределы.
      ref.invalidate(platformFarmsProvider);
      messenger.showSnackBar(SnackBar(content: Text(deleted)));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

class _EmptyPlans extends StatelessWidget {
  const _EmptyPlans({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    // Пустое состояние внутри прокручиваемого списка: иначе обновление
    // жестом на пустой вкладке не работает.
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.6,
          child: AppEmptyState(
            icon: Icons.sell_outlined,
            title: context.l10n.platformPlansEmptyTitle,
            subtitle: context.l10n.platformPlansEmptyBody,
            actionLabel: context.l10n.platformPlanNew,
            onAction: onCreate,
          ),
        ),
      ],
    );
  }
}
