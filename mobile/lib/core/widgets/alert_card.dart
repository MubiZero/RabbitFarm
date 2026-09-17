import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';

class AlertCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const AlertCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;

    return Material(
      color: surface,
      borderRadius: AppRadius.lgAll,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 4)),
            borderRadius: AppRadius.lgAll,
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.mdAll,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTypography.titleMd.copyWith(color: color)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(description,
                        style: AppTypography.bodyMd.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        )),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
