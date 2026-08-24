import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/rabbits_provider.dart';
import '../utils/rabbit_labels.dart';
import '../widgets/rabbit_picker.dart';

/// Поголовье фермы.
class RabbitsListScreen extends ConsumerStatefulWidget {
  const RabbitsListScreen({super.key});

  @override
  ConsumerState<RabbitsListScreen> createState() => _RabbitsListScreenState();
}

class _RabbitsListScreenState extends ConsumerState<RabbitsListScreen> {
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Отбор хранит список, а не экран: если сюда пришли со «Стада», строка
    // поиска должна показывать то, по чему список отобран на самом деле.
    _search.text = ref.read(rabbitsListProvider).filter.search ?? '';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  /// Поиск с задержкой: слово из пяти букв — это пять запросов, между
  /// которыми список мигал бы индикатором, а ответы могли прийти не в том
  /// порядке, в котором их отправляли.
  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(AppDuration.normal, () {
      if (!mounted) return;
      final query = value.trim();
      _apply(ref
          .read(rabbitsListProvider)
          .filter
          .withSearch(query.isEmpty ? null : query));
    });
  }

  void _apply(RabbitsFilter filter) =>
      ref.read(rabbitsListProvider.notifier).applyFilter(filter);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rabbitsListProvider);
    final filter = state.filter;
    final canManage = ref.watch(canProvider(FarmCapability.manageLivestock));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.rabbitsTitle)),
      body: PagedListView<RabbitModel>(
        items: state.rabbits,
        isLoading: state.isLoading,
        error: state.error,
        hasMore: state.hasMore,
        onRefresh: ref.read(rabbitsListProvider.notifier).loadRabbits,
        onLoadMore: ref.read(rabbitsListProvider.notifier).loadMore,
        header: _Header(
          controller: _search,
          onSearchChanged: _onSearchChanged,
          filter: filter,
          onFilter: _apply,
        ),
        empty: !filter.isEmpty
            ? AppEmptyState(
                icon: Icons.search_off,
                title: context.l10n.rabbitsNothingFound,
                subtitle: context.l10n.rabbitsNothingFoundBody,
                actionLabel: context.l10n.commonReset,
                onAction: () {
                  _search.clear();
                  _apply(const RabbitsFilter());
                },
              )
            : AppEmptyState(
                icon: Icons.pets_outlined,
                title: context.l10n.rabbitsEmptyTitle,
                subtitle: context.l10n.rabbitsEmptyBody,
                actionLabel:
                    canManage ? context.l10n.rabbitsEmptyAction : null,
                onAction: canManage ? () => context.push('/rabbits/new') : null,
              ),
        itemBuilder: (context, rabbit, _) => RabbitListCard(
          rabbit: rabbit,
          onTap: () => context.push('/rabbits/${rabbit.id}'),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final RabbitsFilter filter;
  final ValueChanged<RabbitsFilter> onFilter;

  const _Header({
    required this.controller,
    required this.onSearchChanged,
    required this.filter,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
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
              hintText: l10n.rabbitsSearchHint,
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: onSearchChanged,
            onSubmitted: onSearchChanged,
          ),
        ),
        AppFilterBar(
          chips: [
            AppFilterChipData(
              label: l10n.rabbitsFilterAll,
              isSelected: filter.sex == null && filter.status == null,
              onTap: () =>
                  onFilter(filter.withSex(null).withStatus(null)),
            ),
            AppFilterChipData(
              label: l10n.rabbitsFilterMales,
              isSelected: filter.sex == 'male',
              onTap: () =>
                  onFilter(filter.withSex(filter.sex == 'male' ? null : 'male')),
              color: sexColor(context, 'male'),
            ),
            AppFilterChipData(
              label: l10n.rabbitsFilterFemales,
              isSelected: filter.sex == 'female',
              onTap: () => onFilter(
                  filter.withSex(filter.sex == 'female' ? null : 'female')),
              color: sexColor(context, 'female'),
            ),
            AppFilterChipData(
              label: l10n.rabbitsFilterActive,
              isSelected: filter.status == 'active',
              onTap: () => onFilter(filter
                  .withStatus(filter.status == 'active' ? null : 'active')),
              color: AppColors.success,
            ),
            AppFilterChipData(
              label: l10n.rabbitsFilterSold,
              isSelected: filter.status == 'sold',
              onTap: () => onFilter(
                  filter.withStatus(filter.status == 'sold' ? null : 'sold')),
              color: AppColors.warning,
            ),
          ],
        ),
      ],
    );
  }
}

/// Карточка кролика в списке поголовья.
///
/// Живёт отдельным классом, потому что тем же списком особей смотрят на стадо
/// со вкладки «Стадо». Вторая копия карточки разошлась бы с этой в первый же
/// день: они уже разошлись у клеток, где один и тот же тип клетки назывался
/// двумя разными словами.
class RabbitListCard extends StatelessWidget {
  final RabbitModel rabbit;
  final VoidCallback onTap;

  const RabbitListCard({
    super.key,
    required this.rabbit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Hero(
            tag: 'rabbit_photo_${rabbit.id}',
            // Раньше фото подставлялось в NetworkImage напрямую, а адрес с
            // сервера приходит относительный — картинка не грузилась никогда.
            child: RabbitAvatar(photoUrl: rabbit.photoUrl, size: 56),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        rabbit.name,
                        style: AppTypography.titleMd
                            .copyWith(color: context.colors.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    StatusBadge(
                        status: RabbitStatusX.fromString(rabbit.status)),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                // Бирка и порода — справочная строка, её читают глазами по
                // порядку, а не выхватывают. Ярлыки оставлены полу и
                // назначению: по ним стадо делят и в списке ищут.
                Text(
                  [
                    rabbit.tagId.trim().isEmpty
                        ? context.l10n.rabbitNoTag
                        : rabbit.tagId,
                    if (rabbit.breed?.name != null) rabbit.breed!.name,
                  ].join(' · '),
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _Badge(
                      icon: rabbitSexIcon(rabbit.sex),
                      label: sexLabel(context, rabbit.sex),
                      color: sexColor(context, rabbit.sex),
                    ),
                    // Назначение — главное деление стада: по нему решают,
                    // кого случать, а кого ставить на откорм. В карточке его
                    // не было видно вовсе, хотя в базе поле обязательное.
                    _Badge(
                      icon: Icons.label_outline,
                      label: rabbitPurposeLabel(context, rabbit.purpose),
                      color: context.colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.chevron_right, color: context.colors.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.smAll,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.labelSm.copyWith(color: color)),
        ],
      ),
    );
  }
}
