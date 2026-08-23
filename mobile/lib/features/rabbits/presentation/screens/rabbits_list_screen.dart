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

  String? _sex;
  String? _status;

  bool get _hasFilters =>
      _sex != null || _status != null || _search.text.trim().isNotEmpty;

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
      if (mounted) _load();
    });
  }

  Future<void> _load() => ref.read(rabbitsListProvider.notifier).loadRabbits(
        search: _search.text.trim().isEmpty ? null : _search.text.trim(),
        sex: _sex,
        status: _status,
      );

  void _setFilter({String? sex, String? status}) {
    setState(() {
      _sex = sex;
      _status = status;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rabbitsListProvider);
    final canManage = ref.watch(canProvider(FarmCapability.manageLivestock));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.rabbitsTitle)),
      body: PagedListView<RabbitModel>(
        items: state.rabbits,
        isLoading: state.isLoading,
        error: state.error,
        hasMore: state.hasMore,
        onRefresh: _load,
        onLoadMore: () => ref.read(rabbitsListProvider.notifier).loadMore(
              search: _search.text.trim().isEmpty ? null : _search.text.trim(),
              sex: _sex,
              status: _status,
            ),
        header: _Header(
          controller: _search,
          onSearchChanged: _onSearchChanged,
          sex: _sex,
          status: _status,
          onFilter: _setFilter,
        ),
        empty: _hasFilters
            ? AppEmptyState(
                icon: Icons.search_off,
                title: context.l10n.rabbitsNothingFound,
                subtitle: context.l10n.rabbitsNothingFoundBody,
                actionLabel: context.l10n.commonReset,
                onAction: () {
                  _search.clear();
                  _setFilter();
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
        itemBuilder: (context, rabbit, _) => _RabbitCard(
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
  final String? sex;
  final String? status;
  final void Function({String? sex, String? status}) onFilter;

  const _Header({
    required this.controller,
    required this.onSearchChanged,
    required this.sex,
    required this.status,
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
              isSelected: sex == null && status == null,
              onTap: () => onFilter(),
            ),
            AppFilterChipData(
              label: l10n.rabbitsFilterMales,
              isSelected: sex == 'male',
              onTap: () =>
                  onFilter(sex: sex == 'male' ? null : 'male', status: status),
              color: sexColor(context, 'male'),
            ),
            AppFilterChipData(
              label: l10n.rabbitsFilterFemales,
              isSelected: sex == 'female',
              onTap: () => onFilter(
                  sex: sex == 'female' ? null : 'female', status: status),
              color: sexColor(context, 'female'),
            ),
            AppFilterChipData(
              label: l10n.rabbitsFilterActive,
              isSelected: status == 'active',
              onTap: () => onFilter(
                  sex: sex, status: status == 'active' ? null : 'active'),
              color: AppColors.success,
            ),
            AppFilterChipData(
              label: l10n.rabbitsFilterSold,
              isSelected: status == 'sold',
              onTap: () =>
                  onFilter(sex: sex, status: status == 'sold' ? null : 'sold'),
              color: AppColors.warning,
            ),
          ],
        ),
      ],
    );
  }
}

class _RabbitCard extends StatelessWidget {
  final RabbitModel rabbit;
  final VoidCallback onTap;

  const _RabbitCard({required this.rabbit, required this.onTap});

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
            child: RabbitAvatar(photoUrl: rabbit.photoUrl, size: 72),
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
                Text(
                  rabbit.tagId.trim().isEmpty
                      ? context.l10n.rabbitNoTag
                      : rabbit.tagId,
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
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
                    if (rabbit.breed?.name != null)
                      _Badge(
                        icon: Icons.category_outlined,
                        label: rabbit.breed!.name,
                        color: AppColors.domainLivestock,
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
