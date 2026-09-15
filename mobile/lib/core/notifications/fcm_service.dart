import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';
import 'notification_permission.dart';
import '../../features/device_tokens/data/repositories/device_tokens_repository.dart';
import '../../features/device_tokens/presentation/providers/device_tokens_provider.dart';

/// Обязательное требование FCM для показа уведомлений, пока приложение
/// полностью закрыто — топ-левел функция, не метод класса. Само содержимое
/// пусто: систему показывает уведомление сама, по блоку `notification` в
/// пуше, обработчику достаточно просто существовать.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

/// Пуш пришёл, пока приложение открыто — FCM в этом случае не показывает
/// системное уведомление сам, поэтому короткий баннер в приложении.
void listenForForegroundMessages() {
  FirebaseMessaging.onMessage.listen((message) {
    final context = rootNavigatorKey.currentContext;
    final title = message.notification?.title;
    if (context == null || !context.mounted || title == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(title)),
    );
  });
}

/// Тап по уведомлению — переход на связанный список.
void handleMessageTap(RemoteMessage message) {
  final route = message.data['route'] as String?;
  final context = rootNavigatorKey.currentContext;
  if (route == null || context == null) return;
  context.push(route);
}

void listenForMessageTaps() {
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessageTap);
}

/// Регистрация устройства на бэке — не сама доставка (её делает FCM), а
/// привязка токена этого телефона к вошедшему пользователю.
///
/// Не поддерживается на web — там нужен отдельный VAPID-ключ и service
/// worker, это отдельная задача, а сама библиотека на web ведёт себя иначе.
class FcmService {
  final DeviceTokensRepository _repository;

  FcmService(this._repository);

  /// Привязать этот телефон к вошедшему пользователю.
  ///
  /// Системного вопроса о разрешении здесь больше нет: он задаётся один раз
  /// за установку, и задавать его надо тогда, когда человеку есть что
  /// напоминать, а не в момент входа. Этим занимается
  /// `NotificationPrimerSheet`; сюда мы попадаем уже с ответом — и если
  /// разрешения нет, регистрировать токен незачем, доставить по нему всё
  /// равно ничего не получится.
  Future<void> registerCurrentToken() async {
    if (kIsWeb) return;
    try {
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      if (!NotificationPermission.granted(settings.authorizationStatus)) return;

      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;

      await _repository.register(token, Platform.isIOS ? 'ios' : 'android');
    } catch (e) {
      // Пуш — не критичная функция: без него ферма продолжает работать как
      // обычно, поэтому сбой регистрации не должен мешать входу в аккаунт.
      debugPrint('FCM: не удалось зарегистрировать токен устройства: $e');
    }
  }

  Future<void> unregisterCurrentToken() async {
    if (kIsWeb) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await _repository.unregister(token);
    } catch (e) {
      debugPrint('FCM: не удалось отвязать токен устройства: $e');
    }
  }
}

final fcmServiceProvider = Provider<FcmService>((ref) {
  final repository = ref.watch(deviceTokensRepositoryProvider);
  return FcmService(repository);
});
