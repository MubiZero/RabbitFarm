import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/breeding_provider.dart';
import '../../../rabbits/data/models/breeding_model.dart';
import '../../../../core/theme/app_colors.dart';

class BreedingDetailScreen extends ConsumerWidget {
  final int breedingId;

  const BreedingDetailScreen({super.key, required this.breedingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedingAsync = ref.watch(breedingDetailProvider(breedingId));
    final breeding = breedingAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали случки'),
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
      body: breedingAsync.when(
        data: (breeding) => _buildContent(context, ref, breeding),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: AppColors.error.withValues(alpha: 0.6)),
              const SizedBox(height: 16),
              Text('Ошибка загрузки: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(breedingDetailProvider(breedingId)),
                child: const Text('Повторить'),
              ),
            ],
          ),
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
        statusText = 'Запланирована';
        statusIcon = Icons.schedule;
        break;
      case 'completed':
        statusColor = AppColors.success;
        statusText = 'Завершена';
        statusIcon = Icons.check_circle;
        break;
      case 'failed':
        statusColor = AppColors.error;
        statusText = 'Неудачная';
        statusIcon = Icons.cancel;
        break;
      case 'cancelled':
        statusColor = cs.onSurfaceVariant;
        statusText = 'Отменена';
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
                        'Статус',
                        style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
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
                const Text(
                  'Родители',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          Text('Самец', style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                          const SizedBox(height: 4),
                          Text(
                            breeding.male?.name ?? 'ID: ${breeding.maleId}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          if (breeding.male?.tagId != null)
                            Text(
                              'Бирка: ${breeding.male!.tagId}',
                              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
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
                          Text('Самка', style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                          const SizedBox(height: 4),
                          Text(
                            breeding.female?.name ?? 'ID: ${breeding.femaleId}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          if (breeding.female?.tagId != null)
                            Text(
                              'Бирка: ${breeding.female!.tagId}',
                              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
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
                const Text(
                  'Даты',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 24),
                
                _buildDateRow(
                  context: context,
                  icon: Icons.favorite,
                  label: 'Дата случки',
                  date: breeding.breedingDate,
                  color: AppColors.accentViolet,
                ),

                if (breeding.expectedBirthDate != null) ...[
                  const SizedBox(height: 12),
                  _buildDateRow(
                    context: context,
                    icon: Icons.calendar_today,
                    label: 'Ожидаемый окрол',
                    date: breeding.expectedBirthDate!,
                    color: AppColors.success,
                  ),
                ],

                if (breeding.palpationDate != null) ...[
                  const SizedBox(height: 12),
                  _buildDateRow(
                    context: context,
                    icon: Icons.touch_app,
                    label: 'Дата пальпации',
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
                          'Беременность',
                          style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          breeding.isPregnant! ? 'Подтверждена' : 'Не подтверждена',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  const Row(
                    children: [
                      Icon(Icons.notes),
                      SizedBox(width: 8),
                      Text(
                        'Заметки',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            label: const Text(
              'Зарегистрировать окрол',
              style: TextStyle(fontSize: 16),
            ),
          ),

        const SizedBox(height: 16),

        // Кнопка удаления
        OutlinedButton.icon(
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Удалить случку?'),
                content: const Text('Это действие нельзя отменить'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: TextButton.styleFrom(foregroundColor: AppColors.error),
                    child: const Text('Удалить'),
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
                    const SnackBar(
                      content: Text('Случка удалена'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ошибка: ${e.toString().replaceAll('Exception: ', '')}'),
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
          label: const Text('Удалить случку'),
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
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Text(
                _formatDate(date),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
