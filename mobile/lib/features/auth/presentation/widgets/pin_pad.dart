import 'package:flutter/material.dart';

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
    onChanged(value + digit);
  }

  void _backspace() {
    if (value.isEmpty) return;
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
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled
                    ? (error != null ? AppColors.error : context.accent)
                    : Colors.transparent,
                border: Border.all(
                  color: error != null ? AppColors.error : cs.outlineVariant,
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
            const SizedBox(width: 88, height: 72),
            _PinKey('0', _append),
            SizedBox(
              width: 88,
              height: 72,
              child: IconButton(
                tooltip: context.l10n.pinDelete,
                onPressed: value.isEmpty ? null : _backspace,
                icon: const Icon(Icons.backspace_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PinKey extends StatelessWidget {
  const _PinKey(this.digit, this.onTap);

  final String digit;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 72,
      child: TextButton(
        onPressed: () => onTap(digit),
        child: Text(
          digit,
          style: AppTypography.displayMd.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
