import 'package:flutter/material.dart';

/// Плейсхолдер загрузки: мягко пульсирующий прямоугольник.
/// Из таких блоков собирается макет, повторяющий геометрию будущего контента,
/// чтобы при подстановке данных ничего не прыгало.
class SkeletonBox extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final radius = widget.borderRadius ?? BorderRadius.circular(8);

    // При включённом «уменьшить движение» показываем статичный блок.
    if (MediaQuery.of(context).disableAnimations) {
      return _box(base.withValues(alpha: 0.6), radius);
    }

    return FadeTransition(
      opacity: Tween(begin: 0.45, end: 0.9).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
      ),
      child: _box(base, radius),
    );
  }

  Widget _box(Color color, BorderRadius radius) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(color: color, borderRadius: radius),
      );
}
