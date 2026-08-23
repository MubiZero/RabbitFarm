import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';

export '../../l10n/generated/app_localizations.dart';

/// Короткий доступ к переводам: `context.l10n.commonRetry`.
///
/// Полная форма `AppLocalizations.of(context)` длиннее самой строки, которую
/// достаёт, — и именно поэтому её обходили, оставляя текст прямо в экране.
extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
