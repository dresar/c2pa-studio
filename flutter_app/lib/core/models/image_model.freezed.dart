// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ImageModel _$ImageModelFromJson(Map<String, dynamic> json) {
  return _ImageModel.fromJson(json);
}

/// @nodoc
mixin _$ImageModel {
  String get id => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get originalFilename => throw _privateConstructorUsedError;
  String get sanitizedFilename => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  int get sizeBytes => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  String? get format => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get imagekitFileId => throw _privateConstructorUsedError;
  String? get imagekitUrl => throw _privateConstructorUsedError;
  String? get imagekitPath => throw _privateConstructorUsedError;
  String? get processedUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  bool get hasExif => throw _privateConstructorUsedError;
  bool get hasIptc => throw _privateConstructorUsedError;
  bool get hasXmp => throw _privateConstructorUsedError;
  bool get hasGps => throw _privateConstructorUsedError;
  bool get hasC2pa => throw _privateConstructorUsedError;
  bool? get c2paVerified => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  ImageMetadataModel? get metadata => throw _privateConstructorUsedError;
  C2paManifestModel? get c2paManifest => throw _privateConstructorUsedError;

  /// Serializes this ImageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImageModelCopyWith<ImageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageModelCopyWith<$Res> {
  factory $ImageModelCopyWith(
          ImageModel value, $Res Function(ImageModel) then) =
      _$ImageModelCopyWithImpl<$Res, ImageModel>;
  @useResult
  $Res call(
      {String id,
      String projectId,
      String originalFilename,
      String sanitizedFilename,
      String mimeType,
      int sizeBytes,
      int? width,
      int? height,
      String? format,
      String status,
      String? imagekitFileId,
      String? imagekitUrl,
      String? imagekitPath,
      String? processedUrl,
      String? thumbnailUrl,
      bool hasExif,
      bool hasIptc,
      bool hasXmp,
      bool hasGps,
      bool hasC2pa,
      bool? c2paVerified,
      DateTime createdAt,
      DateTime updatedAt,
      ImageMetadataModel? metadata,
      C2paManifestModel? c2paManifest});

  $ImageMetadataModelCopyWith<$Res>? get metadata;
  $C2paManifestModelCopyWith<$Res>? get c2paManifest;
}

