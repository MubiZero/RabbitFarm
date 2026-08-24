import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/breeding_provider.dart';
import '../../../rabbits/data/models/breeding_model.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/l10n/error_text.dart';

class BreedingDetailScreen extends ConsumerWidget {
  final int breedingId;

  const BreedingDetailScreen({super.key, required this.breedingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedingAsync = ref.watch(breedingDetailProvider(breedingId));
    final breeding = breedingAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.breedingDetailTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: breeding == null
                ? null
                : () => context.push(
                      '/breeding/$breedingId/edit',
                      extra: breeding,
                    ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(breedingDetailProvider(breedingId));
          await ref.read(breedingDetailProvider(breedingId).future);
        },
        child: AppAsyncView<BreedingModel>(
          value: breedingAsync,
          onRetry: () => ref.invalidate(breedingDetailProvider(breedingId)),
          skeleton: (_) => const SkeletonList(itemHeight: 120),
          builder: (breeding) => _buildContent(context, ref, breeding),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, BreedingModel breeding) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    final cs = Theme.of(context).colorScheme;
    switch (breeding.status) {
      case 'planned':
        statusColor = AppColors.accentOcean;
        statusText = context.l10n.breedingStatusPlanned;
        statusIcon = Icons.schedule;
        break;
      case 'completed':
        statusColor = AppColors.success;
        statusText = context.l10n.breedingStatusCompleted;
        statusIcon = Icons.check_circle;
        break;
      case 'failed':
        statusColor = AppColors.error;
        statusText = context.l10n.breedingStatusFailed;
        statusIcon = Icons.cancel;
        break;
      case 'cancelled':
        statusColor = cs.onSurfaceVariant;
        statusText = context.l10n.breedingStatusCancelled;
        statusIcon = Icons.block;
        break;
      default:
        statusColor = cs.onSurfaceVariant;
        statusText = breeding.status;
        statusIcon = Icons.help;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Статус
        Card(
          color: statusColor.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(statusIcon, size: 48, color: statusColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.breedingStatus,
                        style: AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusText,
                        style: AppTypography.displayMd
                            .copyWith(color: statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Родители
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.breedingParents,
                  style: AppTypography.titleLg,
                ),
                const Divider(height: 24),
                
                // Самец
                Row(
                  children: [
                    const Icon(Icons.male, color: AppColors.accentOcean),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.breedingMale, style: AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant)),
                          const SizedBox(height: 4),
                          Text(
                            breeding.male?.name ?? context.l10n.commonNameMissing,
                            style: AppTypography.titleMd,
                          ),
                          if (breeding.male?.tagId != null)
                            Text(
                              context.l10n.breedingTag(breeding.male!.tagId!),
                              style: AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () => context.push('/rabbits/${breeding.maleId}'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Самка
                Row(
                  children: [
                    const Icon(Icons.female, color: AppColors.accentRose),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.breedingFemale, style: AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant)),
                          const SizedBox(height: 4),
                          Text(
                            breeding.female?.name ?? context.l10n.commonNameMissing,
                            style: AppTypography.titleMd,
                          ),
                          if (breeding.female?.tagId != null)
                            Text(
                              context.l10n.breedingTag(breeding.female!.tagId!),
                              style: AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () => context.push('/rabbits/${breeding.femaleId}'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Даты
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.breedingDates,
                  style: AppTypography.titleLg,
                ),
                const Divider(height: 24),
                
                _buildDateRow(
                  context: context,
                  icon: Icons.favorite,
                  label: context.l10n.breedingDate,
                  date: breeding.breedingDate,
                  color: AppColors.accentViolet,
                ),

                if (breeding.expectedBirthDate != null) ...[
                  const SizedBox(height: 12),
                  _buildDateRow(
                    context: context,
                    icon: Icons.calendar_today,
                    label: context.l10n.breedingExpected,
                    date: breeding.expectedBirthDate!,
                    color: AppColors.success,
                  ),
                ],

                if (breeding.palpationDate != null) ...[
                  const SizedBox(height: 12),
                  _buildDateRow(
                    context: context,
                    icon: Icons.touch_app,
                    label: context.l10n.breedingPalpation,
                    date: breeding.palpationDate!,
                    color: AppColors.warning,
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Беременность
        if (breeding.isPregnant != null)
          Card(
            color: breeding.isPregnant! ? AppColors.success.withValues(alpha: 0.08) : AppColors.warning.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    breeding.isPregnant! ? Icons.check_circle : Icons.help_outline,
                    color: breeding.isPregnant! ? AppColors.success : AppColors.warning,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.breedingPregnancy,
                          style: AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          breeding.isPregnant! ? context.l10n.breedingPregnancyYes : context.l10n.breedingPregnancyNo,
                          style: AppTypography.titleMd,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Заметки
        if (breeding.notes != null && breeding.notes!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notes),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n.breedingNotes,
                        style: AppTypography.titleLg,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(breeding.notes!),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Кнопка регистрации окрола
        if (breeding.status == 'completed' || breeding.status == 'planned')
          ElevatedButton.icon(
            onPressed: () {
              context.push('/births/new', extra: breeding);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: AppColors.success,
            ),
            icon: const Icon(Icons.child_care),
            label: Text(
              context.l10n.breedingRegisterBirth,
              style: AppTypography.titleMd,
            ),
          ),

        const SizedBox(height: 16),

        // Кнопка удаления
        OutlinedButton.icon(
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(context.l10n.breedingDeleteTitle),
                content: Text(context.l10n.breedingDeleteBody),
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

            if (confirmed == true && context.mounted) {
              try {
                await ref.read(breedingRepositoryProvider).deleteBreeding(breedingId);
                ref.invalidate(breedingListProvider);
                ref.invalidate(breedingDetailProvider(breedingId));
                if (context.mounted) {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.breedingDeleted)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.commonActionFailed(
                          errorText(context.l10n, e))),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            }
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error),
          ),
          icon: const Icon(Icons.delete),
          label: Text(context.l10n.commonDelete),
        ),
      ],
    );
  }

  Widget _buildDateRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String date,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelSm.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(
                _formatDate(date),
                style: AppTypography.labelLg,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}.${date.month}.${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
