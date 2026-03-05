import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_filter_bar.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/rabbits_provider.dart';

class RabbitsListScreen extends ConsumerStatefulWidget {
  const RabbitsListScreen({super.key});

  @override
  ConsumerState<RabbitsListScreen> createState() => _RabbitsListScreenState();
}

class _RabbitsListScreenState extends ConsumerState<RabbitsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _selectedSex;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(rabbitsListProvider.notifier).loadMore(
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        sex: _selectedSex,
        status: _selectedStatus,
      );
    }
  }

  void _onSearchChanged(String value) {
    ref.read(rabbitsListProvider.notifier).loadRabbits(
      search: value,
      sex: _selectedSex,
      status: _selectedStatus,
    );
  }

  void _applyFilters() {
    ref.read(rabbitsListProvider.notifier).loadRabbits(
      search: _searchController.text.isNotEmpty ? _searchController.text : null,
      sex: _selectedSex,
      status: _selectedStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rabbitsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои Кролики'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _buildSearchField(context),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildFilters(),
          if (state.isLoading && state.rabbits.isEmpty)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.error != null && state.rabbits.isEmpty)
            SliverFillRemaining(
              child: AppErrorState(
                message: state.error!,
                onRetry: () => ref.read(rabbitsListProvider.notifier).loadRabbits(),
              ),
            )
          else if (state.rabbits.isEmpty)
            const SliverFillRemaining(
              child: AppEmptyState(
                icon: Icons.pets,
                title: 'Кролики не найдены',
                subtitle: 'Попробуйте изменить фильтры или добавьте кролика',
              ),
            )
          else
            _buildRabbitsList(state.rabbits),
          if (state.isLoading && state.rabbits.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: AppTypography.bodyMd.copyWith(color: cs.onSurface),
        decoration: InputDecoration(
          hintText: 'Поиск по имени или клейму...',
          hintStyle: AppTypography.bodyMd.copyWith(color: cs.onSurfaceVariant),
          prefixIcon: Icon(Icons.search, color: cs.onSurfaceVariant),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: cs.onSurfaceVariant),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SliverToBoxAdapter(
      child: AppFilterBar(
        chips: [
          AppFilterChipData(
            label: 'Все',
            isSelected: _selectedSex == null && _selectedStatus == null,
            onTap: () {
              setState(() {
                _selectedSex = null;
                _selectedStatus = null;
              });
              _applyFilters();
            },
          ),
          AppFilterChipData(
            label: 'Самцы',
            isSelected: _selectedSex == 'male',
            onTap: () {
              setState(() {
                _selectedSex = _selectedSex == 'male' ? null : 'male';
              });
              _applyFilters();
            },
            color: AppColors.accentOcean,
          ),
          AppFilterChipData(
            label: 'Самки',
            isSelected: _selectedSex == 'female',
            onTap: () {
              setState(() {
                _selectedSex = _selectedSex == 'female' ? null : 'female';
              });
              _applyFilters();
            },
            color: AppColors.accentRose,
          ),
          AppFilterChipData(
            label: 'Активные',
            isSelected: _selectedStatus == 'active',
            onTap: () {
              setState(() {
                _selectedStatus = _selectedStatus == 'active' ? null : 'active';
              });
              _applyFilters();
            },
            color: AppColors.success,
          ),
          AppFilterChipData(
            label: 'Проданы',
            isSelected: _selectedStatus == 'sold',
            onTap: () {
              setState(() {
                _selectedStatus = _selectedStatus == 'sold' ? null : 'sold';
              });
              _applyFilters();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRabbitsList(List<RabbitModel> rabbits) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildRabbitCard(rabbits[index]),
          childCount: rabbits.length,
        ),
      ),
    );
  }

  Widget _buildRabbitCard(RabbitModel rabbit) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: () => context.push('/rabbits/${rabbit.id}'),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Hero(
              tag: 'rabbit_photo_${rabbit.id}',
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: cs.surfaceContainerHighest,
                  image: rabbit.photoUrl != null
                      ? DecorationImage(
                          image: NetworkImage(rabbit.photoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: rabbit.photoUrl == null
                    ? Icon(Icons.pets, size: 40, color: cs.onSurfaceVariant)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          rabbit.name,
                          style: AppTypography.titleMd.copyWith(color: cs.onSurface),
                        ),
                      ),
                      StatusBadge(status: RabbitStatusX.fromString(rabbit.status)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Клеймо: ${rabbit.tagId.isEmpty ? "Нет" : rabbit.tagId}',
                    style: AppTypography.bodyMd.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoBadge(
                        icon: rabbit.sex == 'male' ? Icons.male : rabbit.sex == 'female' ? Icons.female : Icons.question_mark,
                        label: rabbit.sex == 'male' ? 'Самец' : rabbit.sex == 'female' ? 'Самка' : 'Неизвестно',
                        color: rabbit.sex == 'male'
                            ? AppColors.accentOcean
                            : rabbit.sex == 'female' ? AppColors.accentRose : AppColors.info,
                      ),
                      if (rabbit.breed?.name != null) ...[
                        const SizedBox(width: 8),
                        _buildInfoBadge(
                          icon: Icons.category,
                          label: rabbit.breed!.name,
                          color: AppColors.accentViolet,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
