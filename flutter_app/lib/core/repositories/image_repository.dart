import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/api_client.dart';
import '../models/image_model.dart';
import '../models/project_model.dart';

part 'image_repository.g.dart';

// ─────────────────────────────────────────────
// Image Repository
// ─────────────────────────────────────────────
@riverpod
ImageRepository imageRepository(ImageRepositoryRef ref) {
  return ImageRepository(ref.watch(apiClientProvider));
}

class ImageRepository {
  final Dio _dio;
  ImageRepository(this._dio);

  // ─── Upload Images ────────────────────────────
  Future<List<Map<String, String>>> uploadImages({
    required String projectId,
    required List<String> filePaths,
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      final formData = FormData();

      for (final path in filePaths) {
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        ));
      }

      final response = await _dio.post(
        '/projects/$projectId/images/upload',
        data: formData,
        onSendProgress: onProgress,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          sendTimeout: const Duration(seconds: 120),
        ),
      );

      return List<Map<String, String>>.from(
        (response.data['data'] as List).map((e) => Map<String, String>.from(e as Map)),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── List Images ──────────────────────────────
  Future<PaginatedResponse<ImageModel>> listImages({
    required String projectId,
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
  }) async {
    try {
      final response = await _dio.get(
        '/projects/$projectId/images',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null && search.isNotEmpty) 'search': search,
          if (status != null) 'status': status,
        },
      );

      final data = response.data;
      final meta = data['meta'] as Map<String, dynamic>;
      final items = (data['data'] as List)
          .map((j) => ImageModel.fromJson(j as Map<String, dynamic>))
          .toList();

      return PaginatedResponse<ImageModel>(
        items: items,
        total: meta['total'] as int,
        page: meta['page'] as int,
        limit: meta['limit'] as int,
        totalPages: meta['totalPages'] as int,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Get Image ────────────────────────────────
  Future<ImageModel> getImage(String id) async {
    try {
      final response = await _dio.get('/images/$id');
      return ImageModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Delete Image ─────────────────────────────
  Future<void> deleteImage(String id) async {
    try {
      await _dio.delete('/images/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Compress ─────────────────────────────────
  Future<void> compress(String id, {
    required String mode,
    int? quality,
    bool keepMetadata = true,
  }) async {
    try {
      await _dio.post('/images/$id/compress', data: {
        'mode': mode,
        if (quality != null) 'quality': quality,
        'keepMetadata': keepMetadata,
      });
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Resize ───────────────────────────────────
  Future<void> resize(String id, {int? width, int? height}) async {
    try {
      await _dio.post('/images/$id/resize', data: {
        if (width != null) 'width': width,
        if (height != null) 'height': height,
      });
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Remove Metadata ──────────────────────────
  Future<void> removeMetadata(String id) async {
    try {
      await _dio.post('/images/$id/remove-metadata');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> removeGps(String id) async {
    try {
      await _dio.post('/images/$id/remove-gps');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> removeC2pa(String id) async {
    try {
      await _dio.post('/images/$id/remove-c2pa');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Create C2PA ──────────────────────────────
  Future<void> createC2pa(String id, Map<String, dynamic> data) async {
    try {
      await _dio.post('/images/$id/create-c2pa', data: data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Re-scan ──────────────────────────────────
  Future<void> rescan(String id) async {
    try {
      await _dio.post('/images/$id/rescan');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Get History ──────────────────────────────
  Future<PaginatedResponse<ImageHistoryModel>> getHistory(
    String id, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/images/$id/history',
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = response.data;
      final meta = data['meta'] as Map<String, dynamic>;
      final items = (data['data'] as List)
          .map((j) => ImageHistoryModel.fromJson(j as Map<String, dynamic>))
          .toList();
      return PaginatedResponse<ImageHistoryModel>(
        items: items,
        total: meta['total'] as int,
        page: meta['page'] as int,
        limit: meta['limit'] as int,
        totalPages: meta['totalPages'] as int,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Batch Operations ─────────────────────────
  Future<void> batchAction({
    required List<String> imageIds,
    required String action,
    Map<String, dynamic>? options,
  }) async {
    try {
      await _dio.post('/images/batch', data: {
        'imageIds': imageIds,
        'action': action,
        if (options != null) 'options': options,
      });
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Export Single Bytes ──────────────────────
  Future<Uint8List> exportSingleBytes(String id, String format) async {
    try {
      final response = await _dio.get<List<int>>(
        '/images/$id/export',
        queryParameters: {'format': format},
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Export Multiple Bytes ────────────────────
  Future<Uint8List> exportMultipleBytes(List<String> imageIds) async {
    try {
      final response = await _dio.post<List<int>>(
        '/images/export-multiple',
        data: {'imageIds': imageIds},
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
