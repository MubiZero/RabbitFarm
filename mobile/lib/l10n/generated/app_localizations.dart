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
