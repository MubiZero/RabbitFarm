import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/first_steps.dart';
import '../../data/onboarding_answers.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_choice_card.dart';
import '../widgets/onboarding_step.dart';

/// Знакомство при первом запуске.
///
/// Не карусель с обещаниями, которую пролистывают не читая, а короткий
/// разговор: один вопрос на экран, крупные ответы, видимый конец пути.
/// Человек отвечает три раза — и приходит к регистрации, уже вложив в это
/// приложение полминуты, а не получив анкету на пустом месте.
///
/// Ответы никуда не отправляются: фермы ещё нет. Они остаются на устройстве
/// и потом решают, какие первые шаги показать на «Сегодня».
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  static const _questionCount = 3;

  int _step = 0;
  OnboardingAnswers _answers = const OnboardingAnswers();

  bool get _onQuestion => _step >= 1 && _step <= _questionCount;

  void _goTo(int step) => setState(() => _step = step);

  Future<void> _leaveTo(String route) async {
    await ref.read(onboardingSeenProvider.notifier).markSeen();
    await ref.read(onboardingAnswersProvider.notifier).save(_answers);
    if (mounted) context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
          child: Column(
            children: [
              _TopBar(
                showBack: _step > 0,
                onBack: () => _goTo(_step - 1),
                progress: _onQuestion
                    ? OnboardingProgress(step: _step, total: _questionCount)
                    : null,
                skipLabel: _onQuestion ? l10n.onbSkip : null,
                onSkip: () => _goTo(_questionCount + 1),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration:
                      context.reduceMotion ? Duration.zero : AppDuration.fast,
                  switchInCurve: AppDuration.curve,
                  // Уход быстрее прихода: ушедший шаг догонять глазами уже не
                  // нужно, а задержка на нём читается как подтормаживание.
                  switchOutCurve: Curves.easeIn,
                  reverseDuration: context.reduceMotion
                      ? Duration.zero
                      : AppDuration.instant,
                  transitionBuilder: _slideIn,
                  child: KeyedSubtree(
                    key: ValueKey(_step),
                    child: _buildStep(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Новый шаг наезжает справа поверх уходящего.
  ///
  /// Своя подложка обязательна: без неё оба шага полсекунды просвечивают друг
  /// сквозь друга, и вместо перехода получается каша из наложенных заголовков.
  Widget _slideIn(Widget child, Animation<double> animation) {
    final entering = animation.status != AnimationStatus.reverse;

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(entering ? 0.08 : -0.08, 0),
          end: Offset.zero,
        ).animate(animation),
        child: ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: child,
        ),
      ),
    );
  }

  Widget _buildStep() => switch (_step) {
        0 => _Greeting(
            onStart: () => _goTo(1),
            onHaveAccount: () => _leaveTo('/login'),
          ),
        1 => _HerdQuestion(
            selected: _answers.herdSize,
            onSelect: (size) {
              setState(() => _answers = _answers.copyWith(herdSize: size));
              _goTo(2);
            },
          ),
        2 => _FocusQuestion(
            selected: _answers.focus,
            onToggle: (focus) => setState(() {
              final next = Set<FarmFocus>.from(_answers.focus);
              next.contains(focus) ? next.remove(focus) : next.add(focus);
              _answers = _answers.copyWith(focus: next);
            }),
            onNext: () => _goTo(3),
          ),
        3 => _CrewQuestion(
            selected: _answers.crew,
            onSelect: (crew) {
              setState(() => _answers = _answers.copyWith(crew: crew));
              _goTo(4);
            },
          ),
        _ => _Summary(answers: _answers, onCreate: () => _leaveTo('/register')),
      };
}

/// Шапка: возврат, полоска пути и выход из опроса.
///
/// Высота держится постоянной даже там, где полоски нет, — иначе заголовок
/// вопроса подпрыгивал бы на каждом переходе.
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.showBack,
    required this.onBack,
    required this.onSkip,
    this.progress,
    this.skipLabel,
  });

  final bool showBack;
  final VoidCallback onBack;
  final VoidCallback onSkip;
  final Widget? progress;
  final String? skipLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: showBack
                ? IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back),
                    tooltip: context.l10n.onbBack,
                  )
                : null,
          ),
          Expanded(
            child: progress == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: progress,
                  ),
          ),
          // Ширину диктует самое длинное слово из четырёх языков: узбекское
          // «Oʻtkazib yuborish» и русское «Пропустить» в 88 точек не влезали
          // и ломались посреди слова на две строки.
          if (skipLabel != null)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: TextButton(
                onPressed: onSkip,
                child: Text(
                  skipLabel!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.onStart, required this.onHaveAccount});

  final VoidCallback onStart;
  final VoidCallback onHaveAccount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        const Spacer(),
        const AppBrandMark(size: 112),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.onbWelcomeTitle,
          style: AppTypography.displayLg,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.onbWelcomeBody,
          style: AppTypography.bodyLg.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        FilledButton(onPressed: onStart, child: Text(l10n.onbWelcomeStart)),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: onHaveAccount,
          child: Text(l10n.onbWelcomeHaveAccount),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _HerdQuestion extends StatelessWidget {
  const _HerdQuestion({required this.selected, required this.onSelect});

  final HerdSize? selected;
  final ValueChanged<HerdSize> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final options = <(HerdSize, String, String)>[
      (HerdSize.upTo20, l10n.onbHerdUpTo20, l10n.onbHerdUpTo20Hint),
      (HerdSize.upTo100, l10n.onbHerdUpTo100, l10n.onbHerdUpTo100Hint),
      (HerdSize.upTo500, l10n.onbHerdUpTo500, l10n.onbHerdUpTo500Hint),
      (HerdSize.over500, l10n.onbHerdOver500, l10n.onbHerdOver500Hint),
    ];

    return OnboardingStep(
      title: l10n.onbHerdTitle,
      subtitle: l10n.onbHerdSubtitle,
      children: [
        for (final (size, label, hint) in options) ...[
          OnboardingChoiceCard(
            label: label,
            description: hint,
            selected: selected == size,
            onTap: () => onSelect(size),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _FocusQuestion extends StatelessWidget {
  const _FocusQuestion({
    required this.selected,
    required this.onToggle,
    required this.onNext,
  });

  final Set<FarmFocus> selected;
  final ValueChanged<FarmFocus> onToggle;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final options = <(FarmFocus, String, IconData)>[
      (FarmFocus.breeding, l10n.onbFocusBreeding, Icons.favorite_outline),
      (FarmFocus.feeding, l10n.onbFocusFeeding, Icons.restaurant_outlined),
      (FarmFocus.health, l10n.onbFocusHealth, Icons.vaccines_outlined),
      (FarmFocus.money, l10n.onbFocusMoney, Icons.payments_outlined),
    ];

    return OnboardingStep(
      title: l10n.onbFocusTitle,
      subtitle: l10n.onbFocusSubtitle,
      footer: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: FilledButton(
          // Кнопка живая и без единой галочки: опрос не экзамен, и запирать
          // человека на вопросе, пока он не выберет «правильное», незачем.
          onPressed: onNext,
          child: Text(l10n.onbFocusNext),
        ),
      ),
      children: [
        for (final (focus, label, icon) in options) ...[
          OnboardingChoiceCard(
            label: label,
            icon: icon,
            selected: selected.contains(focus),
            onTap: () => onToggle(focus),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _CrewQuestion extends StatelessWidget {
  const _CrewQuestion({required this.selected, required this.onSelect});

  final FarmCrew? selected;
  final ValueChanged<FarmCrew> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final options = <(FarmCrew, String, String)>[
      (FarmCrew.alone, l10n.onbCrewAlone, l10n.onbCrewAloneHint),
      (FarmCrew.withHelpers, l10n.onbCrewHelpers, l10n.onbCrewHelpersHint),
    ];

    return OnboardingStep(
      title: l10n.onbCrewTitle,
      subtitle: l10n.onbCrewSubtitle,
      children: [
        for (final (crew, label, hint) in options) ...[
          OnboardingChoiceCard(
            label: label,
            description: hint,
            selected: selected == crew,
            onTap: () => onSelect(crew),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

/// Итог знакомства: что человек ответил, с того и начнём.
///
/// Единственная задача экрана — показать, что ответы не ушли в пустоту.
/// Поэтому здесь и эхо самих ответов, и пронумерованный план, который потом
/// слово в слово встретит человека на «Сегодня».
///
/// Шаги помечены номерами, а не галочками: галочка означала бы сделанное, а
/// это ещё только предстоит.
class _Summary extends StatelessWidget {
  const _Summary({required this.answers, required this.onCreate});

  final OnboardingAnswers answers;
  final VoidCallback onCreate;

  /// Ответы человека его же словами — теми самыми, что он выбирал на
  /// предыдущих экранах.
  List<String> _echo(BuildContext context) {
    final l10n = context.l10n;
    return [
      if (answers.herdSize != null)
        switch (answers.herdSize!) {
          HerdSize.upTo20 => l10n.onbHerdUpTo20,
          HerdSize.upTo100 => l10n.onbHerdUpTo100,
          HerdSize.upTo500 => l10n.onbHerdUpTo500,
          HerdSize.over500 => l10n.onbHerdOver500,
        },
      if (answers.crew != null)
        switch (answers.crew!) {
          FarmCrew.alone => l10n.onbCrewAlone,
          FarmCrew.withHelpers => l10n.onbCrewHelpers,
        },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final steps = onboardingFirstSteps(answers);
    final echo = _echo(context);

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - AppSpacing.lg * 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: const AppBrandMark(size: 72)),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.onbDoneTitle,
                      style: AppTypography.displayMd,
                      textAlign: TextAlign.center,
                    ),
                    if (echo.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          for (final text in echo) _EchoChip(text: text),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    _StepsCard(steps: steps),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.onbDoneSubtitle,
                      style: AppTypography.bodyMd.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(onPressed: onCreate, child: Text(l10n.onbDoneCreate)),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

/// Ответ человека, возвращённый ему же: «От 100 до 500», «Я и помощники».
class _EchoChip extends StatelessWidget {
  const _EchoChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        text,
        style: AppTypography.labelLg.copyWith(color: colors.onSurface),
      ),
    );
  }
}

/// План первых шагов одним блоком.
///
/// Номера и разделители вместо четырёх одинаковых строк: так видно, что это
/// последовательность, а не список настроек, и где она кончается.
class _StepsCard extends StatelessWidget {
  const _StepsCard({required this.steps});

  final List<FirstStep> steps;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        children: [
          for (final (index, step) in steps.indexed) ...[
            if (index > 0)
              Divider(height: 1, thickness: 1, color: colors.outline),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: Row(
                children: [
                  _StepNumber(number: index + 1),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Text(
                      step.label(context),
                      style: AppTypography.bodyLg,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Icon(step.icon, size: 20, color: colors.onSurfaceVariant),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepNumber extends StatelessWidget {
  const _StepNumber({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: AppTypography.labelLg.copyWith(color: colors.primary),
      ),
    );
  }
}
