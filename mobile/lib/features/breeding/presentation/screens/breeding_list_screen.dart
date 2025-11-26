import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/breeding_provider.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../../rabbits/data/models/breeding_model.dart';

class BreedingListScreen extends ConsumerStatefulWidget {
  const BreedingListScreen({super.key});

  @override
  ConsumerState<BreedingListScreen> createState() => _BreedingListScreenState();
}

class _BreedingListScreenState extends ConsumerState<BreedingListScreen> {
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
      ref.read(breedingListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final breedingState = ref.watch(breedingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Случки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(breedingListProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(breedingListProvider.notifier).refresh();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            if (breedingState.error != null)
              SliverToBoxAdapter(
                child: ErrorView(
                  message: breedingState.error!,
                  onRetry: () => ref.read(breedingListProvider.notifier).refresh(),
                ),
              ),

            if (!breedingState.isLoading && breedingState.breedings.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Нет записей о случках',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/breeding/new'),
                        icon: const Icon(Icons.add),
                        label: const Text('Добавить случку'),
                      ),
                    ],
                  ),
                ),
              ),

            if (breedingState.breedings.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final breeding = breedingState.breedings[index];
                      return _BreedingCard(
                        breeding: breeding,
                        onTap: () => context.push('/breeding/${breeding.id}'),
                      );
                    },
                    childCount: breedingState.breedings.length,
                  ),
                ),
              ),

            if (breedingState.isLoading && breedingState.breedings.isNotEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/breeding/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BreedingCard extends StatelessWidget {
  final BreedingModel breeding;
  final VoidCallback onTap;

  const _BreedingCard({
    required this.breeding,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (breeding.status) {
      case 'planned':
        statusColor = Colors.blue;
        statusText = 'Запланировано';
        break;
      case 'completed':
        statusColor = Colors.green;
        statusText = 'Завершено';
        break;
      case 'failed':
        statusColor = Colors.red;
        statusText = 'Неудача';
        break;
      case 'cancelled':
        statusColor = Colors.grey;
        statusText = 'Отменено';
        break;
      default:
        statusColor = Colors.grey;
        statusText = breeding.status;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    _formatDate(breeding.breedingDate),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.male, size: 16, color: Colors.blue),
                            SizedBox(width: 4),
                            Text('Самец', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          breeding.male?.name ?? 'ID: ${breeding.maleId}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.favorite, color: Colors.pinkAccent, size: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Самка', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            SizedBox(width: 4),
                            Icon(Icons.female, size: 16, color: Colors.pink),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          breeding.female?.name ?? 'ID: ${breeding.femaleId}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (breeding.expectedBirthDate != null) ...[
                const Divider(height: 24),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Ожидаемая дата окрола: ${_formatDate(breeding.expectedBirthDate!)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}.${date.month}.${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
