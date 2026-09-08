import 'dart:async';

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
class PlatformFarmsTab extends ConsumerStatefulWidget {
  const PlatformFarmsTab({super.key});

  @override
  ConsumerState<PlatformFarmsTab> createState() => _PlatformFarmsTabState();
}

class _PlatformFarmsTabState extends ConsumerState<PlatformFarmsTab> {
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(
      AppDuration.normal,
      () => ref.read(platformFarmsProvider.notifier).setSearchQuery(query.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(platformFarmsProvider);
    final notifier = ref.read(platformFarmsProvider.notifier);

    return PagedListView<PlatformFarm>(
      items: state.farms,
      isLoading: state.isLoading,
      error: state.error,
      hasMore: state.hasMore,
      onRefresh: notifier.load,
      onLoadMore: notifier.loadMore,
      header: _Header(state: state, controller: _search, onSearch: _onSearchChanged),
      empty: state.hasFilters
          ? AppEmptyState(
              icon: Icons.search_off,
              title: context.l10n.platformFarmsNothingFound,
              subtitle: context.l10n.platformFarmsNothingFoundBody,
              actionLabel: context.l10n.commonReset,
              onAction: () {
                _search.clear();
                notifier.resetFilters();
              },
            )
          : AppEmptyState(
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

class _Header extends ConsumerWidget {
  final PlatformFarmsState state;
  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  const _Header({
    required this.state,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(platformFarmsProvider.notifier);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            AppSpacing.md,
            AppSpacing.screenH,
            AppSpacing.sm,
          ),
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.platformFarmsSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: state.searchQuery.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                        notifier.setSearchQuery('');
                      },
                    ),
            ),
            // Поиск уходит на сервер, а не фильтрует загруженную страницу:
            // иначе ферма со второй страницы «не находилась».
            onChanged: onSearch,
            onSubmitted: (v) => notifier.setSearchQuery(v.trim()),
          ),
        ),
        AppFilterBar(
          chips: [
            AppFilterChipData(
              label: l10n.platformNoPlan,
              isSelected: state.filter == PlatformFarmFilter.noPlan,
              onTap: () => notifier.toggleFilter(PlatformFarmFilter.noPlan),
            ),
            AppFilterChipData(
              label: l10n.platformAtLimit,
              isSelected: state.filter == PlatformFarmFilter.atLimit,
              onTap: () => notifier.toggleFilter(PlatformFarmFilter.atLimit),
              color: AppColors.error,
            ),
            AppFilterChipData(
              // Порог фиксирован (30 дней) — чипу не нужен свой пикер, чтобы
              // включить фильтр одним касанием; сервер это же значение
              // подставляет по умолчанию, если `days` не передан.
              label: l10n.platformFilterInactive(30),
              isSelected: state.filter == PlatformFarmFilter.inactiveDays,
              onTap: () => notifier.toggleFilter(PlatformFarmFilter.inactiveDays),
            ),
          ],
        ),
        // Счётчик берётся из пагинации, а не из длины загруженного списка:
        // иначе «12 ферм» означало бы «столько успело догрузиться». Прячется
        // при пустом списке — иначе на пустом экране висело бы «0 ферм» рядом
        // с подсказкой, что делать дальше.
        if (state.farms.isNotEmpty) _FarmsTotal(total: state.total),
      ],
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
