import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/breed_model.dart';
import '../providers/breeds_provider.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/utils/format_utils.dart';
import '../utils/breed_labels.dart';

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
        title: Text(context.l10n.breedsTitle),
      ),
      body: Column(
        children: [
          // Поиск
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.breedsSearchHint,
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
        label: Text(context.l10n.breedsAdd),
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
            ? context.l10n.breedsNothingFound
            : context.l10n.breedsEmptyTitle,
        subtitle: state.searchQuery.isNotEmpty
            ? context.l10n.breedsNothingFoundBody
            : context.l10n.breedsEmptyBody,
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
                          style: AppTypography.titleLg,
                        ),
                        if (breed.purpose != null)
                          Text(
                            breedPurposeLabel(context, breed.purpose),
                            style: AppTypography.bodyMd.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                      PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.edit_outlined),
                          title: Text(context.l10n.cageEdit),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.delete_outline,
                              color: AppColors.error),
                          title: Text(
                            context.l10n.commonDelete,
                            style: AppTypography.bodyLg
                                .copyWith(color: AppColors.error),
                          ),
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
                  style: AppTypography.bodyMd.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                      formatQuantity(breed.averageWeight!, 'кг'),
                      AppColors.accentOcean,
                    ),
                  if (breed.averageLitterSize != null)
                    _buildInfoChip(
                      Icons.family_restroom,
                      '${breed.averageLitterSize} ${context.l10n.breedFormLitterSuffix}',
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
        style: AppTypography.labelSm,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  void _showBreedForm(BuildContext context, BreedModel? breed) {
    context.push('/breeds/form', extra: breed);
  }

  Future<void> _confirmDelete(BuildContext context, BreedModel breed) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.breedsDeleteTitle),
        content: Text(context.l10n.breedsDeleteBody(breed.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.commonDelete),
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
              content: Text(context.l10n.breedsDeleted),
              backgroundColor: AppColors.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ref.read(breedsProvider).error ?? context.l10n.breedsDeleteFailed,
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
