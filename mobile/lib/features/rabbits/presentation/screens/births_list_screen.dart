import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/birth_model.dart';
import '../providers/births_provider.dart';
import '../providers/rabbits_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';

/// Экран списка окролов
class BirthsListScreen extends ConsumerStatefulWidget {
  const BirthsListScreen({super.key});

  @override
  ConsumerState<BirthsListScreen> createState() => _BirthsListScreenState();
}

class _BirthsListScreenState extends ConsumerState<BirthsListScreen> {
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    final birthsState = ref.watch(birthsProvider);
    final rabbitsState = ref.watch(rabbitsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Окролы'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(birthsProvider.notifier).loadBirths();
        },
        child: birthsState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : birthsState.error != null
                ? AppErrorState(
                    message: birthsState.error!,
                    onRetry: () => ref.read(birthsProvider.notifier).loadBirths(),
                  )
                : birthsState.births.isEmpty
                    ? AppEmptyState(
                        icon: Icons.child_care,
                        title: 'Окролов пока нет',
                        subtitle: 'Зарегистрируйте первый окрол',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: birthsState.births.length,
                        itemBuilder: (context, index) {
                          final birth = birthsState.births[index];
                          final mother = rabbitsState.rabbits.firstWhere(
                            (r) => r.id == birth.motherId,
                            orElse: () => throw Exception('Mother not found'),
                          );

                          return _BirthCard(
                            birth: birth,
                            motherName: mother.name,
                            dateFormat: _dateFormat,
                            onDelete: () => _deleteBirth(birth),
                          );
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/births/new');
        },
        icon: const Icon(Icons.add),
        label: const Text('Добавить окрол'),
      ),
    );
  }

  Future<void> _deleteBirth(BirthModel birth) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить окрол?'),
        content: const Text(
          'Это действие нельзя отменить. Карточки крольчат останутся в базе.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await ref.read(birthsProvider.notifier).deleteBirth(birth.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Окрол удален' : 'Ошибка удаления окрола',
            ),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }
}

/// Карточка окрола
class _BirthCard extends StatelessWidget {
  final BirthModel birth;
  final String motherName;
  final DateFormat dateFormat;
  final VoidCallback onDelete;

  const _BirthCard({
    required this.birth,
    required this.motherName,
    required this.dateFormat,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final totalKits = birth.kitsBornAlive + birth.kitsBornDead;
    final survivalRate = totalKits > 0
        ? (birth.kitsBornAlive / totalKits * 100).toStringAsFixed(0)
        : '0';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Navigate to birth detail screen
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Date and actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        dateFormat.format(DateTime.parse(birth.birthDate)),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    color: AppColors.error,
                    tooltip: 'Удалить окрол',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Mother info
              Row(
                children: [
                  Icon(Icons.female, size: 16, color: Theme.of(context).colorScheme.tertiary),
                  const SizedBox(width: 8),
                  Text(
                    'Мать: $motherName',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Stats
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      icon: Icons.child_care,
                      label: 'Живых',
                      value: birth.kitsBornAlive.toString(),
                      color: AppColors.success,
                    ),
                    _StatItem(
                      icon: Icons.close,
                      label: 'Мёртвых',
                      value: birth.kitsBornDead.toString(),
                      color: AppColors.error,
                    ),
                    _StatItem(
                      icon: Icons.percent,
                      label: 'Выживаемость',
                      value: '$survivalRate%',
                      color: AppColors.info,
                    ),
                  ],
                ),
              ),

              // Weaned info
              if (birth.kitsWeaned != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: AppColors.success),
                    const SizedBox(width: 8),
                    Text(
                      'Отсажено: ${birth.kitsWeaned} крольчат',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.success,
                          ),
                    ),
                  ],
                ),
              ],

              // Complications
              if (birth.complications != null && birth.complications!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, size: 16, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          birth.complications!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.warning,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Notes
              if (birth.notes != null && birth.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  birth.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Статистическая метрика
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
