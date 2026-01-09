import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
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
  
  // Local filter states
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
    // Debounce can be added here if needed
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
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          _buildFilters(),
          if (state.isLoading && state.rabbits.isEmpty)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.error != null && state.rabbits.isEmpty)
            SliverFillRemaining(
              child: Center(child: Text('Error: ${state.error}')),
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
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: true,
      backgroundColor: AppTheme.primaryColor,
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
                        color: Colors.black.withOpacity(0.05),
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
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
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

  Widget _buildFilters() {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildFilterChip(
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
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Самцы',
              isSelected: _selectedSex == 'male',
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
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.white,
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
        ),
      ),
    );
  }

  Widget _buildRabbitsList(List<RabbitModel> rabbits) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final rabbit = rabbits[index];
            return _buildRabbitCard(rabbit);
          },
          childCount: rabbits.length,
        ),
      ),
    );
  }

  Widget _buildRabbitCard(RabbitModel rabbit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: () => context.push('/rabbits/${rabbit.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
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
                    color: Colors.grey[200],
                    image: rabbit.photoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(rabbit.photoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: rabbit.photoUrl == null
                      ? Icon(
                          Icons.pets,
                          size: 40,
                          color: Colors.grey[400],
                        )
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
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(rabbit.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getStatusText(rabbit.status),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(rabbit.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Клеймо: ${rabbit.tagId ?? "Нет"}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoBadge(
                          icon: rabbit.sex == 'male' ? Icons.male : Icons.female,
                          label: rabbit.sex == 'male' ? 'Самец' : 'Самка',
                          color: rabbit.sex == 'male' ? Colors.blue : Colors.pink,
                        ),
                        const SizedBox(width: 8),
                        if (rabbit.breed?.name != null)
                          _buildInfoBadge(
                            icon: Icons.category,
                            label: rabbit.breed!.name,
                            color: Colors.purple,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBadge({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'sold':
        return Colors.blue;
      case 'deceased':
        return Colors.red;
      case 'quarantine':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
      case 'healthy':
        return 'Здоров';
      case 'sold':
        return 'Продан';
      case 'deceased':
        return 'Умер';
      case 'quarantine':
        return 'Карантин';
      case 'sick':
        return 'Болен';
      default:
        return status;
    }
  }
}