/// @nodoc
class _$ImageModelCopyWithImpl<$Res, $Val extends ImageModel>
    implements $ImageModelCopyWith<$Res> {
  _$ImageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? originalFilename = null,
    Object? sanitizedFilename = null,
    Object? mimeType = null,
    Object? sizeBytes = null,
    Object? width = freezed,
    Object? height = freezed,
    Object? format = freezed,
    Object? status = null,
    Object? imagekitFileId = freezed,
    Object? imagekitUrl = freezed,
    Object? imagekitPath = freezed,
    Object? processedUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? hasExif = null,
    Object? hasIptc = null,
    Object? hasXmp = null,
    Object? hasGps = null,
    Object? hasC2pa = null,
    Object? c2paVerified = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? metadata = freezed,
    Object? c2paManifest = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      originalFilename: null == originalFilename
          ? _value.originalFilename
          : originalFilename // ignore: cast_nullable_to_non_nullable
              as String,
      sanitizedFilename: null == sanitizedFilename
          ? _value.sanitizedFilename
          : sanitizedFilename // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      sizeBytes: null == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      format: freezed == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      imagekitFileId: freezed == imagekitFileId
          ? _value.imagekitFileId
          : imagekitFileId // ignore: cast_nullable_to_non_nullable
              as String?,
      imagekitUrl: freezed == imagekitUrl
          ? _value.imagekitUrl
          : imagekitUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imagekitPath: freezed == imagekitPath
          ? _value.imagekitPath
          : imagekitPath // ignore: cast_nullable_to_non_nullable
              as String?,
      processedUrl: freezed == processedUrl
          ? _value.processedUrl
          : processedUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      hasExif: null == hasExif
          ? _value.hasExif
          : hasExif // ignore: cast_nullable_to_non_nullable
              as bool,
      hasIptc: null == hasIptc
          ? _value.hasIptc
          : hasIptc // ignore: cast_nullable_to_non_nullable
              as bool,
      hasXmp: null == hasXmp
          ? _value.hasXmp
          : hasXmp // ignore: cast_nullable_to_non_nullable
              as bool,
      hasGps: null == hasGps
          ? _value.hasGps
          : hasGps // ignore: cast_nullable_to_non_nullable
              as bool,
      hasC2pa: null == hasC2pa
          ? _value.hasC2pa
          : hasC2pa // ignore: cast_nullable_to_non_nullable
              as bool,
      c2paVerified: freezed == c2paVerified
          ? _value.c2paVerified
          : c2paVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ImageMetadataModel?,
      c2paManifest: freezed == c2paManifest
          ? _value.c2paManifest
          : c2paManifest // ignore: cast_nullable_to_non_nullable
              as C2paManifestModel?,
    ) as $Val);
  }

  /// Create a copy of ImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImageMetadataModelCopyWith<$Res>? get metadata {
    if (_value.metadata == null) {
      return null;
    }

    return $ImageMetadataModelCopyWith<$Res>(_value.metadata!, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }

  /// Create a copy of ImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $C2paManifestModelCopyWith<$Res>? get c2paManifest {
    if (_value.c2paManifest == null) {
      return null;
    }

    return $C2paManifestModelCopyWith<$Res>(_value.c2paManifest!, (value) {
      return _then(_value.copyWith(c2paManifest: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ImageModelImplCopyWith<$Res>
    implements $ImageModelCopyWith<$Res> {
  factory _$$ImageModelImplCopyWith(
          _$ImageModelImpl value, $Res Function(_$ImageModelImpl) then) =
      __$$ImageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String projectId,
      String originalFilename,
      String sanitizedFilename,
      String mimeType,
      int sizeBytes,
      int? width,
      int? height,
      String? format,
      String status,
      String? imagekitFileId,
      String? imagekitUrl,
      String? imagekitPath,
      String? processedUrl,
      String? thumbnailUrl,
      bool hasExif,
      bool hasIptc,
      bool hasXmp,
      bool hasGps,
      bool hasC2pa,
      bool? c2paVerified,
      DateTime createdAt,
      DateTime updatedAt,
      ImageMetadataModel? metadata,
      C2paManifestModel? c2paManifest});

  @override
  $ImageMetadataModelCopyWith<$Res>? get metadata;
  @override
  $C2paManifestModelCopyWith<$Res>? get c2paManifest;
}

/// @nodoc
class __$$ImageModelImplCopyWithImpl<$Res>
    extends _$ImageModelCopyWithImpl<$Res, _$ImageModelImpl>
    implements _$$ImageModelImplCopyWith<$Res> {
  __$$ImageModelImplCopyWithImpl(
      _$ImageModelImpl _value, $Res Function(_$ImageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? originalFilename = null,
    Object? sanitizedFilename = null,
    Object? mimeType = null,
    Object? sizeBytes = null,
    Object? width = freezed,
    Object? height = freezed,
    Object? format = freezed,
    Object? status = null,
    Object? imagekitFileId = freezed,
    Object? imagekitUrl = freezed,
    Object? imagekitPath = freezed,
    Object? processedUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? hasExif = null,
    Object? hasIptc = null,
    Object? hasXmp = null,
    Object? hasGps = null,
    Object? hasC2pa = null,
    Object? c2paVerified = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? metadata = freezed,
    Object? c2paManifest = freezed,
  }) {
    return _then(_$ImageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      originalFilename: null == originalFilename
          ? _value.originalFilename
          : originalFilename // ignore: cast_nullable_to_non_nullable
              as String,
      sanitizedFilename: null == sanitizedFilename
          ? _value.sanitizedFilename
          : sanitizedFilename // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      sizeBytes: null == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      format: freezed == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      imagekitFileId: freezed == imagekitFileId
          ? _value.imagekitFileId
          : imagekitFileId // ignore: cast_nullable_to_non_nullable
              as String?,
      imagekitUrl: freezed == imagekitUrl
          ? _value.imagekitUrl
          : imagekitUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imagekitPath: freezed == imagekitPath
          ? _value.imagekitPath
          : imagekitPath // ignore: cast_nullable_to_non_nullable
              as String?,
      processedUrl: freezed == processedUrl
          ? _value.processedUrl
          : processedUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      hasExif: null == hasExif
          ? _value.hasExif
          : hasExif // ignore: cast_nullable_to_non_nullable
              as bool,
      hasIptc: null == hasIptc
          ? _value.hasIptc
          : hasIptc // ignore: cast_nullable_to_non_nullable
              as bool,
      hasXmp: null == hasXmp
          ? _value.hasXmp
          : hasXmp // ignore: cast_nullable_to_non_nullable
              as bool,
      hasGps: null == hasGps
          ? _value.hasGps
          : hasGps // ignore: cast_nullable_to_non_nullable
              as bool,
      hasC2pa: null == hasC2pa
          ? _value.hasC2pa
          : hasC2pa // ignore: cast_nullable_to_non_nullable
              as bool,
      c2paVerified: freezed == c2paVerified
          ? _value.c2paVerified
          : c2paVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ImageMetadataModel?,
      c2paManifest: freezed == c2paManifest
          ? _value.c2paManifest
          : c2paManifest // ignore: cast_nullable_to_non_nullable
              as C2paManifestModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageModelImpl implements _ImageModel {
  const _$ImageModelImpl(
      {required this.id,
      required this.projectId,
      required this.originalFilename,
      required this.sanitizedFilename,
      required this.mimeType,
      required this.sizeBytes,
      this.width,
      this.height,
      this.format,
      this.status = 'PENDING',
      this.imagekitFileId,
      this.imagekitUrl,
      this.imagekitPath,
      this.processedUrl,
      this.thumbnailUrl,
      this.hasExif = false,
      this.hasIptc = false,
      this.hasXmp = false,
      this.hasGps = false,
      this.hasC2pa = false,
      this.c2paVerified,
      required this.createdAt,
      required this.updatedAt,
      this.metadata,
      this.c2paManifest});

  factory _$ImageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageModelImplFromJson(json);

  @override
  final String id;
  @override
  final String projectId;
  @override
  final String originalFilename;
  @override
  final String sanitizedFilename;
  @override
  final String mimeType;
  @override
  final int sizeBytes;
  @override
  final int? width;
  @override
  final int? height;
  @override
  final String? format;
  @override
  @JsonKey()
  final String status;
  @override
  final String? imagekitFileId;
  @override
  final String? imagekitUrl;
  @override
  final String? imagekitPath;
  @override
  final String? processedUrl;
  @override
  final String? thumbnailUrl;
  @override
  @JsonKey()
  final bool hasExif;
  @override
  @JsonKey()
  final bool hasIptc;
  @override
  @JsonKey()
  final bool hasXmp;
  @override
  @JsonKey()
  final bool hasGps;
  @override
  @JsonKey()
  final bool hasC2pa;
  @override
  final bool? c2paVerified;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final ImageMetadataModel? metadata;
  @override
  final C2paManifestModel? c2paManifest;

  @override
  String toString() {
    return 'ImageModel(id: $id, projectId: $projectId, originalFilename: $originalFilename, sanitizedFilename: $sanitizedFilename, mimeType: $mimeType, sizeBytes: $sizeBytes, width: $width, height: $height, format: $format, status: $status, imagekitFileId: $imagekitFileId, imagekitUrl: $imagekitUrl, imagekitPath: $imagekitPath, processedUrl: $processedUrl, thumbnailUrl: $thumbnailUrl, hasExif: $hasExif, hasIptc: $hasIptc, hasXmp: $hasXmp, hasGps: $hasGps, hasC2pa: $hasC2pa, c2paVerified: $c2paVerified, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata, c2paManifest: $c2paManifest)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.originalFilename, originalFilename) ||
                other.originalFilename == originalFilename) &&
            (identical(other.sanitizedFilename, sanitizedFilename) ||
                other.sanitizedFilename == sanitizedFilename) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.imagekitFileId, imagekitFileId) ||
                other.imagekitFileId == imagekitFileId) &&
            (identical(other.imagekitUrl, imagekitUrl) ||
                other.imagekitUrl == imagekitUrl) &&
            (identical(other.imagekitPath, imagekitPath) ||
                other.imagekitPath == imagekitPath) &&
            (identical(other.processedUrl, processedUrl) ||
                other.processedUrl == processedUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.hasExif, hasExif) || other.hasExif == hasExif) &&
            (identical(other.hasIptc, hasIptc) || other.hasIptc == hasIptc) &&
            (identical(other.hasXmp, hasXmp) || other.hasXmp == hasXmp) &&
            (identical(other.hasGps, hasGps) || other.hasGps == hasGps) &&
            (identical(other.hasC2pa, hasC2pa) || other.hasC2pa == hasC2pa) &&
            (identical(other.c2paVerified, c2paVerified) ||
                other.c2paVerified == c2paVerified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            (identical(other.c2paManifest, c2paManifest) ||
                other.c2paManifest == c2paManifest));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        projectId,
        originalFilename,
        sanitizedFilename,
        mimeType,
        sizeBytes,
        width,
        height,
        format,
        status,
        imagekitFileId,
        imagekitUrl,
        imagekitPath,
        processedUrl,
        thumbnailUrl,
        hasExif,
        hasIptc,
        hasXmp,
        hasGps,
        hasC2pa,
        c2paVerified,
        createdAt,
        updatedAt,
        metadata,
        c2paManifest
      ]);

  /// Create a copy of ImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageModelImplCopyWith<_$ImageModelImpl> get copyWith =>
      __$$ImageModelImplCopyWithImpl<_$ImageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageModelImplToJson(
      this,
    );
  }
}

