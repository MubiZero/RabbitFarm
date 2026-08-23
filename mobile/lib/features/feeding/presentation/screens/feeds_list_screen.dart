import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/feed_model.dart';
import '../providers/feeds_provider.dart';
import '../utils/feed_labels.dart';

/// Склад кормов.
class FeedsListScreen extends ConsumerStatefulWidget {
  const FeedsListScreen({super.key});

  @override
  ConsumerState<FeedsListScreen> createState() => _FeedsListScreenState();
}

class _FeedsListScreenState extends ConsumerState<FeedsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedsProvider.notifier).loadFeeds(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedsProvider);
    final notifier = ref.read(feedsProvider.notifier);
    final canManage = ref.watch(canProvider(FarmCapability.manageStock));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.feedsTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.commonSummary,
            icon: const Icon(Icons.insights_outlined),
            onPressed: () => context.push('/feeds/statistics'),
          ),
        ],
      ),
      body: PagedListView<Feed>(
        items: state.feeds,
        isLoading: state.isLoading,
        error: state.error,
        hasMore: state.hasMore,
        onRefresh: notifier.refresh,
        onLoadMore: notifier.loadMore,
        header: _Filters(state: state),
        empty: state.hasFilters
            ? AppEmptyState(
                icon: Icons.filter_alt_off_outlined,
                title: context.l10n.feedsNoneInView,
                subtitle: context.l10n.feedsNoneInViewBody,
                actionLabel: context.l10n.commonReset,
                onAction: notifier.clearFilters,
              )
            : AppEmptyState(
                icon: Icons.inventory_2_outlined,
                title: context.l10n.feedsEmptyTitle,
                subtitle: context.l10n.feedsEmptyBody,
                actionLabel: canManage ? context.l10n.feedsAdd : null,
                onAction: canManage ? () => context.push('/feeds/form') : null,
              ),
        itemBuilder: (context, feed, _) => _FeedCard(
          feed: feed,
          canManage: canManage,
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => _FeedDetailsSheet(feed: feed),
          ),
          onAdjust: (isAddition) =>
              _adjustStock(context, feed, isAddition: isAddition),
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/feeds/form'),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.feedsAdd),
            )
          : null,
    );
  }

  Future<void> _adjustStock(
    BuildContext context,
    Feed feed, {
    required bool isAddition,
  }) async {
    // Всё, что зависит от контекста, снимается до ожидания: экран может
    // закрыться, пока идёт запрос.
    final messenger = ScaffoldMessenger.of(context);
    final refilled = context.l10n.feedsRefilled;
    final writtenOff = context.l10n.feedsWrittenOff;
    final failed = context.l10n.feedsAdjustFailed;

    final quantity = await showDialog<double>(
      context: context,
      builder: (_) => _StockDialog(feed: feed, isAddition: isAddition),
    );
    if (quantity == null) return;

    final amount = formatQuantity(quantity, feed.unit.displayName);
    final done = isAddition ? refilled(amount) : writtenOff(amount);

    final error = await ref.read(feedsProvider.notifier).adjustStock(
          feed.id,
          StockAdjustment(
            quantity: quantity,
            operation: isAddition ? 'add' : 'subtract',
          ),
        );

    // Сообщение показывается после ответа сервера, а не вместо него: раньше
    // «склад пополнен» появлялось даже при отказе, и остаток не менялся.
    messenger.showSnackBar(
      error == null
          ? SnackBar(content: Text(done))
          : SnackBar(
              content: Text('$failed: $error'),
              backgroundColor: AppColors.error,
            ),
    );
  }
}

class _Filters extends ConsumerWidget {
  final FeedsState state;

  const _Filters({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(feedsProvider.notifier);

    return AppFilterBar(
      chips: [
        AppFilterChipData(
          label: context.l10n.feedsFilterAll,
          isSelected: !state.hasFilters,
          onTap: notifier.clearFilters,
        ),
        AppFilterChipData(
          label: context.l10n.feedsFilterLowStock,
          isSelected: state.lowStockOnly,
          onTap: () => notifier.setFilters(
            type: state.type,
            lowStockOnly: !state.lowStockOnly,
          ),
          color: AppColors.warning,
        ),
        // Типы берутся из самой модели: раньше пять из них были переписаны в
        // экране руками и могли разойтись с подписями в других местах.
        for (final type in FeedType.values)
          AppFilterChipData(
            label: type.displayName,
            isSelected: state.type == type,
            onTap: () => notifier.setFilters(
              type: state.type == type ? null : type,
              lowStockOnly: state.lowStockOnly,
            ),
            color: type.color,
          ),
      ],
    );
  }
}

class _FeedCard extends StatelessWidget {
  final Feed feed;
  final bool canManage;
  final VoidCallback onTap;
  final void Function(bool isAddition) onAdjust;

