import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../l10n/l10n_context.dart';

/// Каркас экрана-формы: заголовок, прокручиваемые поля и кнопка сохранения,
/// закреплённая внизу.
///
/// Одиннадцать форм повторяли один и тот же обвес вокруг сохранения: проверить
/// поля, поднять флаг занятости, дождаться ответа, опустить флаг, показать
/// сообщение, закрыть экран. Повторялись и ошибки в нём — например,
/// `setState` после закрытия экрана, если ответ пришёл позже, чем пользователь
/// нажал «назад».
///
/// Экрану остаётся описать поля и одну функцию сохранения.
class AppFormScaffold extends StatefulWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> children;

  /// Надпись на кнопке. Одно-два слова: длинная подпись переносится на вторую
  /// строку и кнопка выглядит сломанной.
  final String submitLabel;

  /// Сохранение. Возвращает текст ошибки или `null`, если всё получилось.
  ///
  /// При ошибке экран остаётся открытым — заполненные поля не должны
  /// пропадать вместе с сообщением об ошибке.
  final Future<String?> Function() onSubmit;

  /// Что сказать после успешного сохранения.
  final String successMessage;

  /// Есть ли несохранённые изменения. Если да, выход по кнопке «назад»
  /// потребует подтверждения.
  final bool Function()? isDirty;

  final List<Widget>? actions;

  const AppFormScaffold({
    super.key,
    required this.title,
    required this.formKey,
    required this.children,
    required this.submitLabel,
    required this.onSubmit,
    required this.successMessage,
    this.isDirty,
    this.actions,
  });

  @override
  State<AppFormScaffold> createState() => _AppFormScaffoldState();
}

class _AppFormScaffoldState extends State<AppFormScaffold> {
  bool _submitting = false;

  Future<void> _submit() async {
    if (!(widget.formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    String? error;
    try {
      error = await widget.onSubmit();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }

    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(widget.successMessage)));
    if (navigator.canPop()) navigator.pop(true);
  }

  Future<bool> _confirmDiscard() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.formDiscardTitle),
        content: Text(context.l10n.formDiscardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.formDiscardStay),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.formDiscardLeave),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !(widget.isDirty?.call() ?? false) && !_submitting,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || _submitting) return;
        if (await _confirmDiscard() && mounted) {
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: widget.actions),
        body: Form(
          key: widget.formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            children: [
              for (var i = 0; i < widget.children.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.xl),
                widget.children[i],
              ],
            ],
          ),
        ),
        bottomNavigationBar: AppSubmitBar(
          label: widget.submitLabel,
          busy: _submitting,
          onPressed: _submit,
        ),
      ),
    );
  }
}

/// Закреплённая внизу панель с основной кнопкой.
///
/// Кнопка сохранения не должна уезжать вместе с полями: на длинной форме до
/// неё приходилось долистывать, а на короткой она болталась посреди экрана.
class AppSubmitBar extends StatelessWidget {
  final String label;
  final bool busy;
  final VoidCallback onPressed;

  const AppSubmitBar({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.outline)),
      ),
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          AppSpacing.md,
          AppSpacing.screenH,
          AppSpacing.md,
        ),
        child: FilledButton(
          onPressed: busy ? null : onPressed,
          child: busy
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(label),
        ),
      ),
    );
  }
}
