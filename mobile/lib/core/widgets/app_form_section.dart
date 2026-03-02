import 'package:flutter/material.dart';
import '../theme/app_typography.dart';

/// Groups form fields under a semantic section title.
/// Automatically adds 16px gap between child widgets.
class AppFormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const AppFormSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppTypography.labelSm.copyWith(
            color: cs.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}
