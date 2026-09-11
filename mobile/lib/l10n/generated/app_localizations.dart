import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tg.dart';
import 'app_localizations_uz.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('tg'),
    Locale('uz'),
  ];

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

  /// No description provided for @commonCopy.
  ///
  /// In ru, this message translates to:
  /// **'Скопировать'**
  String get commonCopy;

  /// No description provided for @commonCopied.
  ///
  /// In ru, this message translates to:
  /// **'Скопировано'**
  String get commonCopied;

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

  /// No description provided for @commonSomethingWrong.
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так'**
  String get commonSomethingWrong;

  /// No description provided for @commonSomethingWrongHint.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось показать этот экран. Вернитесь назад или перезапустите приложение.'**
  String get commonSomethingWrongHint;

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

  /// Плашка поверх всего приложения, когда у устройства нет сети
  ///
  /// In ru, this message translates to:
  /// **'Нет связи — кормление, задачи и заметки сохранятся и отправятся позже'**
  String get offlineBanner;

  /// Сообщение об успехе вместо обычного, когда действие (кормление, заметка) сохранено офлайн и ждёт отправки
  ///
  /// In ru, this message translates to:
  /// **'Сохранено на устройстве — отправится, когда появится связь'**
  String get offlineActionQueued;

  /// Заголовок экрана обязательного обновления
  ///
  /// In ru, this message translates to:
  /// **'Доступна новая версия'**
  String get forceUpdateTitle;

  /// Пояснение на экране обязательного обновления
  ///
  /// In ru, this message translates to:
  /// **'Эта версия приложения больше не поддерживается. Обновите приложение, чтобы продолжить работу.'**
  String get forceUpdateHint;

  /// Кнопка перехода в магазин приложений на экране обязательного обновления
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get forceUpdateButton;

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

  /// No description provided for @quickGroupOften.
  ///
  /// In ru, this message translates to:
  /// **'Часто'**
  String get quickGroupOften;

  /// No description provided for @journalPeriodToday.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get journalPeriodToday;

  /// No description provided for @journalPeriodWeek.
  ///
  /// In ru, this message translates to:
  /// **'Неделя'**
  String get journalPeriodWeek;

  /// No description provided for @journalKindAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get journalKindAll;

  /// No description provided for @journalKindFeeding.
  ///
  /// In ru, this message translates to:
  /// **'Кормление'**
  String get journalKindFeeding;

  /// No description provided for @journalKindTreatment.
  ///
  /// In ru, this message translates to:
  /// **'Лечение'**
  String get journalKindTreatment;

  /// No description provided for @journalKindVaccination.
  ///
  /// In ru, this message translates to:
  /// **'Прививка'**
  String get journalKindVaccination;

  /// No description provided for @journalKindTask.
  ///
  /// In ru, this message translates to:
  /// **'Задача'**
  String get journalKindTask;

  /// No description provided for @journalKindNote.
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get journalKindNote;

  /// No description provided for @journalKindPhoto.
  ///
  /// In ru, this message translates to:
  /// **'Фото'**
  String get journalKindPhoto;

  /// No description provided for @journalEmptyTodayTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня ещё ничего не записано'**
  String get journalEmptyTodayTitle;

  /// No description provided for @journalEmptyWeekTitle.
  ///
  /// In ru, this message translates to:
  /// **'За неделю ничего не записано'**
  String get journalEmptyWeekTitle;

  /// No description provided for @journalEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Кормления, лечение, прививки, закрытые задачи, заметки и фото попадают сюда сами. Запишите первое — и оно появится здесь.'**
  String get journalEmptyBody;

  /// No description provided for @journalNoneInViewTitle.
  ///
  /// In ru, this message translates to:
  /// **'В этой выборке пусто'**
  String get journalNoneInViewTitle;

  /// No description provided for @journalNoneInViewBody.
  ///
  /// In ru, this message translates to:
  /// **'Смените вид записи или срок.'**
  String get journalNoneInViewBody;

  /// No description provided for @loginSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход в вашу ферму'**
  String get loginSubtitle;

  /// No description provided for @loginPhoneLabel.
  ///
  /// In ru, this message translates to:
  /// **'Телефон'**
  String get loginPhoneLabel;

  /// No description provided for @loginPhoneHint.
  ///
  /// In ru, this message translates to:
  /// **'+992 XX XXX XX XX'**
  String get loginPhoneHint;

  /// No description provided for @loginPhoneEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите номер телефона'**
  String get loginPhoneEmpty;

  /// No description provided for @loginPhoneInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Номер как +992 90 123 45 67'**
  String get loginPhoneInvalid;

  /// No description provided for @loginPhoneIntro.
  ///
  /// In ru, this message translates to:
  /// **'Пришлём код в SMS — пароль не нужен.'**
  String get loginPhoneIntro;

  /// No description provided for @loginRequestCode.
  ///
  /// In ru, this message translates to:
  /// **'Получить код'**
  String get loginRequestCode;

  /// No description provided for @loginWithPassword.
  ///
  /// In ru, this message translates to:
  /// **'Войти по почте и паролю'**
  String get loginWithPassword;

  /// No description provided for @loginCodeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Введите код'**
  String get loginCodeTitle;

  /// No description provided for @loginCodeSentTo.
  ///
  /// In ru, this message translates to:
  /// **'Отправили код на {phone}'**
  String loginCodeSentTo(String phone);

  /// No description provided for @loginCodeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Код из SMS'**
  String get loginCodeLabel;

  /// No description provided for @loginCodeEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите код'**
  String get loginCodeEmpty;

  /// No description provided for @loginCodeInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Код — это 6 цифр'**
  String get loginCodeInvalid;

  /// No description provided for @loginCodeSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get loginCodeSubmit;

  /// No description provided for @loginCodeResend.
  ///
  /// In ru, this message translates to:
  /// **'Отправить код ещё раз'**
  String get loginCodeResend;

  /// No description provided for @loginCodeResendIn.
  ///
  /// In ru, this message translates to:
  /// **'Отправить ещё раз через {seconds} с'**
  String loginCodeResendIn(int seconds);

  /// No description provided for @loginCodeResent.
  ///
  /// In ru, this message translates to:
  /// **'Код отправлен ещё раз'**
  String get loginCodeResent;

  /// No description provided for @loginCodeChangePhone.
  ///
  /// In ru, this message translates to:
  /// **'Изменить номер'**
  String get loginCodeChangePhone;

  /// No description provided for @passwordLoginTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход по почте и паролю'**
  String get passwordLoginTitle;

  /// No description provided for @passwordLoginIntro.
  ///
  /// In ru, this message translates to:
  /// **'Запасной способ — для тех, кто завёл ферму на почту.'**
  String get passwordLoginIntro;

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

  /// No description provided for @commonPasswordShow.
  ///
  /// In ru, this message translates to:
  /// **'Показать пароль'**
  String get commonPasswordShow;

  /// No description provided for @commonPasswordHide.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть пароль'**
  String get commonPasswordHide;

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
  /// **'Забыли пароль?'**
  String get loginForgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In ru, this message translates to:
  /// **'Забыли пароль?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordIntro.
  ///
  /// In ru, this message translates to:
  /// **'Укажите почту, с которой входите в ферму. Если аккаунт есть, пришлём код — по SMS или на почту.'**
  String get forgotPasswordIntro;

  /// No description provided for @forgotPasswordEmailHint.
  ///
  /// In ru, this message translates to:
  /// **'Введите почту'**
  String get forgotPasswordEmailHint;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Отправить код'**
  String get forgotPasswordSubmit;

  /// No description provided for @forgotPasswordSentMessage.
  ///
  /// In ru, this message translates to:
  /// **'Если аккаунт существует, код отправлен'**
  String get forgotPasswordSentMessage;

  /// No description provided for @forgotPasswordBackToLogin.
  ///
  /// In ru, this message translates to:
  /// **'Вспомнили пароль? Войти'**
  String get forgotPasswordBackToLogin;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In ru, this message translates to:
  /// **'Введите код'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordCodeHint.
  ///
  /// In ru, this message translates to:
  /// **'6-значный код из SMS или письма'**
  String get resetPasswordCodeHint;

  /// No description provided for @resetPasswordCodeEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите код'**
  String get resetPasswordCodeEmpty;

  /// No description provided for @resetPasswordCodeInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Код — это 6 цифр'**
  String get resetPasswordCodeInvalid;

  /// No description provided for @resetPasswordNewPasswordHint.
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get resetPasswordNewPasswordHint;

  /// No description provided for @resetPasswordConfirmHint.
  ///
  /// In ru, this message translates to:
  /// **'Повторите новый пароль'**
  String get resetPasswordConfirmHint;

  /// No description provided for @resetPasswordConfirmMismatch.
  ///
  /// In ru, this message translates to:
  /// **'Пароли не совпадают'**
  String get resetPasswordConfirmMismatch;

  /// No description provided for @resetPasswordSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Сменить пароль'**
  String get resetPasswordSubmit;

  /// No description provided for @resetPasswordSuccessMessage.
  ///
  /// In ru, this message translates to:
  /// **'Пароль изменён. Войдите с новым паролем.'**
  String get resetPasswordSuccessMessage;

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

  /// No description provided for @todayAlertOverdueVaccination.
  ///
  /// In ru, this message translates to:
  /// **'Вакцинация просрочена'**
  String get todayAlertOverdueVaccination;

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

  /// No description provided for @activationChecklistTitle.
  ///
  /// In ru, this message translates to:
  /// **'Начало работы'**
  String get activationChecklistTitle;

  /// No description provided for @activationChecklistDismiss.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть'**
  String get activationChecklistDismiss;

  /// No description provided for @activationChecklistAddCage.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте клетку'**
  String get activationChecklistAddCage;

  /// No description provided for @activationChecklistAddRabbit.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте кролика'**
  String get activationChecklistAddRabbit;

  /// No description provided for @activationChecklistFirstFeeding.
  ///
  /// In ru, this message translates to:
  /// **'Внесите первое кормление'**
  String get activationChecklistFirstFeeding;

  /// No description provided for @menuProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get menuProfile;

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

  /// No description provided for @quickRecordNote.
  ///
  /// In ru, this message translates to:
  /// **'Оставить заметку'**
  String get quickRecordNote;

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

  /// No description provided for @cycleTitle.
  ///
  /// In ru, this message translates to:
  /// **'Разведение'**
  String get cycleTitle;

  /// No description provided for @cycleFindPair.
  ///
  /// In ru, this message translates to:
  /// **'Подобрать пару'**
  String get cycleFindPair;

  /// No description provided for @cycleRecordBirth.
  ///
  /// In ru, this message translates to:
  /// **'Записать окрол'**
  String get cycleRecordBirth;

  /// No description provided for @cycleStageCheck.
  ///
  /// In ru, this message translates to:
  /// **'Проверить сукрольность'**
  String get cycleStageCheck;

  /// No description provided for @cycleStageBirth.
  ///
  /// In ru, this message translates to:
  /// **'Окрол ожидается'**
  String get cycleStageBirth;

  /// No description provided for @cycleStageWeaning.
  ///
  /// In ru, this message translates to:
  /// **'Отсадка молодняка'**
  String get cycleStageWeaning;

  /// No description provided for @cycleStageNotPregnant.
  ///
  /// In ru, this message translates to:
  /// **'Самка пустая'**
  String get cycleStageNotPregnant;

  /// No description provided for @cycleStageFailed.
  ///
  /// In ru, this message translates to:
  /// **'Случка не удалась'**
  String get cycleStageFailed;

  /// No description provided for @cycleStageCancelled.
  ///
  /// In ru, this message translates to:
  /// **'Случка отменена'**
  String get cycleStageCancelled;

  /// No description provided for @cycleStageClosed.
  ///
  /// In ru, this message translates to:
  /// **'Цикл отработан'**
  String get cycleStageClosed;

  /// No description provided for @cycleDay.
  ///
  /// In ru, this message translates to:
  /// **'{day}-й день'**
  String cycleDay(int day);

  /// No description provided for @cycleMaleLine.
  ///
  /// In ru, this message translates to:
  /// **'Самец: {name}'**
  String cycleMaleLine(String name);

  /// No description provided for @cycleActionWhen.
  ///
  /// In ru, this message translates to:
  /// **'{date} · {when}'**
  String cycleActionWhen(String date, String when);

  /// No description provided for @cycleApproxDate.
  ///
  /// In ru, this message translates to:
  /// **'примерно {date}'**
  String cycleApproxDate(String date);

  /// No description provided for @cycleDueToday.
  ///
  /// In ru, this message translates to:
  /// **'сегодня'**
  String get cycleDueToday;

  /// No description provided for @cycleDueTomorrow.
  ///
  /// In ru, this message translates to:
  /// **'завтра'**
  String get cycleDueTomorrow;

  /// No description provided for @cycleInDays.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{через {count} день} few{через {count} дня} many{через {count} дней} other{через {count} дня}}'**
  String cycleInDays(int count);

  /// No description provided for @cycleOverdueDays.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{просрочено на {count} день} few{просрочено на {count} дня} many{просрочено на {count} дней} other{просрочено на {count} дня}}'**
  String cycleOverdueDays(int count);

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

  /// No description provided for @commonOpenCard.
  ///
  /// In ru, this message translates to:
  /// **'Открыть карточку'**
  String get commonOpenCard;

  /// No description provided for @commonEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get commonEdit;

  /// No description provided for @commonClearSearch.
  ///
  /// In ru, this message translates to:
  /// **'Очистить поиск'**
  String get commonClearSearch;

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

  /// No description provided for @cycleStageWeaned.
  ///
  /// In ru, this message translates to:
  /// **'Молодняк отсажен'**
  String get cycleStageWeaned;

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

  /// No description provided for @todayTasksTitle.
  ///
  /// In ru, this message translates to:
  /// **'Задачи на сегодня'**
  String get todayTasksTitle;

  /// No description provided for @todayTasksAll.
  ///
  /// In ru, this message translates to:
  /// **'Все задачи'**
  String get todayTasksAll;

  /// No description provided for @todayTaskDone.
  ///
  /// In ru, this message translates to:
  /// **'Закрыта'**
  String get todayTaskDone;

  /// No description provided for @todayTasksNone.
  ///
  /// In ru, this message translates to:
  /// **'На сегодня задач нет'**
  String get todayTasksNone;

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

  /// No description provided for @noteFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая заметка'**
  String get noteFormNewTitle;

  /// No description provided for @noteFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get noteFormEditTitle;

  /// No description provided for @noteFormSectionMain.
  ///
  /// In ru, this message translates to:
  /// **'Основное'**
  String get noteFormSectionMain;

  /// No description provided for @noteFormContentLabel.
  ///
  /// In ru, this message translates to:
  /// **'Текст заметки'**
  String get noteFormContentLabel;

  /// No description provided for @noteFormContentEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите текст заметки'**
  String get noteFormContentEmpty;

  /// No description provided for @noteFormSectionLink.
  ///
  /// In ru, this message translates to:
  /// **'К чему относится'**
  String get noteFormSectionLink;

  /// No description provided for @noteFormRabbitLabel.
  ///
  /// In ru, this message translates to:
  /// **'Кролик (необязательно)'**
  String get noteFormRabbitLabel;

  /// No description provided for @noteFormCageLabel.
  ///
  /// In ru, this message translates to:
  /// **'Клетка (необязательно)'**
  String get noteFormCageLabel;

  /// No description provided for @noteFormCageNone.
  ///
  /// In ru, this message translates to:
  /// **'Не выбрано'**
  String get noteFormCageNone;

  /// No description provided for @noteFormCreate.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get noteFormCreate;

  /// No description provided for @noteFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Заметка добавлена'**
  String get noteFormCreated;

  /// No description provided for @noteFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Заметка обновлена'**
  String get noteFormUpdated;

  /// No description provided for @noteFormDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить заметку?'**
  String get noteFormDeleteTitle;

  /// No description provided for @noteFormDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить её будет нельзя.'**
  String get noteFormDeleteBody;

  /// No description provided for @noteFormDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Заметка удалена'**
  String get noteFormDeleted;

  /// No description provided for @noteFormDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить заметку'**
  String get noteFormDeleteFailed;

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

  /// Знак валюты передаётся параметром — он один на всё приложение, см. kCurrencySymbol
  ///
  /// In ru, this message translates to:
  /// **'Затраты, {currency}'**
  String medFormCostLabel(String currency);

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

  /// No description provided for @feedingBulkModeRabbits.
  ///
  /// In ru, this message translates to:
  /// **'Кролики'**
  String get feedingBulkModeRabbits;

  /// No description provided for @feedingBulkModeCages.
  ///
  /// In ru, this message translates to:
  /// **'Клетки'**
  String get feedingBulkModeCages;

  /// No description provided for @feedingBulkAddRabbit.
  ///
  /// In ru, this message translates to:
  /// **'Добавить кролика'**
  String get feedingBulkAddRabbit;

  /// No description provided for @feedingBulkRabbitsRequired.
  ///
  /// In ru, this message translates to:
  /// **'Выберите хотя бы одного кролика'**
  String get feedingBulkRabbitsRequired;

  /// No description provided for @feedingBulkRemove.
  ///
  /// In ru, this message translates to:
  /// **'Убрать из списка'**
  String get feedingBulkRemove;

  /// No description provided for @feedingBulkCagesField.
  ///
  /// In ru, this message translates to:
  /// **'Какие клетки'**
  String get feedingBulkCagesField;

  /// No description provided for @feedingBulkCagesRequired.
  ///
  /// In ru, this message translates to:
  /// **'Выберите хотя бы одну клетку'**
  String get feedingBulkCagesRequired;

  /// No description provided for @feedingBulkCagesPickTitle.
  ///
  /// In ru, this message translates to:
  /// **'Какие клетки кормим'**
  String get feedingBulkCagesPickTitle;

  /// No description provided for @feedingBulkCagesSelected.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} клетка} few{{count} клетки} many{{count} клеток} other{{count} клетки}}'**
  String feedingBulkCagesSelected(int count);

  /// No description provided for @feedingBulkWholeFarm.
  ///
  /// In ru, this message translates to:
  /// **'Вся ферма'**
  String get feedingBulkWholeFarm;

  /// No description provided for @feedingBulkClearSelection.
  ///
  /// In ru, this message translates to:
  /// **'Снять выбор'**
  String get feedingBulkClearSelection;

  /// No description provided for @feedingBulkRowUnnamed.
  ///
  /// In ru, this message translates to:
  /// **'Без ряда'**
  String get feedingBulkRowUnnamed;

  /// No description provided for @feedingBulkDone.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get feedingBulkDone;

  /// No description provided for @feedingBulkNoCagesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Клеток пока нет'**
  String get feedingBulkNoCagesTitle;

  /// No description provided for @feedingBulkNoCagesBody.
  ///
  /// In ru, this message translates to:
  /// **'Заведите клетки — тогда кормление можно будет записать сразу на ряд или на всю ферму.'**
  String get feedingBulkNoCagesBody;

  /// No description provided for @feedingBulkQuantityEach.
  ///
  /// In ru, this message translates to:
  /// **'Сколько на каждого'**
  String get feedingBulkQuantityEach;

  /// No description provided for @feedingBulkQuantityEachHint.
  ///
  /// In ru, this message translates to:
  /// **'Число — на одного получателя.'**
  String get feedingBulkQuantityEachHint;

  /// No description provided for @feedingBulkQuantityEachNote.
  ///
  /// In ru, this message translates to:
  /// **'Число — на одного получателя. Всего спишется {amount}.'**
  String feedingBulkQuantityEachNote(String amount);

  /// No description provided for @feedingBulkCreated.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{Записано {count} кормление} few{Записано {count} кормления} many{Записано {count} кормлений} other{Записано {count} кормления}}'**
  String feedingBulkCreated(int count);

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

  /// No description provided for @herdCagesNoPlace.
  ///
  /// In ru, this message translates to:
  /// **'Место не указано'**
  String get herdCagesNoPlace;

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

  /// No description provided for @galleryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Галерея фото'**
  String get galleryTitle;

  /// No description provided for @galleryEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Снимков пока нет'**
  String get galleryEmptyTitle;

  /// No description provided for @galleryEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте фото — на карточке останется одно, а здесь поместятся все.'**
  String get galleryEmptyBody;

  /// No description provided for @galleryAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить фото'**
  String get galleryAdd;

  /// No description provided for @galleryUploaded.
  ///
  /// In ru, this message translates to:
  /// **'Фото добавлено'**
  String get galleryUploaded;

  /// No description provided for @galleryCaptionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Подпись к фото'**
  String get galleryCaptionTitle;

  /// No description provided for @galleryCaptionLabel.
  ///
  /// In ru, this message translates to:
  /// **'Например, «После стрижки»'**
  String get galleryCaptionLabel;

  /// No description provided for @galleryCaptionSkip.
  ///
  /// In ru, this message translates to:
  /// **'Без подписи'**
  String get galleryCaptionSkip;

  /// No description provided for @galleryDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить фото?'**
  String get galleryDeleteTitle;

  /// No description provided for @galleryDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить его будет нельзя.'**
  String get galleryDeleteBody;

  /// No description provided for @galleryDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Фото удалено'**
  String get galleryDeleted;

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

  /// No description provided for @healthTitle.
  ///
  /// In ru, this message translates to:
  /// **'Здоровье'**
  String get healthTitle;

  /// No description provided for @healthMenuLabel.
  ///
  /// In ru, this message translates to:
  /// **'Прививки и лечение'**
  String get healthMenuLabel;

  /// No description provided for @healthKindAll.
  ///
  /// In ru, this message translates to:
  /// **'Всё'**
  String get healthKindAll;

  /// No description provided for @healthKindVaccination.
  ///
  /// In ru, this message translates to:
  /// **'Прививки'**
  String get healthKindVaccination;

  /// No description provided for @healthKindTreatment.
  ///
  /// In ru, this message translates to:
  /// **'Лечение'**
  String get healthKindTreatment;

  /// No description provided for @healthEntryVaccination.
  ///
  /// In ru, this message translates to:
  /// **'Прививка'**
  String get healthEntryVaccination;

  /// No description provided for @healthEntryTreatment.
  ///
  /// In ru, this message translates to:
  /// **'Лечение'**
  String get healthEntryTreatment;

  /// No description provided for @healthPickRabbit.
  ///
  /// In ru, this message translates to:
  /// **'История одного кролика'**
  String get healthPickRabbit;

  /// No description provided for @healthEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Здоровье стада ещё не записано'**
  String get healthEmptyTitle;

  /// No description provided for @healthEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Отмечайте прививки и лечение — и будет видно, что было с каждым кроликом и когда прививать снова.'**
  String get healthEmptyBody;

  /// No description provided for @healthNoneInViewTitle.
  ///
  /// In ru, this message translates to:
  /// **'В этой выборке пусто'**
  String get healthNoneInViewTitle;

  /// No description provided for @healthNoneForRabbitTitle.
  ///
  /// In ru, this message translates to:
  /// **'У {name} записей о здоровье нет'**
  String healthNoneForRabbitTitle(String name);

  /// No description provided for @healthNoneInViewBody.
  ///
  /// In ru, this message translates to:
  /// **'Снимите фильтр — остальные записи никуда не делись.'**
  String get healthNoneInViewBody;

  /// No description provided for @healthRecordTitle.
  ///
  /// In ru, this message translates to:
  /// **'Что записать?'**
  String get healthRecordTitle;

  /// No description provided for @healthRecordVaccination.
  ///
  /// In ru, this message translates to:
  /// **'Прививку'**
  String get healthRecordVaccination;

  /// No description provided for @healthRecordTreatment.
  ///
  /// In ru, this message translates to:
  /// **'Лечение'**
  String get healthRecordTreatment;

  /// No description provided for @farmSectionMoney.
  ///
  /// In ru, this message translates to:
  /// **'Деньги'**
  String get farmSectionMoney;

  /// No description provided for @farmTransactions.
  ///
  /// In ru, this message translates to:
  /// **'Доходы и расходы'**
  String get farmTransactions;

  /// No description provided for @farmSectionFeed.
  ///
  /// In ru, this message translates to:
  /// **'Корма'**
  String get farmSectionFeed;

  /// No description provided for @farmFeedStock.
  ///
  /// In ru, this message translates to:
  /// **'Запас корма'**
  String get farmFeedStock;

  /// No description provided for @farmFeedingRecords.
  ///
  /// In ru, this message translates to:
  /// **'Кормления'**
  String get farmFeedingRecords;

  /// No description provided for @farmSectionHealth.
  ///
  /// In ru, this message translates to:
  /// **'Здоровье'**
  String get farmSectionHealth;

  /// No description provided for @farmSectionReports.
  ///
  /// In ru, this message translates to:
  /// **'Отчёты'**
  String get farmSectionReports;

  /// No description provided for @farmReports.
  ///
  /// In ru, this message translates to:
  /// **'Сводка по ферме'**
  String get farmReports;

  /// No description provided for @farmSectionPeople.
  ///
  /// In ru, this message translates to:
  /// **'Люди'**
  String get farmSectionPeople;

  /// No description provided for @farmStaff.
  ///
  /// In ru, this message translates to:
  /// **'Сотрудники'**
  String get farmStaff;

  /// No description provided for @farmSectionApp.
  ///
  /// In ru, this message translates to:
  /// **'Приложение'**
  String get farmSectionApp;

  /// No description provided for @farmSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get farmSettings;

  /// No description provided for @farmAbout.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get farmAbout;

  /// No description provided for @farmAboutBody.
  ///
  /// In ru, this message translates to:
  /// **'Учёт поголовья, кормов, здоровья и денег кроличьей фермы.'**
  String get farmAboutBody;

  /// No description provided for @farmLogout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get farmLogout;

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

  /// No description provided for @settingsLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get settingsLanguage;

  /// No description provided for @settingsNotifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get settingsNotifications;

  /// No description provided for @settingsDigestToggle.
  ///
  /// In ru, this message translates to:
  /// **'Дайджест по хозяйству'**
  String get settingsDigestToggle;

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

  /// No description provided for @settingsSupport.
  ///
  /// In ru, this message translates to:
  /// **'Написать в поддержку'**
  String get settingsSupport;

  /// No description provided for @supportRequestTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поддержка'**
  String get supportRequestTitle;

  /// No description provided for @supportRequestHint.
  ///
  /// In ru, this message translates to:
  /// **'Опишите, что случилось, — ответим по тому же аккаунту, с которого пришло обращение.'**
  String get supportRequestHint;

  /// No description provided for @supportRequestPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Например: не получается добавить кролика — приложение зависает на сохранении'**
  String get supportRequestPlaceholder;

  /// No description provided for @supportRequestTooShort.
  ///
  /// In ru, this message translates to:
  /// **'Опишите проблему подробнее — хотя бы 10 символов'**
  String get supportRequestTooShort;

  /// No description provided for @supportRequestSend.
  ///
  /// In ru, this message translates to:
  /// **'Отправить'**
  String get supportRequestSend;

  /// No description provided for @supportRequestSent.
  ///
  /// In ru, this message translates to:
  /// **'Обращение отправлено'**
  String get supportRequestSent;

  /// No description provided for @supportContactHint.
  ///
  /// In ru, this message translates to:
  /// **'Или свяжитесь напрямую:'**
  String get supportContactHint;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In ru, this message translates to:
  /// **'Политика конфиденциальности'**
  String get settingsPrivacyPolicy;

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

  /// No description provided for @settingsSubscription.
  ///
  /// In ru, this message translates to:
  /// **'Тариф'**
  String get settingsSubscription;

  /// No description provided for @subscriptionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тариф'**
  String get subscriptionTitle;

  /// No description provided for @subscriptionNoPlan.
  ///
  /// In ru, this message translates to:
  /// **'Тариф не назначен'**
  String get subscriptionNoPlan;

  /// No description provided for @subscriptionNoPlanHint.
  ///
  /// In ru, this message translates to:
  /// **'Обратитесь в поддержку, чтобы подключить тариф.'**
  String get subscriptionNoPlanHint;

  /// No description provided for @subscriptionContactSupport.
  ///
  /// In ru, this message translates to:
  /// **'Написать в поддержку'**
  String get subscriptionContactSupport;

  /// No description provided for @subscriptionFree.
  ///
  /// In ru, this message translates to:
  /// **'Бесплатный тариф'**
  String get subscriptionFree;

  /// No description provided for @subscriptionForever.
  ///
  /// In ru, this message translates to:
  /// **'Бессрочно'**
  String get subscriptionForever;

  /// No description provided for @subscriptionExpiresOn.
  ///
  /// In ru, this message translates to:
  /// **'Действует до {date}'**
  String subscriptionExpiresOn(String date);

  /// No description provided for @subscriptionExpired.
  ///
  /// In ru, this message translates to:
  /// **'Срок истёк {date}'**
  String subscriptionExpired(String date);

  /// No description provided for @subscriptionPricePerPeriod.
  ///
  /// In ru, this message translates to:
  /// **'{price} с / 30 дней'**
  String subscriptionPricePerPeriod(String price);

  /// No description provided for @subscriptionPay.
  ///
  /// In ru, this message translates to:
  /// **'Оплатить'**
  String get subscriptionPay;

  /// No description provided for @subscriptionOpenPaymentPage.
  ///
  /// In ru, this message translates to:
  /// **'Открыть страницу оплаты'**
  String get subscriptionOpenPaymentPage;

  /// No description provided for @subscriptionAfterPayingHint.
  ///
  /// In ru, this message translates to:
  /// **'Оплатите по открывшейся ссылке, затем вернитесь сюда и нажмите «Проверить оплату».'**
  String get subscriptionAfterPayingHint;

  /// No description provided for @subscriptionCheckPayment.
  ///
  /// In ru, this message translates to:
  /// **'Проверить оплату'**
  String get subscriptionCheckPayment;

  /// No description provided for @subscriptionPaymentCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Оплата прошла, тариф продлён'**
  String get subscriptionPaymentCompleted;

  /// No description provided for @subscriptionPaymentPending.
  ///
  /// In ru, this message translates to:
  /// **'Банк ещё не подтвердил оплату — попробуйте ещё раз через минуту'**
  String get subscriptionPaymentPending;

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

  /// No description provided for @registerFarmName.
  ///
  /// In ru, this message translates to:
  /// **'Название фермы'**
  String get registerFarmName;

  /// No description provided for @registerFarmNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Можно оставить пустым — назовём по вашему имени. Потом название не поменять'**
  String get registerFarmNameHint;

  /// No description provided for @registerFarmNameShort.
  ///
  /// In ru, this message translates to:
  /// **'Слишком коротко'**
  String get registerFarmNameShort;

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
  /// **'Не короче 8 символов'**
  String get registerPasswordHint;

  /// No description provided for @registerPasswordEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Придумайте пароль'**
  String get registerPasswordEmpty;

  /// No description provided for @registerPasswordShort.
  ///
  /// In ru, this message translates to:
  /// **'Пароль должен быть не короче 8 символов'**
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

  /// No description provided for @registerConsentPrefix.
  ///
  /// In ru, this message translates to:
  /// **'Я принимаю '**
  String get registerConsentPrefix;

  /// No description provided for @registerConsentLink.
  ///
  /// In ru, this message translates to:
  /// **'политику конфиденциальности'**
  String get registerConsentLink;

  /// No description provided for @registerConsentRequired.
  ///
  /// In ru, this message translates to:
  /// **'Нужно принять политику конфиденциальности, чтобы продолжить'**
  String get registerConsentRequired;

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

  /// No description provided for @planLimitStaffTitle.
  ///
  /// In ru, this message translates to:
  /// **'Лимит участников по тарифу'**
  String get planLimitStaffTitle;

  /// No description provided for @planLimitStaffBody.
  ///
  /// In ru, this message translates to:
  /// **'Состав фермы достиг лимита участников, разрешённого текущим тарифом. Чтобы пригласить ещё, нужен тариф с большим лимитом.'**
  String get planLimitStaffBody;

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

  /// No description provided for @staffInviteChannelPhone.
  ///
  /// In ru, this message translates to:
  /// **'По телефону'**
  String get staffInviteChannelPhone;

  /// No description provided for @staffInviteChannelEmail.
  ///
  /// In ru, this message translates to:
  /// **'По почте'**
  String get staffInviteChannelEmail;

  /// No description provided for @staffInvitePhoneHint.
  ///
  /// In ru, this message translates to:
  /// **'+992 XX XXX XX XX'**
  String get staffInvitePhoneHint;

  /// No description provided for @staffInvitePhoneInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Номер как +992 90 123 45 67'**
  String get staffInvitePhoneInvalid;

  /// No description provided for @staffInviteNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Имя работника'**
  String get staffInviteNameLabel;

  /// No description provided for @staffInviteNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Под этим именем он появится в ферме'**
  String get staffInviteNameHint;

  /// No description provided for @staffInviteNameEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Укажите имя работника'**
  String get staffInviteNameEmpty;

  /// No description provided for @staffInviteCodeSmsBody.
  ///
  /// In ru, this message translates to:
  /// **'Код ушёл по SMS на {phone}. Работник вводит этот номер на входе и код из сообщения — больше ничего не нужно. Если SMS не дошла, передайте код сами: второй раз он не покажется.'**
  String staffInviteCodeSmsBody(String phone);

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

  /// No description provided for @staffTransferOwnership.
  ///
  /// In ru, this message translates to:
  /// **'Передать хозяйство'**
  String get staffTransferOwnership;

  /// No description provided for @staffTransferTitle.
  ///
  /// In ru, this message translates to:
  /// **'Передать хозяйство?'**
  String get staffTransferTitle;

  /// No description provided for @staffTransferBody.
  ///
  /// In ru, this message translates to:
  /// **'Ферма перейдёт {name}, а вы станете управляющим. Отменить это будет нельзя.'**
  String staffTransferBody(String name);

  /// No description provided for @staffTransferConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Передать ферму'**
  String get staffTransferConfirm;

  /// No description provided for @staffTransferred.
  ///
  /// In ru, this message translates to:
  /// **'Хозяйство передано {name}'**
  String staffTransferred(String name);

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

  /// No description provided for @planLimitRabbitsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Лимит кроликов по тарифу'**
  String get planLimitRabbitsTitle;

  /// No description provided for @planLimitRabbitsBody.
  ///
  /// In ru, this message translates to:
  /// **'Ферма достигла лимита кроликов, разрешённого текущим тарифом. Чтобы завести ещё, нужен тариф с большим лимитом — обратитесь к владельцу фермы.'**
  String get planLimitRabbitsBody;

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

  /// No description provided for @reportsOutcomeUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Исход не указан'**
  String get reportsOutcomeUnknown;

  /// No description provided for @reportsFeedUsed.
  ///
  /// In ru, this message translates to:
  /// **'Израсходовано'**
  String get reportsFeedUsed;

  /// No description provided for @reportsTabFarm.
  ///
  /// In ru, this message translates to:
  /// **'Ферма'**
  String get reportsTabFarm;

  /// No description provided for @reportsTabHealth.
  ///
  /// In ru, this message translates to:
  /// **'Здоровье'**
  String get reportsTabHealth;

  /// No description provided for @reportsTabFinance.
  ///
  /// In ru, this message translates to:
  /// **'Деньги'**
  String get reportsTabFinance;

  /// No description provided for @reportsPeriodRange.
  ///
  /// In ru, this message translates to:
  /// **'С {from} по {to}'**
  String reportsPeriodRange(String from, String to);

  /// No description provided for @reportsPopulationNow.
  ///
  /// In ru, this message translates to:
  /// **'Кроликов сейчас'**
  String get reportsPopulationNow;

  /// No description provided for @reportsBirths.
  ///
  /// In ru, this message translates to:
  /// **'Окролы'**
  String get reportsBirths;

  /// No description provided for @reportsBreedings.
  ///
  /// In ru, this message translates to:
  /// **'Случки'**
  String get reportsBreedings;

  /// No description provided for @reportsVaccinations.
  ///
  /// In ru, this message translates to:
  /// **'Вакцинации'**
  String get reportsVaccinations;

  /// No description provided for @reportsMedicalRecords.
  ///
  /// In ru, this message translates to:
  /// **'Лечение'**
  String get reportsMedicalRecords;

  /// No description provided for @reportsFeedings.
  ///
  /// In ru, this message translates to:
  /// **'Кормления'**
  String get reportsFeedings;

  /// No description provided for @reportsActivity.
  ///
  /// In ru, this message translates to:
  /// **'За период'**
  String get reportsActivity;

  /// No description provided for @reportsByBreed.
  ///
  /// In ru, this message translates to:
  /// **'Поголовье по породам'**
  String get reportsByBreed;

  /// No description provided for @reportsBreedUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Порода №{id}'**
  String reportsBreedUnknown(int id);

  /// No description provided for @reportsMoney.
  ///
  /// In ru, this message translates to:
  /// **'Деньги за период'**
  String get reportsMoney;

  /// No description provided for @reportsNoActivityTitle.
  ///
  /// In ru, this message translates to:
  /// **'За этот период записей нет'**
  String get reportsNoActivityTitle;

  /// No description provided for @reportsNoActivityBody.
  ///
  /// In ru, this message translates to:
  /// **'Выберите период шире — или запишите случку, прививку, кормление, и они появятся здесь.'**
  String get reportsNoActivityBody;

  /// No description provided for @reportsFarmEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отчёту пока не из чего собраться'**
  String get reportsFarmEmptyTitle;

  /// No description provided for @reportsFarmEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Заведите первого кролика — дальше отчёт соберётся сам из ежедневных записей.'**
  String get reportsFarmEmptyBody;

  /// No description provided for @reportsHealthEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'За этот период прививок и лечений не было'**
  String get reportsHealthEmptyTitle;

  /// No description provided for @reportsHealthEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Выберите период шире или отметьте прививку — отчёт посчитается сам.'**
  String get reportsHealthEmptyBody;

  /// No description provided for @reportsVaccinesByName.
  ///
  /// In ru, this message translates to:
  /// **'Прививки по вакцинам'**
  String get reportsVaccinesByName;

  /// No description provided for @reportsRecordsByOutcome.
  ///
  /// In ru, this message translates to:
  /// **'Лечение по исходу'**
  String get reportsRecordsByOutcome;

  /// No description provided for @farmSectionPlatform.
  ///
  /// In ru, this message translates to:
  /// **'Платформа'**
  String get farmSectionPlatform;

  /// No description provided for @farmPlatformAdmin.
  ///
  /// In ru, this message translates to:
  /// **'Фермы и тарифы'**
  String get farmPlatformAdmin;

  /// No description provided for @platformTitle.
  ///
  /// In ru, this message translates to:
  /// **'Платформа'**
  String get platformTitle;

  /// No description provided for @platformTabSummary.
  ///
  /// In ru, this message translates to:
  /// **'Сводка'**
  String get platformTabSummary;

  /// No description provided for @platformTabFarms.
  ///
  /// In ru, this message translates to:
  /// **'Фермы'**
  String get platformTabFarms;

  /// No description provided for @platformTabPlans.
  ///
  /// In ru, this message translates to:
  /// **'Тарифы'**
  String get platformTabPlans;

  /// No description provided for @platformTabAnnouncements.
  ///
  /// In ru, this message translates to:
  /// **'Объявления'**
  String get platformTabAnnouncements;

  /// No description provided for @platformTabSupport.
  ///
  /// In ru, this message translates to:
  /// **'Обращения'**
  String get platformTabSupport;

  /// No description provided for @platformSummarySectionFarms.
  ///
  /// In ru, this message translates to:
  /// **'Фермы'**
  String get platformSummarySectionFarms;

  /// No description provided for @platformSummarySectionStatus.
  ///
  /// In ru, this message translates to:
  /// **'Состояние'**
  String get platformSummarySectionStatus;

  /// No description provided for @platformSummarySectionActivity.
  ///
  /// In ru, this message translates to:
  /// **'Активность'**
  String get platformSummarySectionActivity;

  /// No description provided for @platformSummarySectionData.
  ///
  /// In ru, this message translates to:
  /// **'Данные'**
  String get platformSummarySectionData;

  /// No description provided for @platformSummaryTotalFarms.
  ///
  /// In ru, this message translates to:
  /// **'Всего ферм'**
  String get platformSummaryTotalFarms;

  /// No description provided for @platformSummaryFree.
  ///
  /// In ru, this message translates to:
  /// **'На бесплатном'**
  String get platformSummaryFree;

  /// No description provided for @platformSummaryPaid.
  ///
  /// In ru, this message translates to:
  /// **'На платном'**
  String get platformSummaryPaid;

  /// No description provided for @platformSummaryExpired.
  ///
  /// In ru, this message translates to:
  /// **'Просрочка тарифа'**
  String get platformSummaryExpired;

  /// No description provided for @platformSummaryAtLimit.
  ///
  /// In ru, this message translates to:
  /// **'У предела тарифа'**
  String get platformSummaryAtLimit;

  /// No description provided for @platformSummaryRegistrations30d.
  ///
  /// In ru, this message translates to:
  /// **'Регистраций за 30 дней'**
  String get platformSummaryRegistrations30d;

  /// No description provided for @platformSummaryRabbitsTotal.
  ///
  /// In ru, this message translates to:
  /// **'Поголовье всего'**
  String get platformSummaryRabbitsTotal;

  /// No description provided for @platformSummaryStorageTotal.
  ///
  /// In ru, this message translates to:
  /// **'Место всего'**
  String get platformSummaryStorageTotal;

  /// No description provided for @countFarms.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} ферма} few{{count} фермы} many{{count} ферм} other{{count} фермы}}'**
  String countFarms(int count);

  /// No description provided for @countAnnouncements.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} объявление} few{{count} объявления} many{{count} объявлений} other{{count} объявления}}'**
  String countAnnouncements(int count);

  /// No description provided for @platformFarmsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ферм пока нет'**
  String get platformFarmsEmptyTitle;

  /// No description provided for @platformFarmsEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Здесь будут все хозяйства сервиса — они появятся сами, как только кто-нибудь зарегистрируется.'**
  String get platformFarmsEmptyBody;

  /// No description provided for @platformFarmsNothingFound.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не нашлось'**
  String get platformFarmsNothingFound;

  /// No description provided for @platformFarmsNothingFoundBody.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте запрос или снимите фильтр.'**
  String get platformFarmsNothingFoundBody;

  /// No description provided for @platformOwnerMissing.
  ///
  /// In ru, this message translates to:
  /// **'Владелец не назначен'**
  String get platformOwnerMissing;

  /// No description provided for @platformNoPlan.
  ///
  /// In ru, this message translates to:
  /// **'Без тарифа'**
  String get platformNoPlan;

  /// No description provided for @platformNoPlanHint.
  ///
  /// In ru, this message translates to:
  /// **'Ограничений нет'**
  String get platformNoPlanHint;

  /// No description provided for @platformRabbits.
  ///
  /// In ru, this message translates to:
  /// **'Кролики'**
  String get platformRabbits;

  /// No description provided for @platformStaff.
  ///
  /// In ru, this message translates to:
  /// **'Люди'**
  String get platformStaff;

  /// No description provided for @platformUsageOfLimit.
  ///
  /// In ru, this message translates to:
  /// **'{used} из {limit}'**
  String platformUsageOfLimit(int used, int limit);

  /// No description provided for @platformUsageUnlimited.
  ///
  /// In ru, this message translates to:
  /// **'{used}, без предела'**
  String platformUsageUnlimited(int used);

  /// No description provided for @platformAtLimit.
  ///
  /// In ru, this message translates to:
  /// **'Упёрлась в предел тарифа'**
  String get platformAtLimit;

  /// No description provided for @platformNearLimit.
  ///
  /// In ru, this message translates to:
  /// **'Подходит к пределу тарифа'**
  String get platformNearLimit;

  /// No description provided for @platformFarmsSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Ферма, владелец, почта, телефон'**
  String get platformFarmsSearchHint;

  /// No description provided for @platformFilterInactive.
  ///
  /// In ru, this message translates to:
  /// **'{days, plural, one{Не заходили {days} день} few{Не заходили {days} дня} many{Не заходили {days} дней} other{Не заходили {days} дней}}'**
  String platformFilterInactive(int days);

  /// No description provided for @platformFilterExpired.
  ///
  /// In ru, this message translates to:
  /// **'Просрочен тариф'**
  String get platformFilterExpired;

  /// No description provided for @platformFilterUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Неизвестный срез: {filter}'**
  String platformFilterUnknown(String filter);

  /// No description provided for @platformChangePlan.
  ///
  /// In ru, this message translates to:
  /// **'Сменить тариф'**
  String get platformChangePlan;

  /// No description provided for @platformAssignPlan.
  ///
  /// In ru, this message translates to:
  /// **'Назначить тариф'**
  String get platformAssignPlan;

  /// No description provided for @platformPlanSheetTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тариф хозяйства «{farm}»'**
  String platformPlanSheetTitle(String farm);

  /// No description provided for @platformPlanOff.
  ///
  /// In ru, this message translates to:
  /// **'Без тарифа — работает без ограничений'**
  String get platformPlanOff;

  /// No description provided for @platformPlanAssigned.
  ///
  /// In ru, this message translates to:
  /// **'Тариф обновлён'**
  String get platformPlanAssigned;

  /// No description provided for @platformPlanInactive.
  ///
  /// In ru, this message translates to:
  /// **'выключен'**
  String get platformPlanInactive;

  /// No description provided for @platformPlansEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тарифов пока нет'**
  String get platformPlansEmptyTitle;

  /// No description provided for @platformPlansEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Пока их нет, все фермы работают без ограничений. Создайте первый — и его можно будет назначать.'**
  String get platformPlansEmptyBody;

  /// No description provided for @platformPlanNew.
  ///
  /// In ru, this message translates to:
  /// **'Новый тариф'**
  String get platformPlanNew;

  /// No description provided for @platformPlanEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get platformPlanEdit;

  /// No description provided for @platformPlanDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить тариф?'**
  String get platformPlanDeleteTitle;

  /// No description provided for @platformPlanDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'«{name}» исчезнет из списка, а фермы на нём станут работать без ограничений. Их записи не тронутся.'**
  String platformPlanDeleteBody(String name);

  /// No description provided for @platformPlanDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Тариф удалён'**
  String get platformPlanDeleted;

  /// No description provided for @platformPlanUnlimited.
  ///
  /// In ru, this message translates to:
  /// **'Без ограничений'**
  String get platformPlanUnlimited;

  /// No description provided for @platformPlanFree.
  ///
  /// In ru, this message translates to:
  /// **'Бесплатный'**
  String get platformPlanFree;

  /// No description provided for @platformPlanLimitRabbits.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{до {count} кролика} few{до {count} кроликов} many{до {count} кроликов} other{до {count} кроликов}}'**
  String platformPlanLimitRabbits(int count);

  /// No description provided for @platformPlanLimitStaff.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{до {count} человека} few{до {count} человек} many{до {count} человек} other{до {count} человек}}'**
  String platformPlanLimitStaff(int count);

  /// No description provided for @platformPlanFormNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый тариф'**
  String get platformPlanFormNewTitle;

  /// No description provided for @platformPlanFormEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тариф'**
  String get platformPlanFormEditTitle;

  /// No description provided for @platformPlanFormName.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get platformPlanFormName;

  /// No description provided for @platformPlanFormNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, «Базовый»'**
  String get platformPlanFormNameHint;

  /// No description provided for @platformPlanFormNameEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Введите название'**
  String get platformPlanFormNameEmpty;

  /// No description provided for @platformPlanFormPrice.
  ///
  /// In ru, this message translates to:
  /// **'Цена в месяц'**
  String get platformPlanFormPrice;

  /// No description provided for @platformPlanFormPriceHint.
  ///
  /// In ru, this message translates to:
  /// **'Пусто — бесплатно'**
  String get platformPlanFormPriceHint;

  /// No description provided for @platformPlanFormSectionLimits.
  ///
  /// In ru, this message translates to:
  /// **'Пределы'**
  String get platformPlanFormSectionLimits;

  /// No description provided for @platformPlanFormMaxRabbits.
  ///
  /// In ru, this message translates to:
  /// **'Кроликов не больше'**
  String get platformPlanFormMaxRabbits;

  /// No description provided for @platformPlanFormMaxStaff.
  ///
  /// In ru, this message translates to:
  /// **'Людей не больше'**
  String get platformPlanFormMaxStaff;

  /// No description provided for @platformPlanFormLimitHint.
  ///
  /// In ru, this message translates to:
  /// **'Пусто — без ограничения'**
  String get platformPlanFormLimitHint;

  /// No description provided for @platformPlanFormActive.
  ///
  /// In ru, this message translates to:
  /// **'Тариф в ходу'**
  String get platformPlanFormActive;

  /// No description provided for @platformPlanFormActiveHint.
  ///
  /// In ru, this message translates to:
  /// **'Выключенный тариф остаётся у ферм, которым уже назначен, но новым его не выдать.'**
  String get platformPlanFormActiveHint;

  /// No description provided for @platformPlanFormDefault.
  ///
  /// In ru, this message translates to:
  /// **'Выдавать новым фермам'**
  String get platformPlanFormDefault;

  /// No description provided for @platformPlanFormDefaultHint.
  ///
  /// In ru, this message translates to:
  /// **'Этот тариф автоматически достаётся каждой новой зарегистрированной ферме. Ровно один тариф может быть таким — назначить его другому можно, только сняв флаг с текущего.'**
  String get platformPlanFormDefaultHint;

  /// No description provided for @platformPlanFormCreated.
  ///
  /// In ru, this message translates to:
  /// **'Тариф создан'**
  String get platformPlanFormCreated;

  /// No description provided for @platformPlanFormUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Тариф обновлён'**
  String get platformPlanFormUpdated;

  /// No description provided for @platformFarmTitleFallback.
  ///
  /// In ru, this message translates to:
  /// **'Ферма'**
  String get platformFarmTitleFallback;

  /// No description provided for @platformFarmSectionOwner.
  ///
  /// In ru, this message translates to:
  /// **'Владелец и связь'**
  String get platformFarmSectionOwner;

  /// No description provided for @platformFarmSectionAccess.
  ///
  /// In ru, this message translates to:
  /// **'Доступ'**
  String get platformFarmSectionAccess;

  /// No description provided for @platformFarmSectionImpersonate.
  ///
  /// In ru, this message translates to:
  /// **'Просмотр под клиентом'**
  String get platformFarmSectionImpersonate;

  /// No description provided for @platformFarmSectionPlan.
  ///
  /// In ru, this message translates to:
  /// **'Тариф'**
  String get platformFarmSectionPlan;

  /// No description provided for @platformFarmSectionExtras.
  ///
  /// In ru, this message translates to:
  /// **'Поблажка'**
  String get platformFarmSectionExtras;

  /// No description provided for @platformFarmSectionUsage.
  ///
  /// In ru, this message translates to:
  /// **'Потребление'**
  String get platformFarmSectionUsage;

  /// No description provided for @platformFarmSectionStaff.
  ///
  /// In ru, this message translates to:
  /// **'Состав'**
  String get platformFarmSectionStaff;

  /// No description provided for @platformFarmSectionPayments.
  ///
  /// In ru, this message translates to:
  /// **'Платежи'**
  String get platformFarmSectionPayments;

  /// No description provided for @platformFarmSectionFacts.
  ///
  /// In ru, this message translates to:
  /// **'Ещё о ферме'**
  String get platformFarmSectionFacts;

  /// No description provided for @platformFarmSectionExport.
  ///
  /// In ru, this message translates to:
  /// **'Выгрузка данных'**
  String get platformFarmSectionExport;

  /// No description provided for @platformFarmSectionDanger.
  ///
  /// In ru, this message translates to:
  /// **'Удаление фермы'**
  String get platformFarmSectionDanger;

  /// No description provided for @platformFarmContactMissing.
  ///
  /// In ru, this message translates to:
  /// **'Ни почты, ни телефона — связаться нечем'**
  String get platformFarmContactMissing;

  /// No description provided for @platformFarmStatusActive.
  ///
  /// In ru, this message translates to:
  /// **'Работает как обычно'**
  String get platformFarmStatusActive;

  /// No description provided for @platformFarmStatusActiveHint.
  ///
  /// In ru, this message translates to:
  /// **'Ферма читает и записывает всё своё без помех.'**
  String get platformFarmStatusActiveHint;

  /// No description provided for @platformFarmStatusReadOnly.
  ///
  /// In ru, this message translates to:
  /// **'Только чтение'**
  String get platformFarmStatusReadOnly;

  /// No description provided for @platformFarmStatusReadOnlyHint.
  ///
  /// In ru, this message translates to:
  /// **'Данные видны, записать ничего нельзя. Так поступают при неоплате: история хозяйства остаётся у фермера, а работать в ней нельзя, пока не заплатит.'**
  String get platformFarmStatusReadOnlyHint;

  /// No description provided for @platformFarmStatusSuspended.
  ///
  /// In ru, this message translates to:
  /// **'Доступ закрыт'**
  String get platformFarmStatusSuspended;

  /// No description provided for @platformFarmStatusSuspendedHint.
  ///
  /// In ru, this message translates to:
  /// **'Ферма не пускает никого — ни записать, ни посмотреть.'**
  String get platformFarmStatusSuspendedHint;

  /// No description provided for @platformFarmStatusUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Неизвестное состояние: {status}'**
  String platformFarmStatusUnknown(String status);

  /// No description provided for @platformFarmStatusChange.
  ///
  /// In ru, this message translates to:
  /// **'Изменить доступ'**
  String get platformFarmStatusChange;

  /// No description provided for @platformFarmStatusSheetTitle.
  ///
  /// In ru, this message translates to:
  /// **'Доступ хозяйства «{farm}»'**
  String platformFarmStatusSheetTitle(String farm);

  /// No description provided for @platformFarmStatusConfirmTitle.
  ///
  /// In ru, this message translates to:
  /// **'Изменить доступ?'**
  String get platformFarmStatusConfirmTitle;

  /// No description provided for @platformFarmStatusConfirmBody.
  ///
  /// In ru, this message translates to:
  /// **'Хозяйство перейдёт в состояние «{status}». Люди на ферме увидят это сразу же, без перезахода.'**
  String platformFarmStatusConfirmBody(String status);

  /// No description provided for @platformFarmStatusApply.
  ///
  /// In ru, this message translates to:
  /// **'Применить'**
  String get platformFarmStatusApply;

  /// No description provided for @platformFarmStatusUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Доступ обновлён'**
  String get platformFarmStatusUpdated;

  /// No description provided for @platformFarmPlanForever.
  ///
  /// In ru, this message translates to:
  /// **'Бессрочно'**
  String get platformFarmPlanForever;

  /// No description provided for @platformFarmPlanExpires.
  ///
  /// In ru, this message translates to:
  /// **'Действует до {date}'**
  String platformFarmPlanExpires(String date);

  /// No description provided for @platformFarmPlanExpired.
  ///
  /// In ru, this message translates to:
  /// **'Срок истёк {date}'**
  String platformFarmPlanExpired(String date);

  /// No description provided for @platformFarmPlanExtend.
  ///
  /// In ru, this message translates to:
  /// **'Продлить вручную'**
  String get platformFarmPlanExtend;

  /// No description provided for @platformFarmPlanExtended.
  ///
  /// In ru, this message translates to:
  /// **'Срок тарифа обновлён'**
  String get platformFarmPlanExtended;

  /// No description provided for @platformFarmExtrasNone.
  ///
  /// In ru, this message translates to:
  /// **'Поблажек нет — действуют пределы тарифа'**
  String get platformFarmExtrasNone;

  /// No description provided for @platformFarmExtrasGrant.
  ///
  /// In ru, this message translates to:
  /// **'Выдать поблажку'**
  String get platformFarmExtrasGrant;

  /// No description provided for @platformFarmExtrasEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get platformFarmExtrasEdit;

  /// No description provided for @platformFarmExtrasClear.
  ///
  /// In ru, this message translates to:
  /// **'Снять поблажку'**
  String get platformFarmExtrasClear;

  /// No description provided for @platformFarmExtrasRabbits.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{+{count} кролик} few{+{count} кролика} many{+{count} кроликов} other{+{count} кролика}}'**
  String platformFarmExtrasRabbits(int count);

  /// No description provided for @platformFarmExtrasStaff.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{+{count} человек} few{+{count} человека} many{+{count} человек} other{+{count} человека}}'**
  String platformFarmExtrasStaff(int count);

  /// No description provided for @platformFarmExtrasUntil.
  ///
  /// In ru, this message translates to:
  /// **'до {date}'**
  String platformFarmExtrasUntil(String date);

  /// No description provided for @platformFarmExtrasEndless.
  ///
  /// In ru, this message translates to:
  /// **'бессрочно'**
  String get platformFarmExtrasEndless;

  /// No description provided for @platformFarmExtrasExpired.
  ///
  /// In ru, this message translates to:
  /// **'Поблажка истекла {date} — снова действуют пределы тарифа'**
  String platformFarmExtrasExpired(String date);

  /// No description provided for @platformFarmExtrasFormTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поблажка сверх тарифа'**
  String get platformFarmExtrasFormTitle;

  /// No description provided for @platformFarmExtrasFormBody.
  ///
  /// In ru, this message translates to:
  /// **'Добавка к пределам одной этой фермы. Сам тариф не меняется — ни у неё, ни у остальных.'**
  String get platformFarmExtrasFormBody;

  /// No description provided for @platformFarmExtrasFormRabbits.
  ///
  /// In ru, this message translates to:
  /// **'Кроликов сверх тарифа'**
  String get platformFarmExtrasFormRabbits;

  /// No description provided for @platformFarmExtrasFormStaff.
  ///
  /// In ru, this message translates to:
  /// **'Людей сверх тарифа'**
  String get platformFarmExtrasFormStaff;

  /// No description provided for @platformFarmExtrasFormAmountHint.
  ///
  /// In ru, this message translates to:
  /// **'Пусто — без добавки'**
  String get platformFarmExtrasFormAmountHint;

  /// No description provided for @platformFarmExtrasFormUntil.
  ///
  /// In ru, this message translates to:
  /// **'Действует до'**
  String get platformFarmExtrasFormUntil;

  /// No description provided for @platformFarmExtrasFormSetDeadline.
  ///
  /// In ru, this message translates to:
  /// **'Задать срок'**
  String get platformFarmExtrasFormSetDeadline;

  /// No description provided for @platformFarmExtrasFormEndlessHint.
  ///
  /// In ru, this message translates to:
  /// **'Без срока поблажка действует бессрочно.'**
  String get platformFarmExtrasFormEndlessHint;

  /// No description provided for @platformFarmExtrasFormEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Укажите кроликов или людей — или снимите поблажку'**
  String get platformFarmExtrasFormEmpty;

  /// No description provided for @platformFarmExtrasSaved.
  ///
  /// In ru, this message translates to:
  /// **'Поблажка обновлена'**
  String get platformFarmExtrasSaved;

  /// No description provided for @platformFarmExtrasCleared.
  ///
  /// In ru, this message translates to:
  /// **'Поблажка снята'**
  String get platformFarmExtrasCleared;

  /// No description provided for @platformFarmStaffNever.
  ///
  /// In ru, this message translates to:
  /// **'Ещё не заходил'**
  String get platformFarmStaffNever;

  /// No description provided for @platformFarmStaffLastLogin.
  ///
  /// In ru, this message translates to:
  /// **'Заходил {date}'**
  String platformFarmStaffLastLogin(String date);

  /// No description provided for @platformFarmStaffBlocked.
  ///
  /// In ru, this message translates to:
  /// **'Вход закрыт'**
  String get platformFarmStaffBlocked;

  /// No description provided for @platformFarmStaffEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В составе никого — даже владельца'**
  String get platformFarmStaffEmpty;

  /// No description provided for @platformFarmPaymentsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Платежей ещё не было'**
  String get platformFarmPaymentsEmpty;

  /// No description provided for @platformFarmPaymentNew.
  ///
  /// In ru, this message translates to:
  /// **'Начат'**
  String get platformFarmPaymentNew;

  /// No description provided for @platformFarmPaymentCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Оплачен'**
  String get platformFarmPaymentCompleted;

  /// No description provided for @platformFarmPaymentFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не прошёл'**
  String get platformFarmPaymentFailed;

  /// No description provided for @platformFarmImpersonate.
  ///
  /// In ru, this message translates to:
  /// **'Войти под клиентом'**
  String get platformFarmImpersonate;

  /// No description provided for @platformFarmImpersonateHint.
  ///
  /// In ru, this message translates to:
  /// **'Увидеть приложение так же, как видит его владелец фермы — вместо переписки «а что у вас на экране». Только чтение, 15 минут, действие попадает в журнал.'**
  String get platformFarmImpersonateHint;

  /// No description provided for @platformFarmImpersonateTitle.
  ///
  /// In ru, this message translates to:
  /// **'Войти под клиентом?'**
  String get platformFarmImpersonateTitle;

  /// No description provided for @platformFarmImpersonateBody.
  ///
  /// In ru, this message translates to:
  /// **'Вы увидите {farmName} глазами владельца — без права что-либо менять. Сеанс закончится сам через 15 минут или по кнопке «Выйти».'**
  String platformFarmImpersonateBody(String farmName);

  /// No description provided for @platformFarmImpersonateReasonLabel.
  ///
  /// In ru, this message translates to:
  /// **'Причина'**
  String get platformFarmImpersonateReasonLabel;

  /// No description provided for @platformFarmImpersonateReasonHint.
  ///
  /// In ru, this message translates to:
  /// **'Например: жалоба в поддержку №482'**
  String get platformFarmImpersonateReasonHint;

  /// No description provided for @platformFarmImpersonateReasonRequired.
  ///
  /// In ru, this message translates to:
  /// **'Укажите причину — без неё вход не запишется в журнал'**
  String get platformFarmImpersonateReasonRequired;

  /// No description provided for @platformFarmImpersonateConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get platformFarmImpersonateConfirm;

  /// No description provided for @impersonationBanner.
  ///
  /// In ru, this message translates to:
  /// **'Вы смотрите «{farmName}» — только чтение'**
  String impersonationBanner(String farmName);

  /// No description provided for @impersonationExit.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get impersonationExit;

  /// No description provided for @impersonationExpired.
  ///
  /// In ru, this message translates to:
  /// **'Сеанс просмотра истёк — вы снова в своём аккаунте'**
  String get impersonationExpired;

  /// No description provided for @farmStatusBannerReadOnly.
  ///
  /// In ru, this message translates to:
  /// **'Доступ только для чтения — продлите тариф, чтобы снова вносить записи'**
  String get farmStatusBannerReadOnly;

  /// No description provided for @farmStatusBannerSuspended.
  ///
  /// In ru, this message translates to:
  /// **'Доступ закрыт — обратитесь в поддержку'**
  String get farmStatusBannerSuspended;

  /// No description provided for @farmStatusBannerAction.
  ///
  /// In ru, this message translates to:
  /// **'Тариф'**
  String get farmStatusBannerAction;

  /// No description provided for @farmStatusBannerContactSupport.
  ///
  /// In ru, this message translates to:
  /// **'Поддержка'**
  String get farmStatusBannerContactSupport;

  /// No description provided for @platformFarmExport.
  ///
  /// In ru, this message translates to:
  /// **'Экспортировать данные'**
  String get platformFarmExport;

  /// No description provided for @platformFarmExportHint.
  ///
  /// In ru, this message translates to:
  /// **'Снимок всех записей фермы — кролики, лечение, корма, платежи. Пригодится на просьбу «отдайте мои данные».'**
  String get platformFarmExportHint;

  /// No description provided for @platformFarmExportGeneratedAt.
  ///
  /// In ru, this message translates to:
  /// **'Снимок собран {date}'**
  String platformFarmExportGeneratedAt(String date);

  /// No description provided for @platformFarmDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить ферму'**
  String get platformFarmDelete;

  /// No description provided for @platformFarmDeleteHint.
  ///
  /// In ru, this message translates to:
  /// **'Доступ закроется сразу же, а записи и файлы уйдут окончательно через 30 дней. До этого ферму можно вернуть.'**
  String get platformFarmDeleteHint;

  /// No description provided for @platformFarmDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить ферму?'**
  String get platformFarmDeleteTitle;

  /// No description provided for @platformFarmDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Люди на ферме потеряют доступ сразу же. Кролики, лечение, фото и платежи будут окончательно удалены через 30 дней — до этого удаление можно отменить. Чтобы подтвердить, наберите название хозяйства.'**
  String get platformFarmDeleteBody;

  /// No description provided for @platformFarmDeleteConfirmLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название фермы'**
  String get platformFarmDeleteConfirmLabel;

  /// No description provided for @platformFarmDeleteConfirmHint.
  ///
  /// In ru, this message translates to:
  /// **'Наберите «{name}»'**
  String platformFarmDeleteConfirmHint(String name);

  /// No description provided for @platformFarmDeleteMismatch.
  ///
  /// In ru, this message translates to:
  /// **'Название не совпадает с названием фермы'**
  String get platformFarmDeleteMismatch;

  /// No description provided for @platformFarmDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Ферма удалена'**
  String get platformFarmDeleted;

  /// No description provided for @platformFarmDeletedBanner.
  ///
  /// In ru, this message translates to:
  /// **'Ферма удалена {date}. Записи и файлы будут окончательно очищены через 30 дней после удаления.'**
  String platformFarmDeletedBanner(String date);

  /// No description provided for @platformFarmDeletedLocked.
  ///
  /// In ru, this message translates to:
  /// **'Пока ферма удалена, доступ и поблажки не меняются — сначала восстановите её.'**
  String get platformFarmDeletedLocked;

  /// No description provided for @platformFarmRestore.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить'**
  String get platformFarmRestore;

  /// No description provided for @platformFarmRestored.
  ///
  /// In ru, this message translates to:
  /// **'Ферма восстановлена'**
  String get platformFarmRestored;

  /// No description provided for @platformFarmStorage.
  ///
  /// In ru, this message translates to:
  /// **'Занятое место'**
  String get platformFarmStorage;

  /// No description provided for @platformFarmLastActive.
  ///
  /// In ru, this message translates to:
  /// **'Последний вход'**
  String get platformFarmLastActive;

  /// No description provided for @platformFarmNeverActive.
  ///
  /// In ru, this message translates to:
  /// **'Ещё не заходили'**
  String get platformFarmNeverActive;

  /// No description provided for @platformFarmCreatedAt.
  ///
  /// In ru, this message translates to:
  /// **'Ферма создана'**
  String get platformFarmCreatedAt;

  /// No description provided for @platformSupportRequestsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Обращений пока нет'**
  String get platformSupportRequestsEmptyTitle;

  /// No description provided for @platformSupportRequestsEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Здесь появятся вопросы от ферм — фермер пишет через Настройки → Написать в поддержку.'**
  String get platformSupportRequestsEmptyBody;

  /// No description provided for @platformSupportRequestNew.
  ///
  /// In ru, this message translates to:
  /// **'новое'**
  String get platformSupportRequestNew;

  /// No description provided for @platformSupportRequestResolved.
  ///
  /// In ru, this message translates to:
  /// **'разобрано'**
  String get platformSupportRequestResolved;

  /// No description provided for @platformSupportRequestResolve.
  ///
  /// In ru, this message translates to:
  /// **'Отметить разобранным'**
  String get platformSupportRequestResolve;

  /// No description provided for @countSupportRequests.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} обращение} few{{count} обращения} many{{count} обращений} other{{count} обращения}}'**
  String countSupportRequests(int count);

  /// No description provided for @platformAnnouncementsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Объявлений ещё не было'**
  String get platformAnnouncementsEmptyTitle;

  /// No description provided for @platformAnnouncementsEmptyBody.
  ///
  /// In ru, this message translates to:
  /// **'Здесь останется история рассылок: что отправляли, кому и сколько дошло. Отправленное не исправить и не отозвать, поэтому список пригодится, чтобы не повторить одно и то же дважды.'**
  String get platformAnnouncementsEmptyBody;

  /// No description provided for @platformAnnouncementNew.
  ///
  /// In ru, this message translates to:
  /// **'Новое объявление'**
  String get platformAnnouncementNew;

  /// No description provided for @platformAnnouncementSend.
  ///
  /// In ru, this message translates to:
  /// **'Отправить'**
  String get platformAnnouncementSend;

  /// No description provided for @platformAnnouncementTargetAll.
  ///
  /// In ru, this message translates to:
  /// **'Всем фермам'**
  String get platformAnnouncementTargetAll;

  /// No description provided for @platformAnnouncementTargetAllHint.
  ///
  /// In ru, this message translates to:
  /// **'Каждому хозяйству сервиса, кроме удалённых'**
  String get platformAnnouncementTargetAllHint;

  /// No description provided for @platformAnnouncementTargetFarm.
  ///
  /// In ru, this message translates to:
  /// **'Одной ферме'**
  String get platformAnnouncementTargetFarm;

  /// No description provided for @platformAnnouncementTargetFarmHint.
  ///
  /// In ru, this message translates to:
  /// **'Одному хозяйству — например, в ответ на его обращение'**
  String get platformAnnouncementTargetFarmHint;

  /// No description provided for @platformAnnouncementTargetFilter.
  ///
  /// In ru, this message translates to:
  /// **'По срезу ферм'**
  String get platformAnnouncementTargetFilter;

  /// No description provided for @platformAnnouncementTargetFilterHint.
  ///
  /// In ru, this message translates to:
  /// **'Те же срезы, что и в списке ферм: без тарифа, упёрлась в предел, доступ закрыт'**
  String get platformAnnouncementTargetFilterHint;

  /// No description provided for @platformAnnouncementAudienceFarm.
  ///
  /// In ru, this message translates to:
  /// **'Ферме «{farm}»'**
  String platformAnnouncementAudienceFarm(String farm);

  /// No description provided for @platformAnnouncementAudienceFilter.
  ///
  /// In ru, this message translates to:
  /// **'Срез «{filter}»'**
  String platformAnnouncementAudienceFilter(String filter);

  /// No description provided for @platformAnnouncementChannelPush.
  ///
  /// In ru, this message translates to:
  /// **'Push'**
  String get platformAnnouncementChannelPush;

  /// No description provided for @platformAnnouncementChannelPushHint.
  ///
  /// In ru, this message translates to:
  /// **'Уведомление в приложении фермы'**
  String get platformAnnouncementChannelPushHint;

  /// No description provided for @platformAnnouncementChannelEmail.
  ///
  /// In ru, this message translates to:
  /// **'Почта'**
  String get platformAnnouncementChannelEmail;

  /// No description provided for @platformAnnouncementChannelEmailHint.
  ///
  /// In ru, this message translates to:
  /// **'Письмо на адрес из профиля'**
  String get platformAnnouncementChannelEmailHint;

  /// No description provided for @platformAnnouncementReach.
  ///
  /// In ru, this message translates to:
  /// **'{farms, plural, one{{farms} ферма} few{{farms} фермы} many{{farms} ферм} other{{farms} фермы}} · {recipients, plural, one{{recipients} получатель} few{{recipients} получателя} many{{recipients} получателей} other{{recipients} получателя}}'**
  String platformAnnouncementReach(int farms, int recipients);

  /// No description provided for @platformAnnouncementNobody.
  ///
  /// In ru, this message translates to:
  /// **'Получателей не нашлось — объявление никому не ушло'**
  String get platformAnnouncementNobody;

  /// No description provided for @platformAnnouncementDelivered.
  ///
  /// In ru, this message translates to:
  /// **'доставлено {sent} из {attempted}'**
  String platformAnnouncementDelivered(int sent, int attempted);

  /// No description provided for @platformAnnouncementDeliveredNobody.
  ///
  /// In ru, this message translates to:
  /// **'отправлять было некому'**
  String get platformAnnouncementDeliveredNobody;

  /// No description provided for @platformAnnouncementDeliveryUnknown.
  ///
  /// In ru, this message translates to:
  /// **'результат не сохранён'**
  String get platformAnnouncementDeliveryUnknown;

  /// No description provided for @platformAnnouncementFormTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новое объявление'**
  String get platformAnnouncementFormTitle;

  /// No description provided for @platformAnnouncementFormSubject.
  ///
  /// In ru, this message translates to:
  /// **'Заголовок'**
  String get platformAnnouncementFormSubject;

  /// No description provided for @platformAnnouncementFormSubjectHint.
  ///
  /// In ru, this message translates to:
  /// **'Он же станет темой письма и заголовком push'**
  String get platformAnnouncementFormSubjectHint;

  /// No description provided for @platformAnnouncementFormBody.
  ///
  /// In ru, this message translates to:
  /// **'Текст'**
  String get platformAnnouncementFormBody;

  /// No description provided for @platformAnnouncementFormBodyHint.
  ///
  /// In ru, this message translates to:
  /// **'Что нужно знать фермам'**
  String get platformAnnouncementFormBodyHint;

  /// No description provided for @platformAnnouncementFormSectionChannels.
  ///
  /// In ru, this message translates to:
  /// **'Каналы'**
  String get platformAnnouncementFormSectionChannels;

  /// No description provided for @platformAnnouncementFormNoSms.
  ///
  /// In ru, this message translates to:
  /// **'SMS для объявлений недоступна: платёжный шлюз принимает только заранее одобренные шаблоны, а объявление — свободный текст.'**
  String get platformAnnouncementFormNoSms;

  /// No description provided for @platformAnnouncementFormSectionTarget.
  ///
  /// In ru, this message translates to:
  /// **'Кому'**
  String get platformAnnouncementFormSectionTarget;

  /// No description provided for @platformAnnouncementFormPickFarm.
  ///
  /// In ru, this message translates to:
  /// **'Выберите ферму'**
  String get platformAnnouncementFormPickFarm;

  /// No description provided for @platformAnnouncementFormPickFilter.
  ///
  /// In ru, this message translates to:
  /// **'Выберите срез'**
  String get platformAnnouncementFormPickFilter;

  /// No description provided for @platformAnnouncementFarmSheetTitle.
  ///
  /// In ru, this message translates to:
  /// **'Какой ферме отправить'**
  String get platformAnnouncementFarmSheetTitle;

  /// No description provided for @platformAnnouncementFilterSheetTitle.
  ///
  /// In ru, this message translates to:
  /// **'Какому срезу ферм отправить'**
  String get platformAnnouncementFilterSheetTitle;

  /// No description provided for @platformAnnouncementConfirmTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отправить объявление?'**
  String get platformAnnouncementConfirmTitle;

  /// No description provided for @platformAnnouncementConfirmBody.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение уйдёт получателям сразу же. Отозвать или исправить отправленное нельзя.'**
  String get platformAnnouncementConfirmBody;

  /// No description provided for @platformAnnouncementConfirmAudience.
  ///
  /// In ru, this message translates to:
  /// **'Кому: {audience}'**
  String platformAnnouncementConfirmAudience(String audience);

  /// No description provided for @platformAnnouncementConfirmChannels.
  ///
  /// In ru, this message translates to:
  /// **'Каналы: {channels}'**
  String platformAnnouncementConfirmChannels(String channels);

  /// No description provided for @platformAnnouncementSentOk.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{Объявление ушло {count} получателю} few{Объявление ушло {count} получателям} many{Объявление ушло {count} получателям} other{Объявление ушло {count} получателям}}'**
  String platformAnnouncementSentOk(int count);

  /// No description provided for @platformAnnouncementSentPartly.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{Объявление ушло {count} получателю, но часть сообщений не дошла — смотрите строку в списке} few{Объявление ушло {count} получателям, но часть сообщений не дошла — смотрите строку в списке} many{Объявление ушло {count} получателям, но часть сообщений не дошла — смотрите строку в списке} other{Объявление ушло {count} получателям, но часть сообщений не дошла — смотрите строку в списке}}'**
  String platformAnnouncementSentPartly(int count);

  /// No description provided for @platformAnnouncementSentPlain.
  ///
  /// In ru, this message translates to:
  /// **'Объявление отправлено'**
  String get platformAnnouncementSentPlain;

  /// No description provided for @storageUnitBytes.
  ///
  /// In ru, this message translates to:
  /// **'Б'**
  String get storageUnitBytes;

  /// No description provided for @storageUnitKb.
  ///
  /// In ru, this message translates to:
  /// **'КБ'**
  String get storageUnitKb;

  /// No description provided for @storageUnitMb.
  ///
  /// In ru, this message translates to:
  /// **'МБ'**
  String get storageUnitMb;

  /// No description provided for @storageUnitGb.
  ///
  /// In ru, this message translates to:
  /// **'ГБ'**
  String get storageUnitGb;

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
      <String>['en', 'ru', 'tg', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'tg':
      return AppLocalizationsTg();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
