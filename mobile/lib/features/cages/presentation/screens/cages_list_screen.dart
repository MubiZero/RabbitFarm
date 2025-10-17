import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/cage_model.dart';
import '../providers/cages_provider.dart';

/// Экран списка клеток
class CagesListScreen extends ConsumerStatefulWidget {
  const CagesListScreen({super.key});

  @override
  ConsumerState<CagesListScreen> createState() => _CagesListScreenState();
}

class _CagesListScreenState extends ConsumerState<CagesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cagesState = ref.watch(cagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Клетки'),
        centerTitle: true,
        backgroundColor: Colors.orange[700],
        actions: [
          // Фильтры
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
          // Только доступные
          IconButton(
            icon: Icon(
              cagesState.onlyAvailable
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
            ),
            tooltip: 'Только доступные',
            onPressed: () {
              ref.read(cagesProvider.notifier).toggleOnlyAvailable();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Поиск
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск клеток...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(cagesProvider.notifier).updateSearchQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                ref.read(cagesProvider.notifier).updateSearchQuery(value);
              },
            ),
          ),

          // Активные фильтры
          if (cagesState.typeFilter != null ||
              cagesState.conditionFilter != null ||
              cagesState.locationFilter != null)
            _buildActiveFilters(cagesState),

          // Список клеток
          Expanded(
            child: _buildCagesList(context, cagesState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCageForm(context, null),
        backgroundColor: Colors.orange[700],
        icon: const Icon(Icons.add),
        label: const Text('Добавить клетку'),
      ),
    );
  }

  Widget _buildActiveFilters(CagesState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (state.typeFilter != null)
            Chip(
              label: Text(_getTypeText(state.typeFilter!)),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                ref.read(cagesProvider.notifier).setTypeFilter(null);
              },
            ),
          if (state.conditionFilter != null)
            Chip(
              label: Text(_getConditionText(state.conditionFilter!)),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                ref.read(cagesProvider.notifier).setConditionFilter(null);
              },
            ),
          if (state.locationFilter != null)
            Chip(
              label: Text(state.locationFilter!),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                ref.read(cagesProvider.notifier).setLocationFilter(null);
              },
            ),
          TextButton.icon(
            onPressed: () {
              ref.read(cagesProvider.notifier).resetFilters();
            },
            icon: const Icon(Icons.clear_all, size: 18),
            label: const Text('Сбросить все'),
          ),
        ],
      ),
    );
  }

  Widget _buildCagesList(BuildContext context, CagesState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Ошибка загрузки клеток',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.read(cagesProvider.notifier).loadCages(),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    final cages = state.filteredCages;

    if (cages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              state.searchQuery.isNotEmpty ? Icons.search_off : Icons.home_work,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isNotEmpty
                  ? 'Клетки не найдены'
                  : 'Нет клеток',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              state.searchQuery.isNotEmpty
                  ? 'Попробуйте изменить запрос'
                  : 'Добавьте первую клетку',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(cagesProvider.notifier).loadCages(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cages.length,
        itemBuilder: (context, index) {
          final cage = cages[index];
          return _buildCageCard(context, cage);
        },
      ),
    );
  }

  Widget _buildCageCard(BuildContext context, CageModel cage) {
    final occupancyRate = cage.capacity > 0
        ? (cage.currentOccupancy ?? 0) / cage.capacity
        : 0.0;

    Color statusColor = Colors.green;
    if (cage.condition == 'broken') {
      statusColor = Colors.red;
    } else if (cage.condition == 'needs_repair') {
      statusColor = Colors.orange;
    } else if (cage.isFull ?? false) {
      statusColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showCageDetails(context, cage),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getCageIcon(cage.type),
                      color: statusColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Клетка ${cage.number}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (cage.location != null)
                          Text(
                            cage.location!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Действия
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showCageForm(context, cage);
                      } else if (value == 'clean') {
                        _markCleaned(context, cage);
                      } else if (value == 'delete') {
                        _confirmDelete(context, cage);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Редактировать'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'clean',
                        child: Row(
                          children: [
                            Icon(Icons.cleaning_services, size: 20),
                            SizedBox(width: 8),
                            Text('Отметить уборку'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Удалить', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Прогресс заполненности
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Заполненность: ${cage.currentOccupancy ?? 0}/${cage.capacity}',
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        '${(occupancyRate * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: occupancyRate,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Характеристики
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    Icons.category,
                    _getTypeText(cage.type),
                    Colors.blue,
                  ),
                  _buildInfoChip(
                    Icons.build,
                    _getConditionText(cage.condition),
                    _getConditionColor(cage.condition),
                  ),
                  if (cage.size != null)
                    _buildInfoChip(
                      Icons.straighten,
                      cage.size!,
                      Colors.purple,
                    ),
                  if (cage.lastCleanedAt != null)
                    _buildInfoChip(
                      Icons.cleaning_services,
                      'Уборка: ${DateFormat('dd.MM').format(cage.lastCleanedAt!)}',
                      Colors.teal,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  IconData _getCageIcon(String type) {
    switch (type) {
      case 'single':
        return Icons.home;
      case 'group':
        return Icons.home_work;
      case 'maternity':
        return Icons.child_care;
      default:
        return Icons.home;
    }
  }

  String _getTypeText(String type) {
    switch (type) {
      case 'single':
        return 'Одиночная';
      case 'group':
        return 'Групповая';
      case 'maternity':
        return 'Для окрола';
      default:
        return type;
    }
  }

  String _getConditionText(String condition) {
    switch (condition) {
      case 'good':
        return 'Хорошее';
      case 'needs_repair':
        return 'Нужен ремонт';
      case 'broken':
        return 'Сломана';
      default:
        return condition;
    }
  }

  Color _getConditionColor(String condition) {
    switch (condition) {
      case 'good':
        return Colors.green;
      case 'needs_repair':
        return Colors.orange;
      case 'broken':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final state = ref.watch(cagesProvider);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Фильтры',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              // Фильтр по типу
              Text('Тип клетки:', style: Theme.of(context).textTheme.titleSmall),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Все'),
                    selected: state.typeFilter == null,
                    onSelected: (_) {
                      ref.read(cagesProvider.notifier).setTypeFilter(null);
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text('Одиночная'),
                    selected: state.typeFilter == 'single',
                    onSelected: (_) {
                      ref.read(cagesProvider.notifier).setTypeFilter('single');
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text('Групповая'),
                    selected: state.typeFilter == 'group',
                    onSelected: (_) {
                      ref.read(cagesProvider.notifier).setTypeFilter('group');
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text('Для окрола'),
                    selected: state.typeFilter == 'maternity',
                    onSelected: (_) {
                      ref.read(cagesProvider.notifier).setTypeFilter('maternity');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Фильтр по состоянию
              Text('Состояние:', style: Theme.of(context).textTheme.titleSmall),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Все'),
                    selected: state.conditionFilter == null,
                    onSelected: (_) {
                      ref.read(cagesProvider.notifier).setConditionFilter(null);
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text('Хорошее'),
                    selected: state.conditionFilter == 'good',
                    onSelected: (_) {
                      ref.read(cagesProvider.notifier).setConditionFilter('good');
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text('Нужен ремонт'),
                    selected: state.conditionFilter == 'needs_repair',
                    onSelected: (_) {
                      ref.read(cagesProvider.notifier).setConditionFilter('needs_repair');
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text('Сломана'),
                    selected: state.conditionFilter == 'broken',
                    onSelected: (_) {
                      ref.read(cagesProvider.notifier).setConditionFilter('broken');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCageForm(BuildContext context, CageModel? cage) {
    context.push('/cages/form', extra: cage);
  }

  void _showCageDetails(BuildContext context, CageModel cage) {
    context.push('/cages/${cage.id}');
  }

  Future<void> _markCleaned(BuildContext context, CageModel cage) async {
    final success = await ref.read(cagesProvider.notifier).markCleaned(cage.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Клетка "${cage.number}" отмечена как убранная'
                : 'Ошибка при отметке уборки',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, CageModel cage) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить клетку?'),
        content: Text(
          'Вы уверены, что хотите удалить клетку "${cage.number}"?\n\n'
          'Это действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await ref.read(cagesProvider.notifier).deleteCage(cage.id);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Клетка "${cage.number}" удалена'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ref.read(cagesProvider).error ?? 'Ошибка удаления клетки',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
