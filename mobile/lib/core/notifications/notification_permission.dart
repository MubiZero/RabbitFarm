import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Разрешение на уведомления — своими словами, до системного диалога.
///
/// Системный диалог спрашивают один раз за установку: отказ в нём человек
/// уже не отменит из приложения — только в настройках телефона, куда никто
/// не пойдёт. Раньше этот единственный вопрос задавался холодно, сразу после
/// входа, когда ферма ещё пустая и напоминать не о чем, — и отказ уносил с
/// собой главное, ради чего пуши вообще есть: напоминание поставить маточник
/// за два дня до окрола.
///
/// Поэтому вопрос теперь задаётся дважды: сначала наш экран, который
/// объясняет выгоду, и только после согласия — системный. Отказ на нашем
/// экране ничего не сжигает: системный диалог остаётся нетронутым, и
/// предложить его можно снова из настроек.
class NotificationPermission {
  const NotificationPermission();

  /// Наш экран уже показывали. Отдельно от системного статуса: человек мог
  /// ответить «не надо» нам, и переспрашивать его при каждом запуске — это
  /// ровно то раздражение, от которого разрешения и отключают.
  static const _primerSeenKey = 'notification_primer_seen';

  /// Стоит ли показать объяснение.
  ///
  /// Только когда системный диалог ещё ни разу не показывали: если человек
  /// уже дал или отнял разрешение, объяснять поздно — вопрос решён.
  Future<bool> shouldShowPrimer() async {
    if (kIsWeb) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_primerSeenKey) ?? false) return false;
      return await status() == AuthorizationStatus.notDetermined;
    } catch (e) {
      // Firebase может быть не поднят (тесты, сборка без google-services).
      // Молчание здесь безопаснее: без пушей ферма работает как обычно.
      debugPrint('FCM: не удалось узнать статус разрешения: $e');
      return false;
    }
  }

  Future<AuthorizationStatus> status() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    return settings.authorizationStatus;
  }

  Future<void> markPrimerSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_primerSeenKey, true);
  }

  /// Показать системный диалог. Возвращает, разрешил ли человек.
  Future<bool> requestFromSystem() async {
    await markPrimerSeen();
    final settings = await FirebaseMessaging.instance.requestPermission();
    return granted(settings.authorizationStatus);
  }

  static bool granted(AuthorizationStatus status) =>
      status == AuthorizationStatus.authorized ||
      status == AuthorizationStatus.provisional;
}

final notificationPermissionProvider = Provider<NotificationPermission>(
  (ref) => const NotificationPermission(),
);
