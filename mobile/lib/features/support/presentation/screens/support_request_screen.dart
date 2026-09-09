import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/support_provider.dart';

/// Написать в поддержку — одно поле, без темы и категории: выбирать раздел
/// в форме на два поля означало бы заставить ферму классифицировать
/// собственную проблему за поддержку (см. `supportRequestValidator.js`).
///
/// Своей истории обращений экран не показывает: отвечает поддержка тем же
/// способом, каким связывалась бы и раньше, — увидеть текст обращения после
/// отправки можно только заново его вспомнив.
class SupportRequestScreen extends ConsumerStatefulWidget {
  const SupportRequestScreen({super.key});

  @override
  ConsumerState<SupportRequestScreen> createState() =>
      _SupportRequestScreenState();
}

class _SupportRequestScreenState extends ConsumerState<SupportRequestScreen> {
  static const _minLength = 10;
  static const _maxLength = 2000;

  final _text = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _text.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  bool get _isDirty => _text.text.trim().isNotEmpty;

  bool get _isValid => _text.text.trim().length >= _minLength;

  Future<void> _submit() async {
    if (!_isValid || _sending) return;

    setState(() => _sending = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    Object? error;
    try {
      await ref.read(supportRepositoryProvider).create(_text.text.trim());
    } catch (e) {
      error = e;
    }
    if (!mounted) return;
    setState(() => _sending = false);

    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, error)),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(l10n.supportRequestSent)));
    if (navigator.canPop()) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: !_isDirty && !_sending,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || _sending) return;
        if (await confirmDiscardChanges(context) && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.supportRequestTitle)),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          children: [
            Text(
              l10n.supportRequestHint,
              style: AppTypography.bodyMd
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _text,
              enabled: !_sending,
              maxLength: _maxLength,
              minLines: 5,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: l10n.supportRequestPlaceholder,
                alignLabelWithHint: true,
                errorText: _text.text.isNotEmpty && !_isValid
                    ? l10n.supportRequestTooShort
                    : null,
              ),
            ),
          ],
        ),
        bottomNavigationBar: AppSubmitBar(
          label: l10n.supportRequestSend,
          busy: _sending,
          onPressed: _isValid ? _submit : null,
        ),
      ),
    );
  }
}
