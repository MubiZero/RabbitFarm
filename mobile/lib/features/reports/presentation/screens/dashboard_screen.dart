import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/reports_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Сводка фермы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(dashboardReportProvider);
            },
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (dashboard) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardReportProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildRabbitsCard(context, dashboard.rabbits),
              const SizedBox(height: 16),
              _buildCagesCard(context, dashboard.cages),
              const SizedBox(height: 16),
              _buildHealthCard(context, dashboard.health),
              const SizedBox(height: 16),
              _buildFinanceCard(context, dashboard.finance),
              const SizedBox(height: 16),
              _buildTasksCard(context, dashboard.tasks),
              const SizedBox(height: 16),
              _buildInventoryCard(context, dashboard.inventory),
              const SizedBox(height: 16),
              _buildBreedingCard(context, dashboard.breeding),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ошибка: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(dashboardReportProvider);
                },
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRabbitsCard(BuildContext context, dynamic rabbitsStats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.pets, color: Colors.brown),
                const SizedBox(width: 8),
                const Text(
                  'Кролики',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => context.push('/rabbits'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildStatRow('Всего', '${rabbitsStats.total}'),
            _buildStatRow('Самцов', '${rabbitsStats.male}'),
            _buildStatRow('Самок', '${rabbitsStats.female}'),
          ],
        ),
      ),
    );
  }

  Widget _buildCagesCard(BuildContext context, dynamic cagesStats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.grid_view, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Клетки',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => context.push('/cages'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildStatRow('Всего', '${cagesStats.total}'),
            _buildStatRow('Заняты', '${cagesStats.occupied}'),
            _buildStatRow(
              'Свободны',
              '${cagesStats.available}',
              valueColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(BuildContext context, dynamic healthStats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_services, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  'Здоровье',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => context.push('/vaccinations'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildStatRow(
              'Предстоящие вакцинации',
              '${healthStats.upcomingVaccinations}',
              valueColor: Colors.orange,
            ),
            _buildStatRow(
              'Просроченные вакцинации',
              '${healthStats.overdueVaccinations}',
              valueColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceCard(BuildContext context, dynamic financeStats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Финансы (30 дней)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => context.push('/transactions'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildStatRow(
              'Доход',
              '${financeStats.income30days} ₽',
              valueColor: Colors.green,
            ),
            _buildStatRow(
              'Расход',
              '${financeStats.expenses30days} ₽',
              valueColor: Colors.red,
            ),
            _buildStatRow(
              'Прибыль',
              '${financeStats.profit30days} ₽',
              valueColor: double.parse(financeStats.profit30days.toString()) >= 0
                  ? Colors.green
                  : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksCard(BuildContext context, dynamic tasksStats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.task_alt, color: Colors.purple),
                const SizedBox(width: 8),
                const Text(
                  'Задачи',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => context.push('/tasks'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildStatRow('Ожидают', '${tasksStats.pending}'),
            _buildStatRow(
              'Просрочены',
              '${tasksStats.overdue}',
              valueColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(BuildContext context, dynamic inventoryStats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.inventory, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  'Инвентарь',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => context.push('/feeds'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildStatRow(
              'Корма с низким запасом',
              '${inventoryStats.lowStockFeeds}',
              valueColor: inventoryStats.lowStockFeeds > 0
                  ? Colors.red
                  : Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreedingCard(BuildContext context, dynamic breedingStats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.child_care, color: Colors.pink),
                const SizedBox(width: 8),
                const Text(
                  'Разведение',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => context.push('/births'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildStatRow(
              'Рождений (30 дней)',
              '${breedingStats.recentBirths}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
