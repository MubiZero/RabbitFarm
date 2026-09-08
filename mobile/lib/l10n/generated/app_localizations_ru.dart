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
  String get errorOffline => 'Нет связи — проверьте интернет';

  @override
  String get errorTimeout => 'Сервер не ответил, попробуйте ещё раз';

  @override
  String get errorUnauthorized => 'Нужно войти заново';

  @override
  String get errorForbidden => 'У вашей роли нет доступа к этому';

  @override
  String get errorNotFound => 'Запись не найдена — возможно, её удалили';

  @override
  String get errorInvalid => 'Сервер не принял данные';

  @override
  String get errorServer => 'На сервере сбой, попробуйте позже';

  @override
  String get commonStaleData => 'Не удалось обновить, показаны прежние данные';

  @override
  String get commonRetryShort => 'Ещё раз';

  @override
  String get commonNotSpecified => 'Не указано';

  @override
  String get commonActions => 'Действия';

  @override
  String get commonEmail => 'Почта';

  @override
  String get quickGroupOften => 'Часто';

  @override
  String get journalPeriodToday => 'Сегодня';

  @override
  String get journalPeriodWeek => 'Неделя';

  @override
  String get journalKindAll => 'Все';

  @override
  String get journalKindFeeding => 'Кормление';

  @override
  String get journalKindTreatment => 'Лечение';

  @override
  String get journalKindVaccination => 'Прививка';

  @override
  String get journalKindTask => 'Задача';

  @override
  String get journalKindNote => 'Заметка';

  @override
  String get journalKindPhoto => 'Фото';

  @override
  String get journalEmptyTodayTitle => 'Сегодня ещё ничего не записано';

  @override
  String get journalEmptyWeekTitle => 'За неделю ничего не записано';

  @override
  String get journalEmptyBody =>
      'Кормления, лечение, прививки, закрытые задачи, заметки и фото попадают сюда сами. Запишите первое — и оно появится здесь.';

  @override
  String get journalNoneInViewTitle => 'В этой выборке пусто';

  @override
  String get journalNoneInViewBody => 'Смените вид записи или срок.';

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
  String get loginForgotPassword => 'Забыли пароль?';

  @override
  String get forgotPasswordTitle => 'Забыли пароль?';

  @override
  String get forgotPasswordIntro =>
      'Укажите почту, с которой входите в ферму. Если аккаунт есть, пришлём код — по SMS или на почту.';

  @override
  String get forgotPasswordEmailHint => 'Введите почту';

  @override
  String get forgotPasswordSubmit => 'Отправить код';

  @override
  String get forgotPasswordSentMessage =>
      'Если аккаунт существует, код отправлен';

  @override
  String get forgotPasswordBackToLogin => 'Вспомнили пароль? Войти';

  @override
  String get resetPasswordTitle => 'Введите код';

  @override
  String get resetPasswordCodeHint => '6-значный код из SMS или письма';

  @override
  String get resetPasswordCodeEmpty => 'Введите код';

  @override
  String get resetPasswordCodeInvalid => 'Код — это 6 цифр';

  @override
  String get resetPasswordNewPasswordHint => 'Новый пароль';

  @override
  String get resetPasswordConfirmHint => 'Повторите новый пароль';

  @override
  String get resetPasswordConfirmMismatch => 'Пароли не совпадают';

  @override
  String get resetPasswordSubmit => 'Сменить пароль';

  @override
  String get resetPasswordSuccessMessage =>
      'Пароль изменён. Войдите с новым паролем.';

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
  String get todayStatLivestock => 'Поголовье';

  @override
  String get todayStatTasks => 'Задачи в работе';

  @override
  String get todayStatFreeCages => 'Клеток свободно';

  @override
  String get todayAlertOverdueVaccination => 'Вакцинация просрочена';

  @override
  String get todayAlertLowFeed => 'Заканчивается корм';

  @override
  String get todayAlertUpcomingVaccination => 'Скоро вакцинация';

  @override
  String get todayTourAlertsTitle => 'Что требует внимания';

  @override
  String get todayTourAlertsBody =>
      'Задачи на сегодня, вакцинация и заканчивающийся корм — всё срочное собирается здесь. Выполненную задачу отметьте галочкой, не уходя с экрана.';

  @override
  String get todayTourStatsTitle => 'Состояние фермы';

  @override
  String get todayTourStatsBody =>
      'Поголовье, незакрытые задачи и свободные клетки. Потяните экран вниз, чтобы обновить цифры.';

  @override
  String get menuProfile => 'Профиль';

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
  String get navHerd => 'Стадо';

  @override
  String get navBreeding => 'Разведение';

  @override
  String get navFarm => 'Хозяйство';

  @override
  String get navJournal => 'Журнал';

  @override
  String get navProfile => 'Профиль';

  @override
  String get navRecord => 'Записать';

  @override
  String get quickRecordTreatment => 'Лечение';

  @override
  String get quickRecordBreeding => 'Случка';

  @override
  String get quickAddFeed => 'Приход корма';

  @override
  String get quickRecordTransaction => 'Приход или расход';

  @override
  String get quickGroupDaily => 'Каждый день';

  @override
  String get quickGroupHerd => 'Стадо';

  @override
  String get quickGroupFarm => 'Хозяйство';

  @override
  String get herdTitle => 'Стадо';

  @override
  String get herdTabCages => 'Клетки';

  @override
  String get herdTabRabbits => 'Кролики';

  @override
  String get journalTitle => 'Журнал';

  @override
  String get reportsTitle => 'Отчёты';

  @override
  String get farmTitle => 'Хозяйство';

  @override
  String get navQuickTitle => 'Что записать';

  @override
  String get quickRecordFeeding => 'Записать кормление';

  @override
  String get quickRecordVaccination => 'Записать вакцинацию';

  @override
  String get quickCreateTask => 'Создать задачу';

  @override
  String get quickRecordNote => 'Оставить заметку';

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
  String get cycleTitle => 'Разведение';

  @override
  String get cycleFindPair => 'Подобрать пару';

  @override
  String get cycleRecordBirth => 'Записать окрол';

  @override
  String get cycleStageCheck => 'Проверить сукрольность';

  @override
  String get cycleStageBirth => 'Окрол ожидается';

  @override
  String get cycleStageWeaning => 'Отсадка молодняка';

  @override
  String get cycleStageNotPregnant => 'Самка пустая';

  @override
  String get cycleStageFailed => 'Случка не удалась';

  @override
  String get cycleStageCancelled => 'Случка отменена';

  @override
  String get cycleStageClosed => 'Цикл отработан';

  @override
  String cycleDay(int day) {
    return '$day-й день';
  }

  @override
  String cycleMaleLine(String name) {
    return 'Самец: $name';
  }

  @override
  String cycleActionWhen(String date, String when) {
    return '$date · $when';
  }

  @override
  String cycleApproxDate(String date) {
    return 'примерно $date';
  }

  @override
  String get cycleDueToday => 'сегодня';

  @override
  String get cycleDueTomorrow => 'завтра';

  @override
  String cycleInDays(int count) {
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
  String cycleOverdueDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'просрочено на $count дня',
      many: 'просрочено на $count дней',
      few: 'просрочено на $count дня',
      one: 'просрочено на $count день',
    );
    return '$_temp0';
  }

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
  String get commonNameMissing => 'Имя не указано';

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
  String commonActionFailed(String reason) {
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
  String get cageFormType => 'Тип клетки';

  @override
  String get cycleStageWeaned => 'Молодняк отсажен';

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
  String get todayTasksTitle => 'Задачи на сегодня';

  @override
  String get todayTasksAll => 'Все задачи';

  @override
  String get todayTaskDone => 'Закрыта';

  @override
  String get todayTasksNone => 'На сегодня задач нет';

  @override
  String get commonFilters => 'Фильтры';

  @override
  String get commonApply => 'Применить';

  @override
  String get commonReset => 'Сбросить';

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
  String get noteFormNewTitle => 'Новая заметка';

  @override
  String get noteFormEditTitle => 'Заметка';

  @override
  String get noteFormSectionMain => 'Основное';

  @override
  String get noteFormContentLabel => 'Текст заметки';

  @override
  String get noteFormContentEmpty => 'Введите текст заметки';

  @override
  String get noteFormSectionLink => 'К чему относится';

  @override
  String get noteFormRabbitLabel => 'Кролик (необязательно)';

  @override
  String get noteFormCageLabel => 'Клетка (необязательно)';

  @override
  String get noteFormCageNone => 'Не выбрано';

  @override
  String get noteFormCreate => 'Добавить';

  @override
  String get noteFormCreated => 'Заметка добавлена';

  @override
  String get noteFormUpdated => 'Заметка обновлена';

  @override
  String get noteFormDeleteTitle => 'Удалить заметку?';

  @override
  String get noteFormDeleteBody => 'Восстановить её будет нельзя.';

  @override
  String get noteFormDeleted => 'Заметка удалена';

  @override
  String get noteFormDeleteFailed => 'Не удалось удалить заметку';

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
  String get fieldRecipient => 'Кому';

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
  String get commonSummary => 'Сводка';

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
  String medFormCostLabel(String currency) {
    return 'Затраты, $currency';
  }

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
  String get feedingBulkModeRabbits => 'Кролики';

  @override
  String get feedingBulkModeCages => 'Клетки';

  @override
  String get feedingBulkAddRabbit => 'Добавить кролика';

  @override
  String get feedingBulkRabbitsRequired => 'Выберите хотя бы одного кролика';

  @override
  String get feedingBulkRemove => 'Убрать из списка';

  @override
  String get feedingBulkCagesField => 'Какие клетки';

  @override
  String get feedingBulkCagesRequired => 'Выберите хотя бы одну клетку';

  @override
  String get feedingBulkCagesPickTitle => 'Какие клетки кормим';

  @override
  String feedingBulkCagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count клетки',
      many: '$count клеток',
      few: '$count клетки',
      one: '$count клетка',
    );
    return '$_temp0';
  }

  @override
  String get feedingBulkWholeFarm => 'Вся ферма';

  @override
  String get feedingBulkClearSelection => 'Снять выбор';

  @override
  String get feedingBulkRowUnnamed => 'Без ряда';

  @override
  String get feedingBulkDone => 'Готово';

  @override
  String get feedingBulkNoCagesTitle => 'Клеток пока нет';

  @override
  String get feedingBulkNoCagesBody =>
      'Заведите клетки — тогда кормление можно будет записать сразу на ряд или на всю ферму.';

  @override
  String get feedingBulkQuantityEach => 'Сколько на каждого';

  @override
  String get feedingBulkQuantityEachHint => 'Число — на одного получателя.';

  @override
  String feedingBulkQuantityEachNote(String amount) {
    return 'Число — на одного получателя. Всего спишется $amount.';
  }

  @override
  String feedingBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Записано $count кормления',
      many: 'Записано $count кормлений',
      few: 'Записано $count кормления',
      one: 'Записано $count кормление',
    );
    return '$_temp0';
  }

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
  String get commonSectionMain => 'Основное';

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
  String get commonPeriod => 'Период';

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
  String get feedingFormUpdated => 'Запись обновлена';

  @override
  String get feedingFormFailed => 'Не удалось сохранить запись';

  @override
  String get feedingFormStockNote => 'Указанное количество спишется со склада.';

  @override
  String get financeTitle => 'Финансы';

  @override
  String get financeAdd => 'Добавить операцию';

  @override
  String get financeEmptyTitle => 'Операций пока нет';

  @override
  String get financeEmptyBody =>
      'Записывайте доходы и расходы — приложение само посчитает прибыль фермы.';

  @override
  String get financeNoneInView => 'Под фильтры ничего не подошло';

  @override
  String get financeNoneInViewBody =>
      'Снимите условия, чтобы увидеть всю ведомость.';

  @override
  String get financeIncome => 'Доходы';

  @override
  String get financeExpenses => 'Расходы';

  @override
  String get financeBalance => 'Баланс';

  @override
  String get financeSummaryPeriod => 'За весь период';

  @override
  String get financeSummaryFiltered => 'За выбранный период';

  @override
  String get financeAll => 'Все';

  @override
  String get financeOnlyIncome => 'Доходы';

  @override
  String get financeOnlyExpenses => 'Расходы';

  @override
  String get financeCategory => 'Категория';

  @override
  String get financeType => 'Тип';

  @override
  String get financeDate => 'Дата';

  @override
  String get financeDescription => 'Описание';

  @override
  String get financeTypeIncome => 'Доход';

  @override
  String get financeTypeExpense => 'Расход';

  @override
  String get financeDeleteTitle => 'Удалить операцию?';

  @override
  String get financeDeleteBody =>
      'Операция исчезнет из ведомости без возможности вернуть.';

  @override
  String get financeDeleted => 'Операция удалена';

  @override
  String get financeDeleteFailed => 'Не удалось удалить операцию';

  @override
  String get txFormNewTitle => 'Новая операция';

  @override
  String get txFormEditTitle => 'Операция';

  @override
  String get txFormSectionKind => 'Что за операция';

  @override
  String get commonSectionDetails => 'Подробности';

  @override
  String get txFormIncomeSubtitle => 'Продажа, услуги';

  @override
  String get txFormExpenseSubtitle => 'Покупки, лечение, корма';

  @override
  String get txFormAmount => 'Сумма';

  @override
  String get txFormAmountEmpty => 'Введите сумму';

  @override
  String get txFormAmountPositive => 'Сумма должна быть больше нуля';

  @override
  String get txFormDate => 'Когда';

  @override
  String get txFormRabbit => 'Связать с кроликом';

  @override
  String get txFormRabbitHelp =>
      'Необязательно. Нужно, чтобы видеть доход и расходы по конкретному животному.';

  @override
  String get txFormDescription => 'Описание';

  @override
  String get txFormCreated => 'Операция записана';

  @override
  String get txFormUpdated => 'Операция обновлена';

  @override
  String get txFormFailed => 'Не удалось сохранить операцию';

  @override
  String get cagesTitle => 'Клетки';

  @override
  String get cagesAdd => 'Добавить клетку';

  @override
  String get cagesSearchHint => 'Номер или место';

  @override
  String get cagesOnlyAvailable => 'Только свободные';

  @override
  String get cagesEmptyTitle => 'Клеток пока нет';

  @override
  String get cagesEmptyBody =>
      'Заведите клетки — по ним будет видно, куда селить кроликов и где есть место.';

  @override
  String get cagesNothingFound => 'Ничего не нашлось';

  @override
  String get cagesNothingFoundBody => 'Проверьте запрос или снимите фильтры.';

  @override
  String cagesOccupancy(int occupied, int capacity) {
    return 'Занято $occupied из $capacity';
  }

  @override
  String cagesLastCleaned(String date) {
    return 'Убрана $date';
  }

  @override
  String get cagesMarkCleaned => 'Отметить уборку';

  @override
  String get cagesCleaned => 'Уборка отмечена';

  @override
  String get cagesCleanFailed => 'Не удалось отметить уборку';

  @override
  String get cagesDeleteTitle => 'Удалить клетку?';

  @override
  String cagesDeleteBody(String number) {
    return 'Клетка $number исчезнет из списка. Кролики из неё останутся без клетки.';
  }

  @override
  String get cagesDeleted => 'Клетка удалена';

  @override
  String get cagesDeleteFailed => 'Не удалось удалить клетку';

  @override
  String get cagesFilterCondition => 'Состояние';

  @override
  String get cageFormNewTitle => 'Новая клетка';

  @override
  String get cageFormEditTitle => 'Клетка';

  @override
  String get cageFormNumber => 'Номер';

  @override
  String get cageFormNumberEmpty => 'Введите номер клетки';

  @override
  String get cageFormCapacity => 'Сколько кроликов помещается';

  @override
  String get cageFormCapacityInvalid => 'Введите число больше нуля';

  @override
  String get cageFormCapacityGroup => 'В групповой клетке минимум два места';

  @override
  String get cageFormSize => 'Размер';

  @override
  String get cageFormSizeHint => 'Например, 100×60×45 см';

  @override
  String get cageFormLocation => 'Место';

  @override
  String get cageFormLocationHint => 'Например, сарай, левый ряд';

  @override
  String get cageFormNotes => 'Заметки';

  @override
  String get cageFormCreated => 'Клетка добавлена';

  @override
  String get cageFormUpdated => 'Клетка обновлена';

  @override
  String get cageFormFailed => 'Не удалось сохранить клетку';

  @override
  String get rabbitsTitle => 'Кролики';

  @override
  String get rabbitsSearchHint => 'Кличка или номер бирки';

  @override
  String get herdCagesNoPlace => 'Место не указано';

  @override
  String get rabbitsEmptyTitle => 'Кроликов пока нет';

  @override
  String get rabbitsEmptyBody =>
      'Заведите первого кролика — от него пойдёт весь учёт: родословная, здоровье и приплод.';

  @override
  String get rabbitsEmptyAction => 'Добавить кролика';

  @override
  String get rabbitsNothingFound => 'Никого не нашлось';

  @override
  String get rabbitsNothingFoundBody => 'Проверьте запрос или снимите фильтры.';

  @override
  String get rabbitsFilterAll => 'Все';

  @override
  String get rabbitsFilterMales => 'Самцы';

  @override
  String get rabbitsFilterFemales => 'Самки';

  @override
  String get rabbitsFilterActive => 'В работе';

  @override
  String get rabbitsFilterSold => 'Проданы';

  @override
  String get sexMale => 'Самец';

  @override
  String get sexFemale => 'Самка';

  @override
  String get sexUnknown => 'Пол не указан';

  @override
  String get rabbitNoTag => 'Без бирки';

  @override
  String get weightTitle => 'Взвешивания';

  @override
  String weightSubtitle(String name) {
    return '$name';
  }

  @override
  String get weightEmptyTitle => 'Взвешиваний пока нет';

  @override
  String get weightEmptyBody =>
      'Записывайте вес — по нему видно, растёт кролик или что-то не так.';

  @override
  String get weightAdd => 'Записать вес';

  @override
  String get weightSummary => 'Сводка';

  @override
  String get weightCurrent => 'Сейчас';

  @override
  String get weightTrend => 'С прошлого раза';

  @override
  String get weightTotalChange => 'За всё время';

  @override
  String get weightHistory => 'История';

  @override
  String get weightValue => 'Вес, кг';

  @override
  String get weightValueHint => 'Например, 3,5';

  @override
  String get weightValueEmpty => 'Введите вес';

  @override
  String get weightValuePositive => 'Вес должен быть больше нуля';

  @override
  String get weightWhen => 'Когда взвесили';

  @override
  String get weightNotes => 'Заметки';

  @override
  String get weightSaved => 'Вес записан';

  @override
  String get weightSaveFailed => 'Не удалось записать вес';

  @override
  String get galleryTitle => 'Галерея фото';

  @override
  String get galleryEmptyTitle => 'Снимков пока нет';

  @override
  String get galleryEmptyBody =>
      'Добавьте фото — на карточке останется одно, а здесь поместятся все.';

  @override
  String get galleryAdd => 'Добавить фото';

  @override
  String get galleryUploaded => 'Фото добавлено';

  @override
  String get galleryCaptionTitle => 'Подпись к фото';

  @override
  String get galleryCaptionLabel => 'Например, «После стрижки»';

  @override
  String get galleryCaptionSkip => 'Без подписи';

  @override
  String get galleryDeleteTitle => 'Удалить фото?';

  @override
  String get galleryDeleteBody => 'Восстановить его будет нельзя.';

  @override
  String get galleryDeleted => 'Фото удалено';

  @override
  String get pedigreeTitle => 'Родословная';

  @override
  String get rabbitDetailEdit => 'Изменить';

  @override
  String get rabbitDetailDeleteTitle => 'Удалить кролика?';

  @override
  String rabbitDetailDeleteBody(String name) {
    return 'Вместе с $name исчезнут его взвешивания, прививки и записи о лечении.';
  }

  @override
  String get rabbitDetailDeleted => 'Кролик удалён';

  @override
  String get rabbitDetailDeleteFailed => 'Не удалось удалить кролика';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get healthTitle => 'Здоровье';

  @override
  String get healthMenuLabel => 'Прививки и лечение';

  @override
  String get healthKindAll => 'Всё';

  @override
  String get healthKindVaccination => 'Прививки';

  @override
  String get healthKindTreatment => 'Лечение';

  @override
  String get healthEntryVaccination => 'Прививка';

  @override
  String get healthEntryTreatment => 'Лечение';

  @override
  String get healthPickRabbit => 'История одного кролика';

  @override
  String get healthEmptyTitle => 'Здоровье стада ещё не записано';

  @override
  String get healthEmptyBody =>
      'Отмечайте прививки и лечение — и будет видно, что было с каждым кроликом и когда прививать снова.';

  @override
  String get healthNoneInViewTitle => 'В этой выборке пусто';

  @override
  String healthNoneForRabbitTitle(String name) {
    return 'У $name записей о здоровье нет';
  }

  @override
  String get healthNoneInViewBody =>
      'Снимите фильтр — остальные записи никуда не делись.';

  @override
  String get healthRecordTitle => 'Что записать?';

  @override
  String get healthRecordVaccination => 'Прививку';

  @override
  String get healthRecordTreatment => 'Лечение';

  @override
  String get farmSectionMoney => 'Деньги';

  @override
  String get farmTransactions => 'Доходы и расходы';

  @override
  String get farmSectionFeed => 'Корма';

  @override
  String get farmFeedStock => 'Запас корма';

  @override
  String get farmFeedingRecords => 'Кормления';

  @override
  String get farmSectionHealth => 'Здоровье';

  @override
  String get farmSectionReports => 'Отчёты';

  @override
  String get farmReports => 'Сводка по ферме';

  @override
  String get farmSectionPeople => 'Люди';

  @override
  String get farmStaff => 'Сотрудники';

  @override
  String get farmSectionApp => 'Приложение';

  @override
  String get farmSettings => 'Настройки';

  @override
  String get farmAbout => 'О приложении';

  @override
  String get farmAboutBody =>
      'Учёт поголовья, кормов, здоровья и денег кроличьей фермы.';

  @override
  String get farmLogout => 'Выйти';

  @override
  String get settingsAppearance => 'Внешний вид';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsAccent => 'Цвет акцента';

  @override
  String get settingsAbout => 'О приложении';

  @override
  String get settingsVersion => 'Версия';

  @override
  String get settingsLogout => 'Выйти из аккаунта';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeSystem => 'Как в системе';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get joinTitle => 'Присоединиться к ферме';

  @override
  String get joinIntro =>
      'Код выдаёт владелец фермы. После входа вы увидите её хозяйство — поголовье, корма и задачи.';

  @override
  String get joinCode => 'Код приглашения';

  @override
  String get joinCodeHint => 'Введите код, который передал владелец';

  @override
  String get joinName => 'Ваше имя';

  @override
  String get joinNameHint => 'Как к вам обращаться?';

  @override
  String get joinPassword => 'Пароль';

  @override
  String get joinPasswordHint => 'Не короче 8 символов';

  @override
  String get joinPasswordShort => 'Пароль должен быть не короче 8 символов';

  @override
  String get joinSubmit => 'Присоединиться';

  @override
  String get joinHaveAccount => 'У меня уже есть аккаунт';

  @override
  String get onboardWelcomeTitle => 'Ферма под рукой';

  @override
  String get onboardWelcomeBody =>
      'Кролики, кормление, здоровье и деньги — в одном месте';

  @override
  String get onboardStart => 'Начать';

  @override
  String get onboardHaveAccount => 'Уже есть аккаунт? Войти';

  @override
  String get onboardFarmNameTitle => 'Как называется ваша ферма?';

  @override
  String get onboardFarmNameHint => 'Например, Ферма «Берёзки»';

  @override
  String get onboardNext => 'Далее';

  @override
  String get onboardSkip => 'Пропустить';

  @override
  String get onboardFarmTypeTitle => 'Кто ведёт хозяйство?';

  @override
  String get onboardSoloTitle => 'Только я';

  @override
  String get onboardSoloBody => 'Веду ферму сам';

  @override
  String get onboardTeamTitle => 'Я и работники';

  @override
  String get onboardTeamBody => 'У каждого своя роль и свой доступ';

  @override
  String onboardReadyNamed(String name) {
    return '«$name»\nготова к работе!';
  }

  @override
  String get onboardReadyPlain => 'Ферма готова к работе!';

  @override
  String get onboardReadyBody =>
      'Остальное настроим по ходу — приложение подскажет, что делать дальше';

  @override
  String get onboardRegister => 'Зарегистрироваться';

  @override
  String get splashTagline => 'Управление фермой';

  @override
  String get registerTitle => 'Своя ферма';

  @override
  String get registerSubtitle =>
      'Заведите ферму — доступ работникам выдадите потом';

  @override
  String get registerFarmName => 'Название фермы';

  @override
  String get registerFarmNameHint =>
      'Можно оставить пустым — назовём по вашему имени. Потом название не поменять';

  @override
  String get registerFarmNameShort => 'Слишком коротко';

  @override
  String get registerFullName => 'Имя и фамилия';

  @override
  String get registerFullNameHint => 'Как вас зовут';

  @override
  String get registerFullNameEmpty => 'Введите имя';

  @override
  String get registerFullNameShort => 'Слишком коротко';

  @override
  String get registerEmailEmpty => 'Введите почту';

  @override
  String get registerEmailInvalid => 'Похоже, в адресе опечатка';

  @override
  String get registerPhone => 'Телефон, если нужен';

  @override
  String get registerPasswordHint => 'Не короче 8 символов';

  @override
  String get registerPasswordEmpty => 'Придумайте пароль';

  @override
  String get registerPasswordShort => 'Пароль должен быть не короче 8 символов';

  @override
  String get registerPasswordRepeat => 'Повторите пароль';

  @override
  String get registerPasswordRepeatEmpty => 'Введите пароль ещё раз';

  @override
  String get registerPasswordMismatch => 'Пароли не совпадают';

  @override
  String get registerSubmit => 'Завести ферму';

  @override
  String get registerHaveAccount => 'Уже есть аккаунт?';

  @override
  String get registerFailed => 'Не удалось зарегистрироваться';

  @override
  String get birthsTitle => 'Окролы';

  @override
  String get birthsEmptyTitle => 'Окролов пока нет';

  @override
  String get birthsEmptyBody =>
      'Запишите окрол — приложение само заведёт карточки на крольчат.';

  @override
  String get birthsAdd => 'Записать окрол';

  @override
  String get birthsMotherUnknown => 'Мать не указана';

  @override
  String birthsMotherLine(String name) {
    return 'Мать: $name';
  }

  @override
  String get birthsFromBreeding => 'По записи о случке';

  @override
  String get birthsAlive => 'Живых';

  @override
  String get birthsDead => 'Мёртвых';

  @override
  String get birthsWeaned => 'Отсажено';

  @override
  String get birthsSurvival => 'Выживаемость';

  @override
  String get birthsComplications => 'Осложнения';

  @override
  String get birthsDeleteTitle => 'Удалить запись об окроле?';

  @override
  String get birthsDeleteBody =>
      'Карточки крольчат останутся — исчезнет только запись о самом окроле.';

  @override
  String get birthsDeleted => 'Запись удалена';

  @override
  String get birthsDeleteFailed => 'Не удалось удалить запись';

  @override
  String get birthsCreateKits => 'Завести крольчат';

  @override
  String get birthsKitsDialogTitle => 'Завести карточки крольчат?';

  @override
  String birthsKitsDialogBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Будет заведено $count карточки',
      many: 'Будет заведено $count карточек',
      few: 'Будет заведено $count карточки',
      one: 'Будет заведена $count карточка',
    );
    return '$_temp0';
  }

  @override
  String get birthsNamePrefix => 'Начало клички';

  @override
  String get birthsNamePrefixHint => 'Например, Белка-';

  @override
  String birthsNamePreview(String first, String second) {
    return 'Получится: $first, $second, …';
  }

  @override
  String birthsKitsCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Заведено $count карточки',
      many: 'Заведено $count карточек',
      few: 'Заведено $count карточки',
      one: 'Заведена $count карточка',
    );
    return '$_temp0';
  }

  @override
  String get birthsKitsFailed => 'Не удалось завести карточки';

  @override
  String get birthFormNewTitle => 'Новый окрол';

  @override
  String get birthFormEditTitle => 'Окрол';

  @override
  String get birthFormMother => 'Мать';

  @override
  String get birthFormDate => 'Когда окотилась';

  @override
  String get birthFormSectionLitter => 'Помёт';

  @override
  String get birthFormAliveLabel => 'Родилось живыми';

  @override
  String get birthFormDeadLabel => 'Родилось мёртвыми';

  @override
  String get birthFormAliveEmpty => 'Введите количество';

  @override
  String get birthFormComplications => 'Осложнения';

  @override
  String get birthFormComplicationsHint => 'Опишите, если что-то пошло не так';

  @override
  String get birthFormNotes => 'Заметки';

  @override
  String get birthFormAutoKits => 'Сразу завести карточки крольчат';

  @override
  String get birthFormCreated => 'Окрол записан';

  @override
  String get birthFormUpdated => 'Запись обновлена';

  @override
  String get birthFormFailed => 'Не удалось сохранить запись';

  @override
  String get breedsTitle => 'Породы';

  @override
  String get breedsSearchHint => 'Название породы';

  @override
  String get breedsAdd => 'Добавить породу';

  @override
  String get breedsEmptyTitle => 'Пород пока нет';

  @override
  String get breedsEmptyBody =>
      'Заведите породы — по ним удобно подбирать пары и сравнивать привесы.';

  @override
  String get breedsNothingFound => 'Ничего не нашлось';

  @override
  String get breedsNothingFoundBody => 'Проверьте запрос.';

  @override
  String get breedsDeleteTitle => 'Удалить породу?';

  @override
  String breedsDeleteBody(String name) {
    return '«$name» исчезнет из справочника. Кролики этой породы останутся, но без неё.';
  }

  @override
  String get breedsDeleted => 'Порода удалена';

  @override
  String get breedsDeleteFailed => 'Не удалось удалить породу';

  @override
  String get breedPurposeMeat => 'Мясная';

  @override
  String get breedPurposeFur => 'Пуховая';

  @override
  String get breedPurposeDecorative => 'Декоративная';

  @override
  String get breedPurposeCombined => 'Мясо-шкурковая';

  @override
  String get breedFormNewTitle => 'Новая порода';

  @override
  String get breedFormEditTitle => 'Порода';

  @override
  String get breedFormName => 'Название';

  @override
  String get breedFormNameHint => 'Например, Калифорнийский';

  @override
  String get breedFormNameEmpty => 'Введите название породы';

  @override
  String get breedFormPurpose => 'Для чего разводят';

  @override
  String get breedFormDescription => 'Описание';

  @override
  String get breedFormDescriptionHint => 'Чем эта порода отличается';

  @override
  String get breedFormSectionTraits => 'Характеристики';

  @override
  String get breedFormWeight => 'Средний вес, кг';

  @override
  String get breedFormWeightHint => 'Например, 4,5';

  @override
  String get breedFormLitter => 'Обычный размер помёта';

  @override
  String get breedFormLitterHint => 'Например, 8';

  @override
  String get breedFormLitterSuffix => 'крольчат';

  @override
  String get breedFormCreated => 'Порода добавлена';

  @override
  String get breedFormUpdated => 'Порода обновлена';

  @override
  String get breedFormFailed => 'Не удалось сохранить породу';

  @override
  String get breedingDetailTitle => 'Случка';

  @override
  String get breedingStatus => 'Статус';

  @override
  String get breedingParents => 'Пара';

  @override
  String breedingTag(String tag) {
    return 'Бирка $tag';
  }

  @override
  String get breedingDates => 'Даты';

  @override
  String get breedingDate => 'Дата случки';

  @override
  String get breedingExpected => 'Ожидаемый окрол';

  @override
  String get breedingPalpation => 'Дата прощупывания';

  @override
  String get breedingPregnancy => 'Беременность';

  @override
  String get breedingPregnancyYes => 'Подтверждена';

  @override
  String get breedingPregnancyNo => 'Не подтверждена';

  @override
  String get breedingNotes => 'Заметки';

  @override
  String get breedingRegisterBirth => 'Записать окрол';

  @override
  String get breedingDeleteTitle => 'Удалить запись о случке?';

  @override
  String get breedingDeleteBody => 'Вернуть её будет нельзя.';

  @override
  String get breedingDeleted => 'Запись удалена';

  @override
  String get breedingDeleteFailed => 'Не удалось удалить запись';

  @override
  String get breedingFormNewTitle => 'Новая случка';

  @override
  String get breedingFormEditTitle => 'Случка';

  @override
  String get breedingFormPrefilled => 'Пара подставлена из подбора пар';

  @override
  String get breedingFormMale => 'Самец';

  @override
  String get breedingFormFemale => 'Самка';

  @override
  String get breedingFormMaleRequired => 'Выберите самца';

  @override
  String get breedingFormFemaleRequired => 'Выберите самку';

  @override
  String get breedingFormNotesHint => 'Что стоит запомнить об этой случке';

  @override
  String get breedingFormCreated => 'Случка записана';

  @override
  String get breedingFormUpdated => 'Запись обновлена';

  @override
  String get breedingFormFailed => 'Не удалось сохранить запись';

  @override
  String get plannerTitle => 'Подбор пар';

  @override
  String get plannerIntro =>
      'Выберите самца и самку — приложение посмотрит родословную и скажет, насколько они в родстве.';

  @override
  String get plannerAnalysisFailed => 'Не удалось разобрать родословную';

  @override
  String get plannerResults => 'Что получилось';

  @override
  String get plannerCoefficient => 'Степень родства';

  @override
  String get plannerCommonAncestors => 'Общие предки';

  @override
  String plannerGenerations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count поколения',
      many: '$count поколений',
      few: '$count поколения',
      one: '$count поколение',
    );
    return '$_temp0 назад';
  }

  @override
  String get plannerAdvice => 'Что делать';

  @override
  String get plannerPickBoth => 'Выберите обоих';

  @override
  String get plannerPlanned => 'Случка запланирована';

  @override
  String get plannerPlan => 'Запланировать случку';

  @override
  String get plannerPedigreeFailed => 'Не удалось загрузить родословную';

  @override
  String get staffTitle => 'Работники';

  @override
  String get staffInvite => 'Пригласить';

  @override
  String get staffOwner => 'Владелец';

  @override
  String get staffMembers => 'Сотрудники';

  @override
  String get staffEmptyBody =>
      'На ферме пока только вы. Пригласите помощника — он получит доступ к этому же хозяйству.';

  @override
  String get staffInvitesFailed => 'Не удалось загрузить приглашения';

  @override
  String get staffPendingInvites => 'Ждут ответа';

  @override
  String staffAccessClosed(String name) {
    return 'Доступ для $name закрыт';
  }

  @override
  String get staffSaved => 'Изменения сохранены';

  @override
  String get staffResetPasswordTitle => 'Сбросить пароль?';

  @override
  String get staffResetPasswordBody =>
      'Прежний пароль перестанет работать. Взамен приложение выдаст временный — его нужно передать человеку.';

  @override
  String get staffReset => 'Сбросить';

  @override
  String get staffTempPassword => 'Временный пароль';

  @override
  String staffTempPasswordBody(String name) {
    return 'Передайте пароль $name. Второй раз он не покажется — при необходимости сбросьте ещё раз.';
  }

  @override
  String get staffRevokeTitle => 'Отозвать приглашение?';

  @override
  String staffRevokeBody(String email) {
    return 'Код для $email перестанет работать. Выписать новый можно в любой момент.';
  }

  @override
  String get staffKeep => 'Оставить';

  @override
  String get staffRevoke => 'Отозвать';

  @override
  String get staffRevoked => 'Приглашение отозвано';

  @override
  String get staffInviteTitle => 'Пригласить на ферму';

  @override
  String get staffInviteEmailHint => 'На эту почту человек и будет входить';

  @override
  String get staffRole => 'Роль';

  @override
  String get staffIssueCode => 'Выписать код';

  @override
  String get staffInviteCode => 'Код приглашения';

  @override
  String staffInviteCodeBody(String email) {
    return 'Передайте этот код $email любым удобным способом. Второй раз он не покажется: сервер хранит только его отпечаток.';
  }

  @override
  String staffValidUntil(String date) {
    return 'Действует до $date';
  }

  @override
  String get staffCopied => 'Скопировано';

  @override
  String get staffCopy => 'Скопировать';

  @override
  String get staffMakeManager => 'Сделать управляющим';

  @override
  String get staffMakeWorker => 'Сделать работником';

  @override
  String get staffResetPassword => 'Сбросить пароль';

  @override
  String get staffOpenAccess => 'Открыть доступ';

  @override
  String get staffCloseAccess => 'Закрыть доступ';

  @override
  String get staffTransferOwnership => 'Передать хозяйство';

  @override
  String get staffTransferTitle => 'Передать хозяйство?';

  @override
  String staffTransferBody(String name) {
    return 'Ферма перейдёт $name, а вы станете управляющим. Отменить это будет нельзя.';
  }

  @override
  String get staffTransferConfirm => 'Передать ферму';

  @override
  String staffTransferred(String name) {
    return 'Хозяйство передано $name';
  }

  @override
  String get rabbitTapToZoom => 'Нажмите, чтобы рассмотреть';

  @override
  String rabbitTagLine(String tag) {
    return 'Бирка $tag';
  }

  @override
  String get rabbitMainInfo => 'Главное';

  @override
  String get rabbitBreed => 'Порода';

  @override
  String get rabbitBreedUnknown => 'Не указана';

  @override
  String get rabbitSex => 'Пол';

  @override
  String get rabbitAge => 'Возраст';

  @override
  String get rabbitBirthDate => 'Дата рождения';

  @override
  String get rabbitColor => 'Окрас';

  @override
  String get rabbitWeight => 'Вес';

  @override
  String get rabbitQuickActions => 'Что можно посмотреть';

  @override
  String get rabbitWeightHistory => 'История взвешиваний';

  @override
  String get rabbitPedigree => 'Родословная';

  @override
  String get rabbitStatus => 'Статус';

  @override
  String get rabbitCondition => 'Состояние';

  @override
  String get rabbitPurpose => 'Назначение';

  @override
  String get rabbitPlacement => 'Где живёт';

  @override
  String get rabbitCage => 'Клетка';

  @override
  String get rabbitLocation => 'Место';

  @override
  String get rabbitParents => 'Родители';

  @override
  String get rabbitFather => 'Отец';

  @override
  String get rabbitMother => 'Мать';

  @override
  String get rabbitNotes => 'Заметки';

  @override
  String get rabbitDates => 'Записи';

  @override
  String get rabbitCreatedAt => 'Заведён';

  @override
  String get rabbitUpdatedAt => 'Изменён';

  @override
  String get purposeBreeding => 'На развод';

  @override
  String get purposeMeat => 'На мясо';

  @override
  String get purposeFur => 'На мех';

  @override
  String get purposeSale => 'На продажу';

  @override
  String get purposePet => 'Питомец';

  @override
  String get rabbitFormNewTitle => 'Новый кролик';

  @override
  String get rabbitFormEditTitle => 'Кролик';

  @override
  String get rabbitFormPhotoAdd => 'Добавить фото';

  @override
  String get rabbitFormPhotoChange => 'Изменить фото';

  @override
  String get rabbitFormPhotoGallery => 'Выбрать из галереи';

  @override
  String get rabbitFormPhotoCamera => 'Снять на камеру';

  @override
  String get rabbitFormPhotoRemove => 'Убрать фото';

  @override
  String get rabbitFormPhotoFailed => 'Не удалось взять фото';

  @override
  String get rabbitFormName => 'Кличка';

  @override
  String get rabbitFormNameHint => 'Как зовут';

  @override
  String get rabbitFormNameEmpty => 'Введите кличку';

  @override
  String get rabbitFormTag => 'Номер бирки';

  @override
  String get rabbitFormTagEmpty => 'Введите номер бирки';

  @override
  String get rabbitFormBreedRequired => 'Выберите породу';

  @override
  String get rabbitFormBreedsFailed => 'Не удалось загрузить породы';

  @override
  String get rabbitFormColor => 'Окрас';

  @override
  String get rabbitFormColorHint => 'Серый, белый, чёрный…';

  @override
  String get rabbitFormWeight => 'Вес, кг';

  @override
  String get rabbitFormNotes => 'Заметки';

  @override
  String get rabbitFormNotesHint => 'Что стоит помнить об этом кролике';

  @override
  String get rabbitFormCreated => 'Кролик добавлен';

  @override
  String get rabbitFormUpdated => 'Данные обновлены';

  @override
  String get rabbitFormFailed => 'Не удалось сохранить';

  @override
  String get rabbitFormLoadFailed => 'Не удалось загрузить кролика';

  @override
  String get statusHealthy => 'Здоров';

  @override
  String get statusSick => 'Болен';

  @override
  String get statusQuarantine => 'Карантин';

  @override
  String get statusPregnant => 'Беременна';

  @override
  String get statusSold => 'Продан';

  @override
  String get statusDead => 'Погиб';

  @override
  String get purposeShow => 'На выставку';

  @override
  String get tourSkip => 'Пропустить';

  @override
  String get tourNext => 'Дальше';

  @override
  String get tourDone => 'Понятно';

  @override
  String periodDays(int count) {
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
  String periodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count месяца',
      many: '$count месяцев',
      few: '$count месяца',
      one: '$count месяц',
    );
    return '$_temp0';
  }

  @override
  String get periodYear => 'Год';

  @override
  String get periodAll => 'Всё время';

  @override
  String get statusInactive => 'Неактивен';

  @override
  String get pedigreeSelf => 'Кролик';

  @override
  String get pedigreeGrandparents => 'Бабушки и дедушки';

  @override
  String get pedigreeFathersParents => 'Родители отца';

  @override
  String get pedigreeMothersParents => 'Родители матери';

  @override
  String get pedigreeHint => 'Нажмите на карточку, чтобы открыть кролика';

  @override
  String get pedigreeGrandfather => 'Дедушка';

  @override
  String get pedigreeGrandmother => 'Бабушка';

  @override
  String get chartNoData => 'Пока нечего показать';

  @override
  String get chartWeight => 'График веса';

  @override
  String get feedStatsTitle => 'Склад в цифрах';

  @override
  String get feedStatsEmptyTitle => 'Склад пока пуст';

  @override
  String get feedStatsEmptyBody =>
      'Заведите корма — здесь появится состав запаса, его стоимость и предупреждения об остатках.';

  @override
  String get feedStatsPositions => 'Видов корма';

  @override
  String get feedStatsLow => 'На исходе';

  @override
  String get feedStatsValue => 'Стоимость запаса';

  @override
  String get feedStatsByType => 'Состав по типам';

  @override
  String get feedStatsLowList => 'Остатки на исходе';

  @override
  String get feedStatsAllGood => 'Запасов хватает по всем позициям';

  @override
  String feedStatsMinimum(String amount) {
    return 'минимум $amount';
  }

  @override
  String get feedingStatsTitle => 'Кормления в цифрах';

  @override
  String get feedingStatsEmptyTitle => 'За этот период кормлений не было';

  @override
  String get feedingStatsEmptyBody =>
      'Выберите период шире или запишите кормление — расход корма и затраты посчитаются сами.';

  @override
  String get feedingStatsCount => 'Кормлений';

  @override
  String get feedingStatsCost => 'Затраты на корм';

  @override
  String get feedingStatsGiven => 'Выдано';

  @override
  String get feedingStatsByFeed => 'По кормам';

  @override
  String feedingStatsChartTitle(String unit) {
    return 'Расход по типам корма, $unit';
  }

  @override
  String get feedingStatsChartTitlePlain => 'Расход по типам корма';

  @override
  String get financeStatsTitle => 'Финансы в цифрах';

  @override
  String get financeStatsEmptyTitle => 'За этот период операций не было';

  @override
  String get financeStatsEmptyBody =>
      'Выберите период шире или запишите первую операцию — итоги посчитаются сами.';

  @override
  String get financeProfit => 'Прибыль';

  @override
  String get financeLoss => 'Убыток';

  @override
  String get financeIncomeByCategory => 'Доходы по категориям';

  @override
  String get financeExpensesByCategory => 'Расходы по категориям';

  @override
  String get financeRecent => 'Последние операции';

  @override
  String get txCategorySaleRabbit => 'Продажа кролика';

  @override
  String get txCategorySaleMeat => 'Продажа мяса';

  @override
  String get txCategorySaleFur => 'Продажа шкурок';

  @override
  String get txCategoryBreedingFee => 'Плата за случку';

  @override
  String get txCategoryFeed => 'Корм';

  @override
  String get txCategoryVeterinary => 'Лечение';

  @override
  String get txCategoryEquipment => 'Оборудование';

  @override
  String get txCategoryUtilities => 'Свет, вода, отопление';

  @override
  String get txCategoryOther => 'Прочее';

  @override
  String get reportsOutcomeUnknown => 'Исход не указан';

  @override
  String get reportsFeedUsed => 'Израсходовано';

  @override
  String get reportsTabFarm => 'Ферма';

  @override
  String get reportsTabHealth => 'Здоровье';

  @override
  String get reportsTabFinance => 'Деньги';

  @override
  String reportsPeriodRange(String from, String to) {
    return 'С $from по $to';
  }

  @override
  String get reportsPopulationNow => 'Кроликов сейчас';

  @override
  String get reportsBirths => 'Окролы';

  @override
  String get reportsBreedings => 'Случки';

  @override
  String get reportsVaccinations => 'Вакцинации';

  @override
  String get reportsMedicalRecords => 'Лечение';

  @override
  String get reportsFeedings => 'Кормления';

  @override
  String get reportsActivity => 'За период';

  @override
  String get reportsByBreed => 'Поголовье по породам';

  @override
  String reportsBreedUnknown(int id) {
    return 'Порода №$id';
  }

  @override
  String get reportsMoney => 'Деньги за период';

  @override
  String get reportsNoActivityTitle => 'За этот период записей нет';

  @override
  String get reportsNoActivityBody =>
      'Выберите период шире — или запишите случку, прививку, кормление, и они появятся здесь.';

  @override
  String get reportsFarmEmptyTitle => 'Отчёту пока не из чего собраться';

  @override
  String get reportsFarmEmptyBody =>
      'Заведите первого кролика — дальше отчёт соберётся сам из ежедневных записей.';

  @override
  String get reportsHealthEmptyTitle =>
      'За этот период прививок и лечений не было';

  @override
  String get reportsHealthEmptyBody =>
      'Выберите период шире или отметьте прививку — отчёт посчитается сам.';

  @override
  String get reportsVaccinesByName => 'Прививки по вакцинам';

  @override
  String get reportsRecordsByOutcome => 'Лечение по исходу';

  @override
  String get farmSectionPlatform => 'Платформа';

  @override
  String get farmPlatformAdmin => 'Фермы и тарифы';

  @override
  String get platformTitle => 'Платформа';

  @override
  String get platformTabFarms => 'Фермы';

  @override
  String get platformTabPlans => 'Тарифы';

  @override
  String countFarms(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count фермы',
      many: '$count ферм',
      few: '$count фермы',
      one: '$count ферма',
    );
    return '$_temp0';
  }

  @override
  String get platformFarmsEmptyTitle => 'Ферм пока нет';

  @override
  String get platformFarmsEmptyBody =>
      'Здесь будут все хозяйства сервиса — они появятся сами, как только кто-нибудь зарегистрируется.';

  @override
  String get platformOwnerMissing => 'Владелец не назначен';

  @override
  String get platformNoPlan => 'Без тарифа';

  @override
  String get platformNoPlanHint => 'Ограничений нет';

  @override
  String get platformRabbits => 'Кролики';

  @override
  String get platformStaff => 'Люди';

  @override
  String platformUsageOfLimit(int used, int limit) {
    return '$used из $limit';
  }

  @override
  String platformUsageUnlimited(int used) {
    return '$used, без предела';
  }

  @override
  String get platformAtLimit => 'Упёрлась в предел тарифа';

  @override
  String get platformNearLimit => 'Подходит к пределу тарифа';

  @override
  String get platformChangePlan => 'Сменить тариф';

  @override
  String get platformAssignPlan => 'Назначить тариф';

  @override
  String platformPlanSheetTitle(String farm) {
    return 'Тариф хозяйства «$farm»';
  }

  @override
  String get platformPlanOff => 'Без тарифа — работает без ограничений';

  @override
  String get platformPlanAssigned => 'Тариф обновлён';

  @override
  String get platformPlanInactive => 'выключен';

  @override
  String get platformPlansEmptyTitle => 'Тарифов пока нет';

  @override
  String get platformPlansEmptyBody =>
      'Пока их нет, все фермы работают без ограничений. Создайте первый — и его можно будет назначать.';

  @override
  String get platformPlanNew => 'Новый тариф';

  @override
  String get platformPlanEdit => 'Изменить';

  @override
  String get platformPlanDeleteTitle => 'Удалить тариф?';

  @override
  String platformPlanDeleteBody(String name) {
    return '«$name» исчезнет из списка, а фермы на нём станут работать без ограничений. Их записи не тронутся.';
  }

  @override
  String get platformPlanDeleted => 'Тариф удалён';

  @override
  String get platformPlanUnlimited => 'Без ограничений';

  @override
  String get platformPlanFree => 'Бесплатный';

  @override
  String platformPlanLimitRabbits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'до $count кроликов',
      many: 'до $count кроликов',
      few: 'до $count кроликов',
      one: 'до $count кролика',
    );
    return '$_temp0';
  }

  @override
  String platformPlanLimitStaff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'до $count человек',
      many: 'до $count человек',
      few: 'до $count человек',
      one: 'до $count человека',
    );
    return '$_temp0';
  }

  @override
  String get platformPlanFormNewTitle => 'Новый тариф';

  @override
  String get platformPlanFormEditTitle => 'Тариф';

  @override
  String get platformPlanFormName => 'Название';

  @override
  String get platformPlanFormNameHint => 'Например, «Базовый»';

  @override
  String get platformPlanFormNameEmpty => 'Введите название';

  @override
  String get platformPlanFormPrice => 'Цена в месяц';

  @override
  String get platformPlanFormPriceHint => 'Пусто — бесплатно';

  @override
  String get platformPlanFormSectionLimits => 'Пределы';

  @override
  String get platformPlanFormMaxRabbits => 'Кроликов не больше';

  @override
  String get platformPlanFormMaxStaff => 'Людей не больше';

  @override
  String get platformPlanFormLimitHint => 'Пусто — без ограничения';

  @override
  String get platformPlanFormActive => 'Тариф в ходу';

  @override
  String get platformPlanFormActiveHint =>
      'Выключенный тариф остаётся у ферм, которым уже назначен, но новым его не выдать.';

  @override
  String get platformPlanFormDefault => 'Выдавать новым фермам';

  @override
  String get platformPlanFormDefaultHint =>
      'Этот тариф автоматически достаётся каждой новой зарегистрированной ферме. Ровно один тариф может быть таким — назначить его другому можно, только сняв флаг с текущего.';

  @override
  String get platformPlanFormCreated => 'Тариф создан';

  @override
  String get platformPlanFormUpdated => 'Тариф обновлён';

  @override
  String get emptyNoRecordsTitle => 'Записей нет';

  @override
  String get emptyNoRecordsBody => 'Добавьте первую.';
}
