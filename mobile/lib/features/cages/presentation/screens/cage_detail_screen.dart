import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/cage_model.dart';
import '../../data/repositories/cages_repository.dart';
import '../providers/cages_provider.dart';

/// Экран детальной информации о клетке
class CageDetailScreen extends ConsumerWidget {
  final int cageId;

  const CageDetailScreen({
    super.key,
    required this.cageId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали клетки'),
        backgroundColor: Colors.orange[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editCage(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: FutureBuilder<CageModel>(
        future: ref.read(cagesRepositoryProvider).getCageById(cageId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка загрузки клетки',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final cage = snapshot.data!;
          return _buildCageDetails(context, ref, cage);
        },
      ),
    );
  }

  Widget _buildCageDetails(BuildContext context, WidgetRef ref, CageModel cage) {
    final occupancyRate = cage.capacity > 0
        ? (cage.currentOccupancy ?? 0) / cage.capacity
        : 0.0;

    return RefreshIndicator(
      onRefresh: () async {
        // Обновить данные
        await ref.read(cagesRepositoryProvider).getCageById(cageId);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Основная информация
            _buildMainInfoCard(context, cage, occupancyRate),

            const SizedBox(height: 16),

            // Характеристики
            _buildCharacteristicsCard(context, cage),

            const SizedBox(height: 16),

            // Кролики в клетке
            _buildRabbitsCard(context, cage),

            const SizedBox(height: 16),

            // Действия
            _buildActionsCard(context, ref, cage),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoCard(BuildContext context, CageModel cage, double occupancyRate) {
    Color statusColor = Colors.green;
    if (cage.condition == 'broken') {
      statusColor = Colors.red;
    } else if (cage.condition == 'needs_repair') {
      statusColor = Colors.orange;
    } else if (cage.isFull ?? false) {
      statusColor = Colors.blue;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Иконка и номер
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getCageIcon(cage.type),
                    color: statusColor,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Клетка ${cage.number}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getTypeText(cage.type),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Заполненность
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Заполненность',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${cage.currentOccupancy ?? 0}/${cage.capacity}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: occupancyRate,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(occupancyRate * 100).toInt()}% заполнено',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacteristicsCard(BuildContext context, CageModel cage) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Характеристики',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.build,
              'Состояние',
              _getConditionText(cage.condition),
              _getConditionColor(cage.condition),
            ),
            if (cage.size != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.straighten,
                'Размер',
                cage.size!,
                Colors.purple,
              ),
            ],
            if (cage.location != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.location_on,
                'Расположение',
                cage.location!,
                Colors.blue,
              ),
            ],
            if (cage.lastCleanedAt != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.cleaning_services,
                'Последняя уборка',
                DateFormat('dd MMMM yyyy, HH:mm', 'ru').format(cage.lastCleanedAt!),
                Colors.teal,
              ),
            ],
            if (cage.notes != null && cage.notes!.isNotEmpty) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.notes,
                'Заметки',
                cage.notes!,
                Colors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRabbitsCard(BuildContext context, CageModel cage) {
    final rabbits = cage.rabbits ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Кролики в клетке',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${rabbits.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (rabbits.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.pets, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        'Клетка пуста',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rabbits.length,
                separatorBuilder: (context, index) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final rabbit = rabbits[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: rabbit.sex == 'male'
                          ? Colors.blue[100]
                          : Colors.pink[100],
                      child: Icon(
                        rabbit.sex == 'male' ? Icons.male : Icons.female,
                        color: rabbit.sex == 'male' ? Colors.blue : Colors.pink,
                      ),
                    ),
                    title: Text(
                      rabbit.name ?? 'Кролик #${rabbit.tagId ?? rabbit.id}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'ID: ${rabbit.tagId ?? rabbit.id} • Статус: ${_getStatusText(rabbit.status)}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.push('/rabbits/${rabbit.id}');
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context, WidgetRef ref, CageModel cage) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Действия',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _markCleaned(context, ref, cage),
              icon: const Icon(Icons.cleaning_services),
              label: const Text('Отметить уборку'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _editCage(context, ref),
              icon: const Icon(Icons.edit),
              label: const Text('Редактировать'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
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
        return 'Одиночная клетка';
      case 'group':
        return 'Групповая клетка';
      case 'maternity':
        return 'Клетка для окрола';
      default:
        return type;
    }
  }

  String _getConditionText(String condition) {
    switch (condition) {
      case 'good':
        return 'Хорошее состояние';
      case 'needs_repair':
        return 'Требуется ремонт';
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

  String _getStatusText(String status) {
    switch (status) {
      case 'healthy':
        return 'Здоров';
      case 'sick':
        return 'Болен';
      case 'pregnant':
        return 'Беременна';
      case 'quarantine':
        return 'Карантин';
      case 'sold':
        return 'Продан';
      case 'dead':
        return 'Мертв';
      default:
        return status;
    }
  }

  Future<void> _editCage(BuildContext context, WidgetRef ref) async {
    final cage = await ref.read(cagesRepositoryProvider).getCageById(cageId);
    if (context.mounted) {
      context.push('/cages/form', extra: cage);
    }
  }

  Future<void> _markCleaned(BuildContext context, WidgetRef ref, CageModel cage) async {
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

      if (success) {
        // Обновить экран
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CageDetailScreen(cageId: cageId),
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final cage = await ref.read(cagesRepositoryProvider).getCageById(cageId);

    if (!context.mounted) return;

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
          context.pop(); // Вернуться к списку
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
