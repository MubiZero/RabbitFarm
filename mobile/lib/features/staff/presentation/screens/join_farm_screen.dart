import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

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
          content: Text(e.toString().replaceAll('Exception: ', '')),
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
      appBar: AppBar(title: const Text('Присоединиться к ферме')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Код выдаёт владелец фермы. После входа вы увидите её '
                  'хозяйство — поголовье, корма и задачи.',
                  style: AppTypography.bodyMd
                      .copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _codeController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Код приглашения',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Введите код, который передал владелец'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Ваше имя'),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Как к вам обращаться?'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    helperText: 'Не короче 8 символов',
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) => (value == null || value.length < 8)
                      ? 'Пароль должен быть не короче 8 символов'
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
                      : const Text('Присоединиться'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed:
                      _isSubmitting ? null : () => context.go('/login'),
                  child: const Text('У меня уже есть аккаунт'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
