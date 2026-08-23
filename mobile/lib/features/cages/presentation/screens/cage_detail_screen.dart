import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/providers/rabbits_provider.dart';
import '../../data/models/cage_model.dart';
import '../providers/cages_provider.dart';
import '../utils/cage_labels.dart';

/// Карточка клетки: состояние, заполненность и кто в ней живёт.
class CageDetailScreen extends ConsumerStatefulWidget {
  final int cageId;

  const CageDetailScreen({super.key, required this.cageId});

  @override
  ConsumerState<CageDetailScreen> createState() => _CageDetailScreenState();
}

class _CageDetailScreenState extends ConsumerState<CageDetailScreen> {
  /// Идёт перемещение кролика. Содержимое экрана при этом остаётся на месте:
  /// раньше вместо него на весь экран разворачивался спиннер, и человек
  /// терял из виду список, с которым только что работал.
  bool _busy = false;

  Future<void> _refresh() async {
    ref.invalidate(cageDetailProvider(widget.cageId));
    await ref.read(cageDetailProvider(widget.cageId).future);
  }

  /// Общая обвязка действий над жителями клетки: занятость, обновление
  /// экрана и сообщение о результате.
  Future<void> _run(Future<void> Function() action, String success) async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action();
      ref.invalidate(cagesProvider);
      await _refresh();
      messenger.showSnackBar(SnackBar(content: Text(success)));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Не удалось: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _removeRabbit(RabbitModel rabbit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Убрать из клетки?'),
        content: Text(
          '${rabbit.name} перейдёт в список кроликов без клетки.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Убрать'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await _run(
      () => ref
          .read(rabbitsRepositoryProvider)
          .updateRabbit(rabbit.id, {'cage_id': null}),
      '${rabbit.name} убран из клетки',
    );
  }

  Future<void> _moveRabbit(RabbitModel rabbit) async {
    final target = await showModalBottomSheet<CageModel>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CagePickerSheet(excludeCageId: widget.cageId),
    );
    if (target == null || !mounted) return;

    await _run(
      () => ref
          .read(rabbitsRepositoryProvider)
          .updateRabbit(rabbit.id, {'cage_id': target.id}),
      '${rabbit.name} переехал в клетку ${target.number}',
    );
  }

  Future<void> _addRabbit() async {
    final rabbit = await showModalBottomSheet<RabbitModel>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _RabbitPickerSheet(cageId: widget.cageId),
    );
    if (rabbit == null || !mounted) return;

    await _run(
      () => ref
          .read(rabbitsRepositoryProvider)
          .updateRabbit(rabbit.id, {'cage_id': widget.cageId}),
      '${rabbit.name} поселён в клетку',
    );
  }

  @override
  Widget build(BuildContext context) {
    final cageAsync = ref.watch(cageDetailProvider(widget.cageId));
    final canManage = ref.watch(canProvider(FarmCapability.manageLivestock));
    final cage = cageAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(cage == null ? 'Клетка' : 'Клетка ${cage.number}'),
        actions: [
          if (canManage && cage != null)
            IconButton(
              tooltip: 'Изменить клетку',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push('/cages/form', extra: cage),
            ),
        ],
        bottom: _busy
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(minHeight: 2),
              )
            : null,
      ),
      body: AbsorbPointer(
        absorbing: _busy,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: AppAsyncView<CageModel>(
            value: cageAsync,
            onRetry: _refresh,
            skeleton: (_) => const SkeletonList(count: 3, itemHeight: 120),
            builder: (cage) => _content(cage, canManage),
          ),
        ),
      ),
      floatingActionButton: _fab(cage, canManage),
    );
  }

  Widget? _fab(CageModel? cage, bool canManage) {
    if (cage == null || !canManage) return null;
    final full = cage.isFull ?? false;

    return FloatingActionButton.extended(
      // Заполненная клетка — не ошибка приложения, поэтому кнопка остаётся на
      // месте и прямо говорит, почему не работает.
      onPressed: full || _busy ? null : _addRabbit,
      icon: Icon(full ? Icons.do_not_disturb_on_outlined : Icons.add),
      label: Text(full ? 'Клетка заполнена' : 'Поселить кролика'),
    );
  }

  Widget _content(CageModel cage, bool canManage) {
    final rabbits = cage.rabbits ?? const <RabbitModel>[];

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.screenH,
        AppSpacing.fabSafeBottom,
      ),
      children: [
        _CageSummary(cage: cage),
        const SizedBox(height: AppSpacing.xl),
        AppSectionTitle(
          'Жители',
          subtitle: formatRabbits(rabbits.length),
        ),
        if (rabbits.isEmpty)
          AppCard(
            child: Row(
              children: [
                Icon(Icons.pets_outlined,
                    color: context.colors.onSurfaceVariant),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    canManage
                        ? 'Клетка пустая. Поселите кролика кнопкой внизу.'
                        : 'Клетка пустая.',
                    style: AppTypography.bodyMd
                        .copyWith(color: context.colors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          )
        else
          for (var i = 0; i < rabbits.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            _ResidentTile(
              rabbit: rabbits[i],
              canManage: canManage,
              onOpen: () => context.push('/rabbits/${rabbits[i].id}'),
              onMove: () => _moveRabbit(rabbits[i]),
              onRemove: () => _removeRabbit(rabbits[i]),
            ),
          ],
      ],
    );
  }
}

