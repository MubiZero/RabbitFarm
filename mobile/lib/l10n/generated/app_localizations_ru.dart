// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'RabbitFarm';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonAdd => 'Добавить';

  @override
  String get commonDelete => 'Удалить';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonLoadFailed => 'Не удалось загрузить';

  @override
  String get commonUnknownError => 'Неизвестная ошибка';

  @override
  String get commonStaleData => 'Не удалось обновить, показаны прежние данные';

  @override
  String get commonRetryShort => 'Ещё раз';

  @override
  String get commonNotSpecified => 'Не указано';

  @override
  String get commonActions => 'Действия';

  @override
  String get loginSubtitle => 'Вход в вашу ферму';

  @override
  String get loginEmailLabel => 'Почта';

  @override
  String get loginEmailHint => 'name@example.com';

  @override
  String get loginEmailEmpty => 'Введите почту';

  @override
  String get loginEmailInvalid => 'Похоже, в адресе опечатка';

  @override
  String get loginPasswordLabel => 'Пароль';

  @override
  String get loginPasswordEmpty => 'Введите пароль';

  @override
  String get loginPasswordShow => 'Показать пароль';

  @override
  String get loginPasswordHide => 'Скрыть пароль';

  @override
  String get loginSubmit => 'Войти';

  @override
  String get loginFailed => 'Не удалось войти';

  @override
  String get loginHasInvite => 'У меня есть код приглашения';

  @override
  String get loginCreateFarm => 'Завести свою ферму';

  @override
  String get loginForgotPassword =>
      'Забыли пароль? Его сбрасывает владелец фермы — писем сервис не отправляет.';

  @override
  String get todayGreetingMorning => 'Доброе утро';

  @override
  String get todayGreetingDay => 'Добрый день';

  @override
  String get todayGreetingEvening => 'Добрый вечер';

  @override
  String get todayGreetingNight => 'Доброй ночи';

  @override
  String todayGreetingNamed(String greeting, String name) {
    return '$greeting, $name!';
  }

  @override
  String todayGreetingPlain(String greeting) {
    return '$greeting!';
  }

  @override
  String get todayNeedsAttention => 'Требует внимания';

  @override
  String get todayAllClear => 'Всё под контролем — срочного нет';

  @override
  String get todayFarmNow => 'Ферма сейчас';

  @override
  String get todayLast30Days => 'За 30 дней';

  @override
  String get todayStatLivestock => 'Поголовье';

  @override
  String get todayStatTasks => 'Задачи в работе';

  @override
  String get todayStatFreeCages => 'Клеток свободно';

  @override
  String get todayStatBirths => 'Родилось';

  @override
  String get todayStatIncome => 'Доход';

  @override
  String get todayStatExpenses => 'Расход';

  @override
  String get todayAlertOverdueTasks => 'Просроченные задачи';

  @override
  String get todayAlertOverdueVaccination => 'Вакцинация просрочена';

  @override
  String get todayAlertUrgentTasks => 'Срочные задачи';

  @override
  String get todayAlertLowFeed => 'Заканчивается корм';

  @override
  String get todayAlertUpcomingVaccination => 'Скоро вакцинация';

  @override
  String get todayTourAlertsTitle => 'Что требует внимания';

  @override
  String get todayTourAlertsBody =>
      'Просроченные задачи, вакцинация и заканчивающийся корм — всё срочное собирается здесь. Нажмите на строку, чтобы перейти к делу.';

  @override
  String get todayTourStatsTitle => 'Состояние фермы';

  @override
  String get todayTourStatsBody =>
      'Поголовье, незакрытые задачи и свободные клетки. Потяните экран вниз, чтобы обновить цифры.';

  @override
  String get menuTitle => 'Меню';

  @override
  String get menuProfile => 'Профиль';

  @override
  String get menuSectionLivestock => 'Поголовье';

  @override
  String get menuSectionBreeding => 'Разведение';

  @override
  String get menuSectionHealth => 'Здоровье';

  @override
  String get menuSectionFeeding => 'Корма';

  @override
  String get menuSectionLedger => 'Учёт';

  @override
  String get menuSectionApp => 'Приложение';

  @override
  String get menuCages => 'Клетки';

  @override
  String get menuBreeds => 'Породы';

  @override
  String get menuBreedings => 'Случки';

  @override
  String get menuBirths => 'Роды';

  @override
  String get menuPairPlanner => 'Подбор пар';

  @override
  String get menuVaccinations => 'Вакцинации';

  @override
  String get menuMedicalRecords => 'Лечение';

  @override
  String get menuFeedStock => 'Запасы';

  @override
  String get menuFeedingRecords => 'Кормления';

  @override
  String get menuFinance => 'Финансы';

  @override
  String get menuStaff => 'Работники';

  @override
  String get menuSettings => 'Настройки';

  @override
  String get menuAbout => 'О приложении';

  @override
  String get menuAboutBody =>
      'Учёт поголовья, кормов, здоровья и денег кроличьей фермы.';

  @override
  String get menuLogout => 'Выйти';

  @override
  String get roleOwner => 'Владелец фермы';

  @override
  String get roleManager => 'Управляющий';

  @override
  String get roleWorker => 'Работник';

  @override
  String get navToday => 'Сегодня';

  @override
  String get navRabbits => 'Кролики';

  @override
  String get navTasks => 'Задачи';

  @override
  String get navMenu => 'Меню';

  @override
  String get navNewTask => 'Новая задача';

  @override
  String get navQuickEntry => 'Быстрая запись';

  @override
  String get navQuickTitle => 'Что записать';

  @override
  String get quickRecordFeeding => 'Записать кормление';

  @override
  String get quickRecordVaccination => 'Записать вакцинацию';

  @override
  String get quickCreateTask => 'Создать задачу';

  @override
  String get quickAddRabbit => 'Добавить кролика';

  @override
  String get quickRecordBirth => 'Записать окрол';

  @override
  String get quickAddCage => 'Добавить клетку';

  @override
  String get formDiscardTitle => 'Выйти без сохранения?';

  @override
  String get formDiscardBody => 'Заполненные поля будут потеряны.';

  @override
  String get formDiscardStay => 'Продолжить ввод';

  @override
  String get formDiscardLeave => 'Выйти';

  @override
  String get breedingListTitle => 'Случки';

  @override
  String get breedingEmptyTitle => 'Случек пока нет';

  @override
  String get breedingEmptyBody =>
      'Запишите случку, и приложение подскажет ожидаемую дату окрола.';

  @override
  String get breedingEmptyAction => 'Записать случку';

  @override
  String get breedingMale => 'Самец';

  @override
  String get breedingFemale => 'Самка';

  @override
  String get breedingNameMissing => 'Имя не указано';

  @override
  String breedingExpectedBirth(String date) {
    return 'Окрол ожидается $date';
  }

  @override
  String get breedingStatusPlanned => 'Запланирована';

  @override
  String get breedingStatusCompleted => 'Завершена';

  @override
  String get breedingStatusFailed => 'Неудачная';

  @override
  String get breedingStatusCancelled => 'Отменена';

  @override
  String get cageTitle => 'Клетка';

  @override
  String cageTitleNumbered(String number) {
    return 'Клетка $number';
  }

  @override
  String get cageEdit => 'Изменить клетку';

  @override
  String get cageResidents => 'Жители';

  @override
  String get cageEmptyManaged =>
      'Клетка пустая. Поселите кролика кнопкой внизу.';

  @override
  String get cageEmptyReadOnly => 'Клетка пустая.';

  @override
  String get cageFull => 'Клетка заполнена';

  @override
  String get cageAddRabbit => 'Поселить кролика';

  @override
  String get cageNoLocation => 'Место не указано';

  @override
  String get cageRemoveTitle => 'Убрать из клетки?';

  @override
  String cageRemoveBody(String name) {
    return '$name перейдёт в список кроликов без клетки.';
  }

  @override
  String get cageRemoveConfirm => 'Убрать';

  @override
  String cageRemoved(String name) {
    return '$name убран из клетки';
  }

  @override
  String cageMoved(String name, String number) {
    return '$name переехал в клетку $number';
  }

  @override
  String cageSettled(String name) {
    return '$name поселён в клетку';
  }

  @override
  String cageActionFailed(String reason) {
    return 'Не удалось: $reason';
  }

  @override
  String get cageResidentMove => 'Переселить';

  @override
  String get cagePickRabbitTitle => 'Кого поселить';

  @override
  String get cagePickRabbitHint => 'Кличка или номер бирки';

  @override
  String get cagePickNothingFound => 'Никого не нашлось';

  @override
  String get cagePickNothingFoundBody => 'Проверьте кличку или номер бирки.';

  @override
  String cagePickCurrentCage(String number) {
    return 'Сейчас в клетке $number';
  }

  @override
  String get cagePickNoCage => 'Без клетки';

  @override
  String get cagePickCageTitle => 'Куда переселить';

  @override
  String get cagePickNoFreeCages => 'Свободных клеток нет';

  @override
  String get cagePickNoFreeCagesBody =>
      'Освободите место или добавьте новую клетку.';

  @override
  String get cageTypeSingle => 'Одиночная';

  @override
  String get cageTypeGroup => 'Групповая';

  @override
  String get cageTypeMaternity => 'Для окрола';

  @override
  String get cageConditionGood => 'В порядке';

  @override
  String get cageConditionNeedsRepair => 'Нужен ремонт';

  @override
  String get cageConditionBroken => 'Сломана';

  @override
  String countTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count задачи',
      many: '$count задач',
      few: '$count задачи',
      one: '$count задача',
    );
    return '$_temp0';
  }

  @override
  String countVaccinations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count прививки',
      many: '$count прививок',
      few: '$count прививки',
      one: '$count прививка',
    );
    return '$_temp0';
  }

  @override
  String countFeedKinds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вида корма',
      many: '$count видов корма',
      few: '$count вида корма',
      one: '$count вид корма',
    );
    return '$_temp0';
  }

  @override
  String countRabbits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count кролика',
      many: '$count кроликов',
      few: '$count кролика',
      one: '$count кролик',
    );
    return '$_temp0';
  }

  @override
  String countRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записи',
      many: '$count записей',
      few: '$count записи',
      one: '$count запись',
    );
    return '$_temp0';
  }

  @override
  String countOperations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count операции',
      many: '$count операций',
      few: '$count операции',
      one: '$count операция',
    );
    return '$_temp0';
  }

  @override
  String get tasksTitle => 'Задачи';

  @override
  String get tasksFilters => 'Фильтры';

  @override
  String get tasksFiltersApply => 'Применить';

  @override
  String get tasksFiltersReset => 'Сбросить';

  @override
  String get tasksFilterType => 'Тип';

  @override
  String get tasksFilterStatus => 'Статус';

  @override
  String get tasksFilterPriority => 'Приоритет';

  @override
  String get tasksFilterOverdueOnly => 'Только просроченные';

  @override
  String get tasksFilterTodayOnly => 'Только на сегодня';

  @override
  String get tasksEmptyTitle => 'Задач пока нет';

  @override
  String get tasksEmptyBody =>
      'Создайте задачу — приложение напомнит о ней в день срока.';

  @override
  String get tasksEmptyAction => 'Создать задачу';

  @override
  String get tasksNothingMatchesTitle => 'Под фильтры ничего не подошло';

  @override
  String get tasksNothingMatchesBody =>
      'Снимите часть условий, чтобы увидеть больше.';

  @override
  String get tasksComplete => 'Отметить выполненной';

  @override
  String get tasksCompleted => 'Задача выполнена';

  @override
  String get tasksCompleteFailed => 'Не удалось отметить задачу';

  @override
  String get tasksOverdueChip => 'Просроченные';

  @override
  String get tasksTodayChip => 'На сегодня';

  @override
  String get taskTypeFeeding => 'Кормление';

  @override
  String get taskTypeCleaning => 'Уборка';

  @override
  String get taskTypeVaccination => 'Вакцинация';

  @override
  String get taskTypeCheckup => 'Осмотр';

  @override
  String get taskTypeBreeding => 'Разведение';

  @override
  String get taskTypeOther => 'Другое';

  @override
  String get taskStatusPending => 'Ожидает';

  @override
  String get taskStatusInProgress => 'В работе';

  @override
  String get taskStatusCompleted => 'Выполнена';

  @override
  String get taskStatusCancelled => 'Отменена';

  @override
  String get taskPriorityLow => 'Низкий';

  @override
  String get taskPriorityMedium => 'Средний';

  @override
  String get taskPriorityHigh => 'Высокий';

  @override
  String get taskPriorityUrgent => 'Срочный';

  @override
  String dueToday(String time) {
    return 'Сегодня в $time';
  }

  @override
  String dueTomorrow(String time) {
    return 'Завтра в $time';
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
      other: 'Просрочена на $count дня',
      many: 'Просрочена на $count дней',
      few: 'Просрочена на $count дня',
      one: 'Просрочена на $count день',
    );
    return '$_temp0';
  }

  @override
  String get dueTodayPlain => 'Сегодня';

  @override
  String get dueTomorrowPlain => 'Завтра';

  @override
  String get taskFormNewTitle => 'Новая задача';

  @override
  String get taskFormEditTitle => 'Задача';

  @override
  String get taskFormSectionMain => 'Основное';

  @override
  String get taskFormSectionParams => 'Параметры';

  @override
  String get taskFormSectionNotes => 'Заметки';

  @override
  String get taskFormTitleLabel => 'Что нужно сделать';

  @override
  String get taskFormTitleEmpty => 'Опишите задачу одной строкой';

  @override
  String get taskFormDescriptionLabel => 'Подробности';

  @override
  String get taskFormDueLabel => 'Срок';

  @override
  String get taskFormRepeat => 'Повторять';

  @override
  String get taskFormRepeatNever => 'Не повторять';

  @override
  String get taskFormRepeatHelp =>
      'Когда задачу отметят выполненной, следующая создастся сама.';

  @override
  String get taskFormNotesLabel => 'Примечания';

  @override
  String get taskFormCreate => 'Создать';

  @override
  String get taskFormCreated => 'Задача создана';

  @override
  String get taskFormUpdated => 'Задача обновлена';

  @override
  String get taskFormDeleteTitle => 'Удалить задачу?';

  @override
  String get taskFormDeleteBody => 'Восстановить её будет нельзя.';

  @override
  String get taskFormDeleted => 'Задача удалена';

  @override
  String get taskFormDeleteFailed => 'Не удалось удалить задачу';

  @override
  String get repeatDaily => 'Каждый день';

  @override
  String get repeatWeekly => 'Раз в неделю';

  @override
  String get repeatBiweekly => 'Раз в две недели';

  @override
  String get repeatMonthly => 'Раз в месяц';

  @override
  String get repeatQuarterly => 'Раз в квартал';

  @override
  String get repeatYearly => 'Раз в год';

  @override
  String get vaccinationsTitle => 'Вакцинации';

  @override
  String get vaccinationsStats => 'Сводка';

  @override
  String get vaccinationsViewAll => 'Все';

  @override
  String get vaccinationsViewUpcoming => 'Предстоящие';

  @override
  String get vaccinationsViewOverdue => 'Просроченные';

  @override
  String get vaccinationsViewLast30 => 'За 30 дней';

  @override
  String get vaccinationsEmptyTitle => 'Записей о вакцинации нет';

  @override
  String get vaccinationsEmptyBody =>
      'Отметьте прививку — приложение напомнит, когда придёт срок следующей.';

  @override
  String get vaccinationsEmptyAction => 'Записать вакцинацию';

  @override
  String get vaccinationsNoneInView => 'В этой выборке пусто';

  @override
  String get vaccinationsNoneInViewBody =>
      'Выберите другую вкладку или снимите фильтры.';

  @override
  String get vaccinationsFilterType => 'Тип вакцины';

  @override
  String get vaccinationsFilterPeriod => 'Период';

  @override
  String get vaccinationsFrom => 'От';

  @override
  String get vaccinationsTo => 'До';

  @override
  String get vaccinationsResetAll => 'Сбросить всё';

  @override
  String vaccinationsNext(String date) {
    return 'Следующая $date';
  }

  @override
  String get vaccinationsOverdueBadge => 'Просрочено';

  @override
  String vaccinationsInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'через $count дня',
      many: 'через $count дней',
      few: 'через $count дня',
      one: 'через $count день',
    );
    return '$_temp0';
  }

  @override
  String vaccinationsBatch(String number) {
    return 'Партия $number';
  }

  @override
  String get vaccinationsVet => 'Ветеринар';

  @override
  String get vaccinationsDate => 'Дата прививки';

  @override
  String get vaccinationsNextLabel => 'Следующая прививка';

  @override
  String get vaccinationsBatchLabel => 'Номер партии';

  @override
  String get vaccinationsTypeLabel => 'Тип';

  @override
  String get vaccinationsNotesLabel => 'Заметки';

  @override
  String get vaccinationsDeleteTitle => 'Удалить запись?';

  @override
  String get vaccinationsDeleteBody =>
      'Запись о прививке будет удалена без возможности вернуть.';

  @override
  String get vaccinationsDeleted => 'Запись удалена';

  @override
  String get vaccinationsDeleteFailed => 'Не удалось удалить запись';

  @override
  String get vaccinationsStatTotal => 'Всего прививок';

  @override
  String get vaccinationsStatThisYear => 'В этом году';

  @override
  String get vaccinationsStatLast30 => 'За 30 дней';

  @override
  String get vaccinationsStatUpcoming => 'Предстоящие';

  @override
  String get vaccinationsStatNext30 => 'В ближайшие 30 дней';

  @override
  String get vaccinationsStatOverdue => 'Просрочено';

  @override
  String get rabbitPickerTitle => 'Выберите кролика';

  @override
  String get rabbitPickerHint => 'Кличка или номер бирки';

  @override
  String get rabbitPickerEmpty => 'Не выбран';

  @override
  String get rabbitPickerNothingFound => 'Никого не нашлось';

  @override
  String get rabbitPickerNothingFoundBody =>
      'Проверьте кличку или номер бирки.';

  @override
  String get rabbitPickerClear => 'Очистить';

  @override
  String get rabbitPickerRequired => 'Выберите кролика';

  @override
  String rabbitPickerInCage(String number) {
    return 'Клетка $number';
  }

  @override
  String get rabbitPickerNoCage => 'Без клетки';

  @override
  String get vaccFormNewTitle => 'Новая прививка';

  @override
  String get vaccFormEditTitle => 'Прививка';

  @override
  String get vaccFormSectionMain => 'Основное';

  @override
  String get vaccFormSectionDates => 'Даты';

  @override
  String get vaccFormSectionExtra => 'Дополнительно';

  @override
  String get vaccFormRabbit => 'Кому';

  @override
  String get vaccFormType => 'Тип вакцины';

  @override
  String get vaccFormName => 'Название вакцины';

  @override
  String get vaccFormNameHint => 'Например, Раббивак V';

  @override
  String get vaccFormNameEmpty => 'Введите название вакцины';

  @override
  String get vaccFormDate => 'Дата прививки';

  @override
  String get vaccFormNextDate => 'Следующая прививка';

  @override
  String get vaccFormNextNotSet => 'Не запланирована';

  @override
  String get vaccFormPlus3m => 'через 3 месяца';

  @override
  String get vaccFormPlus6m => 'через полгода';

  @override
  String get vaccFormPlus1y => 'через год';

  @override
  String get vaccFormBatch => 'Номер партии';

  @override
  String get vaccFormBatchHint => 'Например, 12345-67';

  @override
  String get vaccFormVet => 'Ветеринар';

  @override
  String get vaccFormVetHint => 'Кто делал прививку';

  @override
  String get vaccFormNotes => 'Заметки';

  @override
  String get vaccFormCreated => 'Прививка записана';

  @override
  String get vaccFormUpdated => 'Запись обновлена';

  @override
  String get vaccFormFailed => 'Не удалось сохранить';

  @override
  String get medTitle => 'Лечение';

  @override
  String get medEmptyTitle => 'Записей о лечении нет';

  @override
  String get medEmptyBody =>
      'Заведите карту болезни — она соберёт симптомы, лечение и затраты в одном месте.';

  @override
  String get medEmptyAction => 'Завести карту';

  @override
  String get medNoneInView => 'В этой выборке пусто';

  @override
  String get medNoneInViewBody =>
      'Выберите другую вкладку или снимите фильтры.';

  @override
  String get medViewAll => 'Все';

  @override
  String get medOutcomeOngoing => 'Лечится';

  @override
  String get medOutcomeRecovered => 'Выздоровел';

  @override
  String get medOutcomeDied => 'Погиб';

  @override
  String get medOutcomeEuthanized => 'Усыплён';

  @override
  String get medDiagnosis => 'Диагноз';

  @override
  String get medSymptoms => 'Симптомы';

  @override
  String get medTreatment => 'Лечение';

  @override
  String get medMedication => 'Препараты';

  @override
  String get medStarted => 'Начало';

  @override
  String get medEnded => 'Окончание';

  @override
  String get medCost => 'Затраты';

  @override
  String get medVet => 'Ветеринар';

  @override
  String get medNotes => 'Заметки';

  @override
  String get medNoDiagnosis => 'Диагноз не поставлен';

  @override
  String get medDeleteTitle => 'Удалить карту?';

  @override
  String get medDeleteBody =>
      'Запись о лечении будет удалена без возможности вернуть.';

  @override
  String get medDeleted => 'Запись удалена';

  @override
  String get medDeleteFailed => 'Не удалось удалить запись';

  @override
  String get medPeriodFrom => 'С даты';

  @override
  String get medPeriodTo => 'По дату';

  @override
  String get medStats => 'Сводка';

  @override
  String get medStatTotal => 'Всего карт';

  @override
  String get medStatThisYear => 'В этом году';

  @override
  String get medStatLastMonth => 'За месяц';

  @override
  String get medStatCost => 'Потрачено';

  @override
  String get medStatOngoing => 'Лечатся сейчас';

  @override
  String medDaysOngoing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      many: '$count дней',
      few: '$count дня',
      one: '$count день',
    );
    return '$_temp0';
  }

  @override
  String get medFormNewTitle => 'Новая карта';

  @override
  String get medFormEditTitle => 'Карта лечения';

  @override
  String get medFormRabbit => 'Кому';

  @override
  String get medFormSectionCase => 'Что случилось';

  @override
  String get medFormSectionTreatment => 'Лечение';

  @override
  String get medFormSectionDates => 'Сроки и деньги';

  @override
  String get medFormSymptomsEmpty => 'Опишите симптомы';

  @override
  String get medFormOutcome => 'Исход';

  @override
  String get medFormCreated => 'Карта заведена';

  @override
  String get medFormUpdated => 'Карта обновлена';

  @override
  String get medFormFailed => 'Не удалось сохранить';

  @override
  String get medFormCostHelp =>
      'Сумма попадёт в расходы фермы отдельной операцией.';

  @override
  String get medFormDosage => 'Дозировка';

  @override
  String get medFormEndedDate => 'Дата окончания';

  @override
  String get medFormNotSet => 'Не указана';

  @override
  String get medFormCostLabel => 'Затраты, ₽';

  @override
  String get commonNumberInvalid => 'Введите число';

  @override
  String get feedsTitle => 'Склад кормов';

  @override
  String get feedsAdd => 'Добавить корм';

  @override
  String get feedsEmptyTitle => 'Склад пуст';

  @override
  String get feedsEmptyBody =>
      'Заведите корм, и приложение предупредит, когда он начнёт заканчиваться.';

  @override
  String get feedsNoneInView => 'Под фильтры ничего не подошло';

  @override
  String get feedsNoneInViewBody =>
      'Снимите условия, чтобы увидеть весь склад.';

  @override
  String get feedsFilterAll => 'Все';

  @override
  String get feedsFilterLowStock => 'На исходе';

  @override
  String get feedsFilterType => 'Тип корма';

  @override
  String get feedsFilterAllTypes => 'Все типы';

  @override
  String get feedsInStock => 'На складе';

  @override
  String get feedsMinStock => 'Минимум';

  @override
  String get feedsLowStockWarning => 'Осталось меньше минимума';

  @override
  String get feedsRefill => 'Пополнить';

  @override
  String get feedsWriteOff => 'Списать';

  @override
  String get feedsRefillTitle => 'Пополнить склад';

  @override
  String get feedsWriteOffTitle => 'Списать со склада';

  @override
  String feedsCurrentStock(String amount) {
    return 'Сейчас на складе: $amount';
  }

  @override
  String get feedsQuantity => 'Сколько';

  @override
  String get feedsQuantityPositive => 'Введите количество больше нуля';

  @override
  String feedsRefilled(String amount) {
    return 'Склад пополнен на $amount';
  }

  @override
  String feedsWrittenOff(String amount) {
    return 'Списано $amount';
  }

  @override
  String get feedsAdjustFailed => 'Не удалось изменить остаток';

  @override
  String get feedsDeleteTitle => 'Удалить корм?';

  @override
  String feedsDeleteBody(String name) {
    return '«$name» исчезнет со склада вместе с историей остатков.';
  }

  @override
  String get feedsDeleted => 'Корм удалён';

  @override
  String get feedsDeleteFailed => 'Не удалось удалить корм';

  @override
  String get feedFormNewTitle => 'Новый корм';

  @override
  String get feedFormEditTitle => 'Корм';

  @override
  String get feedFormSectionMain => 'Основное';

  @override
  String get feedFormSectionStock => 'Склад';

  @override
  String get feedFormName => 'Название';

  @override
  String get feedFormNameEmpty => 'Введите название корма';

  @override
  String get feedFormType => 'Тип корма';

  @override
  String get feedFormUnit => 'В чём считаем';

  @override
  String get feedFormCurrentStock => 'Сейчас на складе';

  @override
  String get feedFormMinStock => 'Предупреждать, когда останется';

  @override
  String get feedFormMinStockHelp =>
      'Ниже этого остатка корм попадёт в «Требует внимания» на главном экране.';

  @override
  String get feedFormCost => 'Цена за единицу';

  @override
  String get feedFormRequired => 'Заполните поле';

  @override
  String get feedFormNegative => 'Число не может быть отрицательным';

  @override
  String get feedFormCreated => 'Корм добавлен на склад';

  @override
  String get feedFormUpdated => 'Корм обновлён';

  @override
  String get feedFormFailed => 'Не удалось сохранить корм';

  @override
  String get feedingTitle => 'Кормления';

  @override
  String get feedingAdd => 'Записать кормление';

  @override
  String get feedingEmptyTitle => 'Записей о кормлении нет';

  @override
  String get feedingEmptyBody =>
      'Отмечайте кормления — расход корма будет списываться со склада сам.';

  @override
  String get feedingNoneInView => 'За этот период записей нет';

  @override
  String get feedingNoneInViewBody =>
      'Выберите другой период или сбросьте фильтр.';

  @override
  String get feedingUnknownFeed => 'Корм не указан';

  @override
  String feedingForRabbit(String name) {
    return 'Кролик $name';
  }

  @override
  String feedingForCage(String number) {
    return 'Клетка $number';
  }

  @override
  String get feedingForFarm => 'Всей ферме';

  @override
  String get feedingEdit => 'Изменить';

  @override
  String get feedingDeleteTitle => 'Удалить запись?';

  @override
  String get feedingDeleteBody =>
      'Запись о кормлении будет удалена. Списанный корм на склад не вернётся.';

  @override
  String get feedingDeleted => 'Запись удалена';

  @override
  String get feedingDeleteFailed => 'Не удалось удалить запись';

  @override
  String get feedingPeriod => 'Период';

  @override
  String get feedingFormNewTitle => 'Новое кормление';

  @override
  String get feedingFormEditTitle => 'Кормление';

  @override
  String get feedingFormSectionWhom => 'Кого кормим';

  @override
  String get feedingFormSectionWhat => 'Чем и сколько';

  @override
  String get feedingFormModeRabbit => 'Одного кролика';

  @override
  String get feedingFormModeCage => 'Всю клетку';

  @override
  String get feedingFormCage => 'Клетка';

  @override
  String get feedingFormCageRequired => 'Выберите клетку';

  @override
  String get feedingFormFeed => 'Корм';

  @override
  String get feedingFormFeedRequired => 'Выберите корм';

  @override
  String get feedingFormQuantity => 'Сколько';

  @override
  String get feedingFormQuantityRequired => 'Введите количество';

  @override
  String get feedingFormWhen => 'Когда';

  @override
  String get feedingFormNotes => 'Примечания';

  @override
  String feedingFormStockLeft(String amount) {
    return 'осталось $amount';
  }

  @override
  String get feedingFormCreated => 'Кормление записано';

  @override
  String get feedingFormUpdated => 'Запись обновлена';

  @override
  String get feedingFormFailed => 'Не удалось сохранить запись';

  @override
  String get feedingFormStockNote => 'Указанное количество спишется со склада.';

  @override
  String get emptyNoRecordsTitle => 'Записей нет';

  @override
  String get emptyNoRecordsBody => 'Добавьте первую.';
}
