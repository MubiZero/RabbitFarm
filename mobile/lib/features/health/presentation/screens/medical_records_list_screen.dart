import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/medical_record_model.dart';
import '../providers/medical_records_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';

class MedicalRecordsListScreen extends ConsumerStatefulWidget {
  const MedicalRecordsListScreen({super.key});

  @override
  ConsumerState<MedicalRecordsListScreen> createState() =>
      _MedicalRecordsListScreenState();
}

class _MedicalRecordsListScreenState
    extends ConsumerState<MedicalRecordsListScreen> {
  String? _selectedOutcome;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecords();
    });
  }

  void _loadRecords() {
    ref.read(medicalRecordsProvider.notifier).loadMedicalRecords(
          outcome: _selectedOutcome,
          fromDate: _fromDate,
          toDate: _toDate,
          sortBy: 'started_at',
          sortOrder: 'DESC',
        );
  }

  @override
  Widget build(BuildContext context) {
    final medicalRecordsState = ref.watch(medicalRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Медицинские карты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: _showStatistics,
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick filter tabs
          _buildQuickFilters(),

          // Medical records list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _loadRecords();
              },
              child: medicalRecordsState.when(
                data: (records) {
                  if (records.isEmpty) {
                    return const AppEmptyState(
                      icon: Icons.medical_information_outlined,
                      title: 'Нет медицинских записей',
                      subtitle: 'Добавьте первую медицинскую запись',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      return _buildMedicalRecordCard(records[index]);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => AppErrorState(
                  message: error.toString(),
                  onRetry: _loadRecords,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/medical-records/form');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          _buildQuickFilterChip('Все', null),
          _buildQuickFilterChip('Лечение', 'ongoing'),
          _buildQuickFilterChip('Выздоровел', 'recovered'),
          _buildQuickFilterChip('Умер', 'died'),
          _buildQuickFilterChip('Эвтаназия', 'euthanized'),
        ],
      ),
    );
  }

  Widget _buildQuickFilterChip(String label, String? outcome) {
    final isSelected = _selectedOutcome == outcome;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedOutcome = selected ? outcome : null;
            _loadRecords();
          });
        },
      ),
    );
  }

  Widget _buildMedicalRecordCard(MedicalRecord record) {
    final outcomeColor = _getOutcomeColor(record.outcome);
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          context.push('/medical-records/${record.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: outcomeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: outcomeColor),
                    ),
                    child: Text(
                      record.outcome.displayName,
                      style: TextStyle(
                        color: outcomeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dateFormat.format(record.startedAt),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (record.rabbit != null) ...[
                Text(
                  record.rabbit!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              if (record.diagnosis != null && record.diagnosis!.isNotEmpty)
                Text(
                  'Диагноз: ${record.diagnosis}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                'Симптомы: ${record.symptoms}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (record.treatment != null && record.treatment!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Лечение: ${record.treatment}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (record.cost != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${record.cost!.toStringAsFixed(2)} руб.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              if (record.veterinarian != null &&
                  record.veterinarian!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      record.veterinarian!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getOutcomeColor(MedicalOutcome outcome) {
    switch (outcome) {
      case MedicalOutcome.recovered:
        return AppColors.success;
      case MedicalOutcome.ongoing:
        return AppColors.warning;
      case MedicalOutcome.died:
        return AppColors.error;
      case MedicalOutcome.euthanized:
        return AppColors.accentViolet;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Фильтры'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('С даты'),
              subtitle: Text(
                _fromDate != null
                    ? DateFormat('dd.MM.yyyy').format(_fromDate!)
                    : 'Не выбрано',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _fromDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _fromDate = date;
                  });
                }
              },
            ),
            ListTile(
              title: const Text('По дату'),
              subtitle: Text(
                _toDate != null
                    ? DateFormat('dd.MM.yyyy').format(_toDate!)
                    : 'Не выбрано',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _toDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _toDate = date;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _fromDate = null;
                _toDate = null;
              });
              Navigator.pop(context);
              _loadRecords();
            },
            child: const Text('Сбросить'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _loadRecords();
            },
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }

  void _showStatistics() {
    final statisticsAsync = ref.read(medicalStatisticsProvider);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: statisticsAsync.when(
          data: (stats) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Статистика',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildStatRow('Всего записей', stats.totalRecords.toString()),
              const Divider(),
              _buildStatRow(
                  'Выздоровело', stats.byOutcome.recovered.toString(),
                  color: AppColors.success),
              _buildStatRow('Лечение', stats.byOutcome.ongoing.toString(),
                  color: AppColors.warning),
              _buildStatRow('Умерло', stats.byOutcome.died.toString(),
                  color: AppColors.error),
              _buildStatRow(
                  'Эвтаназия', stats.byOutcome.euthanized.toString(),
                  color: AppColors.accentViolet),
              const Divider(),
              _buildStatRow('Затраты',
                  '${stats.totalCost.toStringAsFixed(2)} руб.',
                  color: AppColors.info),
              _buildStatRow('За этот год', stats.thisYear.toString()),
              _buildStatRow('За последний месяц', stats.lastMonth.toString()),
              if (stats.ongoingTreatments.isNotEmpty) ...[
                const Divider(),
                const Text(
                  'Текущие лечения',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...stats.ongoingTreatments.take(5).map((treatment) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(treatment.rabbitName ?? 'Кролик'),
                    subtitle: Text(treatment.diagnosis ?? 'Без диагноза'),
                    trailing: Text(
                      '${treatment.daysOngoing} дн.',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }),
              ],
            ],
          ),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text('Ошибка: ${error.toString()}'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
