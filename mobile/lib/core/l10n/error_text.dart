import '../../l10n/generated/app_localizations.dart';
import '../api/api_failure.dart';

/// Текст ошибки для человека.
///
/// Порядок такой: сначала перевод по коду отказа, затем подробность сервера,
/// и только потом общее описание по виду ошибки.
///
/// Код вперёд текста — потому что тексты сервера написаны по-русски
/// (`utils/apiResponse.js`, `validators/messages.js`), и на таджикском или
/// узбекском экране человек получал русскую фразу. Язык читателя сервер
/// знает, но пользуется им только для push-уведомлений.
///
/// Подробность сервера остаётся запасной, а не выбрасывается: он знает про
/// ферму то, чего не знает клиент («Недостаточно места в клетке матери,
/// свободно: 2»), и для кода, которого мы ещё не перевели, русская
/// конкретика полезнее общего «не удалось».
///
/// Переводы передаются значением, а не через `BuildContext`: текст ошибки
/// собирается после `await`, когда обращаться к контексту уже небезопасно.
String errorText(AppLocalizations l10n, Object? error) {
  if (error is ApiFailure) {
    final byCode = _byCode(l10n, error.code);
    if (byCode != null) return byCode;

    final serverText = error.serverText?.trim();
    if (serverText != null && serverText.isNotEmpty) return serverText;

    return switch (error.kind) {
      ApiFailureKind.offline => l10n.errorOffline,
      ApiFailureKind.timeout => l10n.errorTimeout,
      ApiFailureKind.unauthorized => l10n.errorUnauthorized,
      ApiFailureKind.forbidden => l10n.errorForbidden,
      ApiFailureKind.notFound => l10n.errorNotFound,
      ApiFailureKind.invalid => l10n.errorInvalid,
      ApiFailureKind.server => l10n.errorServer,
      ApiFailureKind.unknown => l10n.commonUnknownError,
    };
  }

  // Часть ошибок приходит не с сервера — например сбой разбора ответа.
  // Служебная обёртка Dart для фермера ничего не значит и выглядит поломкой.
  var text = (error?.toString() ?? '').trim();
  for (final prefix in const ['Exception: ', 'DioException: ', 'Error: ']) {
    if (text.startsWith(prefix)) text = text.substring(prefix.length);
  }
  return text.isEmpty ? l10n.commonUnknownError : text;
}

