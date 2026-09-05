import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/api_client.dart';
import '../models/image_model.dart';

part 'template_repository.g.dart';

// ─────────────────────────────────────────────
// Template Repository
// ─────────────────────────────────────────────
@riverpod
TemplateRepository templateRepository(TemplateRepositoryRef ref) {
  return TemplateRepository(ref.watch(apiClientProvider));
}

class TemplateRepository {
  final Dio _dio;
  TemplateRepository(this._dio);

  // ─── List Templates ───────────────────────────
  Future<List<C2paTemplateModel>> listTemplates() async {
    try {
      final response = await _dio.get('/templates');
      final list = response.data['data'] as List;
      return list.map((j) => C2paTemplateModel.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Create Template ──────────────────────────
  Future<C2paTemplateModel> createTemplate(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/templates', data: data);
      return C2paTemplateModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Delete Template ──────────────────────────
  Future<void> deleteTemplate(String id) async {
    try {
      await _dio.delete('/templates/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
