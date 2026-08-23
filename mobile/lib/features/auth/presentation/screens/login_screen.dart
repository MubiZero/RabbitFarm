import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      if (mounted) context.go('/');
    } catch (e) {
      if (!mounted) return;
      final message = e is DioException
          ? (e.message ?? 'Не удалось войти')
          : e.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final busy = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.xxl,
            ),
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: context.colors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child:
                            Icon(Icons.pets, size: 36, color: context.accent),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'RabbitFarm',
                      style: AppTypography.displayMd
                          .copyWith(color: context.colors.onSurface),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Вход в вашу ферму',
                      style: AppTypography.bodyMd
                          .copyWith(color: context.colors.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Кнопок «Войти через Google» и «Войти через Apple» здесь
                    // больше нет: они ничего не делали. Нерабочая кнопка на
                    // экране входа подрывает доверие ко всему остальному
                    // приложению сильнее, чем её отсутствие.
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      autocorrect: false,
                      enabled: !busy,
                      decoration: const InputDecoration(
                        labelText: 'Почта',
                        hintText: 'name@example.com',
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                      onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) return 'Введите почту';
                        if (!email.contains('@') || !email.contains('.')) {
                          return 'Похоже, в адресе опечатка';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      enabled: !busy,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Показать пароль'
                              : 'Скрыть пароль',
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      onFieldSubmitted: (_) => _handleLogin(),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Введите пароль'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      onPressed: busy ? null : _handleLogin,
                      child: busy
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Войти'),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Вступление по приглашению — основной путь для сотрудников:
                    // регистрация на ферме закрыта, аккаунт выдаёт владелец.
                    TextButton(
                      onPressed: busy ? null : () => context.go('/join'),
                      child: const Text('У меня есть код приглашения'),
                    ),
                    TextButton(
                      onPressed: busy ? null : () => context.go('/register'),
                      child: const Text('Завести свою ферму'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Забыли пароль? Его сбрасывает владелец фермы — '
                      'писем сервис не отправляет.',
                      textAlign: TextAlign.center,
                      style: AppTypography.labelSm
                          .copyWith(color: context.colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
