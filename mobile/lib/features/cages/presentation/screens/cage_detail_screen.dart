import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/cage_model.dart';
import '../../data/models/cage_statistics.dart';
import '../providers/cages_provider.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/providers/rabbits_provider.dart';

class CageDetailScreen extends ConsumerStatefulWidget {
  final int cageId;

  const CageDetailScreen({
    super.key,
    required this.cageId,
  });

  @override
  ConsumerState<CageDetailScreen> createState() => _CageDetailScreenState();
}

class _CageDetailScreenState extends ConsumerState<CageDetailScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Refresh cage data on enter
     Future.microtask(() => 
       ref.read(cagesProvider.notifier).loadCages()
    );
  }

  Future<void> _removeRabbit(RabbitModel rabbit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Убрать из клетки?'),
        content: Text('Кролик "${rabbit.name}" будет перемещен в список без клетки.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Убрать'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await ref.read(rabbitsRepositoryProvider).updateRabbit(
          rabbit.id,
          {'cage_id': null},
        );
        ref.refresh(cagesProvider); // Refresh cages to update occupancy
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Кролик убран из клетки')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _moveRabbit(RabbitModel rabbit) async {
    // Show dialog to select target cage
    // For simplicity, we'll fetch all cages and show them
    // Ideally this should be a paginated search dialog
    final cages = ref.read(cagesProvider).cages
        .where((c) => c.id != widget.cageId && (c.isAvailable ?? false)) // Filter current and full cages
        .toList();

    if (cages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет доступных клеток для перемещения')),
      );
      return;
    }

    final targetCage = await showDialog<CageModel>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Переместить в...'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cages.length,
            itemBuilder: (context, index) {
              final cage = cages[index];
              return ListTile(
                title: Text('Клетка ${cage.number}'),
                subtitle: Text('${cage.type} • ${cage.location ?? ""}'),
                onTap: () => Navigator.pop(context, cage),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );

    if (targetCage != null) {
      setState(() => _isLoading = true);
      try {
         await ref.read(rabbitsRepositoryProvider).updateRabbit(
          rabbit.id,
          {'cage_id': targetCage.id},
        );
        ref.refresh(cagesProvider);
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Кролик перемещен в клетку ${targetCage.number}')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

 Future<void> _addRabbit(int cageId) async {
    // Navigate to a rabbit selection screen or show a dialog.
    // We'll show a simple dialog with recently added rabbits or a search field.
    // For MVP/clean implementation, let's fetch rabbits without cage (if possible) or just all rabbits.
    // Since backend doesn't support 'no_cage' filter explicitly yet, we fetch recent rabbits and filter client side 
    // or just show search.
    
    // We will use a search dialog
    await showDialog(
      context: context, 
      builder: (context) => _AddRabbitDialog(
        onSelect: (rabbit) async {
          Navigator.pop(context);
          setState(() => _isLoading = true);
          try {
             await ref.read(rabbitsRepositoryProvider).updateRabbit(
              rabbit.id,
              {'cage_id': cageId},
            );
            ref.refresh(cagesProvider);
             if (mounted) {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Кролик добавлен в клетку')),
              );
            }
          } catch (e) {
             if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
              );
            }
          } finally {
            if (mounted) setState(() => _isLoading = false);
          }
        }
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    // Find the cage in the provider list
    final cagesState = ref.watch(cagesProvider);
    final cage = cagesState.cages.firstWhere(
      (c) => c.id == widget.cageId,
      orElse: () => CageModel(id: widget.cageId, number: '...', type: 'single', capacity: 0, condition: 'good'),
    );

    // If loading specifically for this screen or global loading
    // But since we are selecting from list, we might have data.
    // The cage object inside 'cages' might have 'rabbits' populated if getCages included them.
    // Controller.list includes rabbits.

    return Scaffold(
      appBar: AppBar(
        title: Text('Клетка ${cage.number}'),
        backgroundColor: Colors.orange[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/cages/form', extra: cage),
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCageInfo(cage),
                  const SizedBox(height: 24),
                  _buildRabbitsSection(cage),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (cage.isFull ?? false) ? null : () => _addRabbit(cage.id),
        backgroundColor: (cage.isFull ?? false) ? Colors.grey : Colors.orange[700],
        icon: const Icon(Icons.add),
        label: const Text('Посадить кролика'),
      ),
    );
  }

  Widget _buildCageInfo(CageModel cage) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Тип: ${_getTypeText(cage.type)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Состояние: ${_getConditionText(cage.condition)}',
                      style: TextStyle(
                        color: _getConditionColor(cage.condition),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _buildOccupancyCircle(cage),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Text(
                  cage.location ?? 'Нет локации',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOccupancyCircle(CageModel cage) {
    final occupancy = cage.rabbits?.length ?? 0;
    final percent = cage.capacity > 0 ? occupancy / cage.capacity : 0.0;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: percent,
          backgroundColor: Colors.grey[200],
          color: percent >= 1 ? Colors.red : Colors.green,
          strokeWidth: 8,
        ),
        Text(
          '$occupancy/${cage.capacity}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRabbitsSection(CageModel cage) {
    final rabbits = cage.rabbits ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Жители',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (rabbits.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('В этой клетке пока никого нет', style: TextStyle(color: Colors.grey)),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rabbits.length,
            itemBuilder: (context, index) {
              final rabbit = rabbits[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: rabbit.photoUrl != null ? NetworkImage(rabbit.photoUrl!) : null,
                    child: rabbit.photoUrl == null ? const Icon(Icons.pets, size: 20) : null,
                  ),
                  title: Text(rabbit.name),
                  subtitle: Text(rabbit.tagId ?? ''),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'move') _moveRabbit(rabbit);
                      if (value == 'remove') _removeRabbit(rabbit);
                      if (value == 'profile') context.push('/rabbits/${rabbit.id}');
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'profile',
                        child: Row(children: [Icon(Icons.visibility), SizedBox(width: 8), Text('Профиль')]),
                      ),
                      const PopupMenuItem(
                        value: 'move',
                        child: Row(children: [Icon(Icons.low_priority), SizedBox(width: 8), Text('Переместить')]),
                      ),
                      const PopupMenuItem(
                         value: 'remove',
                         child: Row(children: [Icon(Icons.output, color: Colors.red), SizedBox(width: 8), Text('Убрать', style: TextStyle(color: Colors.red))]),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
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
}

class _AddRabbitDialog extends ConsumerStatefulWidget {
  final Function(RabbitModel) onSelect;

  const _AddRabbitDialog({required this.onSelect});

  @override
  ConsumerState<_AddRabbitDialog> createState() => _AddRabbitDialogState();
}

class _AddRabbitDialogState extends ConsumerState<_AddRabbitDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<RabbitModel> _allRabbits = [];
  List<RabbitModel> _filteredRabbits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRabbits();
  }

  Future<void> _loadRabbits() async {
    // Ideally we fetch rabbits that are NOT in a cage.
    // For now, load all
    try {
      final repo = ref.read(rabbitsRepositoryProvider);
      final result = await repo.getRabbits(limit: 100); // Increased limit for ease
      if (mounted) {
        setState(() {
          _allRabbits = result.items;
          _filteredRabbits = result.items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filter(String query) {
    setState(() {
      _filteredRabbits = _allRabbits.where((r) => 
        r.name.toLowerCase().contains(query.toLowerCase()) || 
        (r.tagId?.toLowerCase().contains(query.toLowerCase()) ?? false)
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выберите кролика'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Поиск...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filter,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredRabbits.length,
                    itemBuilder: (context, index) {
                      final rabbit = _filteredRabbits[index];
                      // Optional: visually distinguish rabbits already in a cage
                      final isInCage = rabbit.cageId != null;
                      
                      return ListTile(
                        enabled: !isInCage, // Disable selection if already in cage? Users might want to move directly.
                        // Let's allow moving directly from this dialog too
                        leading: const Icon(Icons.pets),
                        title: Text(rabbit.name),
                        subtitle: Text(isInCage ? 'В клетке #${rabbit.cageId}' : 'Без клетки'),
                        onTap: () => widget.onSelect(rabbit),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}
