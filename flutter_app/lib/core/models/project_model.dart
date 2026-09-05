import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

// ─────────────────────────────────────────────
// Project Model
// ─────────────────────────────────────────────
@freezed
class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    required String id,
    required String userId,
    required String name,
    String? description,
    String? thumbnailUrl,
    @Default('ACTIVE') String status,
    @Default(0) int totalImages,
    @Default(0) int totalSizeBytes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);
}

// ─────────────────────────────────────────────
// Paginated Response
// ─────────────────────────────────────────────
@freezed
class PaginatedResponse<T> with _$PaginatedResponse<T> {
  const factory PaginatedResponse({
    required List<T> items,
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _PaginatedResponse<T>;
}
