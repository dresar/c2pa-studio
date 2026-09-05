// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      settings: json['settings'] == null
          ? null
          : UserSettingModel.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'settings': instance.settings,
    };

_$UserSettingModelImpl _$$UserSettingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSettingModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      theme: json['theme'] as String? ?? 'dark',
      language: json['language'] as String? ?? 'en',
      compressionDefault: json['compressionDefault'] as String? ?? 'balanced',
      exportFormat: json['exportFormat'] as String? ?? 'jpeg',
      autoScan: json['autoScan'] as bool? ?? true,
      autoSave: json['autoSave'] as bool? ?? true,
      maxUploadSizeMb: (json['maxUploadSizeMb'] as num?)?.toInt() ?? 50,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserSettingModelImplToJson(
        _$UserSettingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'theme': instance.theme,
      'language': instance.language,
      'compressionDefault': instance.compressionDefault,
      'exportFormat': instance.exportFormat,
      'autoScan': instance.autoScan,
      'autoSave': instance.autoSave,
      'maxUploadSizeMb': instance.maxUploadSizeMb,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$AuthTokensImpl _$$AuthTokensImplFromJson(Map<String, dynamic> json) =>
    _$AuthTokensImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as String,
    );

Map<String, dynamic> _$$AuthTokensImplToJson(_$AuthTokensImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };
