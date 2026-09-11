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
  String get commonAdd => 'Qo\'shish';

  @override
  String get commonDelete => 'O\'chirish';

  @override
  String get commonClose => 'Yopish';

  @override
  String get commonCopy => 'Nusxalash';

  @override
  String get commonCopied => 'Nusxalandi';

  @override
  String get commonLoadFailed => 'Yuklab bo\'lmadi';

  @override
  String get commonUnknownError => 'Noma\'lum xatolik';

  @override
  String get commonSomethingWrong => 'Nimadir noto\'g\'ri ketdi';

  @override
  String get commonSomethingWrongHint =>
      'Bu ekranni ko\'rsatib bo\'lmadi. Orqaga qayting yoki ilovani qayta ishga tushiring.';

  @override
  String get errorOffline => 'Aloqa yo\'q — internetni tekshiring';

  @override
  String get errorTimeout => 'Server javob bermadi, yana urinib ko\'ring';

  @override
  String get errorUnauthorized => 'Qaytadan kirish kerak';

  @override
  String get errorForbidden => 'Sizning rolingizda bunga ruxsat yo\'q';

  @override
  String get errorNotFound => 'Yozuv topilmadi — ehtimol, o\'chirilgan';

  @override
  String get errorInvalid => 'Server ma\'lumotlarni qabul qilmadi';

  @override
  String get errorServer => 'Serverda nosozlik, keyinroq urinib ko\'ring';

  @override
  String get offlineBanner =>
      'Aloqa yo\'q — ozuqlantirish, vazifalar va eslatmalar saqlanadi va keyinroq yuboriladi';

  @override
  String get offlineActionQueued =>
      'Qurilmada saqlandi — aloqa paydo bo\'lganda yuboriladi';

  @override
  String get forceUpdateTitle => 'Yangi versiya mavjud';

  @override
  String get forceUpdateHint =>
      'Ilovaning bu versiyasi endi qo\'llab-quvvatlanmaydi. Davom etish uchun ilovani yangilang.';

  @override
  String get forceUpdateButton => 'Yangilash';

  @override
  String get commonStaleData =>
      'Yangilab bo\'lmadi, avvalgi ma\'lumotlar ko\'rsatilmoqda';

  @override
  String get commonRetryShort => 'Yana bir bor';

  @override
  String get commonNotSpecified => 'Ko\'rsatilmagan';

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
      'Oziqlantirish, davolash, emlash, yopilgan vazifalar, eslatma va rasmlar bu yerga o\'zi tushadi. Birinchisini yozing — va u shu yerda paydo bo\'ladi.';

  @override
  String get journalNoneInViewTitle => 'Bu tanlovda bo\'sh';

  @override
  String get journalNoneInViewBody =>
      'Yozuv turini yoki muddatini almashtiring.';

  @override
  String get pinSetupTitle => 'Tez kirish kodi';

  @override
  String get pinChangeTitle => 'Kodni o\'zgartirish';

  @override
  String get pinSetupPrompt => '4 raqamli kod o\'ylab toping';

  @override
  String get pinRepeatPrompt => 'Kodni takrorlang';

  @override
  String get pinSetupExplanation =>
      'Bu kod bilan ilovani shu telefonda ochasiz — endi SMS kutib o\'tirmaysiz.';

  @override
  String get pinSkip => 'Hozir emas';

  @override
  String get pinSaved => 'Kod saqlandi';

  @override
  String get pinMismatch => 'Kodlar mos kelmadi — yana urinib ko\'ring';

  @override
  String get pinLockPrompt => 'Kodni kiriting';

  @override
  String get pinWrong => 'Kod noto\'g\'ri';

  @override
  String get pinDelete => 'Raqamni o\'chirish';

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
      'Kod faqat shu telefonda saqlanadi, uni tiklashning iloji yo\'q. Akkauntdan chiqamiz — va siz SMS yoki xatdagi kod bilan qaytadan kirasiz.';

  @override
  String get pinForgotConfirm => 'Chiqish va qaytadan kirish';

  @override
  String get settingsPinTitle => 'Tez kirish kodi';

  @override
  String get settingsPinOn => 'Ilova kod bilan ochiladi';

  @override
  String get settingsPinOff => 'Ilova kodsiz ochiladi';

  @override
  String get settingsPinChange => 'Kodni o\'zgartirish';

  @override
  String get loginByPhone => 'Telefon';

  @override
  String get loginByEmail => 'Pochta';

  @override
  String get loginEmailIntro => 'Pochtaga kod yuboramiz — parol kerak emas.';

  @override
  String get loginCodeChangeEmail => 'Pochtani o\'zgartirish';

  @override
  String get registerContactHelper => 'Unga kirish uchun kod keladi';

  @override
  String get loginPhoneLabel => 'Telefon';

  @override
  String get loginPhoneHint => '+992 XX XXX XX XX';

  @override
  String get loginPhoneEmpty => 'Telefon raqamini kiriting';

  @override
  String get loginPhoneInvalid => 'Raqam +992 90 123 45 67 ko\'rinishida';

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
  String get loginCodeChangePhone => 'Raqamni o\'zgartirish';

  @override
  String get loginEmailLabel => 'Pochta';

  @override
  String get loginEmailHint => 'name@example.com';

  @override
  String get loginEmailEmpty => 'Pochtani kiriting';

  @override
  String get loginEmailInvalid => 'Manzilda xatolik bo\'lsa kerak';

  @override
  String get loginSubmit => 'Kirish';

  @override
  String get loginCreateFarm => 'O\'z fermamni ochish';

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
  String get todayAllClear => 'Hammasi nazoratda — shoshilinch narsa yo\'q';

  @override
  String get todayFarmNow => 'Ferma hozir';

  @override
  String get todayStatLivestock => 'Jonivorlar soni';

  @override
  String get todayStatTasks => 'Ishdagi vazifalar';

  @override
  String get todayStatFreeCages => 'Bo\'sh kataklar';

  @override
  String get todayAlertOverdueVaccination => 'Emlash muddati o\'tib ketgan';

  @override
  String get todayAlertLowFeed => 'Em tugab qolmoqda';

  @override
  String get todayAlertUpcomingVaccination => 'Tez orada emlash';

  @override
  String get activationChecklistTitle => 'Ishni boshlash';

  @override
  String get activationChecklistDismiss => 'Berkitish';

  @override
  String get activationChecklistAddCage => 'Katak qo\'shing';

  @override
  String get activationChecklistAddRabbit => 'Quyon qo\'shing';

  @override
  String get activationChecklistFirstFeeding =>
      'Birinchi oziqlantirishni kiriting';

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
  String get navFarm => 'Xo\'jalik';

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
  String get quickGroupFarm => 'Xo\'jalik';

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
  String get farmTitle => 'Xo\'jalik';

  @override
  String get navQuickTitle => 'Nimani yozamiz';

  @override
  String get quickRecordFeeding => 'Oziqlantirishni yozish';

  @override
  String get quickRecordVaccination => 'Emlashni yozish';

  @override
  String get quickCreateTask => 'Vazifa yaratish';

  @override
  String get quickRecordNote => 'Eslatma qoldirish';

  @override
  String get quickAddRabbit => 'Quyon qo\'shish';

  @override
  String get quickRecordBirth => 'Tug\'ishni yozish';

  @override
  String get quickAddCage => 'Katak qo\'shish';

  @override
  String get formDiscardTitle => 'Saqlamasdan chiqilsinmi?';

  @override
  String get formDiscardBody => 'Kiritilgan ma\'lumotlar yo\'qoladi.';

  @override
  String get formDiscardStay => 'Kiritishni davom ettirish';

  @override
  String get formDiscardLeave => 'Chiqish';

  @override
  String get cycleTitle => 'Urchitish';

  @override
  String get cycleFindPair => 'Juft tanlash';

  @override
  String get cycleRecordBirth => 'Tug\'ishni yozish';

  @override
  String get cycleStageCheck => 'Bo\'g\'ozlikni tekshirish';

  @override
  String get cycleStageBirth => 'Tug\'ish kutilmoqda';

  @override
  String get cycleStageWeaning => 'Bolalarni ajratish';

  @override
  String get cycleStageNotPregnant => 'Urg\'ochi bo\'sh';

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
      other: 'muddati $count kunga o\'tib ketgan',
      one: 'muddati $count kunga o\'tib ketgan',
    );
    return '$_temp0';
  }

  @override
  String get breedingEmptyTitle => 'Hali juftlashtirish yo\'q';

  @override
  String get breedingEmptyBody =>
      'Juftlashtirishni yozing — ilova tug\'ish kutilayotgan sanani aytadi.';

  @override
  String get breedingEmptyAction => 'Juftlashtirishni yozish';

  @override
  String get breedingMale => 'Erkak';

  @override
  String get breedingFemale => 'Urg\'ochi';

  @override
  String get commonNameMissing => 'Ism ko\'rsatilmagan';

  @override
  String get commonOpenCard => 'Kartochkani ochish';

  @override
  String get commonEdit => 'O\'zgartirish';

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
  String get cageEdit => 'Katakni o\'zgartirish';

  @override
  String get cageResidents => 'Yashovchilar';

  @override
  String get cageEmptyManaged =>
      'Katak bo\'sh. Pastdagi tugma orqali quyon joylashtiring.';

  @override
  String get cageEmptyReadOnly => 'Katak bo\'sh.';

  @override
  String get cageFull => 'Katak to\'lgan';

  @override
  String get cageAddRabbit => 'Quyon joylashtirish';

  @override
  String get cageNoLocation => 'Joyi ko\'rsatilmagan';

  @override
  String get cageRemoveTitle => 'Katakdan chiqarilsinmi?';

  @override
  String cageRemoveBody(String name) {
    return '$name katak biriktirilmagan quyonlar ro\'yxatiga o\'tadi.';
  }

  @override
  String get cageRemoveConfirm => 'Chiqarish';

  @override
  String cageRemoved(String name) {
    return '$name katakdan chiqarildi';
  }

  @override
  String cageMoved(String name, String number) {
    return '$name $number-katakka ko\'chirildi';
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
  String get cageResidentMove => 'Ko\'chirish';

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
  String get cagePickNoCage => 'Katak yo\'q';

  @override
  String get cagePickCageTitle => 'Qaysi katakka ko\'chiramiz';

  @override
  String get cagePickNoFreeCages => 'Bo\'sh katak yo\'q';

  @override
  String get cagePickNoFreeCagesBody =>
      'Joy bo\'shating yoki yangi katak qo\'shing.';

  @override
  String get cageFormType => 'Katak turi';

  @override
  String get cycleStageWeaned => 'Bolalar ajratildi';

  @override
  String get cageTypeSingle => 'Yakka';

  @override
  String get cageTypeGroup => 'Guruh';

  @override
  String get cageTypeMaternity => 'Tug\'ish uchun';

  @override
  String get cageConditionGood => 'Yaxshi holatda';

  @override
  String get cageConditionNeedsRepair => 'Ta\'mir talab qiladi';

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
  String get todayTasksNone => 'Bugunga vazifa yo\'q';

  @override
  String get commonFilters => 'Filtrlar';

  @override
  String get commonApply => 'Qo\'llash';

  @override
  String get commonReset => 'Tozalash';

  @override
  String get tasksFilterType => 'Turi';

  @override
  String get tasksFilterStatus => 'Holati';

  @override
  String get tasksFilterPriority => 'Muhimligi';

  @override
  String get tasksFilterOverdueOnly => 'Faqat muddati o\'tganlar';

  @override
  String get tasksFilterTodayOnly => 'Faqat bugungilar';

  @override
  String get tasksEmptyTitle => 'Hali vazifa yo\'q';

  @override
  String get tasksEmptyBody =>
      'Vazifa yarating — muddati kelganda ilova eslatadi.';

  @override
  String get tasksEmptyAction => 'Vazifa yaratish';

  @override
  String get tasksNothingMatchesTitle => 'Filtrlarga hech narsa mos kelmadi';

  @override
  String get tasksNothingMatchesBody =>
      'Ko\'proq ko\'rish uchun shartlarning bir qismini olib tashlang.';

  @override
  String get tasksComplete => 'Bajarilgan deb belgilash';

  @override
  String get tasksCompleted => 'Vazifa bajarildi';

  @override
  String get tasksCompleteFailed => 'Vazifani belgilab bo\'lmadi';

  @override
  String get tasksOverdueChip => 'Muddati o\'tganlar';

  @override
  String get tasksTodayChip => 'Bugunga';

  @override
  String get taskTypeFeeding => 'Oziqlantirish';

  @override
  String get taskTypeCleaning => 'Tozalash';

  @override
  String get taskTypeVaccination => 'Emlash';

  @override
  String get taskTypeCheckup => 'Ko\'rik';

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
  String get taskPriorityMedium => 'O\'rta';

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
      other: 'Muddati $count kunga o\'tib ketgan',
      one: 'Muddati $count kunga o\'tib ketgan',
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
      'Vazifa bajarilgan deb belgilanganda, keyingisi o\'zi yaratiladi.';

  @override
  String get taskFormNotesLabel => 'Izohlar';

  @override
  String get taskFormCreate => 'Yaratish';

  @override
  String get taskFormCreated => 'Vazifa yaratildi';

  @override
  String get taskFormUpdated => 'Vazifa yangilandi';

  @override
  String get taskFormDeleteTitle => 'Vazifa o\'chirilsinmi?';

  @override
  String get taskFormDeleteBody => 'Uni qayta tiklab bo\'lmaydi.';

  @override
  String get taskFormDeleted => 'Vazifa o\'chirildi';

  @override
  String get taskFormDeleteFailed => 'Vazifani o\'chirib bo\'lmadi';

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
  String get noteFormCreate => 'Qo\'shish';

  @override
  String get noteFormCreated => 'Eslatma qo\'shildi';

  @override
  String get noteFormUpdated => 'Eslatma yangilandi';

  @override
  String get noteFormDeleteTitle => 'Eslatma o\'chirilsinmi?';

  @override
  String get noteFormDeleteBody => 'Uni qayta tiklab bo\'lmaydi.';

  @override
  String get noteFormDeleted => 'Eslatma o\'chirildi';

  @override
  String get noteFormDeleteFailed => 'Eslatmani o\'chirib bo\'lmadi';

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
  String get vaccinationsViewOverdue => 'Muddati o\'tganlar';

  @override
  String get vaccinationsViewLast30 => 'So\'nggi 30 kun';

  @override
  String get vaccinationsEmptyTitle => 'Emlash yozuvlari yo\'q';

  @override
  String get vaccinationsEmptyBody =>
      'Emlashni belgilang — ilova keyingisi qachon kerakligini eslatadi.';

  @override
  String get vaccinationsEmptyAction => 'Emlashni yozish';

  @override
  String get vaccinationsNoneInView => 'Bu tanlovda bo\'sh';

  @override
  String get vaccinationsNoneInViewBody =>
      'Boshqa bo\'limni tanlang yoki filtrlarni olib tashlang.';

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
  String get vaccinationsOverdueBadge => 'Muddati o\'tgan';

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
  String get vaccinationsDeleteTitle => 'Yozuv o\'chirilsinmi?';

  @override
  String get vaccinationsDeleteBody =>
      'Emlash haqidagi yozuv qaytarib bo\'lmaydigan tarzda o\'chiriladi.';

  @override
  String get vaccinationsDeleted => 'Yozuv o\'chirildi';

  @override
  String get vaccinationsDeleteFailed => 'Yozuvni o\'chirib bo\'lmadi';

  @override
  String get vaccinationsStatTotal => 'Jami emlashlar';

  @override
  String get vaccinationsStatThisYear => 'Shu yilda';

  @override
  String get vaccinationsStatLast30 => 'So\'nggi 30 kunda';

  @override
  String get vaccinationsStatUpcoming => 'Tez orada';

  @override
  String get vaccinationsStatNext30 => 'Keyingi 30 kun ichida';

  @override
  String get vaccinationsStatOverdue => 'Muddati o\'tgan';

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
  String get rabbitPickerNoCage => 'Katak yo\'q';

  @override
  String get vaccFormNewTitle => 'Yangi emlash';

  @override
  String get vaccFormEditTitle => 'Emlash';

  @override
  String get vaccFormSectionMain => 'Asosiy';

  @override
  String get vaccFormSectionDates => 'Sanalar';

  @override
  String get vaccFormSectionExtra => 'Qo\'shimcha';

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
  String get vaccFormFailed => 'Saqlab bo\'lmadi';

  @override
  String get medTitle => 'Davolash';

  @override
  String get medEmptyTitle => 'Davolash yozuvlari yo\'q';

  @override
  String get medEmptyBody =>
      'Kasallik kartasini oching — u belgilar, davolash va xarajatlarni bir joyga yig\'adi.';

  @override
  String get medEmptyAction => 'Karta ochish';

  @override
  String get medNoneInView => 'Bu tanlovda bo\'sh';

  @override
  String get medNoneInViewBody =>
      'Boshqa bo\'limni tanlang yoki filtrlarni olib tashlang.';

  @override
  String get medViewAll => 'Barchasi';

  @override
  String get medOutcomeOngoing => 'Davolanmoqda';

  @override
  String get medOutcomeRecovered => 'Tuzaldi';

  @override
  String get medOutcomeDied => 'Nobud bo\'ldi';

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
  String get medNoDiagnosis => 'Tashxis qo\'yilmagan';

  @override
  String get medDeleteTitle => 'Karta o\'chirilsinmi?';

  @override
  String get medDeleteBody =>
      'Davolash yozuvi qaytarib bo\'lmaydigan tarzda o\'chiriladi.';

  @override
  String get medDeleted => 'Yozuv o\'chirildi';

  @override
  String get medDeleteFailed => 'Yozuvni o\'chirib bo\'lmadi';

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
  String get medFormSectionCase => 'Nima bo\'ldi';

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
  String get medFormFailed => 'Saqlab bo\'lmadi';

  @override
  String get medFormCostHelp =>
      'Summa ferma xarajatlariga alohida amaliyot sifatida tushadi.';

  @override
  String get medFormDosage => 'Dozasi';

  @override
  String get medFormEndedDate => 'Tugash sanasi';

  @override
  String get medFormNotSet => 'Ko\'rsatilmagan';

  @override
  String medFormCostLabel(String currency) {
    return 'Xarajat, $currency';
  }

  @override
  String get commonNumberInvalid => 'Raqam kiriting';

  @override
  String get feedsTitle => 'Em ombori';

  @override
  String get feedsAdd => 'Em qo\'shish';

  @override
  String get feedsEmptyTitle => 'Ombor bo\'sh';

  @override
  String get feedsEmptyBody =>
      'Em kiriting — tugab qolganda ilova ogohlantiradi.';

  @override
  String get feedsNoneInView => 'Filtrlarga hech narsa mos kelmadi';

  @override
  String get feedsNoneInViewBody =>
      'Butun omborni ko\'rish uchun shartlarni olib tashlang.';

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
  String get feedingBulkAddRabbit => 'Quyon qo\'shish';

  @override
  String get feedingBulkRabbitsRequired => 'Kamida bitta quyonni tanlang';

  @override
  String get feedingBulkRemove => 'Ro\'yxatdan chiqarish';

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
  String get feedingBulkNoCagesTitle => 'Hali katak yo\'q';

  @override
  String get feedingBulkNoCagesBody =>
      'Kataklarni kiriting — shunda oziqlantirishni bir zumda qatorga yoki butun fermaga yozish mumkin bo\'ladi.';

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
  String get feedsRefill => 'To\'ldirish';

  @override
  String get feedsWriteOff => 'Hisobdan chiqarish';

  @override
  String get feedsRefillTitle => 'Omborni to\'ldirish';

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
    return 'Ombor ${amount}ga to\'ldirildi';
  }

  @override
  String feedsWrittenOff(String amount) {
    return '$amount hisobdan chiqarildi';
  }

  @override
  String get feedsAdjustFailed => 'Qoldiqni o\'zgartirib bo\'lmadi';

  @override
  String get feedsDeleteTitle => 'Em o\'chirilsinmi?';

  @override
  String feedsDeleteBody(String name) {
    return '«$name» qoldiqlar tarixi bilan birga ombordan yo\'qoladi.';
  }

  @override
  String get feedsDeleted => 'Em o\'chirildi';

  @override
  String get feedsDeleteFailed => 'Emni o\'chirib bo\'lmadi';

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
      'Bu qoldiqdan pastga tushsa, em bosh ekrandagi «Diqqat talab qiladi» bo\'limiga tushadi.';

  @override
  String get feedFormCost => 'Birlik narxi';

  @override
  String get feedFormRequired => 'Maydonni to\'ldiring';

  @override
  String get feedFormNegative => 'Raqam manfiy bo\'lishi mumkin emas';

  @override
  String get feedFormCreated => 'Em omborga qo\'shildi';

  @override
  String get feedFormUpdated => 'Em yangilandi';

  @override
  String get feedFormFailed => 'Emni saqlab bo\'lmadi';

  @override
  String get feedingTitle => 'Oziqlantirishlar';

  @override
  String get feedingAdd => 'Oziqlantirishni yozish';

  @override
  String get feedingEmptyTitle => 'Oziqlantirish yozuvlari yo\'q';

  @override
  String get feedingEmptyBody =>
      'Oziqlantirishlarni belgilang — em sarfi ombordan o\'zi yechiladi.';

  @override
  String get feedingNoneInView => 'Bu davrda yozuv yo\'q';

  @override
  String get feedingNoneInViewBody =>
      'Boshqa davrni tanlang yoki filtrni tozalang.';

  @override
  String get feedingUnknownFeed => 'Em ko\'rsatilmagan';

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
  String get feedingEdit => 'O\'zgartirish';

  @override
  String get feedingDeleteTitle => 'Yozuv o\'chirilsinmi?';

  @override
  String get feedingDeleteBody =>
      'Oziqlantirish yozuvi o\'chiriladi. Yechilgan em omborga qaytmaydi.';

  @override
  String get feedingDeleted => 'Yozuv o\'chirildi';

  @override
  String get feedingDeleteFailed => 'Yozuvni o\'chirib bo\'lmadi';

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
  String get feedingFormFailed => 'Yozuvni saqlab bo\'lmadi';

  @override
  String get feedingFormStockNote => 'Ko\'rsatilgan miqdor ombordan yechiladi.';

  @override
  String get financeTitle => 'Moliya';

  @override
  String get financeAdd => 'Amaliyot qo\'shish';

  @override
  String get financeEmptyTitle => 'Hali amaliyot yo\'q';

  @override
  String get financeEmptyBody =>
      'Daromad va xarajatlarni yozib boring — ilova ferma foydasini o\'zi hisoblaydi.';

  @override
  String get financeNoneInView => 'Filtrlarga hech narsa mos kelmadi';

  @override
  String get financeNoneInViewBody =>
      'Butun ro\'yxatni ko\'rish uchun shartlarni olib tashlang.';

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
  String get financeTypeIncome => 'Daromad';

  @override
  String get financeTypeExpense => 'Xarajat';

  @override
  String get financeDeleteTitle => 'Amaliyot o\'chirilsinmi?';

  @override
  String get financeDeleteBody =>
      'Amaliyot ro\'yxatdan qaytarib bo\'lmaydigan tarzda yo\'qoladi.';

  @override
  String get financeDeleted => 'Amaliyot o\'chirildi';

  @override
  String get financeDeleteFailed => 'Amaliyotni o\'chirib bo\'lmadi';

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
  String get txFormAmountPositive => 'Summa noldan katta bo\'lishi kerak';

  @override
  String get txFormDate => 'Qachon';

  @override
  String get txFormRabbit => 'Quyon bilan bog\'lash';

  @override
  String get txFormRabbitHelp =>
      'Ixtiyoriy. Muayyan hayvon bo\'yicha daromad va xarajatni ko\'rish uchun kerak.';

  @override
  String get txFormDescription => 'Tavsif';

  @override
  String get txFormCreated => 'Amaliyot yozildi';

  @override
  String get txFormUpdated => 'Amaliyot yangilandi';

  @override
  String get txFormFailed => 'Amaliyotni saqlab bo\'lmadi';

  @override
  String get cagesTitle => 'Kataklar';

  @override
  String get cagesAdd => 'Katak qo\'shish';

  @override
  String get cagesSearchHint => 'Raqami yoki joyi';

  @override
  String get cagesOnlyAvailable => 'Faqat bo\'shlar';

  @override
  String get cagesEmptyTitle => 'Hali katak yo\'q';

  @override
  String get cagesEmptyBody =>
      'Kataklarni kiriting — ular orqali quyonlarni qayerga joylash va qayerda joy borligi ko\'rinadi.';

  @override
  String get cagesNothingFound => 'Hech narsa topilmadi';

  @override
  String get cagesNothingFoundBody =>
      'So\'rovni tekshiring yoki filtrlarni olib tashlang.';

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
  String get cagesCleanFailed => 'Tozalashni belgilab bo\'lmadi';

  @override
  String get cagesDeleteTitle => 'Katak o\'chirilsinmi?';

  @override
  String cagesDeleteBody(String number) {
    return '$number-katak ro\'yxatdan yo\'qoladi. Undagi quyonlar kataksiz qoladi.';
  }

  @override
  String get cagesDeleted => 'Katak o\'chirildi';

  @override
  String get cagesDeleteFailed => 'Katakni o\'chirib bo\'lmadi';

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
  String get cageFormCapacity => 'Nechta quyon sig\'adi';

  @override
  String get cageFormCapacityInvalid => 'Noldan katta raqam kiriting';

  @override
  String get cageFormCapacityGroup =>
      'Guruh katagida kamida ikkita joy bo\'lishi kerak';

  @override
  String get cageFormSize => 'O\'lchami';

  @override
  String get cageFormSizeHint => 'Masalan, 100×60×45 sm';

  @override
  String get cageFormLocation => 'Joyi';

  @override
  String get cageFormLocationHint => 'Masalan, ombor, chap qator';

  @override
  String get cageFormNotes => 'Eslatmalar';

  @override
  String get cageFormCreated => 'Katak qo\'shildi';

  @override
  String get cageFormUpdated => 'Katak yangilandi';

  @override
  String get cageFormFailed => 'Katakni saqlab bo\'lmadi';

  @override
  String get rabbitsTitle => 'Quyonlar';

  @override
  String get rabbitsSearchHint => 'Laqabi yoki birka raqami';

  @override
  String get herdCagesNoPlace => 'Joyi ko\'rsatilmagan';

  @override
  String get rabbitsEmptyTitle => 'Hali quyon yo\'q';

  @override
  String get rabbitsEmptyBody =>
      'Birinchi quyonni kiriting — undan butun hisob boshlanadi: nasl-nasabi, salomatligi va bolalari.';

  @override
  String get rabbitsEmptyAction => 'Quyon qo\'shish';

  @override
  String get rabbitsNothingFound => 'Hech kim topilmadi';

  @override
  String get rabbitsNothingFoundBody =>
      'So\'rovni tekshiring yoki filtrlarni olib tashlang.';

  @override
  String get rabbitsFilterAll => 'Barchasi';

  @override
  String get rabbitsFilterMales => 'Erkaklar';

  @override
  String get rabbitsFilterFemales => 'Urg\'ochilar';

  @override
  String get rabbitsFilterActive => 'Ishda';

  @override
  String get rabbitsFilterSold => 'Sotilgan';

  @override
  String get sexMale => 'Erkak';

  @override
  String get sexFemale => 'Urg\'ochi';

  @override
  String get sexUnknown => 'Jinsi ko\'rsatilmagan';

  @override
  String get rabbitNoTag => 'Birkasiz';

  @override
  String get weightTitle => 'Vaznlar';

  @override
  String weightSubtitle(String name) {
    return '$name';
  }

  @override
  String get weightEmptyTitle => 'Hali o\'lchov yo\'q';

  @override
  String get weightEmptyBody =>
      'Vaznni yozib boring — shu bo\'yicha quyon o\'sayotgani yoki muammo borligi ko\'rinadi.';

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
  String get weightValuePositive => 'Vazn noldan katta bo\'lishi kerak';

  @override
  String get weightWhen => 'Qachon o\'lchandi';

  @override
  String get weightNotes => 'Eslatmalar';

  @override
  String get weightSaved => 'Vazn yozildi';

  @override
  String get weightSaveFailed => 'Vaznni yozib bo\'lmadi';

  @override
  String get galleryTitle => 'Rasmlar galereyasi';

  @override
  String get galleryEmptyTitle => 'Hali rasm yo\'q';

  @override
  String get galleryEmptyBody =>
      'Rasm qo\'shing — kartochkada bittasi qoladi, bu yerda esa barchasi joylashadi.';

  @override
  String get galleryAdd => 'Rasm qo\'shish';

  @override
  String get galleryUploaded => 'Rasm qo\'shildi';

  @override
  String get galleryCaptionTitle => 'Rasmga izoh';

  @override
  String get galleryCaptionLabel => 'Masalan, «Soch olingandan keyin»';

  @override
  String get galleryCaptionSkip => 'Izohsiz';

  @override
  String get galleryDeleteTitle => 'Rasm o\'chirilsinmi?';

  @override
  String get galleryDeleteBody => 'Uni qayta tiklab bo\'lmaydi.';

  @override
  String get galleryDeleted => 'Rasm o\'chirildi';

  @override
  String get pedigreeTitle => 'Nasl-nasab';

  @override
  String get rabbitDetailEdit => 'O\'zgartirish';

  @override
  String get rabbitDetailDeleteTitle => 'Quyon o\'chirilsinmi?';

  @override
  String rabbitDetailDeleteBody(String name) {
    return '$name bilan birga uning vaznlari, emlashlari va davolash yozuvlari ham o\'chadi.';
  }

  @override
  String get rabbitDetailDeleted => 'Quyon o\'chirildi';

  @override
  String get rabbitDetailDeleteFailed => 'Quyonni o\'chirib bo\'lmadi';

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
      'Emlash va davolashni belgilang — har bir quyonda nima bo\'lgani va qachon qayta emlash kerakligi ko\'rinadi.';

  @override
  String get healthNoneInViewTitle => 'Bu tanlovda bo\'sh';

  @override
  String healthNoneForRabbitTitle(String name) {
    return '${name}da salomatlik yozuvi yo\'q';
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
  String get farmReports => 'Ferma bo\'yicha xulosa';

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
  String get settingsAppearance => 'Tashqi ko\'rinish';

  @override
  String get settingsTheme => 'Mavzu';

  @override
  String get settingsAccent => 'Urg\'u rangi';

  @override
  String get settingsLanguage => 'Til';

  @override
  String get settingsNotifications => 'Bildirishnomalar';

  @override
  String get settingsDigestToggle => 'Xo\'jalik bo\'yicha kunlik xulosa';

  @override
  String get settingsAbout => 'Ilova haqida';

  @override
  String get settingsVersion => 'Versiya';

  @override
  String get settingsSupport => 'Qo\'llab-quvvatlashga yozish';

  @override
  String get supportRequestTitle => 'Qo\'llab-quvvatlash';

  @override
  String get supportRequestHint =>
      'Nima bo\'lganini yozing — javobni murojaat yuborilgan akkauntga beramiz.';

  @override
  String get supportRequestPlaceholder =>
      'Masalan: quyon qo\'sha olmayapman — ilova saqlashda osilib qolyapti';

  @override
  String get supportRequestTooShort =>
      'Muammoni batafsilroq yozing — kamida 10 ta belgi';

  @override
  String get supportRequestSend => 'Yuborish';

  @override
  String get supportRequestSent => 'Murojaat yuborildi';

  @override
  String get supportContactHint => 'Yoki to\'g\'ridan-to\'g\'ri bog\'laning:';

  @override
  String get settingsPrivacyPolicy => 'Maxfiylik siyosati';

  @override
  String get settingsLogout => 'Akkauntdan chiqish';

  @override
  String get settingsThemeLight => 'Yorug\'';

  @override
  String get settingsThemeSystem => 'Tizimdagidek';

  @override
  String get settingsThemeDark => 'Qorong\'i';

  @override
  String get settingsSubscription => 'Tarif';

  @override
  String get subscriptionTitle => 'Tarif';

  @override
  String get subscriptionNoPlan => 'Tarif belgilanmagan';

  @override
  String get subscriptionNoPlanHint =>
      'Tarifni ulash uchun qo\'llab-quvvatlash bilan bog\'laning.';

  @override
  String get subscriptionContactSupport => 'Qo\'llab-quvvatlashga yozish';

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
  String get subscriptionPay => 'To\'lash';

  @override
  String get subscriptionOpenPaymentPage => 'To\'lov sahifasini ochish';

  @override
  String get subscriptionAfterPayingHint =>
      'Ochilgan havola orqali to\'lang, keyin bu yerga qaytib «To\'lovni tekshirish» tugmasini bosing.';

  @override
  String get subscriptionCheckPayment => 'To\'lovni tekshirish';

  @override
  String get subscriptionPaymentCompleted =>
      'To\'lov o\'tdi, tarif uzaytirildi';

  @override
  String get subscriptionPaymentPending =>
      'Bank to\'lovni hali tasdiqlamadi — bir daqiqadan keyin qayta urinib ko\'ring';

  @override
  String get splashTagline => 'Fermani boshqarish';

  @override
  String get registerTitle => 'O\'z fermam';

  @override
  String get registerSubtitle =>
      'Fermani oching — ishchilarga ruxsatni keyin berasiz';

  @override
  String get registerFarmName => 'Ferma nomi';

  @override
  String get registerFarmNameHint =>
      'Bo\'sh qoldirish mumkin — ismingiz bilan ataymiz. Keyin nomni o\'zgartirib bo\'lmaydi';

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
  String get registerEmailInvalid => 'Manzilda xatolik bo\'lsa kerak';

  @override
  String get registerSubmit => 'Fermani ochish';

  @override
  String get registerHaveAccount => 'Akkauntingiz bormi?';

  @override
  String get registerFailed => 'Ro\'yxatdan o\'tib bo\'lmadi';

  @override
  String get registerConsentPrefix => 'Men ';

  @override
  String get registerConsentLink => 'maxfiylik siyosatini qabul qilaman';

  @override
  String get registerConsentRequired =>
      'Davom etish uchun maxfiylik siyosatini qabul qilish kerak';

  @override
  String get birthsTitle => 'Tug\'ishlar';

  @override
  String get birthsEmptyTitle => 'Hali tug\'ish yo\'q';

  @override
  String get birthsEmptyBody =>
      'Tug\'ishni yozing — ilova bolalarga kartochkalarni o\'zi ochadi.';

  @override
  String get birthsAdd => 'Tug\'ishni yozish';

  @override
  String get birthsMotherUnknown => 'Onasi ko\'rsatilmagan';

  @override
  String birthsMotherLine(String name) {
    return 'Onasi: $name';
  }

  @override
  String get birthsFromBreeding => 'Juftlashtirish yozuvi bo\'yicha';

  @override
  String get birthsAlive => 'Tirik';

  @override
  String get birthsDead => 'O\'lik';

  @override
  String get birthsWeaned => 'Ajratilgan';

  @override
  String get birthsSurvival => 'Omon qolish';

  @override
  String get birthsComplications => 'Asoratlar';

  @override
  String get birthsDeleteTitle => 'Tug\'ish haqidagi yozuv o\'chirilsinmi?';

  @override
  String get birthsDeleteBody =>
      'Bolalar kartochkalari qoladi — faqat tug\'ish haqidagi yozuv o\'chadi.';

  @override
  String get birthsDeleted => 'Yozuv o\'chirildi';

  @override
  String get birthsDeleteFailed => 'Yozuvni o\'chirib bo\'lmadi';

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
    return 'Bunday bo\'ladi: $first, $second, …';
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
  String get birthsKitsFailed => 'Kartochkalarni ochib bo\'lmadi';

  @override
  String get birthFormNewTitle => 'Yangi tug\'ish';

  @override
  String get birthFormEditTitle => 'Tug\'ish';

  @override
  String get birthFormMother => 'Onasi';

  @override
  String get birthFormDate => 'Qachon tug\'di';

  @override
  String get birthFormSectionLitter => 'Bola soni';

  @override
  String get birthFormAliveLabel => 'Tirik tug\'ildi';

  @override
  String get birthFormDeadLabel => 'O\'lik tug\'ildi';

  @override
  String get birthFormAliveEmpty => 'Sonini kiriting';

  @override
  String get birthFormComplications => 'Asoratlar';

  @override
  String get birthFormComplicationsHint =>
      'Nimadir noto\'g\'ri ketgan bo\'lsa, yozing';

  @override
  String get birthFormNotes => 'Eslatmalar';

  @override
  String get birthFormAutoKits => 'Bolalarga kartochkani darhol ochish';

  @override
  String get birthFormCreated => 'Tug\'ish yozildi';

  @override
  String get birthFormUpdated => 'Yozuv yangilandi';

  @override
  String get birthFormFailed => 'Yozuvni saqlab bo\'lmadi';

  @override
  String get breedsTitle => 'Zotlar';

  @override
  String get breedsSearchHint => 'Zot nomi';

  @override
  String get breedsAdd => 'Zot qo\'shish';

  @override
  String get breedsEmptyTitle => 'Hali zot yo\'q';

  @override
  String get breedsEmptyBody =>
      'Zotlarni kiriting — ular bo\'yicha juft tanlash va vazn qo\'shimini solishtirish qulay bo\'ladi.';

  @override
  String get breedsNothingFound => 'Hech narsa topilmadi';

  @override
  String get breedsNothingFoundBody => 'So\'rovni tekshiring.';

  @override
  String get breedsDeleteTitle => 'Zot o\'chirilsinmi?';

  @override
  String breedsDeleteBody(String name) {
    return '«$name» ma\'lumotnomadan yo\'qoladi. Bu zotdagi quyonlar qoladi, lekin zotsiz.';
  }

  @override
  String get breedsDeleted => 'Zot o\'chirildi';

  @override
  String get breedsDeleteFailed => 'Zotni o\'chirib bo\'lmadi';

  @override
  String get breedPurposeMeat => 'Go\'shtchilik';

  @override
  String get breedPurposeFur => 'Momiqchilik';

  @override
  String get breedPurposeDecorative => 'Dekorativ';

  @override
  String get breedPurposeCombined => 'Go\'sht-teri';

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
  String get breedFormWeight => 'O\'rtacha vazn, kg';

  @override
  String get breedFormWeightHint => 'Masalan, 4,5';

  @override
  String get breedFormLitter => 'Odatiy bola soni';

  @override
  String get breedFormLitterHint => 'Masalan, 8';

  @override
  String get breedFormLitterSuffix => 'quyoncha';

  @override
  String get breedFormCreated => 'Zot qo\'shildi';

  @override
  String get breedFormUpdated => 'Zot yangilandi';

  @override
  String get breedFormFailed => 'Zotni saqlab bo\'lmadi';

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
  String get breedingExpected => 'Kutilayotgan tug\'ish';

  @override
  String get breedingPalpation => 'Paypaslash sanasi';

  @override
  String get breedingPregnancy => 'Bo\'g\'ozlik';

  @override
  String get breedingPregnancyYes => 'Tasdiqlangan';

  @override
  String get breedingPregnancyNo => 'Tasdiqlanmagan';

  @override
  String get breedingNotes => 'Eslatmalar';

  @override
  String get breedingRegisterBirth => 'Tug\'ishni yozish';

  @override
  String get breedingDeleteTitle => 'Juftlashtirish yozuvi o\'chirilsinmi?';

  @override
  String get breedingDeleteBody => 'Uni qaytarib bo\'lmaydi.';

  @override
  String get breedingDeleted => 'Yozuv o\'chirildi';

  @override
  String get breedingDeleteFailed => 'Yozuvni o\'chirib bo\'lmadi';

  @override
  String get breedingFormNewTitle => 'Yangi juftlashtirish';

  @override
  String get breedingFormEditTitle => 'Juftlashtirish';

  @override
  String get breedingFormPrefilled => 'Juft tanlovdan qo\'yildi';

  @override
  String get breedingFormMale => 'Erkak';

  @override
  String get breedingFormFemale => 'Urg\'ochi';

  @override
  String get breedingFormMaleRequired => 'Erkakni tanlang';

  @override
  String get breedingFormFemaleRequired => 'Urg\'ochini tanlang';

  @override
  String get breedingFormNotesHint =>
      'Bu juftlashtirish haqida eslab qolish kerak bo\'lgan narsa';

  @override
  String get breedingFormCreated => 'Juftlashtirish yozildi';

  @override
  String get breedingFormUpdated => 'Yozuv yangilandi';

  @override
  String get breedingFormFailed => 'Yozuvni saqlab bo\'lmadi';

  @override
  String get plannerTitle => 'Juft tanlash';

  @override
  String get plannerIntro =>
      'Erkak va urg\'ochini tanlang — ilova nasl-nasabini ko\'rib, ular qanchalik qarindosh ekanini aytadi.';

  @override
  String get plannerAnalysisFailed => 'Nasl-nasabni tahlil qilib bo\'lmadi';

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
  String get plannerPedigreeFailed => 'Nasl-nasabni yuklab bo\'lmadi';

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
      'Fermada hozircha faqat siz bor. Yordamchi taklif qiling — u shu xo\'jalikka kirish huquqini oladi.';

  @override
  String get staffInvitesFailed => 'Takliflarni yuklab bo\'lmadi';

  @override
  String get staffPendingInvites => 'Javob kutilmoqda';

  @override
  String staffAccessClosed(String name) {
    return '$name uchun kirish yopildi';
  }

  @override
  String get staffSaved => 'O\'zgarishlar saqlandi';

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
  String get planLimitStaffTitle => 'Tarif bo\'yicha ishtirokchilar chegarasi';

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
    return 'U kirishda $phone raqamini va SMS orqali keladigan kodni kiritadi. Hech narsa yetkazish shart emas.';
  }

  @override
  String staffInvitedEmailBody(String email) {
    return 'U kirishda $email pochtasini va xat orqali keladigan kodni kiritadi. Hech narsa yetkazish shart emas.';
  }

  @override
  String get staffInviteChannelPhone => 'Telefon orqali';

  @override
  String get staffInviteChannelEmail => 'Pochta orqali';

  @override
  String get staffInvitePhoneHint => '+992 XX XXX XX XX';

  @override
  String get staffInvitePhoneInvalid => 'Raqam +992 90 123 45 67 ko\'rinishida';

  @override
  String get staffInviteNameLabel => 'Ishchining ismi';

  @override
  String get staffInviteNameHint => 'U fermada shu nom bilan ko\'rinadi';

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
  String get staffTransferOwnership => 'Xo\'jalikni topshirish';

  @override
  String get staffTransferTitle => 'Xo\'jalik topshirilsinmi?';

  @override
  String staffTransferBody(String name) {
    return 'Ferma ${name}ga o\'tadi, siz esa boshqaruvchi bo\'lasiz. Buni ortga qaytarib bo\'lmaydi.';
  }

  @override
  String get staffTransferConfirm => 'Fermani topshirish';

  @override
  String staffTransferred(String name) {
    return 'Xo\'jalik ${name}ga topshirildi';
  }

  @override
  String get rabbitTapToZoom => 'Yaqinroq ko\'rish uchun bosing';

  @override
  String rabbitTagLine(String tag) {
    return '$tag-birka';
  }

  @override
  String get rabbitMainInfo => 'Asosiy';

  @override
  String get rabbitBreed => 'Zoti';

  @override
  String get rabbitBreedUnknown => 'Ko\'rsatilmagan';

  @override
  String get rabbitSex => 'Jinsi';

  @override
  String get rabbitAge => 'Yoshi';

  @override
  String get rabbitBirthDate => 'Tug\'ilgan sanasi';

  @override
  String get rabbitColor => 'Rangi';

  @override
  String get rabbitWeight => 'Vazni';

  @override
  String get rabbitQuickActions => 'Nimalarni ko\'rish mumkin';

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
  String get rabbitCreatedAt => 'Qo\'shilgan';

  @override
  String get rabbitUpdatedAt => 'O\'zgartirilgan';

  @override
  String get purposeBreeding => 'Naslga';

  @override
  String get purposeMeat => 'Go\'shtga';

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
  String get rabbitFormPhotoAdd => 'Rasm qo\'shish';

  @override
  String get rabbitFormPhotoChange => 'Rasmni almashtirish';

  @override
  String get rabbitFormPhotoGallery => 'Galereyadan tanlash';

  @override
  String get rabbitFormPhotoCamera => 'Kamerada suratga olish';

  @override
  String get rabbitFormPhotoRemove => 'Rasmni olib tashlash';

  @override
  String get rabbitFormPhotoFailed => 'Rasmni olib bo\'lmadi';

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
  String get rabbitFormBreedsFailed => 'Zotlarni yuklab bo\'lmadi';

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
      'Bu quyon haqida eslab qolish kerak bo\'lgan narsa';

  @override
  String get rabbitFormCreated => 'Quyon qo\'shildi';

  @override
  String get rabbitFormUpdated => 'Ma\'lumotlar yangilandi';

  @override
  String get rabbitFormFailed => 'Saqlab bo\'lmadi';

  @override
  String get rabbitFormLoadFailed => 'Quyonni yuklab bo\'lmadi';

  @override
  String get planLimitRabbitsTitle => 'Tarif bo\'yicha quyonlar chegarasi';

  @override
  String get planLimitRabbitsBody =>
      'Ferma joriy tarifga ruxsat etilgan quyonlar chegarasiga yetdi. Yana qo\'shish uchun kattaroq chegarali tarif kerak — ferma egasiga murojaat qiling.';

  @override
  String get statusHealthy => 'Sog\'lom';

  @override
  String get statusSick => 'Kasal';

  @override
  String get statusQuarantine => 'Karantinda';

  @override
  String get statusPregnant => 'Bo\'g\'oz';

  @override
  String get statusSold => 'Sotilgan';

  @override
  String get statusDead => 'Nobud bo\'lgan';

  @override
  String get purposeShow => 'Ko\'rgazmaga';

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
  String get chartNoData => 'Hozircha ko\'rsatadigan narsa yo\'q';

  @override
  String get chartWeight => 'Vazn grafigi';

  @override
  String get feedStatsTitle => 'Ombor raqamlarda';

  @override
  String get feedStatsEmptyTitle => 'Ombor hali bo\'sh';

  @override
  String get feedStatsEmptyBody =>
      'Emlarni kiriting — bu yerda zaxira tarkibi, uning qiymati va qoldiqlar haqida ogohlantirishlar paydo bo\'ladi.';

  @override
  String get feedStatsPositions => 'Em xillari';

  @override
  String get feedStatsLow => 'Tugab qolyapti';

  @override
  String get feedStatsValue => 'Zaxira qiymati';

  @override
  String get feedStatsByType => 'Turlar bo\'yicha tarkib';

  @override
  String get feedStatsLowList => 'Tugab qolayotgan qoldiqlar';

  @override
  String get feedStatsAllGood => 'Barcha turlar bo\'yicha zaxira yetarli';

  @override
  String feedStatsMinimum(String amount) {
    return 'minimum $amount';
  }

  @override
  String get feedingStatsTitle => 'Oziqlantirishlar raqamlarda';

  @override
  String get feedingStatsEmptyTitle => 'Bu davrda oziqlantirish bo\'lmagan';

  @override
  String get feedingStatsEmptyBody =>
      'Kengroq davrni tanlang yoki oziqlantirishni yozing — em sarfi va xarajatlar o\'zi hisoblanadi.';

  @override
  String get feedingStatsCount => 'Oziqlantirishlar';

  @override
  String get feedingStatsCost => 'Em xarajati';

  @override
  String get feedingStatsGiven => 'Berildi';

  @override
  String get feedingStatsByFeed => 'Emlar bo\'yicha';

  @override
  String feedingStatsChartTitle(String unit) {
    return 'Em turlari bo\'yicha sarf, $unit';
  }

  @override
  String get feedingStatsChartTitlePlain => 'Em turlari bo\'yicha sarf';

  @override
  String get financeStatsTitle => 'Moliya raqamlarda';

  @override
  String get financeStatsEmptyTitle => 'Bu davrda amaliyot bo\'lmagan';

  @override
  String get financeStatsEmptyBody =>
      'Kengroq davrni tanlang yoki birinchi amaliyotni yozing — yakunlar o\'zi hisoblanadi.';

  @override
  String get financeProfit => 'Foyda';

  @override
  String get financeLoss => 'Zarar';

  @override
  String get financeIncomeByCategory => 'Toifalar bo\'yicha daromad';

  @override
  String get financeExpensesByCategory => 'Toifalar bo\'yicha xarajat';

  @override
  String get financeRecent => 'So\'nggi amaliyotlar';

  @override
  String get txCategorySaleRabbit => 'Quyon sotish';

  @override
  String get txCategorySaleMeat => 'Go\'sht sotish';

  @override
  String get txCategorySaleFur => 'Teri sotish';

  @override
  String get txCategoryBreedingFee => 'Juftlashtirish uchun to\'lov';

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
  String get reportsOutcomeUnknown => 'Natija ko\'rsatilmagan';

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
  String get reportsBirths => 'Tug\'ishlar';

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
  String get reportsByBreed => 'Zotlar bo\'yicha jonivorlar';

  @override
  String reportsBreedUnknown(int id) {
    return '$id-zot';
  }

  @override
  String get reportsMoney => 'Davr uchun pul';

  @override
  String get reportsNoActivityTitle => 'Bu davrda yozuv yo\'q';

  @override
  String get reportsNoActivityBody =>
      'Kengroq davrni tanlang — yoki juftlashtirish, emlash, oziqlantirishni yozing, ular shu yerda paydo bo\'ladi.';

  @override
  String get reportsFarmEmptyTitle => 'Hisobot uchun hali material yo\'q';

  @override
  String get reportsFarmEmptyBody =>
      'Birinchi quyonni kiriting — keyin hisobot kundalik yozuvlardan o\'zi to\'planadi.';

  @override
  String get reportsHealthEmptyTitle =>
      'Bu davrda emlash va davolash bo\'lmagan';

  @override
  String get reportsHealthEmptyBody =>
      'Kengroq davrni tanlang yoki emlashni belgilang — hisobot o\'zi hisoblanadi.';

  @override
  String get reportsVaccinesByName => 'Vaksinalar bo\'yicha emlashlar';

  @override
  String get reportsRecordsByOutcome => 'Natijalar bo\'yicha davolash';

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
  String get platformTabAnnouncements => 'E\'lonlar';

  @override
  String get platformTabSupport => 'Murojaatlar';

  @override
  String get platformSummarySectionFarms => 'Fermalar';

  @override
  String get platformSummarySectionStatus => 'Holat';

  @override
  String get platformSummarySectionActivity => 'Faollik';

  @override
  String get platformSummarySectionData => 'Ma\'lumotlar';

  @override
  String get platformSummaryTotalFarms => 'Jami fermalar';

  @override
  String get platformSummaryFree => 'Bepulda';

  @override
  String get platformSummaryPaid => 'Pullikda';

  @override
  String get platformSummaryExpired => 'Tarif muddati o\'tgan';

  @override
  String get platformSummaryAtLimit => 'Tarif chegarasida';

  @override
  String get platformSummaryRegistrations30d =>
      '30 kunda ro\'yxatdan o\'tishlar';

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
      other: '$count e\'lon',
      one: '$count e\'lon',
    );
    return '$_temp0';
  }

  @override
  String get platformFarmsEmptyTitle => 'Hali ferma yo\'q';

  @override
  String get platformFarmsEmptyBody =>
      'Bu yerda xizmatning barcha xo\'jaliklari bo\'ladi — kimdir ro\'yxatdan o\'tishi bilan o\'zi paydo bo\'ladi.';

  @override
  String get platformFarmsNothingFound => 'Hech narsa topilmadi';

  @override
  String get platformFarmsNothingFoundBody =>
      'So\'rovni tekshiring yoki filtrni olib tashlang.';

  @override
  String get platformOwnerMissing => 'Egasi tayinlanmagan';

  @override
  String get platformNoPlan => 'Tarifsiz';

  @override
  String get platformNoPlanHint => 'Chegara yo\'q';

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
  String get platformFilterExpired => 'Tarif muddati o\'tgan';

  @override
  String platformFilterUnknown(String filter) {
    return 'Noma\'lum kesim: $filter';
  }

  @override
  String get platformChangePlan => 'Tarifni almashtirish';

  @override
  String get platformAssignPlan => 'Tarif tayinlash';

  @override
  String platformPlanSheetTitle(String farm) {
    return '«$farm» xo\'jaligining tarifi';
  }

  @override
  String get platformPlanOff => 'Tarifsiz — chegarasiz ishlaydi';

  @override
  String get platformPlanAssigned => 'Tarif yangilandi';

  @override
  String get platformPlanInactive => 'o\'chirilgan';

  @override
  String get platformPlansEmptyTitle => 'Hali tarif yo\'q';

  @override
  String get platformPlansEmptyBody =>
      'Hozircha ular yo\'q, barcha fermalar chegarasiz ishlaydi. Birinchisini yarating — va uni tayinlash mumkin bo\'ladi.';

  @override
  String get platformPlanNew => 'Yangi tarif';

  @override
  String get platformPlanEdit => 'O\'zgartirish';

  @override
  String get platformPlanDeleteTitle => 'Tarif o\'chirilsinmi?';

  @override
  String platformPlanDeleteBody(String name) {
    return '«$name» ro\'yxatdan yo\'qoladi, undagi fermalar esa chegarasiz ishlay boshlaydi. Ularning yozuvlariga tegilmaydi.';
  }

  @override
  String get platformPlanDeleted => 'Tarif o\'chirildi';

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
  String get platformPlanFormPriceHint => 'Bo\'sh — bepul';

  @override
  String get platformPlanFormSectionLimits => 'Chegaralar';

  @override
  String get platformPlanFormMaxRabbits => 'Quyonlar ko\'pi bilan';

  @override
  String get platformPlanFormMaxStaff => 'Odamlar ko\'pi bilan';

  @override
  String get platformPlanFormLimitHint => 'Bo\'sh — chegarasiz';

  @override
  String get platformPlanFormActive => 'Tarif ishlamoqda';

  @override
  String get platformPlanFormActiveHint =>
      'O\'chirilgan tarif unga allaqachon tayinlangan fermalarda qoladi, lekin yangilariga berilmaydi.';

  @override
  String get platformPlanFormDefault => 'Yangi fermalarga berilsin';

  @override
  String get platformPlanFormDefaultHint =>
      'Bu tarif har bir yangi ro\'yxatdan o\'tgan fermaga avtomatik beriladi. Faqat bitta tarif shunday bo\'lishi mumkin — boshqasiga tayinlash uchun avval joriysidan belgini olib tashlang.';

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
  String get platformFarmSectionImpersonate => 'Mijoz nomidan ko\'rish';

  @override
  String get platformFarmSectionPlan => 'Tarif';

  @override
  String get platformFarmSectionExtras => 'Yengillik';

  @override
  String get platformFarmSectionUsage => 'Sarf';

  @override
  String get platformFarmSectionStaff => 'Tarkib';

  @override
  String get platformFarmSectionPayments => 'To\'lovlar';

  @override
  String get platformFarmSectionFacts => 'Ferma haqida yana';

  @override
  String get platformFarmSectionExport => 'Ma\'lumotlarni chiqarish';

  @override
  String get platformFarmSectionDanger => 'Fermani o\'chirish';

  @override
  String get platformFarmContactMissing =>
      'Pochta ham, telefon ham yo\'q — bog\'lanib bo\'lmaydi';

  @override
  String get platformFarmStatusActive => 'Odatdagidek ishlaydi';

  @override
  String get platformFarmStatusActiveHint =>
      'Ferma to\'sqinliksiz o\'zining hammasini o\'qiydi va yozadi.';

  @override
  String get platformFarmStatusReadOnly => 'Faqat o\'qish';

  @override
  String get platformFarmStatusReadOnlyHint =>
      'Ma\'lumotlar ko\'rinadi, hech narsa yozib bo\'lmaydi. Shunday to\'lanmaganda qilinadi: xo\'jalik tarixi fermerda qoladi, lekin to\'lamaguncha unda ishlab bo\'lmaydi.';

  @override
  String get platformFarmStatusSuspended => 'Kirish yopilgan';

  @override
  String get platformFarmStatusSuspendedHint =>
      'Ferma hech kimni kiritmaydi — na yozib, na ko\'rib bo\'ladi.';

  @override
  String platformFarmStatusUnknown(String status) {
    return 'Noma\'lum holat: $status';
  }

  @override
  String get platformFarmStatusChange => 'Kirishni o\'zgartirish';

  @override
  String platformFarmStatusSheetTitle(String farm) {
    return '«$farm» xo\'jaligining kirishi';
  }

  @override
  String get platformFarmStatusConfirmTitle => 'Kirish o\'zgartirilsinmi?';

  @override
  String platformFarmStatusConfirmBody(String status) {
    return 'Xo\'jalik «$status» holatiga o\'tadi. Fermadagi odamlar buni qayta kirmasdan darhol ko\'radi.';
  }

  @override
  String get platformFarmStatusApply => 'Qo\'llash';

  @override
  String get platformFarmStatusUpdated => 'Kirish yangilandi';

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
  String get platformFarmPlanExtend => 'Qo\'lda uzaytirish';

  @override
  String get platformFarmPlanExtended => 'Tarif muddati yangilandi';

  @override
  String get platformFarmExtrasNone =>
      'Yengillik yo\'q — tarif chegaralari amal qiladi';

  @override
  String get platformFarmExtrasGrant => 'Yengillik berish';

  @override
  String get platformFarmExtrasEdit => 'O\'zgartirish';

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
      'Faqat shu fermaning chegaralariga qo\'shimcha. Tarifning o\'zi o\'zgarmaydi — na unda, na boshqalarda.';

  @override
  String get platformFarmExtrasFormRabbits => 'Tarifdan tashqari quyonlar';

  @override
  String get platformFarmExtrasFormStaff => 'Tarifdan tashqari odamlar';

  @override
  String get platformFarmExtrasFormAmountHint => 'Bo\'sh — qo\'shimchasiz';

  @override
  String get platformFarmExtrasFormUntil => 'Amal qilish muddati';

  @override
  String get platformFarmExtrasFormSetDeadline => 'Muddat belgilash';

  @override
  String get platformFarmExtrasFormEndlessHint =>
      'Muddatsiz bo\'lsa, yengillik cheksiz amal qiladi.';

  @override
  String get platformFarmExtrasFormEmpty =>
      'Quyon yoki odam sonini ko\'rsating — yoki yengillikni olib tashlang';

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
      'Tarkibda hech kim yo\'q — hatto egasi ham';

  @override
  String get platformFarmPaymentsEmpty => 'Hali to\'lov bo\'lmagan';

  @override
  String get platformFarmPaymentNew => 'Boshlangan';

  @override
  String get platformFarmPaymentCompleted => 'To\'langan';

  @override
  String get platformFarmPaymentFailed => 'O\'tmagan';

  @override
  String get platformFarmImpersonate => 'Mijoz nomidan kirish';

  @override
  String get platformFarmImpersonateHint =>
      'Ilovani ferma egasi ko\'rgandek ko\'rish — «ekraningizda nima bor» deb yozishmaslik uchun. Faqat o\'qish, 15 daqiqa, amal jurnalga tushadi.';

  @override
  String get platformFarmImpersonateTitle => 'Mijoz nomidan kirilsinmi?';

  @override
  String platformFarmImpersonateBody(String farmName) {
    return '${farmName}ni egasi ko\'rgandek ko\'rasiz — hech narsani o\'zgartira olmaysiz. Seans 15 daqiqadan keyin o\'zi tugaydi yoki «Chiqish» tugmasi bilan.';
  }

  @override
  String get platformFarmImpersonateReasonLabel => 'Sababi';

  @override
  String get platformFarmImpersonateReasonHint =>
      'Masalan: qo\'llab-quvvatlashga shikoyat №482';

  @override
  String get platformFarmImpersonateReasonRequired =>
      'Sababini ko\'rsating — bo\'lmasa, kirish jurnalga yozilmaydi';

  @override
  String get platformFarmImpersonateConfirm => 'Kirish';

  @override
  String impersonationBanner(String farmName) {
    return 'Siz «$farmName»ni ko\'ryapsiz — faqat o\'qish';
  }

  @override
  String get impersonationExit => 'Chiqish';

  @override
  String get impersonationExpired =>
      'Ko\'rish seansi tugadi — siz yana o\'z akkauntingizdasiz';

  @override
  String get farmStatusBannerReadOnly =>
      'Faqat o\'qish uchun kirish — yozuv kiritishni davom ettirish uchun tarifni uzaytiring';

  @override
  String get farmStatusBannerSuspended =>
      'Kirish yopilgan — qo\'llab-quvvatlashga murojaat qiling';

  @override
  String get farmStatusBannerAction => 'Tarif';

  @override
  String get farmStatusBannerContactSupport => 'Qo\'llab-quvvatlash';

  @override
  String get platformFarmExport => 'Ma\'lumotlarni eksport qilish';

  @override
  String get platformFarmExportHint =>
      'Fermaning barcha yozuvlari suratga olinadi — quyonlar, davolash, emlar, to\'lovlar. «Ma\'lumotlarimni bering» so\'roviga kerak bo\'ladi.';

  @override
  String platformFarmExportGeneratedAt(String date) {
    return 'Surat $date olindi';
  }

  @override
  String get platformFarmDelete => 'Fermani o\'chirish';

  @override
  String get platformFarmDeleteHint =>
      'Kirish darhol yopiladi, yozuvlar va fayllar esa 30 kundan keyin butunlay yo\'qoladi. Bungacha fermani qaytarish mumkin.';

  @override
  String get platformFarmDeleteTitle => 'Ferma o\'chirilsinmi?';

  @override
  String get platformFarmDeleteBody =>
      'Fermadagi odamlar kirish huquqini darhol yo\'qotadi. Quyonlar, davolash, rasmlar va to\'lovlar 30 kundan keyin butunlay o\'chiriladi — bungacha o\'chirishni bekor qilish mumkin. Tasdiqlash uchun xo\'jalik nomini kiriting.';

  @override
  String get platformFarmDeleteConfirmLabel => 'Ferma nomi';

  @override
  String platformFarmDeleteConfirmHint(String name) {
    return '«$name» deb kiriting';
  }

  @override
  String get platformFarmDeleteMismatch => 'Nomi ferma nomiga mos kelmadi';

  @override
  String get platformFarmDeleted => 'Ferma o\'chirildi';

  @override
  String platformFarmDeletedBanner(String date) {
    return 'Ferma ${date}da o\'chirildi. Yozuvlar va fayllar o\'chirilgandan 30 kun o\'tib butunlay tozalanadi.';
  }

  @override
  String get platformFarmDeletedLocked =>
      'Ferma o\'chirilgan paytda kirish va yengilliklar o\'zgartirilmaydi — avval uni tiklang.';

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
  String get platformSupportRequestsEmptyTitle => 'Hali murojaat yo\'q';

  @override
  String get platformSupportRequestsEmptyBody =>
      'Bu yerda fermalardan savollar paydo bo\'ladi — fermer Sozlamalar → Qo\'llab-quvvatlashga yozish orqali yozadi.';

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
  String get platformAnnouncementsEmptyTitle => 'Hali e\'lon bo\'lmagan';

  @override
  String get platformAnnouncementsEmptyBody =>
      'Bu yerda yuborilganlar tarixi qoladi: nima yuborilgan, kimga va nechtasiga yetgan. Yuborilganni tuzatib yoki qaytarib bo\'lmaydi, shuning uchun ro\'yxat bir xil narsani ikki marta takrorlamaslikka yordam beradi.';

  @override
  String get platformAnnouncementNew => 'Yangi e\'lon';

  @override
  String get platformAnnouncementSend => 'Yuborish';

  @override
  String get platformAnnouncementTargetAll => 'Barcha fermalarga';

  @override
  String get platformAnnouncementTargetAllHint =>
      'O\'chirilganlardan tashqari, xizmatning har bir xo\'jaligiga';

  @override
  String get platformAnnouncementTargetFarm => 'Bitta fermaga';

  @override
  String get platformAnnouncementTargetFarmHint =>
      'Bitta xo\'jalikka — masalan, uning murojaatiga javoban';

  @override
  String get platformAnnouncementTargetFilter => 'Fermalar kesimi bo\'yicha';

  @override
  String get platformAnnouncementTargetFilterHint =>
      'Fermalar ro\'yxatidagi kesimlar bilan bir xil: tarifsiz, chegaraga yetgan, kirishi yopilgan';

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
      'Oluvchi topilmadi — e\'lon hech kimga yetmadi';

  @override
  String platformAnnouncementDelivered(int sent, int attempted) {
    return '$attempted tadan $sent tasiga yetkazildi';
  }

  @override
  String get platformAnnouncementDeliveredNobody =>
      'yuborishga hech kim yo\'q edi';

  @override
  String get platformAnnouncementDeliveryUnknown => 'natija saqlanmagan';

  @override
  String get platformAnnouncementFormTitle => 'Yangi e\'lon';

  @override
  String get platformAnnouncementFormSubject => 'Sarlavha';

  @override
  String get platformAnnouncementFormSubjectHint =>
      'U xatning mavzusi va push sarlavhasi ham bo\'ladi';

  @override
  String get platformAnnouncementFormBody => 'Matn';

  @override
  String get platformAnnouncementFormBodyHint =>
      'Fermalar nimani bilishi kerak';

  @override
  String get platformAnnouncementFormSectionChannels => 'Kanallar';

  @override
  String get platformAnnouncementFormNoSms =>
      'E\'lonlar uchun SMS mavjud emas: to\'lov shlyuzi faqat oldindan tasdiqlangan shablonlarni qabul qiladi, e\'lon esa erkin matn.';

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
  String get platformAnnouncementConfirmTitle => 'E\'lon yuborilsinmi?';

  @override
  String get platformAnnouncementConfirmBody =>
      'Xabar oluvchilarga darhol yetadi. Yuborilganni qaytarib olib yoki tuzatib bo\'lmaydi.';

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
      other: 'E\'lon $count oluvchiga yetdi',
      one: 'E\'lon $count oluvchiga yetdi',
    );
    return '$_temp0';
  }

  @override
  String platformAnnouncementSentPartly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'E\'lon $count oluvchiga yetdi, lekin ba\'zi xabarlar yetib bormadi — ro\'yxatdagi qatorga qarang',
      one:
          'E\'lon $count oluvchiga yetdi, lekin ba\'zi xabarlar yetib bormadi — ro\'yxatdagi qatorga qarang',
    );
    return '$_temp0';
  }

  @override
  String get platformAnnouncementSentPlain => 'E\'lon yuborildi';

  @override
  String get storageUnitBytes => 'B';

  @override
  String get storageUnitKb => 'KB';

  @override
  String get storageUnitMb => 'MB';

  @override
  String get storageUnitGb => 'GB';

  @override
  String get emptyNoRecordsTitle => 'Yozuv yo\'q';

  @override
  String get emptyNoRecordsBody => 'Birinchisini qo\'shing.';
}
