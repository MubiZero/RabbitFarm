import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
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
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(primary),
          _buildFilters(primary),
          if (state.isLoading && state.rabbits.isEmpty)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.error != null && state.rabbits.isEmpty)
            SliverFillRemaining(
              child: Center(child: Text('Ошибка: ${state.error}')),
            )
          else if (state.rabbits.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('Кролики не найдены')),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/rabbits/new'),
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
    );
  }

  Widget _buildSliverAppBar(Color primary) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: true,
      backgroundColor: primary,
      expandedHeight: 120,
      title: const Text('Мои Кролики'),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Поиск по имени или клейму...',
                hintStyle: const TextStyle(color: AppColors.darkTextHint),
                prefixIcon: const Icon(Icons.search, color: AppColors.darkTextHint),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.darkTextHint),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(Color primary) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: [
            _buildFilterChip(
              label: 'Все',
              isSelected: _selectedSex == null && _selectedStatus == null,
              primary: primary,
              onTap: () {
                setState(() {
                  _selectedSex = null;
                  _selectedStatus = null;
                });
                _applyFilters();
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Самцы',
              isSelected: _selectedSex == 'male',
              primary: primary,
              onTap: () {
                setState(() {
                  _selectedSex = _selectedSex == 'male' ? null : 'male';
                });
                _applyFilters();
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Самки',
              isSelected: _selectedSex == 'female',
              primary: primary,
              onTap: () {
                setState(() {
                  _selectedSex = _selectedSex == 'female' ? null : 'female';
                });
                _applyFilters();
              },
            ),
            const VerticalDivider(width: 20, indent: 8, endIndent: 8),
            _buildFilterChip(
              label: 'Активные',
              isSelected: _selectedStatus == 'active',
              primary: primary,
              onTap: () {
                setState(() {
                  _selectedStatus = _selectedStatus == 'active' ? null : 'active';
                });
                _applyFilters();
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Проданы',
              isSelected: _selectedStatus == 'sold',
              primary: primary,
              onTap: () {
                setState(() {
                  _selectedStatus = _selectedStatus == 'sold' ? null : 'sold';
                });
                _applyFilters();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Color primary,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: primary.withValues(alpha: 0.2),
      checkmarkColor: primary,
      labelStyle: TextStyle(
        color: isSelected ? primary : AppColors.darkTextSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? primary : AppColors.darkBorder,
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: () => context.push('/rabbits/${rabbit.id}'),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Photo
            Hero(
              tag: 'rabbit_photo_${rabbit.id}',
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.darkSurfaceVariant,
                  image: rabbit.photoUrl != null
                      ? DecorationImage(
                          image: NetworkImage(rabbit.photoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: rabbit.photoUrl == null
                    ? const Icon(Icons.pets, size: 40, color: AppColors.darkTextHint)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          rabbit.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkTextPrimary,
                          ),
                        ),
                      ),
                      StatusBadge(status: RabbitStatusX.fromString(rabbit.status)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Клеймо: ${rabbit.tagId.isEmpty ? "Нет" : rabbit.tagId}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoBadge(
                        icon: rabbit.sex == 'male' ? Icons.male : Icons.female,
                        label: rabbit.sex == 'male' ? 'Самец' : 'Самка',
                        color: rabbit.sex == 'male'
                            ? AppColors.accentOcean
                            : AppColors.accentRose,
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
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.darkTextHint),
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
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
