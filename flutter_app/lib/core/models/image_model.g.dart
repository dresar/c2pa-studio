// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImageModelImpl _$$ImageModelImplFromJson(Map<String, dynamic> json) =>
    _$ImageModelImpl(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      originalFilename: json['originalFilename'] as String,
      sanitizedFilename: json['sanitizedFilename'] as String,
      mimeType: json['mimeType'] as String,
      sizeBytes: (json['sizeBytes'] as num).toInt(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      format: json['format'] as String?,
      status: json['status'] as String? ?? 'PENDING',
      imagekitFileId: json['imagekitFileId'] as String?,
      imagekitUrl: json['imagekitUrl'] as String?,
      imagekitPath: json['imagekitPath'] as String?,
      processedUrl: json['processedUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      hasExif: json['hasExif'] as bool? ?? false,
      hasIptc: json['hasIptc'] as bool? ?? false,
      hasXmp: json['hasXmp'] as bool? ?? false,
      hasGps: json['hasGps'] as bool? ?? false,
      hasC2pa: json['hasC2pa'] as bool? ?? false,
      c2paVerified: json['c2paVerified'] as bool?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] == null
          ? null
          : ImageMetadataModel.fromJson(
              json['metadata'] as Map<String, dynamic>),
      c2paManifest: json['c2paManifest'] == null
          ? null
          : C2paManifestModel.fromJson(
              json['c2paManifest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ImageModelImplToJson(_$ImageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'originalFilename': instance.originalFilename,
      'sanitizedFilename': instance.sanitizedFilename,
      'mimeType': instance.mimeType,
      'sizeBytes': instance.sizeBytes,
      'width': instance.width,
      'height': instance.height,
      'format': instance.format,
      'status': instance.status,
      'imagekitFileId': instance.imagekitFileId,
      'imagekitUrl': instance.imagekitUrl,
      'imagekitPath': instance.imagekitPath,
      'processedUrl': instance.processedUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'hasExif': instance.hasExif,
      'hasIptc': instance.hasIptc,
      'hasXmp': instance.hasXmp,
      'hasGps': instance.hasGps,
      'hasC2pa': instance.hasC2pa,
      'c2paVerified': instance.c2paVerified,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'metadata': instance.metadata,
      'c2paManifest': instance.c2paManifest,
    };

_$ImageMetadataModelImpl _$$ImageMetadataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ImageMetadataModelImpl(
      id: json['id'] as String,
      imageId: json['imageId'] as String,
      exifData: json['exifData'] as Map<String, dynamic>?,
      iptcData: json['iptcData'] as Map<String, dynamic>?,
      xmpData: json['xmpData'] as Map<String, dynamic>?,
      gpsData: json['gpsData'] as Map<String, dynamic>?,
      iccData: json['iccData'] as Map<String, dynamic>?,
      cameraModel: json['cameraModel'] as String?,
      cameraMake: json['cameraMake'] as String?,
      lensModel: json['lensModel'] as String?,
      software: json['software'] as String?,
      colorProfile: json['colorProfile'] as String?,
      focalLength: json['focalLength'] as String?,
      aperture: json['aperture'] as String?,
      shutterSpeed: json['shutterSpeed'] as String?,
      iso: json['iso'] as String?,
      capturedAt: json['capturedAt'] == null
          ? null
          : DateTime.parse(json['capturedAt'] as String),
      modifiedAt: json['modifiedAt'] == null
          ? null
          : DateTime.parse(json['modifiedAt'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      scannedAt: DateTime.parse(json['scannedAt'] as String),
    );

Map<String, dynamic> _$$ImageMetadataModelImplToJson(
        _$ImageMetadataModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageId': instance.imageId,
      'exifData': instance.exifData,
      'iptcData': instance.iptcData,
      'xmpData': instance.xmpData,
      'gpsData': instance.gpsData,
      'iccData': instance.iccData,
      'cameraModel': instance.cameraModel,
      'cameraMake': instance.cameraMake,
      'lensModel': instance.lensModel,
      'software': instance.software,
      'colorProfile': instance.colorProfile,
      'focalLength': instance.focalLength,
      'aperture': instance.aperture,
      'shutterSpeed': instance.shutterSpeed,
      'iso': instance.iso,
      'capturedAt': instance.capturedAt?.toIso8601String(),
      'modifiedAt': instance.modifiedAt?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'scannedAt': instance.scannedAt.toIso8601String(),
    };

_$C2paManifestModelImpl _$$C2paManifestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$C2paManifestModelImpl(
      id: json['id'] as String,
      imageId: json['imageId'] as String,
      isCustom: json['isCustom'] as bool? ?? false,
      isVerified: json['isVerified'] as bool?,
      creator: json['creator'] as String?,
      organization: json['organization'] as String?,
      website: json['website'] as String?,
      license: json['license'] as String?,
      copyright: json['copyright'] as String?,
      generator: json['generator'] as String?,
      aiModel: json['aiModel'] as String?,
      prompt: json['prompt'] as String?,
      negativePrompt: json['negativePrompt'] as String?,
      workflow: json['workflow'] as String?,
      source: json['source'] as String?,
      manifestJson: json['manifestJson'] as Map<String, dynamic>?,
      assertionsJson: json['assertionsJson'] as Map<String, dynamic>?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$C2paManifestModelImplToJson(
        _$C2paManifestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageId': instance.imageId,
      'isCustom': instance.isCustom,
      'isVerified': instance.isVerified,
      'creator': instance.creator,
      'organization': instance.organization,
      'website': instance.website,
      'license': instance.license,
      'copyright': instance.copyright,
      'generator': instance.generator,
      'aiModel': instance.aiModel,
      'prompt': instance.prompt,
      'negativePrompt': instance.negativePrompt,
      'workflow': instance.workflow,
      'source': instance.source,
      'manifestJson': instance.manifestJson,
      'assertionsJson': instance.assertionsJson,
      'timestamp': instance.timestamp?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$ImageHistoryModelImpl _$$ImageHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ImageHistoryModelImpl(
      id: json['id'] as String,
      imageId: json['imageId'] as String,
      action: json['action'] as String,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ImageHistoryModelImplToJson(
        _$ImageHistoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageId': instance.imageId,
      'action': instance.action,
      'description': instance.description,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$C2paTemplateModelImpl _$$C2paTemplateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$C2paTemplateModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      creator: json['creator'] as String?,
      organization: json['organization'] as String?,
      website: json['website'] as String?,
      license: json['license'] as String?,
      copyright: json['copyright'] as String?,
      generator: json['generator'] as String?,
      aiModel: json['aiModel'] as String?,
      workflow: json['workflow'] as String?,
      source: json['source'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$C2paTemplateModelImplToJson(
        _$C2paTemplateModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'creator': instance.creator,
      'organization': instance.organization,
      'website': instance.website,
      'license': instance.license,
      'copyright': instance.copyright,
      'generator': instance.generator,
      'aiModel': instance.aiModel,
      'workflow': instance.workflow,
      'source': instance.source,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
    };
