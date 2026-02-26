import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {
  final int current; // 1-based
  final int total;

  const OnboardingProgress({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final inactive = Theme.of(context).colorScheme.outline;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i < current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? accent : inactive,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