abstract class _ImageModel implements ImageModel {
  const factory _ImageModel(
      {required final String id,
      required final String projectId,
      required final String originalFilename,
      required final String sanitizedFilename,
      required final String mimeType,
      required final int sizeBytes,
      final int? width,
      final int? height,
      final String? format,
      final String status,
      final String? imagekitFileId,
      final String? imagekitUrl,
      final String? imagekitPath,
      final String? processedUrl,
      final String? thumbnailUrl,
      final bool hasExif,
      final bool hasIptc,
      final bool hasXmp,
      final bool hasGps,
      final bool hasC2pa,
      final bool? c2paVerified,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final ImageMetadataModel? metadata,
      final C2paManifestModel? c2paManifest}) = _$ImageModelImpl;

  factory _ImageModel.fromJson(Map<String, dynamic> json) =
      _$ImageModelImpl.fromJson;

  @override
  String get id;
  @override
  String get projectId;
  @override
  String get originalFilename;
  @override
  String get sanitizedFilename;
  @override
  String get mimeType;
  @override
  int get sizeBytes;
  @override
  int? get width;
  @override
  int? get height;
  @override
  String? get format;
  @override
  String get status;
  @override
  String? get imagekitFileId;
  @override
  String? get imagekitUrl;
  @override
  String? get imagekitPath;
  @override
  String? get processedUrl;
  @override
  String? get thumbnailUrl;
  @override
  bool get hasExif;
  @override
  bool get hasIptc;
  @override
  bool get hasXmp;
  @override
  bool get hasGps;
  @override
  bool get hasC2pa;
  @override
  bool? get c2paVerified;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  ImageMetadataModel? get metadata;
  @override
  C2paManifestModel? get c2paManifest;

  /// Create a copy of ImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageModelImplCopyWith<_$ImageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ImageMetadataModel _$ImageMetadataModelFromJson(Map<String, dynamic> json) {
  return _ImageMetadataModel.fromJson(json);
}

/// @nodoc
mixin _$ImageMetadataModel {
  String get id => throw _privateConstructorUsedError;
  String get imageId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get exifData => throw _privateConstructorUsedError;
  Map<String, dynamic>? get iptcData => throw _privateConstructorUsedError;
  Map<String, dynamic>? get xmpData => throw _privateConstructorUsedError;
  Map<String, dynamic>? get gpsData => throw _privateConstructorUsedError;
  Map<String, dynamic>? get iccData => throw _privateConstructorUsedError;
  String? get cameraModel => throw _privateConstructorUsedError;
  String? get cameraMake => throw _privateConstructorUsedError;
  String? get lensModel => throw _privateConstructorUsedError;
  String? get software => throw _privateConstructorUsedError;
  String? get colorProfile => throw _privateConstructorUsedError;
  String? get focalLength => throw _privateConstructorUsedError;
  String? get aperture => throw _privateConstructorUsedError;
  String? get shutterSpeed => throw _privateConstructorUsedError;
  String? get iso => throw _privateConstructorUsedError;
  DateTime? get capturedAt => throw _privateConstructorUsedError;
  DateTime? get modifiedAt => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  double? get altitude => throw _privateConstructorUsedError;
  DateTime get scannedAt => throw _privateConstructorUsedError;

  /// Serializes this ImageMetadataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImageMetadataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImageMetadataModelCopyWith<ImageMetadataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageMetadataModelCopyWith<$Res> {
  factory $ImageMetadataModelCopyWith(
          ImageMetadataModel value, $Res Function(ImageMetadataModel) then) =
      _$ImageMetadataModelCopyWithImpl<$Res, ImageMetadataModel>;
  @useResult
  $Res call(
      {String id,
      String imageId,
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
      DateTime scannedAt});
}

/// @nodoc
class _$ImageMetadataModelCopyWithImpl<$Res, $Val extends ImageMetadataModel>
    implements $ImageMetadataModelCopyWith<$Res> {
  _$ImageMetadataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageMetadataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageId = null,
    Object? exifData = freezed,
    Object? iptcData = freezed,
    Object? xmpData = freezed,
    Object? gpsData = freezed,
    Object? iccData = freezed,
    Object? cameraModel = freezed,
    Object? cameraMake = freezed,
    Object? lensModel = freezed,
    Object? software = freezed,
    Object? colorProfile = freezed,
    Object? focalLength = freezed,
    Object? aperture = freezed,
    Object? shutterSpeed = freezed,
    Object? iso = freezed,
    Object? capturedAt = freezed,
    Object? modifiedAt = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? altitude = freezed,
    Object? scannedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String,
      exifData: freezed == exifData
          ? _value.exifData
          : exifData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      iptcData: freezed == iptcData
          ? _value.iptcData
          : iptcData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      xmpData: freezed == xmpData
          ? _value.xmpData
          : xmpData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      gpsData: freezed == gpsData
          ? _value.gpsData
          : gpsData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      iccData: freezed == iccData
          ? _value.iccData
          : iccData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      cameraModel: freezed == cameraModel
          ? _value.cameraModel
          : cameraModel // ignore: cast_nullable_to_non_nullable
              as String?,
      cameraMake: freezed == cameraMake
          ? _value.cameraMake
          : cameraMake // ignore: cast_nullable_to_non_nullable
              as String?,
      lensModel: freezed == lensModel
          ? _value.lensModel
          : lensModel // ignore: cast_nullable_to_non_nullable
              as String?,
      software: freezed == software
          ? _value.software
          : software // ignore: cast_nullable_to_non_nullable
              as String?,
      colorProfile: freezed == colorProfile
          ? _value.colorProfile
          : colorProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      focalLength: freezed == focalLength
          ? _value.focalLength
          : focalLength // ignore: cast_nullable_to_non_nullable
              as String?,
      aperture: freezed == aperture
          ? _value.aperture
          : aperture // ignore: cast_nullable_to_non_nullable
              as String?,
      shutterSpeed: freezed == shutterSpeed
          ? _value.shutterSpeed
          : shutterSpeed // ignore: cast_nullable_to_non_nullable
              as String?,
      iso: freezed == iso
          ? _value.iso
          : iso // ignore: cast_nullable_to_non_nullable
              as String?,
      capturedAt: freezed == capturedAt
          ? _value.capturedAt
          : capturedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      modifiedAt: freezed == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      altitude: freezed == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double?,
      scannedAt: null == scannedAt
          ? _value.scannedAt
          : scannedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImageMetadataModelImplCopyWith<$Res>
    implements $ImageMetadataModelCopyWith<$Res> {
  factory _$$ImageMetadataModelImplCopyWith(_$ImageMetadataModelImpl value,
          $Res Function(_$ImageMetadataModelImpl) then) =
      __$$ImageMetadataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String imageId,
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
      DateTime scannedAt});
}

