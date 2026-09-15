import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n_context.dart';
import '../theme/theme.dart';

/// Подтверждение сдвигом — для того, что нельзя вернуть.
///
/// Обычная кнопка «Удалить» в диалоге рассчитана на точное нажатие. В сарае
/// точности нет: телефон держат одной рукой, в перчатке, часто на морозе, и
/// случайное касание там — обычное дело. Сдвиг пальцем случайно не
/// происходит: это не мгновенное касание, а движение, которое нужно
/// намеренно довести до конца.
///
/// Ставится не на всякое удаление, а только на необратимое: там, где есть
/// отмена в течение нескольких секунд (см. [deleteWithUndo]), лишний барьер
/// только мешает.
class AppSlideToConfirm extends StatefulWidget {
  const AppSlideToConfirm({
    super.key,
    required this.label,
    required this.onConfirmed,
    this.color,
  });

  /// Что произойдёт: «Сдвиньте, чтобы удалить ферму».
  final String label;
  final VoidCallback onConfirmed;

  /// Цвет заливки. По умолчанию — цвет ошибки: почти всегда это удаление.
  final Color? color;

  @override
  State<AppSlideToConfirm> createState() => _AppSlideToConfirmState();
}

class _AppSlideToConfirmState extends State<AppSlideToConfirm> {
  double _progress = 0;
  bool _done = false;

  /// Доля ширины, после которой действие считается подтверждённым. Не 1.0:
  /// довести ползунок ровно до края на ходу почти невозможно, и требовать
  /// этого значило бы превратить защиту от случайности в препятствие.
  static const _threshold = 0.9;

  void _update(double width, double dx) {
    if (_done) return;
    setState(() => _progress = (dx / width).clamp(0.0, 1.0));
  }

  void _release() {
    if (_done) return;
    if (_progress >= _threshold) {
      setState(() => _done = true);
      HapticFeedback.mediumImpact();
      widget.onConfirmed();
      return;
    }
    setState(() => _progress = 0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = widget.color ?? colors.error;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const knob = AppSizes.touchTargetLarge;
        final travel = (width - knob).clamp(1.0, double.infinity);

        return SizedBox(
          height: AppSizes.touchTargetLarge,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.pillAll,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: knob),
                  child: Opacity(
                    // Подпись уступает место ползунку по мере движения:
                    // читать её на середине жеста уже не нужно.
                    opacity: (1 - _progress * 1.6).clamp(0.0, 1.0),
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: context.text.labelLarge?.copyWith(color: color),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: _progress * travel,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      _update(travel, details.localPosition.dx + _progress * travel),
                  onHorizontalDragEnd: (_) => _release(),
                  child: Container(
                    width: knob,
                    height: knob,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    child: Icon(
                      _done ? Icons.check : Icons.arrow_forward,
                      color: colors.onError,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Спросить подтверждение сдвигом. `true` — человек довёл жест до конца.
Future<bool> confirmBySliding(
  BuildContext context, {
  required String title,
  required String body,
  required String slideLabel,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: sheetContext.text.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              style: sheetContext.text.bodyLarge?.copyWith(
                color: sheetContext.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppSlideToConfirm(
              label: slideLabel,
              onConfirmed: () => Navigator.of(sheetContext).pop(true),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              height: AppSizes.touchTarget,
              child: TextButton(
                onPressed: () => Navigator.of(sheetContext).pop(false),
                child: Text(sheetContext.l10n.commonCancel),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}
