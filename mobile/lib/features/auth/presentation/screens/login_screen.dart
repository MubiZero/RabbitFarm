import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/deep_links.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../../core/widgets/app_brand_mark.dart';
import '../../../../core/widgets/language_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/pin_provider.dart';

/// Вход по коду — единственный способ попасть в аккаунт: телефон основной
/// путь, почта запасной, оба ведут к одному и тому же шагу кода. Приглашение
/// сотрудника активируется тем же кодом, отдельного экрана «код приглашения»
/// нет.
///
/// Контакт и код — два шага одного экрана, а не два маршрута: «изменить
/// номер» и обратный отсчёт живут рядом с полем кода, а промахнувшийся
/// человек возвращается к контакту, не теряя введённого.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
    this.initialPhone,
    this.initialEmail,
    this.codeAlreadySent = false,
  });

  /// Номер из ссылки-приглашения (`rabbitfarm://join?phone=…`), если она
  /// пришла маршрутом. Подставляется в поле, но код сам не запрашивается:
  /// SMS уходит по осознанному нажатию, а не потому что открыли ссылку.
  final String? initialPhone;

  /// Почта, с которой пришли сюда после регистрации по почте.
  final String? initialEmail;

  /// Экран открывается сразу на шаге кода: код уже отправлен — так сюда
  /// приходит только что зарегистрировавшийся владелец фермы, которому
  /// второй раз слать SMS незачем.
  final bool codeAlreadySent;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const _resendCooldown = Duration(seconds: 60);

  final _contactFormKey = GlobalKey<FormState>();
  final _codeFormKey = GlobalKey<FormState>();
  final _contactController = TextEditingController();
  final _codeController = TextEditingController();

  /// Телефон — основной способ входа, почта — запасной. Ведут себя
  /// одинаково: контакт, код, вход.
  bool _byPhone = true;

  /// Контакт, на который ушёл код, — уже приведённый к тому виду, в котором
  /// его ждёт сервер. Пусто ровно тогда, когда мы на шаге ввода контакта.
  String? _sentTo;
  bool _requesting = false;
  Timer? _resendTimer;
  int _resendSeconds = 0;

  @override
  void initState() {
    super.initState();
    // Ссылка, открывшая приложение из закрытого состояния, приходит раньше
    // роутера — номер из неё ждёт здесь (см. `deep_links.dart`).
    final phone = widget.initialPhone ?? takePendingInvitePhone();
    final email = widget.initialEmail;

    if (email != null && email.isNotEmpty) {
      _byPhone = false;
      _contactController.text = email;
    } else if (phone != null && phone.isNotEmpty) {
      _contactController.text = formatTjPhone(normalizeTjPhone(phone));
    }

    if (widget.codeAlreadySent) {
      _sentTo = _normalizedContact();
      _startResendCountdown();
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _contactController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  /// Контакт в том виде, в котором его ждёт сервер: телефон — `+992…`,
  /// почта — без регистра и пробелов по краям.
  String _normalizedContact() => _byPhone
      ? normalizeTjPhone(_contactController.text)
      : _contactController.text.trim().toLowerCase();

  /// Аргументы запроса: ровно одно из полей, в зависимости от способа входа.
  ({String? phone, String? email}) _contactArgs(String contact) =>
      _byPhone ? (phone: contact, email: null) : (phone: null, email: contact);

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
    if (!(_contactFormKey.currentState?.validate() ?? false)) return;

    final contact = _normalizedContact();
    final args = _contactArgs(contact);
    setState(() => _requesting = true);
    try {
      await ref
          .read(authProvider.notifier)
          .requestOtp(phone: args.phone, email: args.email);
      if (!mounted) return;
      setState(() => _sentTo = contact);
      _startResendCountdown();
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  Future<void> _resendCode() async {
    final contact = _sentTo;
    if (contact == null || _resendSeconds > 0) return;

    final args = _contactArgs(contact);
    setState(() => _requesting = true);
    try {
      await ref
          .read(authProvider.notifier)
          .requestOtp(phone: args.phone, email: args.email);
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
    final contact = _sentTo;
    if (contact == null) return;
    if (!(_codeFormKey.currentState?.validate() ?? false)) return;

    final args = _contactArgs(contact);
    try {
      await ref.read(authProvider.notifier).loginWithOtp(
            phone: args.phone,
            email: args.email,
            code: _codeController.text.trim(),
          );
      // Вошли — предлагаем закрыть приложение коротким кодом, чтобы в
      // следующий раз не ждать SMS. Один раз: отказ запоминается.
      final offerPin = await ref.read(pinProvider.notifier).shouldOfferSetup();
      if (mounted) context.go(offerPin ? '/pin/setup' : '/');
    } catch (e) {
      // Код неверный или просрочен — поле очищается, чтобы следующую попытку
      // не пришлось начинать со стирания шести цифр.
      _codeController.clear();
      _showError(e);
    }
  }

  void _changeContact() {
    _resendTimer?.cancel();
    _codeController.clear();
    setState(() {
      _sentTo = null;
      _resendSeconds = 0;
    });
  }

  /// Переключение «телефон ↔ почта» на шаге ввода контакта: поле очищается —
  /// номер в поле почты и наоборот всё равно не подойдут.
  void _switchContactKind(bool byPhone) {
    if (byPhone == _byPhone) return;
    setState(() {
      _byPhone = byPhone;
      _contactController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(authProvider).isLoading || _requesting;
    final onCodeStep = _sentTo != null;

    return PopScope(
      // На шаге кода системная кнопка «назад» возвращает к номеру, а не
      // выкидывает с экрана входа — выходить отсюда некуда.
      canPop: !onCodeStep,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && onCodeStep) _changeContact();
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
                  // Фирменный знак, а не `Icons.pets`: тот же значок стоит в
                  // списках кроликов, и «логотип» приложения ничем не
                  // отличался бы от значка одной записи.
                  const Center(child: AppBrandMark(size: 72)),
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
                        ? context.l10n.loginCodeSentTo(
                            _byPhone ? formatTjPhone(_sentTo!) : _sentTo!)
                        : (_byPhone
                            ? context.l10n.loginPhoneIntro
                            : context.l10n.loginEmailIntro),
                    style: AppTypography.bodyMd
                        .copyWith(color: context.colors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  if (onCodeStep)
                    _buildCodeStep(busy)
                  else
                    _buildContactStep(busy),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactStep(bool busy) {
    return Form(
      key: _contactFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Телефон первым: код в SMS доходит и без интернета на телефоне,
          // почта нужна тем, у кого номер не таджикский или SMS не приходят.
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
            onSelectionChanged:
                busy ? null : (value) => _switchContactKind(value.first),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: _contactController,
            keyboardType:
                _byPhone ? TextInputType.phone : TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            autofillHints: [
              _byPhone ? AutofillHints.telephoneNumber : AutofillHints.email
            ],
            enabled: !busy,
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
            ),
            onFieldSubmitted: (_) => _requestCode(),
            validator: (value) {
              final raw = value?.trim() ?? '';
              if (_byPhone) {
                if (raw.isEmpty) return context.l10n.loginPhoneEmpty;
                if (!isTjPhone(normalizeTjPhone(raw))) {
                  return context.l10n.loginPhoneInvalid;
                }
              } else {
                if (raw.isEmpty) return context.l10n.loginEmailEmpty;
                if (!raw.contains('@') || !raw.contains('.')) {
                  return context.l10n.loginEmailInvalid;
                }
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
            onPressed: busy ? null : _changeContact,
            child: Text(
              _byPhone
                  ? context.l10n.loginCodeChangePhone
                  : context.l10n.loginCodeChangeEmail,
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
