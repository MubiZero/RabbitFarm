import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/rabbit_model.dart';

class RabbitCard extends StatelessWidget {
  final RabbitModel rabbit;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const RabbitCard({
    super.key,
    required this.rabbit,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge(rabbit.birthDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar/Photo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getSexColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  _getSexIcon(),
                  size: 30,
                  color: _getSexColor(),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      rabbit.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),

                    // Tag and Breed
                    Text(
                      '№${rabbit.tagId} • ${rabbit.breed?.name ?? "Порода не указана"}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 4),

                    // Age and Weight
                    Row(
                      children: [
                        Icon(Icons.cake, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          age,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(width: 12),
                        if (rabbit.currentWeight != null) ...[
                          Icon(Icons.monitor_weight,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${rabbit.currentWeight!.toStringAsFixed(2)} кг',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                        ],
                      ],
                    ),

                    // Status badges
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        _StatusChip(
                          label: _getStatusText(rabbit.status),
                          color: _getStatusColor(rabbit.status),
                        ),
                        _StatusChip(
                          label: _getPurposeText(rabbit.purpose),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  onPressed: onDelete,
                ),
            ],
          ),
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

  IconData _getSexIcon() {
    return rabbit.sex == 'male' ? Icons.male : Icons.female;
  }

  Color _getSexColor() {
    return rabbit.sex == 'male' ? Colors.blue : Colors.pink;
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'pregnant':
        return Colors.purple;
      case 'sick':
        return Colors.orange;
      case 'sold':
        return Colors.grey;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
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
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color.withOpacity(0.9),
        ),
      ),
    );
  }
}
