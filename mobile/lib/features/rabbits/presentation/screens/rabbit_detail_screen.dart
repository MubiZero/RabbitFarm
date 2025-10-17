import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/rabbits_provider.dart';
import '../../../../core/utils/image_url_helper.dart';
import 'weight_history_screen.dart';

class RabbitDetailScreen extends ConsumerWidget {
  final int rabbitId;

  const RabbitDetailScreen({
    super.key,
    required this.rabbitId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbitAsync = ref.watch(rabbitDetailProvider(rabbitId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали'),
        actions: [
          rabbitAsync.whenOrNull(
            data: (rabbit) => PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  context.push('/rabbits/${rabbit.id}/edit', extra: rabbit);
                } else if (value == 'delete') {
                  _showDeleteDialog(context, ref, rabbit);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Редактировать'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Удалить', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ) ??
              const SizedBox(),
        ],
      ),
      body: rabbitAsync.when(
        data: (rabbit) => _buildContent(context, rabbit),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ошибка: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(rabbitDetailProvider(rabbitId)),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, RabbitModel rabbit) {
    final age = _calculateAge(rabbit.birthDate);
    final photoUrl = ImageUrlHelper.getFullImageUrl(rabbit.photoUrl);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo Section
          if (photoUrl != null)
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showPhotoDialog(context, photoUrl),
                    child: Hero(
                      tag: 'rabbit-photo-${rabbit.id}',
                      child: CachedNetworkImage(
                        imageUrl: photoUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 250,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 250,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.broken_image,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.touch_app, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Нажмите для увеличения',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // Header card with name and tag
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _getSexColor(rabbit.sex).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: photoUrl != null
                          ? CachedNetworkImage(
                              imageUrl: photoUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _getSexColor(rabbit.sex),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                _getSexIcon(rabbit.sex),
                                size: 40,
                                color: _getSexColor(rabbit.sex),
                              ),
                            )
                          : Icon(
                              _getSexIcon(rabbit.sex),
                              size: 40,
                              color: _getSexColor(rabbit.sex),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rabbit.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Бирка: ${rabbit.tagId}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
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

          // Basic info
          _buildSection(
            context,
            title: 'Основная информация',
            children: [
              _buildInfoRow(context, 'Порода', rabbit.breed?.name ?? 'Не указана'),
              _buildInfoRow(context, 'Пол', rabbit.sex == 'male' ? 'Самец' : 'Самка'),
              _buildInfoRow(context, 'Возраст', age),
              _buildInfoRow(
                context,
                'Дата рождения',
                DateFormat('dd.MM.yyyy').format(rabbit.birthDate),
              ),
              if (rabbit.color != null)
                _buildInfoRow(context, 'Окрас', rabbit.color!),
              if (rabbit.currentWeight != null)
                _buildInfoRow(
                  context,
                  'Текущий вес',
                  '${rabbit.currentWeight!.toStringAsFixed(2)} кг',
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Быстрые действия',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeightHistoryScreen(rabbit: rabbit),
                          ),
                        );
                      },
                      icon: const Icon(Icons.scale),
                      label: const Text('История взвешиваний'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push(
                          '/rabbits/${rabbit.id}/pedigree?name=${Uri.encodeComponent(rabbit.name)}',
                        );
                      },
                      icon: const Icon(Icons.account_tree),
                      label: const Text('Родословная'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Status
          _buildSection(
            context,
            title: 'Статус',
            children: [
              _buildInfoRow(context, 'Состояние', _getStatusText(rabbit.status)),
              _buildInfoRow(context, 'Назначение', _getPurposeText(rabbit.purpose)),
            ],
          ),
          const SizedBox(height: 16),

          // Location
          if (rabbit.cage != null)
            _buildSection(
              context,
              title: 'Размещение',
              children: [
                _buildInfoRow(context, 'Клетка', rabbit.cage!.number),
                if (rabbit.cage!.location != null)
                  _buildInfoRow(context, 'Расположение', rabbit.cage!.location!),
              ],
            ),
          const SizedBox(height: 16),

          // Parents
          if (rabbit.father != null || rabbit.mother != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Родители',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    if (rabbit.father != null)
                      _buildParentCard(
                        context,
                        rabbit.father!,
                        'Отец',
                        Icons.male,
                        Colors.blue,
                      ),
                    if (rabbit.father != null && rabbit.mother != null)
                      const SizedBox(height: 8),
                    if (rabbit.mother != null)
                      _buildParentCard(
                        context,
                        rabbit.mother!,
                        'Мать',
                        Icons.female,
                        Colors.pink,
                      ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Notes
          if (rabbit.notes != null && rabbit.notes!.isNotEmpty)
            _buildSection(
              context,
              title: 'Заметки',
              children: [
                Text(
                  rabbit.notes!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          const SizedBox(height: 16),

          // Dates
          _buildSection(
            context,
            title: 'Даты',
            children: [
              _buildInfoRow(
                context,
                'Создано',
                DateFormat('dd.MM.yyyy HH:mm').format(rabbit.createdAt),
              ),
              _buildInfoRow(
                context,
                'Обновлено',
                DateFormat('dd.MM.yyyy HH:mm').format(rabbit.updatedAt),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentCard(
    BuildContext context,
    ParentInfo parent,
    String label,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        context.push('/rabbits/${parent.id}');
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    parent.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Бирка: ${parent.tagId}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    final months = (difference.inDays / 30).floor();
    final years = (months / 12).floor();

    if (years > 0) {
      final remainingMonths = months % 12;
      if (remainingMonths > 0) {
        return '$years г $remainingMonths мес';
      }
      return '$years ${_pluralYears(years)}';
    }
    return '$months ${_pluralMonths(months)}';
  }

  String _pluralYears(int years) {
    if (years % 10 == 1 && years % 100 != 11) return 'год';
    if ([2, 3, 4].contains(years % 10) &&
        ![12, 13, 14].contains(years % 100)) return 'года';
    return 'лет';
  }

  String _pluralMonths(int months) {
    if (months % 10 == 1 && months % 100 != 11) return 'месяц';
    if ([2, 3, 4].contains(months % 10) &&
        ![12, 13, 14].contains(months % 100)) return 'месяца';
    return 'месяцев';
  }

  IconData _getSexIcon(String sex) {
    return sex == 'male' ? Icons.male : Icons.female;
  }

  Color _getSexColor(String sex) {
    return sex == 'male' ? Colors.blue : Colors.pink;
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Активен';
      case 'pregnant':
        return 'Беременна';
      case 'sick':
        return 'Болен';
      case 'sold':
        return 'Продан';
      case 'dead':
        return 'Умер';
      default:
        return status;
    }
  }

  String _getPurposeText(String purpose) {
    switch (purpose) {
      case 'breeding':
        return 'Разведение';
      case 'meat':
        return 'Мясо';
      case 'fur':
        return 'Мех';
      case 'sale':
        return 'Продажа';
      case 'pet':
        return 'Питомец';
      default:
        return purpose;
    }
  }

  void _showPhotoDialog(BuildContext context, String photoUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4,
                child: CachedNetworkImage(
                  imageUrl: photoUrl,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, RabbitModel rabbit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить кролика?'),
        content: Text('Вы уверены, что хотите удалить ${rabbit.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(rabbitsRepositoryProvider).deleteRabbit(rabbit.id);
                ref.read(rabbitsListProvider.notifier).refresh();
                if (context.mounted) {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Кролик удален'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Exception: ', '')),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
