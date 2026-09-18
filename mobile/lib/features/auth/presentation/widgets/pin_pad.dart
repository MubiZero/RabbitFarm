import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../data/pin_repository.dart';

/// Ввод четырёх цифр: точки состояния и своя крупная клавиатура.
///
/// Своя, а не системная: цифры на ней размером с палец в рабочей перчатке,
/// на экране нет ничего лишнего, и клавиатура не перекрывает сами точки —
/// человек всегда видит, сколько цифр уже набрано.
class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.value,
    required this.onChanged,
    this.error,
  });

  final String value;
  final ValueChanged<String> onChanged;

  /// Подпись под точками: промах, несовпадение при повторе.
  final String? error;

  void _append(String digit) {
    if (value.length >= PinRepository.pinLength) return;
    // Короткий отклик в палец: на солнце экран видно плохо, а телефон часто
    // держат в перчатке — щелчок говорит «цифра засчитана» быстрее, чем
    // глаз находит точки.
    HapticFeedback.selectionClick();
    onChanged(value + digit);
  }

  void _backspace() {
    if (value.isEmpty) return;
    HapticFeedback.selectionClick();
    onChanged(value.substring(0, value.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(PinRepository.pinLength, (index) {
            final filled = index < value.length;
            // Набранная цифра помечается цветом текста, а не акцентом
            // темы: акцентом в приложении показывают то, что нажимается, а
            // главное здесь — чтобы точку было видно. Изумруд на светлой
            // теме давал 2.35 к фону при норме 3.
            final marker = error != null ? AppColors.error : cs.onSurface;
            // Пустая точка раньше была прозрачной с контуром `outlineVariant`
            // — это 1,5:1 к фону при норме 3:1, то есть её просто не было
            // видно. Человек нажимал цифру, не видел изменений и решал, что
            // нажатие потерялось: жал ещё раз, набирал лишнее и сбивался.
            return AnimatedContainer(
              duration: AppDuration.instant,
              curve: AppDuration.curve,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled
                    ? marker
                    : cs.onSurfaceVariant.withValues(alpha: 0.15),
                border: Border.all(
                  color: filled ? marker : cs.onSurfaceVariant,
                  width: 2,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: AppSpacing.md),
        // Место под подпись занято всегда — иначе клавиатура прыгает вверх
        // ровно в тот момент, когда человек целится в цифру.
        SizedBox(
          height: 20,
          child: error == null
              ? null
              : Text(
                  error!,
                  style: AppTypography.labelSm.copyWith(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
        ),
        const SizedBox(height: AppSpacing.xl),
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [for (final digit in row) _PinKey(digit, _append)],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: _keyWidth, height: _keyHeight),
            _PinKey('0', _append),
            SizedBox(
              width: _keyWidth,
              height: _keyHeight,
              // Подпись через Semantics, а не `tooltip`: всплывающая
              // подсказка живёт в слое поверх навигатора, а экран замка
              // рисуется НАД ним (см. `PinGate` в main.dart) — и вместо
              // клавиши «стереть» на экране появлялась красная плашка
              // Flutter. Для голосового доступа подпись при этом та же, а
              // всплывающая подсказка на клавише цифрового кода всё равно
              // бесполезна: её показывают долгим нажатием, которого здесь
              // никто не делает.
              child: Semantics(
                label: context.l10n.pinDelete,
                button: true,
                child: IconButton(
                  onPressed: value.isEmpty ? null : _backspace,
                  icon: const Icon(Icons.backspace_outlined),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

const double _keyWidth = 88;
const double _keyHeight = 72;

class _PinKey extends StatelessWidget {
  const _PinKey(this.digit, this.onTap);

  final String digit;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    return SizedBox(
      width: _keyWidth,
      height: _keyHeight,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: TextButton(
          // Клавиша раньше была голой цифрой на фоне экрана: непонятно, где
          // она начинается и куда целиться. Своя подложка делает её похожей
          // на клавишу, а подсветка акцентом показывает само нажатие.
          style: TextButton.styleFrom(
            backgroundColor: cs.surfaceContainerHighest,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
            overlayColor: context.accent,
          ),
          onPressed: () => onTap(digit),
          child: Text(
            digit,
            style: AppTypography.displayMd.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
