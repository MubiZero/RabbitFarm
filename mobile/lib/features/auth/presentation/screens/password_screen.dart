import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../providers/auth_provider.dart';

/// Задать или сменить пароль — запасной способ входа рядом с телефоном+кодом.
///
/// Один экран на оба случая: `hasPassword` решает, нужно ли поле текущего
/// пароля. Смена (не первичная установка) отзывает токены на сервере — после
/// успеха приложение само выходит, а не ждёт следующего 401.
class PasswordScreen extends ConsumerStatefulWidget {
  const PasswordScreen({super.key});

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit(bool hasPassword) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    setState(() => _isSubmitting = true);
    try {
      if (hasPassword) {
        await ref.read(authProvider.notifier).changePassword(
              currentPassword: _currentController.text,
              newPassword: _newController.text,
            );
        // Успех отзывает токены на сервере — приложение уже вышло само
        // (см. AuthNotifier.changePassword), редирект на /login случится
        // сам, показывать тут больше нечего.
        return;
      }

      await ref.read(authProvider.notifier).setPassword(_newController.text);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.passwordSetSuccess)));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, e)),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPassword = ref.watch(authProvider).user?.hasPassword ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          hasPassword ? context.l10n.passwordChangeTitle : context.l10n.passwordSetTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!hasPassword) ...[
                  Text(
                    context.l10n.passwordSetHint,
                    style: AppTypography.bodyMd
                        .copyWith(color: context.colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
                if (hasPassword) ...[
                  TextFormField(
                    controller: _currentController,
                    obscureText: _obscure,
                    autofocus: true,
                    enabled: !_isSubmitting,
                    decoration: InputDecoration(
                      labelText: context.l10n.passwordCurrentLabel,
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? context.l10n.passwordCurrentEmpty
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                TextFormField(
                  controller: _newController,
                  obscureText: _obscure,
                  autofocus: !hasPassword,
                  enabled: !_isSubmitting,
                  decoration: InputDecoration(
                    labelText: context.l10n.resetPasswordNewPasswordHint,
                    suffixIcon: IconButton(
                      tooltip: _obscure
                          ? context.l10n.commonPasswordShow
                          : context.l10n.commonPasswordHide,
                      icon: Icon(_obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (value) => (value == null || value.length < 8)
                      ? context.l10n.joinPasswordShort
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscure,
                  enabled: !_isSubmitting,
                  decoration: InputDecoration(
                    labelText: context.l10n.resetPasswordConfirmHint,
                  ),
                  onFieldSubmitted: (_) => _submit(hasPassword),
                  validator: (value) => value != _newController.text
                      ? context.l10n.resetPasswordConfirmMismatch
                      : null,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: _isSubmitting ? null : () => _submit(hasPassword),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.l10n.commonSave),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
