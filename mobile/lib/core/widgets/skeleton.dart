import 'package:flutter/material.dart';

import '../theme/theme.dart';

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
    _ctrl = AnimationController(vsync: this, duration: AppDuration.slow)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.colors.surfaceContainerHighest;
    final radius = widget.borderRadius ?? AppRadius.smAll;

    // При включённом «уменьшить движение» показываем статичный блок.
    if (context.reduceMotion) {
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

/// Заглушка одной карточки списка: значок, заголовок и строка подписи.
///
/// Размеры подобраны под настоящие карточки, поэтому в момент подстановки
/// данных список не дёргается и позиция прокрутки не сбивается.
class SkeletonCard extends StatelessWidget {
  final double height;

  const SkeletonCard({super.key, this.height = 88});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          const SkeletonBox(width: 40, height: 40, borderRadius: AppRadius.mdAll),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(width: 140, height: 14),
                const SizedBox(height: AppSpacing.sm),
                SkeletonBox(
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Столбик карточек-заглушек — стандартный вид первой загрузки списка.
class SkeletonList extends StatelessWidget {
  final int count;
  final EdgeInsetsGeometry padding;
  final double itemHeight;

  const SkeletonList({
    super.key,
    this.count = 5,
    this.padding = const EdgeInsets.all(AppSpacing.screenH),
    this.itemHeight = 88,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.md),
            SkeletonCard(height: itemHeight),
          ],
        ],
      ),
    );
  }
}

/// Заглушка строки крупных метрик — под [StatTile] и сводные плитки.
class SkeletonStatRow extends StatelessWidget {
  final int count;
  final double height;

  const SkeletonStatRow({super.key, this.count = 2, this.height = 116});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SkeletonBox(height: height, borderRadius: AppRadius.lgAll),
          ),
        ],
      ],
    );
  }
}
