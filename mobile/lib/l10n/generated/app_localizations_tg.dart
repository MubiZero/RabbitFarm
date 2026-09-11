// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tajik (`tg`).
class AppLocalizationsTg extends AppLocalizations {
  AppLocalizationsTg([String locale = 'tg']) : super(locale);

  @override
  String get appName => 'RabbitFarm';

  @override
  String get commonRetry => 'Такрор кардан';

  @override
  String get commonCancel => 'Бекор кардан';

  @override
  String get commonSave => 'Захира кардан';

  @override
  String get commonAdd => 'Илова кардан';

  @override
  String get commonDelete => 'Нест кардан';

  @override
  String get commonClose => 'Пӯшидан';

  @override
  String get commonCopy => 'Нусхабардорӣ кардан';

  @override
  String get commonCopied => 'Нусхабардорӣ шуд';

  @override
  String get commonLoadFailed => 'Бор карда нашуд';

  @override
  String get commonUnknownError => 'Хатои номаълум';

  @override
  String get commonSomethingWrong => 'Ягон чиз хато рафт';

  @override
  String get commonSomethingWrongHint =>
      'Ин экран кушода нашуд. Бозгардед ё барномаро аз нав кушоед.';

  @override
  String get errorOffline => 'Алоқа нест — интернетро санҷед';

  @override
  String get errorTimeout => 'Сервер ҷавоб надод, боз кӯшиш кунед';

  @override
  String get errorUnauthorized => 'Бояд аз нав ворид шавед';

  @override
  String get errorForbidden => 'Вазифаи шумо ба ин дастрасӣ надорад';

  @override
  String get errorNotFound => 'Сабт ёфт нашуд — эҳтимол, нест карда шудааст';

  @override
  String get errorInvalid => 'Сервер маълумотро қабул накард';

  @override
  String get errorServer => 'Дар сервер хато рӯй дод, баъдтар кӯшиш кунед';

  @override
  String get offlineBanner =>
      'Алоқа нест — хӯрокдиҳӣ, вазифаҳо ва қайдҳо захира шуда, баъдтар фиристода мешаванд';

  @override
  String get offlineActionQueued =>
      'Дар дастгоҳ захира шуд — вақте алоқа пайдо шавад, фиристода мешавад';

  @override
  String get forceUpdateTitle => 'Нусхаи нав дастрас аст';

  @override
  String get forceUpdateHint =>
      'Ин нусхаи барнома дигар дастгирӣ намешавад. Барои идома додани кор барномаро нав кунед.';

  @override
  String get forceUpdateButton => 'Нав кардан';

  @override
  String get commonStaleData =>
      'Нав карда нашуд, маълумоти пешина нишон дода мешавад';

  @override
  String get commonRetryShort => 'Боз як бор';

  @override
  String get commonNotSpecified => 'Ишора нашудааст';

  @override
  String get commonActions => 'Амалҳо';

  @override
  String get commonEmail => 'Почта';

  @override
  String get quickGroupOften => 'Зуд-зуд';

  @override
  String get journalPeriodToday => 'Имрӯз';

  @override
  String get journalPeriodWeek => 'Ҳафта';

  @override
  String get journalKindAll => 'Ҳама';

  @override
  String get journalKindFeeding => 'Хӯрокдиҳӣ';

  @override
  String get journalKindTreatment => 'Муолиҷа';

  @override
  String get journalKindVaccination => 'Эмкунӣ';

  @override
  String get journalKindTask => 'Вазифа';

  @override
  String get journalKindNote => 'Қайд';

  @override
  String get journalKindPhoto => 'Расм';

  @override
  String get journalEmptyTodayTitle => 'Имрӯз ҳанӯз чизе сабт нашудааст';

  @override
  String get journalEmptyWeekTitle => 'Дар ин ҳафта чизе сабт нашудааст';

  @override
  String get journalEmptyBody =>
      'Хӯрокдиҳӣ, муолиҷа, эмкунӣ, вазифаҳои иҷрошуда, қайдҳо ва расмҳо худашон ба ин ҷо меафтанд. Аввалинашро сабт кунед — ва он ҳамин ҷо пайдо мешавад.';

  @override
  String get journalNoneInViewTitle => 'Дар ин интихоб чизе нест';

  @override
  String get journalNoneInViewBody => 'Намуди сабт ё муҳлатро иваз кунед.';

  @override
  String get loginSubtitle => 'Вуруд ба фермаи шумо';

  @override
  String get loginPhoneLabel => 'Телефон';

  @override
  String get loginPhoneHint => '+992 XX XXX XX XX';

  @override
  String get loginPhoneEmpty => 'Рақами телефонро ворид кунед';

  @override
  String get loginPhoneInvalid => 'Рақам ба монанди +992 90 123 45 67';

  @override
  String get loginPhoneIntro => 'Рамзро бо SMS мефиристем — парол лозим нест.';

  @override
  String get loginRequestCode => 'Рамз гирифтан';

  @override
  String get loginWithPassword => 'Бо почта ва парол ворид шудан';

  @override
  String get loginCodeTitle => 'Рамзро ворид кунед';

  @override
  String loginCodeSentTo(String phone) {
    return 'Рамзро ба $phone фиристодем';
  }

  @override
  String get loginCodeLabel => 'Рамз аз SMS';

  @override
  String get loginCodeEmpty => 'Рамзро ворид кунед';

  @override
  String get loginCodeInvalid => 'Рамз аз 6 рақам иборат аст';

  @override
  String get loginCodeSubmit => 'Ворид шудан';

  @override
  String get loginCodeResend => 'Рамзро аз нав фиристодан';

  @override
  String loginCodeResendIn(int seconds) {
    return 'Аз нав фиристодан пас аз $seconds с';
  }

  @override
  String get loginCodeResent => 'Рамз аз нав фиристода шуд';

  @override
  String get loginCodeChangePhone => 'Рақамро иваз кардан';

  @override
  String get passwordLoginTitle => 'Вуруд бо почта ва парол';

  @override
  String get passwordLoginIntro =>
      'Роҳи эҳтиётӣ — барои онҳое, ки фермаро бо почта кушодаанд.';

  @override
  String get loginEmailLabel => 'Почта';

  @override
  String get loginEmailHint => 'name@example.com';

  @override
  String get loginEmailEmpty => 'Почтаро ворид кунед';

  @override
  String get loginEmailInvalid => 'Дар суроға хато ба назар мерасад';

  @override
  String get loginPasswordLabel => 'Парол';

  @override
  String get loginPasswordEmpty => 'Паролро ворид кунед';

  @override
  String get commonPasswordShow => 'Паролро нишон додан';

  @override
  String get commonPasswordHide => 'Паролро пинҳон кардан';

  @override
  String get loginSubmit => 'Ворид шудан';

  @override
  String get loginFailed => 'Ворид шудан муяссар нашуд';

  @override
  String get loginHasInvite => 'Ман рамзи даъватнома дорам';

  @override
  String get loginCreateFarm => 'Фермаи худро кушодан';

  @override
  String get loginForgotPassword => 'Паролро фаромӯш кардед?';

  @override
  String get forgotPasswordTitle => 'Паролро фаромӯш кардед?';

  @override
  String get forgotPasswordIntro =>
      'Почтае, ки бо он ба ферма ворид мешавед, нишон диҳед. Агар ҳисоб мавҷуд бошад, рамз мефиристем — тавассути SMS ё почта.';

  @override
  String get forgotPasswordEmailHint => 'Почтаро ворид кунед';

  @override
  String get forgotPasswordSubmit => 'Рамзро фиристодан';

  @override
  String get forgotPasswordSentMessage =>
      'Агар ҳисоб мавҷуд бошад, рамз фиристода шуд';

  @override
  String get forgotPasswordBackToLogin => 'Паролро ба ёд овардед? Ворид шавед';

  @override
  String get resetPasswordTitle => 'Рамзро ворид кунед';

  @override
  String get resetPasswordCodeHint => 'Рамзи 6-рақама аз SMS ё почта';

  @override
  String get resetPasswordCodeEmpty => 'Рамзро ворид кунед';

  @override
  String get resetPasswordCodeInvalid => 'Рамз аз 6 рақам иборат аст';

  @override
  String get resetPasswordNewPasswordHint => 'Пароли нав';

  @override
  String get resetPasswordConfirmHint => 'Пароли навро такрор кунед';

  @override
  String get resetPasswordConfirmMismatch => 'Паролҳо мувофиқат намекунанд';

  @override
  String get resetPasswordSubmit => 'Паролро иваз кардан';

  @override
  String get resetPasswordSuccessMessage =>
      'Парол иваз шуд. Бо пароли нав ворид шавед.';

  @override
  String get todayGreetingMorning => 'Субҳ ба хайр';

  @override
  String get todayGreetingDay => 'Рӯз ба хайр';

  @override
  String get todayGreetingEvening => 'Бегоҳ ба хайр';

  @override
  String get todayGreetingNight => 'Шаб ба хайр';

  @override
  String todayGreetingNamed(String greeting, String name) {
    return '$greeting, $name!';
  }

  @override
  String todayGreetingPlain(String greeting) {
    return '$greeting!';
  }

  @override
  String get todayNeedsAttention => 'Таваҷҷуҳ лозим аст';

  @override
  String get todayAllClear => 'Ҳама зери назорат аст — фаврӣ чизе нест';

  @override
  String get todayFarmNow => 'Ферма ҳозир';

  @override
  String get todayStatLivestock => 'Шумораи харгӯшҳо';

  @override
  String get todayStatTasks => 'Вазифаҳои корӣ';

  @override
  String get todayStatFreeCages => 'Қафасҳои холӣ';

  @override
  String get todayAlertOverdueVaccination => 'Эмкунӣ мӯҳлаташ гузаштааст';

  @override
  String get todayAlertLowFeed => 'Хӯрок рӯ ба тамом аст';

  @override
  String get todayAlertUpcomingVaccination => 'Ба зудӣ эмкунӣ';

  @override
  String get activationChecklistTitle => 'Оғози кор';

  @override
  String get activationChecklistDismiss => 'Пинҳон кардан';

  @override
  String get activationChecklistAddCage => 'Қафас илова кунед';

  @override
  String get activationChecklistAddRabbit => 'Харгӯш илова кунед';

  @override
  String get activationChecklistFirstFeeding => 'Хӯрокдиҳии якумро сабт кунед';

  @override
  String get menuProfile => 'Профил';

  @override
  String get roleOwner => 'Соҳиби ферма';

  @override
  String get roleManager => 'Мудир';

  @override
  String get roleWorker => 'Коргар';

  @override
  String get navToday => 'Имрӯз';

  @override
  String get navRabbits => 'Харгӯшҳо';

  @override
  String get navHerd => 'Чорво';

  @override
  String get navBreeding => 'Ҷуфтгирӣ';

  @override
  String get navFarm => 'Хоҷагӣ';

  @override
  String get navJournal => 'Дафтар';

  @override
  String get navProfile => 'Профил';

  @override
  String get navRecord => 'Сабт кардан';

  @override
  String get quickRecordTreatment => 'Муолиҷа';

  @override
  String get quickRecordBreeding => 'Ҷуфтгирӣ';

  @override
  String get quickAddFeed => 'Воридшавии хӯрок';

  @override
  String get quickRecordTransaction => 'Даромад ё харҷ';

  @override
  String get quickGroupDaily => 'Ҳар рӯз';

  @override
  String get quickGroupHerd => 'Чорво';

  @override
  String get quickGroupFarm => 'Хоҷагӣ';

  @override
  String get herdTitle => 'Чорво';

  @override
  String get herdTabCages => 'Қафасҳо';

  @override
  String get herdTabRabbits => 'Харгӯшҳо';

  @override
  String get journalTitle => 'Дафтар';

  @override
  String get reportsTitle => 'Ҳисоботҳо';

  @override
  String get farmTitle => 'Хоҷагӣ';

  @override
  String get navQuickTitle => 'Чиро сабт кунем';

  @override
  String get quickRecordFeeding => 'Хӯрокдиҳиро сабт кардан';

  @override
  String get quickRecordVaccination => 'Эмкуниро сабт кардан';

  @override
  String get quickCreateTask => 'Вазифа сохтан';

  @override
  String get quickRecordNote => 'Қайд гузоштан';

  @override
  String get quickAddRabbit => 'Харгӯш илова кардан';

  @override
  String get quickRecordBirth => 'Таваллудро сабт кардан';

  @override
  String get quickAddCage => 'Қафас илова кардан';

  @override
  String get formDiscardTitle => 'Бе захира баромадан?';

  @override
  String get formDiscardBody => 'Майдонҳои пуркардашуда гум мешаванд.';

  @override
  String get formDiscardStay => 'Пур карданро идома додан';

  @override
  String get formDiscardLeave => 'Баромадан';

  @override
  String get cycleTitle => 'Ҷуфтгирӣ';

  @override
  String get cycleFindPair => 'Ҷуфт интихоб кардан';

  @override
  String get cycleRecordBirth => 'Таваллудро сабт кардан';

  @override
  String get cycleStageCheck => 'Ҳомиладориро санҷидан';

  @override
  String get cycleStageBirth => 'Таваллуд интизор аст';

  @override
  String get cycleStageWeaning => 'Ҷудо кардани харгӯшчаҳо';

  @override
  String get cycleStageNotPregnant => 'Мода холӣ аст';

  @override
  String get cycleStageFailed => 'Ҷуфтгирӣ натиҷа надод';

  @override
  String get cycleStageCancelled => 'Ҷуфтгирӣ бекор карда шуд';

  @override
  String get cycleStageClosed => 'Давра ба анҷом расид';

  @override
  String cycleDay(int day) {
    return 'Рӯзи $day-ум';
  }

  @override
  String cycleMaleLine(String name) {
    return 'Нар: $name';
  }

  @override
  String cycleActionWhen(String date, String when) {
    return '$date · $when';
  }

  @override
  String cycleApproxDate(String date) {
    return 'тахминан $date';
  }

  @override
  String get cycleDueToday => 'имрӯз';

  @override
  String get cycleDueTomorrow => 'пагоҳ';

