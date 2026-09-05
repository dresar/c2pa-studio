import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/user_model.dart';
import '../../../core/repositories/auth_repository.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

// ─────────────────────────────────────────────
// Auth State
// ─────────────────────────────────────────────
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserModel user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

// ─────────────────────────────────────────────
// Auth Notifier
// ─────────────────────────────────────────────
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _initialize();
    return const AuthState.initial();
  }

  Future<void> _initialize() async {
    state = const AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final hasToken = await repo.hasValidToken();
      if (hasToken) {
        final user = await repo.getProfile();
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.login(email: email, password: password);
      final user = await repo.getProfile();
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
    String? displayName,
  }) async {
    state = const AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.register(
        email: email,
        username: username,
        password: password,
        displayName: displayName,
      );
      final user = await repo.getProfile();
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AuthState.unauthenticated();
  }

  Future<void> updateProfile({
    String? displayName,
    String? password,
  }) async {
    final currentState = state;
    if (currentState is! _Authenticated) return;

    state = const AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final updatedUser = await repo.updateProfile(
        displayName: displayName,
        password: password,
      );
      state = AuthState.authenticated(updatedUser);
    } catch (e) {
      state = AuthState.authenticated(currentState.user);
      rethrow;
    }
  }

  void clearError() {
    state = const AuthState.unauthenticated();
  }
}
