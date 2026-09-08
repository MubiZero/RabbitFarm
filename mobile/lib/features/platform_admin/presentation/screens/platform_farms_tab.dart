import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import '../providers/platform_admin_provider.dart';
import '../widgets/plan_picker_sheet.dart';
import '../widgets/platform_farm_card.dart';

/// Все хозяйства сервиса: кто на каком тарифе и сколько израсходовал.
class PlatformFarmsTab extends ConsumerWidget {
  const PlatformFarmsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(platformFarmsProvider);
    final notifier = ref.read(platformFarmsProvider.notifier);

    return PagedListView<PlatformFarm>(
      items: state.farms,
      isLoading: state.isLoading,
      error: state.error,
      hasMore: state.hasMore,
      onRefresh: notifier.load,
      onLoadMore: notifier.loadMore,
      // Счётчик берётся из пагинации, а не из длины загруженного списка:
      // иначе «12 ферм» означало бы «столько успело догрузиться».
      header: state.farms.isEmpty ? null : _FarmsTotal(total: state.total),
      empty: AppEmptyState(
        icon: Icons.holiday_village_outlined,
        title: context.l10n.platformFarmsEmptyTitle,
        subtitle: context.l10n.platformFarmsEmptyBody,
      ),
      itemBuilder: (context, farm, _) => PlatformFarmCard(
        farm: farm,
        onChangePlan: () => _changePlan(context, ref, farm),
      ),
    );
  }

  Future<void> _changePlan(
    BuildContext context,
    WidgetRef ref,
    PlatformFarm farm,
  ) async {
    final choice = await showPlanPicker(context, farm: farm);
    if (choice == null || !context.mounted) return;
    // Выбрали то же самое — запрос не нужен.
    if (choice.planId == farm.plan?.id) return;

    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final assigned = l10n.platformPlanAssigned;

    final error =
        await ref.read(platformFarmsProvider.notifier).assignPlan(farm.id, choice.planId);

    messenger.showSnackBar(
      error == null
          ? SnackBar(content: Text(assigned))
          : SnackBar(
              content: Text(errorText(l10n, error)),
              backgroundColor: AppColors.error,
            ),
    );
  }
}

class _FarmsTotal extends StatelessWidget {
  const _FarmsTotal({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.screenH,
        0,
      ),
      child: AppGroupLabel(context.l10n.countFarms(total)),
    );
  }
}