class _CageSummary extends StatelessWidget {
  final CageModel cage;

  const _CageSummary({required this.cage});

  @override
  Widget build(BuildContext context) {
    final occupied = cage.rabbits?.length ?? cage.currentOccupancy ?? 0;
    final conditionColor = cageConditionColor(context, cage.condition);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cageTypeLabel(cage.type),
                      style: AppTypography.titleMd
                          .copyWith(color: context.colors.onSurface),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      cageConditionLabel(cage.condition),
                      style:
                          AppTypography.labelLg.copyWith(color: conditionColor),
                    ),
                  ],
                ),
              ),
              _Occupancy(occupied: occupied, capacity: cage.capacity),
            ],
          ),
          const Divider(height: AppSpacing.xxl),
          Row(
            children: [
              Icon(Icons.place_outlined,
                  size: 20, color: context.colors.onSurfaceVariant),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  cage.location?.trim().isNotEmpty == true
                      ? cage.location!.trim()
                      : 'Место не указано',
                  style: AppTypography.bodyMd
                      .copyWith(color: context.colors.onSurface),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Occupancy extends StatelessWidget {
  final int occupied;
  final int capacity;

  const _Occupancy({required this.occupied, required this.capacity});

  @override
  Widget build(BuildContext context) {
    final ratio = capacity > 0 ? (occupied / capacity).clamp(0.0, 1.0) : 0.0;
    final color = ratio >= 1 ? AppColors.warning : AppColors.success;

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: ratio,
            backgroundColor: context.colors.surfaceContainerHighest,
            color: color,
            strokeWidth: 6,
          ),
          Text(
            '$occupied/$capacity',
            style: AppTypography.labelSm.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _ResidentTile extends StatelessWidget {
  final RabbitModel rabbit;
  final bool canManage;
  final VoidCallback onOpen;
  final VoidCallback onMove;
  final VoidCallback onRemove;

  const _ResidentTile({
    required this.rabbit,
    required this.canManage,
    required this.onOpen,
    required this.onMove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onOpen,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          RabbitAvatar(photoUrl: rabbit.photoUrl),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rabbit.name,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  rabbit.tagId,
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (canManage)
            PopupMenuButton<_ResidentAction>(
              tooltip: 'Действия',
              onSelected: (action) => switch (action) {
                _ResidentAction.move => onMove(),
                _ResidentAction.remove => onRemove(),
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: _ResidentAction.move,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.swap_horiz),
                    title: Text('Переселить'),
                  ),
                ),
                PopupMenuItem(
                  value: _ResidentAction.remove,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout, color: AppColors.error),
                    title: Text(
                      'Убрать',
                      style: AppTypography.bodyLg
                          .copyWith(color: AppColors.error),
                    ),
                  ),
                ),
              ],
            )
          else
            Icon(Icons.chevron_right, color: context.colors.onSurfaceVariant),
        ],
      ),
    );
  }
}

enum _ResidentAction { move, remove }

/// Кружок с фотографией кролика или значком-заглушкой.
class RabbitAvatar extends StatelessWidget {
  final String? photoUrl;
  final double size;

  const RabbitAvatar({super.key, this.photoUrl, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final url = ImageUrlHelper.getFullImageUrl(photoUrl);

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: url == null
            ? _placeholder(context)
            // Фото грузится через кэш: список жителей открывают по многу раз
            // за день, и каждый раз тянуть картинку заново незачем.
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, __) => _placeholder(context),
                errorWidget: (_, __, ___) => _placeholder(context),
              ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) => ColoredBox(
        color: AppColors.domainLivestock.withValues(alpha: 0.12),
        child: Icon(
          Icons.pets,
          size: size * 0.5,
          color: AppColors.domainLivestock,
        ),
      );
}

