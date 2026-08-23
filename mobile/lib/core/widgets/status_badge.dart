import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../l10n/l10n_context.dart';

enum RabbitStatus { active, inactive, sick, pregnant, sold, deceased, quarantine }

extension RabbitStatusX on RabbitStatus {
  static RabbitStatus fromString(String status) => switch (status) {
    'active' || 'healthy' => RabbitStatus.active,
    'sick'                => RabbitStatus.sick,
    'pregnant'            => RabbitStatus.pregnant,
    'sold'                => RabbitStatus.sold,
    'deceased'            => RabbitStatus.deceased,
    'quarantine'          => RabbitStatus.quarantine,
    _                     => RabbitStatus.inactive,
  };
}

class StatusBadge extends StatelessWidget {
  final RabbitStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final (label, color) = switch (status) {
      // Одно и то же состояние подписывалось двумя словами: в форме кролик
      // «Здоров», а в списке — «Активен». Слово берём из общего словаря.
      RabbitStatus.active     => (context.l10n.statusHealthy, AppColors.success),
      RabbitStatus.inactive   => (context.l10n.statusInactive, muted),
      RabbitStatus.sick       => (context.l10n.statusSick, AppColors.error),
      RabbitStatus.pregnant   => (context.l10n.statusPregnant, AppColors.domainBreeding),
      RabbitStatus.sold       => (context.l10n.statusSold, AppColors.warning),
      RabbitStatus.deceased   => (context.l10n.statusDead, muted),
      RabbitStatus.quarantine => (context.l10n.statusQuarantine, AppColors.warning),
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
