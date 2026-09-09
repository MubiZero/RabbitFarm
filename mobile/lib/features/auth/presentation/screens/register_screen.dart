import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../providers/auth_provider.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';
import '../../../../core/api/api_error.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/l10n/error_text.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _farmNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Название фермы уже спросили в онбординге и показали «... готова к
    // работе!». Пустое поле здесь означало бы, что бэкенд заведёт ферму под
    // дефолтным «Ферма {имя}» — не тем названием, которое человек только что
    // видел. Через `.future`, а не `.value`: если экран открыт до того, как
    // провайдер дочитал SharedPreferences, значение всё равно доедет.
    ref.read(onboardingProvider.future).then((onboarding) {
      if (!mounted || _farmNameController.text.isNotEmpty) return;
      _farmNameController.text = onboarding.farmName.trim();
    });
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final l10n = context.l10n;
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authProvider.notifier).register(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              fullName: _fullNameController.text.trim(),
              farmName: _farmNameController.text.trim().isNotEmpty
                  ? _farmNameController.text.trim()
                  : null,
              phone: _phoneController.text.trim().isNotEmpty
                  ? _phoneController.text.trim()
                  : null,
            );

        if (mounted) {
          context.go('/');
        }
      } catch (e) {
        if (mounted) {
          String message = errorText(l10n, e);
          bool userExists = false;

          if (e is DioException) {
            message = serverMessage(e) ?? e.message ?? context.l10n.registerFailed;
            userExists = serverErrorCode(e) == 'USER_EXISTS';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
              duration: Duration(seconds: userExists ? 6 : 4),
              action: userExists
                  ? SnackBarAction(
                      label: context.l10n.loginSubmit,
                      textColor: Colors.white,
                      onPressed: () => context.go('/login'),
                    )
                  : null,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.registerTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon
                Icon(
                  Icons.person_add,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  context.l10n.registerTitle,
                  style: AppTypography.displayMd
                      .copyWith(color: context.colors.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.registerSubtitle,
                  style: AppTypography.bodyMd
                      .copyWith(color: context.colors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Farm name field (optional)
                TextFormField(
                  controller: _farmNameController,
                  decoration: InputDecoration(
                    labelText: context.l10n.registerFarmName,
                    hintText: context.l10n.registerFarmNameHint,
                    prefixIcon: const Icon(Icons.home_work_outlined),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 2) {
                      return context.l10n.registerFarmNameShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Full name field
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: context.l10n.registerFullName,
                    hintText: context.l10n.registerFullNameHint,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.registerFullNameEmpty;
                    }
                    if (value.length < 3) {
                      return context.l10n.registerFullNameShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: context.l10n.loginEmailLabel,
                    hintText: context.l10n.loginEmailHint,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.registerEmailEmpty;
                    }
                    if (!value.contains('@')) {
                      return context.l10n.registerEmailInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone field (optional)
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: context.l10n.registerPhone,
                    hintText: '+7 (XXX) XXX-XX-XX',
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: context.l10n.loginPasswordLabel,
                    hintText: context.l10n.registerPasswordHint,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.registerPasswordEmpty;
                    }
                    if (value.length < 8) {
                      return context.l10n.registerPasswordShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm password field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: context.l10n.registerPasswordRepeat,
                    hintText: context.l10n.registerPasswordRepeatEmpty,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.registerPasswordRepeatEmpty;
                    }
                    if (value != _passwordController.text) {
                      return context.l10n.registerPasswordMismatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Register button
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleRegister,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(context.l10n.registerSubmit),
                ),
                const SizedBox(height: 16),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${context.l10n.registerHaveAccount} '),
                    TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () => context.go('/login'),
                      child: Text(context.l10n.loginSubmit),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
