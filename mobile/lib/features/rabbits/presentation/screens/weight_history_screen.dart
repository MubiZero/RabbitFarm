import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/rabbit_model.dart';
import '../../data/models/rabbit_weight_model.dart';
import '../providers/weights_provider.dart';
import '../widgets/weight_chart.dart';

class WeightHistoryScreen extends ConsumerWidget {
  final RabbitModel rabbit;

  const WeightHistoryScreen({super.key, required this.rabbit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightHistory = ref.watch(weightHistoryProvider(rabbit.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('История взвешиваний - ${rabbit.name}'),
      ),
      body: weightHistory.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки данных',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(weightHistoryProvider(rabbit.id)),
                icon: const Icon(Icons.refresh),
                label: const Text('Повторить'),
              ),
            ],
          ),
        ),
        data: (weights) {
          if (weights.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.scale_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет записей о взвешивании',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Добавьте первое взвешивание',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddWeightDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить взвешивание'),
                  ),
                ],
              ),
            );
          }

          // Calculate weight trend
          final trend = _calculateTrend(weights);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(weightHistoryProvider(rabbit.id));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weight chart
                  WeightChart(weights: weights),

                  // Current weight summary
                  _buildWeightSummary(context, weights, trend),

                  // Weight history list
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Последние измерения',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: weights.length,
                    itemBuilder: (context, index) {
                      final weight = weights[index];
                      final prevWeight = index < weights.length - 1
                          ? weights[index + 1]
                          : null;
                      final difference = prevWeight != null
                          ? weight.weight - prevWeight.weight
                          : null;

                      return _buildWeightListTile(context, weight, difference);
                    },
                  ),
                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddWeightDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Добавить взвешивание'),
      ),
    );
  }

  Widget _buildWeightSummary(
    BuildContext context,
    List<RabbitWeight> weights,
    double? trend,
  ) {
    final latest = weights.first;
    final oldest = weights.last;
    final totalChange = latest.weight - oldest.weight;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Сводка',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Текущий вес',
                  '${latest.weight.toStringAsFixed(2)} кг',
                  Icons.scale,
                  Colors.blue,
                ),
                _buildStatItem(
                  context,
                  'Тенденция',
                  trend != null
                      ? '${trend > 0 ? '+' : ''}${trend.toStringAsFixed(2)} кг'
                      : '-',
                  trend != null && trend > 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  trend != null && trend > 0 ? Colors.green : Colors.orange,
                ),
                _buildStatItem(
                  context,
                  'Общее изменение',
                  '${totalChange > 0 ? '+' : ''}${totalChange.toStringAsFixed(2)} кг',
                  totalChange > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  totalChange > 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWeightListTile(
    BuildContext context,
    RabbitWeight weight,
    double? difference,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.scale,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Row(
          children: [
            Text(
              '${weight.weight.toStringAsFixed(2)} кг',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (difference != null) ...[
              const SizedBox(width: 8),
              Row(
                children: [
                  Icon(
                    difference > 0
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 16,
                    color: difference > 0 ? Colors.green : Colors.red,
                  ),
                  Text(
                    '${difference.abs().toStringAsFixed(2)} кг',
                    style: TextStyle(
                      fontSize: 14,
                      color: difference > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMMM yyyy, HH:mm', 'ru_RU')
                  .format(weight.measuredAt),
            ),
            if (weight.notes != null && weight.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                weight.notes!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        isThreeLine: weight.notes != null && weight.notes!.isNotEmpty,
      ),
    );
  }

  double? _calculateTrend(List<RabbitWeight> weights) {
    if (weights.length < 2) return null;
    final latest = weights.first;
    final previous = weights[1];
    return latest.weight - previous.weight;
  }

  void _showAddWeightDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddWeightDialog(
        rabbitId: rabbit.id,
        onSuccess: () {
          ref.invalidate(weightHistoryProvider(rabbit.id));
          if (context.mounted) {
            context.pop();
          }
        },
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
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить взвешивание'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Вес (кг)',
                hintText: '3.5',
                prefixIcon: Icon(Icons.scale),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите вес';
                }
                final weight = double.tryParse(value);
                if (weight == null || weight <= 0) {
                  return 'Введите корректный вес';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Дата взвешивания',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  DateFormat('dd MMMM yyyy, HH:mm', 'ru_RU')
                      .format(_selectedDate),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Заметки (необязательно)',
                hintText: 'Дополнительная информация',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () => _handleSubmit(context),
          child: const Text('Добавить'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('ru', 'RU'),
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final weight = double.parse(_weightController.text);
    final notes = _notesController.text.trim();

    final request = AddWeightRequest(
      weight: weight,
      measuredAt: _selectedDate,
      notes: notes.isEmpty ? null : notes,
    );

    final notifier = ref.read(weightsNotifierProvider.notifier);
    await notifier.addWeightRecord(widget.rabbitId, request);

    final state = ref.read(weightsNotifierProvider);

    if (state.hasError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${state.error}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!state.hasError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Взвешивание добавлено'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onSuccess();
    }
  }
}
