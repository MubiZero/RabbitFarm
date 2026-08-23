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

  /// No description provided for @errorOffline.
  ///
  /// In ru, this message translates to:
  /// **'Нет связи — проверьте интернет'**
  String get errorOffline;

  /// No description provided for @errorTimeout.
  ///
  /// In ru, this message translates to:
  /// **'Сервер не ответил, попробуйте ещё раз'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In ru, this message translates to:
  /// **'Нужно войти заново'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In ru, this message translates to:
  /// **'У вашей роли нет доступа к этому'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Запись не найдена — возможно, её удалили'**
  String get errorNotFound;

  /// No description provided for @errorInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Сервер не принял данные'**
  String get errorInvalid;

  /// No description provided for @errorServer.
  ///
  /// In ru, this message translates to:
  /// **'На сервере сбой, попробуйте позже'**
  String get errorServer;

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

  /// No description provided for @commonEmail.
  ///
  /// In ru, this message translates to:
  /// **'Почта'**
  String get commonEmail;

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

  /// No description provided for @navHerd.
  ///
  /// In ru, this message translates to:
  /// **'Стадо'**
  String get navHerd;

  /// No description provided for @navBreeding.
  ///
  /// In ru, this message translates to:
  /// **'Разведение'**
  String get navBreeding;

  /// No description provided for @navFarm.
  ///
  /// In ru, this message translates to:
  /// **'Хозяйство'**
  String get navFarm;

  /// No description provided for @navJournal.
  ///
  /// In ru, this message translates to:
  /// **'Журнал'**
  String get navJournal;

  /// No description provided for @navProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get navProfile;

  /// No description provided for @navRecord.
  ///
  /// In ru, this message translates to:
  /// **'Записать'**
  String get navRecord;

  /// No description provided for @quickRecordTreatment.
  ///
  /// In ru, this message translates to:
  /// **'Лечение'**
  String get quickRecordTreatment;

  /// No description provided for @quickRecordBreeding.
  ///
  /// In ru, this message translates to:
  /// **'Случка'**
  String get quickRecordBreeding;

  /// No description provided for @quickAddFeed.
  ///
  /// In ru, this message translates to:
  /// **'Приход корма'**
  String get quickAddFeed;

  /// No description provided for @quickRecordTransaction.
  ///
  /// In ru, this message translates to:
  /// **'Приход или расход'**
  String get quickRecordTransaction;

  /// No description provided for @quickGroupDaily.
  ///
  /// In ru, this message translates to:
  /// **'Каждый день'**
  String get quickGroupDaily;

  /// No description provided for @quickGroupHerd.
  ///
  /// In ru, this message translates to:
  /// **'Стадо'**
  String get quickGroupHerd;

  /// No description provided for @quickGroupFarm.
  ///
  /// In ru, this message translates to:
  /// **'Хозяйство'**
  String get quickGroupFarm;

  /// No description provided for @herdTitle.
  ///
  /// In ru, this message translates to:
  /// **'Стадо'**
  String get herdTitle;

  /// No description provided for @herdTabCages.
  ///
  /// In ru, this message translates to:
  /// **'Клетки'**
  String get herdTabCages;

  /// No description provided for @herdTabRabbits.
  ///
  /// In ru, this message translates to:
  /// **'Кролики'**
  String get herdTabRabbits;

  /// No description provided for @breedingCycleTitle.
  ///
  /// In ru, this message translates to:
  /// **'Разведение'**
  String get breedingCycleTitle;

  /// No description provided for @journalTitle.
  ///
  /// In ru, this message translates to:
  /// **'Журнал'**
  String get journalTitle;

  /// No description provided for @reportsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отчёты'**
  String get reportsTitle;

  /// No description provided for @farmTitle.
  ///
  /// In ru, this message translates to:
  /// **'Хозяйство'**
  String get farmTitle;

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

  /// No description provided for @commonNameMissing.
  ///
  /// In ru, this message translates to:
  /// **'Имя не указано'**
  String get commonNameMissing;

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

  /// No description provided for @commonActionFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось: {reason}'**
  String commonActionFailed(String reason);

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

  /// No description provided for @cageFormType.
  ///
  /// In ru, this message translates to:
  /// **'Тип клетки'**
  String get cageFormType;

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

  /// No description provided for @commonFilters.
  ///
  /// In ru, this message translates to:
  /// **'Фильтры'**
  String get commonFilters;

  /// No description provided for @commonApply.
  ///
  /// In ru, this message translates to:
  /// **'Применить'**
  String get commonApply;

  /// No description provided for @commonReset.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить'**
  String get commonReset;

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

  /// No description provided for @fieldRecipient.
  ///
  /// In ru, this message translates to:
  /// **'Кому'**
  String get fieldRecipient;

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

  /// No description provided for @commonSummary.
  ///
  /// In ru, this message translates to:
  /// **'Сводка'**
  String get commonSummary;

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

  /// No description provided for @feedsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Склад кормов'**
  String get feedsTitle;

  /// No description provided for @feedsAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить корм'**
  String get feedsAdd;

  /// No description provided for @feedsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Склад пуст'**
  String get feedsEmptyTitle;

  /// No description provided for @feedsEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Заведите корм, и приложение предупредит, когда он начнёт заканчиваться.'**
  String get feedsEmptyBody;

  /// No description provided for @feedsNoneInView.
  ///
  /// In ru, this message translates to:
  /// **'Под фильтры ничего не подошло'**
  String get feedsNoneInView;

  /// No description provided for @feedsNoneInViewBody.
  ///
  /// In ru, this message translates to:
  /// **'Снимите условия, чтобы увидеть весь склад.'**
  String get feedsNoneInViewBody;

  /// No description provided for @feedsFilterAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get feedsFilterAll;

  /// No description provided for @feedsFilterLowStock.
  ///
  /// In ru, this message translates to:
  /// **'На исходе'**
  String get feedsFilterLowStock;

  /// No description provided for @feedsFilterType.
  ///
  /// In ru, this message translates to:
  /// **'Тип корма'**
  String get feedsFilterType;

  /// No description provided for @feedsFilterAllTypes.
  ///
  /// In ru, this message translates to:
  /// **'Все типы'**
  String get feedsFilterAllTypes;

  /// No description provided for @feedsInStock.
  ///
  /// In ru, this message translates to:
  /// **'На складе'**
  String get feedsInStock;

  /// No description provided for @feedsMinStock.
  ///
  /// In ru, this message translates to:
  /// **'Минимум'**
  String get feedsMinStock;

  /// No description provided for @feedsLowStockWarning.
  ///
  /// In ru, this message translates to:
  /// **'Осталось меньше минимума'**
  String get feedsLowStockWarning;

  /// No description provided for @feedsRefill.
  ///
  /// In ru, this message translates to:
  /// **'Пополнить'**
  String get feedsRefill;

  /// No description provided for @feedsWriteOff.
  ///
  /// In ru, this message translates to:
  /// **'Списать'**
  String get feedsWriteOff;

  /// No description provided for @feedsRefillTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пополнить склад'**
  String get feedsRefillTitle;

  /// No description provided for @feedsWriteOffTitle.
  ///
  /// In ru, this message translates to:
  /// **'Списать со склада'**
  String get feedsWriteOffTitle;

  /// No description provided for @feedsCurrentStock.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас на складе: {amount}'**
  String feedsCurrentStock(String amount);

  /// No description provided for @feedsQuantity.
  ///
  /// In ru, this message translates to:
  /// **'Сколько'**
  String get feedsQuantity;

  /// No description provided for @feedsQuantityPositive.
  ///
  /// In ru, this message translates to:
  /// **'Введите количество больше нуля'**
  String get feedsQuantityPositive;

  /// No description provided for @feedsRefilled.
  ///
  /// In ru, this message translates to:
  /// **'Склад пополнен на {amount}'**
  String feedsRefilled(String amount);

  /// No description provided for @feedsWrittenOff.
  ///
  /// In ru, this message translates to:
  /// **'Списано {amount}'**
  String feedsWrittenOff(String amount);

  /// No description provided for @feedsAdjustFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось изменить остаток'**
  String get feedsAdjustFailed;

  /// No description provided for @feedsDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить корм?'**
  String get feedsDeleteTitle;

  /// No description provided for @feedsDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'«{name}» исчезнет со склада вместе с историей остатков.'**
  String feedsDeleteBody(String name);

  /// No description provided for @feedsDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Корм удалён'**
  String get feedsDeleted;

  /// No description provided for @feedsDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить корм'**
  String get feedsDeleteFailed;

  /// No description provided for @feedFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый корм'**
  String get feedFormNewTitle;

  /// No description provided for @feedFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Корм'**
  String get feedFormEditTitle;

  /// No description provided for @commonSectionMain.
  ///
  /// In ru, this message translates to:
  /// **'Основное'**
  String get commonSectionMain;

  /// No description provided for @feedFormSectionStock.
  ///
  /// In ru, this message translates to:
  /// **'Склад'**
  String get feedFormSectionStock;

  /// No description provided for @feedFormName.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get feedFormName;

  /// No description provided for @feedFormNameEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите название корма'**
  String get feedFormNameEmpty;

  /// No description provided for @feedFormType.
  ///
  /// In ru, this message translates to:
  /// **'Тип корма'**
  String get feedFormType;

  /// No description provided for @feedFormUnit.
  ///
  /// In ru, this message translates to:
  /// **'В чём считаем'**
  String get feedFormUnit;

  /// No description provided for @feedFormCurrentStock.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас на складе'**
  String get feedFormCurrentStock;

  /// No description provided for @feedFormMinStock.
  ///
  /// In ru, this message translates to:
  /// **'Предупреждать, когда останется'**
  String get feedFormMinStock;

  /// No description provided for @feedFormMinStockHelp.
  ///
  /// In ru, this message translates to:
  /// **'Ниже этого остатка корм попадёт в «Требует внимания» на главном экране.'**
  String get feedFormMinStockHelp;

  /// No description provided for @feedFormCost.
  ///
  /// In ru, this message translates to:
  /// **'Цена за единицу'**
  String get feedFormCost;

  /// No description provided for @feedFormRequired.
  ///
  /// In ru, this message translates to:
  /// **'Заполните поле'**
  String get feedFormRequired;

  /// No description provided for @feedFormNegative.
  ///
  /// In ru, this message translates to:
  /// **'Число не может быть отрицательным'**
  String get feedFormNegative;

  /// No description provided for @feedFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Корм добавлен на склад'**
  String get feedFormCreated;

  /// No description provided for @feedFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Корм обновлён'**
  String get feedFormUpdated;

  /// No description provided for @feedFormFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить корм'**
  String get feedFormFailed;

  /// No description provided for @feedingTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кормления'**
  String get feedingTitle;

  /// No description provided for @feedingAdd.
  ///
  /// In ru, this message translates to:
  /// **'Записать кормление'**
  String get feedingAdd;

  /// No description provided for @feedingEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Записей о кормлении нет'**
  String get feedingEmptyTitle;

  /// No description provided for @feedingEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Отмечайте кормления — расход корма будет списываться со склада сам.'**
  String get feedingEmptyBody;

  /// No description provided for @feedingNoneInView.
  ///
  /// In ru, this message translates to:
  /// **'За этот период записей нет'**
  String get feedingNoneInView;

  /// No description provided for @feedingNoneInViewBody.
  ///
  /// In ru, this message translates to:
  /// **'Выберите другой период или сбросьте фильтр.'**
  String get feedingNoneInViewBody;

  /// No description provided for @feedingUnknownFeed.
  ///
  /// In ru, this message translates to:
  /// **'Корм не указан'**
  String get feedingUnknownFeed;

  /// No description provided for @feedingForRabbit.
  ///
  /// In ru, this message translates to:
  /// **'Кролик {name}'**
  String feedingForRabbit(String name);

  /// No description provided for @feedingForCage.
  ///
  /// In ru, this message translates to:
  /// **'Клетка {number}'**
  String feedingForCage(String number);

  /// No description provided for @feedingForFarm.
  ///
  /// In ru, this message translates to:
  /// **'Всей ферме'**
  String get feedingForFarm;

  /// No description provided for @feedingEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get feedingEdit;

  /// No description provided for @feedingDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить запись?'**
  String get feedingDeleteTitle;

  /// No description provided for @feedingDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Запись о кормлении будет удалена. Списанный корм на склад не вернётся.'**
  String get feedingDeleteBody;

  /// No description provided for @feedingDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Запись удалена'**
  String get feedingDeleted;

  /// No description provided for @feedingDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить запись'**
  String get feedingDeleteFailed;

  /// No description provided for @commonPeriod.
  ///
  /// In ru, this message translates to:
  /// **'Период'**
  String get commonPeriod;

  /// No description provided for @feedingFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новое кормление'**
  String get feedingFormNewTitle;

  /// No description provided for @feedingFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кормление'**
  String get feedingFormEditTitle;

  /// No description provided for @feedingFormSectionWhom.
  ///
  /// In ru, this message translates to:
  /// **'Кого кормим'**
  String get feedingFormSectionWhom;

  /// No description provided for @feedingFormSectionWhat.
  ///
  /// In ru, this message translates to:
  /// **'Чем и сколько'**
  String get feedingFormSectionWhat;

  /// No description provided for @feedingFormModeRabbit.
  ///
  /// In ru, this message translates to:
  /// **'Одного кролика'**
  String get feedingFormModeRabbit;

  /// No description provided for @feedingFormModeCage.
  ///
  /// In ru, this message translates to:
  /// **'Всю клетку'**
  String get feedingFormModeCage;

  /// No description provided for @feedingFormCage.
  ///
  /// In ru, this message translates to:
  /// **'Клетка'**
  String get feedingFormCage;

  /// No description provided for @feedingFormCageRequired.
  ///
  /// In ru, this message translates to:
  /// **'Выберите клетку'**
  String get feedingFormCageRequired;

  /// No description provided for @feedingFormFeed.
  ///
  /// In ru, this message translates to:
  /// **'Корм'**
  String get feedingFormFeed;

  /// No description provided for @feedingFormFeedRequired.
  ///
  /// In ru, this message translates to:
  /// **'Выберите корм'**
  String get feedingFormFeedRequired;

  /// No description provided for @feedingFormQuantity.
  ///
  /// In ru, this message translates to:
  /// **'Сколько'**
  String get feedingFormQuantity;

  /// No description provided for @feedingFormQuantityRequired.
  ///
  /// In ru, this message translates to:
  /// **'Введите количество'**
  String get feedingFormQuantityRequired;

  /// No description provided for @feedingFormWhen.
  ///
  /// In ru, this message translates to:
  /// **'Когда'**
  String get feedingFormWhen;

  /// No description provided for @feedingFormNotes.
  ///
  /// In ru, this message translates to:
  /// **'Примечания'**
  String get feedingFormNotes;

  /// No description provided for @feedingFormStockLeft.
  ///
  /// In ru, this message translates to:
  /// **'осталось {amount}'**
  String feedingFormStockLeft(String amount);

  /// No description provided for @feedingFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Кормление записано'**
  String get feedingFormCreated;

  /// No description provided for @feedingFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Запись обновлена'**
  String get feedingFormUpdated;

  /// No description provided for @feedingFormFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить запись'**
  String get feedingFormFailed;

  /// No description provided for @feedingFormStockNote.
  ///
  /// In ru, this message translates to:
  /// **'Указанное количество спишется со склада.'**
  String get feedingFormStockNote;

  /// No description provided for @financeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Финансы'**
  String get financeTitle;

  /// No description provided for @financeAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить операцию'**
  String get financeAdd;

  /// No description provided for @financeEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Операций пока нет'**
  String get financeEmptyTitle;

  /// No description provided for @financeEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Записывайте доходы и расходы — приложение само посчитает прибыль фермы.'**
  String get financeEmptyBody;

  /// No description provided for @financeNoneInView.
  ///
  /// In ru, this message translates to:
  /// **'Под фильтры ничего не подошло'**
  String get financeNoneInView;

  /// No description provided for @financeNoneInViewBody.
  ///
  /// In ru, this message translates to:
  /// **'Снимите условия, чтобы увидеть всю ведомость.'**
  String get financeNoneInViewBody;

  /// No description provided for @financeIncome.
  ///
  /// In ru, this message translates to:
  /// **'Доходы'**
  String get financeIncome;

  /// No description provided for @financeExpenses.
  ///
  /// In ru, this message translates to:
  /// **'Расходы'**
  String get financeExpenses;

  /// No description provided for @financeBalance.
  ///
  /// In ru, this message translates to:
  /// **'Баланс'**
  String get financeBalance;

  /// No description provided for @financeSummaryPeriod.
  ///
  /// In ru, this message translates to:
  /// **'За весь период'**
  String get financeSummaryPeriod;

  /// No description provided for @financeSummaryFiltered.
  ///
  /// In ru, this message translates to:
  /// **'За выбранный период'**
  String get financeSummaryFiltered;

  /// No description provided for @financeAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get financeAll;

  /// No description provided for @financeOnlyIncome.
  ///
  /// In ru, this message translates to:
  /// **'Доходы'**
  String get financeOnlyIncome;

  /// No description provided for @financeOnlyExpenses.
  ///
  /// In ru, this message translates to:
  /// **'Расходы'**
  String get financeOnlyExpenses;

  /// No description provided for @financeCategory.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get financeCategory;

  /// No description provided for @financeType.
  ///
  /// In ru, this message translates to:
  /// **'Тип'**
  String get financeType;

  /// No description provided for @financeDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата'**
  String get financeDate;

  /// No description provided for @financeDescription.
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get financeDescription;

  /// No description provided for @financeTypeIncome.
  ///
  /// In ru, this message translates to:
  /// **'Доход'**
  String get financeTypeIncome;

  /// No description provided for @financeTypeExpense.
  ///
  /// In ru, this message translates to:
  /// **'Расход'**
  String get financeTypeExpense;

  /// No description provided for @financeDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить операцию?'**
  String get financeDeleteTitle;

  /// No description provided for @financeDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Операция исчезнет из ведомости без возможности вернуть.'**
  String get financeDeleteBody;

  /// No description provided for @financeDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Операция удалена'**
  String get financeDeleted;

  /// No description provided for @financeDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить операцию'**
  String get financeDeleteFailed;

  /// No description provided for @txFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая операция'**
  String get txFormNewTitle;

  /// No description provided for @txFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Операция'**
  String get txFormEditTitle;

  /// No description provided for @txFormSectionKind.
  ///
  /// In ru, this message translates to:
  /// **'Что за операция'**
  String get txFormSectionKind;

  /// No description provided for @commonSectionDetails.
  ///
  /// In ru, this message translates to:
  /// **'Подробности'**
  String get commonSectionDetails;

  /// No description provided for @txFormIncomeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Продажа, услуги'**
  String get txFormIncomeSubtitle;

  /// No description provided for @txFormExpenseSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Покупки, лечение, корма'**
  String get txFormExpenseSubtitle;

  /// No description provided for @txFormAmount.
  ///
  /// In ru, this message translates to:
  /// **'Сумма'**
  String get txFormAmount;

  /// No description provided for @txFormAmountEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите сумму'**
  String get txFormAmountEmpty;

  /// No description provided for @txFormAmountPositive.
  ///
  /// In ru, this message translates to:
  /// **'Сумма должна быть больше нуля'**
  String get txFormAmountPositive;

  /// No description provided for @txFormDate.
  ///
  /// In ru, this message translates to:
  /// **'Когда'**
  String get txFormDate;

  /// No description provided for @txFormRabbit.
  ///
  /// In ru, this message translates to:
  /// **'Связать с кроликом'**
  String get txFormRabbit;

  /// No description provided for @txFormRabbitHelp.
  ///
  /// In ru, this message translates to:
  /// **'Необязательно. Нужно, чтобы видеть доход и расходы по конкретному животному.'**
  String get txFormRabbitHelp;

  /// No description provided for @txFormDescription.
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get txFormDescription;

  /// No description provided for @txFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Операция записана'**
  String get txFormCreated;

  /// No description provided for @txFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Операция обновлена'**
  String get txFormUpdated;

  /// No description provided for @txFormFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить операцию'**
  String get txFormFailed;

  /// No description provided for @cagesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Клетки'**
  String get cagesTitle;

  /// No description provided for @cagesAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить клетку'**
  String get cagesAdd;

  /// No description provided for @cagesSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Номер или место'**
  String get cagesSearchHint;

  /// No description provided for @cagesOnlyAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Только свободные'**
  String get cagesOnlyAvailable;

  /// No description provided for @cagesEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Клеток пока нет'**
  String get cagesEmptyTitle;

  /// No description provided for @cagesEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Заведите клетки — по ним будет видно, куда селить кроликов и где есть место.'**
  String get cagesEmptyBody;

  /// No description provided for @cagesNothingFound.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не нашлось'**
  String get cagesNothingFound;

  /// No description provided for @cagesNothingFoundBody.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте запрос или снимите фильтры.'**
  String get cagesNothingFoundBody;

  /// No description provided for @cagesOccupancy.
  ///
  /// In ru, this message translates to:
  /// **'Занято {occupied} из {capacity}'**
  String cagesOccupancy(int occupied, int capacity);

  /// No description provided for @cagesLastCleaned.
  ///
  /// In ru, this message translates to:
  /// **'Убрана {date}'**
  String cagesLastCleaned(String date);

  /// No description provided for @cagesMarkCleaned.
  ///
  /// In ru, this message translates to:
  /// **'Отметить уборку'**
  String get cagesMarkCleaned;

  /// No description provided for @cagesCleaned.
  ///
  /// In ru, this message translates to:
  /// **'Уборка отмечена'**
  String get cagesCleaned;

  /// No description provided for @cagesCleanFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось отметить уборку'**
  String get cagesCleanFailed;

  /// No description provided for @cagesDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить клетку?'**
  String get cagesDeleteTitle;

  /// No description provided for @cagesDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Клетка {number} исчезнет из списка. Кролики из неё останутся без клетки.'**
  String cagesDeleteBody(String number);

  /// No description provided for @cagesDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Клетка удалена'**
  String get cagesDeleted;

  /// No description provided for @cagesDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить клетку'**
  String get cagesDeleteFailed;

  /// No description provided for @cagesFilterCondition.
  ///
  /// In ru, this message translates to:
  /// **'Состояние'**
  String get cagesFilterCondition;

  /// No description provided for @cageFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая клетка'**
  String get cageFormNewTitle;

  /// No description provided for @cageFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Клетка'**
  String get cageFormEditTitle;

  /// No description provided for @cageFormNumber.
  ///
  /// In ru, this message translates to:
  /// **'Номер'**
  String get cageFormNumber;

  /// No description provided for @cageFormNumberEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите номер клетки'**
  String get cageFormNumberEmpty;

  /// No description provided for @cageFormCapacity.
  ///
  /// In ru, this message translates to:
  /// **'Сколько кроликов помещается'**
  String get cageFormCapacity;

  /// No description provided for @cageFormCapacityInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Введите число больше нуля'**
  String get cageFormCapacityInvalid;

  /// No description provided for @cageFormCapacityGroup.
  ///
  /// In ru, this message translates to:
  /// **'В групповой клетке минимум два места'**
  String get cageFormCapacityGroup;

  /// No description provided for @cageFormSize.
  ///
  /// In ru, this message translates to:
  /// **'Размер'**
  String get cageFormSize;

  /// No description provided for @cageFormSizeHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, 100×60×45 см'**
  String get cageFormSizeHint;

  /// No description provided for @cageFormLocation.
  ///
  /// In ru, this message translates to:
  /// **'Место'**
  String get cageFormLocation;

  /// No description provided for @cageFormLocationHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, сарай, левый ряд'**
  String get cageFormLocationHint;

  /// No description provided for @cageFormNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get cageFormNotes;

  /// No description provided for @cageFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Клетка добавлена'**
  String get cageFormCreated;

  /// No description provided for @cageFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Клетка обновлена'**
  String get cageFormUpdated;

  /// No description provided for @cageFormFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить клетку'**
  String get cageFormFailed;

  /// No description provided for @rabbitsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кролики'**
  String get rabbitsTitle;

  /// No description provided for @rabbitsSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Кличка или номер бирки'**
  String get rabbitsSearchHint;

  /// No description provided for @rabbitsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кроликов пока нет'**
  String get rabbitsEmptyTitle;

  /// No description provided for @rabbitsEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Заведите первого кролика — от него пойдёт весь учёт: родословная, здоровье и приплод.'**
  String get rabbitsEmptyBody;

  /// No description provided for @rabbitsEmptyAction.
  ///
  /// In ru, this message translates to:
  /// **'Добавить кролика'**
  String get rabbitsEmptyAction;

  /// No description provided for @rabbitsNothingFound.
  ///
  /// In ru, this message translates to:
  /// **'Никого не нашлось'**
  String get rabbitsNothingFound;

  /// No description provided for @rabbitsNothingFoundBody.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте запрос или снимите фильтры.'**
  String get rabbitsNothingFoundBody;

  /// No description provided for @rabbitsFilterAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get rabbitsFilterAll;

  /// No description provided for @rabbitsFilterMales.
  ///
  /// In ru, this message translates to:
  /// **'Самцы'**
  String get rabbitsFilterMales;

  /// No description provided for @rabbitsFilterFemales.
  ///
  /// In ru, this message translates to:
  /// **'Самки'**
  String get rabbitsFilterFemales;

  /// No description provided for @rabbitsFilterActive.
  ///
  /// In ru, this message translates to:
  /// **'В работе'**
  String get rabbitsFilterActive;

  /// No description provided for @rabbitsFilterSold.
  ///
  /// In ru, this message translates to:
  /// **'Проданы'**
  String get rabbitsFilterSold;

  /// No description provided for @sexMale.
  ///
  /// In ru, this message translates to:
  /// **'Самец'**
  String get sexMale;

  /// No description provided for @sexFemale.
  ///
  /// In ru, this message translates to:
  /// **'Самка'**
  String get sexFemale;

  /// No description provided for @sexUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Пол не указан'**
  String get sexUnknown;

  /// No description provided for @rabbitNoTag.
  ///
  /// In ru, this message translates to:
  /// **'Без бирки'**
  String get rabbitNoTag;

  /// No description provided for @weightTitle.
  ///
  /// In ru, this message translates to:
  /// **'Взвешивания'**
  String get weightTitle;

  /// No description provided for @weightSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'{name}'**
  String weightSubtitle(String name);

  /// No description provided for @weightEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Взвешиваний пока нет'**
  String get weightEmptyTitle;

  /// No description provided for @weightEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Записывайте вес — по нему видно, растёт кролик или что-то не так.'**
  String get weightEmptyBody;

  /// No description provided for @weightAdd.
  ///
  /// In ru, this message translates to:
  /// **'Записать вес'**
  String get weightAdd;

  /// No description provided for @weightSummary.
  ///
  /// In ru, this message translates to:
  /// **'Сводка'**
  String get weightSummary;

  /// No description provided for @weightCurrent.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас'**
  String get weightCurrent;

  /// No description provided for @weightTrend.
  ///
  /// In ru, this message translates to:
  /// **'С прошлого раза'**
  String get weightTrend;

  /// No description provided for @weightTotalChange.
  ///
  /// In ru, this message translates to:
  /// **'За всё время'**
  String get weightTotalChange;

  /// No description provided for @weightHistory.
  ///
  /// In ru, this message translates to:
  /// **'История'**
  String get weightHistory;

  /// No description provided for @weightValue.
  ///
  /// In ru, this message translates to:
  /// **'Вес, кг'**
  String get weightValue;

  /// No description provided for @weightValueHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, 3,5'**
  String get weightValueHint;

  /// No description provided for @weightValueEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите вес'**
  String get weightValueEmpty;

  /// No description provided for @weightValuePositive.
  ///
  /// In ru, this message translates to:
  /// **'Вес должен быть больше нуля'**
  String get weightValuePositive;

  /// No description provided for @weightWhen.
  ///
  /// In ru, this message translates to:
  /// **'Когда взвесили'**
  String get weightWhen;

  /// No description provided for @weightNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get weightNotes;

  /// No description provided for @weightSaved.
  ///
  /// In ru, this message translates to:
  /// **'Вес записан'**
  String get weightSaved;

  /// No description provided for @weightSaveFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось записать вес'**
  String get weightSaveFailed;

  /// No description provided for @pedigreeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Родословная'**
  String get pedigreeTitle;

  /// No description provided for @rabbitDetailEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get rabbitDetailEdit;

  /// No description provided for @rabbitDetailDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить кролика?'**
  String get rabbitDetailDeleteTitle;

  /// No description provided for @rabbitDetailDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Вместе с {name} исчезнут его взвешивания, прививки и записи о лечении.'**
  String rabbitDetailDeleteBody(String name);

  /// No description provided for @rabbitDetailDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Кролик удалён'**
  String get rabbitDetailDeleted;

  /// No description provided for @rabbitDetailDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить кролика'**
  String get rabbitDetailDeleteFailed;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In ru, this message translates to:
  /// **'Внешний вид'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get settingsTheme;

  /// No description provided for @settingsAccent.
  ///
  /// In ru, this message translates to:
  /// **'Цвет акцента'**
  String get settingsAccent;

  /// No description provided for @settingsAbout.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In ru, this message translates to:
  /// **'Версия'**
  String get settingsVersion;

  /// No description provided for @settingsLogout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из аккаунта'**
  String get settingsLogout;

  /// No description provided for @settingsThemeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Как в системе'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get settingsThemeDark;

  /// No description provided for @joinTitle.
  ///
  /// In ru, this message translates to:
  /// **'Присоединиться к ферме'**
  String get joinTitle;

  /// No description provided for @joinIntro.
  ///
  /// In ru, this message translates to:
  /// **'Код выдаёт владелец фермы. После входа вы увидите её хозяйство — поголовье, корма и задачи.'**
  String get joinIntro;

  /// No description provided for @joinCode.
  ///
  /// In ru, this message translates to:
  /// **'Код приглашения'**
  String get joinCode;

  /// No description provided for @joinCodeHint.
  ///
  /// In ru, this message translates to:
  /// **'Введите код, который передал владелец'**
  String get joinCodeHint;

  /// No description provided for @joinName.
  ///
  /// In ru, this message translates to:
  /// **'Ваше имя'**
  String get joinName;

  /// No description provided for @joinNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Как к вам обращаться?'**
  String get joinNameHint;

  /// No description provided for @joinPassword.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get joinPassword;

  /// No description provided for @joinPasswordHint.
  ///
  /// In ru, this message translates to:
  /// **'Не короче 8 символов'**
  String get joinPasswordHint;

  /// No description provided for @joinPasswordShort.
  ///
  /// In ru, this message translates to:
  /// **'Пароль должен быть не короче 8 символов'**
  String get joinPasswordShort;

  /// No description provided for @joinSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Присоединиться'**
  String get joinSubmit;

  /// No description provided for @joinHaveAccount.
  ///
  /// In ru, this message translates to:
  /// **'У меня уже есть аккаунт'**
  String get joinHaveAccount;

  /// No description provided for @onboardWelcomeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ферма под рукой'**
  String get onboardWelcomeTitle;

  /// No description provided for @onboardWelcomeBody.
  ///
  /// In ru, this message translates to:
  /// **'Кролики, кормление, здоровье и деньги — в одном месте'**
  String get onboardWelcomeBody;

  /// No description provided for @onboardStart.
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get onboardStart;

  /// No description provided for @onboardHaveAccount.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт? Войти'**
  String get onboardHaveAccount;

  /// No description provided for @onboardFarmNameTitle.
  ///
  /// In ru, this message translates to:
  /// **'Как называется ваша ферма?'**
  String get onboardFarmNameTitle;

  /// No description provided for @onboardFarmNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, Ферма «Берёзки»'**
  String get onboardFarmNameHint;

  /// No description provided for @onboardNext.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get onboardNext;

  /// No description provided for @onboardSkip.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get onboardSkip;

  /// No description provided for @onboardFarmTypeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кто ведёт хозяйство?'**
  String get onboardFarmTypeTitle;

  /// No description provided for @onboardSoloTitle.
  ///
  /// In ru, this message translates to:
  /// **'Только я'**
  String get onboardSoloTitle;

  /// No description provided for @onboardSoloBody.
  ///
  /// In ru, this message translates to:
  /// **'Веду ферму сам'**
  String get onboardSoloBody;

  /// No description provided for @onboardTeamTitle.
  ///
  /// In ru, this message translates to:
  /// **'Я и работники'**
  String get onboardTeamTitle;

  /// No description provided for @onboardTeamBody.
  ///
  /// In ru, this message translates to:
  /// **'У каждого своя роль и свой доступ'**
  String get onboardTeamBody;

  /// No description provided for @onboardReadyNamed.
  ///
  /// In ru, this message translates to:
  /// **'«{name}»\nготова к работе!'**
  String onboardReadyNamed(String name);

  /// No description provided for @onboardReadyPlain.
  ///
  /// In ru, this message translates to:
  /// **'Ферма готова к работе!'**
  String get onboardReadyPlain;

  /// No description provided for @onboardReadyBody.
  ///
  /// In ru, this message translates to:
  /// **'Остальное настроим по ходу — приложение подскажет, что делать дальше'**
  String get onboardReadyBody;

  /// No description provided for @onboardRegister.
  ///
  /// In ru, this message translates to:
  /// **'Зарегистрироваться'**
  String get onboardRegister;

  /// No description provided for @splashTagline.
  ///
  /// In ru, this message translates to:
  /// **'Управление фермой'**
  String get splashTagline;

  /// No description provided for @registerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Своя ферма'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Заведите ферму — доступ работникам выдадите потом'**
  String get registerSubtitle;

  /// No description provided for @registerFullName.
  ///
  /// In ru, this message translates to:
  /// **'Имя и фамилия'**
  String get registerFullName;

  /// No description provided for @registerFullNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Как вас зовут'**
  String get registerFullNameHint;

  /// No description provided for @registerFullNameEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите имя'**
  String get registerFullNameEmpty;

  /// No description provided for @registerFullNameShort.
  ///
  /// In ru, this message translates to:
  /// **'Слишком коротко'**
  String get registerFullNameShort;

  /// No description provided for @registerEmailEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите почту'**
  String get registerEmailEmpty;

  /// No description provided for @registerEmailInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Похоже, в адресе опечатка'**
  String get registerEmailInvalid;

  /// No description provided for @registerPhone.
  ///
  /// In ru, this message translates to:
  /// **'Телефон, если нужен'**
  String get registerPhone;

  /// No description provided for @registerPasswordHint.
  ///
  /// In ru, this message translates to:
  /// **'Не короче 6 символов'**
  String get registerPasswordHint;

  /// No description provided for @registerPasswordEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Придумайте пароль'**
  String get registerPasswordEmpty;

  /// No description provided for @registerPasswordShort.
  ///
  /// In ru, this message translates to:
  /// **'Пароль должен быть не короче 6 символов'**
  String get registerPasswordShort;

  /// No description provided for @registerPasswordRepeat.
  ///
  /// In ru, this message translates to:
  /// **'Повторите пароль'**
  String get registerPasswordRepeat;

  /// No description provided for @registerPasswordRepeatEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите пароль ещё раз'**
  String get registerPasswordRepeatEmpty;

  /// No description provided for @registerPasswordMismatch.
  ///
  /// In ru, this message translates to:
  /// **'Пароли не совпадают'**
  String get registerPasswordMismatch;

  /// No description provided for @registerSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Завести ферму'**
  String get registerSubmit;

  /// No description provided for @registerHaveAccount.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт?'**
  String get registerHaveAccount;

  /// No description provided for @registerFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось зарегистрироваться'**
  String get registerFailed;

  /// No description provided for @birthsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Окролы'**
  String get birthsTitle;

  /// No description provided for @birthsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Окролов пока нет'**
  String get birthsEmptyTitle;

  /// No description provided for @birthsEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Запишите окрол — приложение само заведёт карточки на крольчат.'**
  String get birthsEmptyBody;

  /// No description provided for @birthsAdd.
  ///
  /// In ru, this message translates to:
  /// **'Записать окрол'**
  String get birthsAdd;

  /// No description provided for @birthsMotherUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Мать не указана'**
  String get birthsMotherUnknown;

  /// No description provided for @birthsMotherLine.
  ///
  /// In ru, this message translates to:
  /// **'Мать: {name}'**
  String birthsMotherLine(String name);

  /// No description provided for @birthsFromBreeding.
  ///
  /// In ru, this message translates to:
  /// **'По записи о случке'**
  String get birthsFromBreeding;

  /// No description provided for @birthsAlive.
  ///
  /// In ru, this message translates to:
  /// **'Живых'**
  String get birthsAlive;

  /// No description provided for @birthsDead.
  ///
  /// In ru, this message translates to:
  /// **'Мёртвых'**
  String get birthsDead;

  /// No description provided for @birthsWeaned.
  ///
  /// In ru, this message translates to:
  /// **'Отсажено'**
  String get birthsWeaned;

  /// No description provided for @birthsSurvival.
  ///
  /// In ru, this message translates to:
  /// **'Выживаемость'**
  String get birthsSurvival;

  /// No description provided for @birthsComplications.
  ///
  /// In ru, this message translates to:
  /// **'Осложнения'**
  String get birthsComplications;

  /// No description provided for @birthsDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить запись об окроле?'**
  String get birthsDeleteTitle;

  /// No description provided for @birthsDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Карточки крольчат останутся — исчезнет только запись о самом окроле.'**
  String get birthsDeleteBody;

  /// No description provided for @birthsDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Запись удалена'**
  String get birthsDeleted;

  /// No description provided for @birthsDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить запись'**
  String get birthsDeleteFailed;

  /// No description provided for @birthsCreateKits.
  ///
  /// In ru, this message translates to:
  /// **'Завести крольчат'**
  String get birthsCreateKits;

  /// No description provided for @birthsKitsDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Завести карточки крольчат?'**
  String get birthsKitsDialogTitle;

  /// No description provided for @birthsKitsDialogBody.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{Будет заведена {count} карточка} few{Будет заведено {count} карточки} many{Будет заведено {count} карточек} other{Будет заведено {count} карточки}}'**
  String birthsKitsDialogBody(int count);

  /// No description provided for @birthsNamePrefix.
  ///
  /// In ru, this message translates to:
  /// **'Начало клички'**
  String get birthsNamePrefix;

  /// No description provided for @birthsNamePrefixHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, Белка-'**
  String get birthsNamePrefixHint;

  /// No description provided for @birthsNamePreview.
  ///
  /// In ru, this message translates to:
  /// **'Получится: {first}, {second}, …'**
  String birthsNamePreview(String first, String second);

  /// No description provided for @birthsKitsCreated.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{Заведена {count} карточка} few{Заведено {count} карточки} many{Заведено {count} карточек} other{Заведено {count} карточки}}'**
  String birthsKitsCreated(int count);

  /// No description provided for @birthsKitsFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось завести карточки'**
  String get birthsKitsFailed;

  /// No description provided for @birthFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый окрол'**
  String get birthFormNewTitle;

  /// No description provided for @birthFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Окрол'**
  String get birthFormEditTitle;

  /// No description provided for @birthFormMother.
  ///
  /// In ru, this message translates to:
  /// **'Мать'**
  String get birthFormMother;

  /// No description provided for @birthFormDate.
  ///
  /// In ru, this message translates to:
  /// **'Когда окотилась'**
  String get birthFormDate;

  /// No description provided for @birthFormSectionLitter.
  ///
  /// In ru, this message translates to:
  /// **'Помёт'**
  String get birthFormSectionLitter;

  /// No description provided for @birthFormAliveLabel.
  ///
  /// In ru, this message translates to:
  /// **'Родилось живыми'**
  String get birthFormAliveLabel;

  /// No description provided for @birthFormDeadLabel.
  ///
  /// In ru, this message translates to:
  /// **'Родилось мёртвыми'**
  String get birthFormDeadLabel;

  /// No description provided for @birthFormAliveEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите количество'**
  String get birthFormAliveEmpty;

  /// No description provided for @birthFormComplications.
  ///
  /// In ru, this message translates to:
  /// **'Осложнения'**
  String get birthFormComplications;

  /// No description provided for @birthFormComplicationsHint.
  ///
  /// In ru, this message translates to:
  /// **'Опишите, если что-то пошло не так'**
  String get birthFormComplicationsHint;

  /// No description provided for @birthFormNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get birthFormNotes;

  /// No description provided for @birthFormAutoKits.
  ///
  /// In ru, this message translates to:
  /// **'Сразу завести карточки крольчат'**
  String get birthFormAutoKits;

  /// No description provided for @birthFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Окрол записан'**
  String get birthFormCreated;

  /// No description provided for @birthFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Запись обновлена'**
  String get birthFormUpdated;

  /// No description provided for @birthFormFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить запись'**
  String get birthFormFailed;

  /// No description provided for @breedsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Породы'**
  String get breedsTitle;

  /// No description provided for @breedsSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Название породы'**
  String get breedsSearchHint;

  /// No description provided for @breedsAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить породу'**
  String get breedsAdd;

  /// No description provided for @breedsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пород пока нет'**
  String get breedsEmptyTitle;

  /// No description provided for @breedsEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Заведите породы — по ним удобно подбирать пары и сравнивать привесы.'**
  String get breedsEmptyBody;

  /// No description provided for @breedsNothingFound.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не нашлось'**
  String get breedsNothingFound;

  /// No description provided for @breedsNothingFoundBody.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте запрос.'**
  String get breedsNothingFoundBody;

  /// No description provided for @breedsDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить породу?'**
  String get breedsDeleteTitle;

  /// No description provided for @breedsDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'«{name}» исчезнет из справочника. Кролики этой породы останутся, но без неё.'**
  String breedsDeleteBody(String name);

  /// No description provided for @breedsDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Порода удалена'**
  String get breedsDeleted;

  /// No description provided for @breedsDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить породу'**
  String get breedsDeleteFailed;

  /// No description provided for @breedPurposeMeat.
  ///
  /// In ru, this message translates to:
  /// **'Мясная'**
  String get breedPurposeMeat;

  /// No description provided for @breedPurposeFur.
  ///
  /// In ru, this message translates to:
  /// **'Пуховая'**
  String get breedPurposeFur;

  /// No description provided for @breedPurposeDecorative.
  ///
  /// In ru, this message translates to:
  /// **'Декоративная'**
  String get breedPurposeDecorative;

  /// No description provided for @breedPurposeCombined.
  ///
  /// In ru, this message translates to:
  /// **'Мясо-шкурковая'**
  String get breedPurposeCombined;

  /// No description provided for @breedFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая порода'**
  String get breedFormNewTitle;

  /// No description provided for @breedFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Порода'**
  String get breedFormEditTitle;

  /// No description provided for @breedFormName.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get breedFormName;

  /// No description provided for @breedFormNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, Калифорнийский'**
  String get breedFormNameHint;

  /// No description provided for @breedFormNameEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите название породы'**
  String get breedFormNameEmpty;

  /// No description provided for @breedFormPurpose.
  ///
  /// In ru, this message translates to:
  /// **'Для чего разводят'**
  String get breedFormPurpose;

  /// No description provided for @breedFormDescription.
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get breedFormDescription;

  /// No description provided for @breedFormDescriptionHint.
  ///
  /// In ru, this message translates to:
  /// **'Чем эта порода отличается'**
  String get breedFormDescriptionHint;

  /// No description provided for @breedFormSectionTraits.
  ///
  /// In ru, this message translates to:
  /// **'Характеристики'**
  String get breedFormSectionTraits;

  /// No description provided for @breedFormWeight.
  ///
  /// In ru, this message translates to:
  /// **'Средний вес, кг'**
  String get breedFormWeight;

  /// No description provided for @breedFormWeightHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, 4,5'**
  String get breedFormWeightHint;

  /// No description provided for @breedFormLitter.
  ///
  /// In ru, this message translates to:
  /// **'Обычный размер помёта'**
  String get breedFormLitter;

  /// No description provided for @breedFormLitterHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, 8'**
  String get breedFormLitterHint;

  /// No description provided for @breedFormLitterSuffix.
  ///
  /// In ru, this message translates to:
  /// **'крольчат'**
  String get breedFormLitterSuffix;

  /// No description provided for @breedFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Порода добавлена'**
  String get breedFormCreated;

  /// No description provided for @breedFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Порода обновлена'**
  String get breedFormUpdated;

  /// No description provided for @breedFormFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить породу'**
  String get breedFormFailed;

  /// No description provided for @breedingDetailTitle.
  ///
  /// In ru, this message translates to:
  /// **'Случка'**
  String get breedingDetailTitle;

  /// No description provided for @breedingStatus.
  ///
  /// In ru, this message translates to:
  /// **'Статус'**
  String get breedingStatus;

  /// No description provided for @breedingParents.
  ///
  /// In ru, this message translates to:
  /// **'Пара'**
  String get breedingParents;

  /// No description provided for @breedingTag.
  ///
  /// In ru, this message translates to:
  /// **'Бирка {tag}'**
  String breedingTag(String tag);

  /// No description provided for @breedingDates.
  ///
  /// In ru, this message translates to:
  /// **'Даты'**
  String get breedingDates;

  /// No description provided for @breedingDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата случки'**
  String get breedingDate;

  /// No description provided for @breedingExpected.
  ///
  /// In ru, this message translates to:
  /// **'Ожидаемый окрол'**
  String get breedingExpected;

  /// No description provided for @breedingPalpation.
  ///
  /// In ru, this message translates to:
  /// **'Дата прощупывания'**
  String get breedingPalpation;

  /// No description provided for @breedingPregnancy.
  ///
  /// In ru, this message translates to:
  /// **'Беременность'**
  String get breedingPregnancy;

  /// No description provided for @breedingPregnancyYes.
  ///
  /// In ru, this message translates to:
  /// **'Подтверждена'**
  String get breedingPregnancyYes;

  /// No description provided for @breedingPregnancyNo.
  ///
  /// In ru, this message translates to:
  /// **'Не подтверждена'**
  String get breedingPregnancyNo;

  /// No description provided for @breedingNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get breedingNotes;

  /// No description provided for @breedingRegisterBirth.
  ///
  /// In ru, this message translates to:
  /// **'Записать окрол'**
  String get breedingRegisterBirth;

  /// No description provided for @breedingDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить запись о случке?'**
  String get breedingDeleteTitle;

  /// No description provided for @breedingDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Вернуть её будет нельзя.'**
  String get breedingDeleteBody;

  /// No description provided for @breedingDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Запись удалена'**
  String get breedingDeleted;

  /// No description provided for @breedingDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить запись'**
  String get breedingDeleteFailed;

  /// No description provided for @breedingFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая случка'**
  String get breedingFormNewTitle;

  /// No description provided for @breedingFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Случка'**
  String get breedingFormEditTitle;

  /// No description provided for @breedingFormPrefilled.
  ///
  /// In ru, this message translates to:
  /// **'Пара подставлена из подбора пар'**
  String get breedingFormPrefilled;

  /// No description provided for @breedingFormMale.
  ///
  /// In ru, this message translates to:
  /// **'Самец'**
  String get breedingFormMale;

  /// No description provided for @breedingFormFemale.
  ///
  /// In ru, this message translates to:
  /// **'Самка'**
  String get breedingFormFemale;

  /// No description provided for @breedingFormMaleRequired.
  ///
  /// In ru, this message translates to:
  /// **'Выберите самца'**
  String get breedingFormMaleRequired;

  /// No description provided for @breedingFormFemaleRequired.
  ///
  /// In ru, this message translates to:
  /// **'Выберите самку'**
  String get breedingFormFemaleRequired;

  /// No description provided for @breedingFormNotesHint.
  ///
  /// In ru, this message translates to:
  /// **'Что стоит запомнить об этой случке'**
  String get breedingFormNotesHint;

  /// No description provided for @breedingFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Случка записана'**
  String get breedingFormCreated;

  /// No description provided for @breedingFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Запись обновлена'**
  String get breedingFormUpdated;

  /// No description provided for @breedingFormFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить запись'**
  String get breedingFormFailed;

  /// No description provided for @plannerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Подбор пар'**
  String get plannerTitle;

  /// No description provided for @plannerIntro.
  ///
  /// In ru, this message translates to:
  /// **'Выберите самца и самку — приложение посмотрит родословную и скажет, насколько они в родстве.'**
  String get plannerIntro;

  /// No description provided for @plannerAnalysisFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось разобрать родословную'**
  String get plannerAnalysisFailed;

  /// No description provided for @plannerResults.
  ///
  /// In ru, this message translates to:
  /// **'Что получилось'**
  String get plannerResults;

  /// No description provided for @plannerCoefficient.
  ///
  /// In ru, this message translates to:
  /// **'Степень родства'**
  String get plannerCoefficient;

  /// No description provided for @plannerCommonAncestors.
  ///
  /// In ru, this message translates to:
  /// **'Общие предки'**
  String get plannerCommonAncestors;

  /// No description provided for @plannerGenerations.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} поколение} few{{count} поколения} many{{count} поколений} other{{count} поколения}} назад'**
  String plannerGenerations(int count);

  /// No description provided for @plannerAdvice.
  ///
  /// In ru, this message translates to:
  /// **'Что делать'**
  String get plannerAdvice;

  /// No description provided for @plannerPickBoth.
  ///
  /// In ru, this message translates to:
  /// **'Выберите обоих'**
  String get plannerPickBoth;

  /// No description provided for @plannerPlanned.
  ///
  /// In ru, this message translates to:
  /// **'Случка запланирована'**
  String get plannerPlanned;

  /// No description provided for @plannerPlan.
  ///
  /// In ru, this message translates to:
  /// **'Запланировать случку'**
  String get plannerPlan;

  /// No description provided for @plannerPedigreeFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить родословную'**
  String get plannerPedigreeFailed;

  /// No description provided for @staffTitle.
  ///
  /// In ru, this message translates to:
  /// **'Работники'**
  String get staffTitle;

  /// No description provided for @staffInvite.
  ///
  /// In ru, this message translates to:
  /// **'Пригласить'**
  String get staffInvite;

  /// No description provided for @staffOwner.
  ///
  /// In ru, this message translates to:
  /// **'Владелец'**
  String get staffOwner;

  /// No description provided for @staffMembers.
  ///
  /// In ru, this message translates to:
  /// **'Сотрудники'**
  String get staffMembers;

  /// No description provided for @staffEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'На ферме пока только вы. Пригласите помощника — он получит доступ к этому же хозяйству.'**
  String get staffEmptyBody;

  /// No description provided for @staffInvitesFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить приглашения'**
  String get staffInvitesFailed;

  /// No description provided for @staffPendingInvites.
  ///
  /// In ru, this message translates to:
  /// **'Ждут ответа'**
  String get staffPendingInvites;

  /// No description provided for @staffAccessClosed.
  ///
  /// In ru, this message translates to:
  /// **'Доступ для {name} закрыт'**
  String staffAccessClosed(String name);

  /// No description provided for @staffSaved.
  ///
  /// In ru, this message translates to:
  /// **'Изменения сохранены'**
  String get staffSaved;

  /// No description provided for @staffResetPasswordTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить пароль?'**
  String get staffResetPasswordTitle;

  /// No description provided for @staffResetPasswordBody.
  ///
  /// In ru, this message translates to:
  /// **'Прежний пароль перестанет работать. Взамен приложение выдаст временный — его нужно передать человеку.'**
  String get staffResetPasswordBody;

  /// No description provided for @staffReset.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить'**
  String get staffReset;

  /// No description provided for @staffTempPassword.
  ///
  /// In ru, this message translates to:
  /// **'Временный пароль'**
  String get staffTempPassword;

  /// No description provided for @staffTempPasswordBody.
  ///
  /// In ru, this message translates to:
  /// **'Передайте пароль {name}. Второй раз он не покажется — при необходимости сбросьте ещё раз.'**
  String staffTempPasswordBody(String name);

  /// No description provided for @staffRevokeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отозвать приглашение?'**
  String get staffRevokeTitle;

  /// No description provided for @staffRevokeBody.
  ///
  /// In ru, this message translates to:
  /// **'Код для {email} перестанет работать. Выписать новый можно в любой момент.'**
  String staffRevokeBody(String email);

  /// No description provided for @staffKeep.
  ///
  /// In ru, this message translates to:
  /// **'Оставить'**
  String get staffKeep;

  /// No description provided for @staffRevoke.
  ///
  /// In ru, this message translates to:
  /// **'Отозвать'**
  String get staffRevoke;

  /// No description provided for @staffRevoked.
  ///
  /// In ru, this message translates to:
  /// **'Приглашение отозвано'**
  String get staffRevoked;

  /// No description provided for @staffInviteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пригласить на ферму'**
  String get staffInviteTitle;

  /// No description provided for @staffInviteEmailHint.
  ///
  /// In ru, this message translates to:
  /// **'На эту почту человек и будет входить'**
  String get staffInviteEmailHint;

  /// No description provided for @staffRole.
  ///
  /// In ru, this message translates to:
  /// **'Роль'**
  String get staffRole;

  /// No description provided for @staffIssueCode.
  ///
  /// In ru, this message translates to:
  /// **'Выписать код'**
  String get staffIssueCode;

  /// No description provided for @staffInviteCode.
  ///
  /// In ru, this message translates to:
  /// **'Код приглашения'**
  String get staffInviteCode;

  /// No description provided for @staffInviteCodeBody.
  ///
  /// In ru, this message translates to:
  /// **'Передайте этот код {email} любым удобным способом. Второй раз он не покажется: сервер хранит только его отпечаток.'**
  String staffInviteCodeBody(String email);

  /// No description provided for @staffValidUntil.
  ///
  /// In ru, this message translates to:
  /// **'Действует до {date}'**
  String staffValidUntil(String date);

  /// No description provided for @staffCopied.
  ///
  /// In ru, this message translates to:
  /// **'Скопировано'**
  String get staffCopied;

  /// No description provided for @staffCopy.
  ///
  /// In ru, this message translates to:
  /// **'Скопировать'**
  String get staffCopy;

  /// No description provided for @staffMakeManager.
  ///
  /// In ru, this message translates to:
  /// **'Сделать управляющим'**
  String get staffMakeManager;

  /// No description provided for @staffMakeWorker.
  ///
  /// In ru, this message translates to:
  /// **'Сделать работником'**
  String get staffMakeWorker;

  /// No description provided for @staffResetPassword.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить пароль'**
  String get staffResetPassword;

  /// No description provided for @staffOpenAccess.
  ///
  /// In ru, this message translates to:
  /// **'Открыть доступ'**
  String get staffOpenAccess;

  /// No description provided for @staffCloseAccess.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть доступ'**
  String get staffCloseAccess;

  /// No description provided for @rabbitTapToZoom.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите, чтобы рассмотреть'**
  String get rabbitTapToZoom;

  /// No description provided for @rabbitTagLine.
  ///
  /// In ru, this message translates to:
  /// **'Бирка {tag}'**
  String rabbitTagLine(String tag);

  /// No description provided for @rabbitMainInfo.
  ///
  /// In ru, this message translates to:
  /// **'Главное'**
  String get rabbitMainInfo;

  /// No description provided for @rabbitBreed.
  ///
  /// In ru, this message translates to:
  /// **'Порода'**
  String get rabbitBreed;

  /// No description provided for @rabbitBreedUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Не указана'**
  String get rabbitBreedUnknown;

  /// No description provided for @rabbitSex.
  ///
  /// In ru, this message translates to:
  /// **'Пол'**
  String get rabbitSex;

  /// No description provided for @rabbitAge.
  ///
  /// In ru, this message translates to:
  /// **'Возраст'**
  String get rabbitAge;

  /// No description provided for @rabbitBirthDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата рождения'**
  String get rabbitBirthDate;

  /// No description provided for @rabbitColor.
  ///
  /// In ru, this message translates to:
  /// **'Окрас'**
  String get rabbitColor;

  /// No description provided for @rabbitWeight.
  ///
  /// In ru, this message translates to:
  /// **'Вес'**
  String get rabbitWeight;

  /// No description provided for @rabbitQuickActions.
  ///
  /// In ru, this message translates to:
  /// **'Что можно посмотреть'**
  String get rabbitQuickActions;

  /// No description provided for @rabbitWeightHistory.
  ///
  /// In ru, this message translates to:
  /// **'История взвешиваний'**
  String get rabbitWeightHistory;

  /// No description provided for @rabbitPedigree.
  ///
  /// In ru, this message translates to:
  /// **'Родословная'**
  String get rabbitPedigree;

  /// No description provided for @rabbitStatus.
  ///
  /// In ru, this message translates to:
  /// **'Статус'**
  String get rabbitStatus;

  /// No description provided for @rabbitCondition.
  ///
  /// In ru, this message translates to:
  /// **'Состояние'**
  String get rabbitCondition;

  /// No description provided for @rabbitPurpose.
  ///
  /// In ru, this message translates to:
  /// **'Назначение'**
  String get rabbitPurpose;

  /// No description provided for @rabbitPlacement.
  ///
  /// In ru, this message translates to:
  /// **'Где живёт'**
  String get rabbitPlacement;

  /// No description provided for @rabbitCage.
  ///
  /// In ru, this message translates to:
  /// **'Клетка'**
  String get rabbitCage;

  /// No description provided for @rabbitLocation.
  ///
  /// In ru, this message translates to:
  /// **'Место'**
  String get rabbitLocation;

  /// No description provided for @rabbitParents.
  ///
  /// In ru, this message translates to:
  /// **'Родители'**
  String get rabbitParents;

  /// No description provided for @rabbitFather.
  ///
  /// In ru, this message translates to:
  /// **'Отец'**
  String get rabbitFather;

  /// No description provided for @rabbitMother.
  ///
  /// In ru, this message translates to:
  /// **'Мать'**
  String get rabbitMother;

  /// No description provided for @rabbitNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get rabbitNotes;

  /// No description provided for @rabbitDates.
  ///
  /// In ru, this message translates to:
  /// **'Записи'**
  String get rabbitDates;

  /// No description provided for @rabbitCreatedAt.
  ///
  /// In ru, this message translates to:
  /// **'Заведён'**
  String get rabbitCreatedAt;

  /// No description provided for @rabbitUpdatedAt.
  ///
  /// In ru, this message translates to:
  /// **'Изменён'**
  String get rabbitUpdatedAt;

  /// No description provided for @purposeBreeding.
  ///
  /// In ru, this message translates to:
  /// **'На развод'**
  String get purposeBreeding;

  /// No description provided for @purposeMeat.
  ///
  /// In ru, this message translates to:
  /// **'На мясо'**
  String get purposeMeat;

  /// No description provided for @purposeFur.
  ///
  /// In ru, this message translates to:
  /// **'На мех'**
  String get purposeFur;

  /// No description provided for @purposeSale.
  ///
  /// In ru, this message translates to:
  /// **'На продажу'**
  String get purposeSale;

  /// No description provided for @purposePet.
  ///
  /// In ru, this message translates to:
  /// **'Питомец'**
  String get purposePet;

  /// No description provided for @rabbitFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый кролик'**
  String get rabbitFormNewTitle;

  /// No description provided for @rabbitFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кролик'**
  String get rabbitFormEditTitle;

  /// No description provided for @rabbitFormPhotoAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить фото'**
  String get rabbitFormPhotoAdd;

  /// No description provided for @rabbitFormPhotoChange.
  ///
  /// In ru, this message translates to:
  /// **'Изменить фото'**
  String get rabbitFormPhotoChange;

  /// No description provided for @rabbitFormPhotoGallery.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать из галереи'**
  String get rabbitFormPhotoGallery;

  /// No description provided for @rabbitFormPhotoCamera.
  ///
  /// In ru, this message translates to:
  /// **'Снять на камеру'**
  String get rabbitFormPhotoCamera;

  /// No description provided for @rabbitFormPhotoRemove.
  ///
  /// In ru, this message translates to:
  /// **'Убрать фото'**
  String get rabbitFormPhotoRemove;

  /// No description provided for @rabbitFormPhotoFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось взять фото'**
  String get rabbitFormPhotoFailed;

  /// No description provided for @rabbitFormName.
  ///
  /// In ru, this message translates to:
  /// **'Кличка'**
  String get rabbitFormName;

  /// No description provided for @rabbitFormNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Как зовут'**
  String get rabbitFormNameHint;

  /// No description provided for @rabbitFormNameEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите кличку'**
  String get rabbitFormNameEmpty;

  /// No description provided for @rabbitFormTag.
  ///
  /// In ru, this message translates to:
  /// **'Номер бирки'**
  String get rabbitFormTag;

  /// No description provided for @rabbitFormTagEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите номер бирки'**
  String get rabbitFormTagEmpty;

  /// No description provided for @rabbitFormBreedRequired.
  ///
  /// In ru, this message translates to:
  /// **'Выберите породу'**
  String get rabbitFormBreedRequired;

  /// No description provided for @rabbitFormBreedsFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить породы'**
  String get rabbitFormBreedsFailed;

  /// No description provided for @rabbitFormColor.
  ///
  /// In ru, this message translates to:
  /// **'Окрас'**
  String get rabbitFormColor;

  /// No description provided for @rabbitFormColorHint.
  ///
  /// In ru, this message translates to:
  /// **'Серый, белый, чёрный…'**
  String get rabbitFormColorHint;

  /// No description provided for @rabbitFormWeight.
  ///
  /// In ru, this message translates to:
  /// **'Вес, кг'**
  String get rabbitFormWeight;

  /// No description provided for @rabbitFormNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get rabbitFormNotes;

  /// No description provided for @rabbitFormNotesHint.
  ///
  /// In ru, this message translates to:
  /// **'Что стоит помнить об этом кролике'**
  String get rabbitFormNotesHint;

  /// No description provided for @rabbitFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Кролик добавлен'**
  String get rabbitFormCreated;

  /// No description provided for @rabbitFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Данные обновлены'**
  String get rabbitFormUpdated;

  /// No description provided for @rabbitFormFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить'**
  String get rabbitFormFailed;

  /// No description provided for @rabbitFormLoadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить кролика'**
  String get rabbitFormLoadFailed;

  /// No description provided for @statusHealthy.
  ///
  /// In ru, this message translates to:
  /// **'Здоров'**
  String get statusHealthy;

  /// No description provided for @statusSick.
  ///
  /// In ru, this message translates to:
  /// **'Болен'**
  String get statusSick;

  /// No description provided for @statusQuarantine.
  ///
  /// In ru, this message translates to:
  /// **'Карантин'**
  String get statusQuarantine;

  /// No description provided for @statusPregnant.
  ///
  /// In ru, this message translates to:
  /// **'Беременна'**
  String get statusPregnant;

  /// No description provided for @statusSold.
  ///
  /// In ru, this message translates to:
  /// **'Продан'**
  String get statusSold;

  /// No description provided for @statusDead.
  ///
  /// In ru, this message translates to:
  /// **'Погиб'**
  String get statusDead;

  /// No description provided for @purposeShow.
  ///
  /// In ru, this message translates to:
  /// **'На выставку'**
  String get purposeShow;

  /// No description provided for @tourSkip.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get tourSkip;

  /// No description provided for @tourNext.
  ///
  /// In ru, this message translates to:
  /// **'Дальше'**
  String get tourNext;

  /// No description provided for @tourDone.
  ///
  /// In ru, this message translates to:
  /// **'Понятно'**
  String get tourDone;

  /// No description provided for @periodDays.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} день} few{{count} дня} many{{count} дней} other{{count} дня}}'**
  String periodDays(int count);

  /// No description provided for @periodMonths.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} месяц} few{{count} месяца} many{{count} месяцев} other{{count} месяца}}'**
  String periodMonths(int count);

  /// No description provided for @periodYear.
  ///
  /// In ru, this message translates to:
  /// **'Год'**
  String get periodYear;

  /// No description provided for @periodAll.
  ///
  /// In ru, this message translates to:
  /// **'Всё время'**
  String get periodAll;

  /// No description provided for @statusInactive.
  ///
  /// In ru, this message translates to:
  /// **'Неактивен'**
  String get statusInactive;

  /// No description provided for @pedigreeSelf.
  ///
  /// In ru, this message translates to:
  /// **'Кролик'**
  String get pedigreeSelf;

  /// No description provided for @pedigreeGrandparents.
  ///
  /// In ru, this message translates to:
  /// **'Бабушки и дедушки'**
  String get pedigreeGrandparents;

  /// No description provided for @pedigreeFathersParents.
  ///
  /// In ru, this message translates to:
  /// **'Родители отца'**
  String get pedigreeFathersParents;

  /// No description provided for @pedigreeMothersParents.
  ///
  /// In ru, this message translates to:
  /// **'Родители матери'**
  String get pedigreeMothersParents;

  /// No description provided for @pedigreeHint.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите на карточку, чтобы открыть кролика'**
  String get pedigreeHint;

  /// No description provided for @pedigreeGrandfather.
  ///
  /// In ru, this message translates to:
  /// **'Дедушка'**
  String get pedigreeGrandfather;

  /// No description provided for @pedigreeGrandmother.
  ///
  /// In ru, this message translates to:
  /// **'Бабушка'**
  String get pedigreeGrandmother;

  /// No description provided for @chartNoData.
  ///
  /// In ru, this message translates to:
  /// **'Пока нечего показать'**
  String get chartNoData;

  /// No description provided for @chartWeight.
  ///
  /// In ru, this message translates to:
  /// **'График веса'**
  String get chartWeight;

  /// No description provided for @feedStatsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Склад в цифрах'**
  String get feedStatsTitle;

  /// No description provided for @feedStatsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Склад пока пуст'**
  String get feedStatsEmptyTitle;

  /// No description provided for @feedStatsEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Заведите корма — здесь появится состав запаса, его стоимость и предупреждения об остатках.'**
  String get feedStatsEmptyBody;

  /// No description provided for @feedStatsPositions.
  ///
  /// In ru, this message translates to:
  /// **'Видов корма'**
  String get feedStatsPositions;

  /// No description provided for @feedStatsLow.
  ///
  /// In ru, this message translates to:
  /// **'На исходе'**
  String get feedStatsLow;

  /// No description provided for @feedStatsValue.
  ///
  /// In ru, this message translates to:
  /// **'Стоимость запаса'**
  String get feedStatsValue;

  /// No description provided for @feedStatsByType.
  ///
  /// In ru, this message translates to:
  /// **'Состав по типам'**
  String get feedStatsByType;

  /// No description provided for @feedStatsLowList.
  ///
  /// In ru, this message translates to:
  /// **'Остатки на исходе'**
  String get feedStatsLowList;

  /// No description provided for @feedStatsAllGood.
  ///
  /// In ru, this message translates to:
  /// **'Запасов хватает по всем позициям'**
  String get feedStatsAllGood;

  /// No description provided for @feedStatsMinimum.
  ///
  /// In ru, this message translates to:
  /// **'минимум {amount}'**
  String feedStatsMinimum(String amount);

  /// No description provided for @feedingStatsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кормления в цифрах'**
  String get feedingStatsTitle;

  /// No description provided for @feedingStatsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'За этот период кормлений не было'**
  String get feedingStatsEmptyTitle;

  /// No description provided for @feedingStatsEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Выберите период шире или запишите кормление — расход корма и затраты посчитаются сами.'**
  String get feedingStatsEmptyBody;

  /// No description provided for @feedingStatsCount.
  ///
  /// In ru, this message translates to:
  /// **'Кормлений'**
  String get feedingStatsCount;

  /// No description provided for @feedingStatsCost.
  ///
  /// In ru, this message translates to:
  /// **'Затраты на корм'**
  String get feedingStatsCost;

  /// No description provided for @feedingStatsGiven.
  ///
  /// In ru, this message translates to:
  /// **'Выдано'**
  String get feedingStatsGiven;

  /// No description provided for @feedingStatsByFeed.
  ///
  /// In ru, this message translates to:
  /// **'По кормам'**
  String get feedingStatsByFeed;

  /// No description provided for @feedingStatsChartTitle.
  ///
  /// In ru, this message translates to:
  /// **'Расход по типам корма, {unit}'**
  String feedingStatsChartTitle(String unit);

  /// No description provided for @feedingStatsChartTitlePlain.
  ///
  /// In ru, this message translates to:
  /// **'Расход по типам корма'**
  String get feedingStatsChartTitlePlain;

  /// No description provided for @financeStatsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Финансы в цифрах'**
  String get financeStatsTitle;

  /// No description provided for @financeStatsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'За этот период операций не было'**
  String get financeStatsEmptyTitle;

  /// No description provided for @financeStatsEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Выберите период шире или запишите первую операцию — итоги посчитаются сами.'**
  String get financeStatsEmptyBody;

  /// No description provided for @financeProfit.
  ///
  /// In ru, this message translates to:
  /// **'Прибыль'**
  String get financeProfit;

  /// No description provided for @financeLoss.
  ///
  /// In ru, this message translates to:
  /// **'Убыток'**
  String get financeLoss;

  /// No description provided for @financeIncomeByCategory.
  ///
  /// In ru, this message translates to:
  /// **'Доходы по категориям'**
  String get financeIncomeByCategory;

  /// No description provided for @financeExpensesByCategory.
  ///
  /// In ru, this message translates to:
  /// **'Расходы по категориям'**
  String get financeExpensesByCategory;

  /// No description provided for @financeRecent.
  ///
  /// In ru, this message translates to:
  /// **'Последние операции'**
  String get financeRecent;

  /// No description provided for @txCategorySaleRabbit.
  ///
  /// In ru, this message translates to:
  /// **'Продажа кролика'**
  String get txCategorySaleRabbit;

  /// No description provided for @txCategorySaleMeat.
  ///
  /// In ru, this message translates to:
  /// **'Продажа мяса'**
  String get txCategorySaleMeat;

  /// No description provided for @txCategorySaleFur.
  ///
  /// In ru, this message translates to:
  /// **'Продажа шкурок'**
  String get txCategorySaleFur;

  /// No description provided for @txCategoryBreedingFee.
  ///
  /// In ru, this message translates to:
  /// **'Плата за случку'**
  String get txCategoryBreedingFee;

  /// No description provided for @txCategoryFeed.
  ///
  /// In ru, this message translates to:
  /// **'Корм'**
  String get txCategoryFeed;

  /// No description provided for @txCategoryVeterinary.
  ///
  /// In ru, this message translates to:
  /// **'Лечение'**
  String get txCategoryVeterinary;

  /// No description provided for @txCategoryEquipment.
  ///
  /// In ru, this message translates to:
  /// **'Оборудование'**
  String get txCategoryEquipment;

  /// No description provided for @txCategoryUtilities.
  ///
  /// In ru, this message translates to:
  /// **'Свет, вода, отопление'**
  String get txCategoryUtilities;

  /// No description provided for @txCategoryOther.
  ///
  /// In ru, this message translates to:
  /// **'Прочее'**
  String get txCategoryOther;

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