  const _FeedCard({
    required this.feed,
    required this.canManage,
    required this.onTap,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    final low = feed.currentStock <= feed.minStock;
    final stockColor = low ? AppColors.warning : context.colors.onSurface;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: feed.type.color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.smAll,
                ),
                child: Icon(feed.type.icon, color: feed.type.color, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feed.name,
                      style: AppTypography.titleMd
                          .copyWith(color: context.colors.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      feed.type.displayName,
                      style: AppTypography.labelSm
                          .copyWith(color: context.colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatQuantity(feed.currentStock, feed.unit.displayName),
                    style: AppTypography.titleLg.copyWith(color: stockColor),
                  ),
                  Text(
                    '${context.l10n.feedsMinStock} ${formatQuantity(feed.minStock, feed.unit.displayName)}',
                    style: AppTypography.labelSm
                        .copyWith(color: context.colors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          if (low) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(Icons.warning_amber_outlined,
                    size: 16, color: AppColors.warning),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  context.l10n.feedsLowStockWarning,
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.warning),
                ),
              ],
            ),
          ],
          if (canManage) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onAdjust(true),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(context.l10n.feedsRefill),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      foregroundColor: AppColors.success,
                      side: const BorderSide(color: AppColors.success),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onAdjust(false),
                    icon: const Icon(Icons.remove, size: 18),
                    label: Text(context.l10n.feedsWriteOff),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      foregroundColor: context.colors.onSurfaceVariant,
                      side: BorderSide(color: context.colors.outline),
                    ),
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

/// Диалог пополнения и списания.
class _StockDialog extends StatefulWidget {
  final Feed feed;
  final bool isAddition;

  const _StockDialog({required this.feed, required this.isAddition});

  @override
  State<_StockDialog> createState() => _StockDialogState();
}

class _StockDialogState extends State<_StockDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantity = TextEditingController();

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, parseDecimal(_quantity.text));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(
          widget.isAddition ? l10n.feedsRefillTitle : l10n.feedsWriteOffTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.feed.name,
              style: AppTypography.titleMd
                  .copyWith(color: context.colors.onSurface),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.feedsCurrentStock(formatQuantity(
                  widget.feed.currentStock, widget.feed.unit.displayName)),
              style: AppTypography.bodyMd
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _quantity,
              autofocus: true,
              // Дробный ввод: мешки и килограммы редко бывают целыми.
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.feedsQuantity,
                suffixText: widget.feed.unit.displayName,
              ),
              onFieldSubmitted: (_) => _submit(),
              validator: (v) {
                final value = parseDecimal(v);
                // Раньше «2,5» молча ничего не делало: кнопка нажималась,
                // разбор падал, диалог оставался открытым без объяснений.
                if (value == null) return l10n.commonNumberInvalid;
                if (value <= 0) return l10n.feedsQuantityPositive;
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: _submit,
          child: Text(l10n.commonApply),
        ),
      ],
    );
  }
}

class _FeedDetailsSheet extends ConsumerWidget {
  final Feed feed;

  const _FeedDetailsSheet({required this.feed});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.feedsDeleteTitle),
        content: Text(context.l10n.feedsDeleteBody(feed.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final done = context.l10n.feedsDeleted;
    final failed = context.l10n.feedsDeleteFailed;

    final error = await ref.read(feedsProvider.notifier).deleteFeed(feed.id);
    if (error == null) {
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(done)));
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text('$failed: $error'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canManage = ref.watch(canProvider(FarmCapability.manageStock));
    final canDelete = ref.watch(canProvider(FarmCapability.deleteRecords));
    final low = feed.currentStock <= feed.minStock;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          0,
          AppSpacing.screenH,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: feed.type.color.withValues(alpha: 0.12),
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: Icon(feed.type.icon, color: feed.type.color),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feed.name,
                        style: AppTypography.titleLg
                            .copyWith(color: context.colors.onSurface),
                      ),
                      Text(
                        feed.type.displayName,
                        style: AppTypography.labelSm
                            .copyWith(color: context.colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                if (canManage)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/feeds/form', extra: feed);
                    },
                  ),
                if (canDelete)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: AppColors.error,
                    onPressed: () => _delete(context, ref),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    icon: Icons.inventory_2_outlined,
                    label: context.l10n.feedsInStock,
                    value: formatQuantity(
                        feed.currentStock, feed.unit.displayName),
                    accent: low ? AppColors.warning : AppColors.success,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StatTile(
                    icon: Icons.low_priority,
                    label: context.l10n.feedsMinStock,
                    value:
                        formatQuantity(feed.minStock, feed.unit.displayName),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
