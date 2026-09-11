import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/phone_utils.dart';
import '../providers/auth_provider.dart';
import '../../../../core/api/api_error.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/language_picker.dart';
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
  final _contactController = TextEditingController();
  /// Телефон основной, почта запасная — те же два способа, что и на входе.
  bool _byPhone = true;
  bool _acceptedPrivacy = false;
  late final TapGestureRecognizer _privacyLinkRecognizer;

  @override
  void initState() {
    super.initState();
    _privacyLinkRecognizer = TapGestureRecognizer()
      ..onTap = () => launchUrl(
            Uri.parse('https://rabbitfarm.mubi.dev/privacy.html'),
            mode: LaunchMode.externalApplication,
          );
  }

  @override
  void dispose() {
    _privacyLinkRecognizer.dispose();
    _farmNameController.dispose();
    _fullNameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final l10n = context.l10n;
    if (!_acceptedPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.registerConsentRequired),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      final contact = _byPhone
          ? normalizeTjPhone(_contactController.text)
          : _contactController.text.trim().toLowerCase();
      try {
        await ref.read(authProvider.notifier).register(
              fullName: _fullNameController.text.trim(),
              phone: _byPhone ? contact : null,
              email: _byPhone ? null : contact,
              farmName: _farmNameController.text.trim().isNotEmpty
                  ? _farmNameController.text.trim()
                  : null,
            );

        // Сессия ещё не открыта: регистрация только отправила код. Экран
        // входа открывается сразу на шаге кода — второй раз слать SMS
        // незачем.
        if (mounted) {
          context.go(Uri(
            path: '/login',
            queryParameters: {
              if (_byPhone) 'phone': contact else 'email': contact,
              'code_sent': '1',
            },
          ).toString());
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
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
        actions: const [LanguagePickerButton()],
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
                // Privacy policy consent
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _acceptedPrivacy,
                      onChanged: (value) =>
                          setState(() => _acceptedPrivacy = value ?? false),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: RichText(
                          text: TextSpan(
                            style: AppTypography.bodyMd
                                .copyWith(color: context.colors.onSurface),
                            children: [
                              TextSpan(text: context.l10n.registerConsentPrefix),
                              TextSpan(
                                text: context.l10n.registerConsentLink,
                                recognizer: _privacyLinkRecognizer,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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

                // Контакт: на него придёт код для входа — пароля в сервисе
                // нет, и другого способа попасть в аккаунт тоже.
                SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(
                      value: true,
                      icon: const Icon(Icons.phone_outlined, size: 18),
                      label: Text(context.l10n.loginByPhone),
                    ),
                    ButtonSegment(
                      value: false,
                      icon: const Icon(Icons.alternate_email, size: 18),
                      label: Text(context.l10n.loginByEmail),
                    ),
                  ],
                  selected: {_byPhone},
                  onSelectionChanged: (value) => setState(() {
                    _byPhone = value.first;
                    _contactController.clear();
                  }),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  keyboardType:
                      _byPhone ? TextInputType.phone : TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: _byPhone
                        ? context.l10n.loginPhoneLabel
                        : context.l10n.loginEmailLabel,
                    hintText: _byPhone
                        ? context.l10n.loginPhoneHint
                        : context.l10n.loginEmailHint,
                    prefixIcon: Icon(
                      _byPhone ? Icons.phone_outlined : Icons.alternate_email,
                    ),
                    helperText: context.l10n.registerContactHelper,
                    helperMaxLines: 2,
                  ),
                  validator: (value) {
                    final raw = value?.trim() ?? '';
                    if (_byPhone) {
                      if (raw.isEmpty) return context.l10n.loginPhoneEmpty;
                      if (!isTjPhone(normalizeTjPhone(raw))) {
                        return context.l10n.loginPhoneInvalid;
                      }
                    } else {
                      if (raw.isEmpty) return context.l10n.registerEmailEmpty;
                      if (!raw.contains('@') || !raw.contains('.')) {
                        return context.l10n.registerEmailInvalid;
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const SizedBox(height: 24),

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
