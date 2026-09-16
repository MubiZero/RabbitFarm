import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/cache/list_cache.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../tasks/presentation/providers/tasks_provider.dart';
import 'auth_provider.dart';

/// Держит язык уведомлений на сервере в согласии с языком приложения.
///
/// Пуши и письма сервер отправляет тогда, когда приложение закрыто, и
/// спросить язык ему не у кого — поэтому выбранный человеком язык уезжает на
/// сервер заранее: при входе и при каждой смене в настройках.
///
/// Живёт отдельным провайдером, а не внутри переключателя языка: переключатель
/// лежит в `core` и про аккаунты ничего не знает, да и синхронизировать нужно
/// не только смену, но и первый вход — язык мог быть выбран ещё до него, на
/// экране знакомства.
class LanguageSync {
  LanguageSync(this._ref) {
    _ref.listen<AsyncValue<Locale>>(localeProvider, (_, next) {
      final locale = next.value;
      if (locale != null) _push(locale.languageCode);
    }, fireImmediately: true);

    _ref.listen<AuthState>(authProvider, (previous, next) {
      // Именно момент входа: пока человек не вошёл, серверу этот язык
      // некуда записать.
      if (previous?.isAuthenticated == true || !next.isAuthenticated) return;
      final locale = _ref.read(localeProvider).value;
      if (locale != null) _push(locale.languageCode);
    });
  }

  final Ref _ref;

  String? _sent;

  Future<void> _push(String language) async {
    if (_sent == language) return;

    final auth = _ref.read(authProvider);
    if (!auth.isAuthenticated) return;
    // Сервер уже знает этот язык — запрос при каждом запуске приложения был
    // бы ровно тем же значением обратно.
    if (auth.user?.language == language) {
      _sent = language;
      return;
    }

    _sent = language;
    // Молча: человек переключил язык интерфейса, и язык уведомлений — это
    // следствие, за которое он не просил отчёта. Не дошло — отправится со
    // следующим входом.
    final failed = await _ref.read(authProvider.notifier).setLanguage(language);
    if (failed != null) {
      _sent = null;
      return;
    }

    // Заголовки задач, которые завёл сервер («Поставить маточник: Мушка»),
    // приходят собранными на языке читателя. И в памяти, и на диске лежат
    // старые — без сброса человек увидел бы их на прежнем языке до первого
    // обновления списка.
    await clearListCache(ListCacheBoxes.tasks);
    _ref.invalidate(tasksListProvider);
  }
}

final languageSyncProvider = Provider<LanguageSync>((ref) => LanguageSync(ref));
