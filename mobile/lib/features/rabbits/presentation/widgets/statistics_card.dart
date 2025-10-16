import 'package:flutter/material.dart';
import '../../data/models/rabbit_statistics.dart';

class StatisticsCard extends StatelessWidget {
  final RabbitStatistics statistics;

  const StatisticsCard({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Статистика',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Main stats grid
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _StatItem(
                  icon: Icons.pets,
                  label: 'Всего',
                  value: statistics.total.toString(),
                  color: Colors.blue,
                ),
                _StatItem(
                  icon: Icons.check_circle,
                  label: 'Живые',
                  value: statistics.aliveCount.toString(),
                  color: Colors.green,
                ),
                _StatItem(
                  icon: Icons.male,
                  label: 'Самцы',
                  value: statistics.maleCount.toString(),
                  color: Colors.blue,
                ),
                _StatItem(
                  icon: Icons.female,
                  label: 'Самки',
                  value: statistics.femaleCount.toString(),
                  color: Colors.pink,
                ),
                _StatItem(
                  icon: Icons.pregnant_woman,
                  label: 'Бер-ных',
                  value: statistics.pregnantCount.toString(),
                  color: Colors.purple,
                ),
                _StatItem(
                  icon: Icons.medical_services,
                  label: 'Больных',
                  value: statistics.sickCount.toString(),
                  color: Colors.orange,
                ),
              ],
            ),

            // By breed (if available)
            if (statistics.byBreed.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'По породам',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...statistics.byBreed.map((breedStat) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            breedStat.breedName ?? 'Неизвестная порода',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            breedStat.count.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
