import 'package:flutter/material.dart';
import '../theme/app_typography.dart';

/// A single step in the product tour.
class CoachMarkStep {
  final GlobalKey targetKey;
  final String title;
  final String description;

  const CoachMarkStep({
    required this.targetKey,
    required this.title,
    required this.description,
  });
}

/// Full-screen overlay that highlights a target widget and shows a tooltip.
///
/// Wrap inside a [Stack] that covers the full screen, or use [OverlayEntry].
class CoachMarkOverlay extends StatefulWidget {
  final List<CoachMarkStep> steps;
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const CoachMarkOverlay({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.onNext,
    required this.onSkip,
  });

  @override
  State<CoachMarkOverlay> createState() => _CoachMarkOverlayState();
}

class _CoachMarkOverlayState extends State<CoachMarkOverlay>
    with SingleTickerProviderStateMixin {
  Rect? _targetRect;
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureTarget();
      _ctrl.forward();
    });
  }

  @override
  void didUpdateWidget(CoachMarkOverlay old) {
    super.didUpdateWidget(old);
    if (old.currentStep != widget.currentStep) {
      _ctrl.reverse().then((_) {
        _measureTarget();
        _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _measureTarget() {
    final step = widget.steps[widget.currentStep];
    final renderBox =
        step.targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      final pos = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      setState(() {
        _targetRect = Rect.fromLTWH(
          pos.dx - 8,
          pos.dy - 8,
          size.width + 16,
          size.height + 16,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_targetRect == null) return const SizedBox.expand();

    final step = widget.steps[widget.currentStep];
    final isLast = widget.currentStep == widget.steps.length - 1;
    final screen = MediaQuery.of(context).size;

    // Show tooltip above target when target is in the bottom half
    final showAbove = _targetRect!.center.dy > screen.height * 0.5;
    final tooltipTop = showAbove
        ? (_targetRect!.top - 200).clamp(16.0, screen.height - 220)
        : (_targetRect!.bottom + 16).clamp(16.0, screen.height - 220);

    return FadeTransition(
      opacity: _fade,
      child: Stack(
        children: [
          // Scrim with cutout
          Positioned.fill(
            child: CustomPaint(
              painter: _ScrimPainter(targetRect: _targetRect!),
            ),
          ),

          // Tooltip card
          Positioned(
            left: 20,
            right: 20,
            top: tooltipTop,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            step.title,
                            style: AppTypography.titleMd.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Text(
                          '${widget.currentStep + 1} / ${widget.steps.length}',
                          style: AppTypography.labelSm.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step.description,
                      style: AppTypography.bodyMd.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: widget.onSkip,
                          child: Text(
                            'Пропустить',
                            style: AppTypography.labelLg.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: widget.onNext,
                          child: Text(isLast ? 'Готово' : 'Далее'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrimPainter extends CustomPainter {
  final Rect targetRect;
  const _ScrimPainter({required this.targetRect});

  @override
  void paint(Canvas canvas, Size size) {
    // saveLayer so BlendMode.clear punches through the scrim
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );

    // Dark scrim
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black.withValues(alpha: 0.75),
    );

    // Cutout around target
    canvas.drawRRect(
      RRect.fromRectAndRadius(targetRect, const Radius.circular(12)),
      Paint()..blendMode = BlendMode.clear,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_ScrimPainter old) => old.targetRect != targetRect;
}
