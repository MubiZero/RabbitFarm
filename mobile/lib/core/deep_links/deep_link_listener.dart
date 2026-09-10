import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';

/// Ловит `rabbitfarm://join?phone=...` — приглашение сотрудника по телефону
/// (см. `staffController.createInvitation`, `invite_link`). Открывает экран
/// входа с предзаполненным номером; запрос кода всё равно инициирует сам
/// человек, ссылка не несёт ничего секретного.
class DeepLinkListener {
  DeepLinkListener(this._router) {
    _appLinks.getInitialLink().then(_handle);
    _sub = _appLinks.uriLinkStream.listen(_handle);
  }

  final GoRouter _router;
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  void _handle(Uri? uri) {
    if (uri == null || uri.scheme != 'rabbitfarm' || uri.host != 'join') {
      return;
    }
    final phone = uri.queryParameters['phone'];
    if (phone == null || phone.isEmpty) return;
    _router.go('/login', extra: phone);
  }

  void dispose() => _sub?.cancel();
}
