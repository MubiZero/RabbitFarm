import 'package:flutter/material.dart';
import '../theme/app_typography.dart';

class AppFilterChipData {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const AppFilterChipData({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });
}

class AppFilterBar extends StatelessWidget {
  final List<AppFilterChipData> chips;
  final double height;

  const AppFilterBar({
    super.key,
    required this.chips,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final outline = Theme.of(context).colorScheme.outline;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final chip = chips[i];
          final color = chip.color ?? primary;
          return FilterChip(
            label: Text(
              chip.label,
              style: AppTypography.labelSm.copyWith(
                color: chip.isSelected ? color : onSurfaceVariant,
                fontWeight: chip.isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            selected: chip.isSelected,
            onSelected: (_) => chip.onTap(),
            selectedColor: color.withValues(alpha: 0.12),
            checkmarkColor: color,
            showCheckmark: true,
            side: BorderSide(
              color: chip.isSelected ? color : outline,
            ),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 4),
          );
        },
      ),
    );
  }
}
