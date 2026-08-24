import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/api_providers.dart';
import '../../../../core/providers/session.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

// Auth Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storage = ref.watch(storageProvider);
  return AuthRepository(apiClient: apiClient, storage: storage);
});

// Auth State
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final Object? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    Object? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthNotifier(this._authRepository, this._ref) : super(AuthState()) {
    // Клиент сообщает сюда, что обновить токен не удалось. Раньше он молча
    // стирал токены, а приложение продолжало считать себя авторизованным:
    // все экраны писали «не авторизован», и выйти можно было только
    // перезапуском.
    _ref.read(apiClientProvider).onSessionExpired = _handleSessionExpired;
    _checkAuthStatus();
  }

  void _handleSessionExpired() {
    if (!mounted) return;
    state = AuthState();
    // Профиль уезжает вместе с сессией: токены клиент уже стёр, а имя и роль
    // прошлого пользователя оставлять на устройстве незачем.
    _authRepository.clearCachedProfile();
    resetSessionData(_ref);
  }

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        (e.type == DioExceptionType.unknown &&
            e.error.toString().contains('SocketException'));
  }

  // Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        try {
          final user = await _authRepository.getProfile();
          state = state.copyWith(
            user: user,
            isAuthenticated: true,
            isLoading: false,
          );
        } on DioException catch (e) {
          if (_isNetworkError(e)) {
            // Сети нет, но токен есть — работаем дальше. Профиль при этом
            // берём из хранилища: без него роль неизвестна, а неизвестная
            // роль трактуется как самая узкая, и владелец в сарае без связи
            // получал интерфейс работника.
            state = state.copyWith(
              user: await _authRepository.cachedProfile(),
              isAuthenticated: true,
              isLoading: false,
            );
          } else {
            // 401/403 — token is invalid, log user out
            await _authRepository.logout();
            state = state.copyWith(isLoading: false);
          }
        } catch (e) {
          // Unknown error during profile fetch — log user out
          state = state.copyWith(isLoading: false);
        }
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  // Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResponse = await _authRepository.login(
        email: email,
        password: password,
      );

      state = state.copyWith(
        user: authResponse.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e,
      );
      rethrow;
    }
  }

  // Register
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResponse = await _authRepository.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );

      state = state.copyWith(
        user: authResponse.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e,
      );
      rethrow;
    }
  }

  /// Присоединиться к ферме по коду приглашения.
  Future<void> acceptInvitation({
    required String code,
    required String password,
    required String fullName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResponse = await _authRepository.acceptInvitation(
        code: code,
        password: password,
        fullName: fullName,
      );

      state = state.copyWith(
        user: authResponse.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e,
      );
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authRepository.logout();
    } catch (_) {
      // Ignore network errors — tokens are already cleared in repository (finally)
    } finally {
      // Always reset auth state
      state = AuthState();
      // Данные предыдущего пользователя нужно забыть: на общем планшете фермы
      // следующий вошедший иначе увидит чужое поголовье прямо из памяти.
      resetSessionData(_ref);
    }
  }

  // Refresh profile
  Future<void> refreshProfile() async {
    try {
      final user = await _authRepository.getProfile();
      state = state.copyWith(user: user);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository, ref);
});
