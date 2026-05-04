import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.onSurfaceLight,
      onSurfaceVariant: AppColors.onSurfaceVariantLight,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      error: AppColors.error,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _textThemeWithColors(colorScheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: _cardTheme(AppColors.surfaceContainerLowestLight),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      onSurfaceVariant: AppColors.onSurfaceVariantDark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      error: AppColors.error,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _textThemeWithColors(colorScheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: _cardTheme(AppColors.surfaceContainerLowestDark),
    );
  }

  static TextTheme _textThemeWithColors(ColorScheme colorScheme) => TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: colorScheme.onSurface),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: colorScheme.onSurface),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: colorScheme.onSurface),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: colorScheme.onSurface),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: colorScheme.onSurface),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: colorScheme.onSurface),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: colorScheme.onSurface),
      );

  static CardThemeData _cardTheme(Color color) => CardThemeData(
        color: color,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      );
}