  @override
  String cycleInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'пас аз $count рӯз',
    );
    return '$_temp0';
  }

  @override
  String cycleOverdueDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'муҳлаташ аз $count рӯз гузаштааст',
    );
    return '$_temp0';
  }

  @override
  String get breedingEmptyTitle => 'Ҷуфтгирӣ ҳанӯз набудааст';

  @override
  String get breedingEmptyBody =>
      'Ҷуфтгириро сабт кунед, барнома санаи тахминии таваллудро мегӯяд.';

  @override
  String get breedingEmptyAction => 'Ҷуфтгириро сабт кардан';

  @override
  String get breedingMale => 'Нар';

  @override
  String get breedingFemale => 'Мода';

  @override
  String get commonNameMissing => 'Ном ишора нашудааст';

  @override
  String get commonOpenCard => 'Корторо кушодан';

  @override
  String get commonEdit => 'Тағйир додан';

  @override
  String get commonClearSearch => 'Ҷустуҷӯро тоза кардан';

  @override
  String get breedingStatusPlanned => 'Ба нақша гирифта шуд';

  @override
  String get breedingStatusCompleted => 'Анҷом ёфт';

  @override
  String get breedingStatusFailed => 'Натиҷа надод';

  @override
  String get breedingStatusCancelled => 'Бекор карда шуд';

  @override
  String get cageTitle => 'Қафас';

  @override
  String cageTitleNumbered(String number) {
    return 'Қафаси $number';
  }

  @override
  String get cageEdit => 'Қафасро тағйир додан';

  @override
  String get cageResidents => 'Сокинон';

  @override
  String get cageEmptyManaged =>
      'Қафас холӣ аст. Бо тугмаи поён харгӯш ҷойгир кунед.';

  @override
  String get cageEmptyReadOnly => 'Қафас холӣ аст.';

  @override
  String get cageFull => 'Қафас пур аст';

  @override
  String get cageAddRabbit => 'Харгӯш ҷойгир кардан';

  @override
  String get cageNoLocation => 'Ҷой ишора нашудааст';

  @override
  String get cageRemoveTitle => 'Аз қафас баровардан?';

  @override
  String cageRemoveBody(String name) {
    return '$name ба рӯйхати харгӯшони бе қафас мегузарад.';
  }

  @override
  String get cageRemoveConfirm => 'Баровардан';

  @override
  String cageRemoved(String name) {
    return '$name аз қафас бароварда шуд';
  }

  @override
  String cageMoved(String name, String number) {
    return '$name ба қафаси $number гузашт';
  }

  @override
  String cageSettled(String name) {
    return '$name дар қафас ҷойгир шуд';
  }

  @override
  String commonActionFailed(String reason) {
    return 'Иҷро нашуд: $reason';
  }

  @override
  String get cageResidentMove => 'Кӯчонидан';

  @override
  String get cagePickRabbitTitle => 'Киро ҷойгир кунем';

  @override
  String get cagePickRabbitHint => 'Ном ё рақами нишона';

  @override
  String get cagePickNothingFound => 'Ҳеҷ кас ёфт нашуд';

  @override
  String get cagePickNothingFoundBody => 'Ном ё рақами нишонаро санҷед.';

  @override
  String cagePickCurrentCage(String number) {
    return 'Ҳозир дар қафаси $number';
  }

  @override
  String get cagePickNoCage => 'Бе қафас';

  @override
  String get cagePickCageTitle => 'Ба куҷо кӯчонем';

  @override
  String get cagePickNoFreeCages => 'Қафаси холӣ нест';

  @override
  String get cagePickNoFreeCagesBody =>
      'Ҷой холӣ кунед ё қафаси нав илова кунед.';

  @override
  String get cageFormType => 'Навъи қафас';

  @override
  String get cycleStageWeaned => 'Харгӯшчаҳо ҷудо шуданд';

  @override
  String get cageTypeSingle => 'Танҳо';

  @override
  String get cageTypeGroup => 'Гурӯҳӣ';

  @override
  String get cageTypeMaternity => 'Барои таваллуд';

  @override
  String get cageConditionGood => 'Дар ҳолати хуб';

  @override
  String get cageConditionNeedsRepair => 'Таъмир лозим аст';

  @override
  String get cageConditionBroken => 'Вайрон шудааст';

  @override
  String countTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вазифа',
    );
    return '$_temp0';
  }

  @override
  String countVaccinations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count эмкунӣ',
    );
    return '$_temp0';
  }

  @override
  String countFeedKinds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count намуди хӯрок',
    );
    return '$_temp0';
  }

  @override
  String countRabbits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count харгӯш',
    );
    return '$_temp0';
  }

  @override
  String countRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сабт',
    );
    return '$_temp0';
  }

  @override
  String countOperations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count амалиёт',
    );
    return '$_temp0';
  }

  @override
  String get tasksTitle => 'Вазифаҳо';

  @override
  String get todayTasksTitle => 'Вазифаҳои имрӯза';

  @override
  String get todayTasksAll => 'Ҳамаи вазифаҳо';

  @override
  String get todayTaskDone => 'Иҷро шуд';

  @override
  String get todayTasksNone => 'Барои имрӯз вазифа нест';

  @override
  String get commonFilters => 'Филтрҳо';

  @override
  String get commonApply => 'Татбиқ кардан';

  @override
  String get commonReset => 'Бознишонӣ';

  @override
  String get tasksFilterType => 'Навъ';

  @override
  String get tasksFilterStatus => 'Ҳолат';

  @override
  String get tasksFilterPriority => 'Аҳамият';

  @override
  String get tasksFilterOverdueOnly => 'Танҳо мӯҳлаташ гузашта';

  @override
  String get tasksFilterTodayOnly => 'Танҳо имрӯза';

  @override
  String get tasksEmptyTitle => 'Вазифа ҳанӯз нест';

  @override
  String get tasksEmptyBody =>
      'Вазифа созед — барнома дар рӯзи мӯҳлаташ ба шумо ёдрас мекунад.';

  @override
  String get tasksEmptyAction => 'Вазифа сохтан';

  @override
  String get tasksNothingMatchesTitle => 'Ба филтрҳо чизе мувофиқ наомад';

  @override
  String get tasksNothingMatchesBody =>
      'Баъзе шартҳоро бардоред, то бештар бинед.';

  @override
  String get tasksComplete => 'Иҷрошуда қайд кардан';

  @override
  String get tasksCompleted => 'Вазифа иҷро шуд';

  @override
  String get tasksCompleteFailed => 'Қайд кардани вазифа муяссар нашуд';

  @override
  String get tasksOverdueChip => 'Мӯҳлаташ гузашта';

  @override
  String get tasksTodayChip => 'Барои имрӯз';

  @override
  String get taskTypeFeeding => 'Хӯрокдиҳӣ';

  @override
  String get taskTypeCleaning => 'Тозакунӣ';

  @override
  String get taskTypeVaccination => 'Эмкунӣ';

  @override
  String get taskTypeCheckup => 'Муоина';

  @override
  String get taskTypeBreeding => 'Ҷуфтгирӣ';

  @override
  String get taskTypeOther => 'Дигар';

  @override
  String get taskStatusPending => 'Дар навбат';

  @override
  String get taskStatusInProgress => 'Дар кор';

  @override
  String get taskStatusCompleted => 'Иҷрошуда';

  @override
  String get taskStatusCancelled => 'Бекоршуда';

  @override
  String get taskPriorityLow => 'Паст';

  @override
  String get taskPriorityMedium => 'Миёна';

  @override
  String get taskPriorityHigh => 'Баланд';

  @override
  String get taskPriorityUrgent => 'Фаврӣ';

  @override
  String dueToday(String time) {
    return 'Имрӯз соати $time';
  }

  @override
  String dueTomorrow(String time) {
    return 'Пагоҳ соати $time';
  }

  @override
  String dueOn(String date) {
    return '$date';
  }

  @override
  String overdueByDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Мӯҳлаташ аз $count рӯз гузаштааст',
    );
    return '$_temp0';
  }

  @override
  String get dueTodayPlain => 'Имрӯз';

  @override
  String get dueTomorrowPlain => 'Пагоҳ';

  @override
  String get taskFormNewTitle => 'Вазифаи нав';

  @override
  String get taskFormEditTitle => 'Вазифа';

  @override
  String get taskFormSectionMain => 'Асосӣ';

  @override
  String get taskFormSectionParams => 'Параметрҳо';

  @override
  String get taskFormSectionNotes => 'Қайдҳо';

  @override
  String get taskFormTitleLabel => 'Чиро бояд кард';

  @override
  String get taskFormTitleEmpty => 'Вазифаро дар як сатр тасвир кунед';

  @override
  String get taskFormDescriptionLabel => 'Тафсилот';

  @override
  String get taskFormDueLabel => 'Мӯҳлат';

  @override
  String get taskFormRepeat => 'Такрор кардан';

  @override
  String get taskFormRepeatNever => 'Такрор накардан';

  @override
  String get taskFormRepeatHelp =>
      'Вақте ки вазифа иҷрошуда қайд мешавад, навбатиаш худ ба худ пайдо мешавад.';

  @override
  String get taskFormNotesLabel => 'Қайдҳо';

  @override
  String get taskFormCreate => 'Сохтан';

  @override
  String get taskFormCreated => 'Вазифа сохта шуд';

  @override
  String get taskFormUpdated => 'Вазифа нав карда шуд';

  @override
  String get taskFormDeleteTitle => 'Вазифаро нест кунем?';

  @override
  String get taskFormDeleteBody => 'Баргардонидани он имконнопазир мешавад.';

  @override
  String get taskFormDeleted => 'Вазифа нест карда шуд';

  @override
  String get taskFormDeleteFailed => 'Нест кардани вазифа муяссар нашуд';

  @override
  String get noteFormNewTitle => 'Қайди нав';

  @override
  String get noteFormEditTitle => 'Қайд';

  @override
  String get noteFormSectionMain => 'Асосӣ';

  @override
  String get noteFormContentLabel => 'Матни қайд';

  @override
  String get noteFormContentEmpty => 'Матни қайдро ворид кунед';

  @override
  String get noteFormSectionLink => 'Ба чӣ дахл дорад';

  @override
  String get noteFormRabbitLabel => 'Харгӯш (ихтиёрӣ)';

  @override
  String get noteFormCageLabel => 'Қафас (ихтиёрӣ)';

  @override
  String get noteFormCageNone => 'Интихоб нашуд';

  @override
  String get noteFormCreate => 'Илова кардан';

  @override
  String get noteFormCreated => 'Қайд илова шуд';

  @override
  String get noteFormUpdated => 'Қайд нав карда шуд';

  @override
  String get noteFormDeleteTitle => 'Қайдро нест кунем?';

  @override
  String get noteFormDeleteBody => 'Баргардонидани он имконнопазир мешавад.';

  @override
  String get noteFormDeleted => 'Қайд нест карда шуд';

  @override
  String get noteFormDeleteFailed => 'Нест кардани қайд муяссар нашуд';

  @override
  String get repeatDaily => 'Ҳар рӯз';

  @override
  String get repeatWeekly => 'Як бор дар як ҳафта';

  @override
  String get repeatBiweekly => 'Як бор дар ду ҳафта';

  @override
  String get repeatMonthly => 'Як бор дар як моҳ';

  @override
  String get repeatQuarterly => 'Як бор дар як семоҳа';

  @override
  String get repeatYearly => 'Як бор дар як сол';

  @override
  String get vaccinationsTitle => 'Эмкуниҳо';

  @override
  String get vaccinationsStats => 'Хулоса';

  @override
  String get vaccinationsViewAll => 'Ҳама';

  @override
  String get vaccinationsViewUpcoming => 'Пешакӣ';

  @override
  String get vaccinationsViewOverdue => 'Мӯҳлаташ гузашта';

  @override
  String get vaccinationsViewLast30 => 'Барои 30 рӯз';

  @override
  String get vaccinationsEmptyTitle => 'Сабти эмкунӣ нест';

  @override
  String get vaccinationsEmptyBody =>
      'Эмкуниро қайд кунед — барнома вақти навбатиро ба шумо ёдрас мекунад.';

  @override
  String get vaccinationsEmptyAction => 'Эмкуниро сабт кардан';

  @override
  String get vaccinationsNoneInView => 'Дар ин интихоб чизе нест';

  @override
  String get vaccinationsNoneInViewBody =>
      'Варақаи дигар интихоб кунед ё филтрҳоро бардоред.';

  @override
  String get vaccinationsFilterType => 'Навъи ваксина';

  @override
  String get vaccinationsFilterPeriod => 'Давра';

  @override
  String get vaccinationsFrom => 'Аз';

  @override
  String get vaccinationsTo => 'То';

  @override
  String get vaccinationsResetAll => 'Ҳамаро бознишондан';

  @override
  String vaccinationsNext(String date) {
    return 'Навбатӣ $date';
  }

  @override
  String get vaccinationsOverdueBadge => 'Мӯҳлаташ гузашт';

  @override
  String vaccinationsInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'пас аз $count рӯз',
    );
    return '$_temp0';
  }

  @override
  String vaccinationsBatch(String number) {
    return 'Партияи $number';
  }

  @override
  String get vaccinationsVet => 'Духтури байторӣ';

  @override
  String get vaccinationsDate => 'Санаи эмкунӣ';

  @override
  String get vaccinationsNextLabel => 'Эмкунии навбатӣ';

  @override
  String get vaccinationsBatchLabel => 'Рақами партия';

  @override
  String get vaccinationsTypeLabel => 'Навъ';

  @override
  String get vaccinationsNotesLabel => 'Қайдҳо';

  @override
  String get vaccinationsDeleteTitle => 'Сабтро нест кунем?';

  @override
  String get vaccinationsDeleteBody =>
      'Сабти эмкунӣ бе имкони баргардонидан нест карда мешавад.';

  @override
  String get vaccinationsDeleted => 'Сабт нест карда шуд';

  @override
  String get vaccinationsDeleteFailed => 'Нест кардани сабт муяссар нашуд';

  @override
  String get vaccinationsStatTotal => 'Ҳамагӣ эмкуниҳо';

  @override
  String get vaccinationsStatThisYear => 'Дар ин сол';

  @override
  String get vaccinationsStatLast30 => 'Барои 30 рӯз';

  @override
  String get vaccinationsStatUpcoming => 'Пешакӣ';

  @override
  String get vaccinationsStatNext30 => 'Дар 30 рӯзи наздик';

  @override
  String get vaccinationsStatOverdue => 'Мӯҳлаташ гузашт';

  @override
  String get rabbitPickerTitle => 'Харгӯшро интихоб кунед';

  @override
  String get rabbitPickerHint => 'Ном ё рақами нишона';

  @override
  String get rabbitPickerEmpty => 'Интихоб нашуд';

  @override
  String get rabbitPickerNothingFound => 'Ҳеҷ кас ёфт нашуд';

  @override
  String get rabbitPickerNothingFoundBody => 'Ном ё рақами нишонаро санҷед.';

  @override
  String get rabbitPickerClear => 'Тоза кардан';

  @override
  String get rabbitPickerRequired => 'Харгӯшро интихоб кунед';

  @override
  String rabbitPickerInCage(String number) {
    return 'Қафаси $number';
  }

  @override
  String get rabbitPickerNoCage => 'Бе қафас';

  @override
  String get vaccFormNewTitle => 'Эмкунии нав';

  @override
  String get vaccFormEditTitle => 'Эмкунӣ';

  @override
  String get vaccFormSectionMain => 'Асосӣ';

  @override
  String get vaccFormSectionDates => 'Санаҳо';

  @override
  String get vaccFormSectionExtra => 'Иловагӣ';

  @override
  String get fieldRecipient => 'Ба кӣ';

  @override
  String get vaccFormType => 'Навъи ваксина';

  @override
  String get vaccFormName => 'Номи ваксина';

  @override
  String get vaccFormNameHint => 'Масалан, Раббивак V';

  @override
  String get vaccFormNameEmpty => 'Номи ваксинаро ворид кунед';

  @override
  String get vaccFormDate => 'Санаи эмкунӣ';

  @override
  String get vaccFormNextDate => 'Эмкунии навбатӣ';

  @override
  String get vaccFormNextNotSet => 'Ба нақша гирифта нашудааст';

  @override
  String get vaccFormPlus3m => 'пас аз 3 моҳ';

  @override
  String get vaccFormPlus6m => 'пас аз ним сол';

  @override
  String get vaccFormPlus1y => 'пас аз як сол';

  @override
  String get vaccFormBatch => 'Рақами партия';

  @override
  String get vaccFormBatchHint => 'Масалан, 12345-67';

  @override
  String get vaccFormVet => 'Духтури байторӣ';

  @override
  String get vaccFormVetHint => 'Кӣ эмкунӣ кард';

  @override
  String get vaccFormNotes => 'Қайдҳо';

  @override
  String get vaccFormCreated => 'Эмкунӣ сабт шуд';

  @override
  String get vaccFormUpdated => 'Сабт нав карда шуд';

  @override
  String get vaccFormFailed => 'Захира кардан муяссар нашуд';

  @override
  String get medTitle => 'Муолиҷа';

  @override
  String get medEmptyTitle => 'Сабти муолиҷа нест';

  @override
  String get medEmptyBody =>
      'Корти беморӣ кушоед — он аломатҳо, муолиҷа ва харҷро дар як ҷо ҷамъ мекунад.';

  @override
  String get medEmptyAction => 'Корт кушодан';

  @override
  String get medNoneInView => 'Дар ин интихоб чизе нест';

  @override
  String get medNoneInViewBody =>
      'Варақаи дигар интихоб кунед ё филтрҳоро бардоред.';

  @override
  String get medViewAll => 'Ҳама';

  @override
  String get medOutcomeOngoing => 'Муолиҷа мешавад';

  @override
  String get medOutcomeRecovered => 'Сиҳат шуд';

  @override
  String get medOutcomeDied => 'Мурд';

  @override
  String get medOutcomeEuthanized => 'Эвтаназия шуд';

  @override
  String get medDiagnosis => 'Ташхис';

  @override
  String get medSymptoms => 'Аломатҳо';

  @override
  String get medTreatment => 'Муолиҷа';

  @override
  String get medMedication => 'Доруворӣ';

  @override
  String get medStarted => 'Оғоз';

  @override
  String get medEnded => 'Анҷом';

  @override
  String get medCost => 'Харҷ';

  @override
  String get medVet => 'Духтури байторӣ';

  @override
  String get medNotes => 'Қайдҳо';

  @override
  String get medNoDiagnosis => 'Ташхис гузошта нашудааст';

  @override
  String get medDeleteTitle => 'Корторо нест кунем?';

  @override
  String get medDeleteBody =>
      'Сабти муолиҷа бе имкони баргардонидан нест карда мешавад.';

  @override
  String get medDeleted => 'Сабт нест карда шуд';

  @override
  String get medDeleteFailed => 'Нест кардани сабт муяссар нашуд';

  @override
  String get medPeriodFrom => 'Аз санаи';

  @override
  String get medPeriodTo => 'То санаи';

  @override
  String get commonSummary => 'Хулоса';

  @override
  String get medStatTotal => 'Ҳамагӣ картҳо';

  @override
  String get medStatThisYear => 'Дар ин сол';

  @override
  String get medStatLastMonth => 'Дар як моҳ';

  @override
  String get medStatCost => 'Сарф шуд';

  @override
  String get medStatOngoing => 'Ҳозир муолиҷа мешаванд';

  @override
  String medDaysOngoing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рӯз',
    );
    return '$_temp0';
  }

  @override
  String get medFormNewTitle => 'Корти нав';

  @override
  String get medFormEditTitle => 'Корти муолиҷа';

  @override
  String get medFormRabbit => 'Ба кӣ';

  @override
  String get medFormSectionCase => 'Чӣ рӯй дод';

  @override
  String get medFormSectionTreatment => 'Муолиҷа';

  @override
  String get medFormSectionDates => 'Мӯҳлат ва пул';

  @override
  String get medFormSymptomsEmpty => 'Аломатҳоро тасвир кунед';

  @override
  String get medFormOutcome => 'Натиҷа';

  @override
  String get medFormCreated => 'Корт кушода шуд';

  @override
  String get medFormUpdated => 'Корт нав карда шуд';

  @override
  String get medFormFailed => 'Захира кардан муяссар нашуд';

  @override
  String get medFormCostHelp =>
      'Маблағ ҳамчун амалиёти алоҳида ба харҷи ферма меафтад.';

  @override
  String get medFormDosage => 'Миқдори дору';

  @override
  String get medFormEndedDate => 'Санаи анҷом';

  @override
  String get medFormNotSet => 'Ишора нашудааст';

  @override
  String medFormCostLabel(String currency) {
    return 'Харҷ, $currency';
  }

  @override
  String get commonNumberInvalid => 'Рақамро ворид кунед';

  @override
  String get feedsTitle => 'Анбори хӯрок';

  @override
  String get feedsAdd => 'Хӯрок илова кардан';

  @override
  String get feedsEmptyTitle => 'Анбор холӣ аст';

  @override
  String get feedsEmptyBody =>
      'Хӯрок илова кунед — барнома огоҳ мекунад, вақте ки он рӯ ба тамом мешавад.';

  @override
  String get feedsNoneInView => 'Ба филтрҳо чизе мувофиқ наомад';

  @override
  String get feedsNoneInViewBody =>
      'Шартҳоро бардоред, то тамоми анборро бинед.';

  @override
  String get feedsFilterAll => 'Ҳама';

  @override
  String get feedsFilterLowStock => 'Рӯ ба тамом';

  @override
  String get feedsFilterType => 'Навъи хӯрок';

  @override
  String get feedingBulkModeRabbits => 'Харгӯшҳо';

  @override
  String get feedingBulkModeCages => 'Қафасҳо';

  @override
  String get feedingBulkAddRabbit => 'Харгӯш илова кардан';

  @override
  String get feedingBulkRabbitsRequired =>
      'Ҳадди ақал як харгӯшро интихоб кунед';

  @override
  String get feedingBulkRemove => 'Аз рӯйхат баровардан';

  @override
  String get feedingBulkCagesField => 'Кадом қафасҳо';

  @override
  String get feedingBulkCagesRequired => 'Ҳадди ақал як қафасро интихоб кунед';

  @override
  String get feedingBulkCagesPickTitle => 'Кадом қафасҳоро мехӯронем';

  @override
  String feedingBulkCagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count қафас',
    );
    return '$_temp0';
  }

  @override
  String get feedingBulkWholeFarm => 'Тамоми ферма';

  @override
  String get feedingBulkClearSelection => 'Интихобро бекор кардан';

  @override
  String get feedingBulkRowUnnamed => 'Бе қатор';

  @override
  String get feedingBulkDone => 'Тайёр';

  @override
  String get feedingBulkNoCagesTitle => 'Қафас ҳанӯз нест';

  @override
  String get feedingBulkNoCagesBody =>
      'Қафасҳо кушоед — он гоҳ хӯрокдиҳиро якбора барои қатор ё тамоми ферма сабт кардан мумкин мешавад.';

  @override
  String get feedingBulkQuantityEach => 'Ба ҳар кас чӣ қадар';

  @override
  String get feedingBulkQuantityEachHint => 'Рақам — барои як гиранда.';

  @override
  String feedingBulkQuantityEachNote(String amount) {
    return 'Рақам — барои як гиранда. Ҳамагӣ $amount сарф мешавад.';
  }

  @override
  String feedingBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хӯрокдиҳӣ сабт шуд',
    );
    return '$_temp0';
  }

  @override
  String get feedsFilterAllTypes => 'Ҳама навъҳо';

  @override
  String get feedsInStock => 'Дар анбор';

  @override
  String get feedsMinStock => 'Ҳадди ақал';

  @override
  String get feedsLowStockWarning => 'Аз ҳадди ақал камтар мондааст';

  @override
  String get feedsRefill => 'Пур кардан';

  @override
  String get feedsWriteOff => 'Хориҷ кардан';

  @override
  String get feedsRefillTitle => 'Анборро пур кардан';

  @override
  String get feedsWriteOffTitle => 'Аз анбор хориҷ кардан';

  @override
  String feedsCurrentStock(String amount) {
    return 'Ҳозир дар анбор: $amount';
  }

  @override
  String get feedsQuantity => 'Чӣ қадар';

  @override
  String get feedsQuantityPositive => 'Миқдоре аз сифр зиёд ворид кунед';

  @override
  String feedsRefilled(String amount) {
    return 'Анбор ба $amount пур карда шуд';
  }

  @override
  String feedsWrittenOff(String amount) {
    return '$amount хориҷ карда шуд';
  }

  @override
  String get feedsAdjustFailed => 'Тағйир додани миқдор муяссар нашуд';

  @override
  String get feedsDeleteTitle => 'Хӯрокро нест кунем?';

  @override
  String feedsDeleteBody(String name) {
    return '«$name» ҳамроҳи таърихи анбор аз рӯйхат нест мешавад.';
  }

  @override
  String get feedsDeleted => 'Хӯрок нест карда шуд';

  @override
  String get feedsDeleteFailed => 'Нест кардани хӯрок муяссар нашуд';

  @override
  String get feedFormNewTitle => 'Хӯроки нав';

  @override
  String get feedFormEditTitle => 'Хӯрок';

  @override
  String get commonSectionMain => 'Асосӣ';

  @override
  String get feedFormSectionStock => 'Анбор';

  @override
  String get feedFormName => 'Ном';

  @override
  String get feedFormNameEmpty => 'Номи хӯрокро ворид кунед';

  @override
  String get feedFormType => 'Навъи хӯрок';

  @override
  String get feedFormUnit => 'Дар чӣ ҳисоб мекунем';

  @override
  String get feedFormCurrentStock => 'Ҳозир дар анбор';

  @override
  String get feedFormMinStock => 'Огоҳ кардан, вақте ки монад';

  @override
  String get feedFormMinStockHelp =>
      'Аз ин миқдор камтар шавад, хӯрок ба «Таваҷҷуҳ лозим аст»-и экрани асосӣ меафтад.';

  @override
  String get feedFormCost => 'Нархи як воҳид';

  @override
  String get feedFormRequired => 'Майдонро пур кунед';

  @override
  String get feedFormNegative => 'Рақам наметавонад манфӣ бошад';

  @override
  String get feedFormCreated => 'Хӯрок ба анбор илова шуд';

  @override
  String get feedFormUpdated => 'Хӯрок нав карда шуд';

  @override
  String get feedFormFailed => 'Захира кардани хӯрок муяссар нашуд';

  @override
  String get feedingTitle => 'Хӯрокдиҳиҳо';

  @override
  String get feedingAdd => 'Хӯрокдиҳиро сабт кардан';

  @override
  String get feedingEmptyTitle => 'Сабти хӯрокдиҳӣ нест';

  @override
  String get feedingEmptyBody =>
      'Хӯрокдиҳиро қайд кунед — сарфи хӯрок аз анбор худ ба худ кам мешавад.';

  @override
  String get feedingNoneInView => 'Дар ин давра сабт нест';

  @override
  String get feedingNoneInViewBody =>
      'Давраи дигар интихоб кунед ё филтрро бардоред.';

  @override
  String get feedingUnknownFeed => 'Хӯрок ишора нашудааст';

  @override
  String feedingForRabbit(String name) {
    return 'Харгӯши $name';
  }

  @override
  String feedingForCage(String number) {
    return 'Қафаси $number';
  }

  @override
  String get feedingForFarm => 'Тамоми ферма';

  @override
  String get feedingEdit => 'Тағйир додан';

  @override
  String get feedingDeleteTitle => 'Сабтро нест кунем?';

  @override
  String get feedingDeleteBody =>
      'Сабти хӯрокдиҳӣ нест карда мешавад. Хӯроки сарфшуда ба анбор барнамегардад.';

  @override
  String get feedingDeleted => 'Сабт нест карда шуд';

  @override
  String get feedingDeleteFailed => 'Нест кардани сабт муяссар нашуд';

  @override
  String get commonPeriod => 'Давра';

  @override
  String get feedingFormNewTitle => 'Хӯрокдиҳии нав';

  @override
  String get feedingFormEditTitle => 'Хӯрокдиҳӣ';

  @override
  String get feedingFormSectionWhom => 'Киро мехӯронем';

  @override
  String get feedingFormSectionWhat => 'Чӣ ва чӣ қадар';

  @override
  String get feedingFormModeRabbit => 'Як харгӯш';

  @override
  String get feedingFormModeCage => 'Тамоми қафас';

  @override
  String get feedingFormCage => 'Қафас';

  @override
  String get feedingFormCageRequired => 'Қафасро интихоб кунед';

  @override
  String get feedingFormFeed => 'Хӯрок';

  @override
  String get feedingFormFeedRequired => 'Хӯрокро интихоб кунед';

  @override
  String get feedingFormQuantity => 'Чӣ қадар';

  @override
  String get feedingFormQuantityRequired => 'Миқдорро ворид кунед';

  @override
  String get feedingFormWhen => 'Кай';

  @override
  String get feedingFormNotes => 'Қайдҳо';

  @override
  String feedingFormStockLeft(String amount) {
    return '$amount монд';
  }

  @override
  String get feedingFormUpdated => 'Сабт нав карда шуд';

  @override
  String get feedingFormFailed => 'Захира кардани сабт муяссар нашуд';

  @override
  String get feedingFormStockNote =>
      'Миқдори нишондодашуда аз анбор хориҷ мешавад.';

  @override
  String get financeTitle => 'Молия';

  @override
  String get financeAdd => 'Амалиёт илова кардан';

  @override
  String get financeEmptyTitle => 'Амалиёт ҳанӯз нест';

  @override
  String get financeEmptyBody =>
      'Даромад ва харҷро сабт кунед — барнома фоидаи фермаро худ ҳисоб мекунад.';

  @override
  String get financeNoneInView => 'Ба филтрҳо чизе мувофиқ наомад';

  @override
  String get financeNoneInViewBody =>
      'Шартҳоро бардоред, то тамоми рӯйхатро бинед.';

  @override
  String get financeIncome => 'Даромад';

  @override
  String get financeExpenses => 'Харҷ';

  @override
  String get financeBalance => 'Баланс';

  @override
  String get financeSummaryPeriod => 'Барои тамоми давра';

  @override
  String get financeSummaryFiltered => 'Барои давраи интихобшуда';

  @override
  String get financeAll => 'Ҳама';

  @override
  String get financeOnlyIncome => 'Даромад';

  @override
  String get financeOnlyExpenses => 'Харҷ';

  @override
  String get financeCategory => 'Категория';

  @override
  String get financeType => 'Навъ';

  @override
  String get financeDate => 'Сана';

  @override
  String get financeDescription => 'Тавсиф';

  @override
  String get financeTypeIncome => 'Даромад';

  @override
  String get financeTypeExpense => 'Харҷ';

  @override
  String get financeDeleteTitle => 'Амалиётро нест кунем?';

  @override
  String get financeDeleteBody =>
      'Амалиёт бе имкони баргардонидан аз рӯйхат нест мешавад.';

  @override
  String get financeDeleted => 'Амалиёт нест карда шуд';

  @override
  String get financeDeleteFailed => 'Нест кардани амалиёт муяссар нашуд';

  @override
  String get txFormNewTitle => 'Амалиёти нав';

  @override
  String get txFormEditTitle => 'Амалиёт';

  @override
  String get txFormSectionKind => 'Амалиёт чӣ гуна аст';

  @override
  String get commonSectionDetails => 'Тафсилот';

  @override
  String get txFormIncomeSubtitle => 'Фурӯш, хизматрасонӣ';

  @override
  String get txFormExpenseSubtitle => 'Харид, муолиҷа, хӯрок';

  @override
  String get txFormAmount => 'Маблағ';

  @override
  String get txFormAmountEmpty => 'Маблағро ворид кунед';

  @override
  String get txFormAmountPositive => 'Маблағ бояд аз сифр зиёд бошад';

  @override
  String get txFormDate => 'Кай';

  @override
  String get txFormRabbit => 'Бо харгӯш пайваст кардан';

  @override
  String get txFormRabbitHelp =>
      'Ихтиёрӣ. Барои дидани даромад ва харҷи як ҳайвони мушаххас лозим аст.';

  @override
  String get txFormDescription => 'Тавсиф';

  @override
  String get txFormCreated => 'Амалиёт сабт шуд';

  @override
  String get txFormUpdated => 'Амалиёт нав карда шуд';

  @override
  String get txFormFailed => 'Захира кардани амалиёт муяссар нашуд';

  @override
  String get cagesTitle => 'Қафасҳо';

  @override
  String get cagesAdd => 'Қафас илова кардан';

  @override
  String get cagesSearchHint => 'Рақам ё ҷой';

  @override
  String get cagesOnlyAvailable => 'Танҳо холӣ';

  @override
  String get cagesEmptyTitle => 'Қафас ҳанӯз нест';

  @override
  String get cagesEmptyBody =>
      'Қафасҳо кушоед — бо онҳо маълум мешавад, ки харгӯшро ба куҷо ҷойгир кунем ва дар куҷо ҷой ҳаст.';

  @override
  String get cagesNothingFound => 'Чизе ёфт нашуд';

  @override
  String get cagesNothingFoundBody => 'Дархостро санҷед ё филтрҳоро бардоред.';

  @override
  String cagesOccupancy(int occupied, int capacity) {
    return 'Пур $occupied аз $capacity';
  }

  @override
  String cagesLastCleaned(String date) {
    return 'Тоза шуд $date';
  }

  @override
  String get cagesMarkCleaned => 'Тозакуниро қайд кардан';

  @override
  String get cagesCleaned => 'Тозакунӣ қайд шуд';

  @override
  String get cagesCleanFailed => 'Қайд кардани тозакунӣ муяссар нашуд';

  @override
  String get cagesDeleteTitle => 'Қафасро нест кунем?';

  @override
  String cagesDeleteBody(String number) {
    return 'Қафаси $number аз рӯйхат нест мешавад. Харгӯшони он бе қафас мемонанд.';
  }

  @override
  String get cagesDeleted => 'Қафас нест карда шуд';

  @override
  String get cagesDeleteFailed => 'Нест кардани қафас муяссар нашуд';

  @override
  String get cagesFilterCondition => 'Ҳолат';

  @override
  String get cageFormNewTitle => 'Қафаси нав';

  @override
  String get cageFormEditTitle => 'Қафас';

  @override
  String get cageFormNumber => 'Рақам';

  @override
  String get cageFormNumberEmpty => 'Рақами қафасро ворид кунед';

  @override
  String get cageFormCapacity => 'Чанд харгӯш ҷо мешавад';

  @override
  String get cageFormCapacityInvalid => 'Рақаме аз сифр зиёд ворид кунед';

  @override
  String get cageFormCapacityGroup =>
      'Дар қафаси гурӯҳӣ ҳадди ақал ду ҷой лозим аст';

  @override
  String get cageFormSize => 'Андоза';

  @override
  String get cageFormSizeHint => 'Масалан, 100×60×45 см';

  @override
  String get cageFormLocation => 'Ҷой';

  @override
  String get cageFormLocationHint => 'Масалан, анбор, қатори чап';

  @override
  String get cageFormNotes => 'Қайдҳо';

  @override
  String get cageFormCreated => 'Қафас илова шуд';

  @override
  String get cageFormUpdated => 'Қафас нав карда шуд';

  @override
  String get cageFormFailed => 'Захира кардани қафас муяссар нашуд';

  @override
  String get rabbitsTitle => 'Харгӯшҳо';

  @override
  String get rabbitsSearchHint => 'Ном ё рақами нишона';

  @override
  String get herdCagesNoPlace => 'Ҷой ишора нашудааст';

  @override
  String get rabbitsEmptyTitle => 'Харгӯш ҳанӯз нест';

  @override
  String get rabbitsEmptyBody =>
      'Харгӯши аввалро илова кунед — аз он тамоми ҳисобот сар мешавад: насаб, саломатӣ ва насл.';

  @override
  String get rabbitsEmptyAction => 'Харгӯш илова кардан';

  @override
  String get rabbitsNothingFound => 'Ҳеҷ кас ёфт нашуд';

  @override
  String get rabbitsNothingFoundBody =>
      'Дархостро санҷед ё филтрҳоро бардоред.';

  @override
  String get rabbitsFilterAll => 'Ҳама';

  @override
  String get rabbitsFilterMales => 'Нарҳо';

  @override
  String get rabbitsFilterFemales => 'Модаҳо';

  @override
  String get rabbitsFilterActive => 'Дар кор';

  @override
  String get rabbitsFilterSold => 'Фурӯхташуда';

  @override
  String get sexMale => 'Нар';

  @override
  String get sexFemale => 'Мода';

  @override
  String get sexUnknown => 'Ҷинс ишора нашудааст';

  @override
  String get rabbitNoTag => 'Бе нишона';

  @override
  String get weightTitle => 'Вазнкуниҳо';

  @override
  String weightSubtitle(String name) {
    return '$name';
  }

  @override
  String get weightEmptyTitle => 'Вазнкунӣ ҳанӯз нест';

  @override
  String get weightEmptyBody =>
      'Вазнро сабт кунед — аз он маълум мешавад, харгӯш калон мешавад ё не.';

  @override
  String get weightAdd => 'Вазнро сабт кардан';

  @override
  String get weightSummary => 'Хулоса';

  @override
  String get weightCurrent => 'Ҳозир';

  @override
  String get weightTrend => 'Аз бори охир';

  @override
  String get weightTotalChange => 'Барои тамоми вақт';

  @override
  String get weightHistory => 'Таърих';

  @override
  String get weightValue => 'Вазн, кг';

  @override
  String get weightValueHint => 'Масалан, 3,5';

  @override
  String get weightValueEmpty => 'Вазнро ворид кунед';

  @override
  String get weightValuePositive => 'Вазн бояд аз сифр зиёд бошад';

  @override
  String get weightWhen => 'Кай баркашиданд';

  @override
  String get weightNotes => 'Қайдҳо';

  @override
  String get weightSaved => 'Вазн сабт шуд';

  @override
  String get weightSaveFailed => 'Сабт кардани вазн муяссар нашуд';

  @override
  String get galleryTitle => 'Галереяи расмҳо';

  @override
  String get galleryEmptyTitle => 'Расм ҳанӯз нест';

  @override
  String get galleryEmptyBody =>
      'Расм илова кунед — дар корт як расм мемонад, вале ин ҷо ҳама ҷо мегиранд.';

  @override
  String get galleryAdd => 'Расм илова кардан';

  @override
  String get galleryUploaded => 'Расм илова шуд';

  @override
  String get galleryCaptionTitle => 'Тавзеҳ ба расм';

  @override
  String get galleryCaptionLabel => 'Масалан, «Пас аз буридани мӯй»';

  @override
  String get galleryCaptionSkip => 'Бе тавзеҳ';

  @override
  String get galleryDeleteTitle => 'Расмро нест кунем?';

  @override
  String get galleryDeleteBody => 'Баргардонидани он имконнопазир мешавад.';

  @override
  String get galleryDeleted => 'Расм нест карда шуд';

  @override
  String get pedigreeTitle => 'Насаб';

  @override
  String get rabbitDetailEdit => 'Тағйир додан';

  @override
  String get rabbitDetailDeleteTitle => 'Харгӯшро нест кунем?';

  @override
  String rabbitDetailDeleteBody(String name) {
    return 'Ҳамроҳи $name вазнкуниҳо, эмкуниҳо ва сабтҳои муолиҷаи он ҳам нест мешаванд.';
  }

  @override
  String get rabbitDetailDeleted => 'Харгӯш нест карда шуд';

  @override
  String get rabbitDetailDeleteFailed => 'Нест кардани харгӯш муяссар нашуд';

  @override
  String get settingsTitle => 'Танзимот';

  @override
  String get healthTitle => 'Саломатӣ';

  @override
  String get healthMenuLabel => 'Эмкунӣ ва муолиҷа';

  @override
  String get healthKindAll => 'Ҳама';

  @override
  String get healthKindVaccination => 'Эмкуниҳо';

  @override
  String get healthKindTreatment => 'Муолиҷа';

  @override
  String get healthEntryVaccination => 'Эмкунӣ';

  @override
  String get healthEntryTreatment => 'Муолиҷа';

  @override
  String get healthPickRabbit => 'Таърихи як харгӯш';

  @override
  String get healthEmptyTitle => 'Саломатии чорво ҳанӯз сабт нашудааст';

  @override
  String get healthEmptyBody =>
      'Эмкунӣ ва муолиҷаро қайд кунед — маълум мешавад, бо ҳар харгӯш чӣ будааст ва кай боз эм кардан лозим.';

  @override
  String get healthNoneInViewTitle => 'Дар ин интихоб чизе нест';

  @override
  String healthNoneForRabbitTitle(String name) {
    return '$name сабти саломатӣ надорад';
  }

  @override
  String get healthNoneInViewBody =>
      'Филтрро бардоред — сабтҳои дигар ҷои худ ҳастанд.';

  @override
  String get healthRecordTitle => 'Чиро сабт кунем?';

  @override
  String get healthRecordVaccination => 'Эмкунӣ';

  @override
  String get healthRecordTreatment => 'Муолиҷа';

  @override
  String get farmSectionMoney => 'Пул';

  @override
  String get farmTransactions => 'Даромад ва харҷ';

  @override
  String get farmSectionFeed => 'Хӯрок';

  @override
  String get farmFeedStock => 'Захираи хӯрок';

  @override
  String get farmFeedingRecords => 'Хӯрокдиҳиҳо';

  @override
  String get farmSectionHealth => 'Саломатӣ';

  @override
  String get farmSectionReports => 'Ҳисоботҳо';

  @override
  String get farmReports => 'Хулосаи ферма';

  @override
  String get farmSectionPeople => 'Одамон';

  @override
  String get farmStaff => 'Кормандон';

  @override
  String get farmSectionApp => 'Барнома';

  @override
  String get farmSettings => 'Танзимот';

  @override
  String get farmAbout => 'Дар бораи барнома';

  @override
  String get farmAboutBody =>
      'Ҳисоби шумораи харгӯшҳо, хӯрок, саломатӣ ва пули фермаи харгӯшпарварӣ.';

  @override
  String get farmLogout => 'Баромадан';

  @override
  String get settingsAppearance => 'Намуди зоҳирӣ';

  @override
  String get settingsTheme => 'Мавзӯъ';

  @override
  String get settingsAccent => 'Ранги акцент';

  @override
  String get settingsLanguage => 'Забон';

  @override
  String get settingsNotifications => 'Огоҳиномаҳо';

  @override
  String get settingsDigestToggle => 'Хулосаи ҳаррӯзаи хоҷагӣ';

  @override
  String get settingsAbout => 'Дар бораи барнома';

  @override
  String get settingsVersion => 'Версия';

  @override
  String get settingsSupport => 'Ба дастгирӣ навиштан';

  @override
  String get supportRequestTitle => 'Дастгирӣ';

  @override
  String get supportRequestHint =>
      'Чӣ рӯй додаро тасвир кунед — аз ҳамон ҳисобе, ки мурожиат омад, ҷавоб медиҳем.';

  @override
  String get supportRequestPlaceholder =>
      'Масалан: харгӯш илова намешавад — барнома ҳангоми захира қатъ мешавад';

  @override
  String get supportRequestTooShort =>
      'Мушкилро муфассалтар тасвир кунед — ҳадди ақал 10 ҳарф';

  @override
  String get supportRequestSend => 'Фиристодан';

  @override
  String get supportRequestSent => 'Мурожиат фиристода шуд';

  @override
  String get supportContactHint => 'Ё бевосита алоқа кунед:';

  @override
  String get settingsPrivacyPolicy => 'Сиёсати махфият';

  @override
  String get settingsLogout => 'Аз ҳисоб баромадан';

  @override
  String get settingsThemeLight => 'Равшан';

  @override
  String get settingsThemeSystem => 'Мисли система';

  @override
  String get settingsThemeDark => 'Торик';

  @override
  String get settingsSubscription => 'Тариф';

  @override
  String get subscriptionTitle => 'Тариф';

  @override
  String get subscriptionNoPlan => 'Тариф таъин нашудааст';

  @override
  String get subscriptionNoPlanHint =>
      'Барои пайваст кардани тариф ба дастгирӣ муроҷиат кунед.';

  @override
  String get subscriptionContactSupport => 'Ба дастгирӣ навиштан';

  @override
  String get subscriptionFree => 'Тарифи ройгон';

  @override
  String get subscriptionForever => 'Бемуҳлат';

  @override
  String subscriptionExpiresOn(String date) {
    return 'То $date амал мекунад';
  }

  @override
  String subscriptionExpired(String date) {
    return 'Мӯҳлаташ $date гузашт';
  }

  @override
  String subscriptionPricePerPeriod(String price) {
    return '$price сомонӣ / 30 рӯз';
  }

  @override
  String get subscriptionPay => 'Пардохт кардан';

  @override
  String get subscriptionOpenPaymentPage => 'Саҳифаи пардохтро кушодан';

  @override
  String get subscriptionAfterPayingHint =>
      'Бо ҳамон истинод пардохт кунед, баъд ба ин ҷо баргардед ва «Пардохтро санҷидан»-ро зер кунед.';

  @override
  String get subscriptionCheckPayment => 'Пардохтро санҷидан';

  @override
  String get subscriptionPaymentCompleted => 'Пардохт гузашт, тариф дароз шуд';

  @override
  String get subscriptionPaymentPending =>
      'Бонк ҳанӯз пардохтро тасдиқ накардааст — пас аз як дақиқа боз кӯшиш кунед';

  @override
  String get joinTitle => 'Ба ферма ҳамроҳ шудан';

  @override
  String get joinIntro =>
      'Рамзро соҳиби ферма медиҳад. Пас аз вуруд шумо хоҷагии ӯро мебинед — шумораи харгӯшҳо, хӯрок ва вазифаҳо.';

  @override
  String get joinCode => 'Рамзи даъватнома';

  @override
  String get joinCodeHint => 'Рамзеро, ки соҳиб додааст, ворид кунед';

  @override
  String get joinName => 'Номи шумо';

  @override
  String get joinNameHint => 'Шуморо чӣ хел ном барем?';

  @override
  String get joinPassword => 'Парол';

  @override
  String get joinPasswordHint => 'На камтар аз 8 ҳарф';

  @override
  String get joinPasswordShort => 'Парол бояд на камтар аз 8 ҳарф бошад';

  @override
  String get joinSubmit => 'Ҳамроҳ шудан';

  @override
  String get joinHaveAccount => 'Ман аллакай ҳисоб дорам';

  @override
  String get splashTagline => 'Идораи ферма';

  @override
  String get registerTitle => 'Фермаи худ';

  @override
  String get registerSubtitle =>
      'Ферма кушоед — ба коргарон дастрасиро баъдтар медиҳед';

  @override
  String get registerFarmName => 'Номи ферма';

  @override
  String get registerFarmNameHint =>
      'Метавонед холӣ монед — бо номи шумо мегузорем. Баъдан номро иваз кардан мумкин нест';

  @override
  String get registerFarmNameShort => 'Хеле кӯтоҳ';

  @override
  String get registerFullName => 'Ном ва насаб';

  @override
  String get registerFullNameHint => 'Номи шумо чист';

  @override
  String get registerFullNameEmpty => 'Номро ворид кунед';

  @override
  String get registerFullNameShort => 'Хеле кӯтоҳ';

  @override
  String get registerEmailEmpty => 'Почтаро ворид кунед';

  @override
  String get registerEmailInvalid => 'Дар суроға хато ба назар мерасад';

  @override
  String get registerPhone => 'Телефон, агар лозим бошад';

  @override
  String get registerPasswordHint => 'На камтар аз 8 ҳарф';

  @override
  String get registerPasswordEmpty => 'Паролро фикр кунед';

  @override
  String get registerPasswordShort => 'Парол бояд на камтар аз 8 ҳарф бошад';

  @override
  String get registerPasswordRepeat => 'Паролро такрор кунед';

  @override
  String get registerPasswordRepeatEmpty => 'Паролро боз ворид кунед';

  @override
  String get registerPasswordMismatch => 'Паролҳо мувофиқат намекунанд';

  @override
  String get registerSubmit => 'Ферма кушодан';

  @override
  String get registerHaveAccount => 'Ҳисоб аллакай доред?';

  @override
  String get registerFailed => 'Бақайдгирӣ муяссар нашуд';

  @override
  String get registerConsentPrefix => 'Ман қабул мекунам ';

  @override
  String get registerConsentLink => 'сиёсати махфиятро';

  @override
  String get registerConsentRequired =>
      'Барои идома додан бояд сиёсати махфиятро қабул кунед';

  @override
  String get birthsTitle => 'Таваллудҳо';

  @override
  String get birthsEmptyTitle => 'Таваллуд ҳанӯз нест';

  @override
  String get birthsEmptyBody =>
      'Таваллудро сабт кунед — барнома худ ба харгӯшчаҳо корт кушояд.';

  @override
  String get birthsAdd => 'Таваллудро сабт кардан';

  @override
  String get birthsMotherUnknown => 'Модар ишора нашудааст';

  @override
  String birthsMotherLine(String name) {
    return 'Модар: $name';
  }

  @override
  String get birthsFromBreeding => 'Аз рӯи сабти ҷуфтгирӣ';

  @override
  String get birthsAlive => 'Зинда';

  @override
  String get birthsDead => 'Мурда';

  @override
  String get birthsWeaned => 'Ҷудошуда';

  @override
  String get birthsSurvival => 'Зиндамонӣ';

  @override
  String get birthsComplications => 'Душворӣ';

  @override
  String get birthsDeleteTitle => 'Сабти таваллудро нест кунем?';

  @override
  String get birthsDeleteBody =>
      'Картаҳои харгӯшчаҳо мемонанд — танҳо сабти худи таваллуд нест мешавад.';

  @override
  String get birthsDeleted => 'Сабт нест карда шуд';

  @override
  String get birthsDeleteFailed => 'Нест кардани сабт муяссар нашуд';

  @override
  String get birthsCreateKits => 'Ба харгӯшчаҳо корт кушодан';

  @override
  String get birthsKitsDialogTitle => 'Ба харгӯшчаҳо корт кушоем?';

  @override
  String birthsKitsDialogBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count корт кушода мешавад',
    );
    return '$_temp0';
  }

  @override
  String get birthsNamePrefix => 'Аввали ном';

  @override
  String get birthsNamePrefixHint => 'Масалан, Тулпор-';

  @override
  String birthsNamePreview(String first, String second) {
    return 'Чунин мешавад: $first, $second, …';
  }

  @override
  String birthsKitsCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count корт кушода шуд',
    );
    return '$_temp0';
  }

  @override
  String get birthsKitsFailed => 'Кушодани картаҳо муяссар нашуд';

  @override
  String get birthFormNewTitle => 'Таваллуди нав';

  @override
  String get birthFormEditTitle => 'Таваллуд';

  @override
  String get birthFormMother => 'Модар';

  @override
  String get birthFormDate => 'Кай зоид';

  @override
  String get birthFormSectionLitter => 'Насл';

  @override
  String get birthFormAliveLabel => 'Зинда таваллуд шуд';

  @override
  String get birthFormDeadLabel => 'Мурда таваллуд шуд';

  @override
  String get birthFormAliveEmpty => 'Миқдорро ворид кунед';

  @override
  String get birthFormComplications => 'Душворӣ';

  @override
  String get birthFormComplicationsHint =>
      'Агар чизе нодуруст рафта бошад, тасвир кунед';

  @override
  String get birthFormNotes => 'Қайдҳо';

  @override
  String get birthFormAutoKits => 'Дарҳол ба харгӯшчаҳо корт кушодан';

  @override
  String get birthFormCreated => 'Таваллуд сабт шуд';

  @override
  String get birthFormUpdated => 'Сабт нав карда шуд';

  @override
  String get birthFormFailed => 'Захира кардани сабт муяссар нашуд';

  @override
  String get breedsTitle => 'Зотҳо';

  @override
  String get breedsSearchHint => 'Номи зот';

  @override
  String get breedsAdd => 'Зот илова кардан';

  @override
  String get breedsEmptyTitle => 'Зот ҳанӯз нест';

  @override
  String get breedsEmptyBody =>
      'Зотҳо кушоед — бо онҳо ҷуфт интихоб кардан ва афзоиши вазнро муқоиса кардан осон мешавад.';

  @override
  String get breedsNothingFound => 'Чизе ёфт нашуд';

  @override
  String get breedsNothingFoundBody => 'Дархостро санҷед.';

  @override
  String get breedsDeleteTitle => 'Зотро нест кунем?';

  @override
  String breedsDeleteBody(String name) {
    return '«$name» аз феҳрист нест мешавад. Харгӯшони ин зот мемонанд, вале бе зот.';
  }

  @override
  String get breedsDeleted => 'Зот нест карда шуд';

  @override
  String get breedsDeleteFailed => 'Нест кардани зот муяссар нашуд';

  @override
  String get breedPurposeMeat => 'Гӯштӣ';

  @override
  String get breedPurposeFur => 'Пуштӣ';

  @override
  String get breedPurposeDecorative => 'Оройишӣ';

  @override
  String get breedPurposeCombined => 'Гӯшту пуст';

  @override
  String get breedFormNewTitle => 'Зоти нав';

  @override
  String get breedFormEditTitle => 'Зот';

  @override
  String get breedFormName => 'Ном';

  @override
  String get breedFormNameHint => 'Масалан, Калифорнягӣ';

  @override
  String get breedFormNameEmpty => 'Номи зотро ворид кунед';

  @override
  String get breedFormPurpose => 'Барои чӣ парвариш мекунанд';

  @override
  String get breedFormDescription => 'Тавсиф';

  @override
  String get breedFormDescriptionHint => 'Ин зот бо чӣ фарқ мекунад';

  @override
  String get breedFormSectionTraits => 'Хусусиятҳо';

  @override
  String get breedFormWeight => 'Вазни миёна, кг';

  @override
  String get breedFormWeightHint => 'Масалан, 4,5';

  @override
  String get breedFormLitter => 'Андозаи маъмулии насл';

  @override
  String get breedFormLitterHint => 'Масалан, 8';

  @override
  String get breedFormLitterSuffix => 'харгӯшча';

  @override
  String get breedFormCreated => 'Зот илова шуд';

  @override
  String get breedFormUpdated => 'Зот нав карда шуд';

  @override
  String get breedFormFailed => 'Захира кардани зот муяссар нашуд';

  @override
  String get breedingDetailTitle => 'Ҷуфтгирӣ';

  @override
  String get breedingStatus => 'Ҳолат';

  @override
  String get breedingParents => 'Ҷуфт';

  @override
  String breedingTag(String tag) {
    return 'Нишонаи $tag';
  }

  @override
  String get breedingDates => 'Санаҳо';

  @override
  String get breedingDate => 'Санаи ҷуфтгирӣ';

  @override
  String get breedingExpected => 'Таваллуди интизоршаванда';

  @override
  String get breedingPalpation => 'Санаи ламскунӣ';

  @override
  String get breedingPregnancy => 'Ҳомиладорӣ';

  @override
  String get breedingPregnancyYes => 'Тасдиқ шуд';

  @override
  String get breedingPregnancyNo => 'Тасдиқ нашуд';

  @override
  String get breedingNotes => 'Қайдҳо';

  @override
  String get breedingRegisterBirth => 'Таваллудро сабт кардан';

  @override
  String get breedingDeleteTitle => 'Сабти ҷуфтгириро нест кунем?';

  @override
  String get breedingDeleteBody => 'Баргардонидани он имконнопазир мешавад.';

  @override
  String get breedingDeleted => 'Сабт нест карда шуд';

  @override
  String get breedingDeleteFailed => 'Нест кардани сабт муяссар нашуд';

  @override
  String get breedingFormNewTitle => 'Ҷуфтгирии нав';

  @override
  String get breedingFormEditTitle => 'Ҷуфтгирӣ';

  @override
  String get breedingFormPrefilled => 'Ҷуфт аз интихоби ҷуфтҳо гирифта шуд';

  @override
  String get breedingFormMale => 'Нар';

  @override
  String get breedingFormFemale => 'Мода';

  @override
  String get breedingFormMaleRequired => 'Нарро интихоб кунед';

  @override
  String get breedingFormFemaleRequired => 'Модаро интихоб кунед';

  @override
  String get breedingFormNotesHint =>
      'Дар бораи ин ҷуфтгирӣ чиро дар ёд нигоҳ доштан лозим';

  @override
  String get breedingFormCreated => 'Ҷуфтгирӣ сабт шуд';

  @override
  String get breedingFormUpdated => 'Сабт нав карда шуд';

  @override
  String get breedingFormFailed => 'Захира кардани сабт муяссар нашуд';

  @override
  String get plannerTitle => 'Интихоби ҷуфтҳо';

  @override
  String get plannerIntro =>
      'Нар ва модаро интихоб кунед — барнома насабро дида, дараҷаи хешигиашонро мегӯяд.';

  @override
  String get plannerAnalysisFailed => 'Таҳлили насаб муяссар нашуд';

  @override
  String get plannerResults => 'Натиҷа';

  @override
  String get plannerCoefficient => 'Дараҷаи хешӣ';

  @override
  String get plannerCommonAncestors => 'Аҷдодони муштарак';

  @override
  String plannerGenerations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count насл',
    );
    return '$_temp0 пеш';
  }

  @override
  String get plannerAdvice => 'Чӣ кор кардан лозим';

  @override
  String get plannerPickBoth => 'Ҳар дуяшонро интихоб кунед';

  @override
  String get plannerPlanned => 'Ҷуфтгирӣ ба нақша гирифта шуд';

  @override
  String get plannerPlan => 'Ҷуфтгириро ба нақша гирифтан';

  @override
  String get plannerPedigreeFailed => 'Бор кардани насаб муяссар нашуд';

  @override
  String get staffTitle => 'Кормандон';

  @override
  String get staffInvite => 'Даъват кардан';

  @override
  String get staffOwner => 'Соҳиб';

  @override
  String get staffMembers => 'Кормандон';

  @override
  String get staffEmptyBody =>
      'Дар ферма ҳанӯз танҳо шумо ҳастед. Ёридиҳанда даъват кунед — ӯ ба ҳамин хоҷагӣ дастрасӣ мегирад.';

  @override
  String get staffInvitesFailed => 'Бор кардани даъватномаҳо муяссар нашуд';

  @override
  String get staffPendingInvites => 'Интизори ҷавоб';

  @override
  String staffAccessClosed(String name) {
    return 'Дастрасии $name баста шуд';
  }

  @override
  String get staffSaved => 'Тағйирот захира шуд';

  @override
  String get staffResetPasswordTitle => 'Паролро бознишонем?';

  @override
  String get staffResetPasswordBody =>
      'Пароли пешина кор намекунад. Ба ҷои он барнома пароли муваққатӣ медиҳад — онро ба одам расонед.';

  @override
  String get staffReset => 'Бознишондан';

  @override
  String get staffTempPassword => 'Пароли муваққатӣ';

  @override
  String staffTempPasswordBody(String name) {
    return 'Паролро ба $name расонед. Дуюмбор нишон дода намешавад — агар лозим шавад, боз бознишонед.';
  }

  @override
  String get staffRevokeTitle => 'Даъватномаро бекор кунем?';

  @override
  String staffRevokeBody(String email) {
    return 'Рамз барои $email кор намекунад. Ҳар вақт хоҳед, рамзи нав баровардан мумкин аст.';
  }

  @override
  String get staffKeep => 'Гузоштан';

  @override
  String get staffRevoke => 'Бекор кардан';

  @override
  String get staffRevoked => 'Даъватнома бекор карда шуд';

  @override
  String get planLimitStaffTitle => 'Ҳадди аъзо аз рӯи тариф';

  @override
  String get planLimitStaffBody =>
      'Таркиби ферма ба ҳадди аъзои иҷозатдодаи тарифи ҳозира расид. Барои даъвати боз як нафар, тарифи бо ҳадди калонтар лозим аст.';

  @override
  String get staffInviteTitle => 'Ба ферма даъват кардан';

  @override
  String get staffInviteEmailHint => 'Одам аз ин почта ворид мешавад';

  @override
  String get staffRole => 'Вазифа';

  @override
  String get staffIssueCode => 'Рамз баровардан';

  @override
  String get staffInviteCode => 'Рамзи даъватнома';

  @override
  String get staffInviteChannelPhone => 'Бо телефон';

  @override
  String get staffInviteChannelEmail => 'Бо почта';

  @override
  String get staffInvitePhoneHint => '+992 XX XXX XX XX';

  @override
  String get staffInvitePhoneInvalid => 'Рақам ба монанди +992 90 123 45 67';

  @override
  String get staffInviteNameLabel => 'Номи коргар';

  @override
  String get staffInviteNameHint => 'Бо ҳамин ном дар ферма пайдо мешавад';

  @override
  String get staffInviteNameEmpty => 'Номи коргарро нишон диҳед';

  @override
  String staffInviteCodeSmsBody(String phone) {
    return 'Рамз бо SMS ба $phone фиристода шуд. Коргар ҳангоми вуруд ҳамин рақам ва рамзи паёмро ворид мекунад — дигар чизе лозим нест. Агар SMS нарасад, рамзро худатон расонед: дуюмбор нишон дода намешавад.';
  }

  @override
  String staffInviteCodeBody(String email) {
    return 'Ин рамзро ба $email бо роҳи мувофиқ расонед. Дуюмбор нишон дода намешавад: сервер танҳо изи онро нигоҳ медорад.';
  }

  @override
  String staffValidUntil(String date) {
    return 'То $date амал мекунад';
  }

  @override
  String get staffMakeManager => 'Мудир таъин кардан';

  @override
  String get staffMakeWorker => 'Коргар таъин кардан';

  @override
  String get staffResetPassword => 'Паролро бознишондан';

  @override
  String get staffOpenAccess => 'Дастрасиро кушодан';

  @override
  String get staffCloseAccess => 'Дастрасиро бастан';

  @override
  String get staffTransferOwnership => 'Хоҷагиро супоридан';

  @override
  String get staffTransferTitle => 'Хоҷагиро супорем?';

  @override
  String staffTransferBody(String name) {
    return 'Ферма ба $name мегузарад, шумо мудир мешавед. Инро бекор кардан имконнопазир аст.';
  }

  @override
  String get staffTransferConfirm => 'Фермаро супоридан';

  @override
  String staffTransferred(String name) {
    return 'Хоҷагӣ ба $name супорида шуд';
  }

  @override
  String get rabbitTapToZoom => 'Барои калон дидан зер кунед';

  @override
  String rabbitTagLine(String tag) {
    return 'Нишонаи $tag';
  }

  @override
  String get rabbitMainInfo => 'Асосӣ';

  @override
  String get rabbitBreed => 'Зот';

  @override
  String get rabbitBreedUnknown => 'Ишора нашудааст';

  @override
  String get rabbitSex => 'Ҷинс';

  @override
  String get rabbitAge => 'Синну сол';

  @override
  String get rabbitBirthDate => 'Санаи таваллуд';

  @override
  String get rabbitColor => 'Ранг';

  @override
  String get rabbitWeight => 'Вазн';

  @override
  String get rabbitQuickActions => 'Чиро дидан мумкин';

  @override
  String get rabbitWeightHistory => 'Таърихи вазнкунӣ';

  @override
  String get rabbitPedigree => 'Насаб';

  @override
  String get rabbitStatus => 'Ҳолат';

  @override
  String get rabbitCondition => 'Ҳолат';

  @override
  String get rabbitPurpose => 'Мақсад';

  @override
  String get rabbitPlacement => 'Дар куҷо зиндагӣ мекунад';

  @override
  String get rabbitCage => 'Қафас';

  @override
  String get rabbitLocation => 'Ҷой';

  @override
  String get rabbitParents => 'Волидон';

  @override
  String get rabbitFather => 'Падар';

  @override
  String get rabbitMother => 'Модар';

  @override
  String get rabbitNotes => 'Қайдҳо';

  @override
  String get rabbitDates => 'Сабтҳо';

  @override
  String get rabbitCreatedAt => 'Кушода шуд';

  @override
  String get rabbitUpdatedAt => 'Тағйир ёфт';

  @override
  String get purposeBreeding => 'Барои насл';

  @override
  String get purposeMeat => 'Барои гӯшт';

  @override
  String get purposeFur => 'Барои пӯст';

  @override
  String get purposeSale => 'Барои фурӯш';

  @override
  String get purposePet => 'Ҳайвони хонагӣ';

  @override
  String get rabbitFormNewTitle => 'Харгӯши нав';

  @override
  String get rabbitFormEditTitle => 'Харгӯш';

  @override
  String get rabbitFormPhotoAdd => 'Расм илова кардан';

  @override
  String get rabbitFormPhotoChange => 'Расмро иваз кардан';

  @override
  String get rabbitFormPhotoGallery => 'Аз галерея интихоб кардан';

  @override
  String get rabbitFormPhotoCamera => 'Бо камера гирифтан';

  @override
  String get rabbitFormPhotoRemove => 'Расмро бардоштан';

  @override
  String get rabbitFormPhotoFailed => 'Гирифтани расм муяссар нашуд';

  @override
  String get rabbitFormName => 'Ном';

  @override
  String get rabbitFormNameHint => 'Номаш чист';

  @override
  String get rabbitFormNameEmpty => 'Номро ворид кунед';

  @override
  String get rabbitFormTag => 'Рақами нишона';

  @override
  String get rabbitFormTagEmpty => 'Рақами нишонаро ворид кунед';

  @override
  String get rabbitFormBreedRequired => 'Зотро интихоб кунед';

  @override
  String get rabbitFormBreedsFailed => 'Бор кардани зотҳо муяссар нашуд';

  @override
  String get rabbitFormColor => 'Ранг';

  @override
  String get rabbitFormColorHint => 'Хокистарӣ, сафед, сиёҳ…';

  @override
  String get rabbitFormWeight => 'Вазн, кг';

  @override
  String get rabbitFormNotes => 'Қайдҳо';

  @override
  String get rabbitFormNotesHint =>
      'Дар бораи ин харгӯш чиро дар ёд нигоҳ доштан лозим';

  @override
  String get rabbitFormCreated => 'Харгӯш илова шуд';

  @override
  String get rabbitFormUpdated => 'Маълумот нав карда шуд';

  @override
  String get rabbitFormFailed => 'Захира кардан муяссар нашуд';

  @override
  String get rabbitFormLoadFailed => 'Бор кардани харгӯш муяссар нашуд';

  @override
  String get planLimitRabbitsTitle => 'Ҳадди харгӯшҳо аз рӯи тариф';

  @override
  String get planLimitRabbitsBody =>
      'Ферма ба ҳадди харгӯшҳои иҷозатдодаи тарифи ҳозира расид. Барои илова кардани боз, тарифи бо ҳадди калонтар лозим аст — ба соҳиби ферма муроҷиат кунед.';

  @override
  String get statusHealthy => 'Сиҳат';

  @override
  String get statusSick => 'Бемор';

  @override
  String get statusQuarantine => 'Карантин';

  @override
  String get statusPregnant => 'Ҳомиладор';

  @override
  String get statusSold => 'Фурӯхташуда';

  @override
  String get statusDead => 'Мурдааст';

  @override
  String get purposeShow => 'Барои намоиш';

  @override
  String periodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рӯз',
    );
    return '$_temp0';
  }

  @override
  String periodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count моҳ',
    );
    return '$_temp0';
  }

  @override
  String get periodYear => 'Сол';

  @override
  String get periodAll => 'Тамоми вақт';

  @override
  String get statusInactive => 'Фаъол нест';

  @override
  String get pedigreeSelf => 'Харгӯш';

  @override
  String get pedigreeGrandparents => 'Бобою бибиҳо';

  @override
  String get pedigreeFathersParents => 'Волидони падар';

  @override
  String get pedigreeMothersParents => 'Волидони модар';

  @override
  String get pedigreeHint => 'Барои кушодани харгӯш ба корт зер кунед';

  @override
  String get pedigreeGrandfather => 'Бобо';

  @override
  String get pedigreeGrandmother => 'Биби';

  @override
  String get chartNoData => 'Ҳанӯз чизе барои нишон додан нест';

  @override
  String get chartWeight => 'Графики вазн';

  @override
  String get feedStatsTitle => 'Анбор дар рақамҳо';

  @override
  String get feedStatsEmptyTitle => 'Анбор ҳанӯз холӣ аст';

  @override
  String get feedStatsEmptyBody =>
      'Хӯрок кушоед — дар ин ҷо таркиби захира, арзиши он ва огоҳиномаҳо дар бораи миқдор пайдо мешаванд.';

  @override
  String get feedStatsPositions => 'Намуди хӯрок';

  @override
  String get feedStatsLow => 'Рӯ ба тамом';

  @override
  String get feedStatsValue => 'Арзиши захира';

  @override
  String get feedStatsByType => 'Таркиб аз рӯи навъ';

  @override
  String get feedStatsLowList => 'Захираҳои рӯ ба тамом';

  @override
  String get feedStatsAllGood => 'Захира барои ҳамаи мавқеъҳо кифоя аст';

  @override
  String feedStatsMinimum(String amount) {
    return 'ҳадди ақал $amount';
  }

  @override
  String get feedingStatsTitle => 'Хӯрокдиҳиҳо дар рақамҳо';

  @override
  String get feedingStatsEmptyTitle => 'Дар ин давра хӯрокдиҳӣ набудааст';

  @override
  String get feedingStatsEmptyBody =>
      'Давраи васеътарро интихоб кунед ё хӯрокдиҳиро сабт кунед — сарф ва харҷи хӯрок худ ҳисоб мешавад.';

  @override
  String get feedingStatsCount => 'Хӯрокдиҳиҳо';

  @override
  String get feedingStatsCost => 'Харҷи хӯрок';

  @override
  String get feedingStatsGiven => 'Дода шуд';

  @override
  String get feedingStatsByFeed => 'Аз рӯи хӯрок';

  @override
  String feedingStatsChartTitle(String unit) {
    return 'Сарф аз рӯи навъи хӯрок, $unit';
  }

  @override
  String get feedingStatsChartTitlePlain => 'Сарф аз рӯи навъи хӯрок';

  @override
  String get financeStatsTitle => 'Молия дар рақамҳо';

  @override
  String get financeStatsEmptyTitle => 'Дар ин давра амалиёт набудааст';

  @override
  String get financeStatsEmptyBody =>
      'Давраи васеътарро интихоб кунед ё амалиёти аввалро сабт кунед — натиҷа худ ҳисоб мешавад.';

  @override
  String get financeProfit => 'Фоида';

  @override
  String get financeLoss => 'Зиён';

  @override
  String get financeIncomeByCategory => 'Даромад аз рӯи категория';

  @override
  String get financeExpensesByCategory => 'Харҷ аз рӯи категория';

  @override
  String get financeRecent => 'Амалиёти охирин';

  @override
  String get txCategorySaleRabbit => 'Фурӯши харгӯш';

  @override
  String get txCategorySaleMeat => 'Фурӯши гӯшт';

  @override
  String get txCategorySaleFur => 'Фурӯши пӯст';

  @override
  String get txCategoryBreedingFee => 'Ҳаққи ҷуфтгирӣ';

  @override
  String get txCategoryFeed => 'Хӯрок';

  @override
  String get txCategoryVeterinary => 'Муолиҷа';

  @override
  String get txCategoryEquipment => 'Таҷҳизот';

  @override
  String get txCategoryUtilities => 'Барқ, об, гармидиҳӣ';

  @override
  String get txCategoryOther => 'Дигар';

  @override
  String get reportsOutcomeUnknown => 'Натиҷа ишора нашудааст';

  @override
  String get reportsFeedUsed => 'Сарф шуд';

  @override
  String get reportsTabFarm => 'Ферма';

  @override
  String get reportsTabHealth => 'Саломатӣ';

  @override
  String get reportsTabFinance => 'Пул';

  @override
  String reportsPeriodRange(String from, String to) {
    return 'Аз $from то $to';
  }

  @override
  String get reportsPopulationNow => 'Харгӯшҳо ҳозир';

  @override
  String get reportsBirths => 'Таваллудҳо';

  @override
  String get reportsBreedings => 'Ҷуфтгириҳо';

  @override
  String get reportsVaccinations => 'Эмкуниҳо';

  @override
  String get reportsMedicalRecords => 'Муолиҷа';

  @override
  String get reportsFeedings => 'Хӯрокдиҳиҳо';

  @override
  String get reportsActivity => 'Барои давра';

  @override
  String get reportsByBreed => 'Шумораи харгӯшҳо аз рӯи зот';

  @override
  String reportsBreedUnknown(int id) {
    return 'Зоти №$id';
  }

  @override
  String get reportsMoney => 'Пул барои давра';

  @override
  String get reportsNoActivityTitle => 'Дар ин давра сабт нест';

  @override
  String get reportsNoActivityBody =>
      'Давраи васеътарро интихоб кунед — ё ҷуфтгирӣ, эмкунӣ, хӯрокдиҳиро сабт кунед, ва онҳо ин ҷо пайдо мешаванд.';

  @override
  String get reportsFarmEmptyTitle => 'Ҳанӯз чизе барои ҳисобот нест';

  @override
  String get reportsFarmEmptyBody =>
      'Харгӯши аввалро илова кунед — минбаъд ҳисобот худ аз сабтҳои ҳаррӯза ҷамъ мешавад.';

  @override
  String get reportsHealthEmptyTitle =>
      'Дар ин давра эмкунӣ ва муолиҷа набудааст';

  @override
  String get reportsHealthEmptyBody =>
      'Давраи васеътарро интихоб кунед ё эмкуниро қайд кунед — ҳисобот худ ҳисоб мешавад.';

  @override
  String get reportsVaccinesByName => 'Эмкуниҳо аз рӯи ваксина';

  @override
  String get reportsRecordsByOutcome => 'Муолиҷа аз рӯи натиҷа';

  @override
  String get farmSectionPlatform => 'Платформа';

  @override
  String get farmPlatformAdmin => 'Фермаҳо ва тарифҳо';

  @override
  String get platformTitle => 'Платформа';

  @override
  String get platformTabSummary => 'Хулоса';

  @override
  String get platformTabFarms => 'Фермаҳо';

  @override
  String get platformTabPlans => 'Тарифҳо';

  @override
  String get platformTabAnnouncements => 'Эълонҳо';

  @override
  String get platformTabSupport => 'Мурожиатҳо';

  @override
  String get platformSummarySectionFarms => 'Фермаҳо';

  @override
  String get platformSummarySectionStatus => 'Ҳолат';

  @override
  String get platformSummarySectionActivity => 'Фаъолият';

  @override
  String get platformSummarySectionData => 'Маълумот';

  @override
  String get platformSummaryTotalFarms => 'Ҳамагӣ фермаҳо';

  @override
  String get platformSummaryFree => 'Дар тарифи ройгон';

  @override
  String get platformSummaryPaid => 'Дар тарифи пулакӣ';

  @override
  String get platformSummaryExpired => 'Мӯҳлати тариф гузашт';

  @override
  String get platformSummaryAtLimit => 'Ба ҳадди тариф расид';

  @override
  String get platformSummaryRegistrations30d => 'Бақайдгирӣ дар 30 рӯз';

  @override
  String get platformSummaryRabbitsTotal => 'Шумораи харгӯшҳо ҳамагӣ';

  @override
  String get platformSummaryStorageTotal => 'Ҷой ҳамагӣ';

  @override
  String countFarms(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ферма',
    );
    return '$_temp0';
  }

  @override
  String countAnnouncements(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count эълон',
    );
    return '$_temp0';
  }

  @override
  String get platformFarmsEmptyTitle => 'Ферма ҳанӯз нест';

  @override
  String get platformFarmsEmptyBody =>
      'Дар ин ҷо ҳамаи хоҷагиҳои хизмат мебошанд — онҳо худ пайдо мешаванд, ҳамин ки касе бақайд гирад.';

  @override
  String get platformFarmsNothingFound => 'Чизе ёфт нашуд';

  @override
  String get platformFarmsNothingFoundBody =>
      'Дархостро санҷед ё филтрро бардоред.';

  @override
  String get platformOwnerMissing => 'Соҳиб таъин нашудааст';

  @override
  String get platformNoPlan => 'Бе тариф';

  @override
  String get platformNoPlanHint => 'Маҳдудият нест';

  @override
  String get platformRabbits => 'Харгӯшҳо';

  @override
  String get platformStaff => 'Одамон';

  @override
  String platformUsageOfLimit(int used, int limit) {
    return '$used аз $limit';
  }

  @override
  String platformUsageUnlimited(int used) {
    return '$used, бе ҳад';
  }

  @override
  String get platformAtLimit => 'Ба ҳадди тариф расид';

  @override
  String get platformNearLimit => 'Ба ҳадди тариф наздик мешавад';

  @override
  String get platformFarmsSearchHint => 'Ферма, соҳиб, почта, телефон';

  @override
  String platformFilterInactive(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days рӯз ворид нашудаанд',
    );
    return '$_temp0';
  }

  @override
  String get platformFilterExpired => 'Тариф мӯҳлаташ гузашт';

  @override
  String platformFilterUnknown(String filter) {
    return 'Буриши номаълум: $filter';
  }

  @override
  String get platformChangePlan => 'Тарифро иваз кардан';

  @override
  String get platformAssignPlan => 'Тариф таъин кардан';

  @override
  String platformPlanSheetTitle(String farm) {
    return 'Тарифи хоҷагии «$farm»';
  }

  @override
  String get platformPlanOff => 'Бе тариф — бе маҳдудият кор мекунад';

  @override
  String get platformPlanAssigned => 'Тариф нав карда шуд';

  @override
  String get platformPlanInactive => 'хомӯш';

  @override
  String get platformPlansEmptyTitle => 'Тариф ҳанӯз нест';

  @override
  String get platformPlansEmptyBody =>
      'То ҳанӯз нестанд, ҳамаи фермаҳо бе маҳдудият кор мекунанд. Аввалинашро созед — он гоҳ таъин кардан мумкин мешавад.';

  @override
  String get platformPlanNew => 'Тарифи нав';

  @override
  String get platformPlanEdit => 'Тағйир додан';

  @override
  String get platformPlanDeleteTitle => 'Тарифро нест кунем?';

  @override
  String platformPlanDeleteBody(String name) {
    return '«$name» аз рӯйхат нест мешавад, фермаҳои дар он буда бе маҳдудият кор мекунанд. Сабтҳои онҳо дахл намекунанд.';
  }

  @override
  String get platformPlanDeleted => 'Тариф нест карда шуд';

  @override
  String get platformPlanUnlimited => 'Бе маҳдудият';

  @override
  String get platformPlanFree => 'Ройгон';

  @override
  String platformPlanLimitRabbits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'то $count харгӯш',
    );
    return '$_temp0';
  }

  @override
  String platformPlanLimitStaff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'то $count одам',
    );
    return '$_temp0';
  }

  @override
  String get platformPlanFormNewTitle => 'Тарифи нав';

  @override
  String get platformPlanFormEditTitle => 'Тариф';

  @override
  String get platformPlanFormName => 'Ном';

  @override
  String get platformPlanFormNameHint => 'Масалан, «Асосӣ»';

  @override
  String get platformPlanFormNameEmpty => 'Номро ворид кунед';

  @override
  String get platformPlanFormPrice => 'Нарх дар моҳ';

  @override
  String get platformPlanFormPriceHint => 'Холӣ — ройгон';

  @override
  String get platformPlanFormSectionLimits => 'Ҳадҳо';

  @override
  String get platformPlanFormMaxRabbits => 'Харгӯш на бештар аз';

  @override
  String get platformPlanFormMaxStaff => 'Одам на бештар аз';

  @override
  String get platformPlanFormLimitHint => 'Холӣ — бе маҳдудият';

  @override
  String get platformPlanFormActive => 'Тариф дар амал';

  @override
  String get platformPlanFormActiveHint =>
      'Тарифи хомӯшшуда дар фермаҳое, ки ба онҳо аллакай таъин шудааст, мемонад, вале ба фермаи нав дода намешавад.';

  @override
  String get platformPlanFormDefault => 'Ба фермаҳои нав додан';

  @override
  String get platformPlanFormDefaultHint =>
      'Ин тариф ба ҳар фермаи нави бақайдгирифташуда худ ба худ дода мешавад. Танҳо як тариф метавонад чунин бошад — барои таъин кардан ба дигар, бояд аввал аз тарифи ҳозира ин нишонаро бардоред.';

  @override
  String get platformPlanFormCreated => 'Тариф сохта шуд';

  @override
  String get platformPlanFormUpdated => 'Тариф нав карда шуд';

  @override
  String get platformFarmTitleFallback => 'Ферма';

  @override
  String get platformFarmSectionOwner => 'Соҳиб ва алоқа';

  @override
  String get platformFarmSectionAccess => 'Дастрасӣ';

  @override
  String get platformFarmSectionImpersonate => 'Дидан аз номи мизоҷ';

  @override
  String get platformFarmSectionPlan => 'Тариф';

  @override
  String get platformFarmSectionExtras => 'Имтиёз';

  @override
  String get platformFarmSectionUsage => 'Истифода';

  @override
  String get platformFarmSectionStaff => 'Таркиб';

  @override
  String get platformFarmSectionPayments => 'Пардохтҳо';

  @override
  String get platformFarmSectionFacts => 'Боз дар бораи ферма';

  @override
  String get platformFarmSectionExport => 'Бардоштани маълумот';

  @override
  String get platformFarmSectionDanger => 'Нест кардани ферма';

  @override
  String get platformFarmContactMissing =>
      'На почта, на телефон — алоқа кардан имконнопазир аст';

  @override
  String get platformFarmStatusActive => 'Мисли ҳамеша кор мекунад';

  @override
  String get platformFarmStatusActiveHint =>
      'Ферма ҳамаи маълумоти худро бе монеа мехонад ва сабт мекунад.';

  @override
  String get platformFarmStatusReadOnly => 'Танҳо хондан';

  @override
  String get platformFarmStatusReadOnlyHint =>
      'Маълумот дида мешавад, вале чизе сабт кардан мумкин нест. Ин ҳангоми напардохтан рӯй медиҳад: таърихи хоҷагӣ дар назди фермер мемонад, вале то пардохт кор кардан имконнопазир аст.';

  @override
  String get platformFarmStatusSuspended => 'Дастрасӣ баста шуд';

  @override
  String get platformFarmStatusSuspendedHint =>
      'Ферма ба ҳеҷ кас роҳ намедиҳад — на сабт кардан, на дидан.';

  @override
  String platformFarmStatusUnknown(String status) {
    return 'Ҳолати номаълум: $status';
  }

  @override
  String get platformFarmStatusChange => 'Дастрасиро тағйир додан';

  @override
  String platformFarmStatusSheetTitle(String farm) {
    return 'Дастрасии хоҷагии «$farm»';
  }

  @override
  String get platformFarmStatusConfirmTitle => 'Дастрасиро тағйир диҳем?';

  @override
  String platformFarmStatusConfirmBody(String status) {
    return 'Хоҷагӣ ба ҳолати «$status» мегузарад. Одамони ферма инро дарҳол, бе воридшавии нав мебинанд.';
  }

  @override
  String get platformFarmStatusApply => 'Татбиқ кардан';

  @override
  String get platformFarmStatusUpdated => 'Дастрасӣ нав карда шуд';

  @override
  String get platformFarmPlanForever => 'Бемуҳлат';

  @override
  String platformFarmPlanExpires(String date) {
    return 'То $date амал мекунад';
  }

  @override
  String platformFarmPlanExpired(String date) {
    return 'Мӯҳлаташ $date гузашт';
  }

  @override
  String get platformFarmPlanExtend => 'Дастӣ дароз кардан';

  @override
  String get platformFarmPlanExtended => 'Мӯҳлати тариф нав карда шуд';

  @override
  String get platformFarmExtrasNone =>
      'Имтиёз нест — ҳадҳои тариф амал мекунанд';

  @override
  String get platformFarmExtrasGrant => 'Имтиёз додан';

  @override
  String get platformFarmExtrasEdit => 'Тағйир додан';

  @override
  String get platformFarmExtrasClear => 'Имтиёзро бардоштан';

  @override
  String platformFarmExtrasRabbits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count харгӯш',
    );
    return '$_temp0';
  }

  @override
  String platformFarmExtrasStaff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count одам',
    );
    return '$_temp0';
  }

  @override
  String platformFarmExtrasUntil(String date) {
    return 'то $date';
  }

  @override
  String get platformFarmExtrasEndless => 'бемуҳлат';

  @override
  String platformFarmExtrasExpired(String date) {
    return 'Имтиёз $date гузашт — боз ҳадҳои тариф амал мекунанд';
  }

  @override
  String get platformFarmExtrasFormTitle => 'Имтиёз аз болои тариф';

  @override
  String get platformFarmExtrasFormBody =>
      'Иловагӣ ба ҳадди танҳо ҳамин ферма. Худи тариф иваз намешавад — на дар ин ферма, на дар дигарон.';

  @override
  String get platformFarmExtrasFormRabbits => 'Харгӯш аз болои тариф';

  @override
  String get platformFarmExtrasFormStaff => 'Одам аз болои тариф';

  @override
  String get platformFarmExtrasFormAmountHint => 'Холӣ — бе иловагӣ';

  @override
  String get platformFarmExtrasFormUntil => 'То кай амал мекунад';

  @override
  String get platformFarmExtrasFormSetDeadline => 'Мӯҳлат таъин кардан';

  @override
  String get platformFarmExtrasFormEndlessHint =>
      'Бе мӯҳлат имтиёз бемуҳлат амал мекунад.';

  @override
  String get platformFarmExtrasFormEmpty =>
      'Харгӯш ё одамро нишон диҳед — ё имтиёзро бардоред';

  @override
  String get platformFarmExtrasSaved => 'Имтиёз нав карда шуд';

  @override
  String get platformFarmExtrasCleared => 'Имтиёз бардошта шуд';

  @override
  String get platformFarmStaffNever => 'Ҳанӯз ворид нашудааст';

  @override
  String platformFarmStaffLastLogin(String date) {
    return 'Охирин вуруд $date';
  }

  @override
  String get platformFarmStaffBlocked => 'Вуруд баста шуд';

  @override
  String get platformFarmStaffEmpty => 'Дар таркиб ҳеҷ кас нест — ҳатто соҳиб';

  @override
  String get platformFarmPaymentsEmpty => 'Пардохт ҳанӯз набудааст';

  @override
  String get platformFarmPaymentNew => 'Оғоз шуд';

  @override
  String get platformFarmPaymentCompleted => 'Пардохта шуд';

  @override
  String get platformFarmPaymentFailed => 'Нагузашт';

  @override
  String get platformFarmImpersonate => 'Аз номи мизоҷ ворид шудан';

  @override
  String get platformFarmImpersonateHint =>
      'Барномаро ҳамон тавре бинед, ки соҳиби ферма мебинад — ба ҷои мукотиба «дар экрани шумо чӣ ҳаст». Танҳо хондан, 15 дақиқа, амал ба журнал меафтад.';

  @override
  String get platformFarmImpersonateTitle => 'Аз номи мизоҷ ворид шавем?';

  @override
  String platformFarmImpersonateBody(String farmName) {
    return 'Шумо $farmName-ро аз чашми соҳибаш мебинед — бе ҳуқуқи тағйир додан. Сеанс худ пас аз 15 дақиқа ё бо тугмаи «Баромадан» тамом мешавад.';
  }

  @override
  String get platformFarmImpersonateReasonLabel => 'Сабаб';

  @override
  String get platformFarmImpersonateReasonHint =>
      'Масалан: шикоят ба дастгирӣ №482';

  @override
  String get platformFarmImpersonateReasonRequired =>
      'Сабабро нишон диҳед — бе он вуруд ба журнал сабт намешавад';

  @override
  String get platformFarmImpersonateConfirm => 'Ворид шудан';

  @override
  String impersonationBanner(String farmName) {
    return 'Шумо «$farmName»-ро мебинед — танҳо хондан';
  }

  @override
  String get impersonationExit => 'Баромадан';

  @override
  String get impersonationExpired =>
      'Мӯҳлати дидан тамом шуд — шумо боз дар ҳисоби худ ҳастед';

  @override
  String get farmStatusBannerReadOnly =>
      'Дастрасӣ танҳо барои хондан — барои боз сабт кардан тарифро дароз кунед';

  @override
  String get farmStatusBannerSuspended =>
      'Дастрасӣ баста шуд — ба дастгирӣ муроҷиат кунед';

  @override
  String get farmStatusBannerAction => 'Тариф';

  @override
  String get farmStatusBannerContactSupport => 'Дастгирӣ';

  @override
  String get platformFarmExport => 'Маълумотро бардоштан';

  @override
  String get platformFarmExportHint =>
      'Аксандоз аз ҳамаи сабтҳои ферма — харгӯшҳо, муолиҷа, хӯрок, пардохтҳо. Барои дархости «маълумоти маро диҳед» лозим мешавад.';

  @override
  String platformFarmExportGeneratedAt(String date) {
    return 'Аксандоз $date гирифта шуд';
  }

  @override
  String get platformFarmDelete => 'Фермаро нест кардан';

  @override
  String get platformFarmDeleteHint =>
      'Дастрасӣ дарҳол баста мешавад, сабтҳо ва файлҳо пас аз 30 рӯз бебозгашт нест мешаванд. То он вақт фермаро баргардонидан мумкин аст.';

  @override
  String get platformFarmDeleteTitle => 'Фермаро нест кунем?';

  @override
  String get platformFarmDeleteBody =>
      'Одамони ферма дарҳол дастрасиро гум мекунанд. Харгӯшҳо, муолиҷа, расмҳо ва пардохтҳо пас аз 30 рӯз бебозгашт нест мешаванд — то он вақт нест карданро бекор кардан мумкин аст. Барои тасдиқ номи хоҷагиро нависед.';

  @override
  String get platformFarmDeleteConfirmLabel => 'Номи ферма';

  @override
  String platformFarmDeleteConfirmHint(String name) {
    return '«$name»-ро нависед';
  }

  @override
  String get platformFarmDeleteMismatch =>
      'Ном ба номи ферма мувофиқат намекунад';

  @override
  String get platformFarmDeleted => 'Ферма нест карда шуд';

  @override
  String platformFarmDeletedBanner(String date) {
    return 'Ферма $date нест карда шуд. Сабтҳо ва файлҳо пас аз 30 рӯз пас аз несткунӣ бебозгашт тоза мешаванд.';
  }

  @override
  String get platformFarmDeletedLocked =>
      'То ферма нест буда истодааст, дастрасӣ ва имтиёзҳо тағйир намеёбанд — аввал онро баргардонед.';

  @override
  String get platformFarmRestore => 'Баргардонидан';

  @override
  String get platformFarmRestored => 'Ферма баргардонида шуд';

  @override
  String get platformFarmStorage => 'Ҷои ишғолшуда';

  @override
  String get platformFarmLastActive => 'Вуруди охирин';

  @override
  String get platformFarmNeverActive => 'Ҳанӯз ворид нашудаанд';

  @override
  String get platformFarmCreatedAt => 'Ферма сохта шуд';

  @override
  String get platformSupportRequestsEmptyTitle => 'Мурожиат ҳанӯз нест';

  @override
  String get platformSupportRequestsEmptyBody =>
      'Дар ин ҷо саволҳои фермаҳо пайдо мешаванд — фермер тавассути Танзимот → Ба дастгирӣ навиштан менависад.';

  @override
  String get platformSupportRequestNew => 'нав';

  @override
  String get platformSupportRequestResolved => 'ҳал шуд';

  @override
  String get platformSupportRequestResolve => 'Ҳалшуда қайд кардан';

  @override
  String countSupportRequests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мурожиат',
    );
    return '$_temp0';
  }

  @override
  String get platformAnnouncementsEmptyTitle => 'Эълон ҳанӯз набудааст';

  @override
  String get platformAnnouncementsEmptyBody =>
      'Дар ин ҷо таърихи паёмҳо мемонад: чӣ фиристода шуд, ба кӣ ва чанд адад расид. Фиристодашударо ислоҳ ё бозхонд кардан мумкин нест, бинобар ин рӯйхат кӯмак мекунад, ки як чиз дубора такрор нашавад.';

  @override
  String get platformAnnouncementNew => 'Эълони нав';

  @override
  String get platformAnnouncementSend => 'Фиристодан';

  @override
  String get platformAnnouncementTargetAll => 'Ҳамаи фермаҳо';

  @override
  String get platformAnnouncementTargetAllHint =>
      'Ба ҳар хоҷагии хизмат, ба ғайр аз нестшуда';

  @override
  String get platformAnnouncementTargetFarm => 'Як ферма';

  @override
  String get platformAnnouncementTargetFarmHint =>
      'Ба як хоҷагӣ — масалан, дар ҷавоби мурожиати он';

  @override
  String get platformAnnouncementTargetFilter => 'Аз рӯи буриши фермаҳо';

  @override
  String get platformAnnouncementTargetFilterHint =>
      'Ҳамон буришҳое, ки дар рӯйхати фермаҳо ҳастанд: бе тариф, ба ҳад расида, дастрасӣ баста';

  @override
  String platformAnnouncementAudienceFarm(String farm) {
    return 'Ба фермаи «$farm»';
  }

  @override
  String platformAnnouncementAudienceFilter(String filter) {
    return 'Буриши «$filter»';
  }

  @override
  String get platformAnnouncementChannelPush => 'Push';

  @override
  String get platformAnnouncementChannelPushHint =>
      'Огоҳинома дар барномаи ферма';

  @override
  String get platformAnnouncementChannelEmail => 'Почта';

  @override
  String get platformAnnouncementChannelEmailHint =>
      'Мактуб ба суроғаи аз профил';

  @override
  String platformAnnouncementReach(int farms, int recipients) {
    String _temp0 = intl.Intl.pluralLogic(
      farms,
      locale: localeName,
      other: '$farms ферма',
    );
    String _temp1 = intl.Intl.pluralLogic(
      recipients,
      locale: localeName,
      other: '$recipients гиранда',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get platformAnnouncementNobody =>
      'Гиранда ёфт нашуд — эълон ба ҳеҷ кас нарафт';

  @override
  String platformAnnouncementDelivered(int sent, int attempted) {
    return 'расид $sent аз $attempted';
  }

  @override
  String get platformAnnouncementDeliveredNobody => 'фиристодан ба касе набуд';

  @override
  String get platformAnnouncementDeliveryUnknown => 'натиҷа захира нашудааст';

  @override
  String get platformAnnouncementFormTitle => 'Эълони нав';

  @override
  String get platformAnnouncementFormSubject => 'Сарлавҳа';

  @override
  String get platformAnnouncementFormSubjectHint =>
      'Ҳамин мавзӯи мактуб ва сарлавҳаи push ҳам мешавад';

  @override
  String get platformAnnouncementFormBody => 'Матн';

  @override
  String get platformAnnouncementFormBodyHint => 'Фермаҳо чиро бояд донанд';

  @override
  String get platformAnnouncementFormSectionChannels => 'Каналҳо';

  @override
  String get platformAnnouncementFormNoSms =>
      'SMS барои эълонҳо дастрас нест: дарвозаи пардохт танҳо шаблонҳои пешакӣ тасдиқшударо қабул мекунад, эълон бошад матни озод аст.';

  @override
  String get platformAnnouncementFormSectionTarget => 'Ба кӣ';

  @override
  String get platformAnnouncementFormPickFarm => 'Фермаро интихоб кунед';

  @override
  String get platformAnnouncementFormPickFilter => 'Буришро интихоб кунед';

  @override
  String get platformAnnouncementFarmSheetTitle => 'Ба кадом ферма фиристем';

  @override
  String get platformAnnouncementFilterSheetTitle =>
      'Ба кадом буриши фермаҳо фиристем';

  @override
  String get platformAnnouncementConfirmTitle => 'Эълонро фиристем?';

  @override
  String get platformAnnouncementConfirmBody =>
      'Паём дарҳол ба гирандагон меравад. Фиристодашударо бозхонд ё ислоҳ кардан имконнопазир аст.';

  @override
  String platformAnnouncementConfirmAudience(String audience) {
    return 'Ба кӣ: $audience';
  }

  @override
  String platformAnnouncementConfirmChannels(String channels) {
    return 'Каналҳо: $channels';
  }

  @override
  String platformAnnouncementSentOk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Эълон ба $count гиранда рафт',
    );
    return '$_temp0';
  }

  @override
  String platformAnnouncementSentPartly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Эълон ба $count гиранда рафт, вале қисми паёмҳо нарасид — сатрро дар рӯйхат бинед',
    );
    return '$_temp0';
  }

  @override
  String get platformAnnouncementSentPlain => 'Эълон фиристода шуд';

  @override
  String get storageUnitBytes => 'Б';

  @override
  String get storageUnitKb => 'КБ';

  @override
  String get storageUnitMb => 'МБ';

  @override
  String get storageUnitGb => 'ГБ';

  @override
  String get emptyNoRecordsTitle => 'Сабт нест';

  @override
  String get emptyNoRecordsBody => 'Аввалинашро илова кунед.';
}
