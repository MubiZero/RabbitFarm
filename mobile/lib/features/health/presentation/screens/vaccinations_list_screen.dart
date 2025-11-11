import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/vaccination_model.dart';
import '../providers/vaccinations_provider.dart';

/// Экран списка вакцинаций
class VaccinationsListScreen extends ConsumerStatefulWidget {
  const VaccinationsListScreen({super.key});

  @override
  ConsumerState<VaccinationsListScreen> createState() =>
      _VaccinationsListScreenState();
}

class _VaccinationsListScreenState
    extends ConsumerState<VaccinationsListScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем список при открытии экрана
    Future.microtask(() {
      ref.read(vaccinationsProvider.notifier).loadVaccinations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vaccinationsState = ref.watch(vaccinationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Вакцинации'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        actions: [
          // Фильтры
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
          // Статистика
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => _showStatistics(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Быстрые вкладки
          _buildQuickTabs(),

          // Активные фильтры
          if (vaccinationsState.typeFilter != null ||
              vaccinationsState.fromDateFilter != null ||
              vaccinationsState.toDateFilter != null)
            _buildActiveFilters(vaccinationsState),

          // Список вакцинаций
          Expanded(
            child: _buildVaccinationsList(context, vaccinationsState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showVaccinationForm(context, null),
        backgroundColor: Colors.green[700],
        icon: const Icon(Icons.add),
        label: const Text('Добавить вакцинацию'),
      ),
    );
  }

  Widget _buildQuickTabs() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildQuickTabChip('Все', null),
          const SizedBox(width: 8),
          _buildQuickTabChip('Предстоящие', 'upcoming'),
          const SizedBox(width: 8),
          _buildQuickTabChip('Просроченные', 'overdue'),
          const SizedBox(width: 8),
          _buildQuickTabChip('За 30 дней', 'last_30'),
        ],
      ),
    );
  }

  Widget _buildQuickTabChip(String label, String? filter) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        if (filter == null) {
          ref.read(vaccinationsProvider.notifier).clearFilters();
        } else if (filter == 'upcoming') {
          ref
              .read(vaccinationsProvider.notifier)
              .loadVaccinations(upcoming: true);
        } else if (filter == 'overdue') {
          _loadOverdueVaccinations();
        } else if (filter == 'last_30') {
          final now = DateTime.now();
          final thirtyDaysAgo = now.subtract(const Duration(days: 30));
          ref.read(vaccinationsProvider.notifier).setDateFilter(
                thirtyDaysAgo,
                now,
              );
        }
      },
    );
  }

  Widget _buildActiveFilters(VaccinationsState state) {
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (state.typeFilter != null)
            Chip(
              label: Text(state.typeFilter!.displayName),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                ref.read(vaccinationsProvider.notifier).setTypeFilter(null);
              },
            ),
          if (state.fromDateFilter != null)
            Chip(
              label: Text('От: ${dateFormat.format(state.fromDateFilter!)}'),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                ref.read(vaccinationsProvider.notifier).setDateFilter(
                      null,
                      state.toDateFilter,
                    );
              },
            ),
          if (state.toDateFilter != null)
            Chip(
              label: Text('До: ${dateFormat.format(state.toDateFilter!)}'),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                ref.read(vaccinationsProvider.notifier).setDateFilter(
                      state.fromDateFilter,
                      null,
                    );
              },
            ),
          TextButton.icon(
            onPressed: () {
              ref.read(vaccinationsProvider.notifier).clearFilters();
            },
            icon: const Icon(Icons.clear_all, size: 18),
            label: const Text('Сбросить все'),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationsList(
      BuildContext context, VaccinationsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Ошибка: ${state.error}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(vaccinationsProvider.notifier).loadVaccinations();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (state.vaccinations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.vaccines_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Нет записей о вакцинациях',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте первую вакцинацию',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(vaccinationsProvider.notifier).loadVaccinations();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.vaccinations.length,
        itemBuilder: (context, index) {
          final vaccination = state.vaccinations[index];
          return _buildVaccinationCard(context, vaccination);
        },
      ),
    );
  }

  Widget _buildVaccinationCard(BuildContext context, Vaccination vaccination) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final isOverdue = vaccination.nextVaccinationDate != null &&
        vaccination.nextVaccinationDate!.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showVaccinationDetails(context, vaccination),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок: название вакцины + тип
              Row(
                children: [
                  Expanded(
                    child: Text(
                      vaccination.vaccineName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildVaccineTypeChip(vaccination.vaccineType),
                ],
              ),
              const SizedBox(height: 12),

              // Информация о кролике
              if (vaccination.rabbit != null)
                Row(
                  children: [
                    const Icon(Icons.pets, size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        vaccination.rabbit!.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),

              // Дата вакцинации
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Дата: ${dateFormat.format(vaccination.vaccinationDate)}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),

              // Следующая вакцинация
              if (vaccination.nextVaccinationDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.event,
                      size: 18,
                      color: isOverdue ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'След.: ${dateFormat.format(vaccination.nextVaccinationDate!)}',
                        style: TextStyle(
                          color: isOverdue ? Colors.red : Colors.green[700],
                          fontWeight:
                              isOverdue ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isOverdue)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Просрочено',
                          style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (!isOverdue && vaccination.daysUntil != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Через ${vaccination.daysUntil} дн.',
                          style: TextStyle(
                            color: Colors.green[900],
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ],

              // Ветеринар
              if (vaccination.veterinarian != null &&
                  vaccination.veterinarian!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      vaccination.veterinarian!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ],

              // Номер партии
              if (vaccination.batchNumber != null &&
                  vaccination.batchNumber!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.tag, size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Партия: ${vaccination.batchNumber}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],

              // Заметки
              if (vaccination.notes != null &&
                  vaccination.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  vaccination.notes!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVaccineTypeChip(VaccineType type) {
    Color chipColor;
    switch (type) {
      case VaccineType.vhd:
        chipColor = Colors.red[100]!;
        break;
      case VaccineType.myxomatosis:
        chipColor = Colors.blue[100]!;
        break;
      case VaccineType.pasteurellosis:
        chipColor = Colors.orange[100]!;
        break;
      case VaccineType.other:
        chipColor = Colors.grey[300]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        type.displayName,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FiltersSheet(),
    );
  }

  void _showStatistics(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _StatisticsSheet(),
    );
  }

  void _showVaccinationDetails(BuildContext context, Vaccination vaccination) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _VaccinationDetailsSheet(vaccination: vaccination),
    );
  }

  void _showVaccinationForm(BuildContext context, Vaccination? vaccination) {
    // TODO: Навигация к форме добавления/редактирования
    context.push('/vaccinations/form', extra: vaccination);
  }

  void _loadOverdueVaccinations() async {
    // Временная реализация - загружаем через FutureProvider
    ref.invalidate(overdueVaccinationsProvider);
  }
}

/// Виджет панели фильтров
class _FiltersSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<_FiltersSheet> {
  VaccineType? _selectedType;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Фильтры',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Тип вакцины
          const Text('Тип вакцины', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: VaccineType.values.map((type) {
              return ChoiceChip(
                label: Text(type.displayName),
                selected: _selectedType == type,
                onSelected: (selected) {
                  setState(() {
                    _selectedType = selected ? type : null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Период
          const Text('Период', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _fromDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _fromDate = date);
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _fromDate != null
                        ? DateFormat('dd.MM.yyyy').format(_fromDate!)
                        : 'От',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _toDate ?? DateTime.now(),
                      firstDate: _fromDate ?? DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _toDate = date);
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _toDate != null
                        ? DateFormat('dd.MM.yyyy').format(_toDate!)
                        : 'До',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Кнопки
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(vaccinationsProvider.notifier).clearFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Сбросить'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedType != null) {
                      ref
                          .read(vaccinationsProvider.notifier)
                          .setTypeFilter(_selectedType);
                    }
                    if (_fromDate != null || _toDate != null) {
                      ref
                          .read(vaccinationsProvider.notifier)
                          .setDateFilter(_fromDate, _toDate);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Применить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Виджет панели статистики
class _StatisticsSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(vaccinationStatisticsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: statsAsync.when(
        data: (stats) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Статистика вакцинаций',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Общая статистика
            _StatTile(
              icon: Icons.vaccines,
              title: 'Всего вакцинаций',
              value: '${stats.totalVaccinations}',
              color: Colors.blue,
            ),
            _StatTile(
              icon: Icons.calendar_today,
              title: 'За этот год',
              value: '${stats.thisYear}',
              color: Colors.green,
            ),
            _StatTile(
              icon: Icons.history,
              title: 'За последние 30 дней',
              value: '${stats.last30Days}',
              color: Colors.orange,
            ),

            const Divider(height: 32),

            // Предстоящие
            const Text(
              'Предстоящие',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _StatTile(
              icon: Icons.event_available,
              title: 'Следующие 30 дней',
              value: '${stats.upcoming.next30Days}',
              color: Colors.green,
            ),
            _StatTile(
              icon: Icons.warning,
              title: 'Просрочено',
              value: '${stats.upcoming.overdue}',
              color: Colors.red,
            ),
          ],
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(48.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('Ошибка: $error'),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(child: Text(title)),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Виджет детальной информации о вакцинации
class _VaccinationDetailsSheet extends ConsumerWidget {
  final Vaccination vaccination;

  const _VaccinationDetailsSheet({required this.vaccination});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  vaccination.vaccineName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/vaccinations/form', extra: vaccination);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Удалить вакцинацию?'),
                      content: const Text(
                        'Запись о вакцинации будет удалена безвозвратно.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Удалить'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    final success = await ref
                        .read(vaccinationsProvider.notifier)
                        .deleteVaccination(vaccination.id);
                    if (success && context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Вакцинация удалена'),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          _DetailRow(
            icon: Icons.category,
            label: 'Тип',
            value: vaccination.vaccineType.fullName,
          ),
          _DetailRow(
            icon: Icons.calendar_today,
            label: 'Дата вакцинации',
            value: dateFormat.format(vaccination.vaccinationDate),
          ),
          if (vaccination.nextVaccinationDate != null)
            _DetailRow(
              icon: Icons.event,
              label: 'Следующая вакцинация',
              value: dateFormat.format(vaccination.nextVaccinationDate!),
            ),
          if (vaccination.batchNumber != null &&
              vaccination.batchNumber!.isNotEmpty)
            _DetailRow(
              icon: Icons.tag,
              label: 'Номер партии',
              value: vaccination.batchNumber!,
            ),
          if (vaccination.veterinarian != null &&
              vaccination.veterinarian!.isNotEmpty)
            _DetailRow(
              icon: Icons.person,
              label: 'Ветеринар',
              value: vaccination.veterinarian!,
            ),
          if (vaccination.notes != null && vaccination.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Заметки',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(vaccination.notes!),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
