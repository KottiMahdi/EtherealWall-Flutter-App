import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFFAF9FE);
  static const Color primary = Color(0xFF2060A5);
  static const Color primaryContainer = Color(0xFF7DB3FD);
  static const Color primaryDim = Color(0xFF075498);

  static const Color onBackground = Color(0xFF2F323A);
  static const Color onSurface = Color(0xFF2F323A);
  static const Color onSurfaceVariant = Color(0xFF5C5F68);

  static const Color surfaceContainer = Color(0xFFECEDF6);
  static const Color surfaceContainerLow = Color(0xFFF3F3FA);
  static const Color surfaceContainerHigh = Color(0xFFE6E8F1);
  static const Color surfaceContainerHighest = Color(0xFFE0E2ED);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);

  static const Color outline = Color(0xFF787A84);
  static const Color outlineVariant = Color(0xFFAFB2BC);

  static const Color error = Color(0xFFA83836);

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
