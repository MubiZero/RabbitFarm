import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/rabbit_model.dart';
import '../../data/models/rabbit_weight_model.dart';
import '../providers/weights_provider.dart';
import '../widgets/weight_chart.dart';

/// История взвешиваний одного кролика.
class WeightHistoryScreen extends ConsumerWidget {
  final RabbitModel rabbit;

  const WeightHistoryScreen({super.key, required this.rabbit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightsAsync = ref.watch(weightHistoryProvider(rabbit.id));
    final canRecord = ref.watch(canProvider(FarmCapability.manageLivestock));

    Future<void> refresh() async {
      ref.invalidate(weightHistoryProvider(rabbit.id));
      await ref.read(weightHistoryProvider(rabbit.id).future);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.weightTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.screenH,
              bottom: AppSpacing.sm,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                rabbit.label,
                style: AppTypography.bodyMd
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: AppAsyncView<List<RabbitWeight>>(
          value: weightsAsync,
          onRetry: refresh,
          skeleton: (_) => const SkeletonList(itemHeight: 72),
          builder: (weights) => weights.isEmpty
              ? AppEmptyState(
                  icon: Icons.scale_outlined,
                  title: context.l10n.weightEmptyTitle,
                  subtitle: context.l10n.weightEmptyBody,
                  actionLabel: canRecord ? context.l10n.weightAdd : null,
                  onAction: canRecord
                      ? () => _showAddDialog(context, ref)
                      : null,
                )
              : _content(context, weights),
        ),
      ),
      floatingActionButton: canRecord
          ? FloatingActionButton.extended(
              onPressed: () => _showAddDialog(context, ref),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.weightAdd),
            )
          : null,
    );
  }

  Widget _content(BuildContext context, List<RabbitWeight> weights) {
    final latest = weights.first;
    final oldest = weights.last;
    final totalChange = latest.weight - oldest.weight;
    final trend = weights.length >= 2 ? latest.weight - weights[1].weight : null;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.screenH,
        AppSpacing.fabSafeBottom,
      ),
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: WeightChart(weights: weights),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppSectionTitle(context.l10n.weightSummary),
        Row(
          children: [
            Expanded(
              child: StatTile(
                icon: Icons.scale_outlined,
                label: context.l10n.weightCurrent,
                value: formatQuantity(latest.weight, 'кг'),
                accent: AppColors.domainLivestock,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatTile(
                icon: _changeIcon(trend),
                label: context.l10n.weightTrend,
                value: _changeText(trend),
                accent: _changeColor(context, trend),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatTile(
                icon: _changeIcon(totalChange),
                label: context.l10n.weightTotalChange,
                value: _changeText(totalChange),
                accent: _changeColor(context, totalChange),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        AppSectionTitle(context.l10n.weightHistory),
        for (var i = 0; i < weights.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          _WeightRow(
            weight: weights[i],
            difference: i < weights.length - 1
                ? weights[i].weight - weights[i + 1].weight
                : null,
          ),
        ],
      ],
    );
  }

  /// Потеря веса — повод присмотреться, а не авария, поэтому она помечена
  /// предупреждающим цветом, а не тревожным. Раньше одна и та же убыль в
  /// соседних плитках красилась то оранжевым, то красным.
  Color _changeColor(BuildContext context, double? change) {
    if (change == null || change == 0) return context.colors.onSurfaceVariant;
    return change > 0 ? AppColors.success : AppColors.warning;
  }

  IconData _changeIcon(double? change) {
    if (change == null || change == 0) return Icons.remove;
    return change > 0 ? Icons.trending_up : Icons.trending_down;
  }

  String _changeText(double? change) {
    if (change == null) return '—';
    final sign = change > 0 ? '+' : '';
    return '$sign${formatQuantity(change, 'кг')}';
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AddWeightDialog(
        rabbitId: rabbit.id,
        onSuccess: () => ref.invalidate(weightHistoryProvider(rabbit.id)),
      ),
    );
  }
}

class _WeightRow extends StatelessWidget {
  final RabbitWeight weight;
  final double? difference;

  const _WeightRow({required this.weight, required this.difference});

  @override
  Widget build(BuildContext context) {
    final change = difference;
    final changeColor = change == null || change == 0
        ? context.colors.onSurfaceVariant
        : change > 0
            ? AppColors.success
            : AppColors.warning;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.domainLivestock.withValues(alpha: 0.12),
              borderRadius: AppRadius.smAll,
            ),
            child: const Icon(Icons.scale_outlined,
                color: AppColors.domainLivestock, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      formatQuantity(weight.weight, 'кг'),
                      style: AppTypography.titleMd
                          .copyWith(color: context.colors.onSurface),
                    ),
                    if (change != null && change != 0) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        change > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 14,
                        color: changeColor,
                      ),
                      Text(
                        formatQuantity(change.abs(), 'кг'),
                        style:
                            AppTypography.labelSm.copyWith(color: changeColor),
                      ),
                    ],
                  ],
                ),
                Text(
                  DateFormat('d MMMM y, HH:mm', 'ru').format(weight.measuredAt),
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
                if (weight.notes?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    weight.notes!.trim(),
                    style: AppTypography.bodyMd
                        .copyWith(color: context.colors.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddWeightDialog extends ConsumerStatefulWidget {
  final int rabbitId;
  final VoidCallback onSuccess;

  const AddWeightDialog({
    super.key,
    required this.rabbitId,
    required this.onSuccess,
  });

  @override
  ConsumerState<AddWeightDialog> createState() => _AddWeightDialogState();
}

class _AddWeightDialogState extends ConsumerState<AddWeightDialog> {
  final _formKey = GlobalKey<FormState>();
  final _weight = TextEditingController();
  final _notes = TextEditingController();
  DateTime _measuredAt = DateTime.now();
  bool _busy = false;

  @override
  void dispose() {
    _weight.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _measuredAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_measuredAt),
    );
    if (time == null) return;

    setState(() {
      _measuredAt = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final done = context.l10n.weightSaved;
    final failed = context.l10n.weightSaveFailed;

    setState(() => _busy = true);
    final notifier = ref.read(weightsNotifierProvider.notifier);
    await notifier.addWeightRecord(
      widget.rabbitId,
      AddWeightRequest(
        weight: parseDecimal(_weight.text)!,
        measuredAt: _measuredAt,
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      ),
    );
    if (mounted) setState(() => _busy = false);

    final state = ref.read(weightsNotifierProvider);
    if (state.hasError) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('$failed: ${state.error}'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    widget.onSuccess();
    navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(done)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.weightAdd),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _weight,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.weightValue,
                hintText: l10n.weightValueHint,
                prefixIcon: const Icon(Icons.scale_outlined),
              ),
              validator: (v) {
                final value = parseDecimal(v);
                if (value == null) return l10n.weightValueEmpty;
                if (value <= 0) return l10n.weightValuePositive;
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            InkWell(
              borderRadius: AppRadius.mdAll,
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.weightWhen,
                  prefixIcon: const Icon(Icons.event_outlined),
                ),
                child: Text(
                  DateFormat('d MMMM y, HH:mm', 'ru').format(_measuredAt),
                  style: AppTypography.bodyLg
                      .copyWith(color: context.colors.onSurface),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _notes,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: l10n.weightNotes,
                prefixIcon: const Icon(Icons.sticky_note_2_outlined),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: _busy ? null : _submit,
          child: Text(l10n.commonAdd),
        ),
      ],
    );
  }
}
