/// Ответы, которые человек даёт до регистрации.
///
/// Живут только на устройстве: на этом этапе фермы ещё нет, отправлять их
/// некуда. Нужны они ради двух вещей — показать в конце опроса, что мы
/// услышали ответ, и подстроить первые шаги на «Сегодня» под то, чем человек
/// на самом деле занимается.
library;

/// Размер стада. Границы взяты не с потолка: до двух десятков кроликов ведут
/// в голове, сотня — это уже клетки с бирками, а за пятью сотнями начинается
/// хозяйство с наёмными работниками.
enum HerdSize {
  upTo20,
  upTo100,
  upTo500,
  over500;

  static HerdSize? byName(String? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}

/// Что человек хочет вести в первую очередь.
enum FarmFocus {
  breeding,
  feeding,
  health,
  money;

  static FarmFocus? byName(String name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}

/// Кто будет работать в приложении.
///
/// Вариантов ровно два, и различает их единственное, что приложение и правда
/// делает по-разному: одному человеку не нужны ни приглашения, ни права
/// доступа, ни отметка о том, кто внёс запись. «Вся семья» стояла здесь
/// третьим пунктом и приводила ровно туда же, куда «я и помощники», — выбор
/// без последствий только заставляет гадать, чем он отличается.
/// Сколько человек будет работать в приложении, считая владельца.
///
/// Раньше ответов было два — «только я» и «я и помощники», — то есть вопрос
/// был «есть ли помощники». Спрашиваем же мы размер команды: от него зависит
/// и предел работников в тарифе, и стоит ли первым делом звать приглашать
/// людей.
enum FarmCrew {
  alone(1),
  pair(2),
  team(5),
  // Больше пяти — это уже «сколько понадобится»: любое число, названное
  // здесь, было бы выдумкой.
  big(null);

  const FarmCrew(this.people);

  /// Сколько человек, включая владельца. `null` — «сколько понадобится».
  final int? people;

  static FarmCrew? byName(String? name) {
    // `withHelpers` — ответ прежней пары вариантов: у тех, кто уже прошёл
    // знакомство, он лежит в настройках телефона, и терять его незачем.
    if (name == 'withHelpers') return FarmCrew.pair;
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}

class OnboardingAnswers {
  const OnboardingAnswers({
    this.herdSize,
    this.focus = const {},
    this.crew,
    this.wantedPlan,
  });

  final HerdSize? herdSize;
  final Set<FarmFocus> focus;
  final FarmCrew? crew;

  /// Тариф, который человек выбрал на последнем шаге знакомства. Ферма всё
  /// равно заводится на бесплатном — это его намерение, а не наш счёт.
  final String? wantedPlan;

  /// Помощники будут — значит на ферме появится второй человек, и шаг
  /// «пригласить» перестаёт быть необязательной настройкой из глубины меню.
  bool get needsHelpers => crew != null && crew != FarmCrew.alone;

  OnboardingAnswers copyWith({
    HerdSize? herdSize,
    Set<FarmFocus>? focus,
    FarmCrew? crew,
    String? wantedPlan,
  }) =>
      OnboardingAnswers(
        herdSize: herdSize ?? this.herdSize,
        focus: focus ?? this.focus,
        crew: crew ?? this.crew,
        wantedPlan: wantedPlan ?? this.wantedPlan,
      );

  Map<String, dynamic> toJson() => {
        if (herdSize != null) 'herd_size': herdSize!.name,
        'focus': focus.map((f) => f.name).toList(),
        if (crew != null) 'crew': crew!.name,
        if (wantedPlan != null) 'wanted_plan': wantedPlan,
      };

  factory OnboardingAnswers.fromJson(Map<String, dynamic> json) =>
      OnboardingAnswers(
        herdSize: HerdSize.byName(json['herd_size'] as String?),
        focus: {
          for (final name in (json['focus'] as List? ?? const []))
            if (FarmFocus.byName(name as String) case final focus?) focus,
        },
        crew: FarmCrew.byName(json['crew'] as String?),
        wantedPlan: json['wanted_plan'] as String?,
      );
}
