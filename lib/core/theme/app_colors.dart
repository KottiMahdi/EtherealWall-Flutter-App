import 'package:flutter/material.dart';

class AppColors {
  // Common Colors
  static const Color primary = Color(0xFF2060A5);
  static const Color primaryContainer = Color(0xFF7DB3FD);
  static const Color error = Color(0xFFA83836);

  // Light Mode Palette
  static const Color backgroundLight = Color(0xFFFAF9FE);
  static const Color onBackgroundLight = Color(0xFF2F323A);
  static const Color surfaceLight = Color(0xFFFAF9FE);
  static const Color onSurfaceLight = Color(0xFF2F323A);
  static const Color onSurfaceVariantLight = Color(0xFF5C5F68);
  static const Color surfaceContainerLowestLight = Color(0xFFFFFFFF);

  // Dark Mode Palette
  static const Color backgroundDark = Color(0xFF0F1116);
  static const Color onBackgroundDark = Color(0xFFE2E2E6);
  static const Color surfaceDark = Color(0xFF14171D);
  static const Color onSurfaceDark = Color(0xFFE2E2E6);
  static const Color onSurfaceVariantDark = Color(0xFFC4C6D0);
  static const Color surfaceContainerLowestDark = Color(0xFF1C1F26);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> get editorialShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.06),
      blurRadius: 40,
      offset: const Offset(0, 20),
    ),
  ];
}
