import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../utils/phone_utils.dart';
import 'app_router.dart';

/// Схема приложения. Не Universal/App Links: для них нужен домен с
/// `.well-known` и Associated Domains в профиле Apple — этого у проекта пока
/// нет, а кастомной схемы для своей же ссылки из SMS/мессенджера достаточно.
const _scheme = 'rabbitfarm';

/// Номер из ссылки-приглашения `rabbitfarm://join?phone=+992…`.
///
/// Ссылку выдаёт сервер вместе с приглашением по телефону
/// (`staffController.createInvitation`). Секретного в ней нет: код приходит
/// отдельной SMS — ссылка только открывает приложение на нужном номере.
/// Возвращает `null` для всего, что не разобралось: открывать экран входа с
/// чужим или мусорным номером хуже, чем просто открыть приложение.
String? phoneFromInviteLink(Uri uri) {
  if (uri.scheme != _scheme || uri.host != 'join') return null;

  final raw = uri.queryParameters['phone'];
  if (raw == null || raw.isEmpty) return null;

  final phone = normalizeTjPhone(raw);
  return isTjPhone(phone) ? phone : null;
}

/// Подписка на ссылки, открывающие приложение, — и на ту, которой его
/// запустили из закрытого состояния, и на приходящие потом.
///
/// Навигация идёт через `rootNavigatorKey`, как и переход по тапу на
/// уведомление (см. `fcm_service.dart`): роутер живёт в дереве, а ссылка
/// приходит из платформы мимо него.
Future<StreamSubscription<Uri>?> initDeepLinks() async {
  if (kIsWeb) return null;

  final appLinks = AppLinks();
  try {
    final initial = await appLinks.getInitialLink();
    if (initial != null) {
      // Первый кадр ещё не нарисован — роутера, которому можно что-то
      // сказать, пока нет.
      WidgetsBinding.instance.addPostFrameCallback((_) => _open(initial));
    }
  } catch (e) {
    debugPrint('Диплинк: не удалось прочитать стартовую ссылку: $e');
  }

  return appLinks.uriLinkStream.listen(
    _open,
    onError: (Object e) => debugPrint('Диплинк: ошибка потока ссылок: $e'),
  );
}

/// Номер из ссылки, который ещё не доехал до экрана входа.
///
/// Одной навигации мало: при запуске по ссылке приложение стартует со
/// `/splash`, и тот через полторы секунды сам уходит на `/login` — без
/// номера, затирая наш переход (поймано живьём на симуляторе). Поэтому номер
/// кладётся сюда, а [LoginScreen] забирает его при построении, когда бы оно
/// ни случилось.
final pendingInvitePhone = ValueNotifier<String?>(null);

/// Забрать отложенный номер — ровно один раз.
String? takePendingInvitePhone() {
  final phone = pendingInvitePhone.value;
  pendingInvitePhone.value = null;
  return phone;
}

void _open(Uri uri) {
  // Сам URL в лог не пишем: в нём номер телефона живого человека.
  final phone = phoneFromInviteLink(uri);
  if (phone == null) return;

  pendingInvitePhone.value = phone;

  // Приложение уже работало и человек не на входе — ведём его туда сами.
  // Вошедшего в аккаунт `redirect` вернёт с `/login` на «Сегодня», и это
  // верно: ссылка зовёт войти, а он уже внутри.
  final context = rootNavigatorKey.currentContext;
  if (context == null) return;
  context.go('/login');
}
