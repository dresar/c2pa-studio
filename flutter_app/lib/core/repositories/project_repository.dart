import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/api_client.dart';
import '../models/project_model.dart';

part 'project_repository.g.dart';

// ─────────────────────────────────────────────
// Project Repository
// ─────────────────────────────────────────────
@riverpod
ProjectRepository projectRepository(ProjectRepositoryRef ref) {
  return ProjectRepository(ref.watch(apiClientProvider));
}

class ProjectRepository {
  final Dio _dio;
  ProjectRepository(this._dio);

  // ─── List Projects ────────────────────────────
  Future<PaginatedResponse<ProjectModel>> listProjects({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String sortBy = 'updatedAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final response = await _dio.get('/projects', queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null) 'status': status,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      });

      final data = response.data;
      final meta = data['meta'] as Map<String, dynamic>;
      final items = (data['data'] as List)
          .map((j) => ProjectModel.fromJson(j as Map<String, dynamic>))
          .toList();

      return PaginatedResponse<ProjectModel>(
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

  // ─── Get Project ──────────────────────────────
  Future<ProjectModel> getProject(String id) async {
    try {
      final response = await _dio.get('/projects/$id');
      return ProjectModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Create Project ───────────────────────────
  Future<ProjectModel> createProject({
    required String name,
    String? description,
  }) async {
    try {
      final response = await _dio.post('/projects', data: {
        'name': name,
        if (description != null && description.isNotEmpty) 'description': description,
      });
      return ProjectModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Update Project ───────────────────────────
  Future<ProjectModel> updateProject(
    String id, {
    String? name,
    String? description,
    String? status,
  }) async {
    try {
      final response = await _dio.patch('/projects/$id', data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (status != null) 'status': status,
      });
      return ProjectModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ─── Delete Project ───────────────────────────
  Future<void> deleteProject(String id) async {
    try {
      await _dio.delete('/projects/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
