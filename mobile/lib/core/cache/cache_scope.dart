import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';

/// Чей кэш списков лежит на диске.
///
/// Кэш переживает перезапуск, поэтому у него обязан быть владелец: на общем
/// планшете фермы иначе следующий вошедший увидел бы поголовье предыдущего ещё
/// до первого запроса к серверу. Сброс сессии кэш чистит (`resetSessionData`),
/// но полагаться только на выход нельзя — приложение могли просто закрыть.
///
/// `null` — писать и читать нечего:
/// * никто не вошёл;
/// * идёт просмотр под клиентом (см. docs/plans/PLATFORM-ADMIN.md, 3.2) —
///   это чужая ферма на пятнадцать минут, оставлять её на устройстве админа
///   незачем.
final cacheScopeProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);
  if (auth.isImpersonating) return null;

  final user = auth.user;
  if (user == null || !auth.isAuthenticated) return null;

  return 'u${user.id}';
});
