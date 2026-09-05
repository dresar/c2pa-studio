// ─────────────────────────────────────────────
// App Constants
// ─────────────────────────────────────────────

class AppConstants {
  AppConstants._();

  // API
  static const String defaultApiUrl = 'http://localhost:3000/api/v1';
  static const int apiTimeoutSeconds = 30;
  static const int uploadTimeoutSeconds = 120;

  // App Info
  static const String appName = 'Image Provenance Studio';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Professional C2PA & Image Metadata Management';

  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyApiUrl = 'api_url';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyRememberLogin = 'remember_login';
  static const String keyUserEmail = 'user_email';
  static const String keyUserPassword = 'user_password';

  // Pagination
  static const int defaultPageSize = 20;
  static const int projectsPageSize = 20;
  static const int imagesPageSize = 20;
  static const int historyPageSize = 30;

  // Upload
  static const int maxFilesPerUpload = 10;
  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'webp', 'tiff', 'tif'];
  static const List<String> allowedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/tiff',
  ];

  // UI
  static const double sidebarWidthExpanded = 240.0;
  static const double sidebarWidthCollapsed = 64.0;
  static const double propertiesPanelWidth = 320.0;
  static const double imageListWidth = 280.0;
  static const double borderRadius = 16.0;
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;

  // Animation durations
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animMedium = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
}
