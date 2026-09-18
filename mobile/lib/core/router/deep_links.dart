import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/cages/presentation/utils/cage_tag.dart';
import '../utils/phone_utils.dart';
import 'app_router.dart';

/// Схема приложения. Остаётся ради QR-меток на клетках и ради ссылок,
/// выданных до перехода на https: перехватывать `rabbitfarm://` умеет любая
/// сборка, без домена и без проверки.
const _scheme = 'rabbitfarm';

/// Домен, ссылки которого принадлежат приложению. Тот же адрес сервер
/// кладёт в приглашение (`APP_PUBLIC_URL` на бэкенде).
const _publicHost = String.fromEnvironment(
  'APP_PUBLIC_HOST',
  defaultValue: 'rabbitfarm.click',
);

/// Домен, на котором хозяйство жило до переезда на rabbitfarm.click.
///
/// Приглашение живёт десять минут, но само SMS остаётся в телефоне, и
/// человек открывает его когда дойдут руки. Перестать узнавать прежний
/// адрес значит встретить такого работника браузером вместо приложения,
/// поэтому старый домен разбирается наравне с новым.
const _legacyHost = 'rabbitfarm.mubi.dev';

/// Путь страницы приглашения. Короткий не ради красоты: значение в SMS
/// обрезается шлюзом по длине, и длинный адрес приехал бы обрубком.
const _invitePath = '/i';

/// Ссылка-приглашение: `https://<домен>/i`.
///
/// Одна на всех — с установленным приложением её перехватывает приложение
/// (Universal Links на iOS, App Links на Android), без него открывается
/// страница с магазинами и веб-версией. Ни кода, ни номера в ней нет:
/// человек входит обычным кодом на свой контакт, и этот же вход активирует
/// приглашение.
bool isInviteLink(Uri uri) {
  if (uri.scheme != 'https') return false;
  if (uri.host != _publicHost && uri.host != _legacyHost) return false;

  final path = uri.path.endsWith('/') && uri.path.length > 1
      ? uri.path.substring(0, uri.path.length - 1)
      : uri.path;
  return path == _invitePath;
}

/// Номер из старой ссылки-приглашения `rabbitfarm://join?phone=+992…`.
///
/// Такие ссылки могли остаться в переписке у тех, кого звали раньше, —
/// разбор оставлен, чтобы они по-прежнему открывали вход с подставленным
/// номером. Новые приглашения номера не несут.
///
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
  // Метка с клетки, прочитанная чужим сканером (камерой телефона, любым
  // приложением для QR): наш экран сканирования сюда не приходит — он
  // открывает клетку сам, не выходя из приложения.
  final cageId = cageIdFromTag(uri.toString());
  if (cageId != null) {
    // Не вошедшего роутер завернёт на вход, и это верно: чужая ферма по
    // ссылке открываться не должна.
    rootNavigatorKey.currentContext?.push('/cages/$cageId');
    return;
  }

  // Сам URL в лог не пишем: в старых ссылках в нём номер телефона живого
  // человека.
  final phone = phoneFromInviteLink(uri);
  if (phone == null && !isInviteLink(uri)) return;

  if (phone != null) pendingInvitePhone.value = phone;

  // Приложение уже работало и человек не на входе — ведём его туда сами.
  // Вошедшего в аккаунт `redirect` вернёт с `/login` на «Сегодня», и это
  // верно: ссылка зовёт войти, а он уже внутри.
  final context = rootNavigatorKey.currentContext;
  if (context == null) return;
  context.go('/login');
}
