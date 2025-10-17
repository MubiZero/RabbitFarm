import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/rabbits_provider.dart';
import '../widgets/rabbit_card.dart';
import '../widgets/statistics_card.dart';

class RabbitsListScreen extends ConsumerStatefulWidget {
  const RabbitsListScreen({super.key});

  @override
  ConsumerState<RabbitsListScreen> createState() => _RabbitsListScreenState();
}

class _RabbitsListScreenState extends ConsumerState<RabbitsListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(rabbitsListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final rabbitsState = ref.watch(rabbitsListProvider);
    final statisticsState = ref.watch(statisticsProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои кролики'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(rabbitsListProvider.notifier).refresh();
              ref.read(statisticsProvider.notifier).refresh();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              } else if (value == 'breeds') {
                context.push('/breeds');
              } else if (value == 'breeding') {
                context.push('/breeding/planner');
              } else if (value == 'births') {
                context.push('/births');
              } else if (value == 'cages') {
                context.push('/cages');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 8),
                    Text(user?.fullName ?? 'Профиль'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'cages',
                child: Row(
                  children: [
                    Icon(Icons.home_work, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Клетки'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'breeds',
                child: Row(
                  children: [
                    Icon(Icons.pets),
                    SizedBox(width: 8),
                    Text('Породы'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'breeding',
                child: Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.purple),
                    SizedBox(width: 8),
                    Text('Планирование случек'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'births',
                child: Row(
                  children: [
                    Icon(Icons.child_care, color: Colors.pink),
                    SizedBox(width: 8),
                    Text('Окролы'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Выйти'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(rabbitsListProvider.notifier).refresh();
          await ref.read(statisticsProvider.notifier).refresh();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Statistics
            if (statisticsState.statistics != null)
              SliverToBoxAdapter(
                child: StatisticsCard(
                  statistics: statisticsState.statistics!,
                ),
              ),

            // Welcome message if no rabbits
            if (!rabbitsState.isLoading && rabbitsState.rabbits.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.pets,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Нет кроликов',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Добавьте первого кролика',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/rabbits/new'),
                        icon: const Icon(Icons.add),
                        label: const Text('Добавить кролика'),
                      ),
                    ],
                  ),
                ),
              ),

            // Rabbits list
            if (rabbitsState.rabbits.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final rabbit = rabbitsState.rabbits[index];
                      return RabbitCard(
                        rabbit: rabbit,
                        onTap: () => context.push('/rabbits/${rabbit.id}'),
                        onDelete: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Удалить кролика?'),
                              content: Text(
                                'Вы уверены, что хотите удалить ${rabbit.name}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Отмена'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Удалить'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            try {
                              await ref
                                  .read(rabbitsListProvider.notifier)
                                  .deleteRabbit(rabbit.id);
                              if (context.mounted) {
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
                          }
                        },
                      );
                    },
                    childCount: rabbitsState.rabbits.length,
                  ),
                ),
              ),

            // Loading more indicator
            if (rabbitsState.isLoading && rabbitsState.rabbits.isNotEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),

            // Initial loading
            if (rabbitsState.isLoading && rabbitsState.rabbits.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            // Error state
            if (rabbitsState.error != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: Colors.red[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.error, color: Colors.red[700], size: 48),
                          const SizedBox(height: 8),
                          Text(
                            'Ошибка',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            rabbitsState.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ref.read(rabbitsListProvider.notifier).refresh();
                            },
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/rabbits/new');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Форма добавления в разработке'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
