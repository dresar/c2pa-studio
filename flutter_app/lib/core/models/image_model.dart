import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_model.freezed.dart';
part 'image_model.g.dart';

// ─────────────────────────────────────────────
// Image Model
// ─────────────────────────────────────────────
@freezed
class ImageModel with _$ImageModel {
  const factory ImageModel({
    required String id,
    required String projectId,
    required String originalFilename,
    required String sanitizedFilename,
    required String mimeType,
    required int sizeBytes,
    int? width,
    int? height,
    String? format,
    @Default('PENDING') String status,
    String? imagekitFileId,
    String? imagekitUrl,
    String? imagekitPath,
    String? processedUrl,
    String? thumbnailUrl,
    @Default(false) bool hasExif,
    @Default(false) bool hasIptc,
    @Default(false) bool hasXmp,
    @Default(false) bool hasGps,
    @Default(false) bool hasC2pa,
    bool? c2paVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
    ImageMetadataModel? metadata,
    C2paManifestModel? c2paManifest,
  }) = _ImageModel;

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);
}

// ─────────────────────────────────────────────
// Image Metadata Model
// ─────────────────────────────────────────────
@freezed
class ImageMetadataModel with _$ImageMetadataModel {
  const factory ImageMetadataModel({
    required String id,
    required String imageId,
    Map<String, dynamic>? exifData,
    Map<String, dynamic>? iptcData,
    Map<String, dynamic>? xmpData,
    Map<String, dynamic>? gpsData,
    Map<String, dynamic>? iccData,
    String? cameraModel,
    String? cameraMake,
    String? lensModel,
    String? software,
    String? colorProfile,
    String? focalLength,
    String? aperture,
    String? shutterSpeed,
    String? iso,
    DateTime? capturedAt,
    DateTime? modifiedAt,
    double? latitude,
    double? longitude,
    double? altitude,
    required DateTime scannedAt,
  }) = _ImageMetadataModel;

  factory ImageMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$ImageMetadataModelFromJson(json);
}

// ─────────────────────────────────────────────
// C2PA Manifest Model
// ─────────────────────────────────────────────
@freezed
class C2paManifestModel with _$C2paManifestModel {
  const factory C2paManifestModel({
    required String id,
    required String imageId,
    @Default(false) bool isCustom,
    bool? isVerified,
    String? creator,
    String? organization,
    String? website,
    String? license,
    String? copyright,
    String? generator,
    String? aiModel,
    String? prompt,
    String? negativePrompt,
    String? workflow,
    String? source,
    Map<String, dynamic>? manifestJson,
    Map<String, dynamic>? assertionsJson,
    DateTime? timestamp,
    required DateTime createdAt,
  }) = _C2paManifestModel;

  factory C2paManifestModel.fromJson(Map<String, dynamic> json) =>
      _$C2paManifestModelFromJson(json);
}

// ─────────────────────────────────────────────
// Image History Item
// ─────────────────────────────────────────────
@freezed
class ImageHistoryModel with _$ImageHistoryModel {
  const factory ImageHistoryModel({
    required String id,
    required String imageId,
    required String action,
    String? description,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
  }) = _ImageHistoryModel;

  factory ImageHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ImageHistoryModelFromJson(json);
}

// ─────────────────────────────────────────────
// C2PA Template
// ─────────────────────────────────────────────
@freezed
class C2paTemplateModel with _$C2paTemplateModel {
  const factory C2paTemplateModel({
    required String id,
    required String userId,
    required String name,
    String? creator,
    String? organization,
    String? website,
    String? license,
    String? copyright,
    String? generator,
    String? aiModel,
    String? workflow,
    String? source,
    @Default(false) bool isDefault,
    required DateTime createdAt,
  }) = _C2paTemplateModel;

  factory C2paTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$C2paTemplateModelFromJson(json);
}
