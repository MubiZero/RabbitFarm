import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../cages/data/models/cage_model.dart';
import '../../../cages/presentation/providers/herd_cages_provider.dart';
import '../../../cages/presentation/utils/cage_labels.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/rabbits_provider.dart';
import '../utils/rabbit_labels.dart';
import 'rabbits_list_screen.dart';

/// Стадо — два взгляда на одно поголовье.
///
/// Клетки и кролики жили в разных разделах меню, хотя это один и тот же
/// десяток животных, посчитанный с двух сторон: «где стоит» и «кто такой».
/// Здесь у них общая шапка и общий поиск, а переключатель меняет только то,
/// что под шапкой.
///
/// Клетки показаны рядами, а не сплошным списком номеров: в крольчатнике
/// ходят вдоль ряда, и «клетка 14» без ряда — это адрес без улицы.
class HerdScreen extends ConsumerStatefulWidget {
  const HerdScreen({super.key});

  @override
  ConsumerState<HerdScreen> createState() => _HerdScreenState();
}

enum _HerdView { cages, rabbits }

class _HerdScreenState extends ConsumerState<HerdScreen> {
  final _search = TextEditingController();
  Timer? _debounce;

  _HerdView _view = _HerdView.cages;

  /// Запрос хранится здесь, потому что клетки отбираются на месте, на каждой
  /// букве. Для кроликов он же уезжает в отбор списка — с задержкой, потому
  /// что за ними идёт запрос на сервер.
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Список кроликов общий с экраном «Кролики», и в нём мог остаться чужой
    // отбор. Вкладка «Стадо» открывается на всём поголовье: показать выборку
    // и подписать её ярлыком «Все» — это соврать о том, что видно.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!ref.read(rabbitsListProvider).filter.isEmpty) {
        ref
            .read(rabbitsListProvider.notifier)
            .applyFilter(const RabbitsFilter());
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _applyRabbitFilter(RabbitsFilter filter) =>
      ref.read(rabbitsListProvider.notifier).applyFilter(filter);

  void _applySearchToRabbits() {
    final filter = ref.read(rabbitsListProvider).filter;
    final search = _query.isEmpty ? null : _query;
    if (filter.search == search) return;
    _applyRabbitFilter(filter.withSearch(search));
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value.trim());
    _debounce?.cancel();
    // Клетки уже загружены целиком и отбираются на месте, ждать нечего.
    // Задержка нужна только запросу за кроликами: слово из пяти букв — это
    // пять запросов, ответы на которые приходят не по порядку.
    if (_view == _HerdView.rabbits) {
      _debounce = Timer(AppDuration.normal, () {
        if (mounted) _applySearchToRabbits();
      });
    }
  }

  void _switchView(_HerdView view) {
    if (view == _view) return;
    _debounce?.cancel();
    setState(() => _view = view);
    // Поиск один на оба вида, поэтому при переходе к кроликам набранное в
    // клетках слово должно доехать до списка, а не остаться в строке
    // украшением.
    if (view == _HerdView.rabbits) _applySearchToRabbits();
  }

  void _reset() {
    _search.clear();
    setState(() => _query = '');
    // Лишний запрос за кроликами со вкладки клеток ни к чему: сбрасывать
    // нечего, если отбор и так пуст.
    if (!ref.read(rabbitsListProvider).filter.isEmpty) {
      _applyRabbitFilter(const RabbitsFilter());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(
              controller: _search,
              view: _view,
              onSearchChanged: _onSearchChanged,
              onViewChanged: _switchView,
            ),
            Expanded(
              child: switch (_view) {
                _HerdView.cages =>
                  _CagesMap(query: _query, onResetSearch: _reset),
                _HerdView.rabbits => _RabbitsView(
                    onFilter: _applyRabbitFilter,
                    onReset: _reset,
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка стада: заголовок, один поиск на оба вида и переключатель.
class _Header extends StatelessWidget {
  final TextEditingController controller;
  final _HerdView view;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<_HerdView> onViewChanged;

  const _Header({
    required this.controller,
    required this.view,
    required this.onSearchChanged,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.screenH,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.herdTitle,
            style: AppTypography.displayMd
                .copyWith(color: context.colors.onSurface),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              // Подсказка называет то, что видно на экране прямо сейчас: в
              // клетках искать по кличке бессмысленно, кличек там нет.
              hintText: view == _HerdView.cages
                  ? l10n.cagesSearchHint
                  : l10n.rabbitsSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.commonClearSearch,
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                        onSearchChanged('');
                      },
                    ),
            ),
            onChanged: onSearchChanged,
            onSubmitted: onSearchChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<_HerdView>(
              segments: [
                ButtonSegment(
                  value: _HerdView.cages,
                  icon: const Icon(Icons.grid_view_outlined, size: 18),
                  label: Text(l10n.herdTabCages),
                ),
                ButtonSegment(
                  value: _HerdView.rabbits,
                  icon: const Icon(Icons.pets_outlined, size: 18),
                  label: Text(l10n.herdTabRabbits),
                ),
              ],
              selected: {view},
              showSelectedIcon: false,
              onSelectionChanged: (selection) =>
                  onViewChanged(selection.first),
            ),
          ),
        ],
      ),
    );
  }
}

