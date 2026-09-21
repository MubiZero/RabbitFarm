import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/onboarding/data/onboarding_answers.dart';
import 'package:mobile/features/subscription/data/models/plan_option.dart';
import 'package:mobile/features/subscription/data/plan_match.dart';

/// Владелец хозяйства спрашивает про деньги первым, а узнавал последним —
/// уже заведя ферму и записав триста кроликов. Тариф подбирается по тем же
/// ответам, что человек дал в знакомстве, и второй раз спрашивать «сколько у
/// вас кроликов» на экране с ценами незачем.
void main() {
  const free = PlanOption(id: 1, name: 'Бесплатный', maxRabbits: 20, maxStaff: 1, price: 0);
  const small = PlanOption(id: 2, name: 'Малый', maxRabbits: 120, maxStaff: 2, price: 45);
  const medium = PlanOption(id: 3, name: 'Средний', maxRabbits: 600, maxStaff: 5, price: 120);
  const big = PlanOption(id: 4, name: 'Большой', price: 250);
  const plans = [free, small, medium, big];

  OnboardingAnswers answers({HerdSize? herd, FarmCrew? crew}) =>
      OnboardingAnswers(herdSize: herd, crew: crew);

  test('до двадцати кроликов — бесплатный, и это правда', () {
    final plan = recommendedPlan(plans, answers(herd: HerdSize.upTo20));

    expect(plan?.name, 'Бесплатный');
    expect(plan!.maxRabbits, greaterThanOrEqualTo(20),
        reason: 'обещать бесплатный тариф, в который не влезает ответ, нельзя');
  });

  test('сотня кроликов уже не помещается в бесплатный', () {
    expect(recommendedPlan(plans, answers(herd: HerdSize.upTo100))?.name, 'Малый');
  });

  test('берём по верхней границе ответа, а не по нижней', () {
    // «От 100 до 500» — это пятьсот: тариф, который лопнет через месяц, это
    // обещание, которого мы не сдержим.
    expect(recommendedPlan(plans, answers(herd: HerdSize.upTo500))?.name, 'Средний');
  });

  test('больше пятисот — тариф без ограничения', () {
    expect(recommendedPlan(plans, answers(herd: HerdSize.over500))?.name, 'Большой');
  });

  test('команда считается наравне с кроликами', () {
    // Двадцать кроликов помещаются в бесплатный, а вот впятером в нём не
    // поработать: у него один человек.
    final plan = recommendedPlan(
      plans,
      answers(herd: HerdSize.upTo20, crew: FarmCrew.team),
    );

    expect(plan?.name, 'Средний',
        reason: 'нужен тариф, где помещаются и кролики, и пятеро работников');
  });

  test('вдвоём хватает малого, а не среднего', () {
    expect(
      recommendedPlan(plans, answers(herd: HerdSize.upTo20, crew: FarmCrew.pair))
          ?.name,
      'Малый',
      reason: 'у бесплатного один человек, у малого — двое',
    );
  });

  test('«больше пяти» — это тариф без предела по работникам', () {
    expect(
      recommendedPlan(plans, answers(herd: HerdSize.upTo20, crew: FarmCrew.big))
          ?.name,
      'Большой',
    );
  });

  test('без ответа про стадо предлагаем самый маленький подходящий', () {
    expect(recommendedPlan(plans, const OnboardingAnswers())?.name, 'Бесплатный');
  });

  test('пустой список тарифов ничего не выдумывает', () {
    expect(recommendedPlan(const [], answers(herd: HerdSize.upTo100)), isNull);
  });

  test('когда не подходит ни один, предлагаем самый большой', () {
    const tiny = [PlanOption(id: 9, name: 'Крошечный', maxRabbits: 5, maxStaff: 1, price: 10)];

    expect(recommendedPlan(tiny, answers(herd: HerdSize.over500))?.name, 'Крошечный');
  });
}
