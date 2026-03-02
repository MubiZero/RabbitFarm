import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/api_providers.dart';
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
  final String? error;
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
    String? error,
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

  AuthNotifier(this._authRepository) : super(AuthState()) {
    _checkAuthStatus();
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
            // No network, but token exists — keep user authenticated
            // user == null, app continues to work
            state = state.copyWith(
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
        error: e.toString().replaceAll('Exception: ', ''),
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
        error: e.toString().replaceAll('Exception: ', ''),
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
  return AuthNotifier(authRepository);
});