/// Карта фермы: ряды крольчатника и занятость клеток в них.
class _CagesMap extends ConsumerWidget {
  final String query;
  final VoidCallback onResetSearch;

  const _CagesMap({required this.query, required this.onResetSearch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rowsAsync = ref.watch(cageRowsProvider);
    final canManage = ref.watch(canProvider(FarmCapability.manageLivestock));

    Future<void> refresh() => ref.refresh(cageRowsProvider.future);

    return RefreshIndicator(
      onRefresh: refresh,
      child: AppAsyncView<List<CageRow>>(
        value: rowsAsync,
        onRetry: refresh,
        skeleton: (_) => const _CagesSkeleton(),
        builder: (rows) {
          final visible = _filter(rows, query);

          if (visible.isEmpty) {
            return _scrollableFill(
              rows.isEmpty
                  ? AppEmptyState(
                      icon: Icons.grid_view_outlined,
                      title: context.l10n.cagesEmptyTitle,
                      subtitle: context.l10n.cagesEmptyBody,
                      actionLabel: canManage ? context.l10n.cagesAdd : null,
                      onAction:
                          canManage ? () => context.push('/cages/form') : null,
                    )
                  : AppEmptyState(
                      icon: Icons.search_off,
                      title: context.l10n.cagesNothingFound,
                      subtitle: context.l10n.cagesNothingFoundBody,
                      actionLabel: context.l10n.commonReset,
                      onAction: onResetSearch,
                    ),
            );
          }

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.sm,
              AppSpacing.screenH,
              AppSpacing.fabSafeBottom,
            ),
            itemCount: visible.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) => _CageRowCard(row: visible[i]),
          );
        },
      ),
    );
  }

  /// Отбор идёт по тому, что человек видит на карте: по названию ряда и по
  /// номеру клетки. Совпадение с рядом оставляет ряд целиком — иначе поиск
  /// «сарай» показал бы сарай без клеток.
  static List<CageRow> _filter(List<CageRow> rows, String query) {
    if (query.isEmpty) return rows;
    final needle = query.toLowerCase();

    final result = <CageRow>[];
    for (final row in rows) {
      final location = row.location?.toLowerCase() ?? '';
      if (location.contains(needle)) {
        result.add(row);
        continue;
      }
      final cages = row.cages
          .where((cage) => cage.number.toLowerCase().contains(needle))
          .toList();
      if (cages.isNotEmpty) {
        result.add(CageRow(location: row.location, cages: cages));
      }
    }
    return result;
  }
}

/// Пустое состояние внутри «потяните, чтобы обновить»: без прокручиваемого
/// содержимого жест не сработает, и с пустого экрана будет некуда деться.
Widget _scrollableFill(Widget child) => LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: child,
        ),
      ),
    );

/// Один ряд крольчатника: название места, занятость по ряду и сами клетки.
class _CageRowCard extends StatelessWidget {
  final CageRow row;

  const _CageRowCard({required this.row});

  @override
  Widget build(BuildContext context) {
    final title = row.location ?? context.l10n.herdCagesNoPlace;
    final muted = context.colors.onSurfaceVariant;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                row.location == null
                    ? Icons.help_outline
                    : Icons.warehouse_outlined,
                size: 18,
                color: muted,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                context.l10n.cagesOccupancy(row.occupied, row.capacity),
                style: AppTypography.labelSm.copyWith(color: muted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final cage in row.cages) _CageTile(cage: cage),
            ],
          ),
        ],
      ),
    );
  }
}

/// Клетка на карте: номер, сколько кроликов из скольких мест и в каком она
/// состоянии.
class _CageTile extends StatelessWidget {
  final CageModel cage;

  const _CageTile({required this.cage});

