import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../utils/cage_tag.dart';

/// Прочитать метку на клетке.
///
/// Заменяет самый частый и самый бесполезный шаг в крольчатнике: вспомнить
/// номер клетки, у которой стоишь, и найти его в списке. Камера отвечает на
/// этот вопрос за секунду и без набора.
class CageScannerScreen extends StatefulWidget {
  const CageScannerScreen({super.key});

  @override
  State<CageScannerScreen> createState() => _CageScannerScreenState();
}

class _CageScannerScreenState extends State<CageScannerScreen> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  /// Уже уходим на клетку. Камера успевает отдать один и тот же код
  /// несколько раз подряд, и без флага экран открывался бы дважды.
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    for (final barcode in capture.barcodes) {
      final cageId = cageIdFromTag(barcode.rawValue);
      if (cageId == null) continue;

      _handled = true;
      HapticFeedback.mediumImpact();
      context.pushReplacement('/cages/$cageId');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.cageScanTitle)),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error, _) => _CameraProblem(error: error),
          ),
          // Подсказка внизу, а не поверх кадра: наводят камеру, глядя на
          // клетку, и текст посередине закрывал бы ровно то, что ищут.
          Positioned(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            bottom: AppSpacing.xxl,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: AppRadius.lgAll,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  context.l10n.cageScanHint,
                  textAlign: TextAlign.center,
                  style: context.text.bodyMedium?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Камеры нет или доступ к ней закрыт — это не ошибка приложения, и текст
/// ошибки движка человеку ничего не объяснит.
class _CameraProblem extends StatelessWidget {
  const _CameraProblem({required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.no_photography_outlined,
              size: 48,
              color: context.colors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.cageScanNoCamera,
              textAlign: TextAlign.center,
              style: context.text.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
