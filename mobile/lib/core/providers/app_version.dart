import 'package:flutter_riverpod/legacy.dart';

/// Версия приложения ниже минимальной поддерживаемой бэкендом — сервер
/// ответил 426 UPGRADE_REQUIRED хотя бы раз за сеанс (см.
/// `AppVersionInterceptor`, `ErrorInterceptor.onUpgradeRequired`).
///
/// Отдельный провайдер, а не поле `AuthState`: это факт про сборку
/// приложения, а не про сессию пользователя — блокировать нужно и
/// неавторизованный экран входа, если он тоже бьётся в устаревший бэкенд.
final upgradeRequiredProvider = StateProvider<bool>((ref) => false);
