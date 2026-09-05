import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

part 'api_client.g.dart';

// ─────────────────────────────────────────────
// API Client (Dio Singleton with Interceptors)
// ─────────────────────────────────────────────

@Riverpod(keepAlive: true)
Dio apiClient(ApiClientRef ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
      receiveTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
      sendTimeout: const Duration(seconds: AppConstants.uploadTimeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor(dio, ref));
  dio.interceptors.add(LoggingInterceptor());
  dio.interceptors.add(ErrorInterceptor());

  // Set base URL from secure storage or default
  _initBaseUrl(dio);

  return dio;
}

Future<void> _initBaseUrl(Dio dio) async {
  final prefs = await SharedPreferences.getInstance();
  final url = prefs.getString(AppConstants.keyApiUrl) ?? AppConstants.defaultApiUrl;
  dio.options.baseUrl = url;
}

// ─────────────────────────────────────────────
// Auth Interceptor: inject token + auto-refresh
// ─────────────────────────────────────────────
class AuthInterceptor extends Interceptor {
  final Dio dio;
  final Ref ref;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  AuthInterceptor(this.dio, this.ref);

  static const _storage = FlutterSecureStorage();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: AppConstants.keyAccessToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken =
            await _storage.read(key: AppConstants.keyRefreshToken);
        if (refreshToken == null) {
          handler.next(err);
          return;
        }

        final response = await Dio(BaseOptions(baseUrl: dio.options.baseUrl))
            .post('/auth/refresh', data: {'refreshToken': refreshToken});

        final newAccessToken = response.data['data']['accessToken'] as String;
        final newRefreshToken = response.data['data']['refreshToken'] as String;

        await _storage.write(
            key: AppConstants.keyAccessToken, value: newAccessToken);
        await _storage.write(
            key: AppConstants.keyRefreshToken, value: newRefreshToken);

        // Retry original request
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final retried = await dio.fetch(err.requestOptions);
        handler.resolve(retried);
      } catch (_) {
        // Refresh failed — clear tokens
        await _storage.deleteAll();
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
      return;
    }
    handler.next(err);
  }
}

// ─────────────────────────────────────────────
// Logging Interceptor (debug mode)
// ─────────────────────────────────────────────
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // In production, only log method + path
    // print('→ ${options.method} ${options.path}');
    handler.next(options);
  }
}

// ─────────────────────────────────────────────
// Error Interceptor: standardize DioException
// ─────────────────────────────────────────────
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Wrap into ApiException so UI can handle uniformly
    handler.next(err);
  }
}

// ─────────────────────────────────────────────
// API Exception
// ─────────────────────────────────────────────
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;

  const ApiException({
    required this.message,
    this.statusCode,
    this.code,
  });

  factory ApiException.fromDioException(DioException e) {
    final data = e.response?.data;
    final message = (data is Map ? data['message'] as String? : null) ??
        e.message ??
        'An error occurred';
    return ApiException(
      message: message,
      statusCode: e.response?.statusCode,
      code: data is Map ? data['errors']?.first['code'] as String? : null,
    );
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
