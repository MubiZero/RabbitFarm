import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/feeding_record_model.dart';
import '../../data/models/feed_model.dart';
import '../providers/feeding_records_provider.dart';

/// Экран списка записей о кормлении
class FeedingRecordsListScreen extends ConsumerStatefulWidget {
  const FeedingRecordsListScreen({super.key});

  @override
  ConsumerState<FeedingRecordsListScreen> createState() =>
      _FeedingRecordsListScreenState();
}

class _FeedingRecordsListScreenState
    extends ConsumerState<FeedingRecordsListScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    // Загружаем список при открытии экрана
    Future.microtask(() {
      ref.read(feedingRecordsProvider.notifier).loadFeedingRecords(
            refresh: true,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final recordsState = ref.watch(feedingRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('История кормления'),
        centerTitle: true,
        backgroundColor: Colors.orange[700],
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
          // Активные фильтры
          if (_fromDate != null || _toDate != null) _buildActiveFilters(),

          // Список записей
          Expanded(
            child: _buildRecordsList(context, recordsState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFeedingForm(context, null),
        backgroundColor: Colors.orange[700],
        icon: const Icon(Icons.add),
        label: const Text('Добавить кормление'),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Период:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          if (_fromDate != null)
            Chip(
              label: Text('С ${DateFormat('dd.MM.yyyy').format(_fromDate!)}'),
              onDeleted: () {
                setState(() {
                  _fromDate = null;
                });
                _applyFilters();
              },
            ),
          const SizedBox(width: 8),
          if (_toDate != null)
            Chip(
              label: Text('До ${DateFormat('dd.MM.yyyy').format(_toDate!)}'),
              onDeleted: () {
                setState(() {
                  _toDate = null;
                });
                _applyFilters();
              },
            ),
        ],
      ),
    );
  }

  void _applyFilters() {
    ref.read(feedingRecordsProvider.notifier).loadFeedingRecords(
          refresh: true,
          fromDate: _fromDate,
          toDate: _toDate,
        );
  }

  Widget _buildRecordsList(
      BuildContext context, FeedingRecordsState recordsState) {
    if (recordsState.isLoading && recordsState.records.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recordsState.error != null && recordsState.records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Ошибка: ${recordsState.error}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(feedingRecordsProvider.notifier).refresh(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (recordsState.records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_outlined,
                size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Записей не найдено',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте первую запись о кормлении',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(feedingRecordsProvider.notifier).refresh(),
      child: ListView.builder(
        itemCount:
            recordsState.records.length + (recordsState.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == recordsState.records.length) {
            // Загрузка следующей страницы
            if (recordsState.hasMore && !recordsState.isLoading) {
              Future.microtask(
                  () => ref.read(feedingRecordsProvider.notifier).loadMore());
            }
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final record = recordsState.records[index];
          return _buildRecordCard(context, record);
        },
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, FeedingRecord record) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange[700],
          child: const Icon(Icons.restaurant, color: Colors.white),
        ),
        title: Text(
          record.feed?.name ?? 'Корм #${record.feedId}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (record.rabbit != null)
              Row(
                children: [
                  const Icon(Icons.pets, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('Кролик: ${record.rabbit!.name}'),
                ],
              ),
            if (record.cage != null)
              Row(
                children: [
                  const Icon(Icons.home, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('Клетка: ${record.cage!.number}'),
                ],
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.scale, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Количество: ${record.quantity.toStringAsFixed(1)} ${_getFeedUnitName(record.feed?.unit)}',
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(DateFormat('dd.MM.yyyy HH:mm').format(record.fedAt)),
              ],
            ),
            if (record.notes != null && record.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  record.notes!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showRecordOptions(context, record),
        ),
        onTap: () => _showFeedingForm(context, record),
      ),
    );
  }

  void _showFeedingForm(BuildContext context, FeedingRecord? record) {
    context.push('/feeding-records/form', extra: record);
  }

  void _showRecordOptions(BuildContext context, FeedingRecord record) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Редактировать'),
              onTap: () {
                Navigator.pop(context);
                _showFeedingForm(context, record);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Удалить', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, record);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, FeedingRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить запись?'),
        content: const Text('Вы уверены, что хотите удалить эту запись о кормлении?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(deleteFeedingRecordProvider(record.id).future);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Запись успешно удалена')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка при удалении: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showFilters(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Фильтры'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Дата начала'),
              subtitle: Text(
                _fromDate != null
                    ? DateFormat('dd.MM.yyyy').format(_fromDate!)
                    : 'Не выбрана',
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
              title: const Text('Дата окончания'),
              subtitle: Text(
                _toDate != null
                    ? DateFormat('dd.MM.yyyy').format(_toDate!)
                    : 'Не выбрана',
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
              _applyFilters();
            },
            child: const Text('Сбросить'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyFilters();
            },
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }

  void _showStatistics(BuildContext context) {
    context.push('/feeding-records/statistics');
  }

  String _getFeedUnitName(FeedUnit? unit) {
    if (unit == null) return '';
    return unit.displayName;
  }
}
