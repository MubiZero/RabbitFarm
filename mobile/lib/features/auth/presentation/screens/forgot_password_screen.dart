import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../providers/auth_provider.dart';

/// Запрос кода сброса пароля. Сервер сам решает канал (SMS или email) и
/// никогда не говорит, существует ли аккаунт — сообщение об успехе одно
/// и то же в обоих случаях.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final router = GoRouter.of(context);
    final email = _emailController.text.trim();

    setState(() => _isSubmitting = true);
    try {
      await ref.read(authRepositoryProvider).forgotPassword(email: email);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.forgotPasswordSentMessage)),
      );
      router.push('/reset-password', extra: email);
    } catch (e) {
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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.forgotPasswordTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.forgotPasswordIntro,
                  style: AppTypography.bodyMd
                      .copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  controller: _emailController,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  enabled: !_isSubmitting,
                  decoration: InputDecoration(
                    labelText: context.l10n.loginEmailLabel,
                    hintText: context.l10n.forgotPasswordEmailHint,
                    prefixIcon: const Icon(Icons.alternate_email),
                  ),
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) return context.l10n.loginEmailEmpty;
                    if (!email.contains('@') || !email.contains('.')) {
                      return context.l10n.loginEmailInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.l10n.forgotPasswordSubmit),
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed:
                      _isSubmitting ? null : () => context.go('/login'),
                  child: Text(context.l10n.forgotPasswordBackToLogin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
