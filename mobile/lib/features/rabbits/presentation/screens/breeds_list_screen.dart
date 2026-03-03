import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/breed_model.dart';
import '../providers/breeds_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';

/// Экран списка пород кроликов
class BreedsListScreen extends ConsumerStatefulWidget {
  const BreedsListScreen({super.key});

  @override
  ConsumerState<BreedsListScreen> createState() => _BreedsListScreenState();
}

class _BreedsListScreenState extends ConsumerState<BreedsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breedsState = ref.watch(breedsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Породы'),
      ),
      body: Column(
        children: [
          // Поиск
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск пород...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(breedsProvider.notifier).updateSearchQuery('');
                        },
                      )
                    : null,
                filled: true,
              ),
              onChanged: (value) {
                ref.read(breedsProvider.notifier).updateSearchQuery(value);
              },
            ),
          ),

          // Список пород
          Expanded(
            child: _buildBreedsList(context, breedsState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBreedForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Добавить породу'),
      ),
    );
  }

  Widget _buildBreedsList(BuildContext context, BreedsState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
      return AppErrorState(
        message: state.error!,
        onRetry: () => ref.read(breedsProvider.notifier).loadBreeds(),
      );
    }

    final breeds = state.filteredBreeds;

    if (breeds.isEmpty) {
      return AppEmptyState(
        icon: state.searchQuery.isNotEmpty ? Icons.search_off : Icons.pets,
        title: state.searchQuery.isNotEmpty
            ? 'Породы не найдены'
            : 'Нет пород',
        subtitle: state.searchQuery.isNotEmpty
            ? 'Попробуйте изменить запрос'
            : 'Добавьте первую породу',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(breedsProvider.notifier).loadBreeds(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: breeds.length,
        itemBuilder: (context, index) {
          final breed = breeds[index];
          return _buildBreedCard(context, breed);
        },
      ),
    );
  }

  Widget _buildBreedCard(BuildContext context, BreedModel breed) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showBreedForm(context, breed),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Название и количество кроликов
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.pets,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          breed.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (breed.purpose != null)
                          Text(
                            _getPurposeText(breed.purpose!),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Действия
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showBreedForm(context, breed);
                      } else if (value == 'delete') {
                        _confirmDelete(context, breed);
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
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: AppColors.error),
                            SizedBox(width: 8),
                            Text('Удалить', style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Описание
              if (breed.description != null && breed.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  breed.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Характеристики
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (breed.averageWeight != null)
                    _buildInfoChip(
                      Icons.monitor_weight,
                      '${breed.averageWeight} кг',
                      AppColors.accentOcean,
                    ),
                  if (breed.averageLitterSize != null)
                    _buildInfoChip(
                      Icons.family_restroom,
                      '${breed.averageLitterSize} крольчат',
                      AppColors.accentEmerald,
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

  String _getPurposeText(String purpose) {
    switch (purpose) {
      case 'meat':
        return 'Мясная';
      case 'fur':
        return 'Пуховая';
      case 'decorative':
        return 'Декоративная';
      case 'combined':
        return 'Мясо-шкурковая';
      default:
        return purpose;
    }
  }

  void _showBreedForm(BuildContext context, BreedModel? breed) {
    context.push('/breeds/form', extra: breed);
  }

  Future<void> _confirmDelete(BuildContext context, BreedModel breed) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить породу?'),
        content: Text(
          'Вы уверены, что хотите удалить породу "${breed.name}"?\n\n'
          'Это действие нельзя отменить.',
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

    if (confirmed == true && context.mounted) {
      final success = await ref.read(breedsProvider.notifier).deleteBreed(breed.id);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Порода "${breed.name}" удалена'),
              backgroundColor: AppColors.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ref.read(breedsProvider).error ?? 'Ошибка удаления породы',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
