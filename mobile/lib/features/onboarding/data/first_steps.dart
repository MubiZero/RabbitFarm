import 'package:flutter/material.dart';

import '../../../core/l10n/l10n_context.dart';
import 'onboarding_answers.dart';

/// Первый шаг на новой ферме.
///
/// Один список на два места: итог знакомства обещает эти шаги, чек-лист на
/// «Сегодня» их же и показывает. Разойдись они — и человек получил бы одно
/// обещание до регистрации и другое после.
enum FirstStep {
  cages('/cages/form', Icons.grid_view_outlined),
  rabbits('/rabbits/new', Icons.pets_outlined),
  breeding('/breeding/new', Icons.favorite_outline),
  feeding('/feeding-records/form', Icons.restaurant_outlined),
  health('/vaccinations/form', Icons.vaccines_outlined),
  money('/transactions/form', Icons.payments_outlined),
  helpers('/staff', Icons.group_outlined);

  const FirstStep(this.route, this.icon);

  final String route;

  /// Значок шага — тот же, которым это дело помечено в быстром вводе и в
  /// разделах: узнаваемость важнее разнообразия.
  final IconData icon;

  String label(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      FirstStep.cages => l10n.firstStepCages,
      FirstStep.rabbits => l10n.firstStepRabbits,
      FirstStep.breeding => l10n.firstStepBreeding,
      FirstStep.feeding => l10n.firstStepFeeding,
      FirstStep.health => l10n.firstStepHealth,
      FirstStep.money => l10n.firstStepMoney,
      FirstStep.helpers => l10n.firstStepHelpers,
    };
  }
}

/// Сколько шагов показываем. Четыре — предел, после которого список
/// перестаёт читаться как «начну прямо сейчас» и превращается в план работ.
const _maxSteps = 4;

/// Первые шаги под ответы знакомства.
///
/// Клетки и кролики стоят всегда и первыми: без них в приложении нечего
/// записывать, чем бы человек ни собирался заниматься. Дальше идёт то, что
/// он сам назвал важным.
List<FirstStep> onboardingFirstSteps(OnboardingAnswers answers) {
  final steps = <FirstStep>[FirstStep.cages, FirstStep.rabbits];

  // Порядок перечисления в enum, а не порядок нажатий: очерёдность галочек
  // на экране случайна и не говорит о важности.
  const byFocus = {
    FarmFocus.breeding: FirstStep.breeding,
    FarmFocus.feeding: FirstStep.feeding,
    FarmFocus.health: FirstStep.health,
    FarmFocus.money: FirstStep.money,
  };
  for (final focus in FarmFocus.values) {
    if (answers.focus.contains(focus)) steps.add(byFocus[focus]!);
  }

  if (answers.needsHelpers) steps.add(FirstStep.helpers);

  // Ничего не выбрано — кормление как самое частое ежедневное дело: пустой
  // список из двух пунктов выглядит недоделанным.
  if (steps.length == 2) steps.add(FirstStep.feeding);

  return steps.take(_maxSteps).toList();
}
