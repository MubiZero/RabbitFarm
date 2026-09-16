import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/models/support_contact.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/platform_admin_provider.dart';

/// Официальный телефон и почта поддержки — то, что ферма видит на своём
/// экране обращений.
///
/// Задать их до сих пор было негде, поэтому блок «свяжитесь напрямую» не
/// показывался никому и никогда. Оба поля необязательные: пустые — это
/// осознанное «прямого контакта нет», и тогда ферма блок не увидит.
Future<void> showSupportContactDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const _SupportContactDialog(),
  );
}

class _SupportContactDialog extends ConsumerStatefulWidget {
  const _SupportContactDialog();

  @override
  ConsumerState<_SupportContactDialog> createState() =>
      _SupportContactDialogState();
}

class _SupportContactDialogState extends ConsumerState<_SupportContactDialog> {
  final _email = TextEditingController();
  final _phone = TextEditingController();

  bool _seeded = false;
  bool _saving = false;
  Object? _error;
  bool _showEmailError = false;

  @override
  void dispose() {
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final email = _email.text.trim();
    if (email.isNotEmpty && !email.contains('@')) {
      setState(() => _showEmailError = true);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final phone = _phone.text.trim();
    try {
      await ref.read(platformAdminRepositoryProvider).updateSupportContact(
            SupportContact(
              email: email.isEmpty ? null : email,
              phone: phone.isEmpty ? null : phone,
            ),
          );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = e;
      });
      return;
    }

    if (!mounted) return;
    // Экран фермы читает контакт своим провайдером — тот подтянет новое
    // значение при следующем открытии; здесь достаточно сбросить админский.
    ref.invalidate(platformSupportContactProvider);
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(content: Text(context.l10n.platformSupportContactSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final contact = ref.watch(platformSupportContactProvider);

    // Поля заполняются один раз: перечитывать их из провайдера на каждой
    // перерисовке значило бы затирать то, что админ уже набрал.
    final loaded = contact.value;
    if (!_seeded && loaded != null) {
      _seeded = true;
      _email.text = loaded.email ?? '';
      _phone.text = loaded.phone ?? '';
    }

    return AlertDialog(
      icon: const Icon(Icons.contact_support_outlined),
      title: Text(l10n.platformSupportContactTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.platformSupportContactBody,
                style: AppTypography.bodyMd.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Пока текущий контакт не приехал, полей нет вовсе: пустые поля
              // на секунду читались бы как «контакт не задан», а это ровно
              // тот вывод, ради которого форму и открыли.
              if (loaded == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: contact.hasError
                      ? Text(
                          errorText(l10n, contact.error),
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.error,
                          ),
                        )
                      : const Center(child: DelayedSpinner()),
                )
              else ...[
                TextField(
                  controller: _phone,
                  enabled: !_saving,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l10n.platformSupportContactPhone,
                    hintText: l10n.platformSupportContactPhoneHint,
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _email,
                  enabled: !_saving,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    if (_showEmailError) {
                      setState(() => _showEmailError = false);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: l10n.platformSupportContactEmail,
                    hintText: l10n.platformSupportContactEmailHint,
                    prefixIcon: const Icon(Icons.email_outlined),
                    errorText: _showEmailError
                        ? l10n.platformSupportContactEmailInvalid
                        : null,
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  errorText(l10n, _error),
                  style: AppTypography.labelSm.copyWith(color: AppColors.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: _saving || loaded == null ? null : _save,
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
