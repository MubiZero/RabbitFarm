import 'package:flutter/material.dart';

import '../../../../core/api/api_failure.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../data/models/platform_admin_models.dart';

/// Чем закончился разговор об удалении фермы.
///
/// `deleted` — сервер принял удаление; `error` — не принял, и причину надо
/// показать. Не совпавшее название сюда не попадает: это ошибка формы, и
/// диалог остаётся открытым с сообщением под полем.
typedef FarmDeleteOutcome = ({bool deleted, Object? error});

/// Подтверждение удаления фермы: последствия словами и набранное вручную
/// название.
///
/// Запрос делает сам диалог, а не вызвавший экран: отказ «название не
/// совпадает» — это ошибка ввода, и показать её нужно под тем же полем, не
/// закрывая форму. Возвращает [FarmDeleteOutcome] или `null`, если админ
/// передумал.
Future<FarmDeleteOutcome?> showFarmDeleteDialog(
  BuildContext context, {
  required PlatformFarmDetail farm,
  required Future<Object?> Function(String confirmName) onConfirm,
}) {
  return showDialog<FarmDeleteOutcome>(
    context: context,
    // Закрыть тапом мимо нельзя: набранное название — это и есть согласие,
    // и терять его случайным касанием фона обидно.
    barrierDismissible: false,
    builder: (_) => _FarmDeleteDialog(farm: farm, onConfirm: onConfirm),
  );
}

class _FarmDeleteDialog extends StatefulWidget {
  const _FarmDeleteDialog({required this.farm, required this.onConfirm});

  final PlatformFarmDetail farm;
  final Future<Object?> Function(String confirmName) onConfirm;

  @override
  State<_FarmDeleteDialog> createState() => _FarmDeleteDialogState();
}

class _FarmDeleteDialogState extends State<_FarmDeleteDialog> {
  final _confirm = TextEditingController();

  bool _busy = false;
  bool _mismatch = false;

  @override
  void dispose() {
    _confirm.dispose();
    super.dispose();
  }

  /// Набранное название сходится с настоящим.
  ///
  /// Пробелы по краям не считаются: их добавляет клавиатура, а не
  /// невнимательность админа, — и на сервер уходит уже обрезанная строка.
  bool get _matches => _confirm.text.trim() == widget.farm.name.trim();

  Future<void> _submit() async {
    if (!_matches || _busy) return;

    setState(() {
      _busy = true;
      _mismatch = false;
    });

    final error = await widget.onConfirm(_confirm.text.trim());
    if (!mounted) return;

    // Название разошлось с серверным — например, ферму переименовали, пока
    // карточка была открыта. Диалог остаётся на месте с подсказкой.
    if (error is ApiFailure && error.code == 'CONFIRM_NAME_MISMATCH') {
      setState(() {
        _busy = false;
        _mismatch = true;
      });
      return;
    }

    Navigator.pop(context, (deleted: error == null, error: error));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      icon: const Icon(Icons.delete_forever_outlined, color: AppColors.error),
      title: Text(l10n.platformFarmDeleteTitle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.platformFarmDeleteBody,
              style: AppTypography.bodyMd
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _confirm,
              enabled: !_busy,
              autocorrect: false,
              onChanged: (_) => setState(() => _mismatch = false),
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: l10n.platformFarmDeleteConfirmLabel,
                hintText: l10n.platformFarmDeleteConfirmHint(widget.farm.name),
                errorText: _mismatch ? l10n.platformFarmDeleteMismatch : null,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          // Пока название не набрано целиком, кнопка не работает — в этом и
          // смысл второго подтверждения.
          onPressed: _matches && !_busy ? _submit : null,
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: Text(l10n.commonDelete),
        ),
      ],
    );
  }
}