/// Выбор кролика для подселения.
///
/// Поиск идёт на сервере. Прежний вариант загружал первые сто кроликов и искал
/// среди них на устройстве: на ферме из трёхсот голов часть животных просто
/// невозможно было найти, и выглядело это как «кролика нет в системе».
class _RabbitPickerSheet extends ConsumerStatefulWidget {
  final int cageId;

  const _RabbitPickerSheet({required this.cageId});

  @override
  ConsumerState<_RabbitPickerSheet> createState() => _RabbitPickerSheetState();
}

class _RabbitPickerSheetState extends ConsumerState<_RabbitPickerSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;

  List<RabbitModel> _results = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(AppDuration.normal, () => _search(query));
  }

  Future<void> _search(String query) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await ref.read(rabbitsRepositoryProvider).getRabbits(
            limit: 30,
            search: query.trim().isEmpty ? null : query.trim(),
          );
      if (!mounted) return;
      setState(() {
        _results =
            page.items.where((r) => r.cageId != widget.cageId).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _PickerSheet(
      title: 'Кого поселить',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
            child: TextField(
              controller: _controller,
              autofocus: false,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Кличка или номер бирки',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onQueryChanged,
              onSubmitted: _search,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(child: _resultsView(context)),
        ],
      ),
    );
  }

  Widget _resultsView(BuildContext context) {
    if (_loading) return const DelayedSpinner();
    if (_error != null) {
      return AppErrorState(
        message: _error!,
        onRetry: () => _search(_controller.text),
      );
    }
    if (_results.isEmpty) {
      return const AppEmptyState(
        icon: Icons.search_off,
        title: 'Никого не нашлось',
        subtitle: 'Проверьте кличку или номер бирки.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        0,
        AppSpacing.screenH,
        AppSpacing.xl,
      ),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) {
        final rabbit = _results[i];
        // Кролик уже где-то живёт — это не запрет, а предупреждение: выбор
        // означает переезд. Раньше такие строки просто гасились, и было
        // непонятно, почему по ним нельзя нажать.
        final currentCage = rabbit.cage?.number;

        return AppCard(
          onTap: () => Navigator.pop(context, rabbit),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              RabbitAvatar(photoUrl: rabbit.photoUrl),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rabbit.name,
                      style: AppTypography.titleMd
                          .copyWith(color: context.colors.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currentCage != null
                          ? 'Сейчас в клетке $currentCage'
                          : 'Без клетки',
                      style: AppTypography.labelSm.copyWith(
                        color: currentCage != null
                            ? AppColors.warning
                            : context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                rabbit.tagId,
                style: AppTypography.labelSm
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Выбор клетки для переезда.
class _CagePickerSheet extends ConsumerWidget {
  final int excludeCageId;

  const _CagePickerSheet({required this.excludeCageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cagesProvider);
    final available = state.cages
        .where((c) => c.id != excludeCageId && (c.isAvailable ?? false))
        .toList();

    return _PickerSheet(
      title: 'Куда переселить',
      child: available.isEmpty
          ? const AppEmptyState(
              icon: Icons.grid_off_outlined,
              title: 'Свободных клеток нет',
              subtitle: 'Освободите место или добавьте новую клетку.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                0,
                AppSpacing.screenH,
                AppSpacing.xl,
              ),
              itemCount: available.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) {
                final cage = available[i];
                final occupied =
                    cage.rabbits?.length ?? cage.currentOccupancy ?? 0;

                return AppCard(
                  onTap: () => Navigator.pop(context, cage),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Клетка ${cage.number}',
                              style: AppTypography.titleMd
                                  .copyWith(color: context.colors.onSurface),
                            ),
                            Text(
                              [
                                cageTypeLabel(cage.type),
                                if (cage.location?.trim().isNotEmpty == true)
                                  cage.location!.trim(),
                              ].join(' · '),
                              style: AppTypography.labelSm.copyWith(
                                  color: context.colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$occupied/${cage.capacity}',
                        style: AppTypography.labelLg
                            .copyWith(color: context.colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

/// Общая рамка модальной шторки выбора: заголовок и высота в три четверти
/// экрана, чтобы список не приходилось листать в щели.
class _PickerSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const _PickerSheet({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              0,
              AppSpacing.screenH,
              AppSpacing.lg,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: AppTypography.titleLg
                    .copyWith(color: context.colors.onSurface),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
