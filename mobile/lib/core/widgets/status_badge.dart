import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum RabbitStatus { active, inactive, sick, pregnant, sold }

class StatusBadge extends StatelessWidget {
  final RabbitStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      RabbitStatus.active   => ('Активен',   AppColors.success),
      RabbitStatus.inactive => ('Неактивен', AppColors.darkTextSecondary),
      RabbitStatus.sick     => ('Болен',     AppColors.error),
      RabbitStatus.pregnant => ('Беременна', AppColors.accentRose),
      RabbitStatus.sold     => ('Продан',    AppColors.warning),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(color: color),
      ),
    );
  }
}
