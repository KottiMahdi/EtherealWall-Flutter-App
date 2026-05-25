import 'package:flutter/material.dart';

class AppColors {
  // Icon-derived Palette (sky, greens, sun)
  // Sky / primary cyan (used as primary color)
  static const Color primary = Color(0xFF33E7E0); // aqua-cyan
  // Lighter container tint for accents
  static const Color primaryContainer = Color(0xFF9FF1ED);
  // Warm sun accent
  static const Color sun = Color(0xFFF7B24C);
  static const Color error = Color(0xFFA83836);

  // Light Mode Palette
  static const Color backgroundLight = Color(0xFFEFFDFC); // very light cyan
  static const Color onBackgroundLight = Color(
    0xFF052A28,
  ); // deep teal for text
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF052A28);
  static const Color onSurfaceVariantLight = Color(0xFF4C6B65);
  static const Color surfaceContainerLowestLight = Color(0xFFF7FFFE);

  // Dark Mode Palette
  static const Color backgroundDark = Color(0xFF001F20); // deep teal/near-black
  static const Color onBackgroundDark = Color(0xFFE7FBFA);
  static const Color surfaceDark = Color(0xFF042827);
  static const Color onSurfaceDark = Color(0xFFE7FBFA);
  static const Color onSurfaceVariantDark = Color(0xFF98CFC6);
  static const Color surfaceContainerLowestDark = Color(0xFF072A28);

  // Greens from the hills in the icon
  static const Color hillLight = Color(0xFF00D86A);
  static const Color hillDark = Color(0xFF00A46B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, hillLight],
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
