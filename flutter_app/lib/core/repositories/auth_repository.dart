import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../network/api_client.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';

part 'auth_repository.g.dart';

// ─────────────────────────────────────────────
// Auth Repository
// ─────────────────────────────────────────────
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(apiClientProvider));
}

class AuthRepository {
  final Dio _dio;
  static const _storage = FlutterSecureStorage();

  AuthRepository(this._dio);

  // ─── Register ──────────────────────────────────
  Future<AuthTokens> register({
    required String email,
    required String username,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'username': username,
        'password': password,
        if (displayName != null) 'displayName': displayName,
      });

      final tokens = AuthTokens.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
      await _saveTokens(tokens);
      return tokens;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Login ─────────────────────────────────────
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final tokens = AuthTokens.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
      await _saveTokens(tokens);
      return tokens;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Get Profile ───────────────────────────────
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get('/auth/me');
      return UserModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Update Profile ────────────────────────────
  Future<UserModel> updateProfile({
    String? displayName,
    String? password,
  }) async {
    try {
      final response = await _dio.patch('/auth/me', data: {
        if (displayName != null) 'displayName': displayName,
        if (password != null) 'password': password,
      });
      return UserModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Logout ────────────────────────────────────
  Future<void> logout() async {
    final refreshToken =
        await _storage.read(key: AppConstants.keyRefreshToken);
    if (refreshToken != null) {
      try {
        await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
      } catch (_) {
        // Best effort
      }
    }
    await _clearTokens();
  }

  // ─── Token Management ──────────────────────────
  Future<bool> hasValidToken() async {
    final token = await _storage.read(key: AppConstants.keyAccessToken);
    return token != null && token.isNotEmpty;
  }

  Future<void> _saveTokens(AuthTokens tokens) async {
    await _storage.write(
        key: AppConstants.keyAccessToken, value: tokens.accessToken);
    await _storage.write(
        key: AppConstants.keyRefreshToken, value: tokens.refreshToken);
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: AppConstants.keyAccessToken);
    await _storage.delete(key: AppConstants.keyRefreshToken);
  }
}
