import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ru')];

  /// Название приложения
  ///
  /// In ru, this message translates to:
  /// **'RabbitFarm'**
  String get appName;

  /// No description provided for @commonRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get commonSave;

  /// No description provided for @commonAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get commonAdd;

  /// No description provided for @commonDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get commonDelete;

  /// No description provided for @commonClose.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get commonClose;

  /// No description provided for @commonLoadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить'**
  String get commonLoadFailed;

  /// No description provided for @commonUnknownError.
  ///
  /// In ru, this message translates to:
  /// **'Неизвестная ошибка'**
  String get commonUnknownError;

  /// No description provided for @commonStaleData.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обновить, показаны прежние данные'**
  String get commonStaleData;

  /// No description provided for @commonRetryShort.
  ///
  /// In ru, this message translates to:
  /// **'Ещё раз'**
  String get commonRetryShort;

  /// No description provided for @commonNotSpecified.
  ///
  /// In ru, this message translates to:
  /// **'Не указано'**
  String get commonNotSpecified;

  /// No description provided for @commonActions.
  ///
  /// In ru, this message translates to:
  /// **'Действия'**
  String get commonActions;

  /// No description provided for @loginSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход в вашу ферму'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In ru, this message translates to:
  /// **'Почта'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In ru, this message translates to:
  /// **'name@example.com'**
  String get loginEmailHint;

  /// No description provided for @loginEmailEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите почту'**
  String get loginEmailEmpty;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Похоже, в адресе опечатка'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите пароль'**
  String get loginPasswordEmpty;

  /// No description provided for @loginPasswordShow.
  ///
  /// In ru, this message translates to:
  /// **'Показать пароль'**
  String get loginPasswordShow;

  /// No description provided for @loginPasswordHide.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть пароль'**
  String get loginPasswordHide;

  /// No description provided for @loginSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get loginSubmit;

  /// No description provided for @loginFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось войти'**
  String get loginFailed;

  /// No description provided for @loginHasInvite.
  ///
  /// In ru, this message translates to:
  /// **'У меня есть код приглашения'**
  String get loginHasInvite;

  /// No description provided for @loginCreateFarm.
  ///
  /// In ru, this message translates to:
  /// **'Завести свою ферму'**
  String get loginCreateFarm;

  /// No description provided for @loginForgotPassword.
  ///
  /// In ru, this message translates to:
  /// **'Забыли пароль? Его сбрасывает владелец фермы — писем сервис не отправляет.'**
  String get loginForgotPassword;

  /// No description provided for @todayGreetingMorning.
  ///
  /// In ru, this message translates to:
  /// **'Доброе утро'**
  String get todayGreetingMorning;

  /// No description provided for @todayGreetingDay.
  ///
  /// In ru, this message translates to:
  /// **'Добрый день'**
  String get todayGreetingDay;

  /// No description provided for @todayGreetingEvening.
  ///
  /// In ru, this message translates to:
  /// **'Добрый вечер'**
  String get todayGreetingEvening;

  /// No description provided for @todayGreetingNight.
  ///
  /// In ru, this message translates to:
  /// **'Доброй ночи'**
  String get todayGreetingNight;

  /// No description provided for @todayGreetingNamed.
  ///
  /// In ru, this message translates to:
  /// **'{greeting}, {name}!'**
  String todayGreetingNamed(String greeting, String name);

  /// No description provided for @todayGreetingPlain.
  ///
  /// In ru, this message translates to:
  /// **'{greeting}!'**
  String todayGreetingPlain(String greeting);

  /// No description provided for @todayNeedsAttention.
  ///
  /// In ru, this message translates to:
  /// **'Требует внимания'**
  String get todayNeedsAttention;

  /// No description provided for @todayAllClear.
  ///
  /// In ru, this message translates to:
  /// **'Всё под контролем — срочного нет'**
  String get todayAllClear;

  /// No description provided for @todayFarmNow.
  ///
  /// In ru, this message translates to:
  /// **'Ферма сейчас'**
  String get todayFarmNow;

  /// No description provided for @todayLast30Days.
  ///
  /// In ru, this message translates to:
  /// **'За 30 дней'**
  String get todayLast30Days;

  /// No description provided for @todayStatLivestock.
  ///
  /// In ru, this message translates to:
  /// **'Поголовье'**
  String get todayStatLivestock;

  /// No description provided for @todayStatTasks.
  ///
  /// In ru, this message translates to:
  /// **'Задачи в работе'**
  String get todayStatTasks;

  /// No description provided for @todayStatFreeCages.
  ///
  /// In ru, this message translates to:
  /// **'Клеток свободно'**
  String get todayStatFreeCages;

  /// No description provided for @todayStatBirths.
  ///
  /// In ru, this message translates to:
  /// **'Родилось'**
  String get todayStatBirths;

  /// No description provided for @todayStatIncome.
  ///
  /// In ru, this message translates to:
  /// **'Доход'**
  String get todayStatIncome;

  /// No description provided for @todayStatExpenses.
  ///
  /// In ru, this message translates to:
  /// **'Расход'**
  String get todayStatExpenses;

  /// No description provided for @todayAlertOverdueTasks.
  ///
  /// In ru, this message translates to:
  /// **'Просроченные задачи'**
  String get todayAlertOverdueTasks;

  /// No description provided for @todayAlertOverdueVaccination.
  ///
  /// In ru, this message translates to:
  /// **'Вакцинация просрочена'**
  String get todayAlertOverdueVaccination;

  /// No description provided for @todayAlertUrgentTasks.
  ///
  /// In ru, this message translates to:
  /// **'Срочные задачи'**
  String get todayAlertUrgentTasks;

  /// No description provided for @todayAlertLowFeed.
  ///
  /// In ru, this message translates to:
  /// **'Заканчивается корм'**
  String get todayAlertLowFeed;

  /// No description provided for @todayAlertUpcomingVaccination.
  ///
  /// In ru, this message translates to:
  /// **'Скоро вакцинация'**
  String get todayAlertUpcomingVaccination;

  /// No description provided for @todayTourAlertsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Что требует внимания'**
  String get todayTourAlertsTitle;

  /// No description provided for @todayTourAlertsBody.
  ///
  /// In ru, this message translates to:
  /// **'Просроченные задачи, вакцинация и заканчивающийся корм — всё срочное собирается здесь. Нажмите на строку, чтобы перейти к делу.'**
  String get todayTourAlertsBody;

  /// No description provided for @todayTourStatsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Состояние фермы'**
  String get todayTourStatsTitle;

  /// No description provided for @todayTourStatsBody.
  ///
  /// In ru, this message translates to:
  /// **'Поголовье, незакрытые задачи и свободные клетки. Потяните экран вниз, чтобы обновить цифры.'**
  String get todayTourStatsBody;

  /// No description provided for @menuTitle.
  ///
  /// In ru, this message translates to:
  /// **'Меню'**
  String get menuTitle;

  /// No description provided for @menuProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get menuProfile;

  /// No description provided for @menuSectionLivestock.
  ///
  /// In ru, this message translates to:
  /// **'Поголовье'**
  String get menuSectionLivestock;

  /// No description provided for @menuSectionBreeding.
  ///
  /// In ru, this message translates to:
  /// **'Разведение'**
  String get menuSectionBreeding;

  /// No description provided for @menuSectionHealth.
  ///
  /// In ru, this message translates to:
  /// **'Здоровье'**
  String get menuSectionHealth;

  /// No description provided for @menuSectionFeeding.
  ///
  /// In ru, this message translates to:
  /// **'Корма'**
  String get menuSectionFeeding;

  /// No description provided for @menuSectionLedger.
  ///
  /// In ru, this message translates to:
  /// **'Учёт'**
  String get menuSectionLedger;

  /// No description provided for @menuSectionApp.
  ///
  /// In ru, this message translates to:
  /// **'Приложение'**
  String get menuSectionApp;

  /// No description provided for @menuCages.
  ///
  /// In ru, this message translates to:
  /// **'Клетки'**
  String get menuCages;

  /// No description provided for @menuBreeds.
  ///
  /// In ru, this message translates to:
  /// **'Породы'**
  String get menuBreeds;

  /// No description provided for @menuBreedings.
  ///
  /// In ru, this message translates to:
  /// **'Случки'**
  String get menuBreedings;

  /// No description provided for @menuBirths.
  ///
  /// In ru, this message translates to:
  /// **'Роды'**
  String get menuBirths;

  /// No description provided for @menuPairPlanner.
  ///
  /// In ru, this message translates to:
  /// **'Подбор пар'**
  String get menuPairPlanner;

  /// No description provided for @menuVaccinations.
  ///
  /// In ru, this message translates to:
  /// **'Вакцинации'**
  String get menuVaccinations;

  /// No description provided for @menuMedicalRecords.
  ///
  /// In ru, this message translates to:
  /// **'Лечение'**
  String get menuMedicalRecords;

  /// No description provided for @menuFeedStock.
  ///
  /// In ru, this message translates to:
  /// **'Запасы'**
  String get menuFeedStock;

  /// No description provided for @menuFeedingRecords.
  ///
  /// In ru, this message translates to:
  /// **'Кормления'**
  String get menuFeedingRecords;

  /// No description provided for @menuFinance.
  ///
  /// In ru, this message translates to:
  /// **'Финансы'**
  String get menuFinance;

  /// No description provided for @menuStaff.
  ///
  /// In ru, this message translates to:
  /// **'Работники'**
  String get menuStaff;

  /// No description provided for @menuSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get menuSettings;

  /// No description provided for @menuAbout.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get menuAbout;

  /// No description provided for @menuAboutBody.
  ///
  /// In ru, this message translates to:
  /// **'Учёт поголовья, кормов, здоровья и денег кроличьей фермы.'**
  String get menuAboutBody;

  /// No description provided for @menuLogout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get menuLogout;

  /// No description provided for @roleOwner.
  ///
  /// In ru, this message translates to:
  /// **'Владелец фермы'**
  String get roleOwner;

  /// No description provided for @roleManager.
  ///
  /// In ru, this message translates to:
  /// **'Управляющий'**
  String get roleManager;

  /// No description provided for @roleWorker.
  ///
  /// In ru, this message translates to:
  /// **'Работник'**
  String get roleWorker;

  /// No description provided for @navToday.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get navToday;

  /// No description provided for @navRabbits.
  ///
  /// In ru, this message translates to:
  /// **'Кролики'**
  String get navRabbits;

  /// No description provided for @navTasks.
  ///
  /// In ru, this message translates to:
  /// **'Задачи'**
  String get navTasks;

  /// No description provided for @navMenu.
  ///
  /// In ru, this message translates to:
  /// **'Меню'**
  String get navMenu;

  /// No description provided for @navNewTask.
  ///
  /// In ru, this message translates to:
  /// **'Новая задача'**
  String get navNewTask;

  /// No description provided for @navQuickEntry.
  ///
  /// In ru, this message translates to:
  /// **'Быстрая запись'**
  String get navQuickEntry;

  /// No description provided for @navQuickTitle.
  ///
  /// In ru, this message translates to:
  /// **'Что записать'**
  String get navQuickTitle;

  /// No description provided for @quickRecordFeeding.
  ///
  /// In ru, this message translates to:
  /// **'Записать кормление'**
  String get quickRecordFeeding;

  /// No description provided for @quickRecordVaccination.
  ///
  /// In ru, this message translates to:
  /// **'Записать вакцинацию'**
  String get quickRecordVaccination;

  /// No description provided for @quickCreateTask.
  ///
  /// In ru, this message translates to:
  /// **'Создать задачу'**
  String get quickCreateTask;

  /// No description provided for @quickAddRabbit.
  ///
  /// In ru, this message translates to:
  /// **'Добавить кролика'**
  String get quickAddRabbit;

  /// No description provided for @quickRecordBirth.
  ///
  /// In ru, this message translates to:
  /// **'Записать окрол'**
  String get quickRecordBirth;

  /// No description provided for @quickAddCage.
  ///
  /// In ru, this message translates to:
  /// **'Добавить клетку'**
  String get quickAddCage;

  /// No description provided for @formDiscardTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выйти без сохранения?'**
  String get formDiscardTitle;

  /// No description provided for @formDiscardBody.
  ///
  /// In ru, this message translates to:
  /// **'Заполненные поля будут потеряны.'**
  String get formDiscardBody;

  /// No description provided for @formDiscardStay.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить ввод'**
  String get formDiscardStay;

  /// No description provided for @formDiscardLeave.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get formDiscardLeave;

  /// No description provided for @breedingListTitle.
  ///
  /// In ru, this message translates to:
  /// **'Случки'**
  String get breedingListTitle;

  /// No description provided for @breedingEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Случек пока нет'**
  String get breedingEmptyTitle;

  /// No description provided for @breedingEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Запишите случку, и приложение подскажет ожидаемую дату окрола.'**
  String get breedingEmptyBody;

  /// No description provided for @breedingEmptyAction.
  ///
  /// In ru, this message translates to:
  /// **'Записать случку'**
  String get breedingEmptyAction;

  /// No description provided for @breedingMale.
  ///
  /// In ru, this message translates to:
  /// **'Самец'**
  String get breedingMale;

  /// No description provided for @breedingFemale.
  ///
  /// In ru, this message translates to:
  /// **'Самка'**
  String get breedingFemale;

  /// No description provided for @breedingNameMissing.
  ///
  /// In ru, this message translates to:
  /// **'Имя не указано'**
  String get breedingNameMissing;

  /// No description provided for @breedingExpectedBirth.
  ///
  /// In ru, this message translates to:
  /// **'Окрол ожидается {date}'**
  String breedingExpectedBirth(String date);

  /// No description provided for @breedingStatusPlanned.
  ///
  /// In ru, this message translates to:
  /// **'Запланирована'**
  String get breedingStatusPlanned;

  /// No description provided for @breedingStatusCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Завершена'**
  String get breedingStatusCompleted;

  /// No description provided for @breedingStatusFailed.
  ///
  /// In ru, this message translates to:
  /// **'Неудачная'**
  String get breedingStatusFailed;

  /// No description provided for @breedingStatusCancelled.
  ///
  /// In ru, this message translates to:
  /// **'Отменена'**
  String get breedingStatusCancelled;

  /// No description provided for @cageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Клетка'**
  String get cageTitle;

  /// No description provided for @cageTitleNumbered.
  ///
  /// In ru, this message translates to:
  /// **'Клетка {number}'**
  String cageTitleNumbered(String number);

  /// No description provided for @cageEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить клетку'**
  String get cageEdit;

  /// No description provided for @cageResidents.
  ///
  /// In ru, this message translates to:
  /// **'Жители'**
  String get cageResidents;

  /// No description provided for @cageEmptyManaged.
  ///
  /// In ru, this message translates to:
  /// **'Клетка пустая. Поселите кролика кнопкой внизу.'**
  String get cageEmptyManaged;

  /// No description provided for @cageEmptyReadOnly.
  ///
  /// In ru, this message translates to:
  /// **'Клетка пустая.'**
  String get cageEmptyReadOnly;

  /// No description provided for @cageFull.
  ///
  /// In ru, this message translates to:
  /// **'Клетка заполнена'**
  String get cageFull;

  /// No description provided for @cageAddRabbit.
  ///
  /// In ru, this message translates to:
  /// **'Поселить кролика'**
  String get cageAddRabbit;

  /// No description provided for @cageNoLocation.
  ///
  /// In ru, this message translates to:
  /// **'Место не указано'**
  String get cageNoLocation;

  /// No description provided for @cageRemoveTitle.
  ///
  /// In ru, this message translates to:
  /// **'Убрать из клетки?'**
  String get cageRemoveTitle;

  /// No description provided for @cageRemoveBody.
  ///
  /// In ru, this message translates to:
  /// **'{name} перейдёт в список кроликов без клетки.'**
  String cageRemoveBody(String name);

  /// No description provided for @cageRemoveConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Убрать'**
  String get cageRemoveConfirm;

  /// No description provided for @cageRemoved.
  ///
  /// In ru, this message translates to:
  /// **'{name} убран из клетки'**
  String cageRemoved(String name);

  /// No description provided for @cageMoved.
  ///
  /// In ru, this message translates to:
  /// **'{name} переехал в клетку {number}'**
  String cageMoved(String name, String number);

  /// No description provided for @cageSettled.
  ///
  /// In ru, this message translates to:
  /// **'{name} поселён в клетку'**
  String cageSettled(String name);

  /// No description provided for @cageActionFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось: {reason}'**
  String cageActionFailed(String reason);

  /// No description provided for @cageResidentMove.
  ///
  /// In ru, this message translates to:
  /// **'Переселить'**
  String get cageResidentMove;

  /// No description provided for @cagePickRabbitTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кого поселить'**
  String get cagePickRabbitTitle;

  /// No description provided for @cagePickRabbitHint.
  ///
  /// In ru, this message translates to:
  /// **'Кличка или номер бирки'**
  String get cagePickRabbitHint;

  /// No description provided for @cagePickNothingFound.
  ///
  /// In ru, this message translates to:
  /// **'Никого не нашлось'**
  String get cagePickNothingFound;

  /// No description provided for @cagePickNothingFoundBody.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте кличку или номер бирки.'**
  String get cagePickNothingFoundBody;

  /// No description provided for @cagePickCurrentCage.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас в клетке {number}'**
  String cagePickCurrentCage(String number);

  /// No description provided for @cagePickNoCage.
  ///
  /// In ru, this message translates to:
  /// **'Без клетки'**
  String get cagePickNoCage;

  /// No description provided for @cagePickCageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Куда переселить'**
  String get cagePickCageTitle;

  /// No description provided for @cagePickNoFreeCages.
  ///
  /// In ru, this message translates to:
  /// **'Свободных клеток нет'**
  String get cagePickNoFreeCages;

  /// No description provided for @cagePickNoFreeCagesBody.
  ///
  /// In ru, this message translates to:
  /// **'Освободите место или добавьте новую клетку.'**
  String get cagePickNoFreeCagesBody;

  /// No description provided for @cageTypeSingle.
  ///
  /// In ru, this message translates to:
  /// **'Одиночная'**
  String get cageTypeSingle;

  /// No description provided for @cageTypeGroup.
  ///
  /// In ru, this message translates to:
  /// **'Групповая'**
  String get cageTypeGroup;

  /// No description provided for @cageTypeMaternity.
  ///
  /// In ru, this message translates to:
  /// **'Для окрола'**
  String get cageTypeMaternity;

  /// No description provided for @cageConditionGood.
  ///
  /// In ru, this message translates to:
  /// **'В порядке'**
  String get cageConditionGood;

  /// No description provided for @cageConditionNeedsRepair.
  ///
  /// In ru, this message translates to:
  /// **'Нужен ремонт'**
  String get cageConditionNeedsRepair;

  /// No description provided for @cageConditionBroken.
  ///
  /// In ru, this message translates to:
  /// **'Сломана'**
  String get cageConditionBroken;

  /// No description provided for @countTasks.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} задача} few{{count} задачи} many{{count} задач} other{{count} задачи}}'**
  String countTasks(int count);

  /// No description provided for @countVaccinations.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} прививка} few{{count} прививки} many{{count} прививок} other{{count} прививки}}'**
  String countVaccinations(int count);

  /// No description provided for @countFeedKinds.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} вид корма} few{{count} вида корма} many{{count} видов корма} other{{count} вида корма}}'**
  String countFeedKinds(int count);

  /// No description provided for @countRabbits.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} кролик} few{{count} кролика} many{{count} кроликов} other{{count} кролика}}'**
  String countRabbits(int count);

  /// No description provided for @countRecords.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} запись} few{{count} записи} many{{count} записей} other{{count} записи}}'**
  String countRecords(int count);

  /// No description provided for @countOperations.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} операция} few{{count} операции} many{{count} операций} other{{count} операции}}'**
  String countOperations(int count);

  /// No description provided for @tasksTitle.
  ///
  /// In ru, this message translates to:
  /// **'Задачи'**
  String get tasksTitle;

  /// No description provided for @tasksFilters.
  ///
  /// In ru, this message translates to:
  /// **'Фильтры'**
  String get tasksFilters;

  /// No description provided for @tasksFiltersApply.
  ///
  /// In ru, this message translates to:
  /// **'Применить'**
  String get tasksFiltersApply;

  /// No description provided for @tasksFiltersReset.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить'**
  String get tasksFiltersReset;

  /// No description provided for @tasksFilterType.
  ///
  /// In ru, this message translates to:
  /// **'Тип'**
  String get tasksFilterType;

  /// No description provided for @tasksFilterStatus.
  ///
  /// In ru, this message translates to:
  /// **'Статус'**
  String get tasksFilterStatus;

  /// No description provided for @tasksFilterPriority.
  ///
  /// In ru, this message translates to:
  /// **'Приоритет'**
  String get tasksFilterPriority;

  /// No description provided for @tasksFilterOverdueOnly.
  ///
  /// In ru, this message translates to:
  /// **'Только просроченные'**
  String get tasksFilterOverdueOnly;

  /// No description provided for @tasksFilterTodayOnly.
  ///
  /// In ru, this message translates to:
  /// **'Только на сегодня'**
  String get tasksFilterTodayOnly;

  /// No description provided for @tasksEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Задач пока нет'**
  String get tasksEmptyTitle;

  /// No description provided for @tasksEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Создайте задачу — приложение напомнит о ней в день срока.'**
  String get tasksEmptyBody;

  /// No description provided for @tasksEmptyAction.
  ///
  /// In ru, this message translates to:
  /// **'Создать задачу'**
  String get tasksEmptyAction;

  /// No description provided for @tasksNothingMatchesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Под фильтры ничего не подошло'**
  String get tasksNothingMatchesTitle;

  /// No description provided for @tasksNothingMatchesBody.
  ///
  /// In ru, this message translates to:
  /// **'Снимите часть условий, чтобы увидеть больше.'**
  String get tasksNothingMatchesBody;

  /// No description provided for @tasksComplete.
  ///
  /// In ru, this message translates to:
  /// **'Отметить выполненной'**
  String get tasksComplete;

  /// No description provided for @tasksCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Задача выполнена'**
  String get tasksCompleted;

  /// No description provided for @tasksCompleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось отметить задачу'**
  String get tasksCompleteFailed;

  /// No description provided for @tasksOverdueChip.
  ///
  /// In ru, this message translates to:
  /// **'Просроченные'**
  String get tasksOverdueChip;

  /// No description provided for @tasksTodayChip.
  ///
  /// In ru, this message translates to:
  /// **'На сегодня'**
  String get tasksTodayChip;

  /// No description provided for @taskTypeFeeding.
  ///
  /// In ru, this message translates to:
  /// **'Кормление'**
  String get taskTypeFeeding;

  /// No description provided for @taskTypeCleaning.
  ///
  /// In ru, this message translates to:
  /// **'Уборка'**
  String get taskTypeCleaning;

  /// No description provided for @taskTypeVaccination.
  ///
  /// In ru, this message translates to:
  /// **'Вакцинация'**
  String get taskTypeVaccination;

  /// No description provided for @taskTypeCheckup.
  ///
  /// In ru, this message translates to:
  /// **'Осмотр'**
  String get taskTypeCheckup;

  /// No description provided for @taskTypeBreeding.
  ///
  /// In ru, this message translates to:
  /// **'Разведение'**
  String get taskTypeBreeding;

  /// No description provided for @taskTypeOther.
  ///
  /// In ru, this message translates to:
  /// **'Другое'**
  String get taskTypeOther;

  /// No description provided for @taskStatusPending.
  ///
  /// In ru, this message translates to:
  /// **'Ожидает'**
  String get taskStatusPending;

  /// No description provided for @taskStatusInProgress.
  ///
  /// In ru, this message translates to:
  /// **'В работе'**
  String get taskStatusInProgress;

  /// No description provided for @taskStatusCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Выполнена'**
  String get taskStatusCompleted;

  /// No description provided for @taskStatusCancelled.
  ///
  /// In ru, this message translates to:
  /// **'Отменена'**
  String get taskStatusCancelled;

  /// No description provided for @taskPriorityLow.
  ///
  /// In ru, this message translates to:
  /// **'Низкий'**
  String get taskPriorityLow;

  /// No description provided for @taskPriorityMedium.
  ///
  /// In ru, this message translates to:
  /// **'Средний'**
  String get taskPriorityMedium;

  /// No description provided for @taskPriorityHigh.
  ///
  /// In ru, this message translates to:
  /// **'Высокий'**
  String get taskPriorityHigh;

  /// No description provided for @taskPriorityUrgent.
  ///
  /// In ru, this message translates to:
  /// **'Срочный'**
  String get taskPriorityUrgent;

  /// No description provided for @dueToday.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня в {time}'**
  String dueToday(String time);

  /// No description provided for @dueTomorrow.
  ///
  /// In ru, this message translates to:
  /// **'Завтра в {time}'**
  String dueTomorrow(String time);

  /// No description provided for @dueOn.
  ///
  /// In ru, this message translates to:
  /// **'{date}'**
  String dueOn(String date);

  /// No description provided for @overdueByDays.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{Просрочена на {count} день} few{Просрочена на {count} дня} many{Просрочена на {count} дней} other{Просрочена на {count} дня}}'**
  String overdueByDays(int count);

  /// No description provided for @dueTodayPlain.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get dueTodayPlain;

  /// No description provided for @dueTomorrowPlain.
  ///
  /// In ru, this message translates to:
  /// **'Завтра'**
  String get dueTomorrowPlain;

  /// No description provided for @taskFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая задача'**
  String get taskFormNewTitle;

  /// No description provided for @taskFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Задача'**
  String get taskFormEditTitle;

  /// No description provided for @taskFormSectionMain.
  ///
  /// In ru, this message translates to:
  /// **'Основное'**
  String get taskFormSectionMain;

  /// No description provided for @taskFormSectionParams.
  ///
  /// In ru, this message translates to:
  /// **'Параметры'**
  String get taskFormSectionParams;

  /// No description provided for @taskFormSectionNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get taskFormSectionNotes;

  /// No description provided for @taskFormTitleLabel.
  ///
  /// In ru, this message translates to:
  /// **'Что нужно сделать'**
  String get taskFormTitleLabel;

  /// No description provided for @taskFormTitleEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Опишите задачу одной строкой'**
  String get taskFormTitleEmpty;

  /// No description provided for @taskFormDescriptionLabel.
  ///
  /// In ru, this message translates to:
  /// **'Подробности'**
  String get taskFormDescriptionLabel;

  /// No description provided for @taskFormDueLabel.
  ///
  /// In ru, this message translates to:
  /// **'Срок'**
  String get taskFormDueLabel;

  /// No description provided for @taskFormRepeat.
  ///
  /// In ru, this message translates to:
  /// **'Повторять'**
  String get taskFormRepeat;

  /// No description provided for @taskFormRepeatNever.
  ///
  /// In ru, this message translates to:
  /// **'Не повторять'**
  String get taskFormRepeatNever;

  /// No description provided for @taskFormRepeatHelp.
  ///
  /// In ru, this message translates to:
  /// **'Когда задачу отметят выполненной, следующая создастся сама.'**
  String get taskFormRepeatHelp;

  /// No description provided for @taskFormNotesLabel.
  ///
  /// In ru, this message translates to:
  /// **'Примечания'**
  String get taskFormNotesLabel;

  /// No description provided for @taskFormCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать'**
  String get taskFormCreate;

  /// No description provided for @taskFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Задача создана'**
  String get taskFormCreated;

  /// No description provided for @taskFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Задача обновлена'**
  String get taskFormUpdated;

  /// No description provided for @taskFormDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить задачу?'**
  String get taskFormDeleteTitle;

  /// No description provided for @taskFormDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить её будет нельзя.'**
  String get taskFormDeleteBody;

  /// No description provided for @taskFormDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Задача удалена'**
  String get taskFormDeleted;

  /// No description provided for @taskFormDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить задачу'**
  String get taskFormDeleteFailed;

  /// No description provided for @repeatDaily.
  ///
  /// In ru, this message translates to:
  /// **'Каждый день'**
  String get repeatDaily;

  /// No description provided for @repeatWeekly.
  ///
  /// In ru, this message translates to:
  /// **'Раз в неделю'**
  String get repeatWeekly;

  /// No description provided for @repeatBiweekly.
  ///
  /// In ru, this message translates to:
  /// **'Раз в две недели'**
  String get repeatBiweekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In ru, this message translates to:
  /// **'Раз в месяц'**
  String get repeatMonthly;

  /// No description provided for @repeatQuarterly.
  ///
  /// In ru, this message translates to:
  /// **'Раз в квартал'**
  String get repeatQuarterly;

  /// No description provided for @repeatYearly.
  ///
  /// In ru, this message translates to:
  /// **'Раз в год'**
  String get repeatYearly;

  /// No description provided for @vaccinationsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вакцинации'**
  String get vaccinationsTitle;

  /// No description provided for @vaccinationsStats.
  ///
  /// In ru, this message translates to:
  /// **'Сводка'**
  String get vaccinationsStats;

  /// No description provided for @vaccinationsViewAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get vaccinationsViewAll;

  /// No description provided for @vaccinationsViewUpcoming.
  ///
  /// In ru, this message translates to:
  /// **'Предстоящие'**
  String get vaccinationsViewUpcoming;

  /// No description provided for @vaccinationsViewOverdue.
  ///
  /// In ru, this message translates to:
  /// **'Просроченные'**
  String get vaccinationsViewOverdue;

  /// No description provided for @vaccinationsViewLast30.
  ///
  /// In ru, this message translates to:
  /// **'За 30 дней'**
  String get vaccinationsViewLast30;

  /// No description provided for @vaccinationsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Записей о вакцинации нет'**
  String get vaccinationsEmptyTitle;

  /// No description provided for @vaccinationsEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Отметьте прививку — приложение напомнит, когда придёт срок следующей.'**
  String get vaccinationsEmptyBody;

  /// No description provided for @vaccinationsEmptyAction.
  ///
  /// In ru, this message translates to:
  /// **'Записать вакцинацию'**
  String get vaccinationsEmptyAction;

  /// No description provided for @vaccinationsNoneInView.
  ///
  /// In ru, this message translates to:
  /// **'В этой выборке пусто'**
  String get vaccinationsNoneInView;

  /// No description provided for @vaccinationsNoneInViewBody.
  ///
  /// In ru, this message translates to:
  /// **'Выберите другую вкладку или снимите фильтры.'**
  String get vaccinationsNoneInViewBody;

  /// No description provided for @vaccinationsFilterType.
  ///
  /// In ru, this message translates to:
  /// **'Тип вакцины'**
  String get vaccinationsFilterType;

  /// No description provided for @vaccinationsFilterPeriod.
  ///
  /// In ru, this message translates to:
  /// **'Период'**
  String get vaccinationsFilterPeriod;

  /// No description provided for @vaccinationsFrom.
  ///
  /// In ru, this message translates to:
  /// **'От'**
  String get vaccinationsFrom;

  /// No description provided for @vaccinationsTo.
  ///
  /// In ru, this message translates to:
  /// **'До'**
  String get vaccinationsTo;

  /// No description provided for @vaccinationsResetAll.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить всё'**
  String get vaccinationsResetAll;

  /// No description provided for @vaccinationsNext.
  ///
  /// In ru, this message translates to:
  /// **'Следующая {date}'**
  String vaccinationsNext(String date);

  /// No description provided for @vaccinationsOverdueBadge.
  ///
  /// In ru, this message translates to:
  /// **'Просрочено'**
  String get vaccinationsOverdueBadge;

  /// No description provided for @vaccinationsInDays.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{через {count} день} few{через {count} дня} many{через {count} дней} other{через {count} дня}}'**
  String vaccinationsInDays(int count);

  /// No description provided for @vaccinationsBatch.
  ///
  /// In ru, this message translates to:
  /// **'Партия {number}'**
  String vaccinationsBatch(String number);

  /// No description provided for @vaccinationsVet.
  ///
  /// In ru, this message translates to:
  /// **'Ветеринар'**
  String get vaccinationsVet;

  /// No description provided for @vaccinationsDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата прививки'**
  String get vaccinationsDate;

  /// No description provided for @vaccinationsNextLabel.
  ///
  /// In ru, this message translates to:
  /// **'Следующая прививка'**
  String get vaccinationsNextLabel;

  /// No description provided for @vaccinationsBatchLabel.
  ///
  /// In ru, this message translates to:
  /// **'Номер партии'**
  String get vaccinationsBatchLabel;

  /// No description provided for @vaccinationsTypeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Тип'**
  String get vaccinationsTypeLabel;

  /// No description provided for @vaccinationsNotesLabel.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get vaccinationsNotesLabel;

  /// No description provided for @vaccinationsDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить запись?'**
  String get vaccinationsDeleteTitle;

  /// No description provided for @vaccinationsDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Запись о прививке будет удалена без возможности вернуть.'**
  String get vaccinationsDeleteBody;

  /// No description provided for @vaccinationsDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Запись удалена'**
  String get vaccinationsDeleted;

  /// No description provided for @vaccinationsDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить запись'**
  String get vaccinationsDeleteFailed;

  /// No description provided for @vaccinationsStatTotal.
  ///
  /// In ru, this message translates to:
  /// **'Всего прививок'**
  String get vaccinationsStatTotal;

  /// No description provided for @vaccinationsStatThisYear.
  ///
  /// In ru, this message translates to:
  /// **'В этом году'**
  String get vaccinationsStatThisYear;

  /// No description provided for @vaccinationsStatLast30.
  ///
  /// In ru, this message translates to:
  /// **'За 30 дней'**
  String get vaccinationsStatLast30;

  /// No description provided for @vaccinationsStatUpcoming.
  ///
  /// In ru, this message translates to:
  /// **'Предстоящие'**
  String get vaccinationsStatUpcoming;

  /// No description provided for @vaccinationsStatNext30.
  ///
  /// In ru, this message translates to:
  /// **'В ближайшие 30 дней'**
  String get vaccinationsStatNext30;

  /// No description provided for @vaccinationsStatOverdue.
  ///
  /// In ru, this message translates to:
  /// **'Просрочено'**
  String get vaccinationsStatOverdue;

  /// No description provided for @rabbitPickerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выберите кролика'**
  String get rabbitPickerTitle;

  /// No description provided for @rabbitPickerHint.
  ///
  /// In ru, this message translates to:
  /// **'Кличка или номер бирки'**
  String get rabbitPickerHint;

  /// No description provided for @rabbitPickerEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Не выбран'**
  String get rabbitPickerEmpty;

  /// No description provided for @rabbitPickerNothingFound.
  ///
  /// In ru, this message translates to:
  /// **'Никого не нашлось'**
  String get rabbitPickerNothingFound;

  /// No description provided for @rabbitPickerNothingFoundBody.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте кличку или номер бирки.'**
  String get rabbitPickerNothingFoundBody;

  /// No description provided for @rabbitPickerClear.
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get rabbitPickerClear;

  /// No description provided for @rabbitPickerRequired.
  ///
  /// In ru, this message translates to:
  /// **'Выберите кролика'**
  String get rabbitPickerRequired;

  /// No description provided for @rabbitPickerInCage.
  ///
  /// In ru, this message translates to:
  /// **'Клетка {number}'**
  String rabbitPickerInCage(String number);

  /// No description provided for @rabbitPickerNoCage.
  ///
  /// In ru, this message translates to:
  /// **'Без клетки'**
  String get rabbitPickerNoCage;

  /// No description provided for @vaccFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая прививка'**
  String get vaccFormNewTitle;

  /// No description provided for @vaccFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Прививка'**
  String get vaccFormEditTitle;

  /// No description provided for @vaccFormSectionMain.
  ///
  /// In ru, this message translates to:
  /// **'Основное'**
  String get vaccFormSectionMain;

  /// No description provided for @vaccFormSectionDates.
  ///
  /// In ru, this message translates to:
  /// **'Даты'**
  String get vaccFormSectionDates;

  /// No description provided for @vaccFormSectionExtra.
  ///
  /// In ru, this message translates to:
  /// **'Дополнительно'**
  String get vaccFormSectionExtra;

  /// No description provided for @vaccFormRabbit.
  ///
  /// In ru, this message translates to:
  /// **'Кому'**
  String get vaccFormRabbit;

  /// No description provided for @vaccFormType.
  ///
  /// In ru, this message translates to:
  /// **'Тип вакцины'**
  String get vaccFormType;

  /// No description provided for @vaccFormName.
  ///
  /// In ru, this message translates to:
  /// **'Название вакцины'**
  String get vaccFormName;

  /// No description provided for @vaccFormNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, Раббивак V'**
  String get vaccFormNameHint;

  /// No description provided for @vaccFormNameEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите название вакцины'**
  String get vaccFormNameEmpty;

  /// No description provided for @vaccFormDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата прививки'**
  String get vaccFormDate;

  /// No description provided for @vaccFormNextDate.
  ///
  /// In ru, this message translates to:
  /// **'Следующая прививка'**
  String get vaccFormNextDate;

  /// No description provided for @vaccFormNextNotSet.
  ///
  /// In ru, this message translates to:
  /// **'Не запланирована'**
  String get vaccFormNextNotSet;

  /// No description provided for @vaccFormPlus3m.
  ///
  /// In ru, this message translates to:
  /// **'через 3 месяца'**
  String get vaccFormPlus3m;

  /// No description provided for @vaccFormPlus6m.
  ///
  /// In ru, this message translates to:
  /// **'через полгода'**
  String get vaccFormPlus6m;

  /// No description provided for @vaccFormPlus1y.
  ///
  /// In ru, this message translates to:
  /// **'через год'**
  String get vaccFormPlus1y;

  /// No description provided for @vaccFormBatch.
  ///
  /// In ru, this message translates to:
  /// **'Номер партии'**
  String get vaccFormBatch;

  /// No description provided for @vaccFormBatchHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, 12345-67'**
  String get vaccFormBatchHint;

  /// No description provided for @vaccFormVet.
  ///
  /// In ru, this message translates to:
  /// **'Ветеринар'**
  String get vaccFormVet;

  /// No description provided for @vaccFormVetHint.
  ///
  /// In ru, this message translates to:
  /// **'Кто делал прививку'**
  String get vaccFormVetHint;

  /// No description provided for @vaccFormNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get vaccFormNotes;

  /// No description provided for @vaccFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Прививка записана'**
  String get vaccFormCreated;

  /// No description provided for @vaccFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Запись обновлена'**
  String get vaccFormUpdated;

  /// No description provided for @vaccFormFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить'**
  String get vaccFormFailed;

  /// No description provided for @medTitle.
  ///
  /// In ru, this message translates to:
  /// **'Лечение'**
  String get medTitle;

  /// No description provided for @medEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Записей о лечении нет'**
  String get medEmptyTitle;

  /// No description provided for @medEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Заведите карту болезни — она соберёт симптомы, лечение и затраты в одном месте.'**
  String get medEmptyBody;

  /// No description provided for @medEmptyAction.
  ///
  /// In ru, this message translates to:
  /// **'Завести карту'**
  String get medEmptyAction;

  /// No description provided for @medNoneInView.
  ///
  /// In ru, this message translates to:
  /// **'В этой выборке пусто'**
  String get medNoneInView;

  /// No description provided for @medNoneInViewBody.
  ///
  /// In ru, this message translates to:
  /// **'Выберите другую вкладку или снимите фильтры.'**
  String get medNoneInViewBody;

  /// No description provided for @medViewAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get medViewAll;

  /// No description provided for @medOutcomeOngoing.
  ///
  /// In ru, this message translates to:
  /// **'Лечится'**
  String get medOutcomeOngoing;

  /// No description provided for @medOutcomeRecovered.
  ///
  /// In ru, this message translates to:
  /// **'Выздоровел'**
  String get medOutcomeRecovered;

  /// No description provided for @medOutcomeDied.
  ///
  /// In ru, this message translates to:
  /// **'Погиб'**
  String get medOutcomeDied;

  /// No description provided for @medOutcomeEuthanized.
  ///
  /// In ru, this message translates to:
  /// **'Усыплён'**
  String get medOutcomeEuthanized;

  /// No description provided for @medDiagnosis.
  ///
  /// In ru, this message translates to:
  /// **'Диагноз'**
  String get medDiagnosis;

  /// No description provided for @medSymptoms.
  ///
  /// In ru, this message translates to:
  /// **'Симптомы'**
  String get medSymptoms;

  /// No description provided for @medTreatment.
  ///
  /// In ru, this message translates to:
  /// **'Лечение'**
  String get medTreatment;

  /// No description provided for @medMedication.
  ///
  /// In ru, this message translates to:
  /// **'Препараты'**
  String get medMedication;

  /// No description provided for @medStarted.
  ///
  /// In ru, this message translates to:
  /// **'Начало'**
  String get medStarted;

  /// No description provided for @medEnded.
  ///
  /// In ru, this message translates to:
  /// **'Окончание'**
  String get medEnded;

  /// No description provided for @medCost.
  ///
  /// In ru, this message translates to:
  /// **'Затраты'**
  String get medCost;

  /// No description provided for @medVet.
  ///
  /// In ru, this message translates to:
  /// **'Ветеринар'**
  String get medVet;

  /// No description provided for @medNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get medNotes;

  /// No description provided for @medNoDiagnosis.
  ///
  /// In ru, this message translates to:
  /// **'Диагноз не поставлен'**
  String get medNoDiagnosis;

  /// No description provided for @medDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить карту?'**
  String get medDeleteTitle;

  /// No description provided for @medDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Запись о лечении будет удалена без возможности вернуть.'**
  String get medDeleteBody;

  /// No description provided for @medDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Запись удалена'**
  String get medDeleted;

  /// No description provided for @medDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить запись'**
  String get medDeleteFailed;

  /// No description provided for @medPeriodFrom.
  ///
  /// In ru, this message translates to:
  /// **'С даты'**
  String get medPeriodFrom;

  /// No description provided for @medPeriodTo.
  ///
  /// In ru, this message translates to:
  /// **'По дату'**
  String get medPeriodTo;

  /// No description provided for @medStats.
  ///
  /// In ru, this message translates to:
  /// **'Сводка'**
  String get medStats;

  /// No description provided for @medStatTotal.
  ///
  /// In ru, this message translates to:
  /// **'Всего карт'**
  String get medStatTotal;

  /// No description provided for @medStatThisYear.
  ///
  /// In ru, this message translates to:
  /// **'В этом году'**
  String get medStatThisYear;

  /// No description provided for @medStatLastMonth.
  ///
  /// In ru, this message translates to:
  /// **'За месяц'**
  String get medStatLastMonth;

  /// No description provided for @medStatCost.
  ///
  /// In ru, this message translates to:
  /// **'Потрачено'**
  String get medStatCost;

  /// No description provided for @medStatOngoing.
  ///
  /// In ru, this message translates to:
  /// **'Лечатся сейчас'**
  String get medStatOngoing;

  /// No description provided for @medDaysOngoing.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} день} few{{count} дня} many{{count} дней} other{{count} дня}}'**
  String medDaysOngoing(int count);

  /// No description provided for @medFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая карта'**
  String get medFormNewTitle;

  /// No description provided for @medFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Карта лечения'**
  String get medFormEditTitle;

  /// No description provided for @medFormRabbit.
  ///
  /// In ru, this message translates to:
  /// **'Кому'**
  String get medFormRabbit;

  /// No description provided for @medFormSectionCase.
  ///
  /// In ru, this message translates to:
  /// **'Что случилось'**
  String get medFormSectionCase;

  /// No description provided for @medFormSectionTreatment.
  ///
  /// In ru, this message translates to:
  /// **'Лечение'**
  String get medFormSectionTreatment;

  /// No description provided for @medFormSectionDates.
  ///
  /// In ru, this message translates to:
  /// **'Сроки и деньги'**
  String get medFormSectionDates;

  /// No description provided for @medFormSymptomsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Опишите симптомы'**
  String get medFormSymptomsEmpty;

  /// No description provided for @medFormOutcome.
  ///
  /// In ru, this message translates to:
  /// **'Исход'**
  String get medFormOutcome;

  /// No description provided for @medFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Карта заведена'**
  String get medFormCreated;

  /// No description provided for @medFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Карта обновлена'**
  String get medFormUpdated;

  /// No description provided for @medFormFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить'**
  String get medFormFailed;

  /// No description provided for @medFormCostHelp.
  ///
  /// In ru, this message translates to:
  /// **'Сумма попадёт в расходы фермы отдельной операцией.'**
  String get medFormCostHelp;

  /// No description provided for @medFormDosage.
  ///
  /// In ru, this message translates to:
  /// **'Дозировка'**
  String get medFormDosage;

  /// No description provided for @medFormEndedDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата окончания'**
  String get medFormEndedDate;

  /// No description provided for @medFormNotSet.
  ///
  /// In ru, this message translates to:
  /// **'Не указана'**
  String get medFormNotSet;

  /// No description provided for @medFormCostLabel.
  ///
  /// In ru, this message translates to:
  /// **'Затраты, ₽'**
  String get medFormCostLabel;

  /// No description provided for @commonNumberInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Введите число'**
  String get commonNumberInvalid;

  /// No description provided for @emptyNoRecordsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Записей нет'**
  String get emptyNoRecordsTitle;

  /// No description provided for @emptyNoRecordsBody.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте первую.'**
  String get emptyNoRecordsBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
