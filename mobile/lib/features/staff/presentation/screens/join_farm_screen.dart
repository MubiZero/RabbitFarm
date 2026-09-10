import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/l10n/error_text.dart';

/// Вступление в ферму по коду приглашения.
///
/// Почты у сервиса нет: код человеку передаёт владелец, поэтому экран
/// начинается с поля кода, а не с «проверьте почту».
class JoinFarmScreen extends ConsumerStatefulWidget {
  const JoinFarmScreen({super.key});

  @override
  ConsumerState<JoinFarmScreen> createState() => _JoinFarmScreenState();
}

class _JoinFarmScreenState extends ConsumerState<JoinFarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final router = GoRouter.of(context);

    setState(() => _isSubmitting = true);
    try {
      await ref.read(authProvider.notifier).acceptInvitation(
            code: _codeController.text.trim(),
            password: _passwordController.text,
            fullName: _nameController.text.trim(),
          );
      router.go('/');
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
      appBar: AppBar(title: Text(context.l10n.joinTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.joinIntro,
                  style: AppTypography.bodyMd
                      .copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _codeController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.joinCode,
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? context.l10n.joinCodeHint
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration:
                      InputDecoration(labelText: context.l10n.joinName),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? context.l10n.joinNameHint
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: context.l10n.joinPassword,
                    helperText: context.l10n.joinPasswordHint,
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword
                          ? context.l10n.commonPasswordShow
                          : context.l10n.commonPasswordHide,
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) => (value == null || value.length < 8)
                      ? context.l10n.joinPasswordShort
                      : null,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.l10n.joinSubmit),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed:
                      _isSubmitting ? null : () => context.go('/login'),
                  child: Text(context.l10n.joinHaveAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
