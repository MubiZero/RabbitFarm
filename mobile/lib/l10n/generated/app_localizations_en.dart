// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'RabbitFarm';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonCopied => 'Copied';

  @override
  String get commonLoadFailed => 'Failed to load';

  @override
  String get commonUnknownError => 'Unknown error';

  @override
  String get commonSomethingWrong => 'Something went wrong';

  @override
  String get commonSomethingWrongHint =>
      'This screen couldn\'t be shown. Go back or restart the app.';

  @override
  String get errorOffline => 'No connection — check your internet';

  @override
  String get errorTimeout => 'The server didn\'t respond, please try again';

  @override
  String get errorUnauthorized => 'Please sign in again';

  @override
  String get errorForbidden => 'Your role doesn\'t have access to this';

  @override
  String get errorNotFound => 'Record not found — it may have been deleted';

  @override
  String get errorInvalid => 'The server rejected the data';

  @override
  String get errorServer => 'The server had an issue, please try again later';

  @override
  String get offlineBanner =>
      'No connection — your entries are saved and will be sent once you\'re back online';

  @override
  String get offlineActionQueued =>
      'Saved on this device — it will be sent once you\'re back online';

  @override
  String get forceUpdateTitle => 'A new version is available';

  @override
  String get forceUpdateHint =>
      'This version of the app is no longer supported. Update the app to continue.';

  @override
  String get forceUpdateButton => 'Update';

  @override
  String get commonStaleData => 'Couldn\'t refresh — showing previous data';

  @override
  String get commonRetryShort => 'Retry';

  @override
  String get commonNotSpecified => 'Not specified';

  @override
  String get commonActions => 'Actions';

  @override
  String get commonEmail => 'Email';

  @override
  String get quickGroupOften => 'Frequent';

  @override
  String get journalPeriodToday => 'Today';

  @override
  String get journalPeriodWeek => 'Week';

  @override
  String get journalKindAll => 'All';

  @override
  String get journalKindFeeding => 'Feeding';

  @override
  String get journalKindTreatment => 'Treatment';

  @override
  String get journalKindVaccination => 'Vaccination';

  @override
  String get journalKindTask => 'Task';

  @override
  String get journalKindNote => 'Note';

  @override
  String get journalKindPhoto => 'Photo';

  @override
  String get journalEmptyTodayTitle => 'Nothing recorded today yet';

  @override
  String get journalEmptyWeekTitle => 'Nothing recorded this week';

  @override
  String get journalEmptyBody =>
      'Feedings, treatments, vaccinations, completed tasks, notes, and photos show up here automatically. Record your first one and it will appear.';

  @override
  String get journalNoneInViewTitle => 'Nothing in this view';

  @override
  String get journalNoneInViewBody => 'Try a different view or time range.';

  @override
  String get pinSetupTitle => 'Quick sign-in code';

  @override
  String get pinChangeTitle => 'Change the code';

  @override
  String get pinSetupPrompt => 'Pick a 4-digit code';

  @override
  String get pinRepeatPrompt => 'Enter the code again';

  @override
  String get pinSetupExplanation =>
      'You\'ll open the app on this phone with this code — no more waiting for a code by SMS or email.';

  @override
  String get pinSkip => 'Not now';

  @override
  String get pinSaved => 'Code saved';

  @override
  String get pinMismatch => 'The codes didn\'t match — pick a code again';

  @override
  String get pinLockPrompt => 'Enter your code';

  @override
  String get pinWrong => 'Wrong code';

  @override
  String get pinDelete => 'Delete digit';

  @override
  String pinAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count attempts left',
      one: '$count attempt left',
    );
    return '$_temp0';
  }

  @override
  String get pinForgot => 'Forgot your code?';

  @override
  String get pinForgotTitle => 'Forgot your code?';

  @override
  String get pinForgotBody =>
      'The code is kept only on this phone, so there\'s nothing to recover. We\'ll sign you out, and you\'ll sign in again with a code from an SMS or email.';

  @override
  String get pinForgotConfirm => 'Sign out and sign in again';

  @override
  String get settingsPinTitle => 'Quick sign-in code';

  @override
  String get settingsPinOn => 'The app opens with a code';

  @override
  String get settingsPinOff => 'The app opens without a code';

  @override
  String get settingsPinChange => 'Change the code';

  @override
  String get loginByPhone => 'Phone';

  @override
  String get loginByEmail => 'Email';

  @override
  String get loginEmailIntro =>
      'We\'ll send a code to your email — no password needed.';

  @override
  String get loginCodeChangeEmail => 'Change email';

  @override
  String get registerContactHelper => 'Your sign-in code will come here';

  @override
  String get loginPhoneLabel => 'Phone';

  @override
  String get loginPhoneHint => '+992 XX XXX XX XX';

  @override
  String get loginPhoneEmpty => 'Enter your phone number';

  @override
  String get loginPhoneInvalid => 'A number like +992 90 123 45 67';

  @override
  String get loginPhoneIntro =>
      'We\'ll send a code by SMS — no password needed.';

  @override
  String get loginRequestCode => 'Get a code';

  @override
  String loginCodeSentTo(String phone) {
    return 'We sent a code to $phone';
  }

  @override
  String get loginCodeLabel => 'Code from the SMS';

  @override
  String get loginCodeEmpty => 'Enter the code';

  @override
  String get loginCodeInvalid => 'The code is 6 digits';

  @override
  String get loginCodeSubmit => 'Sign in';

  @override
  String get loginCodeResend => 'Send the code again';

  @override
  String loginCodeResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get loginCodeResent => 'Code sent again';

  @override
  String get loginCodeChangePhone => 'Change number';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'name@example.com';

  @override
  String get loginEmailEmpty => 'Enter your email';

  @override
  String get loginEmailInvalid => 'That email address looks off';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginCreateFarm => 'Set up my own farm';

  @override
  String get todayGreetingMorning => 'Good morning';

  @override
  String get todayGreetingDay => 'Good afternoon';

  @override
  String get todayGreetingEvening => 'Good evening';

  @override
  String get todayGreetingNight => 'Good night';

  @override
  String todayGreetingNamed(String greeting, String name) {
    return '$greeting, $name!';
  }

  @override
  String todayGreetingPlain(String greeting) {
    return '$greeting!';
  }

  @override
  String get todayNeedsAttention => 'Needs attention';

  @override
  String get todayAllClear => 'All clear — nothing urgent';

  @override
  String get todayFarmNow => 'Farm right now';

  @override
  String get todayStatLivestock => 'Livestock';

  @override
  String get todayStatTasks => 'Tasks in progress';

  @override
  String get todayStatFreeCages => 'Free cages';

  @override
  String get todayAlertOverdueVaccination => 'Vaccination overdue';

  @override
  String get todayAlertLowFeed => 'Feed running low';

  @override
  String get todayAlertUpcomingVaccination => 'Vaccination coming up';

  @override
  String get activationChecklistTitle => 'Getting started';

  @override
  String get activationChecklistDismiss => 'Dismiss';

  @override
  String get menuProfile => 'Profile';

  @override
  String get roleOwner => 'Farm owner';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleWorker => 'Worker';

  @override
  String get navToday => 'Today';

  @override
  String get navRabbits => 'Rabbits';

  @override
  String get navHerd => 'Herd';

  @override
  String get navBreeding => 'Breeding';

  @override
  String get navFarm => 'Farm';

  @override
  String get navJournal => 'Journal';

  @override
  String get navProfile => 'Profile';

  @override
  String get navRecord => 'Record';

  @override
  String get quickRecordTreatment => 'Treatment';

  @override
  String get quickRecordBreeding => 'Breeding';

  @override
  String get quickAddFeed => 'Feed delivery';

  @override
  String get quickRecordTransaction => 'Income or expense';

  @override
  String get quickGroupDaily => 'Every day';

  @override
  String get quickGroupHerd => 'Herd';

  @override
  String get quickGroupFarm => 'Farm';

  @override
  String get herdTitle => 'Herd';

  @override
  String get herdTabCages => 'Cages';

  @override
  String get herdTabRabbits => 'Rabbits';

  @override
  String get journalTitle => 'Journal';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get farmTitle => 'Farm';

  @override
  String get navQuickTitle => 'What to record';

  @override
  String get quickRecordFeeding => 'Log a feeding';

  @override
  String get quickNeedsConnection => 'Needs connection';

  @override
  String get errorCodeSessionExpired =>
      'Your session has ended — sign in again';

  @override
  String get errorCodeUserInactive =>
      'Your access to the farm is closed — ask the owner';

  @override
  String get errorCodeRegistrationClosed =>
      'Accounts are created by the farm owner';

  @override
  String get errorCodePlatformAdminOnly =>
      'This section is for the platform administrator only';

  @override
  String get errorCodeOtpInvalid => 'Wrong code';

  @override
  String get errorCodeOtpExpired => 'The code has expired — request a new one';

  @override
  String get errorCodeOtpLocked => 'Too many attempts — request a new code';

  @override
  String get errorCodeOtpRateLimited =>
      'You are asking for codes too often — wait a little';

  @override
  String get errorCodeRateLimited => 'Too many requests — wait a little';

  @override
  String get errorCodeUploadRateLimited =>
      'Too many uploads in a row — wait a little';

  @override
  String get errorCodeContactRequired => 'Enter a phone number or an email';

  @override
  String get errorCodeInvalidEmail => 'That email address is not valid';

  @override
  String get errorCodeInvalidPhone =>
      'A Tajik number is required: +992 and nine digits';

  @override
  String get errorCodeSmsNotConfigured =>
      'Sending SMS is not working right now — sign in by email';

  @override
  String get errorCodeEmailNotConfigured =>
      'Sending email is not working right now — sign in by phone';

  @override
  String get errorCodeFarmSuspended =>
      'The farm is suspended — contact support';

  @override
  String get errorCodeFarmDeleted =>
      'The farm has been deleted — contact support';

  @override
  String get errorCodeFarmReadOnly =>
      'The farm is read-only — records cannot be saved right now';

  @override
  String get errorCodeImpersonationReadOnly =>
      'Signed in as the client — read-only, records cannot be changed';

  @override
  String get errorCodeUpgradeRequired =>
      'A newer version of the app is required — please update';

  @override
  String get errorCodeUserNotFound => 'That person was not found';

  @override
  String get errorCodeFarmNotFound => 'Farm not found';

  @override
  String get errorCodeBirthNotFound => 'Kindling not found';

  @override
  String get errorCodeMotherNotFound => 'Mother not found';

  @override
  String get errorCodeFatherNotFound => 'Father not found';

  @override
  String get errorCodeMaleNotFound => 'Buck not found';

  @override
  String get errorCodeFemaleNotFound => 'Doe not found';

  @override
  String get errorCodeBreedingNotFound => 'Mating not found';

  @override
  String get errorCodeFeedingNotFound => 'Feeding record not found';

  @override
  String get errorCodeMedicalRecordNotFound => 'Treatment record not found';

  @override
  String get errorCodeVaccinationNotFound => 'Vaccination record not found';

  @override
  String get errorCodeNoteNotFound => 'Note not found';

  @override
  String get errorCodeTransactionNotFound => 'Money record not found';

  @override
  String get errorCodePaymentNotFound => 'Payment not found';

  @override
  String get errorCodePlanNotFound => 'Plan not found';

  @override
  String get errorCodeSupportRequestNotFound => 'Support request not found';

  @override
  String get errorCodePhotoNotFound => 'Photo not found';

  @override
  String get errorCodeMemberNotFound => 'Worker not found';

  @override
  String get errorCodeInvitationNotFound => 'Invitation not found';

  @override
  String get errorCodeAssigneeNotFound => 'Assignee not found';

  @override
  String get errorCodeRabbitNotActive =>
      'The rabbit is dead or sold — no new records for it';

  @override
  String get errorCodeBirthHasKitCards =>
      'This kindling already has kit cards — record it there';

  @override
  String get errorCodeKitsMoreThanBorn =>
      'There cannot be more cards than kits born alive';

  @override
  String get errorCodeKitsCountInvalid =>
      'A kindling has between one and thirty kits';

  @override
  String get errorCodeWeaningBeforeBirth =>
      'Weaning cannot happen before the kindling';

  @override
  String get errorCodeNotAMale => 'The chosen rabbit is not a buck';

  @override
  String get errorCodeNotAFemale => 'The chosen rabbit is not a doe';

  @override
  String get errorCodeParentIdInvalid =>
      'The buck or the doe is chosen incorrectly';

  @override
  String get errorCodeBreedingSelf => 'A rabbit cannot be mated with itself';

  @override
  String get errorCodeFemaleNotAvailable =>
      'The doe is not ready for mating right now';

  @override
  String get errorCodeFatherNotFoundOrInvalidSex =>
      'The father was not found, or it is not a buck';

  @override
  String get errorCodeMotherNotFoundOrInvalidSex =>
      'The mother was not found, or it is not a doe';

  @override
  String get errorCodeCannotBeOwnParent => 'A rabbit cannot be its own parent';

  @override
  String get errorCodeSexLocked =>
      'The sex can no longer be changed: the rabbit has offspring or matings';

  @override
  String get errorCodeRabbitHasOffspring =>
      'Cannot delete: the rabbit has offspring';

  @override
  String get errorCodeRabbitHasBreedings =>
      'Cannot delete: the rabbit has matings';

  @override
  String get errorCodeRabbitHasBirths => 'Cannot delete: the doe has kindlings';

  @override
  String get errorCodeRabbitHasHealthRecords =>
      'Cannot delete: the rabbit has treatments or vaccinations';

  @override
  String get errorCodeRabbitHasTransactions =>
      'Cannot delete: money records are linked to the rabbit';

  @override
  String get errorCodeCageHasRabbits =>
      'Move the rabbits out first — the cage is not empty';

  @override
  String get errorCodeBreedHasRabbits =>
      'Cannot delete a breed while rabbits belong to it';

  @override
  String get errorCodeBreedNameExists =>
      'A breed with this name already exists';

  @override
  String get errorCodeTagRangeTaken =>
      'Tags in this range are taken — start from another one';

  @override
  String get errorCodeFeedInUse =>
      'Cannot delete the feed: it is used in feeding records';

  @override
  String get errorCodeStockOperationInvalid =>
      'Stock changes only by adding or subtracting';

  @override
  String get errorCodeBulkCountInvalid =>
      'You can add between one and a hundred rabbits at once';

  @override
  String get errorCodePeriodRequired => 'Choose a year and a month';

  @override
  String get errorCodeFileMissing => 'No file chosen';

  @override
  String get errorCodeFileTooLarge => 'The file is too large';

  @override
  String get errorCodeFileUploadFailed => 'The file did not upload — try again';

  @override
  String get errorCodeRelatedRecordInvalid =>
      'The linked record was not found — refresh the screen';

  @override
  String get errorCodeNoPlan =>
      'The farm has no plan assigned — contact support';

  @override
  String get errorCodePlanFree =>
      'The current plan is free — no payment needed';

  @override
  String get errorCodePlanNameExists => 'A plan with this name already exists';

  @override
  String get errorCodePlanDefaultTaken =>
      'Another plan is already the default — clear it there first';

  @override
  String get errorCodePlanDisabled =>
      'The plan is switched off — turn it on or choose another';

  @override
  String get errorCodeNoRecipients =>
      'No recipients matched — check who the announcement is addressed to';

  @override
  String get errorCodeFarmNoOwner =>
      'The farm has no owner — there is nobody to sign in as';

  @override
  String get errorCodeFarmNotDeleted =>
      'The farm was not deleted — there is nothing to restore';

  @override
  String get errorCodePlatformAdminAccount =>
      'This is a platform administrator account';

  @override
  String get errorCodeRabbitNotFound => 'Rabbit not found';

  @override
  String get errorCodeCageNotFound => 'Cage not found';

  @override
  String get errorCodeBreedNotFound => 'Breed not found';

  @override
  String get errorCodeFeedNotFound => 'Feed not found';

  @override
  String get errorCodeTaskNotFound => 'Task not found';

  @override
  String get errorCodeCageFull => 'The cage is full';

  @override
  String get errorCodeTagIdExists => 'This tag is already taken';

  @override
  String get errorCodeRabbitLimitReached => 'Plan limit for rabbits reached';

  @override
  String get errorCodeStaffLimitReached => 'Plan limit for staff reached';

  @override
  String get errorCodeInsufficientStock => 'Not enough feed in stock';

  @override
  String get errorCodeUserExists => 'This email is already taken';

  @override
  String get errorCodePhoneExists => 'This number is already taken';

  @override
  String get errorCodePhoneLoginUnavailable =>
      'SMS codes do not reach your country — sign in by email';

  @override
  String get errorCodePaymentsUnavailableInCountry =>
      'Card payment is not available in your country yet — message support';

  @override
  String get taskReminderLabel => 'Remind in advance';

  @override
  String get taskReminderNone => 'No reminder';

  @override
  String get taskReminder15m => '15 minutes before';

  @override
  String get taskReminder1h => 'An hour before';

  @override
  String get taskReminder3h => '3 hours before';

  @override
  String get taskReminder1d => 'A day before';

  @override
  String get taskReminder2d => 'Two days before';

  @override
  String get bulkHerdTitle => 'Add several';

  @override
  String get bulkHerdSubtitle => 'For moving a herd you already have';

  @override
  String get bulkHerdCount => 'How many';

  @override
  String get bulkHerdTagPrefix => 'Tag prefix';

  @override
  String get bulkHerdTagPrefixHint => 'For example, R- gives R-001, R-002';

  @override
  String get bulkHerdTagPrefixEmpty => 'Leave empty if there are no tags';

  @override
  String get bulkHerdCountInvalid => 'From 1 to 100';

  @override
  String bulkHerdDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rabbits added',
      one: '$count rabbit added',
    );
    return '$_temp0';
  }

  @override
  String get rabbitMultiPickerTitle => 'Who is in the batch';

  @override
  String get rabbitMultiPickerLabel => 'Rabbits';

  @override
  String get rabbitMultiPickerEmpty => 'No one selected';

  @override
  String get rabbitMultiPickerDone => 'Done';

  @override
  String rabbitMultiPickerSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '$count selected',
    );
    return '$_temp0';
  }

  @override
  String get transactionSaleBatch => 'Sell as a batch';

  @override
  String ageYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '$count year',
    );
    return '$_temp0';
  }

  @override
  String ageYearsMonths(int years, int months) {
    return '${years}y ${months}m';
  }

  @override
  String get feedTypePellets => 'Pellets';

  @override
  String get feedTypeHay => 'Hay';

  @override
  String get feedTypeVegetables => 'Vegetables';

  @override
  String get feedTypeGrain => 'Grain';

  @override
  String get feedTypeSupplements => 'Supplements';

  @override
  String get feedTypeOther => 'Other';

  @override
  String get feedUnitKg => 'kg';

  @override
  String get feedUnitLiter => 'l';

  @override
  String get feedUnitPiece => 'pcs';

  @override
  String get vaccineTypeVhd => 'RHD';

  @override
  String get vaccineTypeMyxomatosis => 'Myxomatosis';

  @override
  String get vaccineTypePasteurellosis => 'Pasteurellosis';

  @override
  String get vaccineTypeOther => 'Other';

  @override
  String get vaccineFullVhd => 'Rabbit haemorrhagic disease (RHD)';

  @override
  String offlineRejectedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records were not saved',
      one: '$count record was not saved',
    );
    return '$_temp0';
  }

  @override
  String get offlineRejectedBody =>
      'The server rejected them — please enter them again.';

  @override
  String get offlineRejectedDismiss => 'Got it';

  @override
  String get quickRecordVaccination => 'Log a vaccination';

  @override
  String get quickCreateTask => 'Create a task';

  @override
  String get quickRecordNote => 'Leave a note';

  @override
  String get quickAddRabbit => 'Add a rabbit';

  @override
  String get quickRecordBirth => 'Log a kindling';

  @override
  String get quickAddCage => 'Add a cage';

  @override
  String get formDiscardTitle => 'Leave without saving?';

  @override
  String get formDiscardBody => 'The information you entered will be lost.';

  @override
  String get formDiscardStay => 'Keep editing';

  @override
  String get formDiscardLeave => 'Leave';

  @override
  String get cycleTitle => 'Breeding';

  @override
  String get cycleFindPair => 'Find a pair';

  @override
  String get cycleRecordBirth => 'Log a kindling';

  @override
  String get cycleStageCheck => 'Check for pregnancy';

  @override
  String get cycleStageBirth => 'Kindling expected';

  @override
  String get cycleStageWeaning => 'Weaning kits';

  @override
  String get cycleStageNotPregnant => 'Not pregnant';

  @override
  String get cycleStageFailed => 'Breeding unsuccessful';

  @override
  String get cycleStageCancelled => 'Breeding cancelled';

  @override
  String get cycleStageClosed => 'Cycle closed';

  @override
  String cycleDay(int day) {
    return 'Day $day';
  }

  @override
  String cycleMaleLine(String name) {
    return 'Male: $name';
  }

  @override
  String cycleActionWhen(String date, String when) {
    return '$date · $when';
  }

  @override
  String cycleApproxDate(String date) {
    return 'around $date';
  }

  @override
  String get cycleDueToday => 'today';

  @override
  String get cycleDueTomorrow => 'tomorrow';

  @override
  String cycleInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count days',
      one: 'in $count day',
    );
    return '$_temp0';
  }

  @override
  String cycleOverdueDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'overdue by $count days',
      one: 'overdue by $count day',
    );
    return '$_temp0';
  }

  @override
  String get breedingEmptyTitle => 'No breedings yet';

  @override
  String get breedingEmptyBody =>
      'Log a breeding and the app will estimate the kindling date.';

  @override
  String get breedingEmptyAction => 'Log a breeding';

  @override
  String get breedingMale => 'Male';

  @override
  String get breedingFemale => 'Female';

  @override
  String get commonNameMissing => 'Name not specified';

  @override
  String get commonOpenCard => 'Open card';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClearSearch => 'Clear search';

  @override
  String get breedingStatusPlanned => 'Planned';

  @override
  String get breedingStatusCompleted => 'Completed';

  @override
  String get breedingStatusFailed => 'Unsuccessful';

  @override
  String get breedingStatusCancelled => 'Cancelled';

  @override
  String get cageTitle => 'Cage';

  @override
  String cageTitleNumbered(String number) {
    return 'Cage $number';
  }

  @override
  String get cageEdit => 'Edit cage';

  @override
  String get cageResidents => 'Residents';

  @override
  String get cageEmptyManaged =>
      'This cage is empty. Move a rabbit in using the button below.';

  @override
  String get cageEmptyReadOnly => 'This cage is empty.';

  @override
  String get cageFull => 'Cage is full';

  @override
  String get cageAddRabbit => 'Move a rabbit in';

  @override
  String get cageNoLocation => 'Location not specified';

  @override
  String get cageRemoveTitle => 'Remove from cage?';

  @override
  String cageRemoveBody(String name) {
    return '$name will move to the list of rabbits without a cage.';
  }

  @override
  String get cageRemoveConfirm => 'Remove';

  @override
  String cageRemoved(String name) {
    return '$name removed from the cage';
  }

  @override
  String cageMoved(String name, String number) {
    return '$name moved to cage $number';
  }

  @override
  String cageSettled(String name) {
    return '$name moved into the cage';
  }

  @override
  String commonActionFailed(String reason) {
    return 'Failed: $reason';
  }

  @override
  String get cageResidentMove => 'Relocate';

  @override
  String get cagePickRabbitTitle => 'Who to move in';

  @override
  String get cagePickRabbitHint => 'Name or tag number';

  @override
  String get cagePickNothingFound => 'No matches found';

  @override
  String get cagePickNothingFoundBody => 'Check the name or tag number.';

  @override
  String cagePickCurrentCage(String number) {
    return 'Currently in cage $number';
  }

  @override
  String get cagePickNoCage => 'No cage';

  @override
  String get cagePickCageTitle => 'Where to move';

  @override
  String get cagePickNoFreeCages => 'No free cages';

  @override
  String get cagePickNoFreeCagesBody => 'Free up space or add a new cage.';

  @override
  String get cageFormType => 'Cage type';

  @override
  String get cycleStageWeaned => 'Kits weaned';

  @override
  String get cageTypeSingle => 'Single';

  @override
  String get cageTypeGroup => 'Group';

  @override
  String get cageTypeMaternity => 'Maternity';

  @override
  String get cageConditionGood => 'Good';

  @override
  String get cageConditionNeedsRepair => 'Needs repair';

  @override
  String get cageConditionBroken => 'Broken';

  @override
  String countTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '$count task',
    );
    return '$_temp0';
  }

  @override
  String countVaccinations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vaccinations',
      one: '$count vaccination',
    );
    return '$_temp0';
  }

  @override
  String countFeedKinds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count feed types',
      one: '$count feed type',
    );
    return '$_temp0';
  }

  @override
  String countRabbits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rabbits',
      one: '$count rabbit',
    );
    return '$_temp0';
  }

  @override
  String countRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '$count record',
    );
    return '$_temp0';
  }

  @override
  String countOperations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '$count transaction',
    );
    return '$_temp0';
  }

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get todayTasksTitle => 'Today\'s tasks';

  @override
  String get todayTasksAll => 'All tasks';

  @override
  String get todayTaskDone => 'Done';

  @override
  String get todayTasksNone => 'No tasks for today';

  @override
  String get commonFilters => 'Filters';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonReset => 'Reset';

  @override
  String get tasksFilterType => 'Type';

  @override
  String get tasksFilterStatus => 'Status';

  @override
  String get tasksFilterPriority => 'Priority';

  @override
  String get tasksFilterOverdueOnly => 'Overdue only';

  @override
  String get tasksFilterTodayOnly => 'Today only';

  @override
  String get tasksFilterAssignee => 'Assignee';

  @override
  String get tasksFilterAssigneeAny => 'Anyone';

  @override
  String get tasksFilterAssigneeMine => 'Only mine';

  @override
  String get tasksAssigneeMineChip => 'My tasks';

  @override
  String get tasksEmptyTitle => 'No tasks yet';

  @override
  String get tasksEmptyBody =>
      'Create a task and the app will remind you on its due date.';

  @override
  String get tasksEmptyAction => 'Create a task';

  @override
  String get tasksNothingMatchesTitle => 'Nothing matches these filters';

  @override
  String get tasksNothingMatchesBody => 'Remove some filters to see more.';

  @override
  String get tasksComplete => 'Mark as done';

  @override
  String get tasksCompleted => 'Task completed';

  @override
  String get tasksCompleteFailed => 'Couldn\'t mark the task as done';

  @override
  String get tasksOverdueChip => 'Overdue';

  @override
  String get tasksTodayChip => 'Today';

  @override
  String get taskTypeFeeding => 'Feeding';

  @override
  String get taskTypeCleaning => 'Cleaning';

  @override
  String get taskTypeVaccination => 'Vaccination';

  @override
  String get taskTypeCheckup => 'Checkup';

  @override
  String get taskTypeBreeding => 'Breeding';

  @override
  String get taskTypeOther => 'Other';

  @override
  String get taskStatusPending => 'Pending';

  @override
  String get taskStatusInProgress => 'In progress';

  @override
  String get taskStatusCompleted => 'Completed';

  @override
  String get taskStatusCancelled => 'Cancelled';

  @override
  String get taskPriorityLow => 'Low';

  @override
  String get taskPriorityMedium => 'Medium';

  @override
  String get taskPriorityHigh => 'High';

  @override
  String get taskPriorityUrgent => 'Urgent';

  @override
  String dueToday(String time) {
    return 'Today at $time';
  }

  @override
  String dueTomorrow(String time) {
    return 'Tomorrow at $time';
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
      other: 'Overdue by $count days',
      one: 'Overdue by $count day',
    );
    return '$_temp0';
  }

  @override
  String get dueTodayPlain => 'Today';

  @override
  String get dueTomorrowPlain => 'Tomorrow';

  @override
  String get taskFormNewTitle => 'New task';

  @override
  String get taskFormEditTitle => 'Task';

  @override
  String get taskFormSectionMain => 'Main';

  @override
  String get taskFormSectionParams => 'Parameters';

  @override
  String get taskFormSectionNotes => 'Notes';

  @override
  String get taskFormTitleLabel => 'What needs to be done';

  @override
  String get taskFormTitleEmpty => 'Describe the task in one line';

  @override
  String get taskFormDescriptionLabel => 'Details';

  @override
  String get taskFormDueLabel => 'Due';

  @override
  String get taskFormRepeat => 'Repeat';

  @override
  String get taskFormRepeatNever => 'Don\'t repeat';

  @override
  String get taskFormRepeatHelp =>
      'When the task is marked done, the next one will be created automatically.';

  @override
  String get taskFormAssignee => 'Assignee';

  @override
  String get taskFormAssigneeNobody => 'Not assigned';

  @override
  String get taskFormAssigneeHelp =>
      'The assignee gets a notification about the task.';

  @override
  String tasksAssignedTo(String name) {
    return 'Assignee: $name';
  }

  @override
  String get taskFormNotesLabel => 'Notes';

  @override
  String get taskFormCreate => 'Create';

  @override
  String get taskFormCreated => 'Task created';

  @override
  String get taskFormUpdated => 'Task updated';

  @override
  String get taskFormDeleteTitle => 'Delete task?';

  @override
  String get taskFormDeleteBody => 'This can\'t be undone.';

  @override
  String get taskFormDeleted => 'Task deleted';

  @override
  String get taskFormDeleteFailed => 'Couldn\'t delete the task';

  @override
  String get noteFormNewTitle => 'New note';

  @override
  String get noteFormEditTitle => 'Note';

  @override
  String get noteFormSectionMain => 'Main';

  @override
  String get noteFormContentLabel => 'Note text';

  @override
  String get noteFormContentEmpty => 'Enter the note text';

  @override
  String get noteFormSectionLink => 'Related to';

  @override
  String get noteFormRabbitLabel => 'Rabbit (optional)';

  @override
  String get noteFormCageLabel => 'Cage (optional)';

  @override
  String get noteFormCageNone => 'Not selected';

  @override
  String get noteFormCreate => 'Add';

  @override
  String get noteFormCreated => 'Note added';

  @override
  String get noteFormUpdated => 'Note updated';

  @override
  String get noteFormDeleteTitle => 'Delete note?';

  @override
  String get noteFormDeleteBody => 'This can\'t be undone.';

  @override
  String get noteFormDeleted => 'Note deleted';

  @override
  String get noteFormDeleteFailed => 'Couldn\'t delete the note';

  @override
  String get repeatDaily => 'Every day';

  @override
  String get repeatWeekly => 'Weekly';

  @override
  String get repeatBiweekly => 'Every two weeks';

  @override
  String get repeatMonthly => 'Monthly';

  @override
  String get repeatQuarterly => 'Quarterly';

  @override
  String get repeatYearly => 'Yearly';

  @override
  String get vaccinationsTitle => 'Vaccinations';

  @override
  String get vaccinationsStats => 'Summary';

  @override
  String get vaccinationsViewAll => 'All';

  @override
  String get vaccinationsViewUpcoming => 'Upcoming';

  @override
  String get vaccinationsViewOverdue => 'Overdue';

  @override
  String get vaccinationsViewLast30 => 'Last 30 days';

  @override
  String get vaccinationsEmptyTitle => 'No vaccination records';

  @override
  String get vaccinationsEmptyBody =>
      'Log a vaccination and the app will remind you when the next one is due.';

  @override
  String get vaccinationsEmptyAction => 'Log a vaccination';

  @override
  String get vaccinationsNoneInView => 'Nothing in this view';

  @override
  String get vaccinationsNoneInViewBody =>
      'Choose a different tab or clear the filters.';

  @override
  String get vaccinationsFilterType => 'Vaccine type';

  @override
  String get vaccinationsFilterPeriod => 'Period';

  @override
  String get vaccinationsFrom => 'From';

  @override
  String get vaccinationsTo => 'To';

  @override
  String get vaccinationsResetAll => 'Reset all';

  @override
  String vaccinationsNext(String date) {
    return 'Next on $date';
  }

  @override
  String get vaccinationsOverdueBadge => 'Overdue';

  @override
  String vaccinationsInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count days',
      one: 'in $count day',
    );
    return '$_temp0';
  }

  @override
  String vaccinationsBatch(String number) {
    return 'Batch $number';
  }

  @override
  String get vaccinationsVet => 'Veterinarian';

  @override
  String get vaccinationsDate => 'Vaccination date';

  @override
  String get vaccinationsNextLabel => 'Next vaccination';

  @override
  String get vaccinationsBatchLabel => 'Batch number';

  @override
  String get vaccinationsTypeLabel => 'Type';

  @override
  String get vaccinationsNotesLabel => 'Notes';

  @override
  String get vaccinationsDeleteTitle => 'Delete record?';

  @override
  String get vaccinationsDeleteBody =>
      'The vaccination record will be permanently deleted.';

  @override
  String get vaccinationsDeleted => 'Record deleted';

  @override
  String get vaccinationsDeleteFailed => 'Couldn\'t delete the record';

  @override
  String get vaccinationsStatTotal => 'Total vaccinations';

  @override
  String get vaccinationsStatThisYear => 'This year';

  @override
  String get vaccinationsStatLast30 => 'Last 30 days';

  @override
  String get vaccinationsStatUpcoming => 'Upcoming';

  @override
  String get vaccinationsStatNext30 => 'Next 30 days';

  @override
  String get vaccinationsStatOverdue => 'Overdue';

  @override
  String get rabbitPickerTitle => 'Select a rabbit';

  @override
  String get rabbitPickerHint => 'Name or tag number';

  @override
  String get rabbitPickerEmpty => 'Not selected';

  @override
  String get rabbitPickerNothingFound => 'No matches found';

  @override
  String get rabbitPickerNothingFoundBody => 'Check the name or tag number.';

  @override
  String get rabbitPickerClear => 'Clear';

  @override
  String get rabbitPickerRequired => 'Select a rabbit';

  @override
  String rabbitPickerInCage(String number) {
    return 'Cage $number';
  }

  @override
  String get rabbitPickerNoCage => 'No cage';

  @override
  String get vaccFormNewTitle => 'New vaccination';

  @override
  String get vaccFormEditTitle => 'Vaccination';

  @override
  String get vaccFormSectionMain => 'Main';

  @override
  String get vaccFormSectionDates => 'Dates';

  @override
  String get vaccFormSectionExtra => 'Extra';

  @override
  String get fieldRecipient => 'For';

  @override
  String get vaccFormType => 'Vaccine type';

  @override
  String get vaccFormName => 'Vaccine name';

  @override
  String get vaccFormNameHint => 'For example, Rabbivac V';

  @override
  String get vaccFormNameEmpty => 'Enter the vaccine name';

  @override
  String get vaccFormDate => 'Vaccination date';

  @override
  String get vaccFormNextDate => 'Next vaccination';

  @override
  String get vaccFormNextNotSet => 'Not scheduled';

  @override
  String get vaccFormPlus3m => 'in 3 months';

  @override
  String get vaccFormPlus6m => 'in 6 months';

  @override
  String get vaccFormPlus1y => 'in 1 year';

  @override
  String get vaccFormBatch => 'Batch number';

  @override
  String get vaccFormBatchHint => 'For example, 12345-67';

  @override
  String get vaccFormVet => 'Veterinarian';

  @override
  String get vaccFormVetHint => 'Who gave the vaccination';

  @override
  String get vaccFormNotes => 'Notes';

  @override
  String get vaccFormCreated => 'Vaccination logged';

  @override
  String get vaccFormUpdated => 'Record updated';

  @override
  String get vaccFormFailed => 'Couldn\'t save';

  @override
  String get medTitle => 'Treatment';

  @override
  String get medEmptyTitle => 'No treatment records';

  @override
  String get medEmptyBody =>
      'Start a medical record — it will collect symptoms, treatment, and costs in one place.';

  @override
  String get medEmptyAction => 'Start a record';

  @override
  String get medNoneInView => 'Nothing in this view';

  @override
  String get medNoneInViewBody =>
      'Choose a different tab or clear the filters.';

  @override
  String get medViewAll => 'All';

  @override
  String get medOutcomeOngoing => 'Ongoing';

  @override
  String get medOutcomeRecovered => 'Recovered';

  @override
  String get medOutcomeDied => 'Died';

  @override
  String get medOutcomeEuthanized => 'Euthanized';

  @override
  String get medDiagnosis => 'Diagnosis';

  @override
  String get medSymptoms => 'Symptoms';

  @override
  String get medTreatment => 'Treatment';

  @override
  String get medMedication => 'Medication';

  @override
  String get medStarted => 'Started';

  @override
  String get medEnded => 'Ended';

  @override
  String get medCost => 'Cost';

  @override
  String get medVet => 'Veterinarian';

  @override
  String get medNotes => 'Notes';

  @override
  String get medNoDiagnosis => 'No diagnosis';

  @override
  String get medDeleteTitle => 'Delete record?';

  @override
  String get medDeleteBody =>
      'The treatment record will be permanently deleted.';

  @override
  String get medDeleted => 'Record deleted';

  @override
  String get medDeleteFailed => 'Couldn\'t delete the record';

  @override
  String get medPeriodFrom => 'From';

  @override
  String get medPeriodTo => 'To';

  @override
  String get commonSummary => 'Summary';

  @override
  String get medStatTotal => 'Total records';

  @override
  String get medStatThisYear => 'This year';

  @override
  String get medStatLastMonth => 'Last month';

  @override
  String get medStatCost => 'Spent';

  @override
  String get medStatOngoing => 'Currently being treated';

  @override
  String medDaysOngoing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String get medFormNewTitle => 'New record';

  @override
  String get medFormEditTitle => 'Medical record';

  @override
  String get medFormRabbit => 'For';

  @override
  String get medFormSectionCase => 'What happened';

  @override
  String get medFormSectionTreatment => 'Treatment';

  @override
  String get medFormSectionDates => 'Timeline and cost';

  @override
  String get medFormSymptomsEmpty => 'Describe the symptoms';

  @override
  String get medFormOutcome => 'Outcome';

  @override
  String get medFormCreated => 'Record created';

  @override
  String get medFormUpdated => 'Record updated';

  @override
  String get medFormFailed => 'Couldn\'t save';

  @override
  String get medFormCostHelp =>
      'The amount will be added to farm expenses as a separate transaction.';

  @override
  String get medFormDosage => 'Dosage';

  @override
  String get medFormEndedDate => 'End date';

  @override
  String get medFormNotSet => 'Not set';

  @override
  String medFormCostLabel(String currency) {
    return 'Cost, $currency';
  }

  @override
  String get commonNumberInvalid => 'Enter a number';

  @override
  String get feedsTitle => 'Feed inventory';

  @override
  String get feedsAdd => 'Add feed';

  @override
  String get feedsEmptyTitle => 'Inventory is empty';

  @override
  String get feedsEmptyBody =>
      'Add feed and the app will warn you when it\'s running low.';

  @override
  String get feedsNoneInView => 'Nothing matches these filters';

  @override
  String get feedsNoneInViewBody =>
      'Clear the filters to see the whole inventory.';

  @override
  String get feedsFilterAll => 'All';

  @override
  String get feedsFilterLowStock => 'Running low';

  @override
  String get feedsFilterType => 'Feed type';

  @override
  String get feedingBulkModeRabbits => 'Rabbits';

  @override
  String get feedingBulkModeCages => 'Cages';

  @override
  String get feedingBulkAddRabbit => 'Add a rabbit';

  @override
  String get feedingBulkRabbitsRequired => 'Select at least one rabbit';

  @override
  String get feedingBulkRemove => 'Remove from list';

  @override
  String get feedingBulkCagesField => 'Which cages';

  @override
  String get feedingBulkCagesRequired => 'Select at least one cage';

  @override
  String get feedingBulkCagesPickTitle => 'Which cages to feed';

  @override
  String feedingBulkCagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cages',
      one: '$count cage',
    );
    return '$_temp0';
  }

  @override
  String get feedingBulkWholeFarm => 'Whole farm';

  @override
  String get feedingBulkClearSelection => 'Clear selection';

  @override
  String get feedingBulkRowUnnamed => 'No row';

  @override
  String get feedingBulkDone => 'Done';

  @override
  String get feedingBulkNoCagesTitle => 'No cages yet';

  @override
  String get feedingBulkNoCagesBody =>
      'Add cages so feedings can be logged for a whole row or the whole farm at once.';

  @override
  String get feedingBulkQuantityEach => 'Amount per animal';

  @override
  String get feedingBulkQuantityEachHint => 'The amount for one recipient.';

  @override
  String feedingBulkQuantityEachNote(String amount) {
    return 'The amount for one recipient. $amount will be deducted in total.';
  }

  @override
  String feedingBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count feedings logged',
      one: '$count feeding logged',
    );
    return '$_temp0';
  }

  @override
  String get feedsFilterAllTypes => 'All types';

  @override
  String get feedsInStock => 'In stock';

  @override
  String get feedsMinStock => 'Minimum';

  @override
  String get feedsLowStockWarning => 'Below the minimum';

  @override
  String get feedsRefill => 'Restock';

  @override
  String get feedsWriteOff => 'Write off';

  @override
  String get feedsRefillTitle => 'Restock inventory';

  @override
  String get feedsWriteOffTitle => 'Write off from inventory';

  @override
  String feedsCurrentStock(String amount) {
    return 'Currently in stock: $amount';
  }

  @override
  String get feedsQuantity => 'Amount';

  @override
  String get feedsQuantityPositive => 'Enter an amount greater than zero';

  @override
  String feedsRefilled(String amount) {
    return 'Restocked by $amount';
  }

  @override
  String feedsWrittenOff(String amount) {
    return 'Written off $amount';
  }

  @override
  String get feedsAdjustFailed => 'Couldn\'t update the stock';

  @override
  String get feedsDeleteTitle => 'Delete feed?';

  @override
  String feedsDeleteBody(String name) {
    return '\"$name\" will be removed from inventory along with its stock history.';
  }

  @override
  String get feedsDeleted => 'Feed deleted';

  @override
  String get feedsDeleteFailed => 'Couldn\'t delete the feed';

  @override
  String get feedFormNewTitle => 'New feed';

  @override
  String get feedFormEditTitle => 'Feed';

  @override
  String get commonSectionMain => 'Main';

  @override
  String get feedFormSectionStock => 'Inventory';

  @override
  String get feedFormName => 'Name';

  @override
  String get feedFormNameEmpty => 'Enter the feed name';

  @override
  String get feedFormType => 'Feed type';

  @override
  String get feedFormUnit => 'Unit';

  @override
  String get feedFormCurrentStock => 'Currently in stock';

  @override
  String get feedFormMinStock => 'Warn when it drops to';

  @override
  String get feedFormMinStockHelp =>
      'Below this amount, the feed will show up under \"Needs attention\" on the home screen.';

  @override
  String get feedFormCost => 'Price per unit';

  @override
  String get feedFormRequired => 'Fill in this field';

  @override
  String get feedFormNegative => 'The number can\'t be negative';

  @override
  String get feedFormCreated => 'Feed added to inventory';

  @override
  String get feedFormUpdated => 'Feed updated';

  @override
  String get feedFormFailed => 'Couldn\'t save the feed';

  @override
  String get feedingTitle => 'Feedings';

  @override
  String get feedingAdd => 'Log a feeding';

  @override
  String get feedingEmptyTitle => 'No feeding records';

  @override
  String get feedingEmptyBody =>
      'Log feedings and the feed usage will be deducted from inventory automatically.';

  @override
  String get feedingNoneInView => 'No records for this period';

  @override
  String get feedingNoneInViewBody =>
      'Choose a different period or clear the filter.';

  @override
  String get feedingUnknownFeed => 'Feed not specified';

  @override
  String feedingForRabbit(String name) {
    return 'Rabbit $name';
  }

  @override
  String feedingForCage(String number) {
    return 'Cage $number';
  }

  @override
  String get feedingForFarm => 'Whole farm';

  @override
  String get feedingEdit => 'Edit';

  @override
  String get feedingDeleteTitle => 'Delete record?';

  @override
  String get feedingDeleteBody =>
      'The feeding record will be deleted. Deducted feed won\'t be returned to inventory.';

  @override
  String get feedingDeleted => 'Record deleted';

  @override
  String get feedingDeleteFailed => 'Couldn\'t delete the record';

  @override
  String get commonPeriod => 'Period';

  @override
  String get feedingFormNewTitle => 'New feeding';

  @override
  String get feedingFormEditTitle => 'Feeding';

  @override
  String get feedingFormSectionWhom => 'Who\'s being fed';

  @override
  String get feedingFormSectionWhat => 'What and how much';

  @override
  String get feedingFormModeRabbit => 'One rabbit';

  @override
  String get feedingFormModeCage => 'Whole cage';

  @override
  String get feedingFormCage => 'Cage';

  @override
  String get feedingFormCageRequired => 'Select a cage';

  @override
  String get feedingFormFeed => 'Feed';

  @override
  String get feedingFormFeedRequired => 'Select a feed';

  @override
  String get feedingFormQuantity => 'Amount';

  @override
  String get feedingFormQuantityRequired => 'Enter an amount';

  @override
  String get feedingFormWhen => 'When';

  @override
  String get feedingFormNotes => 'Notes';

  @override
  String feedingFormStockLeft(String amount) {
    return '$amount left';
  }

  @override
  String get feedingFormUpdated => 'Record updated';

  @override
  String get feedingFormFailed => 'Couldn\'t save the record';

  @override
  String get feedingFormStockNote =>
      'The specified amount will be deducted from inventory.';

  @override
  String get financeTitle => 'Finances';

  @override
  String get financeAdd => 'Add transaction';

  @override
  String get financeEmptyTitle => 'No transactions yet';

  @override
  String get financeEmptyBody =>
      'Log income and expenses and the app will calculate your farm\'s profit automatically.';

  @override
  String get financeNoneInView => 'Nothing matches these filters';

  @override
  String get financeNoneInViewBody =>
      'Clear the filters to see the full ledger.';

  @override
  String get financeIncome => 'Income';

  @override
  String get financeExpenses => 'Expenses';

  @override
  String get financeBalance => 'Balance';

  @override
  String get financeSummaryPeriod => 'All time';

  @override
  String get financeSummaryFiltered => 'Selected period';

  @override
  String get financeAll => 'All';

  @override
  String get financeOnlyIncome => 'Income';

  @override
  String get financeOnlyExpenses => 'Expenses';

  @override
  String get financeCategory => 'Category';

  @override
  String get financeType => 'Type';

  @override
  String get financeDate => 'Date';

  @override
  String get financeDescription => 'Description';

  @override
  String get financeAuthor => 'Recorded by';

  @override
  String financeAuthorLine(String name) {
    return 'Recorded by $name';
  }

  @override
  String get financeTypeIncome => 'Income';

  @override
  String get financeTypeExpense => 'Expense';

  @override
  String get financeDeleteTitle => 'Delete transaction?';

  @override
  String get financeDeleteBody =>
      'The transaction will be permanently removed from the ledger.';

  @override
  String get financeDeleted => 'Transaction deleted';

  @override
  String get financeDeleteFailed => 'Couldn\'t delete the transaction';

  @override
  String get txFormNewTitle => 'New transaction';

  @override
  String get txFormEditTitle => 'Transaction';

  @override
  String get txFormSectionKind => 'Transaction type';

  @override
  String get commonSectionDetails => 'Details';

  @override
  String get txFormIncomeSubtitle => 'Sales, services';

  @override
  String get txFormExpenseSubtitle => 'Purchases, treatment, feed';

  @override
  String get txFormAmount => 'Amount';

  @override
  String get txFormAmountEmpty => 'Enter an amount';

  @override
  String get txFormAmountPositive => 'The amount must be greater than zero';

  @override
  String get txFormDate => 'When';

  @override
  String get txFormRabbit => 'Link to a rabbit';

  @override
  String get txFormRabbitHelp =>
      'Optional. Lets you see income and expenses for a specific animal.';

  @override
  String get txFormDescription => 'Description';

  @override
  String get txFormReceipt => 'Receipt';

  @override
  String get txFormReceiptShoot => 'Take a photo';

  @override
  String get txFormReceiptFromGallery => 'From gallery';

  @override
  String get txFormReceiptReplace => 'Retake';

  @override
  String get txFormReceiptRemove => 'Remove receipt';

  @override
  String get txFormReceiptFailed => 'Could not get the photo';

  @override
  String get txFormCreated => 'Transaction logged';

  @override
  String get txFormUpdated => 'Transaction updated';

  @override
  String get txFormFailed => 'Couldn\'t save the transaction';

  @override
  String get cagesTitle => 'Cages';

  @override
  String get cagesAdd => 'Add cage';

  @override
  String get cagesSearchHint => 'Number or location';

  @override
  String get cagesOnlyAvailable => 'Available only';

  @override
  String get cagesEmptyTitle => 'No cages yet';

  @override
  String get cagesEmptyBody =>
      'Add cages to see where to house rabbits and where there\'s room.';

  @override
  String get cagesNothingFound => 'No matches found';

  @override
  String get cagesNothingFoundBody => 'Check your search or clear the filters.';

  @override
  String cagesOccupancy(int occupied, int capacity) {
    return '$occupied of $capacity occupied';
  }

  @override
  String cagesLastCleaned(String date) {
    return 'Cleaned $date';
  }

  @override
  String get cagesMarkCleaned => 'Mark as cleaned';

  @override
  String get cagesCleaned => 'Cleaning logged';

  @override
  String get cagesCleanFailed => 'Couldn\'t log the cleaning';

  @override
  String get cagesDeleteTitle => 'Delete cage?';

  @override
  String cagesDeleteBody(String number) {
    return 'Cage $number will be removed from the list. Its rabbits will be left without a cage.';
  }

  @override
  String get cagesDeleted => 'Cage deleted';

  @override
  String get cagesDeleteFailed => 'Couldn\'t delete the cage';

  @override
  String get cagesFilterCondition => 'Condition';

  @override
  String get cageFormNewTitle => 'New cage';

  @override
  String get cageFormEditTitle => 'Cage';

  @override
  String get cageFormNumber => 'Number';

  @override
  String get cageFormNumberEmpty => 'Enter the cage number';

  @override
  String get cageFormCapacity => 'How many rabbits it holds';

  @override
  String get cageFormCapacityInvalid => 'Enter a number greater than zero';

  @override
  String get cageFormCapacityGroup => 'A group cage needs at least two spots';

  @override
  String get cageFormSize => 'Size';

  @override
  String get cageFormSizeHint => 'For example, 100×60×45 cm';

  @override
  String get cageFormLocation => 'Location';

  @override
  String get cageFormLocationHint => 'For example, barn, left row';

  @override
  String get cageFormNotes => 'Notes';

  @override
  String get cageFormCreated => 'Cage added';

  @override
  String get cageFormUpdated => 'Cage updated';

  @override
  String get cageFormFailed => 'Couldn\'t save the cage';

  @override
  String get rabbitsTitle => 'Rabbits';

  @override
  String get rabbitsSearchHint => 'Name or tag number';

  @override
  String get herdCagesNoPlace => 'Location not specified';

  @override
  String get rabbitsEmptyTitle => 'No rabbits yet';

  @override
  String get rabbitsEmptyBody =>
      'Add your first rabbit — it\'s the starting point for tracking pedigree, health, and offspring.';

  @override
  String get rabbitsEmptyAction => 'Add a rabbit';

  @override
  String get rabbitsNothingFound => 'No matches found';

  @override
  String get rabbitsNothingFoundBody =>
      'Check your search or clear the filters.';

  @override
  String get rabbitsFilterAll => 'All';

  @override
  String get rabbitsFilterMales => 'Males';

  @override
  String get rabbitsFilterFemales => 'Females';

  @override
  String get rabbitsFilterActive => 'Active';

  @override
  String get rabbitsFilterSold => 'Sold';

  @override
  String get rabbitsFilterDead => 'Dead';

  @override
  String get sexMale => 'Male';

  @override
  String get sexFemale => 'Female';

  @override
  String get sexUnknown => 'Sex not specified';

  @override
  String get rabbitNoTag => 'No tag';

  @override
  String get weightTitle => 'Weigh-ins';

  @override
  String weightSubtitle(String name) {
    return '$name';
  }

  @override
  String get weightEmptyTitle => 'No weigh-ins yet';

  @override
  String get weightEmptyBody =>
      'Log weight to see whether the rabbit is growing well.';

  @override
  String get weightAdd => 'Log weight';

  @override
  String get weightSummary => 'Summary';

  @override
  String get weightCurrent => 'Current';

  @override
  String get weightTrend => 'Since last time';

  @override
  String get weightTotalChange => 'All time';

  @override
  String get weightHistory => 'History';

  @override
  String get weightValue => 'Weight, kg';

  @override
  String get weightValueHint => 'For example, 3.5';

  @override
  String get weightValueEmpty => 'Enter the weight';

  @override
  String get weightValuePositive => 'Weight must be greater than zero';

  @override
  String get weightWhen => 'Weighed on';

  @override
  String get weightNotes => 'Notes';

  @override
  String get weightSaved => 'Weight logged';

  @override
  String get weightSaveFailed => 'Couldn\'t log the weight';

  @override
  String get galleryTitle => 'Photo gallery';

  @override
  String get galleryEmptyTitle => 'No photos yet';

  @override
  String get galleryEmptyBody =>
      'Add photos — the card shows one, and they all live here.';

  @override
  String get galleryAdd => 'Add photo';

  @override
  String get galleryUploaded => 'Photo added';

  @override
  String get galleryCaptionTitle => 'Photo caption';

  @override
  String get galleryCaptionLabel => 'For example, \"After grooming\"';

  @override
  String get galleryCaptionSkip => 'No caption';

  @override
  String get galleryDeleteTitle => 'Delete photo?';

  @override
  String get galleryDeleteBody => 'This can\'t be undone.';

  @override
  String get galleryDeleted => 'Photo deleted';

  @override
  String get pedigreeTitle => 'Pedigree';

  @override
  String get rabbitDetailEdit => 'Edit';

  @override
  String get rabbitDetailDeleteTitle => 'Delete rabbit?';

  @override
  String rabbitDetailDeleteBody(String name) {
    return 'Deleting $name will also remove its weigh-ins, vaccinations, and treatment records.';
  }

  @override
  String get rabbitDetailDeleted => 'Rabbit deleted';

  @override
  String get rabbitDetailDeleteFailed => 'Couldn\'t delete the rabbit';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get healthTitle => 'Health';

  @override
  String get healthMenuLabel => 'Vaccinations and treatment';

  @override
  String get healthKindAll => 'All';

  @override
  String get healthKindVaccination => 'Vaccinations';

  @override
  String get healthKindTreatment => 'Treatment';

  @override
  String get healthEntryVaccination => 'Vaccination';

  @override
  String get healthEntryTreatment => 'Treatment';

  @override
  String get healthPickRabbit => 'History for one rabbit';

  @override
  String get healthEmptyTitle => 'No health records for the herd yet';

  @override
  String get healthEmptyBody =>
      'Log vaccinations and treatments to see each rabbit\'s history and when it\'s due for its next shot.';

  @override
  String get healthNoneInViewTitle => 'Nothing in this view';

  @override
  String healthNoneForRabbitTitle(String name) {
    return 'No health records for $name';
  }

  @override
  String get healthNoneInViewBody =>
      'Clear the filter — the other records are still there.';

  @override
  String get healthRecordTitle => 'What to record?';

  @override
  String get healthRecordVaccination => 'Vaccination';

  @override
  String get healthRecordTreatment => 'Treatment';

  @override
  String get farmSectionMoney => 'Money';

  @override
  String get farmTransactions => 'Income and expenses';

  @override
  String get farmSectionFeed => 'Feed';

  @override
  String get farmFeedStock => 'Feed inventory';

  @override
  String get farmFeedingRecords => 'Feedings';

  @override
  String get farmSectionHealth => 'Health';

  @override
  String get farmSectionReports => 'Reports';

  @override
  String get farmReports => 'Farm summary';

  @override
  String get farmSectionPeople => 'People';

  @override
  String get farmStaff => 'Staff';

  @override
  String get farmSectionApp => 'App';

  @override
  String get farmSettings => 'Settings';

  @override
  String get farmAbout => 'About';

  @override
  String get farmAboutBody =>
      'Track your rabbit farm\'s livestock, feed, health, and finances.';

  @override
  String get farmLogout => 'Sign out';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsAccent => 'Accent color';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsDigestToggle => 'Daily farm digest';

  @override
  String get settingsHerd => 'Herd';

  @override
  String get settingsPurposeAll => 'Purpose for every rabbit';

  @override
  String get settingsPurposeAllHint =>
      'Most farms keep rabbits for one thing. Set it once instead of answering on every card.';

  @override
  String get settingsPurposeAllTitle => 'Set the purpose for everyone?';

  @override
  String settingsPurposeAllBody(String purpose) {
    return 'Every live rabbit on the farm will be set to “$purpose”. Rabbits that have left the farm stay as they are. Different values are replaced and can only be restored one by one. New rabbits will get this purpose too.';
  }

  @override
  String get settingsPurposeAllApply => 'Set it';

  @override
  String settingsPurposeAllDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rabbits changed.',
      one: '$count rabbit changed.',
      zero: 'Nothing to change — everyone was already set.',
    );
    return '$_temp0';
  }

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsSupport => 'Support';

  @override
  String get supportRequestTitle => 'Support';

  @override
  String get supportRequestHint =>
      'Describe what happened. The reply lands on this very screen and as a notification on your phone.';

  @override
  String get supportRequestPlaceholder =>
      'For example: can\'t add a rabbit — the app freezes when saving';

  @override
  String get supportRequestTooShort =>
      'Please describe the issue in more detail — at least 10 characters';

  @override
  String get supportRequestSend => 'Send';

  @override
  String get supportRequestSent => 'Request sent';

  @override
  String get supportContactHint => 'Or reach out directly:';

  @override
  String get settingsPrivacyPolicy => 'Privacy policy';

  @override
  String get settingsLogout => 'Sign out';

  @override
  String get logoutDialogTitle => 'Sign out?';

  @override
  String get logoutDialogBody =>
      'Your records stay on the server — you will see them again after signing in.';

  @override
  String get logoutDialogConfirm => 'Sign out';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsSubscription => 'Plan';

  @override
  String get subscriptionTitle => 'Plan';

  @override
  String get subscriptionNoPlan => 'No plan assigned';

  @override
  String get subscriptionNoPlanHint => 'Contact support to set up a plan.';

  @override
  String get subscriptionContactSupport => 'Contact support';

  @override
  String get subscriptionFree => 'Free plan';

  @override
  String get subscriptionForever => 'Unlimited';

  @override
  String subscriptionExpiresOn(String date) {
    return 'Valid until $date';
  }

  @override
  String subscriptionExpired(String date) {
    return 'Expired on $date';
  }

  @override
  String subscriptionPricePerPeriod(String price) {
    return '$price somoni / 30 days';
  }

  @override
  String get subscriptionPay => 'Pay';

  @override
  String get subscriptionPayAbroadTitle =>
      'Card payment is available in Tajikistan only for now';

  @override
  String get subscriptionPayAbroadBody =>
      'We will extend your plan manually — message support and they will reply.';

  @override
  String get subscriptionPayAbroadAction => 'Message support';

  @override
  String get subscriptionOpenPaymentPage => 'Open payment page';

  @override
  String get subscriptionAfterPayingHint =>
      'Pay using the link that opens, then come back here and tap \"Check payment.\"';

  @override
  String get subscriptionCheckPayment => 'Check payment';

  @override
  String get subscriptionPaymentCompleted => 'Payment received, plan renewed';

  @override
  String get subscriptionPaymentPending =>
      'The bank hasn\'t confirmed the payment yet — try again in a minute';

  @override
  String get splashTagline => 'Farm management';

  @override
  String get registerTitle => 'My own farm';

  @override
  String get registerSubtitle =>
      'Set up your farm — you can invite workers later';

  @override
  String get registerFarmName => 'Farm name';

  @override
  String get registerFarmNameHint =>
      'Leave blank to name it after you. It can\'t be changed later';

  @override
  String get registerFarmNameShort => 'Too short';

  @override
  String get registerFullName => 'Full name';

  @override
  String get registerFullNameHint => 'What\'s your name';

  @override
  String get registerFullNameEmpty => 'Enter your name';

  @override
  String get registerFullNameShort => 'Too short';

  @override
  String get registerEmailEmpty => 'Enter your email';

  @override
  String get registerEmailInvalid => 'That email address looks off';

  @override
  String get registerSubmit => 'Create farm';

  @override
  String get registerHaveAccount => 'Already have an account?';

  @override
  String get registerFailed => 'Couldn\'t register';

  @override
  String get registerConsentPrefix => 'I accept the ';

  @override
  String get registerConsentLink => 'privacy policy';

  @override
  String get registerConsentRequired =>
      'You need to accept the privacy policy to continue';

  @override
  String get birthsTitle => 'Kindlings';

  @override
  String get birthsEmptyTitle => 'No kindlings yet';

  @override
  String get birthsEmptyBody =>
      'Log a kindling and the app will create cards for the kits automatically.';

  @override
  String get birthsAdd => 'Log a kindling';

  @override
  String get birthsMotherUnknown => 'Mother not specified';

  @override
  String birthsMotherLine(String name) {
    return 'Mother: $name';
  }

  @override
  String get birthsFromBreeding => 'From a breeding record';

  @override
  String get birthsAlive => 'Alive';

  @override
  String get birthsDead => 'Dead';

  @override
  String get birthsWeaned => 'Weaned';

  @override
  String get birthsSurvival => 'Survival rate';

  @override
  String get birthsComplications => 'Complications';

  @override
  String get birthsDeleteTitle => 'Delete this kindling record?';

  @override
  String get birthsDeleteBody =>
      'The kits\' cards will stay — only the kindling record itself will be removed.';

  @override
  String get birthsDeleted => 'Record deleted';

  @override
  String get birthsDeleteFailed => 'Couldn\'t delete the record';

  @override
  String get birthsCreateKits => 'Create kit cards';

  @override
  String get birthsKitsDialogTitle => 'Create cards for the kits?';

  @override
  String birthsKitsDialogBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards will be created',
      one: '$count card will be created',
    );
    return '$_temp0';
  }

  @override
  String get birthsNamePrefix => 'Name prefix';

  @override
  String get birthsNamePrefixHint => 'For example, Snowball-';

  @override
  String birthsNamePreview(String first, String second) {
    return 'Will become: $first, $second, …';
  }

  @override
  String birthsKitsCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards created',
      one: '$count card created',
    );
    return '$_temp0';
  }

  @override
  String get birthsKitsFailed => 'Couldn\'t create the cards';

  @override
  String get birthFormNewTitle => 'New kindling';

  @override
  String get birthFormEditTitle => 'Kindling';

  @override
  String get birthFormMother => 'Mother';

  @override
  String get birthFormDate => 'Date of kindling';

  @override
  String get birthFormSectionLitter => 'Litter';

  @override
  String get birthFormAliveLabel => 'Born alive';

  @override
  String get birthFormDeadLabel => 'Born dead';

  @override
  String get birthFormAliveEmpty => 'Enter the count';

  @override
  String get birthFormComplications => 'Complications';

  @override
  String get birthFormComplicationsHint => 'Describe if anything went wrong';

  @override
  String get birthFormNotes => 'Notes';

  @override
  String get birthFormAutoKits => 'Create kit cards right away';

  @override
  String get birthFormCreated => 'Kindling logged';

  @override
  String get birthFormUpdated => 'Record updated';

  @override
  String get birthFormFailed => 'Couldn\'t save the record';

  @override
  String get breedsTitle => 'Breeds';

  @override
  String get breedsSearchHint => 'Breed name';

  @override
  String get breedsAdd => 'Add breed';

  @override
  String get breedsEmptyTitle => 'No breeds yet';

  @override
  String get breedsEmptyBody =>
      'Add breeds to make it easier to pair rabbits and compare weight gain.';

  @override
  String get breedsNothingFound => 'No matches found';

  @override
  String get breedsNothingFoundBody => 'Check your search.';

  @override
  String get breedsDeleteTitle => 'Delete breed?';

  @override
  String breedsDeleteBody(String name) {
    return '\"$name\" will be removed from the list. Rabbits of this breed will remain, without a breed assigned.';
  }

  @override
  String get breedsDeleted => 'Breed deleted';

  @override
  String get breedsDeleteFailed => 'Couldn\'t delete the breed';

  @override
  String get breedPurposeMeat => 'Meat';

  @override
  String get breedPurposeFur => 'Fur';

  @override
  String get breedPurposeDecorative => 'Decorative';

  @override
  String get breedPurposeCombined => 'Meat and fur';

  @override
  String get breedFormNewTitle => 'New breed';

  @override
  String get breedFormEditTitle => 'Breed';

  @override
  String get breedFormName => 'Name';

  @override
  String get breedFormNameHint => 'For example, Californian';

  @override
  String get breedFormNameEmpty => 'Enter the breed name';

  @override
  String get breedFormPurpose => 'Purpose';

  @override
  String get breedFormDescription => 'Description';

  @override
  String get breedFormDescriptionHint => 'What sets this breed apart';

  @override
  String get breedFormSectionTraits => 'Traits';

  @override
  String get breedFormWeight => 'Average weight, kg';

  @override
  String get breedFormWeightHint => 'For example, 4.5';

  @override
  String get breedFormLitter => 'Typical litter size';

  @override
  String get breedFormLitterHint => 'For example, 8';

  @override
  String get breedFormLitterSuffix => 'kits';

  @override
  String get breedFormCreated => 'Breed added';

  @override
  String get breedFormUpdated => 'Breed updated';

  @override
  String get breedFormFailed => 'Couldn\'t save the breed';

  @override
  String get breedingDetailTitle => 'Breeding';

  @override
  String get breedingStatus => 'Status';

  @override
  String get breedingParents => 'Pair';

  @override
  String breedingTag(String tag) {
    return 'Tag $tag';
  }

  @override
  String get breedingDates => 'Dates';

  @override
  String get breedingDate => 'Breeding date';

  @override
  String get breedingExpected => 'Expected kindling';

  @override
  String get breedingPalpation => 'Palpation date';

  @override
  String get breedingPregnancy => 'Pregnancy';

  @override
  String get breedingPregnancyYes => 'Confirmed';

  @override
  String get breedingPregnancyNo => 'Not confirmed';

  @override
  String get breedingNotes => 'Notes';

  @override
  String get breedingRegisterBirth => 'Log kindling';

  @override
  String get breedingDeleteTitle => 'Delete this breeding record?';

  @override
  String get breedingDeleteBody => 'This can\'t be undone.';

  @override
  String get breedingDeleted => 'Record deleted';

  @override
  String get breedingDeleteFailed => 'Couldn\'t delete the record';

  @override
  String get breedingFormNewTitle => 'New breeding';

  @override
  String get breedingFormEditTitle => 'Breeding';

  @override
  String get breedingFormPrefilled => 'Pair filled in from pairing';

  @override
  String get breedingFormMale => 'Male';

  @override
  String get breedingFormFemale => 'Female';

  @override
  String get breedingFormMaleRequired => 'Select a male';

  @override
  String get breedingFormFemaleRequired => 'Select a female';

  @override
  String get breedingFormNotesHint =>
      'Anything worth remembering about this breeding';

  @override
  String get breedingFormCreated => 'Breeding logged';

  @override
  String get breedingFormUpdated => 'Record updated';

  @override
  String get breedingFormFailed => 'Couldn\'t save the record';

  @override
  String get plannerTitle => 'Pairing';

  @override
  String get plannerIntro =>
      'Select a male and a female — the app will check the pedigree and tell you how closely they\'re related.';

  @override
  String get plannerAnalysisFailed => 'Couldn\'t analyze the pedigree';

  @override
  String get plannerResults => 'Results';

  @override
  String get plannerCoefficient => 'Relatedness';

  @override
  String get plannerCommonAncestors => 'Common ancestors';

  @override
  String plannerGenerations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count generations',
      one: '$count generation',
    );
    return '$_temp0 back';
  }

  @override
  String get plannerAdvice => 'What to do';

  @override
  String get plannerPickBoth => 'Select both';

  @override
  String get plannerPlanned => 'Breeding planned';

  @override
  String get plannerPlan => 'Plan breeding';

  @override
  String get plannerPedigreeFailed => 'Couldn\'t load the pedigree';

  @override
  String get staffTitle => 'Staff';

  @override
  String get staffInvite => 'Invite';

  @override
  String get staffOwner => 'Owner';

  @override
  String get staffMembers => 'Staff';

  @override
  String get staffEmptyBody =>
      'You\'re the only one on the farm so far. Invite a helper — they\'ll get access to the same farm.';

  @override
  String get staffInvitesFailed => 'Couldn\'t load invites';

  @override
  String get staffPendingInvites => 'Awaiting response';

  @override
  String staffAccessClosed(String name) {
    return 'Access closed for $name';
  }

  @override
  String get staffSaved => 'Changes saved';

  @override
  String get staffRevokeTitle => 'Revoke invite?';

  @override
  String staffRevokeBody(String email) {
    return 'The code for $email will stop working. You can issue a new one anytime.';
  }

  @override
  String get staffKeep => 'Keep';

  @override
  String get staffRevoke => 'Revoke';

  @override
  String get staffRevoked => 'Invite revoked';

  @override
  String get planLimitStaffTitle => 'Plan staff limit';

  @override
  String get planLimitStaffBody =>
      'The farm has reached the staff limit allowed by the current plan. To invite more, you need a plan with a higher limit.';

  @override
  String get staffInviteTitle => 'Invite to the farm';

  @override
  String get staffInviteEmailHint => 'The person will sign in with this email';

  @override
  String get staffRole => 'Role';

  @override
  String get staffIssueCode => 'Invite worker';

  @override
  String get staffInvitedTitle => 'Worker invited';

  @override
  String staffInvitedPhoneBody(String phone) {
    return 'We do not text $phone — forward the invitation yourself. The link gets them the app, and they sign in with their own number; the code arrives by SMS.';
  }

  @override
  String staffInvitedEmailBody(String email) {
    return 'The invitation email has been sent to $email. Your worker signs in with that address, and the code arrives by email.';
  }

  @override
  String get staffInviteChannelPhone => 'By phone';

  @override
  String get staffInviteChannelEmail => 'By email';

  @override
  String get staffInvitePhoneHint => '+992 XX XXX XX XX';

  @override
  String get staffInvitePhoneInvalid => 'A number like +992 90 123 45 67';

  @override
  String get staffInviteNameLabel => 'Worker\'s name';

  @override
  String get staffInviteNameHint =>
      'This is the name they\'ll appear under on the farm';

  @override
  String get staffInviteNameEmpty => 'Enter the worker\'s name';

  @override
  String staffValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get staffMakeManager => 'Make manager';

  @override
  String get staffMakeWorker => 'Make worker';

  @override
  String get staffOpenAccess => 'Open access';

  @override
  String get staffCloseAccess => 'Close access';

  @override
  String get staffTransferOwnership => 'Transfer ownership';

  @override
  String get staffTransferTitle => 'Transfer ownership?';

  @override
  String staffTransferBody(String name) {
    return 'The farm will transfer to $name, and you\'ll become a manager. This can\'t be undone.';
  }

  @override
  String get staffTransferConfirm => 'Transfer farm';

  @override
  String staffTransferred(String name) {
    return 'Farm transferred to $name';
  }

  @override
  String get rabbitTapToZoom => 'Tap to zoom in';

  @override
  String rabbitTagLine(String tag) {
    return 'Tag $tag';
  }

  @override
  String get rabbitMainInfo => 'Main info';

  @override
  String get rabbitBreed => 'Breed';

  @override
  String get rabbitBreedUnknown => 'Not specified';

  @override
  String get rabbitSex => 'Sex';

  @override
  String get rabbitAge => 'Age';

  @override
  String get rabbitBirthDate => 'Date of birth';

  @override
  String get rabbitAcquiredDate => 'Acquired on';

  @override
  String get rabbitAcquiredDateEmpty => 'Born on the farm';

  @override
  String get rabbitColor => 'Color';

  @override
  String get rabbitWeight => 'Weight';

  @override
  String get rabbitQuickActions => 'What you can view';

  @override
  String get rabbitWeightHistory => 'Weight history';

  @override
  String get rabbitPedigree => 'Pedigree';

  @override
  String get rabbitStatus => 'Status';

  @override
  String get rabbitCondition => 'Condition';

  @override
  String get rabbitPurpose => 'Purpose';

  @override
  String get rabbitPlacement => 'Where it lives';

  @override
  String get rabbitCage => 'Cage';

  @override
  String get rabbitLocation => 'Location';

  @override
  String get rabbitParents => 'Parents';

  @override
  String get rabbitFather => 'Father';

  @override
  String get rabbitMother => 'Mother';

  @override
  String get rabbitNotes => 'Notes';

  @override
  String get rabbitDates => 'Records';

  @override
  String get rabbitCreatedAt => 'Added';

  @override
  String get rabbitUpdatedAt => 'Last updated';

  @override
  String get purposeBreeding => 'Breeding stock';

  @override
  String get purposeMeat => 'Meat';

  @override
  String get purposeFur => 'Fur';

  @override
  String get purposeSale => 'For sale';

  @override
  String get purposePet => 'Pet';

  @override
  String get rabbitFormNewTitle => 'New rabbit';

  @override
  String get rabbitFormEditTitle => 'Rabbit';

  @override
  String get rabbitFormPhotoAdd => 'Add photo';

  @override
  String get rabbitFormPhotoChange => 'Change photo';

  @override
  String get rabbitFormPhotoGallery => 'Choose from gallery';

  @override
  String get rabbitFormPhotoCamera => 'Take a photo';

  @override
  String get rabbitFormPhotoRemove => 'Remove photo';

  @override
  String get rabbitFormPhotoFailed => 'Couldn\'t get the photo';

  @override
  String get rabbitFormName => 'Name';

  @override
  String get rabbitFormNameHint => 'What\'s its name';

  @override
  String get rabbitFormNameEmpty => 'Enter a name';

  @override
  String get rabbitFormTag => 'Tag number';

  @override
  String get rabbitFormTagEmpty => 'Enter the tag number';

  @override
  String get rabbitFormBreedRequired => 'Select a breed';

  @override
  String get rabbitFormBreedsFailed => 'Couldn\'t load breeds';

  @override
  String get rabbitFormBreedsEmpty => 'No breeds yet';

  @override
  String get rabbitFormBreedsEmptyHint =>
      'A breed is required to add a rabbit. Add the one you keep.';

  @override
  String get rabbitFormBreedsEmptyAction => 'Add a breed';

  @override
  String get rabbitFormColor => 'Color';

  @override
  String get rabbitFormColorHint => 'Gray, white, black…';

  @override
  String get rabbitFormWeight => 'Weight, kg';

  @override
  String get rabbitFormNotes => 'Notes';

  @override
  String get rabbitFormNotesHint =>
      'Anything worth remembering about this rabbit';

  @override
  String get rabbitFormCreated => 'Rabbit added';

  @override
  String get rabbitFormUpdated => 'Details updated';

  @override
  String get rabbitFormFailed => 'Couldn\'t save';

  @override
  String get rabbitFormLoadFailed => 'Couldn\'t load the rabbit';

  @override
  String get planLimitRabbitsTitle => 'Plan rabbit limit';

  @override
  String get planLimitRabbitsBody =>
      'The farm has reached the rabbit limit allowed by the current plan. To add more, you need a plan with a higher limit — contact the farm owner.';

  @override
  String get statusHealthy => 'Healthy';

  @override
  String get statusSick => 'Sick';

  @override
  String get statusQuarantine => 'Quarantine';

  @override
  String get statusPregnant => 'Pregnant';

  @override
  String get statusSold => 'Sold';

  @override
  String get statusDead => 'Deceased';

  @override
  String get purposeShow => 'For shows';

  @override
  String periodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String periodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '$count month',
    );
    return '$_temp0';
  }

  @override
  String get periodYear => 'Year';

  @override
  String get periodAll => 'All time';

  @override
  String get statusInactive => 'Inactive';

  @override
  String get pedigreeSelf => 'Rabbit';

  @override
  String get pedigreeGrandparents => 'Grandparents';

  @override
  String get pedigreeFathersParents => 'Father\'s parents';

  @override
  String get pedigreeMothersParents => 'Mother\'s parents';

  @override
  String get pedigreeHint => 'Tap a card to open that rabbit';

  @override
  String get pedigreeGrandfather => 'Grandfather';

  @override
  String get pedigreeGrandmother => 'Grandmother';

  @override
  String get chartNoData => 'Nothing to show yet';

  @override
  String get chartWeight => 'Weight chart';

  @override
  String get feedStatsTitle => 'Inventory by the numbers';

  @override
  String get feedStatsEmptyTitle => 'Inventory is still empty';

  @override
  String get feedStatsEmptyBody =>
      'Add feed — this will show stock composition, its value, and low-stock warnings.';

  @override
  String get feedStatsPositions => 'Feed types';

  @override
  String get feedStatsLow => 'Running low';

  @override
  String get feedStatsValue => 'Inventory value';

  @override
  String get feedStatsByType => 'Breakdown by type';

  @override
  String get feedStatsLowList => 'Low stock';

  @override
  String get feedStatsAllGood => 'Stock is sufficient across the board';

  @override
  String feedStatsMinimum(String amount) {
    return 'minimum $amount';
  }

  @override
  String get feedingStatsTitle => 'Feedings by the numbers';

  @override
  String get feedingStatsEmptyTitle => 'No feedings in this period';

  @override
  String get feedingStatsEmptyBody =>
      'Choose a wider period or log a feeding — usage and cost will be calculated automatically.';

  @override
  String get feedingStatsCount => 'Feedings';

  @override
  String get feedingStatsCost => 'Feed cost';

  @override
  String get feedingStatsGiven => 'Given';

  @override
  String get feedingStatsByFeed => 'By feed';

  @override
  String feedingStatsChartTitle(String unit) {
    return 'Usage by feed type, $unit';
  }

  @override
  String get feedingStatsChartTitlePlain => 'Usage by feed type';

  @override
  String get financeStatsTitle => 'Finances by the numbers';

  @override
  String get financeStatsEmptyTitle => 'No transactions in this period';

  @override
  String get financeStatsEmptyBody =>
      'Choose a wider period or log your first transaction — totals will be calculated automatically.';

  @override
  String get financeProfit => 'Profit';

  @override
  String get financeLoss => 'Loss';

  @override
  String get financeIncomeByCategory => 'Income by category';

  @override
  String get financeExpensesByCategory => 'Expenses by category';

  @override
  String get financeRecent => 'Recent transactions';

  @override
  String get txCategorySaleRabbit => 'Rabbit sale';

  @override
  String get txCategorySaleMeat => 'Meat sale';

  @override
  String get txCategorySaleFur => 'Fur sale';

  @override
  String get txCategoryBreedingFee => 'Breeding fee';

  @override
  String get txCategoryFeed => 'Feed';

  @override
  String get txCategoryVeterinary => 'Veterinary care';

  @override
  String get txCategoryEquipment => 'Equipment';

  @override
  String get txCategoryUtilities => 'Utilities';

  @override
  String get txCategoryOther => 'Other';

  @override
  String get reportsOutcomeUnknown => 'Outcome not specified';

  @override
  String get reportsFeedUsed => 'Used';

  @override
  String get reportsTabFarm => 'Farm';

  @override
  String get reportsTabHealth => 'Health';

  @override
  String get reportsTabFinance => 'Money';

  @override
  String reportsPeriodRange(String from, String to) {
    return 'From $from to $to';
  }

  @override
  String get reportsPopulationNow => 'Rabbits now';

  @override
  String get reportsBirths => 'Kindlings';

  @override
  String get reportsBreedings => 'Breedings';

  @override
  String get reportsVaccinations => 'Vaccinations';

  @override
  String get reportsMedicalRecords => 'Treatment';

  @override
  String get reportsFeedings => 'Feedings';

  @override
  String get reportsActivity => 'For this period';

  @override
  String get reportsByBreed => 'Livestock by breed';

  @override
  String get reportsByPurpose => 'By purpose';

  @override
  String reportsBreedUnknown(int id) {
    return 'Breed #$id';
  }

  @override
  String get reportsMoney => 'Money for this period';

  @override
  String get reportsNoActivityTitle => 'No records for this period';

  @override
  String get reportsNoActivityBody =>
      'Choose a wider period — or log a breeding, vaccination, or feeding, and it will show up here.';

  @override
  String get reportsFarmEmptyTitle => 'Nothing to build a report from yet';

  @override
  String get reportsFarmEmptyBody =>
      'Add your first rabbit — the report will build itself from your day-to-day records.';

  @override
  String get reportsHealthEmptyTitle =>
      'No vaccinations or treatments in this period';

  @override
  String get reportsHealthEmptyBody =>
      'Choose a wider period or log a vaccination — the report will be calculated automatically.';

  @override
  String get reportsVaccinesByName => 'Vaccinations by vaccine';

  @override
  String get reportsRecordsByOutcome => 'Treatment by outcome';

  @override
  String get farmSectionPlatform => 'Platform';

  @override
  String get farmPlatformAdmin => 'Farms and plans';

  @override
  String get platformTitle => 'Platform';

  @override
  String get platformTabSummary => 'Summary';

  @override
  String get platformTabFarms => 'Farms';

  @override
  String get platformTabPlans => 'Plans';

  @override
  String get platformTabAnnouncements => 'Announcements';

  @override
  String get platformTabSupport => 'Requests';

  @override
  String get platformSummarySectionFarms => 'Farms';

  @override
  String get platformSummarySectionStatus => 'Status';

  @override
  String get platformSummarySectionActivity => 'Activity';

  @override
  String get platformSummarySectionData => 'Data';

  @override
  String get platformSummaryTotalFarms => 'Total farms';

  @override
  String get platformSummaryFree => 'On free plan';

  @override
  String get platformSummaryPaid => 'On paid plan';

  @override
  String get platformSummaryExpired => 'Plan expired';

  @override
  String get platformSummaryAtLimit => 'At plan limit';

  @override
  String get platformSummaryRegistrations30d => 'Registrations in 30 days';

  @override
  String get platformSummaryRabbitsTotal => 'Total rabbits';

  @override
  String get platformSummaryStorageTotal => 'Total storage used';

  @override
  String countFarms(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count farms',
      one: '$count farm',
    );
    return '$_temp0';
  }

  @override
  String countAnnouncements(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count announcements',
      one: '$count announcement',
    );
    return '$_temp0';
  }

  @override
  String get platformFarmsEmptyTitle => 'No farms yet';

  @override
  String get platformFarmsEmptyBody =>
      'Every farm on the service will show up here automatically as soon as someone registers.';

  @override
  String get platformFarmsNothingFound => 'No matches found';

  @override
  String get platformFarmsNothingFoundBody =>
      'Check your search or clear the filter.';

  @override
  String get platformOwnerMissing => 'No owner assigned';

  @override
  String get platformNoPlan => 'No plan';

  @override
  String get platformNoPlanHint => 'No limits';

  @override
  String get platformRabbits => 'Rabbits';

  @override
  String get platformStaff => 'People';

  @override
  String platformUsageOfLimit(int used, int limit) {
    return '$used of $limit';
  }

  @override
  String platformUsageUnlimited(int used) {
    return '$used, no limit';
  }

  @override
  String get platformAtLimit => 'At plan limit';

  @override
  String get platformNearLimit => 'Approaching plan limit';

  @override
  String get platformFarmsSearchHint => 'Farm, owner, email, phone';

  @override
  String platformFilterInactive(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Hasn\'t logged in for $days days',
      one: 'Hasn\'t logged in for $days day',
    );
    return '$_temp0';
  }

  @override
  String get platformFilterExpired => 'Plan expired';

  @override
  String platformFilterUnknown(String filter) {
    return 'Unknown filter: $filter';
  }

  @override
  String get platformChangePlan => 'Change plan';

  @override
  String get platformAssignPlan => 'Assign plan';

  @override
  String platformPlanSheetTitle(String farm) {
    return 'Plan for \"$farm\"';
  }

  @override
  String get platformPlanOff => 'No plan — running without limits';

  @override
  String get platformPlanAssigned => 'Plan updated';

  @override
  String get platformPlanInactive => 'inactive';

  @override
  String get platformPlansEmptyTitle => 'No plans yet';

  @override
  String get platformPlansEmptyBody =>
      'Without any plans, all farms run without limits. Create the first one to start assigning it.';

  @override
  String get platformPlanNew => 'New plan';

  @override
  String get platformPlanEdit => 'Edit';

  @override
  String get platformPlanDeleteTitle => 'Delete plan?';

  @override
  String platformPlanDeleteFarms(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count farms are on it — they will run without limits.',
      one: '$count farm is on it — it will run without limits.',
      zero: 'No farm is on this plan right now.',
    );
    return '$_temp0';
  }

  @override
  String platformPlanDeleteBody(String name) {
    return '\"$name\" will be removed from the list, and farms on it will run without limits. Their records won\'t be affected.';
  }

  @override
  String get platformPlanDeleted => 'Plan deleted';

  @override
  String get platformPlanUnlimited => 'Unlimited';

  @override
  String get platformPlanFree => 'Free';

  @override
  String platformPlanLimitRabbits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'up to $count rabbits',
      one: 'up to $count rabbit',
    );
    return '$_temp0';
  }

  @override
  String platformPlanLimitStaff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'up to $count people',
      one: 'up to $count person',
    );
    return '$_temp0';
  }

  @override
  String get platformPlanFormNewTitle => 'New plan';

  @override
  String get platformPlanFormEditTitle => 'Plan';

  @override
  String get platformPlanFormName => 'Name';

  @override
  String get platformPlanFormNameHint => 'For example, \"Basic\"';

  @override
  String get platformPlanFormNameEmpty => 'Enter a name';

  @override
  String get platformPlanFormPrice => 'Monthly price';

  @override
  String get platformPlanFormPriceHint => 'Leave blank for free';

  @override
  String get platformPlanFormSectionLimits => 'Limits';

  @override
  String get platformPlanFormMaxRabbits => 'Max rabbits';

  @override
  String get platformPlanFormMaxStaff => 'Max people';

  @override
  String get platformPlanFormLimitHint => 'Leave blank for no limit';

  @override
  String get platformPlanFormActive => 'Plan is active';

  @override
  String get platformPlanFormActiveHint =>
      'An inactive plan stays with farms already assigned to it, but can\'t be given to new ones.';

  @override
  String get platformPlanFormDefault => 'Give to new farms';

  @override
  String get platformPlanFormDefaultHint =>
      'This plan is automatically assigned to every newly registered farm. Only one plan can be set this way — assigning it to another means unsetting it from the current one.';

  @override
  String get platformPlanFormCreated => 'Plan created';

  @override
  String get platformPlanFormUpdated => 'Plan updated';

  @override
  String get platformFarmTitleFallback => 'Farm';

  @override
  String get platformFarmSectionOwner => 'Owner and contact';

  @override
  String get platformFarmSectionAccess => 'Access';

  @override
  String get platformFarmSectionImpersonate => 'View as customer';

  @override
  String get platformFarmSectionPlan => 'Plan';

  @override
  String get platformFarmSectionExtras => 'Grace allowance';

  @override
  String get platformFarmSectionUsage => 'Usage';

  @override
  String get platformFarmSectionStaff => 'Staff';

  @override
  String get platformFarmSectionPayments => 'Payments';

  @override
  String get platformFarmSectionFacts => 'More about the farm';

  @override
  String get platformFarmSectionExport => 'Data export';

  @override
  String get platformFarmSectionDanger => 'Delete farm';

  @override
  String get platformFarmContactMissing =>
      'No email or phone — no way to reach them';

  @override
  String get platformFarmStatusActive => 'Running normally';

  @override
  String get platformFarmStatusActiveHint =>
      'The farm can read and write its data without restriction.';

  @override
  String get platformFarmStatusReadOnly => 'Read-only';

  @override
  String get platformFarmStatusReadOnlyHint =>
      'Data is visible but nothing can be written. Used for non-payment: the farm\'s history stays with the farmer, but they can\'t work in it until they pay.';

  @override
  String get platformFarmStatusSuspended => 'Access closed';

  @override
  String get platformFarmStatusSuspendedHint =>
      'The farm can\'t be reached by anyone — no writing, no viewing.';

  @override
  String platformFarmStatusUnknown(String status) {
    return 'Unknown status: $status';
  }

  @override
  String get platformFarmStatusChange => 'Change access';

  @override
  String platformFarmStatusSheetTitle(String farm) {
    return 'Access for \"$farm\"';
  }

  @override
  String get platformFarmStatusConfirmTitle => 'Change access?';

  @override
  String platformFarmStatusConfirmBody(String status) {
    return 'The farm will move to \"$status\" status. People on the farm will see this immediately, without signing in again.';
  }

  @override
  String get platformFarmStatusApply => 'Apply';

  @override
  String get platformFarmStatusUpdated => 'Access updated';

  @override
  String get platformFarmSectionAudit => 'What was done to it';

  @override
  String get platformFarmAuditEmpty => 'No admin has touched this farm.';

  @override
  String get platformFarmAuditLoading => 'Checking the log…';

  @override
  String get platformFarmAuditAll => 'Full log';

  @override
  String platformFarmStatusExpiredWarning(String date) {
    return 'The plan expired on $date. The nightly check will put the farm back to read-only — extend the plan first if the access is to stay.';
  }

  @override
  String get platformFarmPlanForever => 'Unlimited';

  @override
  String platformFarmPlanExpires(String date) {
    return 'Valid until $date';
  }

  @override
  String platformFarmPlanExpired(String date) {
    return 'Expired on $date';
  }

  @override
  String get platformFarmPlanExtend => 'Extend manually';

  @override
  String get platformFarmPlanExtended => 'Plan duration updated';

  @override
  String get platformFarmExtrasNone => 'No grace allowance — plan limits apply';

  @override
  String get platformFarmExtrasGrant => 'Grant allowance';

  @override
  String get platformFarmExtrasEdit => 'Edit';

  @override
  String get platformFarmExtrasClear => 'Remove allowance';

  @override
  String platformFarmExtrasRabbits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count rabbits',
      one: '+$count rabbit',
    );
    return '$_temp0';
  }

  @override
  String platformFarmExtrasStaff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count people',
      one: '+$count person',
    );
    return '$_temp0';
  }

  @override
  String platformFarmExtrasUntil(String date) {
    return 'until $date';
  }

  @override
  String get platformFarmExtrasEndless => 'no expiration';

  @override
  String platformFarmExtrasExpired(String date) {
    return 'Allowance expired on $date — plan limits apply again';
  }

  @override
  String get platformFarmExtrasFormTitle => 'Allowance beyond the plan';

  @override
  String get platformFarmExtrasFormBody =>
      'An addition to the limits for this one farm. The plan itself doesn\'t change — for this farm or any other.';

  @override
  String get platformFarmExtrasFormRabbits => 'Extra rabbits';

  @override
  String get platformFarmExtrasFormStaff => 'Extra people';

  @override
  String get platformFarmExtrasFormAmountHint => 'Leave blank for no addition';

  @override
  String get platformFarmExtrasFormUntil => 'Valid until';

  @override
  String get platformFarmExtrasFormSetDeadline => 'Set a deadline';

  @override
  String get platformFarmExtrasFormEndlessHint =>
      'Without a deadline, the allowance never expires.';

  @override
  String get platformFarmExtrasFormEmpty =>
      'Specify rabbits or people — or remove the allowance';

  @override
  String get platformFarmExtrasSaved => 'Allowance updated';

  @override
  String get platformFarmExtrasCleared => 'Allowance removed';

  @override
  String get platformFarmStaffNever => 'Never signed in';

  @override
  String platformFarmStaffLastLogin(String date) {
    return 'Last signed in $date';
  }

  @override
  String get platformFarmStaffBlocked => 'Access closed';

  @override
  String get platformFarmStaffEmpty => 'No one on staff — not even the owner';

  @override
  String get platformFarmPaymentsEmpty => 'No payments yet';

  @override
  String get platformFarmPaymentNew => 'Started';

  @override
  String get platformFarmPaymentCompleted => 'Paid';

  @override
  String get platformFarmPaymentFailed => 'Failed';

  @override
  String get platformFarmImpersonate => 'View as customer';

  @override
  String get platformFarmImpersonateHint =>
      'See the app the way the farm owner sees it — instead of going back and forth about what\'s on their screen. Read-only, 15 minutes, logged.';

  @override
  String get platformFarmImpersonateTitle => 'View as customer?';

  @override
  String platformFarmImpersonateBody(String farmName) {
    return 'You\'ll see $farmName through the owner\'s eyes — without the ability to change anything. The session ends automatically after 15 minutes, or when you tap \"Exit.\"';
  }

  @override
  String get platformFarmImpersonateReasonLabel => 'Reason';

  @override
  String get platformFarmImpersonateReasonHint =>
      'For example: support ticket #482';

  @override
  String get platformFarmImpersonateReasonRequired =>
      'Enter a reason — without it, this won\'t be logged';

  @override
  String get platformFarmImpersonateConfirm => 'Enter';

  @override
  String impersonationBanner(String farmName) {
    return 'Viewing \"$farmName\" — read-only';
  }

  @override
  String get impersonationExit => 'Exit';

  @override
  String get impersonationExpired =>
      'The viewing session has expired — you\'re back in your own account';

  @override
  String get farmStatusBannerReadOnly =>
      'Read-only access — renew your plan to make changes again';

  @override
  String get farmStatusBannerSuspended => 'Access closed — contact support';

  @override
  String get farmStatusBannerAction => 'Plan';

  @override
  String get farmStatusBannerContactSupport => 'Support';

  @override
  String get platformFarmExport => 'Export data';

  @override
  String get platformFarmExportHint =>
      'A snapshot of all the farm\'s records — rabbits, treatment, feed, payments. Useful for a \"give me my data\" request.';

  @override
  String platformFarmExportGeneratedAt(String date) {
    return 'Snapshot generated $date';
  }

  @override
  String get platformFarmDelete => 'Delete farm';

  @override
  String get platformFarmDeleteHint =>
      'Access closes right away; records and files are permanently removed after 30 days. The farm can be restored until then.';

  @override
  String get platformFarmDeleteTitle => 'Delete farm?';

  @override
  String get platformFarmDeleteBody =>
      'People on the farm will lose access immediately. Rabbits, treatment records, photos, and payments will be permanently deleted after 30 days — deletion can be undone until then. Type the farm\'s name to confirm.';

  @override
  String get platformFarmDeleteConfirmLabel => 'Farm name';

  @override
  String platformFarmDeleteConfirmHint(String name) {
    return 'Type \"$name\"';
  }

  @override
  String get platformFarmDeleteMismatch =>
      'The name doesn\'t match the farm\'s name';

  @override
  String get platformFarmDeleted => 'Farm deleted';

  @override
  String platformFarmDeletedBanner(String date) {
    return 'Farm deleted on $date. Records and files will be permanently erased 30 days after deletion.';
  }

  @override
  String get platformFarmDeletedLocked =>
      'While the farm is deleted, access and allowances can\'t be changed — restore it first.';

  @override
  String get platformFarmRestore => 'Restore';

  @override
  String get platformFarmRestored => 'Farm restored';

  @override
  String get platformFarmStorage => 'Storage used';

  @override
  String get platformFarmLastActive => 'Last login';

  @override
  String get platformFarmNeverActive => 'Never logged in';

  @override
  String get platformFarmCreatedAt => 'Farm created';

  @override
  String get platformSupportRequestsEmptyTitle => 'No requests yet';

  @override
  String get platformSupportRequestsEmptyBody =>
      'Questions from farms will show up here — a farmer writes in via Settings → Support.';

  @override
  String get platformSupportRequestNew => 'new';

  @override
  String get platformSupportRequestResolved => 'resolved';

  @override
  String get platformSupportRequestResolve => 'Mark as resolved';

  @override
  String countSupportRequests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count requests',
      one: '$count request',
    );
    return '$_temp0';
  }

  @override
  String get platformAnnouncementsEmptyTitle => 'No announcements yet';

  @override
  String get platformAnnouncementsEmptyBody =>
      'A history of broadcasts will stay here: what was sent, to whom, and how many received it. A sent announcement can\'t be edited or recalled, so this list helps avoid sending the same thing twice.';

  @override
  String get platformAnnouncementNew => 'New announcement';

  @override
  String get platformAnnouncementSend => 'Send';

  @override
  String get platformAnnouncementTargetAll => 'All farms';

  @override
  String get platformAnnouncementTargetAllHint =>
      'Every farm on the service, except deleted ones';

  @override
  String get platformAnnouncementTargetFarm => 'One farm';

  @override
  String get platformAnnouncementTargetFarmHint =>
      'A single farm — for example, in response to their request';

  @override
  String get platformAnnouncementTargetFilter => 'By farm filter';

  @override
  String get platformAnnouncementTargetFilterHint =>
      'The same filters as in the farm list: no plan, at limit, access closed';

  @override
  String platformAnnouncementAudienceFarm(String farm) {
    return 'Farm \"$farm\"';
  }

  @override
  String platformAnnouncementAudienceFilter(String filter) {
    return 'Filter \"$filter\"';
  }

  @override
  String get platformAnnouncementChannelPush => 'Push';

  @override
  String get platformAnnouncementChannelPushHint =>
      'In-app notification for the farm';

  @override
  String get platformAnnouncementChannelEmail => 'Email';

  @override
  String get platformAnnouncementChannelEmailHint =>
      'Message to the address on their profile';

  @override
  String platformAnnouncementReach(int farms, int recipients) {
    String _temp0 = intl.Intl.pluralLogic(
      farms,
      locale: localeName,
      other: '$farms farms',
      one: '$farms farm',
    );
    String _temp1 = intl.Intl.pluralLogic(
      recipients,
      locale: localeName,
      other: '$recipients recipients',
      one: '$recipients recipient',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get platformAnnouncementNobody =>
      'No recipients found — the announcement wasn\'t sent to anyone';

  @override
  String platformAnnouncementDelivered(int sent, int attempted) {
    return 'delivered $sent of $attempted';
  }

  @override
  String get platformAnnouncementDeliveredNobody =>
      'there was no one to send to';

  @override
  String get platformAnnouncementDeliveryUnknown => 'result not saved';

  @override
  String get platformAnnouncementFormTitle => 'New announcement';

  @override
  String get platformAnnouncementFormSubject => 'Subject';

  @override
  String get platformAnnouncementFormSubjectHint =>
      'This becomes the email subject and push title';

  @override
  String get platformAnnouncementFormBody => 'Message';

  @override
  String get platformAnnouncementFormBodyHint => 'What farms need to know';

  @override
  String get platformAnnouncementFormSectionChannels => 'Channels';

  @override
  String get platformAnnouncementFormNoSms =>
      'SMS isn\'t available for announcements: the payment gateway only accepts pre-approved templates, and an announcement is free-form text.';

  @override
  String get platformAnnouncementFormSectionTarget => 'Recipients';

  @override
  String get platformAnnouncementFormPickFarm => 'Select a farm';

  @override
  String get platformAnnouncementFormPickFilter => 'Select a filter';

  @override
  String get platformAnnouncementFarmSheetTitle => 'Which farm to send to';

  @override
  String get platformAnnouncementFilterSheetTitle =>
      'Which farm filter to send to';

  @override
  String get platformAnnouncementConfirmTitle => 'Send announcement?';

  @override
  String get platformAnnouncementConfirmBody =>
      'The message will be sent to recipients immediately. A sent announcement can\'t be recalled or corrected.';

  @override
  String platformAnnouncementConfirmAudience(String audience) {
    return 'To: $audience';
  }

  @override
  String platformAnnouncementConfirmChannels(String channels) {
    return 'Channels: $channels';
  }

  @override
  String platformAnnouncementSentOk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Announcement sent to $count recipients',
      one: 'Announcement sent to $count recipient',
    );
    return '$_temp0';
  }

  @override
  String platformAnnouncementSentPartly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Announcement sent to $count recipients, but some messages didn\'t go through — see the row in the list',
      one:
          'Announcement sent to $count recipient, but some messages didn\'t go through — see the row in the list',
    );
    return '$_temp0';
  }

  @override
  String get platformAnnouncementSentPlain => 'Announcement sent';

  @override
  String get storageUnitBytes => 'B';

  @override
  String get storageUnitKb => 'KB';

  @override
  String get storageUnitMb => 'MB';

  @override
  String get storageUnitGb => 'GB';

  @override
  String get emptyNoRecordsTitle => 'No records';

  @override
  String get emptyNoRecordsBody => 'Add the first one.';

  @override
  String get onbWelcomeTitle => 'RabbitFarm';

  @override
  String get onbWelcomeBody =>
      'Cages, matings, kindlings, feed and money, all recorded and always at hand. The app reminds you when to put the nest box in and when shots are due.';

  @override
  String get onbWelcomeStart => 'Get started';

  @override
  String get onbWelcomeHaveAccount => 'I already have a farm';

  @override
  String get onbHerdTitle => 'How many rabbits do you keep?';

  @override
  String get onbHerdSubtitle => 'Roughly, young stock included.';

  @override
  String get onbHerdUpTo20 => 'Up to 20';

  @override
  String get onbHerdUpTo20Hint => 'Just for my own table';

  @override
  String get onbHerdUpTo100 => '20 to 100';

  @override
  String get onbHerdUpTo100Hint => 'A small holding';

  @override
  String get onbHerdUpTo500 => '100 to 500';

  @override
  String get onbHerdUpTo500Hint => 'A farm that sells';

  @override
  String get onbHerdOver500 => 'More than 500';

  @override
  String get onbHerdOver500Hint => 'A large operation';

  @override
  String get onbFocusTitle => 'What matters most to record?';

  @override
  String get onbFocusSubtitle =>
      'Pick everything that fits. The rest stays available anyway.';

  @override
  String get onbFocusBreeding => 'Matings and kindlings';

  @override
  String get onbFocusFeeding => 'Feed and consumption';

  @override
  String get onbFocusHealth => 'Vaccinations and treatment';

  @override
  String get onbFocusMoney => 'Sales and expenses';

  @override
  String get onbFocusNext => 'Next';

  @override
  String get onbCrewTitle => 'Who will use the app?';

  @override
  String get onbCrewSubtitle => 'You can change this at any time.';

  @override
  String get onbCrewAlone => 'Only me';

  @override
  String get onbCrewAloneHint => 'No invites, no access settings';

  @override
  String get onbCrewHelpers => 'Me and my helpers';

  @override
  String get onbCrewHelpersHint =>
      'Everyone records from their own phone, and you can see who entered what';

  @override
  String get onbDoneTitle => 'Where we start';

  @override
  String get onbDoneSubtitle =>
      'These steps will be waiting on the home screen.';

  @override
  String get onbDoneCreate => 'Create my farm';

  @override
  String get onbBack => 'Back';

  @override
  String get onbSkip => 'Skip';

  @override
  String get onbCountryTitle => 'Where is your farm?';

  @override
  String get onbCountrySubtitle =>
      'Currency, time and sign-in method depend on this';

  @override
  String countryLine(String country) {
    return 'Country: $country';
  }

  @override
  String get countryTJ => 'Tajikistan';

  @override
  String get countryUZ => 'Uzbekistan';

  @override
  String get countryKG => 'Kyrgyzstan';

  @override
  String get countryKZ => 'Kazakhstan';

  @override
  String get countryRU => 'Russia';

  @override
  String get countryAF => 'Afghanistan';

  @override
  String get loginSmsUnavailable =>
      'SMS codes do not reach your country — sign in by email';

  @override
  String get firstStepCages => 'Set up your cages';

  @override
  String get firstStepRabbits => 'Add your does and bucks';

  @override
  String get firstStepBreeding => 'Record your first mating';

  @override
  String get firstStepFeeding => 'Log your first feeding';

  @override
  String get firstStepHealth => 'Log your first vaccination';

  @override
  String get firstStepMoney => 'Record your first sale';

  @override
  String get firstStepHelpers => 'Invite a helper';

  @override
  String get activationChecklistFarmCreated => 'Farm created';

  @override
  String activationChecklistProgress(int done, int total) {
    return '$done of $total';
  }

  @override
  String get deathFormTitle => 'Record a death';

  @override
  String get deathFormRabbit => 'Rabbit';

  @override
  String get deathFormDate => 'Date';

  @override
  String get deathFormReason => 'Cause';

  @override
  String get deathFormReasonHint => 'What it died of, if you know';

  @override
  String get deathFormSubmit => 'Record';

  @override
  String get deathFormSaved => 'Death recorded';

  @override
  String get saleFormTitle => 'Record a sale';

  @override
  String get saleFormRabbit => 'Rabbit';

  @override
  String get saleFormAmount => 'Price';

  @override
  String get saleFormAmountHelp =>
      'The amount goes into the income book, the rabbit becomes sold.';

  @override
  String get saleFormAmountEmpty => 'Say what it sold for';

  @override
  String get saleFormDate => 'Day of sale';

  @override
  String get saleFormBuyer => 'Buyer';

  @override
  String get saleFormBuyerHint => 'Who bought it — if you want it remembered';

  @override
  String get saleFormSubmit => 'Record';

  @override
  String get saleFormSaved => 'Sale recorded';

  @override
  String get quickRecordDeath => 'Death';

  @override
  String get notificationPrimerTitle => 'We\'ll remind you about the nest box';

  @override
  String get notificationPrimerBody =>
      'Two days before kindling you\'ll get a reminder, with time to prepare the cage. We\'ll also remind you about vaccinations and the day\'s work.';

  @override
  String get notificationPrimerAllow => 'Turn on reminders';

  @override
  String get notificationPrimerDecline => 'Not now';

  @override
  String get settingsNotificationsOff => 'Notifications are off';

  @override
  String get settingsNotificationsTurnOn => 'Turn on';

  @override
  String get rabbitFormMore => 'More details';

  @override
  String get rabbitFormSexRequired => 'Choose buck or doe';

  @override
  String get rabbitFormCageNone => 'No cage';

  @override
  String rabbitFormCageFull(String number) {
    return '$number — full';
  }

  @override
  String get commonOptional => 'optional';

  @override
  String get unitKg => 'kg';

  @override
  String get kindlingPlanAction => 'Kindling plan';

  @override
  String get kindlingPlanPickMonth => 'Which month is the plan for?';

  @override
  String get kindlingPlanThisMonth => 'This month';

  @override
  String get kindlingPlanNextMonth => 'Next month';

  @override
  String kindlingPlanEmpty(String month) {
    return 'No kindlings expected in $month';
  }

  @override
  String kindlingPlanSheetTitle(String month) {
    return 'Kindling plan — $month';
  }

  @override
  String get kindlingPlanNestHint =>
      'Put the nest box in three days before kindling';

  @override
  String get kindlingPlanColBirth => 'Kindling';

  @override
  String get kindlingPlanColFemale => 'Doe';

  @override
  String get kindlingPlanColCage => 'Cage';

  @override
  String get kindlingPlanColBred => 'Mating';

  @override
  String get kindlingPlanColNest => 'Nest box';

  @override
  String get kindlingPlanColMark => 'Done';

  @override
  String kindlingPlanPrintedAt(String date) {
    return 'Printed $date';
  }

  @override
  String get commonUndo => 'Undo';

  @override
  String get journalKindDeletion => 'Deletion';

  @override
  String get voiceDictate => 'Dictate';

  @override
  String get voiceStop => 'Stop recording';

  @override
  String get voiceUnavailable => 'This phone cannot recognise speech';

  @override
  String get cageAddNewRabbit => 'Add a new rabbit';

  @override
  String get cageAddNewRabbitHint => 'A rabbit that is not in the app yet';

  @override
  String get cageSettleExisting => 'Move one in';

  @override
  String get cageSettleExistingHint => 'Bring a rabbit you already have';

  @override
  String get cageFeedThis => 'Feed this cage';

  @override
  String get cageTagsTitle => 'Cage tags';

  @override
  String get cageTagsPrint => 'Print';

  @override
  String get cageTagsPrintHint =>
      'Cut along the frame and hang on the cage — the camera will open it in the app.';

  @override
  String get cageTagsEmptyTitle => 'No cages yet';

  @override
  String get cageTagsEmptyBody =>
      'Add a cage and you can print its tag right away.';

  @override
  String get cageScanTitle => 'Scan a tag';

  @override
  String get cageScanHint => 'Point the camera at the cage tag';

  @override
  String get cageScanNoCamera =>
      'Camera unavailable. Check the permission in your phone settings.';

  @override
  String get slideToDelete => 'Slide to delete';

  @override
  String get birthsKitsDied => 'Lost';

  @override
  String get birthsKitDeathAction => 'Record losses';

  @override
  String get birthsKitsCardedHint =>
      'This litter has individual cards — record deaths and weaning on the kit card in the herd.';

  @override
  String get birthsKitDeathTitle => 'How many kits died?';

  @override
  String birthsKitDeathHint(int alive) {
    return 'Still alive: $alive';
  }

  @override
  String get birthsKitDeathSaved => 'Recorded';

  @override
  String get birthsKitsAlive => 'Alive';

  @override
  String get loginCodeLabelEmail => 'Code from the email';

  @override
  String get cyclePalpationAction => 'Palpated';

  @override
  String get cyclePalpationTitle => 'What did the check show?';

  @override
  String get cyclePalpationPregnant => 'Pregnant';

  @override
  String get cyclePalpationPregnantHint =>
      'The doe is marked pregnant, kindling comes next';

  @override
  String get cyclePalpationEmpty => 'Not pregnant';

  @override
  String get cyclePalpationEmptyHint =>
      'The cycle closes — the doe can be bred again';

  @override
  String get cyclePalpationSavedPregnant => 'Recorded: pregnant';

  @override
  String get cyclePalpationSavedEmpty => 'Recorded: not pregnant';

  @override
  String get birthsWeaningAction => 'Weaned';

  @override
  String get birthsWeaningTitle => 'How many kits were weaned?';

  @override
  String birthsWeaningHint(int alive) {
    return 'Alive in the litter: $alive';
  }

  @override
  String birthsWeaningAll(int count) {
    return 'All of them: $count';
  }

  @override
  String get birthsWeaningFewer => 'Or fewer';

  @override
  String get birthsWeaningSaved => 'Weaning recorded';

  @override
  String get subscriptionCheckFailed =>
      'Could not check the payment — no connection to the server';

  @override
  String get subscriptionPaymentDeclined => 'The bank declined the payment';

  @override
  String get subscriptionPaymentDeclinedHint =>
      'No money was taken. Check the card and try again.';

  @override
  String get subscriptionPayAgain => 'Pay again';

  @override
  String get supportRequestNew => 'Write';

  @override
  String get supportRequestNewTitle => 'New request';

  @override
  String get supportRequestsEmptyTitle => 'No requests yet';

  @override
  String get supportRequestsEmptyBody =>
      'Write to us if something is broken or unclear. The reply lands right here and as a notification on your phone.';

  @override
  String get supportRequestsEmptyAction => 'Contact support';

  @override
  String get supportRequestStatusWaiting => 'Waiting for a reply';

  @override
  String get supportRequestStatusAnswered => 'Support replied';

  @override
  String get supportRequestAnswerTitle => 'Support reply';

  @override
  String get supportRequestClosedWithoutAnswer =>
      'The request was closed without a written reply.';

  @override
  String get platformSupportAnswerTitle => 'Reply to the author';

  @override
  String get platformSupportResolveTitle => 'Close the request';

  @override
  String get platformSupportResolveBody =>
      'Write a reply — the author gets it as a notification and an email. Leave the field empty if it was sorted out without writing back.';

  @override
  String get platformSupportResolveAnswerLabel => 'Reply to the author';

  @override
  String get platformSupportResolveAnswerHint =>
      'For example: update the app — the new version fixes this';

  @override
  String get platformSupportResolveSendAnswer => 'Send the reply';

  @override
  String get platformSupportResolveWithoutAnswer => 'Close without a reply';

  @override
  String get platformSupportContactTitle => 'Support contact';

  @override
  String get platformSupportContactBody =>
      'Farms see this phone number and email on their requests screen. Leave them empty if there is no direct contact.';

  @override
  String get platformSupportContactPhone => 'Phone';

  @override
  String get platformSupportContactPhoneHint => '+992 00 000 00 00';

  @override
  String get platformSupportContactEmail => 'Email';

  @override
  String get platformSupportContactEmailHint => 'support@example.com';

  @override
  String get platformSupportContactEmailInvalid =>
      'Check the address — it has no @ sign';

  @override
  String get platformSupportContactSaved => 'Support contact saved';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmptyTitle => 'Nothing yet';

  @override
  String get notificationsEmptyBody =>
      'Here you\'ll find what the app has told you: overdue vaccinations, feed running low, kindling coming up.';

  @override
  String get platformFilterDeleted => 'Deleted';

  @override
  String platformFarmDeletedShort(String date) {
    return 'Deleted $date';
  }

  @override
  String get platformFarmsDeletedEmptyTitle => 'No deleted farms';

  @override
  String get platformFarmsDeletedEmptyBody =>
      'Nothing is waiting to be wiped. A deleted farm stays here for 30 days — long enough to change your mind.';

  @override
  String get platformPlanDeleteDefaultWarning =>
      'This is the default plan. Once it is gone, new farms will appear with no plan at all until another one is marked as the default.';

  @override
  String get platformPlanDeleteIrreversible =>
      'This cannot be undone: the plan would have to be created again and assigned to farms by hand.';

  @override
  String get platformTabAudit => 'Log';

  @override
  String get platformAuditEmptyTitle => 'The log is empty';

  @override
  String get platformAuditEmptyBody =>
      'Every admin action lands here: plan changes, farm access, signing in as a client, deletions.';

  @override
  String countAuditRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '$count record',
    );
    return '$_temp0';
  }

  @override
  String platformAuditAdmin(String id) {
    return 'Admin $id';
  }

  @override
  String platformAuditFarm(String id) {
    return 'Farm $id';
  }

  @override
  String get platformAuditWholeService => 'Whole service';

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
  String get platformAuditValueNone => 'not set';

  @override
  String get platformAuditActionPlanCreate => 'Plan created';

  @override
  String get platformAuditActionPlanUpdate => 'Plan changed';

  @override
  String get platformAuditActionPlanDelete => 'Plan deleted';

  @override
  String get platformAuditActionPlanAssign => 'Farm plan changed';

  @override
  String get platformAuditActionFarmStatus => 'Farm access changed';

  @override
  String get platformAuditActionFarmExtras => 'Allowance above the plan';

  @override
  String get platformAuditActionFarmExtendPlan => 'Plan extended by hand';

  @override
  String get platformAuditActionFarmExport => 'Farm data exported';

  @override
  String get platformAuditActionFarmImpersonate => 'Signed in as the client';

  @override
  String get platformAuditActionFarmDelete => 'Farm deleted';

  @override
  String get platformAuditActionFarmRestore => 'Farm restored';

  @override
  String get platformAuditActionAnnouncementSend => 'Announcement sent';

  @override
  String get platformAuditActionSupportResolve => 'Support request closed';

  @override
  String get platformAuditActionSupportContact => 'Support contact changed';

  @override
  String platformAuditActionUnknown(String action) {
    return 'Action “$action”';
  }

  @override
  String get platformAuditFieldName => 'Name';

  @override
  String get platformAuditFieldLimits => 'Limits';

  @override
  String get platformAuditFieldPrice => 'Price';

  @override
  String get platformAuditFieldRabbitsLimit => 'Rabbits on the plan';

  @override
  String get platformAuditFieldStaffLimit => 'People on the plan';

  @override
  String get platformAuditFieldPlan => 'Plan';

  @override
  String get platformAuditFieldStatus => 'Access';

  @override
  String get platformAuditFieldPlanExpiry => 'Plan expiry';

  @override
  String get platformAuditFieldExtras => 'Allowance';

  @override
  String get platformAuditFieldReason => 'Why';

  @override
  String get platformAuditPlanEnabled => 'The plan is offered to farms again';

  @override
  String get platformAuditPlanDisabled =>
      'The plan is no longer offered to farms';

  @override
  String get platformAuditPlanBecameDefault => 'Became the default plan';

  @override
  String get platformAuditPlanNoLongerDefault => 'No longer the default plan';

  @override
  String platformAuditPlanRef(int id) {
    return 'Plan #$id';
  }

  @override
  String platformAuditSupportAnswered(int id) {
    return 'Request #$id — answered to the author';
  }

  @override
  String platformAuditSupportClosed(int id) {
    return 'Request #$id — closed without an answer';
  }

  @override
  String get feedsPaidLabel => 'Amount paid';

  @override
  String get feedsPaidHint =>
      'If this was a purchase, the amount goes into expenses. Leave empty when you are just correcting the count.';

  @override
  String staffInvitedEmailFailedBody(String email) {
    return 'We could not send the email to $email — forward the invitation yourself.';
  }

  @override
  String get staffInviteLinkLabel => 'Invitation link';

  @override
  String get staffInviteCopy => 'Copy the invitation';

  @override
  String get staffInviteCopied =>
      'Invitation copied — paste it into a message to your worker';

  @override
  String staffInviteMessage(String link) {
    return 'I am inviting you to work at my farm in RabbitFarm. Open the link, install the app and sign in with your own number: $link';
  }

  @override
  String get staffExpiredInvites => 'Expired';

  @override
  String staffInviteCardLive(String role, String date) {
    return '$role · until $date';
  }

  @override
  String staffInviteCardExpired(String role, String date) {
    return '$role · expired on $date';
  }

  @override
  String get staffInviteAgain => 'Invite again';

  @override
  String get loginNoCodePhone =>
      'No code? Ask the farm owner which number they invited you with.';

  @override
  String get loginNoCodeEmail =>
      'No code? Ask the farm owner which email address they invited you with.';

  @override
  String get platformPlanDefaultBadge => 'for new farms';

  @override
  String get staffAccessClosedBadge => 'access closed';

  @override
  String get roleManagerDescription => 'Runs the herd, the feed and the money';

  @override
  String get roleWorkerDescription => 'Reads the records and marks work done';

  @override
  String get farmAuditTitle => 'Change log';

  @override
  String get farmAuditEmptyTitle => 'Nothing logged yet';

  @override
  String get farmAuditEmptyBody =>
      'Every edit and every deletion lands here: who, when and what they changed.';

  @override
  String get farmAuditActionUpdated => 'Edited';

  @override
  String get farmAuditActionDeleted => 'Deleted';

  @override
  String get farmAuditActionRoleChanged => 'Role changed';

  @override
  String get farmAuditActionDeactivated => 'Access closed';

  @override
  String get farmAuditActionActivated => 'Access opened';

  @override
  String get farmAuditActionOwnership => 'Farm handed over';

  @override
  String farmAuditActionUnknown(String action) {
    return '$action';
  }

  @override
  String farmAuditChange(String field, String before, String after) {
    return '$field: $before → $after';
  }

  @override
  String farmAuditChanged(String field) {
    return 'Changed: $field';
  }

  @override
  String get farmAuditNoValue => 'empty';

  @override
  String get errorCodeNotRecordAuthor =>
      'Only a manager or the owner edits records made by others';

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get deleteAccountOpen => 'Delete account';

  @override
  String get deleteAccountOwnerHeadline => 'This deletes the whole farm';

  @override
  String get deleteAccountOwnerBody =>
      'You are the owner, so the farm goes with your account — with all of its data. Access ends at once, both for you and for your staff.';

  @override
  String get deleteAccountOwnerWhatGoes =>
      'Rabbits and cages, feeding and feed, treatments and vaccinations, matings and kindlings, money, tasks, notes and photos will be gone.';

  @override
  String get deleteAccountGracePeriod =>
      'For thirty days the data still sits on the server: if you change your mind, write to support and the farm comes back. After that it is erased for good.';

  @override
  String deleteAccountTypeName(String name) {
    return 'Type the farm name “$name” to confirm';
  }

  @override
  String get deleteAccountTypeNameUnknown => 'Type your farm name to confirm';

  @override
  String get deleteAccountFarmNameHint => 'Farm name';

  @override
  String get deleteAccountOwnerAction => 'Delete the farm';

  @override
  String get deleteAccountOwnerDialogTitle => 'Delete the farm?';

  @override
  String get deleteAccountOwnerDialogBody =>
      'Access closes at once, for you and for your staff. After thirty days the data is erased for good.';

  @override
  String get deleteAccountStaffHeadline => 'This deletes your account';

  @override
  String get deleteAccountStaffBody =>
      'The farm is not yours, so it and its data stay. Only your way into the app is deleted.';

  @override
  String get deleteAccountStaffWhatStays =>
      'The records you entered — feeding, treatments, vaccinations — stay with the farm: they are its data. The owner can invite you again, but that will be a new account.';

  @override
  String get deleteAccountStaffAction => 'Delete account';

  @override
  String get deleteAccountStaffDialogTitle => 'Delete your account?';

  @override
  String get deleteAccountStaffDialogBody =>
      'You lose your way into the app at once. The account cannot be brought back.';

  @override
  String get deleteAccountConfirm => 'Delete';

  @override
  String get deleteAccountDone => 'Deleted';

  @override
  String get errorCodeConfirmNameMismatch => 'The farm name does not match';

  @override
  String get healthSheetAction => 'Health record';

  @override
  String get healthSheetPrint => 'Print';

  @override
  String get healthSheetShare => 'Send as a table';

  @override
  String healthSheetTitle(String name) {
    return 'Health record: $name';
  }

  @override
  String get healthSheetNoVaccinations => 'No vaccinations recorded';

  @override
  String get healthSheetNoTreatments => 'No treatments recorded';

  @override
  String get healthSheetNextDate => 'Next';

  @override
  String get healthSheetPeriod => 'Dates';

  @override
  String get healthSheetColKind => 'Kind';

  @override
  String get healthSheetColWhat => 'Vaccine or diagnosis';

  @override
  String get healthSheetColDetails => 'Details';

  @override
  String get healthSheetEmpty =>
      'This rabbit has no vaccinations and no treatments yet';

  @override
  String get financeSheetAction => 'Income and expense book';

  @override
  String get financeSheetTitle => 'Income and expenses';

  @override
  String financeSheetPeriod(String from, String to) {
    return 'For $from to $to';
  }

  @override
  String get financeSheetEmpty => 'No entries recorded for these dates';

  @override
  String get financeSheetColKind => 'Income or expense';

  @override
  String exportShareSubject(String title) {
    return '$title — Rabbit Farm';
  }

  @override
  String get financeSheetLastMonth => 'Last month';

  @override
  String get financeSheetThisYear => 'This year';

  @override
  String get formDraftRestored => 'Brought back what you had not saved';

  @override
  String get formDraftDiscard => 'Clear';
}
