import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../../core/widgets/language_picker.dart';
import '../providers/auth_provider.dart';

/// Вход по телефону — основной способ для всех: и для владельца, и для
/// работника, приглашённого по номеру (его приглашение активирует тот же код
/// из SMS, отдельного экрана «код приглашения» ему не нужно).
///
/// Номер и код — два шага одного экрана, а не два маршрута: «изменить номер»
/// и обратный отсчёт живут рядом с полем кода, а промахнувшийся человек
/// возвращается к номеру, не теряя введённого. Вход по почте и паролю уехал
/// на отдельный запасной экран (`/login/password`).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const _resendCooldown = Duration(seconds: 60);

  final _phoneFormKey = GlobalKey<FormState>();
  final _codeFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  /// Номер, на который ушёл код, — уже нормализованный (`+992XXXXXXXXX`).
  /// Пусто ровно тогда, когда мы на шаге ввода номера.
  String? _phone;
  bool _requesting = false;
  Timer? _resendTimer;
  int _resendSeconds = 0;

  @override
  void dispose() {
    _resendTimer?.cancel();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = _resendCooldown.inSeconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      if (_resendSeconds <= 1) timer.cancel();
      setState(() => _resendSeconds = _resendSeconds - 1);
    });
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorText(context.l10n, error)),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Future<void> _requestCode() async {
    if (!(_phoneFormKey.currentState?.validate() ?? false)) return;

    final phone = normalizeTjPhone(_phoneController.text);
    setState(() => _requesting = true);
    try {
      await ref.read(authProvider.notifier).requestOtp(phone: phone);
      if (!mounted) return;
      setState(() => _phone = phone);
      _startResendCountdown();
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  Future<void> _resendCode() async {
    final phone = _phone;
    if (phone == null || _resendSeconds > 0) return;

    setState(() => _requesting = true);
    try {
      await ref.read(authProvider.notifier).requestOtp(phone: phone);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.loginCodeResent)),
      );
      _startResendCountdown();
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  Future<void> _submitCode() async {
    final phone = _phone;
    if (phone == null) return;
    if (!(_codeFormKey.currentState?.validate() ?? false)) return;

    try {
      await ref.read(authProvider.notifier).loginWithOtp(
            phone: phone,
            code: _codeController.text.trim(),
          );
      if (mounted) context.go('/');
    } catch (e) {
      // Код неверный или просрочен — поле очищается, чтобы следующую попытку
      // не пришлось начинать со стирания шести цифр.
      _codeController.clear();
      _showError(e);
    }
  }

  void _changePhone() {
    _resendTimer?.cancel();
    _codeController.clear();
    setState(() {
      _phone = null;
      _resendSeconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(authProvider).isLoading || _requesting;
    final onCodeStep = _phone != null;

    return PopScope(
      // На шаге кода системная кнопка «назад» возвращает к номеру, а не
      // выкидывает с экрана входа — выходить отсюда некуда.
      canPop: !onCodeStep,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && onCodeStep) _changePhone();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: const [LanguagePickerButton()],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.xxl,
              ),
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
                      child: Icon(Icons.pets, size: 36, color: context.accent),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    context.l10n.appName,
                    style: AppTypography.displayMd
                        .copyWith(color: context.colors.onSurface),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    onCodeStep
                        ? context.l10n.loginCodeSentTo(formatTjPhone(_phone!))
                        : context.l10n.loginPhoneIntro,
                    style: AppTypography.bodyMd
                        .copyWith(color: context.colors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  if (onCodeStep) _buildCodeStep(busy) else _buildPhoneStep(busy),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneStep(bool busy) {
    return Form(
      key: _phoneFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.telephoneNumber],
            enabled: !busy,
            decoration: InputDecoration(
              labelText: context.l10n.loginPhoneLabel,
              hintText: context.l10n.loginPhoneHint,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            onFieldSubmitted: (_) => _requestCode(),
            validator: (value) {
              final raw = value?.trim() ?? '';
              if (raw.isEmpty) return context.l10n.loginPhoneEmpty;
              if (!isTjPhone(normalizeTjPhone(raw))) {
                return context.l10n.loginPhoneInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: busy ? null : _requestCode,
            child: busy
                ? const _ButtonSpinner()
                : Text(context.l10n.loginRequestCode),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextButton(
            onPressed: busy ? null : () => context.go('/register'),
            child: Text(context.l10n.loginCreateFarm),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: busy ? null : () => context.push('/login/password'),
            child: Text(
              context.l10n.loginWithPassword,
              style: AppTypography.labelSm
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeStep(bool busy) {
    return Form(
      key: _codeFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _codeController,
            autofocus: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.oneTimeCode],
            enabled: !busy,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: AppTypography.displayMd.copyWith(
              color: context.colors.onSurface,
              letterSpacing: 6,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: context.l10n.loginCodeLabel,
              counterText: '',
            ),
            // Шесть цифр — это весь ввод: ждать отдельного нажатия «Войти»
            // после последней цифры незачем.
            onChanged: (value) {
              if (value.length == 6 && !busy) _submitCode();
            },
            onFieldSubmitted: (_) => _submitCode(),
            validator: (value) {
              final code = value?.trim() ?? '';
              if (code.isEmpty) return context.l10n.loginCodeEmpty;
              if (!RegExp(r'^\d{6}$').hasMatch(code)) {
                return context.l10n.loginCodeInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: busy ? null : _submitCode,
            child: busy
                ? const _ButtonSpinner()
                : Text(context.l10n.loginCodeSubmit),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextButton(
            onPressed: (busy || _resendSeconds > 0) ? null : _resendCode,
            child: Text(
              _resendSeconds > 0
                  ? context.l10n.loginCodeResendIn(_resendSeconds)
                  : context.l10n.loginCodeResend,
            ),
          ),
          TextButton(
            onPressed: busy ? null : _changePhone,
            child: Text(
              context.l10n.loginCodeChangePhone,
              style: AppTypography.labelSm
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtonSpinner extends StatelessWidget {
  const _ButtonSpinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
    );
  }
}
