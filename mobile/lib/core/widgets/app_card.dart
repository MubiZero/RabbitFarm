import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';

enum AppCardVariant { default_, highlighted, error }

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final Color? borderColor; // override

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.variant = AppCardVariant.default_,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final surface = scheme.surface;
    final effectiveBorder = borderColor ??
        switch (variant) {
          AppCardVariant.highlighted => scheme.primary,
          AppCardVariant.error => scheme.error,
          AppCardVariant.default_ => scheme.outline,
        };

    return Material(
      color: surface,
      borderRadius: AppRadius.lgAll,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgAll,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: effectiveBorder, width: 1),
            borderRadius: AppRadius.lgAll,
          ),
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          child: child,
        ),
      ),
    );
  }
}