  @override
  Widget build(BuildContext context) {
    final occupied = cage.currentOccupancy ?? cage.rabbits?.length ?? 0;
    final ratio =
        cage.capacity > 0 ? (occupied / cage.capacity).clamp(0.0, 1.0) : 0.0;

    // Цвет рамки говорит о состоянии клетки, а не о заполненности: полная
    // исправная клетка — это норма, а сломанная пустая — работа на завтра.
    final condition = cageConditionColor(context, cage.condition);
    final isFine = cage.condition == 'good';
    final border = isFine ? context.colors.outline : condition;
    // Полоса показывает занятость, и только её. Полная клетка — это норма,
    // а не тревога, поэтому оранжевого здесь быть не должно: на ферме он
    // означает ровно одно — с клеткой что-то не так. Делить один цвет между
    // «занята целиком» и «нужен ремонт» значит обесценить сигнал.
    final fill = context.accent;

    return SizedBox(
      width: 92,
      child: Material(
        color: context.colors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppRadius.mdAll,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/cages/${cage.id}'),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border.all(
                color: border,
                width: isFine ? 1 : 1.5,
              ),
              borderRadius: AppRadius.mdAll,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cage.number,
                        style: AppTypography.titleMd
                            .copyWith(color: context.colors.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!isFine)
                      Icon(Icons.build_outlined, size: 14, color: condition),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$occupied/${cage.capacity}',
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: context.colors.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(fill),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Заглушка карты: два ряда клеток той же высоты, что настоящие.
class _CagesSkeleton extends StatelessWidget {
  const _CagesSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.sm,
        AppSpacing.screenH,
        AppSpacing.fabSafeBottom,
      ),
      children: const [
        SkeletonBox(height: 148, borderRadius: AppRadius.lgAll),
        SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 148, borderRadius: AppRadius.lgAll),
      ],
    );
  }
}

/// Список особей с отбором по назначению — по тому, для чего кролика держат.
class _RabbitsView extends ConsumerWidget {
  final ValueChanged<RabbitsFilter> onFilter;
  final VoidCallback onReset;

  const _RabbitsView({required this.onFilter, required this.onReset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rabbitsListProvider);
    final notifier = ref.read(rabbitsListProvider.notifier);
    final canManage = ref.watch(canProvider(FarmCapability.manageLivestock));

    return PagedListView<RabbitModel>(
      items: state.rabbits,
      isLoading: state.isLoading,
      error: state.error,
      hasMore: state.hasMore,
      onRefresh: notifier.loadRabbits,
      onLoadMore: notifier.loadMore,
      header: _RabbitFilters(filter: state.filter, onFilter: onFilter),
      empty: state.filter.isEmpty
          ? AppEmptyState(
              icon: Icons.pets_outlined,
              title: context.l10n.rabbitsEmptyTitle,
              subtitle: context.l10n.rabbitsEmptyBody,
              actionLabel: canManage ? context.l10n.rabbitsEmptyAction : null,
              onAction: canManage ? () => context.push('/rabbits/new') : null,
            )
          : AppEmptyState(
              icon: Icons.search_off,
              title: context.l10n.rabbitsNothingFound,
              subtitle: context.l10n.rabbitsNothingFoundBody,
              actionLabel: context.l10n.commonReset,
              onAction: onReset,
            ),
      itemBuilder: (context, rabbit, _) => RabbitListCard(
        rabbit: rabbit,
        onTap: () => context.push('/rabbits/${rabbit.id}'),
      ),
    );
  }
}

class _RabbitFilters extends StatelessWidget {
  final RabbitsFilter filter;
  final ValueChanged<RabbitsFilter> onFilter;

  const _RabbitFilters({required this.filter, required this.onFilter});

  /// Назначения в том порядке, в каком о стаде думают: сначала те, кто даёт
  /// приплод, потом те, кого держат на мясо, продажу и выставку.
  static const _purposes = ['breeding', 'meat', 'sale', 'show'];

  @override
  Widget build(BuildContext context) {
    return AppFilterBar(
      chips: [
        AppFilterChipData(
          label: context.l10n.rabbitsFilterAll,
          isSelected: filter.purpose == null && filter.sex == null,
          onTap: () => onFilter(filter.withPurpose(null).withSex(null)),
        ),
        for (final value in _purposes)
          AppFilterChipData(
            label: rabbitPurposeLabel(context, value),
            isSelected: filter.purpose == value,
            onTap: () => onFilter(
              filter.withPurpose(filter.purpose == value ? null : value),
            ),
          ),
        AppFilterChipData(
          label: context.l10n.rabbitsFilterMales,
          isSelected: filter.sex == 'male',
          onTap: () =>
              onFilter(filter.withSex(filter.sex == 'male' ? null : 'male')),
          color: sexColor(context, 'male'),
        ),
        AppFilterChipData(
          label: context.l10n.rabbitsFilterFemales,
          isSelected: filter.sex == 'female',
          onTap: () => onFilter(
              filter.withSex(filter.sex == 'female' ? null : 'female')),
          color: sexColor(context, 'female'),
        ),
      ],
    );
  }
}
