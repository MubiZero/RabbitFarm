import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../../core/widgets/app_brand_mark.dart';
import '../../../../core/widgets/language_picker.dart';
import '../providers/auth_provider.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/l10n/error_text.dart';

enum _LoginStep { phone, code }

/// Основной вход — телефон и код из SMS. Активирует и обычный вход, и
/// приглашение сотрудника по телефону: сервер сам решает, завести ли новый
/// аккаунт по приглашению или впустить в уже существующий (см.
/// `otpAuthService.verifyOtp`).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.prefilledPhone});

  /// Номер из диплинка приглашения (`rabbitfarm://join?phone=...`) —
  /// подставляется в поле, запрос кода всё равно инициирует сам человек.
  final String? prefilledPhone;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const _resendCooldown = 60;

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  _LoginStep _step = _LoginStep.phone;
  String _normalizedPhone = '';
  Timer? _resendTimer;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledPhone != null) {
      _phoneController.text = widget.prefilledPhone!;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _secondsLeft = _resendCooldown);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  Future<void> _requestCode() async {
    if (_step == _LoginStep.phone && !_formKey.currentState!.validate()) {
      return;
    }

    final l10n = context.l10n;
    _normalizedPhone = normalizeTjPhone(_phoneController.text);

    try {
      await ref.read(authProvider.notifier).requestOtp(_normalizedPhone);
      if (!mounted) return;
      setState(() => _step = _LoginStep.code);
      _startResendTimer();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _verifyCode(String code) async {
    final l10n = context.l10n;

    try {
      await ref.read(authProvider.notifier).verifyOtp(
            phone: _normalizedPhone,
            code: code,
          );
      if (mounted) context.go('/');
    } catch (e) {
      if (!mounted) return;
      _codeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _changeNumber() {
    _resendTimer?.cancel();
    _codeController.clear();
    setState(() {
      _step = _LoginStep.phone;
      _secondsLeft = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final busy = authState.isLoading;

    return Scaffold(
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
                const Center(child: AppBrandMark()),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  context.l10n.appName,
                  style: AppTypography.displayMd
                      .copyWith(color: context.colors.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.loginSubtitle,
                  style: AppTypography.bodyMd
                      .copyWith(color: context.colors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                if (_step == _LoginStep.phone)
                  _PhoneStep(
                    formKey: _formKey,
                    controller: _phoneController,
                    busy: busy,
                    onSubmit: _requestCode,
                  )
                else
                  _CodeStep(
                    phone: _normalizedPhone,
                    codeController: _codeController,
                    busy: busy,
                    secondsLeft: _secondsLeft,
                    onCompleted: _verifyCode,
                    onResend: _requestCode,
                    onChangeNumber: _changeNumber,
                  ),
                const SizedBox(height: AppSpacing.lg),
                TextButton(
                  onPressed:
                      busy ? null : () => context.go('/login-password'),
                  child: Text(context.l10n.loginUsePassword),
                ),
                TextButton(
                  onPressed: busy ? null : () => context.go('/register'),
                  child: Text(context.l10n.loginCreateFarm),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneStep extends StatelessWidget {
  const _PhoneStep({
    required this.formKey,
    required this.controller,
    required this.busy,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool busy;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.telephoneNumber],
            enabled: !busy,
            inputFormatters: [TjPhoneInputFormatter()],
            decoration: InputDecoration(
              labelText: context.l10n.commonPhone,
              hintText: context.l10n.loginPhoneHint,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            onFieldSubmitted: (_) => onSubmit(),
            validator: (value) {
              final phone = normalizeTjPhone(value ?? '');
              if ((value ?? '').trim().isEmpty) {
                return context.l10n.loginPhoneEmpty;
              }
              if (!isTjPhone(phone)) return context.l10n.loginPhoneInvalid;
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: busy ? null : onSubmit,
            child: busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(context.l10n.loginRequestCode),
          ),
        ],
      ),
    );
  }
}

class _CodeStep extends StatelessWidget {
  const _CodeStep({
    required this.phone,
    required this.codeController,
    required this.busy,
    required this.secondsLeft,
    required this.onCompleted,
    required this.onResend,
    required this.onChangeNumber,
  });

  final String phone;
  final TextEditingController codeController;
  final bool busy;
  final int secondsLeft;
  final ValueChanged<String> onCompleted;
  final VoidCallback onResend;
  final VoidCallback onChangeNumber;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: AppTypography.titleMd.copyWith(color: cs.onSurface),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: cs.outline),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.loginOtpTitle,
          style: AppTypography.titleMd.copyWith(color: cs.onSurface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          context.l10n.loginOtpSentTo(phone),
          style: AppTypography.bodyMd.copyWith(color: cs.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Pinput(
            length: 6,
            controller: codeController,
            enabled: !busy,
            autofocus: true,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: cs.primary, width: 2),
              ),
            ),
            onCompleted: onCompleted,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: TextButton(
            onPressed: (busy || secondsLeft > 0) ? null : onResend,
            child: Text(
              secondsLeft > 0
                  ? context.l10n.loginOtpResendIn(secondsLeft)
                  : context.l10n.loginOtpResend,
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: busy ? null : onChangeNumber,
            child: Text(context.l10n.loginOtpChangeNumber),
          ),
        ),
      ],
    );
  }
}
