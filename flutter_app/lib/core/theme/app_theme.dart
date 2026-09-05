import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
// App Color Palette
// ─────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Secondary
  static const Color secondary = Color(0xFF0F172A);

  // Semantic
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA5E9);

  // Dark Theme
  static const Color bgDark = Color(0xFF09090B);
  static const Color bgDarkCard = Color(0xFF111113);
  static const Color bgDarkSurface = Color(0xFF18181B);
  static const Color bgDarkElevated = Color(0xFF1E1E21);
  static const Color bgDarkBorder = Color(0xFF27272A);

  // Light Theme
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color bgLightCard = Color(0xFFFFFFFF);
  static const Color bgLightSurface = Color(0xFFF1F5F9);
  static const Color bgLightElevated = Color(0xFFE2E8F0);
  static const Color bgLightBorder = Color(0xFFE2E8F0);

  // Text (Dark)
  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFFA1A1AA);
  static const Color textTertiaryDark = Color(0xFF71717A);

  // Text (Light)
  static const Color textPrimaryLight = Color(0xFF09090B);
  static const Color textSecondaryLight = Color(0xFF52525B);
  static const Color textTertiaryLight = Color(0xFF71717A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBgGradient = LinearGradient(
    colors: [Color(0xFF09090B), Color(0xFF111113)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // C2PA Status Colors
  static const Color c2paVerified = Color(0xFF16A34A);
  static const Color c2paInvalid = Color(0xFFDC2626);
  static const Color c2paCustom = Color(0xFF2563EB);
  static const Color c2paNone = Color(0xFF71717A);
}

// ─────────────────────────────────────────────
// App Theme
// ─────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get dark => _buildTheme(isDark: true);
  static ThemeData get light => _buildTheme(isDark: false);

  static ThemeData _buildTheme({required bool isDark}) {
    final colorScheme = isDark ? _darkColorScheme : _lightColorScheme;
    final textTheme = _buildTextTheme(isDark: isDark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: GoogleFonts.inter().fontFamily,
      scaffoldBackgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      cardTheme: CardThemeData(
        color: isDark ? AppColors.bgDarkCard : AppColors.bgLightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? AppColors.bgDarkBorder : AppColors.bgLightBorder,
            width: 1,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.bgDarkSurface : AppColors.bgLightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.bgDarkBorder : AppColors.bgLightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.bgDarkBorder : AppColors.bgLightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        hintStyle: TextStyle(
          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: AppColors.primary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.bgDarkBorder : AppColors.bgLightBorder,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isDark ? AppColors.bgDarkElevated : AppColors.bgLightCard,
        contentTextStyle: TextStyle(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkElevated : AppColors.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ColorScheme get _darkColorScheme => ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.primaryLight,
        surface: AppColors.bgDarkSurface,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: AppColors.bgDarkCard,
        outline: AppColors.bgDarkBorder,
        error: AppColors.danger,
        onError: Colors.white,
      );

  static ColorScheme get _lightColorScheme => ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.primaryLight,
        surface: AppColors.bgLightSurface,
        onSurface: AppColors.textPrimaryLight,
        surfaceContainerHighest: AppColors.bgLightCard,
        outline: AppColors.bgLightBorder,
        error: AppColors.danger,
        onError: Colors.white,
      );

  static TextTheme _buildTextTheme({required bool isDark}) {
    final baseColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 57, fontWeight: FontWeight.w300, color: baseColor, letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45, fontWeight: FontWeight.w300, color: baseColor,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36, fontWeight: FontWeight.w400, color: baseColor,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32, fontWeight: FontWeight.w700, color: baseColor, letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28, fontWeight: FontWeight.w600, color: baseColor, letterSpacing: -0.3,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24, fontWeight: FontWeight.w600, color: baseColor,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22, fontWeight: FontWeight.w600, color: baseColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600, color: baseColor, letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w600, color: baseColor, letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400, color: baseColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, color: baseColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400, color: secondary,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w600, color: baseColor, letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w500, color: secondary, letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w500, color: secondary, letterSpacing: 0.5,
      ),
    );
  }
}