/// Перевод по коду отказа. `null` — код незнакомый, дальше пробуем текст
/// сервера.
String? _byCode(AppLocalizations l10n, String? code) => switch (code) {
      // Вход и сессия. Причин четыре, а человеку важно одно: вход устарел.
      'TOKEN_MISSING' ||
      'TOKEN_INVALID' ||
      'TOKEN_EXPIRED' ||
      'TOKEN_REVOKED' ||
      'UNAUTHORIZED' =>
        l10n.errorCodeSessionExpired,
      'USER_INACTIVE' => l10n.errorCodeUserInactive,
      'REGISTRATION_CLOSED' => l10n.errorCodeRegistrationClosed,
      'PLATFORM_ADMIN_ONLY' => l10n.errorCodePlatformAdminOnly,
      'PLATFORM_ADMIN_ACCOUNT' => l10n.errorCodePlatformAdminAccount,
      'FORBIDDEN' => l10n.errorForbidden,
      'NOT_FOUND' || 'ROUTE_NOT_FOUND' => l10n.errorNotFound,
      'BAD_REQUEST' || 'VALIDATION_ERROR' => l10n.errorInvalid,

      'OTP_INVALID' => l10n.errorCodeOtpInvalid,
      'OTP_EXPIRED' => l10n.errorCodeOtpExpired,
      'OTP_LOCKED' => l10n.errorCodeOtpLocked,
      'OTP_RATE_LIMITED' => l10n.errorCodeOtpRateLimited,
      'RATE_LIMIT_EXCEEDED' ||
      'AUTH_RATE_LIMIT_EXCEEDED' =>
        l10n.errorCodeRateLimited,
      'UPLOAD_RATE_LIMIT_EXCEEDED' => l10n.errorCodeUploadRateLimited,
      'CONTACT_REQUIRED' => l10n.errorCodeContactRequired,
      'INVALID_EMAIL' => l10n.errorCodeInvalidEmail,
      'INVALID_PHONE' => l10n.errorCodeInvalidPhone,
      'SMS_NOT_CONFIGURED' => l10n.errorCodeSmsNotConfigured,
      'EMAIL_NOT_CONFIGURED' => l10n.errorCodeEmailNotConfigured,
      'USER_EXISTS' => l10n.errorCodeUserExists,
      'PHONE_EXISTS' => l10n.errorCodePhoneExists,
      'PHONE_LOGIN_UNAVAILABLE' => l10n.errorCodePhoneLoginUnavailable,
      'CONFIRM_NAME_MISMATCH' => l10n.errorCodeConfirmNameMismatch,

      // Состояние хозяйства целиком.
      'FARM_SUSPENDED' => l10n.errorCodeFarmSuspended,
      'FARM_DELETED' => l10n.errorCodeFarmDeleted,
      'FARM_NOT_DELETED' => l10n.errorCodeFarmNotDeleted,
      'FARM_READ_ONLY' => l10n.errorCodeFarmReadOnly,
      'FARM_NO_OWNER' => l10n.errorCodeFarmNoOwner,
      'IMPERSONATION_READ_ONLY' => l10n.errorCodeImpersonationReadOnly,
      'UPGRADE_REQUIRED' => l10n.errorCodeUpgradeRequired,
      'NO_PLAN' => l10n.errorCodeNoPlan,
      'PLAN_FREE' => l10n.errorCodePlanFree,
      'PLAN_NOT_FOUND' => l10n.errorCodePlanNotFound,
      'PLAN_NAME_EXISTS' => l10n.errorCodePlanNameExists,
      'PLAN_DEFAULT_TAKEN' => l10n.errorCodePlanDefaultTaken,
      'PLAN_DISABLED' => l10n.errorCodePlanDisabled,
      'PAYMENTS_UNAVAILABLE_IN_COUNTRY' =>
        l10n.errorCodePaymentsUnavailableInCountry,
      'PAYMENT_NOT_FOUND' => l10n.errorCodePaymentNotFound,
      'RABBIT_LIMIT_REACHED' => l10n.errorCodeRabbitLimitReached,
      'STAFF_LIMIT_REACHED' => l10n.errorCodeStaffLimitReached,
      'NO_RECIPIENTS' => l10n.errorCodeNoRecipients,
      'SUPPORT_REQUEST_NOT_FOUND' => l10n.errorCodeSupportRequestNotFound,

      // Записи, которых не нашлось.
      'RABBIT_NOT_FOUND' => l10n.errorCodeRabbitNotFound,
      'CAGE_NOT_FOUND' => l10n.errorCodeCageNotFound,
      'BREED_NOT_FOUND' => l10n.errorCodeBreedNotFound,
      'FEED_NOT_FOUND' => l10n.errorCodeFeedNotFound,
      'TASK_NOT_FOUND' => l10n.errorCodeTaskNotFound,
      'USER_NOT_FOUND' => l10n.errorCodeUserNotFound,
      'FARM_NOT_FOUND' => l10n.errorCodeFarmNotFound,
      'BIRTH_NOT_FOUND' => l10n.errorCodeBirthNotFound,
      'MOTHER_NOT_FOUND' => l10n.errorCodeMotherNotFound,
      'FATHER_NOT_FOUND' => l10n.errorCodeFatherNotFound,
      'MALE_NOT_FOUND' => l10n.errorCodeMaleNotFound,
      'FEMALE_NOT_FOUND' => l10n.errorCodeFemaleNotFound,
      'BREEDING_NOT_FOUND' => l10n.errorCodeBreedingNotFound,
      'FEEDING_NOT_FOUND' => l10n.errorCodeFeedingNotFound,
      'MEDICAL_RECORD_NOT_FOUND' => l10n.errorCodeMedicalRecordNotFound,
      'VACCINATION_NOT_FOUND' => l10n.errorCodeVaccinationNotFound,
      'NOTE_NOT_FOUND' => l10n.errorCodeNoteNotFound,
      'TRANSACTION_NOT_FOUND' => l10n.errorCodeTransactionNotFound,
      'PHOTO_NOT_FOUND' => l10n.errorCodePhotoNotFound,
      'MEMBER_NOT_FOUND' => l10n.errorCodeMemberNotFound,
      'INVITATION_NOT_FOUND' => l10n.errorCodeInvitationNotFound,
      'ASSIGNEE_NOT_FOUND' => l10n.errorCodeAssigneeNotFound,

      // Правила хозяйства: почему так нельзя.
      'CAGE_FULL' => l10n.errorCodeCageFull,
      'CAGE_HAS_RABBITS' => l10n.errorCodeCageHasRabbits,
      'TAG_ID_EXISTS' => l10n.errorCodeTagIdExists,
      'TAG_RANGE_TAKEN' => l10n.errorCodeTagRangeTaken,
      'INSUFFICIENT_STOCK' => l10n.errorCodeInsufficientStock,
      'FEED_IN_USE' => l10n.errorCodeFeedInUse,
      'STOCK_OPERATION_INVALID' => l10n.errorCodeStockOperationInvalid,
      'BREED_NAME_EXISTS' => l10n.errorCodeBreedNameExists,
      'BREED_HAS_RABBITS' => l10n.errorCodeBreedHasRabbits,
      'RABBIT_NOT_ACTIVE' => l10n.errorCodeRabbitNotActive,
      'RABBIT_HAS_OFFSPRING' => l10n.errorCodeRabbitHasOffspring,
      'RABBIT_HAS_BREEDINGS' => l10n.errorCodeRabbitHasBreedings,
      'RABBIT_HAS_BIRTHS' => l10n.errorCodeRabbitHasBirths,
      'RABBIT_HAS_HEALTH_RECORDS' => l10n.errorCodeRabbitHasHealthRecords,
      'RABBIT_HAS_TRANSACTIONS' => l10n.errorCodeRabbitHasTransactions,
      'SEX_LOCKED' => l10n.errorCodeSexLocked,
      'CANNOT_BE_OWN_PARENT' ||
      'CANNOT_BE_OWN_MOTHER' ||
      'CANNOT_BE_OWN_FATHER' =>
        l10n.errorCodeCannotBeOwnParent,
      'NOT_A_MALE' => l10n.errorCodeNotAMale,
      'NOT_A_FEMALE' => l10n.errorCodeNotAFemale,
      'PARENT_ID_INVALID' => l10n.errorCodeParentIdInvalid,
      'BREEDING_SELF' => l10n.errorCodeBreedingSelf,
      'FEMALE_NOT_AVAILABLE' ||
      'MALE_NOT_AVAILABLE' =>
        l10n.errorCodeFemaleNotAvailable,
      'FATHER_NOT_FOUND_OR_INVALID_SEX' =>
        l10n.errorCodeFatherNotFoundOrInvalidSex,
      'MOTHER_NOT_FOUND_OR_INVALID_SEX' =>
        l10n.errorCodeMotherNotFoundOrInvalidSex,
      'BIRTH_HAS_KIT_CARDS' => l10n.errorCodeBirthHasKitCards,
      'KITS_MORE_THAN_BORN' => l10n.errorCodeKitsMoreThanBorn,
      'KITS_COUNT_INVALID' => l10n.errorCodeKitsCountInvalid,
      'WEANING_BEFORE_BIRTH' => l10n.errorCodeWeaningBeforeBirth,
      'BULK_COUNT_INVALID' => l10n.errorCodeBulkCountInvalid,
      'PERIOD_REQUIRED' => l10n.errorCodePeriodRequired,
      'FILE_MISSING' => l10n.errorCodeFileMissing,
      'FILE_TOO_LARGE' => l10n.errorCodeFileTooLarge,
      'FILE_UPLOAD_FAILED' => l10n.errorCodeFileUploadFailed,
      'RELATED_RECORD_INVALID' => l10n.errorCodeRelatedRecordInvalid,
      'NOT_RECORD_AUTHOR' => l10n.errorCodeNotRecordAuthor,
      _ => null,
    };
