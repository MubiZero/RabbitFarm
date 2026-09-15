import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';

/// Что админ решил, закрывая обращение: текст ответа или пустая строка, если
/// закрыл молча. Отдельная запись, а не голый `String?`, чтобы «закрыл без
/// ответа» не путалось с «передумал и закрыл диалог» (это `null`).
typedef SupportResolveChoice = ({String? answer});

/// Закрыть обращение — с ответом автору или без.
///
/// Раньше кнопка «Разобрано» закрывала обращение молча, и ферма об этом не
/// узнавала вовсе. Поле ответа здесь не обязательное: часть обращений
/// разбирают звонком, и заставлять писать текст ради закрытия — лишняя работа.
Future<SupportResolveChoice?> showSupportResolveDialog(BuildContext context) {
  return showDialog<SupportResolveChoice>(
    context: context,
    builder: (_) => const _SupportResolveDialog(),
  );
}

class _SupportResolveDialog extends StatefulWidget {
  const _SupportResolveDialog();

  @override
  State<_SupportResolveDialog> createState() => _SupportResolveDialogState();
}

class _SupportResolveDialogState extends State<_SupportResolveDialog> {
  static const _maxLength = 2000;

  final _answer = TextEditingController();

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final answer = _answer.text.trim();

    return AlertDialog(
      icon: const Icon(Icons.mark_email_read_outlined),
      title: Text(l10n.platformSupportResolveTitle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.platformSupportResolveBody,
              style: AppTypography.bodyMd.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _answer,
              autofocus: true,
              maxLength: _maxLength,
              minLines: 3,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: l10n.platformSupportResolveAnswerLabel,
                hintText: l10n.platformSupportResolveAnswerHint,
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        // Подпись говорит, что именно произойдёт: уйдёт ответ человеку или
        // обращение просто закроется. Одна кнопка с двумя разными
        // последствиями обязана называть их вслух.
        TextButton(
          onPressed: () =>
              Navigator.pop(context, (answer: answer.isEmpty ? null : answer)),
          child: Text(
            answer.isEmpty
                ? l10n.platformSupportResolveWithoutAnswer
                : l10n.platformSupportResolveSendAnswer,
          ),
        ),
      ],
    );
  }
}
