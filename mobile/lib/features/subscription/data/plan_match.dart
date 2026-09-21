import '../../onboarding/data/onboarding_answers.dart';
import 'models/plan_option.dart';

/// Подбор тарифа по ответам знакомства.
///
/// Человек уже сказал, сколько у него кроликов и работает ли он один, —
/// спрашивать то же самое второй раз на экране с ценами незачем. Хозяйству
/// до двадцати кроликов хватает бесплатного, и это не маркетинговая уловка:
/// бесплатный тариф ровно такой.
///
/// Считаем по верхней границе ответа: человек, сказавший «от 100 до 500»,
/// завтра может быть на пятистах, и тариф, который лопнет через месяц, —
/// это обещание, которое мы не сдержим.
int? rabbitsWanted(HerdSize? size) => switch (size) {
      HerdSize.upTo20 => 20,
      HerdSize.upTo100 => 100,
      HerdSize.upTo500 => 500,
      // «Больше пятисот» — это без ограничения: любое число, которое мы бы
      // здесь назвали, было бы выдумкой.
      HerdSize.over500 => null,
      // Человек пропустил вопрос — это не «сколько угодно», а «неизвестно»,
      // и предлагать ему самый дорогой тариф за молчание нечестно.
      null => 1,
    };

/// Сколько человек будет работать в приложении, включая самого владельца.
/// `null` — «сколько понадобится», то есть тариф без предела.
/// Ответа нет — считаем, что человек пока один: предлагать самый дорогой
/// тариф за молчание нечестно. `null` у ответа «больше пяти» означает
/// «сколько понадобится», и он проходит только в тариф без предела.
int? staffWanted(FarmCrew? crew) => crew == null ? 1 : crew.people;

/// Помещается ли хозяйство в тариф.
bool planFits(PlanOption plan, {int? rabbits, int? staff}) {
  final rabbitsOk = plan.maxRabbits == null ||
      (rabbits != null && plan.maxRabbits! >= rabbits);
  final staffOk =
      plan.maxStaff == null || (staff != null && plan.maxStaff! >= staff);
  return rabbitsOk && staffOk;
}

/// Самый маленький тариф, в который хозяйство помещается.
///
/// Список приходит с сервера от меньшего к большему, поэтому первый
/// подошедший — он и есть самый дешёвый. Не подошёл ни один — предлагаем
/// самый большой: это честнее, чем показать тариф, который заведомо лопнет.
PlanOption? recommendedPlan(List<PlanOption> plans, OnboardingAnswers answers) {
  if (plans.isEmpty) return null;

  final rabbits = rabbitsWanted(answers.herdSize);
  final staff = staffWanted(answers.crew);

  for (final plan in plans) {
    if (planFits(plan, rabbits: rabbits, staff: staff)) return plan;
  }
  return plans.last;
}
