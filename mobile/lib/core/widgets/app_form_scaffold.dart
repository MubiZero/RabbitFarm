import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cache/cache_scope.dart';
import '../forms/form_draft.dart';
import '../theme/theme.dart';
import '../l10n/l10n_context.dart';
import 'app_slide_to_confirm.dart';
import '../l10n/error_text.dart';
import 'app_snack.dart';

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
class AppFormScaffold extends ConsumerStatefulWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> children;

  /// Надпись на кнопке. Одно-два слова: длинная подпись переносится на вторую
  /// строку и кнопка выглядит сломанной.
  final String submitLabel;

  /// Сохранение. Возвращает причину неудачи или `null`, если всё получилось.
  ///
  /// Именно причину, а не готовую фразу: текст для человека собирается здесь,
  /// из переводов, а форма о языке интерфейса не знает.
  ///
  /// При ошибке экран остаётся открытым — заполненные поля не должны
  /// пропадать вместе с сообщением об ошибке.
  final Future<Object?> Function() onSubmit;

  /// Что сказать после успешного сохранения.
  final String successMessage;

  /// Есть ли несохранённые изменения. Если да, выход по кнопке «назад»
  /// потребует подтверждения.
  final bool Function()? isDirty;

  final List<Widget>? actions;

  /// Подтверждать сдвигом, а не нажатием.
  ///
  /// Для форм, чью запись не отменить: отметку падежа ставят у клетки, в
  /// перчатке, и случайное касание кнопки внизу экрана там — обычное дело.
  /// Сдвиг пальцем случайно не происходит.
  final bool confirmBySlide;

  /// Что сохранять, если приложение убьют на полуслове.
  ///
  /// Перечисляются только текстовые поля: на них уходят минуты, и именно они
  /// пропадали безвозвратно (см. `core/forms/form_draft.dart`).
  final FormDraft? draft;

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
    this.confirmBySlide = false,
    this.draft,
  });

  @override
  ConsumerState<AppFormScaffold> createState() => _AppFormScaffoldState();
}

class _AppFormScaffoldState extends ConsumerState<AppFormScaffold> {
  bool _submitting = false;

  FormDraftStore get _drafts => FormDraftStore(ref.read(cacheScopeProvider));

  @override
  void initState() {
    super.initState();
    if (widget.draft != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _restoreDraft());
    }
  }

  /// Недописанное возвращается молча, но с объяснением и возможностью
  /// стереть: вопрос «продолжить?» на входе человек читает реже, чем
  /// закрывает, а потерянный текст ему всё равно нужен.
  Future<void> _restoreDraft() async {
    final draft = widget.draft;
    if (draft == null) return;

    final saved = await _drafts.read(draft.key);
    if (saved == null || saved.isEmpty || !mounted) return;

    setState(() => draft.apply(saved));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.formDraftRestored),
        action: SnackBarAction(
          label: context.l10n.formDraftDiscard,
          onPressed: () {
            for (final field in draft.fields.values) {
              field.clear();
            }
            _drafts.forget(draft.key);
            if (mounted) setState(() {});
          },
        ),
      ),
    );
  }

  void _saveDraft() {
    final draft = widget.draft;
    if (draft == null) return;
    _drafts.write(draft.key, draft.snapshot());
  }

  void _forgetDraft() {
    final draft = widget.draft;
    if (draft != null) _drafts.forget(draft.key);
  }

  Future<void> _submit() async {
    if (!(widget.formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    Object? error;
    try {
      error = await widget.onSubmit();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }

    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (error != null) {
      messenger.showError(errorText(context.l10n, error));
      return;
    }

    // Запись сохранена — черновику больше нечего переживать.
    _forgetDraft();
    messenger.showSnackBar(SnackBar(content: Text(widget.successMessage)));
    if (navigator.canPop()) navigator.pop(true);
  }

  /// «Выйти без сохранения» — это и отказ от черновика: человек сказал, что
  /// написанное ему не нужно, и встречать его этим текстом в следующий раз
  /// значило бы не услышать.
  Future<bool> _confirmDiscard() async {
    final discard = await confirmDiscardChanges(context);
    if (discard) _forgetDraft();
    return discard;
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
          // Набор текста не перестраивает экран сам по себе, поэтому вопрос
          // «выйти без сохранения?» вычислялся по состоянию пустой формы и
          // не задавался никогда: заполненная форма закрывалась молча.
          onChanged: () {
            setState(() {});
            _saveDraft();
          },
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
          slide: widget.confirmBySlide,
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

  /// Что сделать по нажатию. `null` — кнопка неактивна: так форма показывает,
  /// что заполнено ещё не всё, до попытки отправки.
  final VoidCallback? onPressed;

  /// Подтверждение сдвигом вместо нажатия — см. `AppFormScaffold.confirmBySlide`.
  final bool slide;

  const AppSubmitBar({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.slide = false,
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
        child: slide && !busy && onPressed != null
            ? AppSlideToConfirm(
                label: label,
                color: context.colors.primary,
                onConfirmed: onPressed!,
              )
            : FilledButton(
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

/// Спросить, не жалко ли потерять заполненное.
///
/// Живёт отдельно от каркаса: форма кролика собирает свой экран сама, и без
/// общей функции у неё либо не было бы вопроса вовсе, либо появился бы
/// второй такой же диалог со своим текстом.
Future<bool> confirmDiscardChanges(BuildContext context) async {
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
