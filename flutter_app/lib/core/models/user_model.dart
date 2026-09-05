import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

// ─────────────────────────────────────────────
// User Model
// ─────────────────────────────────────────────
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String username,
    String? displayName,
    String? avatarUrl,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    UserSettingModel? settings,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// ─────────────────────────────────────────────
// User Settings Model
// ─────────────────────────────────────────────
@freezed
class UserSettingModel with _$UserSettingModel {
  const factory UserSettingModel({
    required String id,
    required String userId,
    @Default('dark') String theme,
    @Default('en') String language,
    @Default('balanced') String compressionDefault,
    @Default('jpeg') String exportFormat,
    @Default(true) bool autoScan,
    @Default(true) bool autoSave,
    @Default(50) int maxUploadSizeMb,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserSettingModel;

  factory UserSettingModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingModelFromJson(json);
}

// ─────────────────────────────────────────────
// Auth Tokens Model
// ─────────────────────────────────────────────
@freezed
class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
    required String expiresIn,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);
}
