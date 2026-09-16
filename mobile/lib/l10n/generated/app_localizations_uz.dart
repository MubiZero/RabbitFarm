// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appName => 'RabbitFarm';

  @override
  String get commonRetry => 'Qayta urinish';

  @override
  String get commonCancel => 'Bekor qilish';

  @override
  String get commonSave => 'Saqlash';

  @override
  String get commonAdd => 'Qoʻshish';

  @override
  String get commonDelete => 'Oʻchirish';

  @override
  String get commonClose => 'Yopish';

  @override
  String get commonCopy => 'Nusxalash';

  @override
  String get commonCopied => 'Nusxalandi';

  @override
  String get commonLoadFailed => 'Yuklab boʻlmadi';

  @override
  String get commonUnknownError => 'Nomaʼlum xatolik';

  @override
  String get commonSomethingWrong => 'Nimadir notoʻgʻri ketdi';

  @override
  String get commonSomethingWrongHint =>
      'Bu ekranni koʻrsatib boʻlmadi. Orqaga qayting yoki ilovani qayta ishga tushiring.';

  @override
  String get errorOffline => 'Aloqa yoʻq — internetni tekshiring';

  @override
  String get errorTimeout => 'Server javob bermadi, yana urinib koʻring';

  @override
  String get errorUnauthorized => 'Qaytadan kirish kerak';

  @override
  String get errorForbidden => 'Sizning rolingizda bunga ruxsat yoʻq';

  @override
  String get errorNotFound => 'Yozuv topilmadi — ehtimol, oʻchirilgan';

  @override
  String get errorInvalid => 'Server maʼlumotlarni qabul qilmadi';

  @override
  String get errorServer => 'Serverda nosozlik, keyinroq urinib koʻring';

  @override
  String get offlineBanner =>
      'Aloqa yoʻq — yozuvlar saqlanadi va aloqa tiklangach yuboriladi';

  @override
  String get offlineActionQueued =>
      'Qurilmada saqlandi — aloqa paydo boʻlganda yuboriladi';

  @override
  String get forceUpdateTitle => 'Yangi versiya mavjud';

  @override
  String get forceUpdateHint =>
      'Ilovaning bu versiyasi endi qoʻllab-quvvatlanmaydi. Davom etish uchun ilovani yangilang.';

  @override
  String get forceUpdateButton => 'Yangilash';

  @override
  String get commonStaleData =>
      'Yangilab boʻlmadi, avvalgi maʼlumotlar koʻrsatilmoqda';

  @override
  String get commonRetryShort => 'Yana bir bor';

  @override
  String get commonNotSpecified => 'Koʻrsatilmagan';

  @override
  String get commonActions => 'Amallar';

  @override
  String get commonEmail => 'Pochta';

  @override
  String get quickGroupOften => 'Tez-tez';

  @override
  String get journalPeriodToday => 'Bugun';

  @override
  String get journalPeriodWeek => 'Hafta';

  @override
  String get journalKindAll => 'Barchasi';

  @override
  String get journalKindFeeding => 'Oziqlantirish';

  @override
  String get journalKindTreatment => 'Davolash';

  @override
  String get journalKindVaccination => 'Emlash';

  @override
  String get journalKindTask => 'Vazifa';

  @override
  String get journalKindNote => 'Eslatma';

  @override
  String get journalKindPhoto => 'Rasm';

  @override
  String get journalEmptyTodayTitle => 'Bugun hali hech narsa yozilmagan';

  @override
  String get journalEmptyWeekTitle => 'Hafta davomida hech narsa yozilmagan';

  @override
  String get journalEmptyBody =>
      'Oziqlantirish, davolash, emlash, yopilgan vazifalar, eslatma va rasmlar bu yerga oʻzi tushadi. Birinchisini yozing — va u shu yerda paydo boʻladi.';

  @override
  String get journalNoneInViewTitle => 'Bu tanlovda boʻsh';

  @override
  String get journalNoneInViewBody =>
      'Yozuv turini yoki muddatini almashtiring.';

  @override
  String get pinSetupTitle => 'Tez kirish kodi';

  @override
  String get pinChangeTitle => 'Kodni oʻzgartirish';

  @override
  String get pinSetupPrompt => '4 raqamli kod oʻylab toping';

  @override
  String get pinRepeatPrompt => 'Kodni takrorlang';

  @override
  String get pinSetupExplanation =>
      'Bu kod bilan ilovani shu telefonda ochasiz — endi SMS yoki xatdagi kodni kutib oʻtirmaysiz.';

  @override
  String get pinSkip => 'Hozir emas';

  @override
  String get pinSaved => 'Kod saqlandi';

  @override
  String get pinMismatch => 'Kodlar mos kelmadi — yana urinib koʻring';

  @override
  String get pinLockPrompt => 'Kodni kiriting';

  @override
  String get pinWrong => 'Kod notoʻgʻri';

  @override
  String get pinDelete => 'Raqamni oʻchirish';

  @override
  String pinAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta urinish qoldi',
      few: '$count ta urinish qoldi',
      one: '$count ta urinish qoldi',
    );
    return '$_temp0';
  }

  @override
  String get pinForgot => 'Kodni unutdingizmi?';

  @override
  String get pinForgotTitle => 'Kodni unutdingizmi?';

  @override
  String get pinForgotBody =>
      'Kod faqat shu telefonda saqlanadi, uni tiklashning iloji yoʻq. Akkauntdan chiqamiz — va siz SMS yoki xatdagi kod bilan qaytadan kirasiz.';

  @override
  String get pinForgotConfirm => 'Chiqish va qaytadan kirish';

  @override
  String get settingsPinTitle => 'Tez kirish kodi';

  @override
  String get settingsPinOn => 'Ilova kod bilan ochiladi';

  @override
  String get settingsPinOff => 'Ilova kodsiz ochiladi';

  @override
  String get settingsPinChange => 'Kodni oʻzgartirish';

  @override
  String get loginByPhone => 'Telefon';

  @override
  String get loginByEmail => 'Pochta';

  @override
  String get loginEmailIntro => 'Pochtaga kod yuboramiz — parol kerak emas.';

  @override
  String get loginCodeChangeEmail => 'Pochtani oʻzgartirish';

  @override
  String get registerContactHelper => 'Unga kirish uchun kod keladi';

  @override
  String get loginPhoneLabel => 'Telefon';

  @override
  String get loginPhoneHint => '+992 XX XXX XX XX';

  @override
  String get loginPhoneEmpty => 'Telefon raqamini kiriting';

  @override
  String get loginPhoneInvalid => 'Raqam +992 90 123 45 67 koʻrinishida';

  @override
  String get loginPhoneIntro => 'SMS orqali kod yuboramiz — parol kerak emas.';

  @override
  String get loginRequestCode => 'Kod olish';

  @override
  String loginCodeSentTo(String phone) {
    return 'Kod $phone raqamiga yuborildi';
  }

  @override
  String get loginCodeLabel => 'SMSdagi kod';

  @override
  String get loginCodeEmpty => 'Kodni kiriting';

  @override
  String get loginCodeInvalid => 'Kod — 6 ta raqam';

  @override
  String get loginCodeSubmit => 'Kirish';

  @override
  String get loginCodeResend => 'Kodni qayta yuborish';

  @override
  String loginCodeResendIn(int seconds) {
    return '$seconds s dan keyin qayta yuborish';
  }

  @override
  String get loginCodeResent => 'Kod qayta yuborildi';

  @override
  String get loginCodeChangePhone => 'Raqamni oʻzgartirish';

  @override
  String get loginEmailLabel => 'Pochta';

  @override
  String get loginEmailHint => 'name@example.com';

  @override
  String get loginEmailEmpty => 'Pochtani kiriting';

  @override
  String get loginEmailInvalid => 'Manzilda xatolik boʻlsa kerak';

  @override
  String get loginSubmit => 'Kirish';

  @override
  String get loginCreateFarm => 'Oʻz fermamni ochish';

  @override
  String get todayGreetingMorning => 'Xayrli tong';

  @override
  String get todayGreetingDay => 'Xayrli kun';

  @override
  String get todayGreetingEvening => 'Xayrli kech';

  @override
  String get todayGreetingNight => 'Xayrli tun';

  @override
  String todayGreetingNamed(String greeting, String name) {
    return '$greeting, $name!';
  }

  @override
  String todayGreetingPlain(String greeting) {
    return '$greeting!';
  }

  @override
  String get todayNeedsAttention => 'Diqqat talab qiladi';

  @override
  String get todayAllClear => 'Hammasi nazoratda — shoshilinch narsa yoʻq';

  @override
  String get todayFarmNow => 'Ferma hozir';

  @override
  String get todayStatLivestock => 'Jonivorlar soni';

  @override
  String get todayStatTasks => 'Ishdagi vazifalar';

  @override
  String get todayStatFreeCages => 'Boʻsh kataklar';

  @override
  String get todayAlertOverdueVaccination => 'Emlash muddati oʻtib ketgan';

  @override
  String get todayAlertLowFeed => 'Em tugab qolmoqda';

  @override
  String get todayAlertUpcomingVaccination => 'Tez orada emlash';

  @override
  String get activationChecklistTitle => 'Ishni boshlash';

  @override
  String get activationChecklistDismiss => 'Berkitish';

  @override
  String get menuProfile => 'Profil';

  @override
  String get roleOwner => 'Ferma egasi';

  @override
  String get roleManager => 'Boshqaruvchi';

  @override
  String get roleWorker => 'Ishchi';

  @override
  String get navToday => 'Bugun';

  @override
  String get navRabbits => 'Quyonlar';

  @override
  String get navHerd => 'Poda';

  @override
  String get navBreeding => 'Urchitish';

  @override
  String get navFarm => 'Xoʻjalik';

  @override
  String get navJournal => 'Jurnal';

  @override
  String get navProfile => 'Profil';

  @override
  String get navRecord => 'Yozish';

  @override
  String get quickRecordTreatment => 'Davolash';

  @override
  String get quickRecordBreeding => 'Juftlashtirish';

  @override
  String get quickAddFeed => 'Em kirimi';

  @override
  String get quickRecordTransaction => 'Kirim yoki chiqim';

  @override
  String get quickGroupDaily => 'Har kuni';

  @override
  String get quickGroupHerd => 'Poda';

  @override
  String get quickGroupFarm => 'Xoʻjalik';

  @override
  String get herdTitle => 'Poda';

  @override
  String get herdTabCages => 'Kataklar';

  @override
  String get herdTabRabbits => 'Quyonlar';

  @override
  String get journalTitle => 'Jurnal';

  @override
  String get reportsTitle => 'Hisobotlar';

  @override
  String get farmTitle => 'Xoʻjalik';

  @override
  String get navQuickTitle => 'Nimani yozamiz';

  @override
  String get quickRecordFeeding => 'Oziqlantirishni yozish';

  @override
  String get quickNeedsConnection => 'Aloqa kerak';

  @override
  String offlineRejectedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yozuv saqlanmadi',
      one: '$count yozuv saqlanmadi',
    );
    return '$_temp0';
  }

  @override
  String get offlineRejectedBody =>
      'Server ularni qabul qilmadi — qaytadan yozing.';

  @override
  String get offlineRejectedDismiss => 'Tushunarli';

  @override
  String get quickRecordVaccination => 'Emlashni yozish';

  @override
  String get quickCreateTask => 'Vazifa yaratish';

  @override
  String get quickRecordNote => 'Eslatma qoldirish';

  @override
  String get quickAddRabbit => 'Quyon qoʻshish';

  @override
  String get quickRecordBirth => 'Tugʻishni yozish';

  @override
  String get quickAddCage => 'Katak qoʻshish';

  @override
  String get formDiscardTitle => 'Saqlamasdan chiqilsinmi?';

  @override
  String get formDiscardBody => 'Kiritilgan maʼlumotlar yoʻqoladi.';

  @override
  String get formDiscardStay => 'Kiritishni davom ettirish';

  @override
  String get formDiscardLeave => 'Chiqish';

  @override
  String get cycleTitle => 'Urchitish';

  @override
  String get cycleFindPair => 'Juft tanlash';

  @override
  String get cycleRecordBirth => 'Tugʻishni yozish';

  @override
  String get cycleStageCheck => 'Boʻgʻozlikni tekshirish';

  @override
  String get cycleStageBirth => 'Tugʻish kutilmoqda';

  @override
  String get cycleStageWeaning => 'Bolalarni ajratish';

  @override
  String get cycleStageNotPregnant => 'Urgʻochi boʻsh';

  @override
  String get cycleStageFailed => 'Juftlashtirish muvaffaqiyatsiz';

  @override
  String get cycleStageCancelled => 'Juftlashtirish bekor qilindi';

  @override
  String get cycleStageClosed => 'Davr yakunlandi';

  @override
  String cycleDay(int day) {
    return '$day-kun';
  }

  @override
  String cycleMaleLine(String name) {
    return 'Erkak: $name';
  }

  @override
  String cycleActionWhen(String date, String when) {
    return '$date · $when';
  }

  @override
  String cycleApproxDate(String date) {
    return 'taxminan $date';
  }

  @override
  String get cycleDueToday => 'bugun';

  @override
  String get cycleDueTomorrow => 'ertaga';

  @override
  String cycleInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kundan keyin',
      one: '$count kundan keyin',
    );
    return '$_temp0';
  }

  @override
  String cycleOverdueDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'muddati $count kunga oʻtib ketgan',
      one: 'muddati $count kunga oʻtib ketgan',
    );
    return '$_temp0';
  }

  @override
  String get breedingEmptyTitle => 'Hali juftlashtirish yoʻq';

  @override
  String get breedingEmptyBody =>
      'Juftlashtirishni yozing — ilova tugʻish kutilayotgan sanani aytadi.';

  @override
  String get breedingEmptyAction => 'Juftlashtirishni yozish';

  @override
  String get breedingMale => 'Erkak';

  @override
  String get breedingFemale => 'Urgʻochi';

  @override
  String get commonNameMissing => 'Ism koʻrsatilmagan';

  @override
  String get commonOpenCard => 'Kartochkani ochish';

  @override
  String get commonEdit => 'Oʻzgartirish';

  @override
  String get commonClearSearch => 'Qidiruvni tozalash';

  @override
  String get breedingStatusPlanned => 'Rejalashtirilgan';

  @override
  String get breedingStatusCompleted => 'Yakunlangan';

  @override
  String get breedingStatusFailed => 'Muvaffaqiyatsiz';

  @override
  String get breedingStatusCancelled => 'Bekor qilingan';

  @override
  String get cageTitle => 'Katak';

  @override
  String cageTitleNumbered(String number) {
    return '$number-katak';
  }

  @override
  String get cageEdit => 'Katakni oʻzgartirish';

  @override
  String get cageResidents => 'Yashovchilar';

  @override
  String get cageEmptyManaged =>
      'Katak boʻsh. Pastdagi tugma orqali quyon joylashtiring.';

  @override
  String get cageEmptyReadOnly => 'Katak boʻsh.';

  @override
  String get cageFull => 'Katak toʻlgan';

  @override
  String get cageAddRabbit => 'Quyon joylashtirish';

  @override
  String get cageNoLocation => 'Joyi koʻrsatilmagan';

  @override
  String get cageRemoveTitle => 'Katakdan chiqarilsinmi?';

  @override
  String cageRemoveBody(String name) {
    return '$name katak biriktirilmagan quyonlar roʻyxatiga oʻtadi.';
  }

  @override
  String get cageRemoveConfirm => 'Chiqarish';

  @override
  String cageRemoved(String name) {
    return '$name katakdan chiqarildi';
  }

  @override
  String cageMoved(String name, String number) {
    return '$name $number-katakka koʻchirildi';
  }

  @override
  String cageSettled(String name) {
    return '$name katakka joylashtirildi';
  }

  @override
  String commonActionFailed(String reason) {
    return 'Bajarilmadi: $reason';
  }

  @override
  String get cageResidentMove => 'Koʻchirish';

  @override
  String get cagePickRabbitTitle => 'Kimni joylashtiramiz';

  @override
  String get cagePickRabbitHint => 'Laqabi yoki birka raqami';

  @override
  String get cagePickNothingFound => 'Hech kim topilmadi';

  @override
  String get cagePickNothingFoundBody =>
      'Laqabi yoki birka raqamini tekshiring.';

  @override
  String cagePickCurrentCage(String number) {
    return 'Hozir $number-katakda';
  }

  @override
  String get cagePickNoCage => 'Katak yoʻq';

  @override
  String get cagePickCageTitle => 'Qaysi katakka koʻchiramiz';

  @override
  String get cagePickNoFreeCages => 'Boʻsh katak yoʻq';

  @override
  String get cagePickNoFreeCagesBody =>
      'Joy boʻshating yoki yangi katak qoʻshing.';

  @override
  String get cageFormType => 'Katak turi';

  @override
  String get cycleStageWeaned => 'Bolalar ajratildi';

  @override
  String get cageTypeSingle => 'Yakka';

  @override
  String get cageTypeGroup => 'Guruh';

  @override
  String get cageTypeMaternity => 'Tugʻish uchun';

  @override
  String get cageConditionGood => 'Yaxshi holatda';

  @override
  String get cageConditionNeedsRepair => 'Taʼmir talab qiladi';

  @override
  String get cageConditionBroken => 'Buzilgan';

  @override
  String countTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vazifa',
      one: '$count vazifa',
    );
    return '$_temp0';
  }

  @override
  String countVaccinations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count emlash',
      one: '$count emlash',
    );
    return '$_temp0';
  }

  @override
  String countFeedKinds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count xil em',
      one: '$count xil em',
    );
    return '$_temp0';
  }

  @override
  String countRabbits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count quyon',
      one: '$count quyon',
    );
    return '$_temp0';
  }

  @override
  String countRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yozuv',
      one: '$count yozuv',
    );
    return '$_temp0';
  }

  @override
  String countOperations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amaliyot',
      one: '$count amaliyot',
    );
    return '$_temp0';
  }

  @override
  String get tasksTitle => 'Vazifalar';

  @override
  String get todayTasksTitle => 'Bugungi vazifalar';

  @override
  String get todayTasksAll => 'Barcha vazifalar';

  @override
  String get todayTaskDone => 'Yopilgan';

  @override
  String get todayTasksNone => 'Bugunga vazifa yoʻq';

  @override
  String get commonFilters => 'Filtrlar';

  @override
  String get commonApply => 'Qoʻllash';

  @override
  String get commonReset => 'Tozalash';

  @override
  String get tasksFilterType => 'Turi';

  @override
  String get tasksFilterStatus => 'Holati';

  @override
  String get tasksFilterPriority => 'Muhimligi';

  @override
  String get tasksFilterOverdueOnly => 'Faqat muddati oʻtganlar';

  @override
  String get tasksFilterTodayOnly => 'Faqat bugungilar';

  @override
  String get tasksFilterAssignee => 'Ijrochi';

  @override
  String get tasksFilterAssigneeAny => 'Har kim';

  @override
  String get tasksFilterAssigneeMine => 'Faqat meniki';

  @override
  String get tasksAssigneeMineChip => 'Mening vazifalarim';

  @override
  String get tasksEmptyTitle => 'Hali vazifa yoʻq';

  @override
  String get tasksEmptyBody =>
      'Vazifa yarating — muddati kelganda ilova eslatadi.';

  @override
  String get tasksEmptyAction => 'Vazifa yaratish';

  @override
  String get tasksNothingMatchesTitle => 'Filtrlarga hech narsa mos kelmadi';

  @override
  String get tasksNothingMatchesBody =>
      'Koʻproq koʻrish uchun shartlarning bir qismini olib tashlang.';

  @override
  String get tasksComplete => 'Bajarilgan deb belgilash';

  @override
  String get tasksCompleted => 'Vazifa bajarildi';

  @override
  String get tasksCompleteFailed => 'Vazifani belgilab boʻlmadi';

  @override
  String get tasksOverdueChip => 'Muddati oʻtganlar';

  @override
  String get tasksTodayChip => 'Bugunga';

  @override
  String get taskTypeFeeding => 'Oziqlantirish';

  @override
  String get taskTypeCleaning => 'Tozalash';

  @override
  String get taskTypeVaccination => 'Emlash';

  @override
  String get taskTypeCheckup => 'Koʻrik';

  @override
  String get taskTypeBreeding => 'Urchitish';

  @override
  String get taskTypeOther => 'Boshqa';

  @override
  String get taskStatusPending => 'Kutilmoqda';

  @override
  String get taskStatusInProgress => 'Bajarilmoqda';

  @override
  String get taskStatusCompleted => 'Bajarilgan';

  @override
  String get taskStatusCancelled => 'Bekor qilingan';

  @override
  String get taskPriorityLow => 'Past';

  @override
  String get taskPriorityMedium => 'Oʻrta';

  @override
  String get taskPriorityHigh => 'Yuqori';

  @override
  String get taskPriorityUrgent => 'Shoshilinch';

  @override
  String dueToday(String time) {
    return 'Bugun soat $time';
  }

  @override
  String dueTomorrow(String time) {
    return 'Ertaga soat $time';
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
      other: 'Muddati $count kunga oʻtib ketgan',
      one: 'Muddati $count kunga oʻtib ketgan',
    );
    return '$_temp0';
  }

  @override
  String get dueTodayPlain => 'Bugun';

  @override
  String get dueTomorrowPlain => 'Ertaga';

  @override
  String get taskFormNewTitle => 'Yangi vazifa';

  @override
  String get taskFormEditTitle => 'Vazifa';

  @override
  String get taskFormSectionMain => 'Asosiy';

  @override
  String get taskFormSectionParams => 'Parametrlar';

  @override
  String get taskFormSectionNotes => 'Eslatmalar';

  @override
  String get taskFormTitleLabel => 'Nima qilish kerak';

  @override
  String get taskFormTitleEmpty => 'Vazifani bir qatorda yozing';

  @override
  String get taskFormDescriptionLabel => 'Batafsil';

  @override
  String get taskFormDueLabel => 'Muddat';

  @override
  String get taskFormRepeat => 'Takrorlash';

  @override
  String get taskFormRepeatNever => 'Takrorlanmasin';

  @override
  String get taskFormRepeatHelp =>
      'Vazifa bajarilgan deb belgilanganda, keyingisi oʻzi yaratiladi.';

  @override
  String get taskFormAssignee => 'Ijrochi';

  @override
  String get taskFormAssigneeNobody => 'Hech kimga topshirilmagan';

  @override
  String get taskFormAssigneeHelp =>
      'Ijrochiga vazifa haqida bildirishnoma boradi.';

  @override
  String tasksAssignedTo(String name) {
    return 'Ijrochi: $name';
  }

  @override
  String get taskFormNotesLabel => 'Izohlar';

  @override
  String get taskFormCreate => 'Yaratish';

  @override
  String get taskFormCreated => 'Vazifa yaratildi';

  @override
  String get taskFormUpdated => 'Vazifa yangilandi';

  @override
  String get taskFormDeleteTitle => 'Vazifa oʻchirilsinmi?';

  @override
  String get taskFormDeleteBody => 'Uni qayta tiklab boʻlmaydi.';

  @override
  String get taskFormDeleted => 'Vazifa oʻchirildi';

  @override
  String get taskFormDeleteFailed => 'Vazifani oʻchirib boʻlmadi';

  @override
  String get noteFormNewTitle => 'Yangi eslatma';

  @override
  String get noteFormEditTitle => 'Eslatma';

  @override
  String get noteFormSectionMain => 'Asosiy';

  @override
  String get noteFormContentLabel => 'Eslatma matni';

  @override
  String get noteFormContentEmpty => 'Eslatma matnini kiriting';

  @override
  String get noteFormSectionLink => 'Nimaga tegishli';

  @override
  String get noteFormRabbitLabel => 'Quyon (ixtiyoriy)';

  @override
  String get noteFormCageLabel => 'Katak (ixtiyoriy)';

  @override
  String get noteFormCageNone => 'Tanlanmagan';

  @override
  String get noteFormCreate => 'Qoʻshish';

  @override
  String get noteFormCreated => 'Eslatma qoʻshildi';

  @override
  String get noteFormUpdated => 'Eslatma yangilandi';

  @override
  String get noteFormDeleteTitle => 'Eslatma oʻchirilsinmi?';

  @override
  String get noteFormDeleteBody => 'Uni qayta tiklab boʻlmaydi.';

  @override
  String get noteFormDeleted => 'Eslatma oʻchirildi';

  @override
  String get noteFormDeleteFailed => 'Eslatmani oʻchirib boʻlmadi';

  @override
  String get repeatDaily => 'Har kuni';

  @override
  String get repeatWeekly => 'Haftada bir marta';

  @override
  String get repeatBiweekly => 'Ikki haftada bir marta';

  @override
  String get repeatMonthly => 'Oyda bir marta';

  @override
  String get repeatQuarterly => 'Chorakda bir marta';

  @override
  String get repeatYearly => 'Yilda bir marta';

  @override
  String get vaccinationsTitle => 'Emlashlar';

  @override
  String get vaccinationsStats => 'Xulosa';

  @override
  String get vaccinationsViewAll => 'Barchasi';

  @override
  String get vaccinationsViewUpcoming => 'Tez orada';

  @override
  String get vaccinationsViewOverdue => 'Muddati oʻtganlar';

  @override
  String get vaccinationsViewLast30 => 'Soʻnggi 30 kun';

  @override
  String get vaccinationsEmptyTitle => 'Emlash yozuvlari yoʻq';

  @override
  String get vaccinationsEmptyBody =>
      'Emlashni belgilang — ilova keyingisi qachon kerakligini eslatadi.';

  @override
  String get vaccinationsEmptyAction => 'Emlashni yozish';

  @override
  String get vaccinationsNoneInView => 'Bu tanlovda boʻsh';

  @override
  String get vaccinationsNoneInViewBody =>
      'Boshqa boʻlimni tanlang yoki filtrlarni olib tashlang.';

  @override
  String get vaccinationsFilterType => 'Vaksina turi';

  @override
  String get vaccinationsFilterPeriod => 'Davr';

  @override
  String get vaccinationsFrom => 'Dan';

  @override
  String get vaccinationsTo => 'Gacha';

  @override
  String get vaccinationsResetAll => 'Hammasini tozalash';

  @override
  String vaccinationsNext(String date) {
    return 'Keyingisi $date';
  }

  @override
  String get vaccinationsOverdueBadge => 'Muddati oʻtgan';

  @override
  String vaccinationsInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kundan keyin',
      one: '$count kundan keyin',
    );
    return '$_temp0';
  }

  @override
  String vaccinationsBatch(String number) {
    return '$number-partiya';
  }

  @override
  String get vaccinationsVet => 'Veterinar';

  @override
  String get vaccinationsDate => 'Emlash sanasi';

  @override
  String get vaccinationsNextLabel => 'Keyingi emlash';

  @override
  String get vaccinationsBatchLabel => 'Partiya raqami';

  @override
  String get vaccinationsTypeLabel => 'Turi';

  @override
  String get vaccinationsNotesLabel => 'Eslatmalar';

  @override
  String get vaccinationsDeleteTitle => 'Yozuv oʻchirilsinmi?';

  @override
  String get vaccinationsDeleteBody =>
      'Emlash haqidagi yozuv qaytarib boʻlmaydigan tarzda oʻchiriladi.';

  @override
  String get vaccinationsDeleted => 'Yozuv oʻchirildi';

  @override
  String get vaccinationsDeleteFailed => 'Yozuvni oʻchirib boʻlmadi';

  @override
  String get vaccinationsStatTotal => 'Jami emlashlar';

  @override
  String get vaccinationsStatThisYear => 'Shu yilda';

  @override
  String get vaccinationsStatLast30 => 'Soʻnggi 30 kunda';

  @override
  String get vaccinationsStatUpcoming => 'Tez orada';

  @override
  String get vaccinationsStatNext30 => 'Keyingi 30 kun ichida';

  @override
  String get vaccinationsStatOverdue => 'Muddati oʻtgan';

  @override
  String get rabbitPickerTitle => 'Quyonni tanlang';

  @override
  String get rabbitPickerHint => 'Laqabi yoki birka raqami';

  @override
  String get rabbitPickerEmpty => 'Tanlanmagan';

  @override
  String get rabbitPickerNothingFound => 'Hech kim topilmadi';

  @override
  String get rabbitPickerNothingFoundBody =>
      'Laqabi yoki birka raqamini tekshiring.';

  @override
  String get rabbitPickerClear => 'Tozalash';

  @override
  String get rabbitPickerRequired => 'Quyonni tanlang';

  @override
  String rabbitPickerInCage(String number) {
    return '$number-katak';
  }

  @override
  String get rabbitPickerNoCage => 'Katak yoʻq';

  @override
  String get vaccFormNewTitle => 'Yangi emlash';

  @override
  String get vaccFormEditTitle => 'Emlash';

  @override
  String get vaccFormSectionMain => 'Asosiy';

  @override
  String get vaccFormSectionDates => 'Sanalar';

  @override
  String get vaccFormSectionExtra => 'Qoʻshimcha';

  @override
  String get fieldRecipient => 'Kimga';

  @override
  String get vaccFormType => 'Vaksina turi';

  @override
  String get vaccFormName => 'Vaksina nomi';

  @override
  String get vaccFormNameHint => 'Masalan, Rabbivak V';

  @override
  String get vaccFormNameEmpty => 'Vaksina nomini kiriting';

  @override
  String get vaccFormDate => 'Emlash sanasi';

  @override
  String get vaccFormNextDate => 'Keyingi emlash';

  @override
  String get vaccFormNextNotSet => 'Rejalashtirilmagan';

  @override
  String get vaccFormPlus3m => '3 oydan keyin';

  @override
  String get vaccFormPlus6m => 'yarim yildan keyin';

  @override
  String get vaccFormPlus1y => 'bir yildan keyin';

  @override
  String get vaccFormBatch => 'Partiya raqami';

  @override
  String get vaccFormBatchHint => 'Masalan, 12345-67';

  @override
  String get vaccFormVet => 'Veterinar';

  @override
  String get vaccFormVetHint => 'Kim emladi';

  @override
  String get vaccFormNotes => 'Eslatmalar';

  @override
  String get vaccFormCreated => 'Emlash yozildi';

  @override
  String get vaccFormUpdated => 'Yozuv yangilandi';

  @override
  String get vaccFormFailed => 'Saqlab boʻlmadi';

  @override
  String get medTitle => 'Davolash';

  @override
  String get medEmptyTitle => 'Davolash yozuvlari yoʻq';

  @override
  String get medEmptyBody =>
      'Kasallik kartasini oching — u belgilar, davolash va xarajatlarni bir joyga yigʻadi.';

  @override
  String get medEmptyAction => 'Karta ochish';

  @override
  String get medNoneInView => 'Bu tanlovda boʻsh';

  @override
  String get medNoneInViewBody =>
      'Boshqa boʻlimni tanlang yoki filtrlarni olib tashlang.';

  @override
  String get medViewAll => 'Barchasi';

  @override
  String get medOutcomeOngoing => 'Davolanmoqda';

  @override
  String get medOutcomeRecovered => 'Tuzaldi';

  @override
  String get medOutcomeDied => 'Nobud boʻldi';

  @override
  String get medOutcomeEuthanized => 'Uxlatildi';

  @override
  String get medDiagnosis => 'Tashxis';

  @override
  String get medSymptoms => 'Belgilar';

  @override
  String get medTreatment => 'Davolash';

  @override
  String get medMedication => 'Dorilar';

  @override
  String get medStarted => 'Boshlanishi';

  @override
  String get medEnded => 'Tugashi';

  @override
  String get medCost => 'Xarajat';

  @override
  String get medVet => 'Veterinar';

  @override
  String get medNotes => 'Eslatmalar';

  @override
  String get medNoDiagnosis => 'Tashxis qoʻyilmagan';

  @override
  String get medDeleteTitle => 'Karta oʻchirilsinmi?';

  @override
  String get medDeleteBody =>
      'Davolash yozuvi qaytarib boʻlmaydigan tarzda oʻchiriladi.';

  @override
  String get medDeleted => 'Yozuv oʻchirildi';

  @override
  String get medDeleteFailed => 'Yozuvni oʻchirib boʻlmadi';

  @override
  String get medPeriodFrom => 'Sanadan';

  @override
  String get medPeriodTo => 'Sanagacha';

  @override
  String get commonSummary => 'Xulosa';

  @override
  String get medStatTotal => 'Jami kartalar';

  @override
  String get medStatThisYear => 'Shu yilda';

  @override
  String get medStatLastMonth => 'Bir oyda';

  @override
  String get medStatCost => 'Sarflandi';

  @override
  String get medStatOngoing => 'Hozir davolanmoqda';

  @override
  String medDaysOngoing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kun',
      one: '$count kun',
    );
    return '$_temp0';
  }

  @override
  String get medFormNewTitle => 'Yangi karta';

  @override
  String get medFormEditTitle => 'Davolash kartasi';

  @override
  String get medFormRabbit => 'Kimga';

  @override
  String get medFormSectionCase => 'Nima boʻldi';

  @override
  String get medFormSectionTreatment => 'Davolash';

  @override
  String get medFormSectionDates => 'Muddat va pul';

  @override
  String get medFormSymptomsEmpty => 'Belgilarni yozing';

  @override
  String get medFormOutcome => 'Natija';

  @override
  String get medFormCreated => 'Karta ochildi';

  @override
  String get medFormUpdated => 'Karta yangilandi';

  @override
  String get medFormFailed => 'Saqlab boʻlmadi';

  @override
  String get medFormCostHelp =>
      'Summa ferma xarajatlariga alohida amaliyot sifatida tushadi.';

  @override
  String get medFormDosage => 'Dozasi';

  @override
  String get medFormEndedDate => 'Tugash sanasi';

  @override
  String get medFormNotSet => 'Koʻrsatilmagan';

  @override
  String medFormCostLabel(String currency) {
    return 'Xarajat, $currency';
  }

  @override
  String get commonNumberInvalid => 'Raqam kiriting';

  @override
  String get feedsTitle => 'Em ombori';

  @override
  String get feedsAdd => 'Em qoʻshish';

  @override
  String get feedsEmptyTitle => 'Ombor boʻsh';

  @override
  String get feedsEmptyBody =>
      'Em kiriting — tugab qolganda ilova ogohlantiradi.';

  @override
  String get feedsNoneInView => 'Filtrlarga hech narsa mos kelmadi';

  @override
  String get feedsNoneInViewBody =>
      'Butun omborni koʻrish uchun shartlarni olib tashlang.';

  @override
  String get feedsFilterAll => 'Barchasi';

  @override
  String get feedsFilterLowStock => 'Tugab qolyapti';

  @override
  String get feedsFilterType => 'Em turi';

  @override
  String get feedingBulkModeRabbits => 'Quyonlar';

  @override
  String get feedingBulkModeCages => 'Kataklar';

  @override
  String get feedingBulkAddRabbit => 'Quyon qoʻshish';

  @override
  String get feedingBulkRabbitsRequired => 'Kamida bitta quyonni tanlang';

  @override
  String get feedingBulkRemove => 'Roʻyxatdan chiqarish';

  @override
  String get feedingBulkCagesField => 'Qaysi kataklar';

  @override
  String get feedingBulkCagesRequired => 'Kamida bitta katakni tanlang';

  @override
  String get feedingBulkCagesPickTitle => 'Qaysi kataklarni oziqlantiramiz';

  @override
  String feedingBulkCagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count katak',
      one: '$count katak',
    );
    return '$_temp0';
  }

  @override
  String get feedingBulkWholeFarm => 'Butun ferma';

  @override
  String get feedingBulkClearSelection => 'Tanlovni bekor qilish';

  @override
  String get feedingBulkRowUnnamed => 'Qatorsiz';

  @override
  String get feedingBulkDone => 'Tayyor';

  @override
  String get feedingBulkNoCagesTitle => 'Hali katak yoʻq';

  @override
  String get feedingBulkNoCagesBody =>
      'Kataklarni kiriting — shunda oziqlantirishni bir zumda qatorga yoki butun fermaga yozish mumkin boʻladi.';

  @override
  String get feedingBulkQuantityEach => 'Har biriga qancha';

  @override
  String get feedingBulkQuantityEachHint => 'Raqam — bitta oluvchiga.';

  @override
  String feedingBulkQuantityEachNote(String amount) {
    return 'Raqam — bitta oluvchiga. Jami $amount sarflanadi.';
  }

  @override
  String feedingBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta oziqlantirish yozildi',
      one: '$count ta oziqlantirish yozildi',
    );
    return '$_temp0';
  }

  @override
  String get feedsFilterAllTypes => 'Barcha turlar';

  @override
  String get feedsInStock => 'Omborda';

  @override
  String get feedsMinStock => 'Minimal';

  @override
  String get feedsLowStockWarning => 'Minimumdan kam qoldi';

  @override
  String get feedsRefill => 'Toʻldirish';

  @override
  String get feedsWriteOff => 'Hisobdan chiqarish';

  @override
  String get feedsRefillTitle => 'Omborni toʻldirish';

  @override
  String get feedsWriteOffTitle => 'Ombordan hisobdan chiqarish';

  @override
  String feedsCurrentStock(String amount) {
    return 'Hozir omborda: $amount';
  }

  @override
  String get feedsQuantity => 'Qancha';

  @override
  String get feedsQuantityPositive => 'Noldan katta miqdor kiriting';

  @override
  String feedsRefilled(String amount) {
    return 'Ombor ${amount}ga toʻldirildi';
  }

  @override
  String feedsWrittenOff(String amount) {
    return '$amount hisobdan chiqarildi';
  }

  @override
  String get feedsAdjustFailed => 'Qoldiqni oʻzgartirib boʻlmadi';

  @override
  String get feedsDeleteTitle => 'Em oʻchirilsinmi?';

  @override
  String feedsDeleteBody(String name) {
    return '«$name» qoldiqlar tarixi bilan birga ombordan yoʻqoladi.';
  }

  @override
  String get feedsDeleted => 'Em oʻchirildi';

  @override
  String get feedsDeleteFailed => 'Emni oʻchirib boʻlmadi';

  @override
  String get feedFormNewTitle => 'Yangi em';

  @override
  String get feedFormEditTitle => 'Em';

  @override
  String get commonSectionMain => 'Asosiy';

  @override
  String get feedFormSectionStock => 'Ombor';

  @override
  String get feedFormName => 'Nomi';

  @override
  String get feedFormNameEmpty => 'Em nomini kiriting';

  @override
  String get feedFormType => 'Em turi';

  @override
  String get feedFormUnit => 'Nimada hisoblaymiz';

  @override
  String get feedFormCurrentStock => 'Hozir omborda';

  @override
  String get feedFormMinStock => 'Qolganda ogohlantirish';

  @override
  String get feedFormMinStockHelp =>
      'Bu qoldiqdan pastga tushsa, em bosh ekrandagi «Diqqat talab qiladi» boʻlimiga tushadi.';

  @override
  String get feedFormCost => 'Birlik narxi';

  @override
  String get feedFormRequired => 'Maydonni toʻldiring';

  @override
  String get feedFormNegative => 'Raqam manfiy boʻlishi mumkin emas';

  @override
  String get feedFormCreated => 'Em omborga qoʻshildi';

  @override
  String get feedFormUpdated => 'Em yangilandi';

  @override
  String get feedFormFailed => 'Emni saqlab boʻlmadi';

  @override
  String get feedingTitle => 'Oziqlantirishlar';

  @override
  String get feedingAdd => 'Oziqlantirishni yozish';

  @override
  String get feedingEmptyTitle => 'Oziqlantirish yozuvlari yoʻq';

  @override
  String get feedingEmptyBody =>
      'Oziqlantirishlarni belgilang — em sarfi ombordan oʻzi yechiladi.';

  @override
  String get feedingNoneInView => 'Bu davrda yozuv yoʻq';

  @override
  String get feedingNoneInViewBody =>
      'Boshqa davrni tanlang yoki filtrni tozalang.';

  @override
  String get feedingUnknownFeed => 'Em koʻrsatilmagan';

  @override
  String feedingForRabbit(String name) {
    return 'Quyon $name';
  }

  @override
  String feedingForCage(String number) {
    return '$number-katak';
  }

  @override
  String get feedingForFarm => 'Butun fermaga';

  @override
  String get feedingEdit => 'Oʻzgartirish';

  @override
  String get feedingDeleteTitle => 'Yozuv oʻchirilsinmi?';

  @override
  String get feedingDeleteBody =>
      'Oziqlantirish yozuvi oʻchiriladi. Yechilgan em omborga qaytmaydi.';

  @override
  String get feedingDeleted => 'Yozuv oʻchirildi';

  @override
  String get feedingDeleteFailed => 'Yozuvni oʻchirib boʻlmadi';

  @override
  String get commonPeriod => 'Davr';

  @override
  String get feedingFormNewTitle => 'Yangi oziqlantirish';

  @override
  String get feedingFormEditTitle => 'Oziqlantirish';

  @override
  String get feedingFormSectionWhom => 'Kimni oziqlantiramiz';

  @override
  String get feedingFormSectionWhat => 'Nima va qancha';

  @override
  String get feedingFormModeRabbit => 'Bitta quyonni';

  @override
  String get feedingFormModeCage => 'Butun katakni';

  @override
  String get feedingFormCage => 'Katak';

  @override
  String get feedingFormCageRequired => 'Katakni tanlang';

  @override
  String get feedingFormFeed => 'Em';

  @override
  String get feedingFormFeedRequired => 'Emni tanlang';

  @override
  String get feedingFormQuantity => 'Qancha';

  @override
  String get feedingFormQuantityRequired => 'Miqdorni kiriting';

  @override
  String get feedingFormWhen => 'Qachon';

  @override
  String get feedingFormNotes => 'Izohlar';

  @override
  String feedingFormStockLeft(String amount) {
    return '$amount qoldi';
  }

  @override
  String get feedingFormUpdated => 'Yozuv yangilandi';

  @override
  String get feedingFormFailed => 'Yozuvni saqlab boʻlmadi';

  @override
  String get feedingFormStockNote => 'Koʻrsatilgan miqdor ombordan yechiladi.';

  @override
  String get financeTitle => 'Moliya';

  @override
  String get financeAdd => 'Amaliyot qoʻshish';

  @override
  String get financeEmptyTitle => 'Hali amaliyot yoʻq';

  @override
  String get financeEmptyBody =>
      'Daromad va xarajatlarni yozib boring — ilova ferma foydasini oʻzi hisoblaydi.';

  @override
  String get financeNoneInView => 'Filtrlarga hech narsa mos kelmadi';

  @override
  String get financeNoneInViewBody =>
      'Butun roʻyxatni koʻrish uchun shartlarni olib tashlang.';

  @override
  String get financeIncome => 'Daromadlar';

  @override
  String get financeExpenses => 'Xarajatlar';

  @override
  String get financeBalance => 'Balans';

  @override
  String get financeSummaryPeriod => 'Butun davr uchun';

  @override
  String get financeSummaryFiltered => 'Tanlangan davr uchun';

  @override
  String get financeAll => 'Barchasi';

  @override
  String get financeOnlyIncome => 'Daromadlar';

  @override
  String get financeOnlyExpenses => 'Xarajatlar';

  @override
  String get financeCategory => 'Toifa';

  @override
  String get financeType => 'Turi';

  @override
  String get financeDate => 'Sana';

  @override
  String get financeDescription => 'Tavsif';

  @override
  String get financeAuthor => 'Kim yozdi';

  @override
  String financeAuthorLine(String name) {
    return 'Yozdi: $name';
  }

  @override
  String get financeTypeIncome => 'Daromad';

  @override
  String get financeTypeExpense => 'Xarajat';

  @override
  String get financeDeleteTitle => 'Amaliyot oʻchirilsinmi?';

  @override
  String get financeDeleteBody =>
      'Amaliyot roʻyxatdan qaytarib boʻlmaydigan tarzda yoʻqoladi.';

  @override
  String get financeDeleted => 'Amaliyot oʻchirildi';

  @override
  String get financeDeleteFailed => 'Amaliyotni oʻchirib boʻlmadi';

  @override
  String get txFormNewTitle => 'Yangi amaliyot';

  @override
  String get txFormEditTitle => 'Amaliyot';

  @override
  String get txFormSectionKind => 'Qanday amaliyot';

  @override
  String get commonSectionDetails => 'Tafsilotlar';

  @override
  String get txFormIncomeSubtitle => 'Sotuv, xizmatlar';

  @override
  String get txFormExpenseSubtitle => 'Xaridlar, davolash, em';

  @override
  String get txFormAmount => 'Summa';

  @override
  String get txFormAmountEmpty => 'Summani kiriting';

  @override
  String get txFormAmountPositive => 'Summa noldan katta boʻlishi kerak';

  @override
  String get txFormDate => 'Qachon';

  @override
  String get txFormRabbit => 'Quyon bilan bogʻlash';

  @override
  String get txFormRabbitHelp =>
      'Ixtiyoriy. Muayyan hayvon boʻyicha daromad va xarajatni koʻrish uchun kerak.';

  @override
  String get txFormDescription => 'Tavsif';

  @override
  String get txFormReceipt => 'Chek';

  @override
  String get txFormReceiptShoot => 'Chekni suratga oling';

  @override
  String get txFormReceiptFromGallery => 'Galereyadan';

  @override
  String get txFormReceiptReplace => 'Qayta suratga olish';

  @override
  String get txFormReceiptRemove => 'Chekni olib tashlash';

  @override
  String get txFormReceiptFailed => 'Suratni olib boʻlmadi';

  @override
  String get txFormCreated => 'Amaliyot yozildi';

  @override
  String get txFormUpdated => 'Amaliyot yangilandi';

  @override
  String get txFormFailed => 'Amaliyotni saqlab boʻlmadi';

  @override
  String get cagesTitle => 'Kataklar';

  @override
  String get cagesAdd => 'Katak qoʻshish';

  @override
  String get cagesSearchHint => 'Raqami yoki joyi';

  @override
  String get cagesOnlyAvailable => 'Faqat boʻshlar';

  @override
  String get cagesEmptyTitle => 'Hali katak yoʻq';

  @override
  String get cagesEmptyBody =>
      'Kataklarni kiriting — ular orqali quyonlarni qayerga joylash va qayerda joy borligi koʻrinadi.';

  @override
  String get cagesNothingFound => 'Hech narsa topilmadi';

  @override
  String get cagesNothingFoundBody =>
      'Soʻrovni tekshiring yoki filtrlarni olib tashlang.';

  @override
  String cagesOccupancy(int occupied, int capacity) {
    return '$capacity tadan $occupied tasi band';
  }

  @override
  String cagesLastCleaned(String date) {
    return '$date tozalangan';
  }

  @override
  String get cagesMarkCleaned => 'Tozalanganini belgilash';

  @override
  String get cagesCleaned => 'Tozalash belgilandi';

  @override
  String get cagesCleanFailed => 'Tozalashni belgilab boʻlmadi';

  @override
  String get cagesDeleteTitle => 'Katak oʻchirilsinmi?';

  @override
  String cagesDeleteBody(String number) {
    return '$number-katak roʻyxatdan yoʻqoladi. Undagi quyonlar kataksiz qoladi.';
  }

  @override
  String get cagesDeleted => 'Katak oʻchirildi';

  @override
  String get cagesDeleteFailed => 'Katakni oʻchirib boʻlmadi';

  @override
  String get cagesFilterCondition => 'Holati';

  @override
  String get cageFormNewTitle => 'Yangi katak';

  @override
  String get cageFormEditTitle => 'Katak';

  @override
  String get cageFormNumber => 'Raqami';

  @override
  String get cageFormNumberEmpty => 'Katak raqamini kiriting';

  @override
  String get cageFormCapacity => 'Nechta quyon sigʻadi';

  @override
  String get cageFormCapacityInvalid => 'Noldan katta raqam kiriting';

  @override
  String get cageFormCapacityGroup =>
      'Guruh katagida kamida ikkita joy boʻlishi kerak';

  @override
  String get cageFormSize => 'Oʻlchami';

  @override
  String get cageFormSizeHint => 'Masalan, 100×60×45 sm';

  @override
  String get cageFormLocation => 'Joyi';

  @override
  String get cageFormLocationHint => 'Masalan, ombor, chap qator';

  @override
  String get cageFormNotes => 'Eslatmalar';

  @override
  String get cageFormCreated => 'Katak qoʻshildi';

  @override
  String get cageFormUpdated => 'Katak yangilandi';

  @override
  String get cageFormFailed => 'Katakni saqlab boʻlmadi';

  @override
  String get rabbitsTitle => 'Quyonlar';

  @override
  String get rabbitsSearchHint => 'Laqabi yoki birka raqami';

  @override
  String get herdCagesNoPlace => 'Joyi koʻrsatilmagan';

  @override
  String get rabbitsEmptyTitle => 'Hali quyon yoʻq';

  @override
  String get rabbitsEmptyBody =>
      'Birinchi quyonni kiriting — undan butun hisob boshlanadi: nasl-nasabi, salomatligi va bolalari.';

  @override
  String get rabbitsEmptyAction => 'Quyon qoʻshish';

  @override
  String get rabbitsNothingFound => 'Hech kim topilmadi';

  @override
  String get rabbitsNothingFoundBody =>
      'Soʻrovni tekshiring yoki filtrlarni olib tashlang.';

  @override
  String get rabbitsFilterAll => 'Barchasi';

  @override
  String get rabbitsFilterMales => 'Erkaklar';

  @override
  String get rabbitsFilterFemales => 'Urgʻochilar';

  @override
  String get rabbitsFilterActive => 'Ishda';

  @override
  String get rabbitsFilterSold => 'Sotilgan';

  @override
  String get rabbitsFilterDead => 'Nobud boʻlgan';

  @override
  String get sexMale => 'Erkak';

  @override
  String get sexFemale => 'Urgʻochi';

  @override
  String get sexUnknown => 'Jinsi koʻrsatilmagan';

  @override
  String get rabbitNoTag => 'Birkasiz';

  @override
  String get weightTitle => 'Vaznlar';

  @override
  String weightSubtitle(String name) {
    return '$name';
  }

  @override
  String get weightEmptyTitle => 'Hali oʻlchov yoʻq';

  @override
  String get weightEmptyBody =>
      'Vaznni yozib boring — shu boʻyicha quyon oʻsayotgani yoki muammo borligi koʻrinadi.';

  @override
  String get weightAdd => 'Vaznni yozish';

  @override
  String get weightSummary => 'Xulosa';

  @override
  String get weightCurrent => 'Hozir';

  @override
  String get weightTrend => 'Oxirgi safardan beri';

  @override
  String get weightTotalChange => 'Butun davr uchun';

  @override
  String get weightHistory => 'Tarix';

  @override
  String get weightValue => 'Vazn, kg';

  @override
  String get weightValueHint => 'Masalan, 3,5';

  @override
  String get weightValueEmpty => 'Vaznni kiriting';

  @override
  String get weightValuePositive => 'Vazn noldan katta boʻlishi kerak';

  @override
  String get weightWhen => 'Qachon oʻlchandi';

  @override
  String get weightNotes => 'Eslatmalar';

  @override
  String get weightSaved => 'Vazn yozildi';

  @override
  String get weightSaveFailed => 'Vaznni yozib boʻlmadi';

  @override
  String get galleryTitle => 'Rasmlar galereyasi';

  @override
  String get galleryEmptyTitle => 'Hali rasm yoʻq';

  @override
  String get galleryEmptyBody =>
      'Rasm qoʻshing — kartochkada bittasi qoladi, bu yerda esa barchasi joylashadi.';

  @override
  String get galleryAdd => 'Rasm qoʻshish';

  @override
  String get galleryUploaded => 'Rasm qoʻshildi';

  @override
  String get galleryCaptionTitle => 'Rasmga izoh';

  @override
  String get galleryCaptionLabel => 'Masalan, «Soch olingandan keyin»';

  @override
  String get galleryCaptionSkip => 'Izohsiz';

  @override
  String get galleryDeleteTitle => 'Rasm oʻchirilsinmi?';

  @override
  String get galleryDeleteBody => 'Uni qayta tiklab boʻlmaydi.';

  @override
  String get galleryDeleted => 'Rasm oʻchirildi';

  @override
  String get pedigreeTitle => 'Nasl-nasab';

  @override
  String get rabbitDetailEdit => 'Oʻzgartirish';

  @override
  String get rabbitDetailDeleteTitle => 'Quyon oʻchirilsinmi?';

  @override
  String rabbitDetailDeleteBody(String name) {
    return '$name bilan birga uning vaznlari, emlashlari va davolash yozuvlari ham oʻchadi.';
  }

  @override
  String get rabbitDetailDeleted => 'Quyon oʻchirildi';

  @override
  String get rabbitDetailDeleteFailed => 'Quyonni oʻchirib boʻlmadi';

  @override
  String get settingsTitle => 'Sozlamalar';

  @override
  String get healthTitle => 'Salomatlik';

  @override
  String get healthMenuLabel => 'Emlash va davolash';

  @override
  String get healthKindAll => 'Barchasi';

  @override
  String get healthKindVaccination => 'Emlashlar';

  @override
  String get healthKindTreatment => 'Davolash';

  @override
  String get healthEntryVaccination => 'Emlash';

  @override
  String get healthEntryTreatment => 'Davolash';

  @override
  String get healthPickRabbit => 'Bitta quyon tarixi';

  @override
  String get healthEmptyTitle => 'Poda salomatligi hali yozilmagan';

  @override
  String get healthEmptyBody =>
      'Emlash va davolashni belgilang — har bir quyonda nima boʻlgani va qachon qayta emlash kerakligi koʻrinadi.';

  @override
  String get healthNoneInViewTitle => 'Bu tanlovda boʻsh';

  @override
  String healthNoneForRabbitTitle(String name) {
    return '${name}da salomatlik yozuvi yoʻq';
  }

  @override
  String get healthNoneInViewBody =>
      'Filtrni olib tashlang — qolgan yozuvlar joyida turibdi.';

  @override
  String get healthRecordTitle => 'Nimani yozamiz?';

  @override
  String get healthRecordVaccination => 'Emlashni';

  @override
  String get healthRecordTreatment => 'Davolashni';

  @override
  String get farmSectionMoney => 'Pul';

  @override
  String get farmTransactions => 'Daromad va xarajatlar';

  @override
  String get farmSectionFeed => 'Emlar';

  @override
  String get farmFeedStock => 'Em zaxirasi';

  @override
  String get farmFeedingRecords => 'Oziqlantirishlar';

  @override
  String get farmSectionHealth => 'Salomatlik';

  @override
  String get farmSectionReports => 'Hisobotlar';

  @override
  String get farmReports => 'Ferma boʻyicha xulosa';

  @override
  String get farmSectionPeople => 'Odamlar';

  @override
  String get farmStaff => 'Xodimlar';

  @override
  String get farmSectionApp => 'Ilova';

  @override
  String get farmSettings => 'Sozlamalar';

  @override
  String get farmAbout => 'Ilova haqida';

  @override
  String get farmAboutBody =>
      'Quyonchilik fermasining jonivorlari, emlari, salomatligi va pulini hisobga olish.';

  @override
  String get farmLogout => 'Chiqish';

  @override
  String get settingsAppearance => 'Tashqi koʻrinish';

  @override
  String get settingsTheme => 'Mavzu';

  @override
  String get settingsAccent => 'Urgʻu rangi';

  @override
  String get settingsLanguage => 'Til';

  @override
  String get settingsNotifications => 'Bildirishnomalar';

  @override
  String get settingsDigestToggle => 'Xoʻjalik boʻyicha kunlik xulosa';

  @override
  String get settingsHerd => 'Poda';

  @override
  String get settingsPurposeAll => 'Hamma quyonlarga maqsad';

  @override
  String get settingsPurposeAllHint =>
      'Koʻpchilik fermalar quyonlarni bitta narsa uchun boqadi. Bir marta qoʻying — har kartada javob bermang.';

  @override
  String get settingsPurposeAllTitle => 'Hammaga maqsad qoʻyilsinmi?';

  @override
  String settingsPurposeAllBody(String purpose) {
    return 'Xoʻjalikdagi barcha tirik quyonlarga «$purpose» qoʻyiladi. Chiqib ketganlar oʻzgarmaydi. Boshqa tayinlov almashtiriladi va faqat bittalab qaytariladi. Yangi quyonlar ham shu tayinlov bilan qoʻshiladi.';
  }

  @override
  String get settingsPurposeAllApply => 'Qoʻyish';

  @override
  String settingsPurposeAllDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count quyon oʻzgardi.',
      one: '$count quyon oʻzgardi.',
      zero: 'Oʻzgartiradigan narsa yoʻq — hammada allaqachon shunday.',
    );
    return '$_temp0';
  }

  @override
  String get settingsAbout => 'Ilova haqida';

  @override
  String get settingsVersion => 'Versiya';

  @override
  String get settingsSupport => 'Qoʻllab-quvvatlash';

  @override
  String get supportRequestTitle => 'Qoʻllab-quvvatlash';

  @override
  String get supportRequestHint =>
      'Nima boʻlganini yozing. Javob shu ekranning oʻziga va telefoningizga bildirishnoma boʻlib keladi.';

  @override
  String get supportRequestPlaceholder =>
      'Masalan: quyon qoʻsha olmayapman — ilova saqlashda osilib qolyapti';

  @override
  String get supportRequestTooShort =>
      'Muammoni batafsilroq yozing — kamida 10 ta belgi';

  @override
  String get supportRequestSend => 'Yuborish';

  @override
  String get supportRequestSent => 'Murojaat yuborildi';

  @override
  String get supportContactHint => 'Yoki toʻgʻridan-toʻgʻri bogʻlaning:';

  @override
  String get settingsPrivacyPolicy => 'Maxfiylik siyosati';

  @override
  String get settingsLogout => 'Akkauntdan chiqish';

  @override
  String get logoutDialogTitle => 'Akkauntdan chiqilsinmi?';

  @override
  String get logoutDialogBody =>
      'Yozuvlar serverda qoladi — kirganingizdan keyin ularni yana koʻrasiz.';

  @override
  String get logoutDialogConfirm => 'Chiqish';

  @override
  String get settingsThemeLight => 'Yorugʻ';

  @override
  String get settingsThemeSystem => 'Tizimdagidek';

  @override
  String get settingsThemeDark => 'Qorongʻi';

  @override
  String get settingsSubscription => 'Tarif';

  @override
  String get subscriptionTitle => 'Tarif';

  @override
  String get subscriptionNoPlan => 'Tarif belgilanmagan';

  @override
  String get subscriptionNoPlanHint =>
      'Tarifni ulash uchun qoʻllab-quvvatlash bilan bogʻlaning.';

  @override
  String get subscriptionContactSupport => 'Qoʻllab-quvvatlashga yozish';

  @override
  String get subscriptionFree => 'Bepul tarif';

  @override
  String get subscriptionForever => 'Muddatsiz';

  @override
  String subscriptionExpiresOn(String date) {
    return '${date}gacha amal qiladi';
  }

  @override
  String subscriptionExpired(String date) {
    return 'Muddati ${date}da tugagan';
  }

  @override
  String subscriptionPricePerPeriod(String price) {
    return '$price s / 30 kun';
  }

  @override
  String get subscriptionPay => 'Toʻlash';

  @override
  String get subscriptionPayAbroadTitle =>
      'Karta bilan toʻlov hozircha faqat Tojikistonda';

  @override
  String get subscriptionPayAbroadBody =>
      'Tarifni qoʻlda uzaytiramiz — qoʻllab-quvvatlashga yozing, javob berishadi.';

  @override
  String get subscriptionPayAbroadAction => 'Qoʻllab-quvvatlashga yozish';

  @override
  String get subscriptionOpenPaymentPage => 'Toʻlov sahifasini ochish';

  @override
  String get subscriptionAfterPayingHint =>
      'Ochilgan havola orqali toʻlang, keyin bu yerga qaytib «Toʻlovni tekshirish» tugmasini bosing.';

  @override
  String get subscriptionCheckPayment => 'Toʻlovni tekshirish';

  @override
  String get subscriptionPaymentCompleted => 'Toʻlov oʻtdi, tarif uzaytirildi';

  @override
  String get subscriptionPaymentPending =>
      'Bank toʻlovni hali tasdiqlamadi — bir daqiqadan keyin qayta urinib koʻring';

  @override
  String get splashTagline => 'Fermani boshqarish';

  @override
  String get registerTitle => 'Oʻz fermam';

  @override
  String get registerSubtitle =>
      'Fermani oching — ishchilarga ruxsatni keyin berasiz';

  @override
  String get registerFarmName => 'Ferma nomi';

  @override
  String get registerFarmNameHint =>
      'Boʻsh qoldirish mumkin — ismingiz bilan ataymiz. Keyin nomni oʻzgartirib boʻlmaydi';

  @override
  String get registerFarmNameShort => 'Juda qisqa';

  @override
  String get registerFullName => 'Ism va familiya';

  @override
  String get registerFullNameHint => 'Ismingiz nima';

  @override
  String get registerFullNameEmpty => 'Ismingizni kiriting';

  @override
  String get registerFullNameShort => 'Juda qisqa';

  @override
  String get registerEmailEmpty => 'Pochtani kiriting';

  @override
  String get registerEmailInvalid => 'Manzilda xatolik boʻlsa kerak';

  @override
  String get registerSubmit => 'Fermani ochish';

  @override
  String get registerHaveAccount => 'Akkauntingiz bormi?';

  @override
  String get registerFailed => 'Roʻyxatdan oʻtib boʻlmadi';

  @override
  String get registerConsentPrefix => 'Men ';

  @override
  String get registerConsentLink => 'maxfiylik siyosatini qabul qilaman';

  @override
  String get registerConsentRequired =>
      'Davom etish uchun maxfiylik siyosatini qabul qilish kerak';

  @override
  String get birthsTitle => 'Tugʻishlar';

  @override
  String get birthsEmptyTitle => 'Hali tugʻish yoʻq';

  @override
  String get birthsEmptyBody =>
      'Tugʻishni yozing — ilova bolalarga kartochkalarni oʻzi ochadi.';

  @override
  String get birthsAdd => 'Tugʻishni yozish';

  @override
  String get birthsMotherUnknown => 'Onasi koʻrsatilmagan';

  @override
  String birthsMotherLine(String name) {
    return 'Onasi: $name';
  }

  @override
  String get birthsFromBreeding => 'Juftlashtirish yozuvi boʻyicha';

  @override
  String get birthsAlive => 'Tirik';

  @override
  String get birthsDead => 'Oʻlik';

  @override
  String get birthsWeaned => 'Ajratilgan';

  @override
  String get birthsSurvival => 'Omon qolish';

  @override
  String get birthsComplications => 'Asoratlar';

  @override
  String get birthsDeleteTitle => 'Tugʻish haqidagi yozuv oʻchirilsinmi?';

  @override
  String get birthsDeleteBody =>
      'Bolalar kartochkalari qoladi — faqat tugʻish haqidagi yozuv oʻchadi.';

  @override
  String get birthsDeleted => 'Yozuv oʻchirildi';

  @override
  String get birthsDeleteFailed => 'Yozuvni oʻchirib boʻlmadi';

  @override
  String get birthsCreateKits => 'Bolalarga kartochka ochish';

  @override
  String get birthsKitsDialogTitle => 'Bolalarga kartochka ochilsinmi?';

  @override
  String birthsKitsDialogBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta kartochka ochiladi',
      one: '$count ta kartochka ochiladi',
    );
    return '$_temp0';
  }

  @override
  String get birthsNamePrefix => 'Laqab boshi';

  @override
  String get birthsNamePrefixHint => 'Masalan, Oqcha-';

  @override
  String birthsNamePreview(String first, String second) {
    return 'Bunday boʻladi: $first, $second, …';
  }

  @override
  String birthsKitsCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta kartochka ochildi',
      one: '$count ta kartochka ochildi',
    );
    return '$_temp0';
  }

  @override
  String get birthsKitsFailed => 'Kartochkalarni ochib boʻlmadi';

  @override
  String get birthFormNewTitle => 'Yangi tugʻish';

  @override
  String get birthFormEditTitle => 'Tugʻish';

  @override
  String get birthFormMother => 'Onasi';

  @override
  String get birthFormDate => 'Qachon tugʻdi';

  @override
  String get birthFormSectionLitter => 'Bola soni';

  @override
  String get birthFormAliveLabel => 'Tirik tugʻildi';

  @override
  String get birthFormDeadLabel => 'Oʻlik tugʻildi';

  @override
  String get birthFormAliveEmpty => 'Sonini kiriting';

  @override
  String get birthFormComplications => 'Asoratlar';

  @override
  String get birthFormComplicationsHint =>
      'Nimadir notoʻgʻri ketgan boʻlsa, yozing';

  @override
  String get birthFormNotes => 'Eslatmalar';

  @override
  String get birthFormAutoKits => 'Bolalarga kartochkani darhol ochish';

  @override
  String get birthFormCreated => 'Tugʻish yozildi';

  @override
  String get birthFormUpdated => 'Yozuv yangilandi';

  @override
  String get birthFormFailed => 'Yozuvni saqlab boʻlmadi';

  @override
  String get breedsTitle => 'Zotlar';

  @override
  String get breedsSearchHint => 'Zot nomi';

  @override
  String get breedsAdd => 'Zot qoʻshish';

  @override
  String get breedsEmptyTitle => 'Hali zot yoʻq';

  @override
  String get breedsEmptyBody =>
      'Zotlarni kiriting — ular boʻyicha juft tanlash va vazn qoʻshimini solishtirish qulay boʻladi.';

  @override
  String get breedsNothingFound => 'Hech narsa topilmadi';

  @override
  String get breedsNothingFoundBody => 'Soʻrovni tekshiring.';

  @override
  String get breedsDeleteTitle => 'Zot oʻchirilsinmi?';

  @override
  String breedsDeleteBody(String name) {
    return '«$name» maʼlumotnomadan yoʻqoladi. Bu zotdagi quyonlar qoladi, lekin zotsiz.';
  }

  @override
  String get breedsDeleted => 'Zot oʻchirildi';

  @override
  String get breedsDeleteFailed => 'Zotni oʻchirib boʻlmadi';

  @override
  String get breedPurposeMeat => 'Goʻshtchilik';

  @override
  String get breedPurposeFur => 'Momiqchilik';

  @override
  String get breedPurposeDecorative => 'Dekorativ';

  @override
  String get breedPurposeCombined => 'Goʻsht-teri';

  @override
  String get breedFormNewTitle => 'Yangi zot';

  @override
  String get breedFormEditTitle => 'Zot';

  @override
  String get breedFormName => 'Nomi';

  @override
  String get breedFormNameHint => 'Masalan, Kaliforniya';

  @override
  String get breedFormNameEmpty => 'Zot nomini kiriting';

  @override
  String get breedFormPurpose => 'Nima uchun boqiladi';

  @override
  String get breedFormDescription => 'Tavsif';

  @override
  String get breedFormDescriptionHint => 'Bu zot nimasi bilan farq qiladi';

  @override
  String get breedFormSectionTraits => 'Xususiyatlari';

  @override
  String get breedFormWeight => 'Oʻrtacha vazn, kg';

  @override
  String get breedFormWeightHint => 'Masalan, 4,5';

  @override
  String get breedFormLitter => 'Odatiy bola soni';

  @override
  String get breedFormLitterHint => 'Masalan, 8';

  @override
  String get breedFormLitterSuffix => 'quyoncha';

  @override
  String get breedFormCreated => 'Zot qoʻshildi';

  @override
  String get breedFormUpdated => 'Zot yangilandi';

  @override
  String get breedFormFailed => 'Zotni saqlab boʻlmadi';

  @override
  String get breedingDetailTitle => 'Juftlashtirish';

  @override
  String get breedingStatus => 'Holati';

  @override
  String get breedingParents => 'Juft';

  @override
  String breedingTag(String tag) {
    return '$tag-birka';
  }

  @override
  String get breedingDates => 'Sanalar';

  @override
  String get breedingDate => 'Juftlashtirish sanasi';

  @override
  String get breedingExpected => 'Kutilayotgan tugʻish';

  @override
  String get breedingPalpation => 'Paypaslash sanasi';

  @override
  String get breedingPregnancy => 'Boʻgʻozlik';

  @override
  String get breedingPregnancyYes => 'Tasdiqlangan';

  @override
  String get breedingPregnancyNo => 'Tasdiqlanmagan';

  @override
  String get breedingNotes => 'Eslatmalar';

  @override
  String get breedingRegisterBirth => 'Tugʻishni yozish';

  @override
  String get breedingDeleteTitle => 'Juftlashtirish yozuvi oʻchirilsinmi?';

  @override
  String get breedingDeleteBody => 'Uni qaytarib boʻlmaydi.';

  @override
  String get breedingDeleted => 'Yozuv oʻchirildi';

  @override
  String get breedingDeleteFailed => 'Yozuvni oʻchirib boʻlmadi';

  @override
  String get breedingFormNewTitle => 'Yangi juftlashtirish';

  @override
  String get breedingFormEditTitle => 'Juftlashtirish';

  @override
  String get breedingFormPrefilled => 'Juft tanlovdan qoʻyildi';

  @override
  String get breedingFormMale => 'Erkak';

  @override
  String get breedingFormFemale => 'Urgʻochi';

  @override
  String get breedingFormMaleRequired => 'Erkakni tanlang';

  @override
  String get breedingFormFemaleRequired => 'Urgʻochini tanlang';

  @override
  String get breedingFormNotesHint =>
      'Bu juftlashtirish haqida eslab qolish kerak boʻlgan narsa';

  @override
  String get breedingFormCreated => 'Juftlashtirish yozildi';

  @override
  String get breedingFormUpdated => 'Yozuv yangilandi';

  @override
  String get breedingFormFailed => 'Yozuvni saqlab boʻlmadi';

  @override
  String get plannerTitle => 'Juft tanlash';

  @override
  String get plannerIntro =>
      'Erkak va urgʻochini tanlang — ilova nasl-nasabini koʻrib, ular qanchalik qarindosh ekanini aytadi.';

  @override
  String get plannerAnalysisFailed => 'Nasl-nasabni tahlil qilib boʻlmadi';

  @override
  String get plannerResults => 'Natija';

  @override
  String get plannerCoefficient => 'Qarindoshlik darajasi';

  @override
  String get plannerCommonAncestors => 'Umumiy ajdodlar';

  @override
  String plannerGenerations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count avlod',
      one: '$count avlod',
    );
    return '$_temp0 oldin';
  }

  @override
  String get plannerAdvice => 'Nima qilish kerak';

  @override
  String get plannerPickBoth => 'Ikkalasini ham tanlang';

  @override
  String get plannerPlanned => 'Juftlashtirish rejalashtirildi';

  @override
  String get plannerPlan => 'Juftlashtirishni rejalashtirish';

  @override
  String get plannerPedigreeFailed => 'Nasl-nasabni yuklab boʻlmadi';

  @override
  String get staffTitle => 'Ishchilar';

  @override
  String get staffInvite => 'Taklif qilish';

  @override
  String get staffOwner => 'Egasi';

  @override
  String get staffMembers => 'Xodimlar';

  @override
  String get staffEmptyBody =>
      'Fermada hozircha faqat siz bor. Yordamchi taklif qiling — u shu xoʻjalikka kirish huquqini oladi.';

  @override
  String get staffInvitesFailed => 'Takliflarni yuklab boʻlmadi';

  @override
  String get staffPendingInvites => 'Javob kutilmoqda';

  @override
  String staffAccessClosed(String name) {
    return '$name uchun kirish yopildi';
  }

  @override
  String get staffSaved => 'Oʻzgarishlar saqlandi';

  @override
  String get staffRevokeTitle => 'Taklif bekor qilinsinmi?';

  @override
  String staffRevokeBody(String email) {
    return '$email uchun kod ishlamay qoladi. Istalgan payt yangisini chiqarish mumkin.';
  }

  @override
  String get staffKeep => 'Qoldirish';

  @override
  String get staffRevoke => 'Bekor qilish';

  @override
  String get staffRevoked => 'Taklif bekor qilindi';

  @override
  String get planLimitStaffTitle => 'Tarif boʻyicha ishtirokchilar chegarasi';

  @override
  String get planLimitStaffBody =>
      'Ferma tarkibi joriy tarifga ruxsat etilgan ishtirokchilar chegarasiga yetdi. Yana taklif qilish uchun kattaroq chegarali tarif kerak.';

  @override
  String get staffInviteTitle => 'Fermaga taklif qilish';

  @override
  String get staffInviteEmailHint => 'Odam shu pochta orqali kiradi';

  @override
  String get staffRole => 'Roli';

  @override
  String get staffIssueCode => 'Ishchini taklif qilish';

  @override
  String get staffInvitedTitle => 'Ishchi taklif qilindi';

  @override
  String staffInvitedPhoneBody(String phone) {
    return '$phone raqamiga SMS yuborilmaydi — taklifni oʻzingiz yuboring. Havola orqali u ilovani oʻrnatadi va oʻz raqami bilan kiradi, kod esa unga SMS orqali keladi.';
  }

  @override
  String staffInvitedEmailBody(String email) {
    return 'Taklif xati $email manziliga yuborildi. Ishchi shu manzil bilan kiradi — kod unga xat orqali keladi.';
  }

  @override
  String get staffInviteChannelPhone => 'Telefon orqali';

  @override
  String get staffInviteChannelEmail => 'Pochta orqali';

  @override
  String get staffInvitePhoneHint => '+992 XX XXX XX XX';

  @override
  String get staffInvitePhoneInvalid => 'Raqam +992 90 123 45 67 koʻrinishida';

  @override
  String get staffInviteNameLabel => 'Ishchining ismi';

  @override
  String get staffInviteNameHint => 'U fermada shu nom bilan koʻrinadi';

  @override
  String get staffInviteNameEmpty => 'Ishchining ismini kiriting';

  @override
  String staffValidUntil(String date) {
    return '${date}gacha amal qiladi';
  }

  @override
  String get staffMakeManager => 'Boshqaruvchi qilish';

  @override
  String get staffMakeWorker => 'Ishchi qilish';

  @override
  String get staffOpenAccess => 'Kirishni ochish';

  @override
  String get staffCloseAccess => 'Kirishni yopish';

  @override
  String get staffTransferOwnership => 'Xoʻjalikni topshirish';

  @override
  String get staffTransferTitle => 'Xoʻjalik topshirilsinmi?';

  @override
  String staffTransferBody(String name) {
    return 'Ferma ${name}ga oʻtadi, siz esa boshqaruvchi boʻlasiz. Buni ortga qaytarib boʻlmaydi.';
  }

  @override
  String get staffTransferConfirm => 'Fermani topshirish';

  @override
  String staffTransferred(String name) {
    return 'Xoʻjalik ${name}ga topshirildi';
  }

  @override
  String get rabbitTapToZoom => 'Yaqinroq koʻrish uchun bosing';

  @override
  String rabbitTagLine(String tag) {
    return '$tag-birka';
  }

  @override
  String get rabbitMainInfo => 'Asosiy';

  @override
  String get rabbitBreed => 'Zoti';

  @override
  String get rabbitBreedUnknown => 'Koʻrsatilmagan';

  @override
  String get rabbitSex => 'Jinsi';

  @override
  String get rabbitAge => 'Yoshi';

  @override
  String get rabbitBirthDate => 'Tugʻilgan sanasi';

  @override
  String get rabbitAcquiredDate => 'Qachon sotib olingan';

  @override
  String get rabbitAcquiredDateEmpty => 'Fermada tugʻilgan';

  @override
  String get rabbitColor => 'Rangi';

  @override
  String get rabbitWeight => 'Vazni';

  @override
  String get rabbitQuickActions => 'Nimalarni koʻrish mumkin';

  @override
  String get rabbitWeightHistory => 'Vazn tarixi';

  @override
  String get rabbitPedigree => 'Nasl-nasab';

  @override
  String get rabbitStatus => 'Holati';

  @override
  String get rabbitCondition => 'Ahvoli';

  @override
  String get rabbitPurpose => 'Maqsadi';

  @override
  String get rabbitPlacement => 'Qayerda yashaydi';

  @override
  String get rabbitCage => 'Katak';

  @override
  String get rabbitLocation => 'Joyi';

  @override
  String get rabbitParents => 'Ota-onasi';

  @override
  String get rabbitFather => 'Otasi';

  @override
  String get rabbitMother => 'Onasi';

  @override
  String get rabbitNotes => 'Eslatmalar';

  @override
  String get rabbitDates => 'Yozuvlar';

  @override
  String get rabbitCreatedAt => 'Qoʻshilgan';

  @override
  String get rabbitUpdatedAt => 'Oʻzgartirilgan';

  @override
  String get purposeBreeding => 'Naslga';

  @override
  String get purposeMeat => 'Goʻshtga';

  @override
  String get purposeFur => 'Teriga';

  @override
  String get purposeSale => 'Sotishga';

  @override
  String get purposePet => 'Uy hayvoni';

  @override
  String get rabbitFormNewTitle => 'Yangi quyon';

  @override
  String get rabbitFormEditTitle => 'Quyon';

  @override
  String get rabbitFormPhotoAdd => 'Rasm qoʻshish';

  @override
  String get rabbitFormPhotoChange => 'Rasmni almashtirish';

  @override
  String get rabbitFormPhotoGallery => 'Galereyadan tanlash';

  @override
  String get rabbitFormPhotoCamera => 'Kamerada suratga olish';

  @override
  String get rabbitFormPhotoRemove => 'Rasmni olib tashlash';

  @override
  String get rabbitFormPhotoFailed => 'Rasmni olib boʻlmadi';

  @override
  String get rabbitFormName => 'Laqabi';

  @override
  String get rabbitFormNameHint => 'Ismi nima';

  @override
  String get rabbitFormNameEmpty => 'Laqabini kiriting';

  @override
  String get rabbitFormTag => 'Birka raqami';

  @override
  String get rabbitFormTagEmpty => 'Birka raqamini kiriting';

  @override
  String get rabbitFormBreedRequired => 'Zotni tanlang';

  @override
  String get rabbitFormBreedsFailed => 'Zotlarni yuklab boʻlmadi';

  @override
  String get rabbitFormColor => 'Rangi';

  @override
  String get rabbitFormColorHint => 'Kulrang, oq, qora…';

  @override
  String get rabbitFormWeight => 'Vazni, kg';

  @override
  String get rabbitFormNotes => 'Eslatmalar';

  @override
  String get rabbitFormNotesHint =>
      'Bu quyon haqida eslab qolish kerak boʻlgan narsa';

  @override
  String get rabbitFormCreated => 'Quyon qoʻshildi';

  @override
  String get rabbitFormUpdated => 'Maʼlumotlar yangilandi';

  @override
  String get rabbitFormFailed => 'Saqlab boʻlmadi';

  @override
  String get rabbitFormLoadFailed => 'Quyonni yuklab boʻlmadi';

  @override
  String get planLimitRabbitsTitle => 'Tarif boʻyicha quyonlar chegarasi';

  @override
  String get planLimitRabbitsBody =>
      'Ferma joriy tarifga ruxsat etilgan quyonlar chegarasiga yetdi. Yana qoʻshish uchun kattaroq chegarali tarif kerak — ferma egasiga murojaat qiling.';

  @override
  String get statusHealthy => 'Sogʻlom';

  @override
  String get statusSick => 'Kasal';

  @override
  String get statusQuarantine => 'Karantinda';

  @override
  String get statusPregnant => 'Boʻgʻoz';

  @override
  String get statusSold => 'Sotilgan';

  @override
  String get statusDead => 'Nobud boʻlgan';

  @override
  String get purposeShow => 'Koʻrgazmaga';

  @override
  String periodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kun',
      one: '$count kun',
    );
    return '$_temp0';
  }

  @override
  String periodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oy',
      one: '$count oy',
    );
    return '$_temp0';
  }

  @override
  String get periodYear => 'Yil';

  @override
  String get periodAll => 'Butun davr';

  @override
  String get statusInactive => 'Faol emas';

  @override
  String get pedigreeSelf => 'Quyon';

  @override
  String get pedigreeGrandparents => 'Bobo va buvilar';

  @override
  String get pedigreeFathersParents => 'Otaning ota-onasi';

  @override
  String get pedigreeMothersParents => 'Onaning ota-onasi';

  @override
  String get pedigreeHint => 'Quyonni ochish uchun kartochkani bosing';

  @override
  String get pedigreeGrandfather => 'Bobosi';

  @override
  String get pedigreeGrandmother => 'Buvisi';

  @override
  String get chartNoData => 'Hozircha koʻrsatadigan narsa yoʻq';

  @override
  String get chartWeight => 'Vazn grafigi';

  @override
  String get feedStatsTitle => 'Ombor raqamlarda';

  @override
  String get feedStatsEmptyTitle => 'Ombor hali boʻsh';

  @override
  String get feedStatsEmptyBody =>
      'Emlarni kiriting — bu yerda zaxira tarkibi, uning qiymati va qoldiqlar haqida ogohlantirishlar paydo boʻladi.';

  @override
  String get feedStatsPositions => 'Em xillari';

  @override
  String get feedStatsLow => 'Tugab qolyapti';

  @override
  String get feedStatsValue => 'Zaxira qiymati';

  @override
  String get feedStatsByType => 'Turlar boʻyicha tarkib';

  @override
  String get feedStatsLowList => 'Tugab qolayotgan qoldiqlar';

  @override
  String get feedStatsAllGood => 'Barcha turlar boʻyicha zaxira yetarli';

  @override
  String feedStatsMinimum(String amount) {
    return 'minimum $amount';
  }

  @override
  String get feedingStatsTitle => 'Oziqlantirishlar raqamlarda';

  @override
  String get feedingStatsEmptyTitle => 'Bu davrda oziqlantirish boʻlmagan';

  @override
  String get feedingStatsEmptyBody =>
      'Kengroq davrni tanlang yoki oziqlantirishni yozing — em sarfi va xarajatlar oʻzi hisoblanadi.';

  @override
  String get feedingStatsCount => 'Oziqlantirishlar';

  @override
  String get feedingStatsCost => 'Em xarajati';

  @override
  String get feedingStatsGiven => 'Berildi';

  @override
  String get feedingStatsByFeed => 'Emlar boʻyicha';

  @override
  String feedingStatsChartTitle(String unit) {
    return 'Em turlari boʻyicha sarf, $unit';
  }

  @override
  String get feedingStatsChartTitlePlain => 'Em turlari boʻyicha sarf';

  @override
  String get financeStatsTitle => 'Moliya raqamlarda';

  @override
  String get financeStatsEmptyTitle => 'Bu davrda amaliyot boʻlmagan';

  @override
  String get financeStatsEmptyBody =>
      'Kengroq davrni tanlang yoki birinchi amaliyotni yozing — yakunlar oʻzi hisoblanadi.';

  @override
  String get financeProfit => 'Foyda';

  @override
  String get financeLoss => 'Zarar';

  @override
  String get financeIncomeByCategory => 'Toifalar boʻyicha daromad';

  @override
  String get financeExpensesByCategory => 'Toifalar boʻyicha xarajat';

  @override
  String get financeRecent => 'Soʻnggi amaliyotlar';

  @override
  String get txCategorySaleRabbit => 'Quyon sotish';

  @override
  String get txCategorySaleMeat => 'Goʻsht sotish';

  @override
  String get txCategorySaleFur => 'Teri sotish';

  @override
  String get txCategoryBreedingFee => 'Juftlashtirish uchun toʻlov';

  @override
  String get txCategoryFeed => 'Em';

  @override
  String get txCategoryVeterinary => 'Davolash';

  @override
  String get txCategoryEquipment => 'Uskunalar';

  @override
  String get txCategoryUtilities => 'Elektr, suv, isitish';

  @override
  String get txCategoryOther => 'Boshqa';

  @override
  String get reportsOutcomeUnknown => 'Natija koʻrsatilmagan';

  @override
  String get reportsFeedUsed => 'Sarflandi';

  @override
  String get reportsTabFarm => 'Ferma';

  @override
  String get reportsTabHealth => 'Salomatlik';

  @override
  String get reportsTabFinance => 'Pul';

  @override
  String reportsPeriodRange(String from, String to) {
    return '$from dan $to gacha';
  }

  @override
  String get reportsPopulationNow => 'Hozir quyonlar';

  @override
  String get reportsBirths => 'Tugʻishlar';

  @override
  String get reportsBreedings => 'Juftlashtirishlar';

  @override
  String get reportsVaccinations => 'Emlashlar';

  @override
  String get reportsMedicalRecords => 'Davolash';

  @override
  String get reportsFeedings => 'Oziqlantirishlar';

  @override
  String get reportsActivity => 'Davr uchun';

  @override
  String get reportsByBreed => 'Zotlar boʻyicha jonivorlar';

  @override
  String get reportsByPurpose => 'Maqsadi boʻyicha';

  @override
  String reportsBreedUnknown(int id) {
    return '$id-zot';
  }

  @override
  String get reportsMoney => 'Davr uchun pul';

  @override
  String get reportsNoActivityTitle => 'Bu davrda yozuv yoʻq';

  @override
  String get reportsNoActivityBody =>
      'Kengroq davrni tanlang — yoki juftlashtirish, emlash, oziqlantirishni yozing, ular shu yerda paydo boʻladi.';

  @override
  String get reportsFarmEmptyTitle => 'Hisobot uchun hali material yoʻq';

  @override
  String get reportsFarmEmptyBody =>
      'Birinchi quyonni kiriting — keyin hisobot kundalik yozuvlardan oʻzi toʻplanadi.';

  @override
  String get reportsHealthEmptyTitle =>
      'Bu davrda emlash va davolash boʻlmagan';

  @override
  String get reportsHealthEmptyBody =>
      'Kengroq davrni tanlang yoki emlashni belgilang — hisobot oʻzi hisoblanadi.';

  @override
  String get reportsVaccinesByName => 'Vaksinalar boʻyicha emlashlar';

  @override
  String get reportsRecordsByOutcome => 'Natijalar boʻyicha davolash';

  @override
  String get farmSectionPlatform => 'Platforma';

  @override
  String get farmPlatformAdmin => 'Fermalar va tariflar';

  @override
  String get platformTitle => 'Platforma';

  @override
  String get platformTabSummary => 'Xulosa';

  @override
  String get platformTabFarms => 'Fermalar';

  @override
  String get platformTabPlans => 'Tariflar';

  @override
  String get platformTabAnnouncements => 'Eʼlonlar';

  @override
  String get platformTabSupport => 'Murojaatlar';

  @override
  String get platformSummarySectionFarms => 'Fermalar';

  @override
  String get platformSummarySectionStatus => 'Holat';

  @override
  String get platformSummarySectionActivity => 'Faollik';

  @override
  String get platformSummarySectionData => 'Maʼlumotlar';

  @override
  String get platformSummaryTotalFarms => 'Jami fermalar';

  @override
  String get platformSummaryFree => 'Bepulda';

  @override
  String get platformSummaryPaid => 'Pullikda';

  @override
  String get platformSummaryExpired => 'Tarif muddati oʻtgan';

  @override
  String get platformSummaryAtLimit => 'Tarif chegarasida';

  @override
  String get platformSummaryRegistrations30d => '30 kunda roʻyxatdan oʻtishlar';

  @override
  String get platformSummaryRabbitsTotal => 'Jami jonivorlar';

  @override
  String get platformSummaryStorageTotal => 'Jami joy';

  @override
  String countFarms(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ferma',
      one: '$count ferma',
    );
    return '$_temp0';
  }

  @override
  String countAnnouncements(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eʼlon',
      one: '$count eʼlon',
    );
    return '$_temp0';
  }

  @override
  String get platformFarmsEmptyTitle => 'Hali ferma yoʻq';

  @override
  String get platformFarmsEmptyBody =>
      'Bu yerda xizmatning barcha xoʻjaliklari boʻladi — kimdir roʻyxatdan oʻtishi bilan oʻzi paydo boʻladi.';

  @override
  String get platformFarmsNothingFound => 'Hech narsa topilmadi';

  @override
  String get platformFarmsNothingFoundBody =>
      'Soʻrovni tekshiring yoki filtrni olib tashlang.';

  @override
  String get platformOwnerMissing => 'Egasi tayinlanmagan';

  @override
  String get platformNoPlan => 'Tarifsiz';

  @override
  String get platformNoPlanHint => 'Chegara yoʻq';

  @override
  String get platformRabbits => 'Quyonlar';

  @override
  String get platformStaff => 'Odamlar';

  @override
  String platformUsageOfLimit(int used, int limit) {
    return '$limit tadan $used tasi';
  }

  @override
  String platformUsageUnlimited(int used) {
    return '$used, chegarasiz';
  }

  @override
  String get platformAtLimit => 'Tarif chegarasiga yetdi';

  @override
  String get platformNearLimit => 'Tarif chegarasiga yaqinlashmoqda';

  @override
  String get platformFarmsSearchHint => 'Ferma, egasi, pochta, telefon';

  @override
  String platformFilterInactive(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days kundan beri kirmagan',
      one: '$days kundan beri kirmagan',
    );
    return '$_temp0';
  }

  @override
  String get platformFilterExpired => 'Tarif muddati oʻtgan';

  @override
  String platformFilterUnknown(String filter) {
    return 'Nomaʼlum kesim: $filter';
  }

  @override
  String get platformChangePlan => 'Tarifni almashtirish';

  @override
  String get platformAssignPlan => 'Tarif tayinlash';

  @override
  String platformPlanSheetTitle(String farm) {
    return '«$farm» xoʻjaligining tarifi';
  }

  @override
  String get platformPlanOff => 'Tarifsiz — chegarasiz ishlaydi';

  @override
  String get platformPlanAssigned => 'Tarif yangilandi';

  @override
  String get platformPlanInactive => 'oʻchirilgan';

  @override
  String get platformPlansEmptyTitle => 'Hali tarif yoʻq';

  @override
  String get platformPlansEmptyBody =>
      'Hozircha ular yoʻq, barcha fermalar chegarasiz ishlaydi. Birinchisini yarating — va uni tayinlash mumkin boʻladi.';

  @override
  String get platformPlanNew => 'Yangi tarif';

  @override
  String get platformPlanEdit => 'Oʻzgartirish';

  @override
  String get platformPlanDeleteTitle => 'Tarif oʻchirilsinmi?';

  @override
  String platformPlanDeleteFarms(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hozir unda $count ferma bor — ular cheklovsiz ishlaydi.',
      one: 'Hozir unda $count ferma bor — u cheklovsiz ishlaydi.',
      zero: 'Hozir bu tarifda birorta ferma yoʻq.',
    );
    return '$_temp0';
  }

  @override
  String platformPlanDeleteBody(String name) {
    return '«$name» roʻyxatdan yoʻqoladi, undagi fermalar esa chegarasiz ishlay boshlaydi. Ularning yozuvlariga tegilmaydi.';
  }

  @override
  String get platformPlanDeleted => 'Tarif oʻchirildi';

  @override
  String get platformPlanUnlimited => 'Chegarasiz';

  @override
  String get platformPlanFree => 'Bepul';

  @override
  String platformPlanLimitRabbits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tagacha quyon',
      one: '$count tagacha quyon',
    );
    return '$_temp0';
  }

  @override
  String platformPlanLimitStaff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tagacha odam',
      one: '$count tagacha odam',
    );
    return '$_temp0';
  }

  @override
  String get platformPlanFormNewTitle => 'Yangi tarif';

  @override
  String get platformPlanFormEditTitle => 'Tarif';

  @override
  String get platformPlanFormName => 'Nomi';

  @override
  String get platformPlanFormNameHint => 'Masalan, «Bazaviy»';

  @override
  String get platformPlanFormNameEmpty => 'Nomini kiriting';

  @override
  String get platformPlanFormPrice => 'Oylik narxi';

  @override
  String get platformPlanFormPriceHint => 'Boʻsh — bepul';

  @override
  String get platformPlanFormSectionLimits => 'Chegaralar';

  @override
  String get platformPlanFormMaxRabbits => 'Quyonlar koʻpi bilan';

  @override
  String get platformPlanFormMaxStaff => 'Odamlar koʻpi bilan';

  @override
  String get platformPlanFormLimitHint => 'Boʻsh — chegarasiz';

  @override
  String get platformPlanFormActive => 'Tarif ishlamoqda';

  @override
  String get platformPlanFormActiveHint =>
      'Oʻchirilgan tarif unga allaqachon tayinlangan fermalarda qoladi, lekin yangilariga berilmaydi.';

  @override
  String get platformPlanFormDefault => 'Yangi fermalarga berilsin';

  @override
  String get platformPlanFormDefaultHint =>
      'Bu tarif har bir yangi roʻyxatdan oʻtgan fermaga avtomatik beriladi. Faqat bitta tarif shunday boʻlishi mumkin — boshqasiga tayinlash uchun avval joriysidan belgini olib tashlang.';

  @override
  String get platformPlanFormCreated => 'Tarif yaratildi';

  @override
  String get platformPlanFormUpdated => 'Tarif yangilandi';

  @override
  String get platformFarmTitleFallback => 'Ferma';

  @override
  String get platformFarmSectionOwner => 'Egasi va aloqa';

  @override
  String get platformFarmSectionAccess => 'Kirish';

  @override
  String get platformFarmSectionImpersonate => 'Mijoz nomidan koʻrish';

  @override
  String get platformFarmSectionPlan => 'Tarif';

  @override
  String get platformFarmSectionExtras => 'Yengillik';

  @override
  String get platformFarmSectionUsage => 'Sarf';

  @override
  String get platformFarmSectionStaff => 'Tarkib';

  @override
  String get platformFarmSectionPayments => 'Toʻlovlar';

  @override
  String get platformFarmSectionFacts => 'Ferma haqida yana';

  @override
  String get platformFarmSectionExport => 'Maʼlumotlarni chiqarish';

  @override
  String get platformFarmSectionDanger => 'Fermani oʻchirish';

  @override
  String get platformFarmContactMissing =>
      'Pochta ham, telefon ham yoʻq — bogʻlanib boʻlmaydi';

  @override
  String get platformFarmStatusActive => 'Odatdagidek ishlaydi';

  @override
  String get platformFarmStatusActiveHint =>
      'Ferma toʻsqinliksiz oʻzining hammasini oʻqiydi va yozadi.';

  @override
  String get platformFarmStatusReadOnly => 'Faqat oʻqish';

  @override
  String get platformFarmStatusReadOnlyHint =>
      'Maʼlumotlar koʻrinadi, hech narsa yozib boʻlmaydi. Shunday toʻlanmaganda qilinadi: xoʻjalik tarixi fermerda qoladi, lekin toʻlamaguncha unda ishlab boʻlmaydi.';

  @override
  String get platformFarmStatusSuspended => 'Kirish yopilgan';

  @override
  String get platformFarmStatusSuspendedHint =>
      'Ferma hech kimni kiritmaydi — na yozib, na koʻrib boʻladi.';

  @override
  String platformFarmStatusUnknown(String status) {
    return 'Nomaʼlum holat: $status';
  }

  @override
  String get platformFarmStatusChange => 'Kirishni oʻzgartirish';

  @override
  String platformFarmStatusSheetTitle(String farm) {
    return '«$farm» xoʻjaligining kirishi';
  }

  @override
  String get platformFarmStatusConfirmTitle => 'Kirish oʻzgartirilsinmi?';

  @override
  String platformFarmStatusConfirmBody(String status) {
    return 'Xoʻjalik «$status» holatiga oʻtadi. Fermadagi odamlar buni qayta kirmasdan darhol koʻradi.';
  }

  @override
  String get platformFarmStatusApply => 'Qoʻllash';

  @override
  String get platformFarmStatusUpdated => 'Kirish yangilandi';

  @override
  String get platformFarmSectionAudit => 'U bilan nima qilingan';

  @override
  String get platformFarmAuditEmpty => 'Adminlar bu fermaga tegmagan.';

  @override
  String get platformFarmAuditLoading => 'Jurnalga qaraymiz…';

  @override
  String get platformFarmAuditAll => 'Butun jurnal';

  @override
  String platformFarmStatusExpiredWarning(String date) {
    return 'Tarif $date da tugagan. Tungi tekshiruv fermani yana «Faqat oʻqish» holatiga qaytaradi — kirish saqlanishi uchun avval tarifni uzaytiring.';
  }

  @override
  String get platformFarmPlanForever => 'Muddatsiz';

  @override
  String platformFarmPlanExpires(String date) {
    return '${date}gacha amal qiladi';
  }

  @override
  String platformFarmPlanExpired(String date) {
    return 'Muddati ${date}da tugagan';
  }

  @override
  String get platformFarmPlanExtend => 'Qoʻlda uzaytirish';

  @override
  String get platformFarmPlanExtended => 'Tarif muddati yangilandi';

  @override
  String get platformFarmExtrasNone =>
      'Yengillik yoʻq — tarif chegaralari amal qiladi';

  @override
  String get platformFarmExtrasGrant => 'Yengillik berish';

  @override
  String get platformFarmExtrasEdit => 'Oʻzgartirish';

  @override
  String get platformFarmExtrasClear => 'Yengillikni olib tashlash';

  @override
  String platformFarmExtrasRabbits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count quyon',
      one: '+$count quyon',
    );
    return '$_temp0';
  }

  @override
  String platformFarmExtrasStaff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count odam',
      one: '+$count odam',
    );
    return '$_temp0';
  }

  @override
  String platformFarmExtrasUntil(String date) {
    return '${date}gacha';
  }

  @override
  String get platformFarmExtrasEndless => 'muddatsiz';

  @override
  String platformFarmExtrasExpired(String date) {
    return 'Yengillik ${date}da tugadi — yana tarif chegaralari amal qiladi';
  }

  @override
  String get platformFarmExtrasFormTitle => 'Tarifdan tashqari yengillik';

  @override
  String get platformFarmExtrasFormBody =>
      'Faqat shu fermaning chegaralariga qoʻshimcha. Tarifning oʻzi oʻzgarmaydi — na unda, na boshqalarda.';

  @override
  String get platformFarmExtrasFormRabbits => 'Tarifdan tashqari quyonlar';

  @override
  String get platformFarmExtrasFormStaff => 'Tarifdan tashqari odamlar';

  @override
  String get platformFarmExtrasFormAmountHint => 'Boʻsh — qoʻshimchasiz';

  @override
  String get platformFarmExtrasFormUntil => 'Amal qilish muddati';

  @override
  String get platformFarmExtrasFormSetDeadline => 'Muddat belgilash';

  @override
  String get platformFarmExtrasFormEndlessHint =>
      'Muddatsiz boʻlsa, yengillik cheksiz amal qiladi.';

  @override
  String get platformFarmExtrasFormEmpty =>
      'Quyon yoki odam sonini koʻrsating — yoki yengillikni olib tashlang';

  @override
  String get platformFarmExtrasSaved => 'Yengillik yangilandi';

  @override
  String get platformFarmExtrasCleared => 'Yengillik olib tashlandi';

  @override
  String get platformFarmStaffNever => 'Hali kirmagan';

  @override
  String platformFarmStaffLastLogin(String date) {
    return '$date kirgan';
  }

  @override
  String get platformFarmStaffBlocked => 'Kirish yopilgan';

  @override
  String get platformFarmStaffEmpty =>
      'Tarkibda hech kim yoʻq — hatto egasi ham';

  @override
  String get platformFarmPaymentsEmpty => 'Hali toʻlov boʻlmagan';

  @override
  String get platformFarmPaymentNew => 'Boshlangan';

  @override
  String get platformFarmPaymentCompleted => 'Toʻlangan';

  @override
  String get platformFarmPaymentFailed => 'Oʻtmagan';

  @override
  String get platformFarmImpersonate => 'Mijoz nomidan kirish';

  @override
  String get platformFarmImpersonateHint =>
      'Ilovani ferma egasi koʻrgandek koʻrish — «ekraningizda nima bor» deb yozishmaslik uchun. Faqat oʻqish, 15 daqiqa, amal jurnalga tushadi.';

  @override
  String get platformFarmImpersonateTitle => 'Mijoz nomidan kirilsinmi?';

  @override
  String platformFarmImpersonateBody(String farmName) {
    return '${farmName}ni egasi koʻrgandek koʻrasiz — hech narsani oʻzgartira olmaysiz. Seans 15 daqiqadan keyin oʻzi tugaydi yoki «Chiqish» tugmasi bilan.';
  }

  @override
  String get platformFarmImpersonateReasonLabel => 'Sababi';

  @override
  String get platformFarmImpersonateReasonHint =>
      'Masalan: qoʻllab-quvvatlashga shikoyat №482';

  @override
  String get platformFarmImpersonateReasonRequired =>
      'Sababini koʻrsating — boʻlmasa, kirish jurnalga yozilmaydi';

  @override
  String get platformFarmImpersonateConfirm => 'Kirish';

  @override
  String impersonationBanner(String farmName) {
    return 'Siz «$farmName»ni koʻryapsiz — faqat oʻqish';
  }

  @override
  String get impersonationExit => 'Chiqish';

  @override
  String get impersonationExpired =>
      'Koʻrish seansi tugadi — siz yana oʻz akkauntingizdasiz';

  @override
  String get farmStatusBannerReadOnly =>
      'Faqat oʻqish uchun kirish — yozuv kiritishni davom ettirish uchun tarifni uzaytiring';

  @override
  String get farmStatusBannerSuspended =>
      'Kirish yopilgan — qoʻllab-quvvatlashga murojaat qiling';

  @override
  String get farmStatusBannerAction => 'Tarif';

  @override
  String get farmStatusBannerContactSupport => 'Qoʻllab-quvvatlash';

  @override
  String get platformFarmExport => 'Maʼlumotlarni eksport qilish';

  @override
  String get platformFarmExportHint =>
      'Fermaning barcha yozuvlari suratga olinadi — quyonlar, davolash, emlar, toʻlovlar. «Maʼlumotlarimni bering» soʻroviga kerak boʻladi.';

  @override
  String platformFarmExportGeneratedAt(String date) {
    return 'Surat $date olindi';
  }

  @override
  String get platformFarmDelete => 'Fermani oʻchirish';

  @override
  String get platformFarmDeleteHint =>
      'Kirish darhol yopiladi, yozuvlar va fayllar esa 30 kundan keyin butunlay yoʻqoladi. Bungacha fermani qaytarish mumkin.';

  @override
  String get platformFarmDeleteTitle => 'Ferma oʻchirilsinmi?';

  @override
  String get platformFarmDeleteBody =>
      'Fermadagi odamlar kirish huquqini darhol yoʻqotadi. Quyonlar, davolash, rasmlar va toʻlovlar 30 kundan keyin butunlay oʻchiriladi — bungacha oʻchirishni bekor qilish mumkin. Tasdiqlash uchun xoʻjalik nomini kiriting.';

  @override
  String get platformFarmDeleteConfirmLabel => 'Ferma nomi';

  @override
  String platformFarmDeleteConfirmHint(String name) {
    return '«$name» deb kiriting';
  }

  @override
  String get platformFarmDeleteMismatch => 'Nomi ferma nomiga mos kelmadi';

  @override
  String get platformFarmDeleted => 'Ferma oʻchirildi';

  @override
  String platformFarmDeletedBanner(String date) {
    return 'Ferma ${date}da oʻchirildi. Yozuvlar va fayllar oʻchirilgandan 30 kun oʻtib butunlay tozalanadi.';
  }

  @override
  String get platformFarmDeletedLocked =>
      'Ferma oʻchirilgan paytda kirish va yengilliklar oʻzgartirilmaydi — avval uni tiklang.';

  @override
  String get platformFarmRestore => 'Tiklash';

  @override
  String get platformFarmRestored => 'Ferma tiklandi';

  @override
  String get platformFarmStorage => 'Band joy';

  @override
  String get platformFarmLastActive => 'Oxirgi kirish';

  @override
  String get platformFarmNeverActive => 'Hali kirmagan';

  @override
  String get platformFarmCreatedAt => 'Ferma yaratilgan';

  @override
  String get platformSupportRequestsEmptyTitle => 'Hali murojaat yoʻq';

  @override
  String get platformSupportRequestsEmptyBody =>
      'Bu yerda fermalardan savollar paydo boʻladi — fermer Sozlamalar → Qoʻllab-quvvatlash orqali yozadi.';

  @override
  String get platformSupportRequestNew => 'yangi';

  @override
  String get platformSupportRequestResolved => 'hal qilingan';

  @override
  String get platformSupportRequestResolve => 'Hal qilingan deb belgilash';

  @override
  String countSupportRequests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count murojaat',
      one: '$count murojaat',
    );
    return '$_temp0';
  }

  @override
  String get platformAnnouncementsEmptyTitle => 'Hali eʼlon boʻlmagan';

  @override
  String get platformAnnouncementsEmptyBody =>
      'Bu yerda yuborilganlar tarixi qoladi: nima yuborilgan, kimga va nechtasiga yetgan. Yuborilganni tuzatib yoki qaytarib boʻlmaydi, shuning uchun roʻyxat bir xil narsani ikki marta takrorlamaslikka yordam beradi.';

  @override
  String get platformAnnouncementNew => 'Yangi eʼlon';

  @override
  String get platformAnnouncementSend => 'Yuborish';

  @override
  String get platformAnnouncementTargetAll => 'Barcha fermalarga';

  @override
  String get platformAnnouncementTargetAllHint =>
      'Oʻchirilganlardan tashqari, xizmatning har bir xoʻjaligiga';

  @override
  String get platformAnnouncementTargetFarm => 'Bitta fermaga';

  @override
  String get platformAnnouncementTargetFarmHint =>
      'Bitta xoʻjalikka — masalan, uning murojaatiga javoban';

  @override
  String get platformAnnouncementTargetFilter => 'Fermalar kesimi boʻyicha';

  @override
  String get platformAnnouncementTargetFilterHint =>
      'Fermalar roʻyxatidagi kesimlar bilan bir xil: tarifsiz, chegaraga yetgan, kirishi yopilgan';

  @override
  String platformAnnouncementAudienceFarm(String farm) {
    return '«$farm» fermasiga';
  }

  @override
  String platformAnnouncementAudienceFilter(String filter) {
    return '«$filter» kesimiga';
  }

  @override
  String get platformAnnouncementChannelPush => 'Push';

  @override
  String get platformAnnouncementChannelPushHint =>
      'Ferma ilovasidagi bildirishnoma';

  @override
  String get platformAnnouncementChannelEmail => 'Pochta';

  @override
  String get platformAnnouncementChannelEmailHint => 'Profildagi manzilga xat';

  @override
  String platformAnnouncementReach(int farms, int recipients) {
    String _temp0 = intl.Intl.pluralLogic(
      farms,
      locale: localeName,
      other: '$farms ferma',
      one: '$farms ferma',
    );
    String _temp1 = intl.Intl.pluralLogic(
      recipients,
      locale: localeName,
      other: '$recipients oluvchi',
      one: '$recipients oluvchi',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get platformAnnouncementNobody =>
      'Oluvchi topilmadi — eʼlon hech kimga yetmadi';

  @override
  String platformAnnouncementDelivered(int sent, int attempted) {
    return '$attempted tadan $sent tasiga yetkazildi';
  }

  @override
  String get platformAnnouncementDeliveredNobody =>
      'yuborishga hech kim yoʻq edi';

  @override
  String get platformAnnouncementDeliveryUnknown => 'natija saqlanmagan';

  @override
  String get platformAnnouncementFormTitle => 'Yangi eʼlon';

  @override
  String get platformAnnouncementFormSubject => 'Sarlavha';

  @override
  String get platformAnnouncementFormSubjectHint =>
      'U xatning mavzusi va push sarlavhasi ham boʻladi';

  @override
  String get platformAnnouncementFormBody => 'Matn';

  @override
  String get platformAnnouncementFormBodyHint =>
      'Fermalar nimani bilishi kerak';

  @override
  String get platformAnnouncementFormSectionChannels => 'Kanallar';

  @override
  String get platformAnnouncementFormNoSms =>
      'Eʼlonlar uchun SMS mavjud emas: toʻlov shlyuzi faqat oldindan tasdiqlangan shablonlarni qabul qiladi, eʼlon esa erkin matn.';

  @override
  String get platformAnnouncementFormSectionTarget => 'Kimga';

  @override
  String get platformAnnouncementFormPickFarm => 'Fermani tanlang';

  @override
  String get platformAnnouncementFormPickFilter => 'Kesimni tanlang';

  @override
  String get platformAnnouncementFarmSheetTitle => 'Qaysi fermaga yuboramiz';

  @override
  String get platformAnnouncementFilterSheetTitle =>
      'Fermalarning qaysi kesimiga yuboramiz';

  @override
  String get platformAnnouncementConfirmTitle => 'Eʼlon yuborilsinmi?';

  @override
  String get platformAnnouncementConfirmBody =>
      'Xabar oluvchilarga darhol yetadi. Yuborilganni qaytarib olib yoki tuzatib boʻlmaydi.';

  @override
  String platformAnnouncementConfirmAudience(String audience) {
    return 'Kimga: $audience';
  }

  @override
  String platformAnnouncementConfirmChannels(String channels) {
    return 'Kanallar: $channels';
  }

  @override
  String platformAnnouncementSentOk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eʼlon $count oluvchiga yetdi',
      one: 'Eʼlon $count oluvchiga yetdi',
    );
    return '$_temp0';
  }

  @override
  String platformAnnouncementSentPartly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Eʼlon $count oluvchiga yetdi, lekin baʼzi xabarlar yetib bormadi — roʻyxatdagi qatorga qarang',
      one:
          'Eʼlon $count oluvchiga yetdi, lekin baʼzi xabarlar yetib bormadi — roʻyxatdagi qatorga qarang',
    );
    return '$_temp0';
  }

  @override
  String get platformAnnouncementSentPlain => 'Eʼlon yuborildi';

  @override
  String get storageUnitBytes => 'B';

  @override
  String get storageUnitKb => 'KB';

  @override
  String get storageUnitMb => 'MB';

  @override
  String get storageUnitGb => 'GB';

  @override
  String get emptyNoRecordsTitle => 'Yozuv yoʻq';

  @override
  String get emptyNoRecordsBody => 'Birinchisini qoʻshing.';

  @override
  String get onbWelcomeTitle => 'RabbitFarm';

  @override
  String get onbWelcomeBody =>
      'Kataklar, juftlash, bolalash, ozuqa va pul — hammasi yozib boriladi va doim qoʻl ostida. Ilova oʻzi eslatadi: qachon uya qoʻyish va qachon emlash kerak.';

  @override
  String get onbWelcomeStart => 'Boshlash';

  @override
  String get onbWelcomeHaveAccount => 'Menda xoʻjalik bor';

  @override
  String get onbHerdTitle => 'Nechta quyoningiz bor?';

  @override
  String get onbHerdSubtitle => 'Taxminan, yosh bolalari bilan birga.';

  @override
  String get onbHerdUpTo20 => '20 tagacha';

  @override
  String get onbHerdUpTo20Hint => 'Oʻzim uchun boqaman';

  @override
  String get onbHerdUpTo100 => '20 dan 100 gacha';

  @override
  String get onbHerdUpTo100Hint => 'Kichik xoʻjalik';

  @override
  String get onbHerdUpTo500 => '100 dan 500 gacha';

  @override
  String get onbHerdUpTo500Hint => 'Sotuvga moʻljallangan xoʻjalik';

  @override
  String get onbHerdOver500 => '500 dan koʻp';

  @override
  String get onbHerdOver500Hint => 'Yirik xoʻjalik';

  @override
  String get onbFocusTitle => 'Avvalo nimani yozib borish kerak?';

  @override
  String get onbFocusSubtitle =>
      'Mos keladiganlarning barchasini belgilang. Qolgani ham joyida qoladi.';

  @override
  String get onbFocusBreeding => 'Juftlash va bolalash';

  @override
  String get onbFocusFeeding => 'Ozuqa va sarfi';

  @override
  String get onbFocusHealth => 'Emlash va davolash';

  @override
  String get onbFocusMoney => 'Sotuv va xarajatlar';

  @override
  String get onbFocusNext => 'Keyingisi';

  @override
  String get onbCrewTitle => 'Ilovada kim ishlaydi?';

  @override
  String get onbCrewSubtitle => 'Buni istalgan vaqtda oʻzgartirish mumkin.';

  @override
  String get onbCrewAlone => 'Faqat men';

  @override
  String get onbCrewAloneHint => 'Na taklif, na ruxsat sozlamalari kerak';

  @override
  String get onbCrewHelpers => 'Men va yordamchilarim';

  @override
  String get onbCrewHelpersHint =>
      'Har biri oʻz telefonidan yozadi va kim nima kiritgani koʻrinadi';

  @override
  String get onbDoneTitle => 'Nimadan boshlaymiz';

  @override
  String get onbDoneSubtitle => 'Bu qadamlar asosiy ekranda kutib turadi.';

  @override
  String get onbDoneCreate => 'Xoʻjalik yaratish';

  @override
  String get onbBack => 'Orqaga';

  @override
  String get onbSkip => 'Oʻtkazib yuborish';

  @override
  String get onbCountryTitle => 'Xoʻjaligingiz qayerda?';

  @override
  String get onbCountrySubtitle =>
      'Valyuta, vaqt va kirish usuli shunga bogʻliq';

  @override
  String get countryTJ => 'Tojikiston';

  @override
  String get countryUZ => 'Oʻzbekiston';

  @override
  String get countryKG => 'Qirgʻiziston';

  @override
  String get countryKZ => 'Qozogʻiston';

  @override
  String get countryRU => 'Rossiya';

  @override
  String get countryAF => 'Afgʻoniston';

  @override
  String get loginSmsUnavailable =>
      'Sizning mamlakatingizga SMS kod kelmaydi — pochta orqali kiring';

  @override
  String get firstStepCages => 'Kataklarni kiriting';

  @override
  String get firstStepRabbits => 'Urgʻochi va erkaklarni qoʻshing';

  @override
  String get firstStepBreeding => 'Birinchi juftlashni yozing';

  @override
  String get firstStepFeeding => 'Birinchi oziqlantirishni kiriting';

  @override
  String get firstStepHealth => 'Birinchi emlashni yozing';

  @override
  String get firstStepMoney => 'Birinchi sotuvni yozing';

  @override
  String get firstStepHelpers => 'Yordamchini taklif qiling';

  @override
  String get activationChecklistFarmCreated => 'Xoʻjalik yaratildi';

  @override
  String activationChecklistProgress(int done, int total) {
    return '$done dan $total';
  }

  @override
  String get deathFormTitle => 'Nobud boʻlishni qayd etish';

  @override
  String get deathFormRabbit => 'Quyon';

  @override
  String get deathFormDate => 'Sana';

  @override
  String get deathFormReason => 'Sabab';

  @override
  String get deathFormReasonHint => 'Nimadan nobud boʻlgani — bilsangiz';

  @override
  String get deathFormSubmit => 'Qayd etish';

  @override
  String get deathFormSaved => 'Nobud boʻlish qayd etildi';

  @override
  String get saleFormTitle => 'Sotuvni yozish';

  @override
  String get saleFormRabbit => 'Quyon';

  @override
  String get saleFormAmount => 'Narxi';

  @override
  String get saleFormAmountHelp =>
      'Summa daromad daftariga tushadi, quyon sotilganga oʻtadi.';

  @override
  String get saleFormAmountEmpty => 'Necha pulga sotganingizni yozing';

  @override
  String get saleFormDate => 'Sotilgan kun';

  @override
  String get saleFormBuyer => 'Xaridor';

  @override
  String get saleFormBuyerHint =>
      'Kimga sotdingiz — esda qolishini xohlasangiz';

  @override
  String get saleFormSubmit => 'Yozish';

  @override
  String get saleFormSaved => 'Sotuv yozildi';

  @override
  String get quickRecordDeath => 'Nobud boʻlish';

  @override
  String get notificationPrimerTitle => 'Bolalash uyasi haqida eslatamiz';

  @override
  String get notificationPrimerBody =>
      'Bolalashdan ikki kun oldin eslatma keladi — qafasni tayyorlashga ulgurasiz. Emlash va kunlik ishlar haqida ham eslatamiz.';

  @override
  String get notificationPrimerAllow => 'Eslatmalarni yoqish';

  @override
  String get notificationPrimerDecline => 'Hozir emas';

  @override
  String get settingsNotificationsOff => 'Bildirishnomalar oʻchiq';

  @override
  String get settingsNotificationsTurnOn => 'Yoqish';

  @override
  String get rabbitFormMore => 'Qoʻshimcha';

  @override
  String get rabbitFormSexRequired => 'Erkak yoki urgʻochi ekanini tanlang';

  @override
  String get rabbitFormCageNone => 'Qafassiz';

  @override
  String rabbitFormCageFull(String number) {
    return '$number — toʻla';
  }

  @override
  String get commonOptional => 'ixtiyoriy';

  @override
  String get unitKg => 'kg';

  @override
  String get kindlingPlanAction => 'Tugʻish rejasi';

  @override
  String get kindlingPlanPickMonth => 'Reja qaysi oy uchun?';

  @override
  String get kindlingPlanThisMonth => 'Shu oy uchun';

  @override
  String get kindlingPlanNextMonth => 'Keyingi oy uchun';

  @override
  String kindlingPlanEmpty(String month) {
    return '$month uchun tugʻish kutilmaydi';
  }

  @override
  String kindlingPlanSheetTitle(String month) {
    return 'Tugʻish rejasi — $month';
  }

  @override
  String get kindlingPlanNestHint => 'Uya tugʻishdan uch kun oldin qoʻyiladi';

  @override
  String get kindlingPlanColBirth => 'Tugʻish';

  @override
  String get kindlingPlanColFemale => 'Urgʻochi';

  @override
  String get kindlingPlanColCage => 'Katak';

  @override
  String get kindlingPlanColBred => 'Juftlashtirish';

  @override
  String get kindlingPlanColNest => 'Uya';

  @override
  String get kindlingPlanColMark => 'Belgi';

  @override
  String kindlingPlanPrintedAt(String date) {
    return 'Chop etildi: $date';
  }

  @override
  String get commonUndo => 'Qaytarish';

  @override
  String get journalKindDeletion => 'Oʻchirish';

  @override
  String get voiceDictate => 'Ovoz bilan aytish';

  @override
  String get voiceStop => 'Yozishni toʻxtatish';

  @override
  String get voiceUnavailable => 'Bu telefon nutqni tanimaydi';

  @override
  String get cageAddNewRabbit => 'Yangisini qoʻshish';

  @override
  String get cageAddNewRabbitHint => 'Ilovada hali yoʻq quyon';

  @override
  String get cageSettleExisting => 'Podadan koʻchirish';

  @override
  String get cageSettleExistingHint =>
      'Allaqachon qoʻshilgan quyonni bu yerga oʻtkazing';

  @override
  String get cageFeedThis => 'Qafasni boqish';

  @override
  String get cageTagsTitle => 'Qafas belgilari';

  @override
  String get cageTagsPrint => 'Chop etish';

  @override
  String get cageTagsPrintHint =>
      'Ramka boʻylab kesing va qafasga osing — kamera uni ilovada ochadi.';

  @override
  String get cageTagsEmptyTitle => 'Hali qafas yoʻq';

  @override
  String get cageTagsEmptyBody =>
      'Qafas qoʻshing — belgisini darhol chop etish mumkin boʻladi.';

  @override
  String get cageScanTitle => 'Belgini oʻqish';

  @override
  String get cageScanHint => 'Kamerani qafas belgisiga qarating';

  @override
  String get cageScanNoCamera =>
      'Kamera mavjud emas. Telefon sozlamalarida ruxsatni tekshiring.';

  @override
  String get slideToDelete => 'Oʻchirish uchun suring';

  @override
  String get birthsKitsDied => 'Nobud';

  @override
  String get birthsKitDeathAction => 'Nobud boʻlganini qayd etish';

  @override
  String get birthsKitsCardedHint =>
      'Bu nasl uchun alohida kartochkalar ochilgan — nobud boʻlish va ajratishni bolaning oʻz kartochkasida belgilang.';

  @override
  String get birthsKitDeathTitle => 'Nechta bolasi nobud boʻldi?';

  @override
  String birthsKitDeathHint(int alive) {
    return 'Tirik qolgani: $alive';
  }

  @override
  String get birthsKitDeathSaved => 'Qayd etildi';

  @override
  String get birthsKitsAlive => 'Tirik';

  @override
  String get loginCodeLabelEmail => 'Xatdagi kod';

  @override
  String get cyclePalpationAction => 'Tekshirdim';

  @override
  String get cyclePalpationTitle => 'Tekshiruv nima koʻrsatdi?';

  @override
  String get cyclePalpationPregnant => 'Boʻgʻoz';

  @override
  String get cyclePalpationPregnantHint =>
      'Urgʻochi boʻgʻoz deb belgilanadi, oldinda bolalash';

  @override
  String get cyclePalpationEmpty => 'Boʻsh';

  @override
  String get cyclePalpationEmptyHint =>
      'Davra yopiladi — urgʻochini qayta qochirish mumkin';

  @override
  String get cyclePalpationSavedPregnant => 'Qayd etildi: boʻgʻoz';

  @override
  String get cyclePalpationSavedEmpty => 'Qayd etildi: boʻsh';

  @override
  String get birthsWeaningAction => 'Ajratdik';

  @override
  String get birthsWeaningTitle => 'Nechta bola ajratildi?';

  @override
  String birthsWeaningHint(int alive) {
    return 'Naslda tirigi: $alive';
  }

  @override
  String birthsWeaningAll(int count) {
    return 'Hammasini: $count';
  }

  @override
  String get birthsWeaningFewer => 'Yoki kamroq';

  @override
  String get birthsWeaningSaved => 'Ajratish qayd etildi';

  @override
  String get subscriptionCheckFailed =>
      'Toʻlovni tekshirib boʻlmadi — server bilan aloqa yoʻq';

  @override
  String get subscriptionPaymentDeclined => 'Bank toʻlovni rad etdi';

  @override
  String get subscriptionPaymentDeclinedHint =>
      'Pul yechilmadi. Kartani tekshiring va qayta urinib koʻring.';

  @override
  String get subscriptionPayAgain => 'Qayta toʻlash';

  @override
  String get supportRequestNew => 'Yozish';

  @override
  String get supportRequestNewTitle => 'Yangi murojaat';

  @override
  String get supportRequestsEmptyTitle => 'Hozircha murojaat yoʻq';

  @override
  String get supportRequestsEmptyBody =>
      'Biror narsa ishlamasa yoki tushunarsiz boʻlsa, yozing. Javob shu yerga va telefoningizga bildirishnoma boʻlib keladi.';

  @override
  String get supportRequestsEmptyAction => 'Qoʻllab-quvvatlashga yozish';

  @override
  String get supportRequestStatusWaiting => 'Javob kutilmoqda';

  @override
  String get supportRequestStatusAnswered => 'Qoʻllab-quvvatlash javob berdi';

  @override
  String get supportRequestAnswerTitle => 'Qoʻllab-quvvatlash javobi';

  @override
  String get supportRequestClosedWithoutAnswer =>
      'Murojaat yozma javobsiz yopildi.';

  @override
  String get platformSupportAnswerTitle => 'Muallifga javob';

  @override
  String get platformSupportResolveTitle => 'Murojaatni yopish';

  @override
  String get platformSupportResolveBody =>
      'Javob yozing — u muallifga bildirishnoma va xat boʻlib boradi. Agar yozishmasdan hal qilingan boʻlsa, maydonni boʻsh qoldiring.';

  @override
  String get platformSupportResolveAnswerLabel => 'Muallifga javob';

  @override
  String get platformSupportResolveAnswerHint =>
      'Masalan: ilovani yangilang — yangi versiyada bu tuzatilgan';

  @override
  String get platformSupportResolveSendAnswer => 'Javobni yuborish';

  @override
  String get platformSupportResolveWithoutAnswer => 'Javobsiz yopish';

  @override
  String get platformSupportContactTitle => 'Qoʻllab-quvvatlash aloqasi';

  @override
  String get platformSupportContactBody =>
      'Fermalar bu telefon va pochtani oʻz murojaatlar ekranida koʻradi. Bevosita aloqa boʻlmasa, boʻsh qoldiring.';

  @override
  String get platformSupportContactPhone => 'Telefon';

  @override
  String get platformSupportContactPhoneHint => '+992 00 000 00 00';

  @override
  String get platformSupportContactEmail => 'Pochta';

  @override
  String get platformSupportContactEmailHint => 'support@example.com';

  @override
  String get platformSupportContactEmailInvalid =>
      'Manzilni tekshiring — unda @ belgisi yoʻq';

  @override
  String get platformSupportContactSaved =>
      'Qoʻllab-quvvatlash aloqasi saqlandi';

  @override
  String get notificationsTitle => 'Bildirishnomalar';

  @override
  String get notificationsEmptyTitle => 'Hozircha jim';

  @override
  String get notificationsEmptyBody =>
      'Bu yerda ilova xabar bergan narsalar paydo boʻladi: muddati oʻtgan emlashlar, tugayotgan yem, yaqinlashayotgan bolalash.';

  @override
  String get platformFilterDeleted => 'Oʻchirilganlar';

  @override
  String platformFarmDeletedShort(String date) {
    return '$date da oʻchirilgan';
  }

  @override
  String get platformFarmsDeletedEmptyTitle => 'Oʻchirilgan ferma yoʻq';

  @override
  String get platformFarmsDeletedEmptyBody =>
      'Butunlay tozalashni kutayotgan narsa yoʻq. Oʻchirilgan ferma bu yerda 30 kun turadi — fikrdan qaytish uchun shu muddat yetarli.';

  @override
  String get platformPlanDeleteDefaultWarning =>
      'Bu — sukut boʻyicha tarif. Uni oʻchirgandan keyin boshqa tarif sukut boʻyicha belgilanmaguncha yangi fermalar umuman tarifsiz paydo boʻladi.';

  @override
  String get platformPlanDeleteIrreversible =>
      'Buni qaytarib boʻlmaydi: tarifni qaytadan yaratib, fermalarga qoʻlda biriktirishga toʻgʻri keladi.';

  @override
  String get platformTabAudit => 'Jurnal';

  @override
  String get platformAuditEmptyTitle => 'Jurnal boʻsh';

  @override
  String get platformAuditEmptyBody =>
      'Har bir admin amali shu yerga tushadi: tarif almashtirish, ferma kirishi, mijoz nomidan kirish, oʻchirish.';

  @override
  String countAuditRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta yozuv',
      one: '$count ta yozuv',
    );
    return '$_temp0';
  }

  @override
  String platformAuditAdmin(String id) {
    return 'Admin $id';
  }

  @override
  String platformAuditFarm(String id) {
    return 'Xoʻjalik $id';
  }

  @override
  String get platformAuditWholeService => 'Butun xizmat';

  @override
  String platformAuditIp(String ip) {
    return 'IP $ip';
  }

  @override
  String platformAuditChange(String field, String before, String after) {
    return '$field: $before → $after';
  }

  @override
  String platformAuditDetail(String field, String value) {
    return '$field: $value';
  }

  @override
  String get platformAuditValueNone => 'belgilanmagan';

  @override
  String get platformAuditActionPlanCreate => 'Tarif yaratildi';

  @override
  String get platformAuditActionPlanUpdate => 'Tarif oʻzgartirildi';

  @override
  String get platformAuditActionPlanDelete => 'Tarif oʻchirildi';

  @override
  String get platformAuditActionPlanAssign => 'Ferma tarifi almashtirildi';

  @override
  String get platformAuditActionFarmStatus => 'Ferma kirishi oʻzgartirildi';

  @override
  String get platformAuditActionFarmExtras => 'Tarifdan ortiq yengillik';

  @override
  String get platformAuditActionFarmExtendPlan => 'Tarif qoʻlda uzaytirildi';

  @override
  String get platformAuditActionFarmExport =>
      'Ferma maʼlumotlari yuklab olindi';

  @override
  String get platformAuditActionFarmImpersonate => 'Mijoz nomidan kirish';

  @override
  String get platformAuditActionFarmDelete => 'Ferma oʻchirildi';

  @override
  String get platformAuditActionFarmRestore => 'Ferma tiklandi';

  @override
  String get platformAuditActionAnnouncementSend => 'Eʼlon yuborildi';

  @override
  String get platformAuditActionSupportResolve => 'Murojaat yopildi';

  @override
  String get platformAuditActionSupportContact =>
      'Yordam aloqasi oʻzgartirildi';

  @override
  String platformAuditActionUnknown(String action) {
    return '«$action» amali';
  }

  @override
  String get platformAuditFieldName => 'Nomi';

  @override
  String get platformAuditFieldLimits => 'Chegaralar';

  @override
  String get platformAuditFieldPrice => 'Narxi';

  @override
  String get platformAuditFieldRabbitsLimit => 'Tarif boʻyicha quyonlar';

  @override
  String get platformAuditFieldStaffLimit => 'Tarif boʻyicha odamlar';

  @override
  String get platformAuditFieldPlan => 'Tarif';

  @override
  String get platformAuditFieldStatus => 'Kirish';

  @override
  String get platformAuditFieldPlanExpiry => 'Tarif muddati';

  @override
  String get platformAuditFieldExtras => 'Yengillik';

  @override
  String get platformAuditFieldReason => 'Nima uchun';

  @override
  String get platformAuditPlanEnabled => 'Tarif yana fermalarga beriladi';

  @override
  String get platformAuditPlanDisabled => 'Tarif endi fermalarga berilmaydi';

  @override
  String get platformAuditPlanBecameDefault => 'Sukut boʻyicha tarifga aylandi';

  @override
  String get platformAuditPlanNoLongerDefault =>
      'Endi sukut boʻyicha tarif emas';

  @override
  String platformAuditPlanRef(int id) {
    return 'Tarif №$id';
  }

  @override
  String platformAuditSupportAnswered(int id) {
    return '№$id murojaat — muallifga javob bilan';
  }

  @override
  String platformAuditSupportClosed(int id) {
    return '№$id murojaat — javobsiz';
  }

  @override
  String get feedsPaidLabel => 'Qancha toʻladingiz';

  @override
  String get feedsPaidHint =>
      'Agar bu xarid boʻlsa, summa xarajatlarga tushadi. Faqat qoldiqni qayta sanagan boʻlsangiz — boʻsh qoldiring.';

  @override
  String staffInvitedEmailFailedBody(String email) {
    return '$email manziliga xat yuborib boʻlmadi — taklifni oʻzingiz yuboring.';
  }

  @override
  String get staffInviteLinkLabel => 'Taklif havolasi';

  @override
  String get staffInviteCopy => 'Taklifni nusxalash';

  @override
  String get staffInviteCopied =>
      'Taklif nusxalandi — uni ishchiga yuboriladigan xabarga qoʻying';

  @override
  String staffInviteMessage(String link) {
    return 'Sizni RabbitFarmdagi xoʻjaligimda ishlashga taklif qilaman. Havolani oching, ilovani oʻrnating va oʻz raqamingiz bilan kiring: $link';
  }

  @override
  String get staffExpiredInvites => 'Muddati oʻtgan';

  @override
  String staffInviteCardLive(String role, String date) {
    return '$role · $date gacha';
  }

  @override
  String staffInviteCardExpired(String role, String date) {
    return '$role · muddati $date da tugagan';
  }

  @override
  String get staffInviteAgain => 'Qaytadan taklif qilish';

  @override
  String get loginNoCodePhone =>
      'Kod kelmadimi? Xoʻjalik egasidan qaysi raqamga taklif qilganini soʻrang.';

  @override
  String get loginNoCodeEmail =>
      'Kod kelmadimi? Xoʻjalik egasidan qaysi pochtaga taklif qilganini soʻrang.';

  @override
  String get platformPlanDefaultBadge => 'yangi fermalarga';

  @override
  String get staffAccessClosedBadge => 'kirish yopiq';

  @override
  String get roleManagerDescription => 'Podani, ozuqani va pulni yuritadi';

  @override
  String get roleWorkerDescription =>
      'Maʼlumotlarni koʻradi va ishni belgilaydi';
}