/// @nodoc
class __$$ImageMetadataModelImplCopyWithImpl<$Res>
    extends _$ImageMetadataModelCopyWithImpl<$Res, _$ImageMetadataModelImpl>
    implements _$$ImageMetadataModelImplCopyWith<$Res> {
  __$$ImageMetadataModelImplCopyWithImpl(_$ImageMetadataModelImpl _value,
      $Res Function(_$ImageMetadataModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImageMetadataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageId = null,
    Object? exifData = freezed,
    Object? iptcData = freezed,
    Object? xmpData = freezed,
    Object? gpsData = freezed,
    Object? iccData = freezed,
    Object? cameraModel = freezed,
    Object? cameraMake = freezed,
    Object? lensModel = freezed,
    Object? software = freezed,
    Object? colorProfile = freezed,
    Object? focalLength = freezed,
    Object? aperture = freezed,
    Object? shutterSpeed = freezed,
    Object? iso = freezed,
    Object? capturedAt = freezed,
    Object? modifiedAt = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? altitude = freezed,
    Object? scannedAt = null,
  }) {
    return _then(_$ImageMetadataModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String,
      exifData: freezed == exifData
          ? _value._exifData
          : exifData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      iptcData: freezed == iptcData
          ? _value._iptcData
          : iptcData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      xmpData: freezed == xmpData
          ? _value._xmpData
          : xmpData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      gpsData: freezed == gpsData
          ? _value._gpsData
          : gpsData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      iccData: freezed == iccData
          ? _value._iccData
          : iccData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      cameraModel: freezed == cameraModel
          ? _value.cameraModel
          : cameraModel // ignore: cast_nullable_to_non_nullable
              as String?,
      cameraMake: freezed == cameraMake
          ? _value.cameraMake
          : cameraMake // ignore: cast_nullable_to_non_nullable
              as String?,
      lensModel: freezed == lensModel
          ? _value.lensModel
          : lensModel // ignore: cast_nullable_to_non_nullable
              as String?,
      software: freezed == software
          ? _value.software
          : software // ignore: cast_nullable_to_non_nullable
              as String?,
      colorProfile: freezed == colorProfile
          ? _value.colorProfile
          : colorProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      focalLength: freezed == focalLength
          ? _value.focalLength
          : focalLength // ignore: cast_nullable_to_non_nullable
              as String?,
      aperture: freezed == aperture
          ? _value.aperture
          : aperture // ignore: cast_nullable_to_non_nullable
              as String?,
      shutterSpeed: freezed == shutterSpeed
          ? _value.shutterSpeed
          : shutterSpeed // ignore: cast_nullable_to_non_nullable
              as String?,
      iso: freezed == iso
          ? _value.iso
          : iso // ignore: cast_nullable_to_non_nullable
              as String?,
      capturedAt: freezed == capturedAt
          ? _value.capturedAt
          : capturedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      modifiedAt: freezed == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      altitude: freezed == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double?,
      scannedAt: null == scannedAt
          ? _value.scannedAt
          : scannedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageMetadataModelImpl implements _ImageMetadataModel {
  const _$ImageMetadataModelImpl(
      {required this.id,
      required this.imageId,
      final Map<String, dynamic>? exifData,
      final Map<String, dynamic>? iptcData,
      final Map<String, dynamic>? xmpData,
      final Map<String, dynamic>? gpsData,
      final Map<String, dynamic>? iccData,
      this.cameraModel,
      this.cameraMake,
      this.lensModel,
      this.software,
      this.colorProfile,
      this.focalLength,
      this.aperture,
      this.shutterSpeed,
      this.iso,
      this.capturedAt,
      this.modifiedAt,
      this.latitude,
      this.longitude,
      this.altitude,
      required this.scannedAt})
      : _exifData = exifData,
        _iptcData = iptcData,
        _xmpData = xmpData,
        _gpsData = gpsData,
        _iccData = iccData;

  factory _$ImageMetadataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageMetadataModelImplFromJson(json);

  @override
  final String id;
  @override
  final String imageId;
  final Map<String, dynamic>? _exifData;
  @override
  Map<String, dynamic>? get exifData {
    final value = _exifData;
    if (value == null) return null;
    if (_exifData is EqualUnmodifiableMapView) return _exifData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _iptcData;
  @override
  Map<String, dynamic>? get iptcData {
    final value = _iptcData;
    if (value == null) return null;
    if (_iptcData is EqualUnmodifiableMapView) return _iptcData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _xmpData;
  @override
  Map<String, dynamic>? get xmpData {
    final value = _xmpData;
    if (value == null) return null;
    if (_xmpData is EqualUnmodifiableMapView) return _xmpData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _gpsData;
  @override
  Map<String, dynamic>? get gpsData {
    final value = _gpsData;
    if (value == null) return null;
    if (_gpsData is EqualUnmodifiableMapView) return _gpsData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _iccData;
  @override
  Map<String, dynamic>? get iccData {
    final value = _iccData;
    if (value == null) return null;
    if (_iccData is EqualUnmodifiableMapView) return _iccData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? cameraModel;
  @override
  final String? cameraMake;
  @override
  final String? lensModel;
  @override
  final String? software;
  @override
  final String? colorProfile;
  @override
  final String? focalLength;
  @override
  final String? aperture;
  @override
  final String? shutterSpeed;
  @override
  final String? iso;
  @override
  final DateTime? capturedAt;
  @override
  final DateTime? modifiedAt;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final double? altitude;
  @override
  final DateTime scannedAt;

  @override
  String toString() {
    return 'ImageMetadataModel(id: $id, imageId: $imageId, exifData: $exifData, iptcData: $iptcData, xmpData: $xmpData, gpsData: $gpsData, iccData: $iccData, cameraModel: $cameraModel, cameraMake: $cameraMake, lensModel: $lensModel, software: $software, colorProfile: $colorProfile, focalLength: $focalLength, aperture: $aperture, shutterSpeed: $shutterSpeed, iso: $iso, capturedAt: $capturedAt, modifiedAt: $modifiedAt, latitude: $latitude, longitude: $longitude, altitude: $altitude, scannedAt: $scannedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageMetadataModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageId, imageId) || other.imageId == imageId) &&
            const DeepCollectionEquality().equals(other._exifData, _exifData) &&
            const DeepCollectionEquality().equals(other._iptcData, _iptcData) &&
            const DeepCollectionEquality().equals(other._xmpData, _xmpData) &&
            const DeepCollectionEquality().equals(other._gpsData, _gpsData) &&
            const DeepCollectionEquality().equals(other._iccData, _iccData) &&
            (identical(other.cameraModel, cameraModel) ||
                other.cameraModel == cameraModel) &&
            (identical(other.cameraMake, cameraMake) ||
                other.cameraMake == cameraMake) &&
            (identical(other.lensModel, lensModel) ||
                other.lensModel == lensModel) &&
            (identical(other.software, software) ||
                other.software == software) &&
            (identical(other.colorProfile, colorProfile) ||
                other.colorProfile == colorProfile) &&
            (identical(other.focalLength, focalLength) ||
                other.focalLength == focalLength) &&
            (identical(other.aperture, aperture) ||
                other.aperture == aperture) &&
            (identical(other.shutterSpeed, shutterSpeed) ||
                other.shutterSpeed == shutterSpeed) &&
            (identical(other.iso, iso) || other.iso == iso) &&
            (identical(other.capturedAt, capturedAt) ||
                other.capturedAt == capturedAt) &&
            (identical(other.modifiedAt, modifiedAt) ||
                other.modifiedAt == modifiedAt) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.scannedAt, scannedAt) ||
                other.scannedAt == scannedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        imageId,
        const DeepCollectionEquality().hash(_exifData),
        const DeepCollectionEquality().hash(_iptcData),
        const DeepCollectionEquality().hash(_xmpData),
        const DeepCollectionEquality().hash(_gpsData),
        const DeepCollectionEquality().hash(_iccData),
        cameraModel,
        cameraMake,
        lensModel,
        software,
        colorProfile,
        focalLength,
        aperture,
        shutterSpeed,
        iso,
        capturedAt,
        modifiedAt,
        latitude,
        longitude,
        altitude,
        scannedAt
      ]);

  /// Create a copy of ImageMetadataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageMetadataModelImplCopyWith<_$ImageMetadataModelImpl> get copyWith =>
      __$$ImageMetadataModelImplCopyWithImpl<_$ImageMetadataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageMetadataModelImplToJson(
      this,
    );
  }
}

abstract class _ImageMetadataModel implements ImageMetadataModel {
  const factory _ImageMetadataModel(
      {required final String id,
      required final String imageId,
      final Map<String, dynamic>? exifData,
      final Map<String, dynamic>? iptcData,
      final Map<String, dynamic>? xmpData,
      final Map<String, dynamic>? gpsData,
      final Map<String, dynamic>? iccData,
      final String? cameraModel,
      final String? cameraMake,
      final String? lensModel,
      final String? software,
      final String? colorProfile,
      final String? focalLength,
      final String? aperture,
      final String? shutterSpeed,
      final String? iso,
      final DateTime? capturedAt,
      final DateTime? modifiedAt,
      final double? latitude,
      final double? longitude,
      final double? altitude,
      required final DateTime scannedAt}) = _$ImageMetadataModelImpl;

  factory _ImageMetadataModel.fromJson(Map<String, dynamic> json) =
      _$ImageMetadataModelImpl.fromJson;

  @override
  String get id;
  @override
  String get imageId;
  @override
  Map<String, dynamic>? get exifData;
  @override
  Map<String, dynamic>? get iptcData;
  @override
  Map<String, dynamic>? get xmpData;
  @override
  Map<String, dynamic>? get gpsData;
  @override
  Map<String, dynamic>? get iccData;
  @override
  String? get cameraModel;
  @override
  String? get cameraMake;
  @override
  String? get lensModel;
  @override
  String? get software;
  @override
  String? get colorProfile;
  @override
  String? get focalLength;
  @override
  String? get aperture;
  @override
  String? get shutterSpeed;
  @override
  String? get iso;
  @override
  DateTime? get capturedAt;
  @override
  DateTime? get modifiedAt;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  double? get altitude;
  @override
  DateTime get scannedAt;

  /// Create a copy of ImageMetadataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageMetadataModelImplCopyWith<_$ImageMetadataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

C2paManifestModel _$C2paManifestModelFromJson(Map<String, dynamic> json) {
  return _C2paManifestModel.fromJson(json);
}

/// @nodoc
mixin _$C2paManifestModel {
  String get id => throw _privateConstructorUsedError;
  String get imageId => throw _privateConstructorUsedError;
  bool get isCustom => throw _privateConstructorUsedError;
  bool? get isVerified => throw _privateConstructorUsedError;
  String? get creator => throw _privateConstructorUsedError;
  String? get organization => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get license => throw _privateConstructorUsedError;
  String? get copyright => throw _privateConstructorUsedError;
  String? get generator => throw _privateConstructorUsedError;
  String? get aiModel => throw _privateConstructorUsedError;
  String? get prompt => throw _privateConstructorUsedError;
  String? get negativePrompt => throw _privateConstructorUsedError;
  String? get workflow => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  Map<String, dynamic>? get manifestJson => throw _privateConstructorUsedError;
  Map<String, dynamic>? get assertionsJson =>
      throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this C2paManifestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of C2paManifestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $C2paManifestModelCopyWith<C2paManifestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $C2paManifestModelCopyWith<$Res> {
  factory $C2paManifestModelCopyWith(
          C2paManifestModel value, $Res Function(C2paManifestModel) then) =
      _$C2paManifestModelCopyWithImpl<$Res, C2paManifestModel>;
  @useResult
  $Res call(
      {String id,
      String imageId,
      bool isCustom,
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
      DateTime createdAt});
}

/// @nodoc
class _$C2paManifestModelCopyWithImpl<$Res, $Val extends C2paManifestModel>
    implements $C2paManifestModelCopyWith<$Res> {
  _$C2paManifestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of C2paManifestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageId = null,
    Object? isCustom = null,
    Object? isVerified = freezed,
    Object? creator = freezed,
    Object? organization = freezed,
    Object? website = freezed,
    Object? license = freezed,
    Object? copyright = freezed,
    Object? generator = freezed,
    Object? aiModel = freezed,
    Object? prompt = freezed,
    Object? negativePrompt = freezed,
    Object? workflow = freezed,
    Object? source = freezed,
    Object? manifestJson = freezed,
    Object? assertionsJson = freezed,
    Object? timestamp = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String,
      isCustom: null == isCustom
          ? _value.isCustom
          : isCustom // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      creator: freezed == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      license: freezed == license
          ? _value.license
          : license // ignore: cast_nullable_to_non_nullable
              as String?,
      copyright: freezed == copyright
          ? _value.copyright
          : copyright // ignore: cast_nullable_to_non_nullable
              as String?,
      generator: freezed == generator
          ? _value.generator
          : generator // ignore: cast_nullable_to_non_nullable
              as String?,
      aiModel: freezed == aiModel
          ? _value.aiModel
          : aiModel // ignore: cast_nullable_to_non_nullable
              as String?,
      prompt: freezed == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      negativePrompt: freezed == negativePrompt
          ? _value.negativePrompt
          : negativePrompt // ignore: cast_nullable_to_non_nullable
              as String?,
      workflow: freezed == workflow
          ? _value.workflow
          : workflow // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      manifestJson: freezed == manifestJson
          ? _value.manifestJson
          : manifestJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      assertionsJson: freezed == assertionsJson
          ? _value.assertionsJson
          : assertionsJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$C2paManifestModelImplCopyWith<$Res>
    implements $C2paManifestModelCopyWith<$Res> {
  factory _$$C2paManifestModelImplCopyWith(_$C2paManifestModelImpl value,
          $Res Function(_$C2paManifestModelImpl) then) =
      __$$C2paManifestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String imageId,
      bool isCustom,
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
      DateTime createdAt});
}

/// @nodoc
class __$$C2paManifestModelImplCopyWithImpl<$Res>
    extends _$C2paManifestModelCopyWithImpl<$Res, _$C2paManifestModelImpl>
    implements _$$C2paManifestModelImplCopyWith<$Res> {
  __$$C2paManifestModelImplCopyWithImpl(_$C2paManifestModelImpl _value,
      $Res Function(_$C2paManifestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of C2paManifestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageId = null,
    Object? isCustom = null,
    Object? isVerified = freezed,
    Object? creator = freezed,
    Object? organization = freezed,
    Object? website = freezed,
    Object? license = freezed,
    Object? copyright = freezed,
    Object? generator = freezed,
    Object? aiModel = freezed,
    Object? prompt = freezed,
    Object? negativePrompt = freezed,
    Object? workflow = freezed,
    Object? source = freezed,
    Object? manifestJson = freezed,
    Object? assertionsJson = freezed,
    Object? timestamp = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$C2paManifestModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String,
      isCustom: null == isCustom
          ? _value.isCustom
          : isCustom // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      creator: freezed == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      license: freezed == license
          ? _value.license
          : license // ignore: cast_nullable_to_non_nullable
              as String?,
      copyright: freezed == copyright
          ? _value.copyright
          : copyright // ignore: cast_nullable_to_non_nullable
              as String?,
      generator: freezed == generator
          ? _value.generator
          : generator // ignore: cast_nullable_to_non_nullable
              as String?,
      aiModel: freezed == aiModel
          ? _value.aiModel
          : aiModel // ignore: cast_nullable_to_non_nullable
              as String?,
      prompt: freezed == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      negativePrompt: freezed == negativePrompt
          ? _value.negativePrompt
          : negativePrompt // ignore: cast_nullable_to_non_nullable
              as String?,
      workflow: freezed == workflow
          ? _value.workflow
          : workflow // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      manifestJson: freezed == manifestJson
          ? _value._manifestJson
          : manifestJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      assertionsJson: freezed == assertionsJson
          ? _value._assertionsJson
          : assertionsJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$C2paManifestModelImpl implements _C2paManifestModel {
  const _$C2paManifestModelImpl(
      {required this.id,
      required this.imageId,
      this.isCustom = false,
      this.isVerified,
      this.creator,
      this.organization,
      this.website,
      this.license,
      this.copyright,
      this.generator,
      this.aiModel,
      this.prompt,
      this.negativePrompt,
      this.workflow,
      this.source,
      final Map<String, dynamic>? manifestJson,
      final Map<String, dynamic>? assertionsJson,
      this.timestamp,
      required this.createdAt})
      : _manifestJson = manifestJson,
        _assertionsJson = assertionsJson;

  factory _$C2paManifestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$C2paManifestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String imageId;
  @override
  @JsonKey()
  final bool isCustom;
  @override
  final bool? isVerified;
  @override
  final String? creator;
  @override
  final String? organization;
  @override
  final String? website;
  @override
  final String? license;
  @override
  final String? copyright;
  @override
  final String? generator;
  @override
  final String? aiModel;
  @override
  final String? prompt;
  @override
  final String? negativePrompt;
  @override
  final String? workflow;
  @override
  final String? source;
  final Map<String, dynamic>? _manifestJson;
  @override
  Map<String, dynamic>? get manifestJson {
    final value = _manifestJson;
    if (value == null) return null;
    if (_manifestJson is EqualUnmodifiableMapView) return _manifestJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _assertionsJson;
  @override
  Map<String, dynamic>? get assertionsJson {
    final value = _assertionsJson;
    if (value == null) return null;
    if (_assertionsJson is EqualUnmodifiableMapView) return _assertionsJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? timestamp;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'C2paManifestModel(id: $id, imageId: $imageId, isCustom: $isCustom, isVerified: $isVerified, creator: $creator, organization: $organization, website: $website, license: $license, copyright: $copyright, generator: $generator, aiModel: $aiModel, prompt: $prompt, negativePrompt: $negativePrompt, workflow: $workflow, source: $source, manifestJson: $manifestJson, assertionsJson: $assertionsJson, timestamp: $timestamp, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$C2paManifestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageId, imageId) || other.imageId == imageId) &&
            (identical(other.isCustom, isCustom) ||
                other.isCustom == isCustom) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.license, license) || other.license == license) &&
            (identical(other.copyright, copyright) ||
                other.copyright == copyright) &&
            (identical(other.generator, generator) ||
                other.generator == generator) &&
            (identical(other.aiModel, aiModel) || other.aiModel == aiModel) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.negativePrompt, negativePrompt) ||
                other.negativePrompt == negativePrompt) &&
            (identical(other.workflow, workflow) ||
                other.workflow == workflow) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality()
                .equals(other._manifestJson, _manifestJson) &&
            const DeepCollectionEquality()
                .equals(other._assertionsJson, _assertionsJson) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        imageId,
        isCustom,
        isVerified,
        creator,
        organization,
        website,
        license,
        copyright,
        generator,
        aiModel,
        prompt,
        negativePrompt,
        workflow,
        source,
        const DeepCollectionEquality().hash(_manifestJson),
        const DeepCollectionEquality().hash(_assertionsJson),
        timestamp,
        createdAt
      ]);

  /// Create a copy of C2paManifestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$C2paManifestModelImplCopyWith<_$C2paManifestModelImpl> get copyWith =>
      __$$C2paManifestModelImplCopyWithImpl<_$C2paManifestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$C2paManifestModelImplToJson(
      this,
    );
  }
}

abstract class _C2paManifestModel implements C2paManifestModel {
  const factory _C2paManifestModel(
      {required final String id,
      required final String imageId,
      final bool isCustom,
      final bool? isVerified,
      final String? creator,
      final String? organization,
      final String? website,
      final String? license,
      final String? copyright,
      final String? generator,
      final String? aiModel,
      final String? prompt,
      final String? negativePrompt,
      final String? workflow,
      final String? source,
      final Map<String, dynamic>? manifestJson,
      final Map<String, dynamic>? assertionsJson,
      final DateTime? timestamp,
      required final DateTime createdAt}) = _$C2paManifestModelImpl;

  factory _C2paManifestModel.fromJson(Map<String, dynamic> json) =
      _$C2paManifestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get imageId;
  @override
  bool get isCustom;
  @override
  bool? get isVerified;
  @override
  String? get creator;
  @override
  String? get organization;
  @override
  String? get website;
  @override
  String? get license;
  @override
  String? get copyright;
  @override
  String? get generator;
  @override
  String? get aiModel;
  @override
  String? get prompt;
  @override
  String? get negativePrompt;
  @override
  String? get workflow;
  @override
  String? get source;
  @override
  Map<String, dynamic>? get manifestJson;
  @override
  Map<String, dynamic>? get assertionsJson;
  @override
  DateTime? get timestamp;
  @override
  DateTime get createdAt;

  /// Create a copy of C2paManifestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$C2paManifestModelImplCopyWith<_$C2paManifestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ImageHistoryModel _$ImageHistoryModelFromJson(Map<String, dynamic> json) {
  return _ImageHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$ImageHistoryModel {
  String get id => throw _privateConstructorUsedError;
  String get imageId => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ImageHistoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImageHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImageHistoryModelCopyWith<ImageHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageHistoryModelCopyWith<$Res> {
  factory $ImageHistoryModelCopyWith(
          ImageHistoryModel value, $Res Function(ImageHistoryModel) then) =
      _$ImageHistoryModelCopyWithImpl<$Res, ImageHistoryModel>;
  @useResult
  $Res call(
      {String id,
      String imageId,
      String action,
      String? description,
      Map<String, dynamic>? metadata,
      DateTime createdAt});
}

/// @nodoc
class _$ImageHistoryModelCopyWithImpl<$Res, $Val extends ImageHistoryModel>
    implements $ImageHistoryModelCopyWith<$Res> {
  _$ImageHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageId = null,
    Object? action = null,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImageHistoryModelImplCopyWith<$Res>
    implements $ImageHistoryModelCopyWith<$Res> {
  factory _$$ImageHistoryModelImplCopyWith(_$ImageHistoryModelImpl value,
          $Res Function(_$ImageHistoryModelImpl) then) =
      __$$ImageHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String imageId,
      String action,
      String? description,
      Map<String, dynamic>? metadata,
      DateTime createdAt});
}

/// @nodoc
class __$$ImageHistoryModelImplCopyWithImpl<$Res>
    extends _$ImageHistoryModelCopyWithImpl<$Res, _$ImageHistoryModelImpl>
    implements _$$ImageHistoryModelImplCopyWith<$Res> {
  __$$ImageHistoryModelImplCopyWithImpl(_$ImageHistoryModelImpl _value,
      $Res Function(_$ImageHistoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImageHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageId = null,
    Object? action = null,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ImageHistoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageHistoryModelImpl implements _ImageHistoryModel {
  const _$ImageHistoryModelImpl(
      {required this.id,
      required this.imageId,
      required this.action,
      this.description,
      final Map<String, dynamic>? metadata,
      required this.createdAt})
      : _metadata = metadata;

  factory _$ImageHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageHistoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String imageId;
  @override
  final String action;
  @override
  final String? description;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ImageHistoryModel(id: $id, imageId: $imageId, action: $action, description: $description, metadata: $metadata, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageId, imageId) || other.imageId == imageId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, imageId, action, description,
      const DeepCollectionEquality().hash(_metadata), createdAt);

  /// Create a copy of ImageHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageHistoryModelImplCopyWith<_$ImageHistoryModelImpl> get copyWith =>
      __$$ImageHistoryModelImplCopyWithImpl<_$ImageHistoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _ImageHistoryModel implements ImageHistoryModel {
  const factory _ImageHistoryModel(
      {required final String id,
      required final String imageId,
      required final String action,
      final String? description,
      final Map<String, dynamic>? metadata,
      required final DateTime createdAt}) = _$ImageHistoryModelImpl;

  factory _ImageHistoryModel.fromJson(Map<String, dynamic> json) =
      _$ImageHistoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get imageId;
  @override
  String get action;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get createdAt;

  /// Create a copy of ImageHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageHistoryModelImplCopyWith<_$ImageHistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

C2paTemplateModel _$C2paTemplateModelFromJson(Map<String, dynamic> json) {
  return _C2paTemplateModel.fromJson(json);
}

/// @nodoc
mixin _$C2paTemplateModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get creator => throw _privateConstructorUsedError;
  String? get organization => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get license => throw _privateConstructorUsedError;
  String? get copyright => throw _privateConstructorUsedError;
  String? get generator => throw _privateConstructorUsedError;
  String? get aiModel => throw _privateConstructorUsedError;
  String? get workflow => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this C2paTemplateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of C2paTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $C2paTemplateModelCopyWith<C2paTemplateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $C2paTemplateModelCopyWith<$Res> {
  factory $C2paTemplateModelCopyWith(
          C2paTemplateModel value, $Res Function(C2paTemplateModel) then) =
      _$C2paTemplateModelCopyWithImpl<$Res, C2paTemplateModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String? creator,
      String? organization,
      String? website,
      String? license,
      String? copyright,
      String? generator,
      String? aiModel,
      String? workflow,
      String? source,
      bool isDefault,
      DateTime createdAt});
}

/// @nodoc
class _$C2paTemplateModelCopyWithImpl<$Res, $Val extends C2paTemplateModel>
    implements $C2paTemplateModelCopyWith<$Res> {
  _$C2paTemplateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of C2paTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? creator = freezed,
    Object? organization = freezed,
    Object? website = freezed,
    Object? license = freezed,
    Object? copyright = freezed,
    Object? generator = freezed,
    Object? aiModel = freezed,
    Object? workflow = freezed,
    Object? source = freezed,
    Object? isDefault = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      creator: freezed == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      license: freezed == license
          ? _value.license
          : license // ignore: cast_nullable_to_non_nullable
              as String?,
      copyright: freezed == copyright
          ? _value.copyright
          : copyright // ignore: cast_nullable_to_non_nullable
              as String?,
      generator: freezed == generator
          ? _value.generator
          : generator // ignore: cast_nullable_to_non_nullable
              as String?,
      aiModel: freezed == aiModel
          ? _value.aiModel
          : aiModel // ignore: cast_nullable_to_non_nullable
              as String?,
      workflow: freezed == workflow
          ? _value.workflow
          : workflow // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$C2paTemplateModelImplCopyWith<$Res>
    implements $C2paTemplateModelCopyWith<$Res> {
  factory _$$C2paTemplateModelImplCopyWith(_$C2paTemplateModelImpl value,
          $Res Function(_$C2paTemplateModelImpl) then) =
      __$$C2paTemplateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String? creator,
      String? organization,
      String? website,
      String? license,
      String? copyright,
      String? generator,
      String? aiModel,
      String? workflow,
      String? source,
      bool isDefault,
      DateTime createdAt});
}

/// @nodoc
class __$$C2paTemplateModelImplCopyWithImpl<$Res>
    extends _$C2paTemplateModelCopyWithImpl<$Res, _$C2paTemplateModelImpl>
    implements _$$C2paTemplateModelImplCopyWith<$Res> {
  __$$C2paTemplateModelImplCopyWithImpl(_$C2paTemplateModelImpl _value,
      $Res Function(_$C2paTemplateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of C2paTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? creator = freezed,
    Object? organization = freezed,
    Object? website = freezed,
    Object? license = freezed,
    Object? copyright = freezed,
    Object? generator = freezed,
    Object? aiModel = freezed,
    Object? workflow = freezed,
    Object? source = freezed,
    Object? isDefault = null,
    Object? createdAt = null,
  }) {
    return _then(_$C2paTemplateModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      creator: freezed == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      license: freezed == license
          ? _value.license
          : license // ignore: cast_nullable_to_non_nullable
              as String?,
      copyright: freezed == copyright
          ? _value.copyright
          : copyright // ignore: cast_nullable_to_non_nullable
              as String?,
      generator: freezed == generator
          ? _value.generator
          : generator // ignore: cast_nullable_to_non_nullable
              as String?,
      aiModel: freezed == aiModel
          ? _value.aiModel
          : aiModel // ignore: cast_nullable_to_non_nullable
              as String?,
      workflow: freezed == workflow
          ? _value.workflow
          : workflow // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$C2paTemplateModelImpl implements _C2paTemplateModel {
  const _$C2paTemplateModelImpl(
      {required this.id,
      required this.userId,
      required this.name,
      this.creator,
      this.organization,
      this.website,
      this.license,
      this.copyright,
      this.generator,
      this.aiModel,
      this.workflow,
      this.source,
      this.isDefault = false,
      required this.createdAt});

  factory _$C2paTemplateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$C2paTemplateModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String? creator;
  @override
  final String? organization;
  @override
  final String? website;
  @override
  final String? license;
  @override
  final String? copyright;
  @override
  final String? generator;
  @override
  final String? aiModel;
  @override
  final String? workflow;
  @override
  final String? source;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'C2paTemplateModel(id: $id, userId: $userId, name: $name, creator: $creator, organization: $organization, website: $website, license: $license, copyright: $copyright, generator: $generator, aiModel: $aiModel, workflow: $workflow, source: $source, isDefault: $isDefault, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$C2paTemplateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.license, license) || other.license == license) &&
            (identical(other.copyright, copyright) ||
                other.copyright == copyright) &&
            (identical(other.generator, generator) ||
                other.generator == generator) &&
            (identical(other.aiModel, aiModel) || other.aiModel == aiModel) &&
            (identical(other.workflow, workflow) ||
                other.workflow == workflow) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      name,
      creator,
      organization,
      website,
      license,
      copyright,
      generator,
      aiModel,
      workflow,
      source,
      isDefault,
      createdAt);

  /// Create a copy of C2paTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$C2paTemplateModelImplCopyWith<_$C2paTemplateModelImpl> get copyWith =>
      __$$C2paTemplateModelImplCopyWithImpl<_$C2paTemplateModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$C2paTemplateModelImplToJson(
      this,
    );
  }
}

abstract class _C2paTemplateModel implements C2paTemplateModel {
  const factory _C2paTemplateModel(
      {required final String id,
      required final String userId,
      required final String name,
      final String? creator,
      final String? organization,
      final String? website,
      final String? license,
      final String? copyright,
      final String? generator,
      final String? aiModel,
      final String? workflow,
      final String? source,
      final bool isDefault,
      required final DateTime createdAt}) = _$C2paTemplateModelImpl;

  factory _C2paTemplateModel.fromJson(Map<String, dynamic> json) =
      _$C2paTemplateModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  String? get creator;
  @override
  String? get organization;
  @override
  String? get website;
  @override
  String? get license;
  @override
  String? get copyright;
  @override
  String? get generator;
  @override
  String? get aiModel;
  @override
  String? get workflow;
  @override
  String? get source;
  @override
  bool get isDefault;
  @override
  DateTime get createdAt;

  /// Create a copy of C2paTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$C2paTemplateModelImplCopyWith<_$C2paTemplateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
