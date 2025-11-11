import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/feed_model.dart';
import '../providers/feeds_provider.dart';

/// Экран списка кормов (склад)
class FeedsListScreen extends ConsumerStatefulWidget {
  const FeedsListScreen({super.key});

  @override
  ConsumerState<FeedsListScreen> createState() => _FeedsListScreenState();
}

class _FeedsListScreenState extends ConsumerState<FeedsListScreen> {
  FeedType? _selectedType;
  bool _showLowStockOnly = false;

  @override
  void initState() {
    super.initState();
    // Загружаем список при открытии экрана
    Future.microtask(() {
      ref.read(feedsProvider.notifier).loadFeeds(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedsState = ref.watch(feedsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Склад кормов'),
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
          // Быстрые фильтры
          _buildQuickFilters(),

          // Активные фильтры
          if (_selectedType != null || _showLowStockOnly)
            _buildActiveFilters(),

          // Список кормов
          Expanded(
            child: _buildFeedsList(context, feedsState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFeedForm(context, null),
        backgroundColor: Colors.orange[700],
        icon: const Icon(Icons.add),
        label: const Text('Добавить корм'),
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Все', _selectedType == null && !_showLowStockOnly, () {
            setState(() {
              _selectedType = null;
              _showLowStockOnly = false;
            });
            _applyFilters();
          }),
          const SizedBox(width: 8),
          _buildFilterChip('Мало на складе', _showLowStockOnly, () {
            setState(() {
              _showLowStockOnly = !_showLowStockOnly;
            });
            _applyFilters();
          }),
          const SizedBox(width: 8),
          _buildFilterChip('Гранулы', _selectedType == FeedType.pellets, () {
            _toggleTypeFilter(FeedType.pellets);
          }),
          const SizedBox(width: 8),
          _buildFilterChip('Сено', _selectedType == FeedType.hay, () {
            _toggleTypeFilter(FeedType.hay);
          }),
          const SizedBox(width: 8),
          _buildFilterChip('Овощи', _selectedType == FeedType.vegetables, () {
            _toggleTypeFilter(FeedType.vegetables);
          }),
          const SizedBox(width: 8),
          _buildFilterChip('Зерно', _selectedType == FeedType.grain, () {
            _toggleTypeFilter(FeedType.grain);
          }),
          const SizedBox(width: 8),
          _buildFilterChip('Добавки', _selectedType == FeedType.supplements, () {
            _toggleTypeFilter(FeedType.supplements);
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.orange[200],
    );
  }

  void _toggleTypeFilter(FeedType type) {
    setState(() {
      _selectedType = _selectedType == type ? null : type;
    });
    _applyFilters();
  }

  void _applyFilters() {
    ref.read(feedsProvider.notifier).loadFeeds(
          refresh: true,
          type: _selectedType,
          lowStockOnly: _showLowStockOnly,
        );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Фильтры:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          if (_showLowStockOnly)
            Chip(
              label: const Text('Мало на складе'),
              onDeleted: () {
                setState(() {
                  _showLowStockOnly = false;
                });
                _applyFilters();
              },
            ),
          if (_selectedType != null)
            Chip(
              label: Text(_getFeedTypeName(_selectedType!)),
              onDeleted: () {
                setState(() {
                  _selectedType = null;
                });
                _applyFilters();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFeedsList(BuildContext context, FeedsState feedsState) {
    if (feedsState.isLoading && feedsState.feeds.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (feedsState.error != null && feedsState.feeds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Ошибка: ${feedsState.error}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(feedsProvider.notifier).refresh(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (feedsState.feeds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Корма не найдены',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте первый корм',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(feedsProvider.notifier).refresh(),
      child: ListView.builder(
        itemCount: feedsState.feeds.length + (feedsState.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == feedsState.feeds.length) {
            // Загрузка следующей страницы
            if (feedsState.hasMore && !feedsState.isLoading) {
              Future.microtask(
                  () => ref.read(feedsProvider.notifier).loadMore());
            }
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final feed = feedsState.feeds[index];
          return _buildFeedCard(context, feed);
        },
      ),
    );
  }

  Widget _buildFeedCard(BuildContext context, Feed feed) {
    final hasLowStock = ref.watch(feedHasLowStockProvider(feed));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getFeedTypeColor(feed.type),
          child: Icon(_getFeedTypeIcon(feed.type), color: Colors.white),
        ),
        title: Text(
          feed.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getFeedTypeName(feed.type)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  hasLowStock ? Icons.warning : Icons.inventory,
                  size: 16,
                  color: hasLowStock ? Colors.red : Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  'На складе: ${feed.currentStock.toStringAsFixed(1)} ${_getFeedUnitName(feed.unit)}',
                  style: TextStyle(
                    color: hasLowStock ? Colors.red : Colors.black87,
                    fontWeight: hasLowStock ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            if (hasLowStock)
              Text(
                'Минимум: ${feed.minStock.toStringAsFixed(1)} ${_getFeedUnitName(feed.unit)}',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
              onPressed: () => _showStockAdjustment(context, feed, true),
              tooltip: 'Пополнить склад',
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => _showStockAdjustment(context, feed, false),
              tooltip: 'Списать со склада',
            ),
          ],
        ),
        onTap: () => _showFeedForm(context, feed),
      ),
    );
  }

  void _showFeedForm(BuildContext context, Feed? feed) {
    context.push('/feeds/form', extra: feed);
  }

  void _showStockAdjustment(BuildContext context, Feed feed, bool isAddition) {
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAddition ? 'Пополнить склад' : 'Списать со склада'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feed.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Текущий остаток: ${feed.currentStock.toStringAsFixed(1)} ${_getFeedUnitName(feed.unit)}',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Количество',
                suffixText: _getFeedUnitName(feed.unit),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = double.tryParse(quantityController.text);
              if (quantity != null && quantity > 0) {
                _adjustStock(context, feed.id, quantity, isAddition);
                Navigator.pop(context);
              }
            },
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }

  void _adjustStock(
      BuildContext context, int feedId, double quantity, bool isAddition) {
    final adjustment = StockAdjustment(
      quantity: quantity,
      operation: isAddition ? StockOperation.add : StockOperation.subtract,
    );

    ref.read(adjustFeedStockProvider((id: feedId, adjustment: adjustment)));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAddition
              ? 'Склад пополнен на ${quantity.toStringAsFixed(1)}'
              : 'Списано со склада ${quantity.toStringAsFixed(1)}',
        ),
      ),
    );
  }

  void _showFilters(BuildContext context) {
    // TODO: Implement advanced filters dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Дополнительные фильтры')),
    );
  }

  void _showStatistics(BuildContext context) {
    context.push('/feeds/statistics');
  }

  String _getFeedTypeName(FeedType type) {
    switch (type) {
      case FeedType.pellets:
        return 'Гранулы';
      case FeedType.hay:
        return 'Сено';
      case FeedType.vegetables:
        return 'Овощи';
      case FeedType.grain:
        return 'Зерно';
      case FeedType.supplements:
        return 'Добавки';
      case FeedType.other:
        return 'Другое';
    }
  }

  String _getFeedUnitName(FeedUnit unit) {
    switch (unit) {
      case FeedUnit.kg:
        return 'кг';
      case FeedUnit.liter:
        return 'л';
      case FeedUnit.piece:
        return 'шт';
    }
  }

  Color _getFeedTypeColor(FeedType type) {
    switch (type) {
      case FeedType.pellets:
        return Colors.brown;
      case FeedType.hay:
        return Colors.amber;
      case FeedType.vegetables:
        return Colors.green;
      case FeedType.grain:
        return Colors.orange;
      case FeedType.supplements:
        return Colors.purple;
      case FeedType.other:
        return Colors.grey;
    }
  }

  IconData _getFeedTypeIcon(FeedType type) {
    switch (type) {
      case FeedType.pellets:
        return Icons.grain;
      case FeedType.hay:
        return Icons.grass;
      case FeedType.vegetables:
        return Icons.eco;
      case FeedType.grain:
        return Icons.agriculture;
      case FeedType.supplements:
        return Icons.medication;
      case FeedType.other:
        return Icons.inventory_2;
    }
  }
}
