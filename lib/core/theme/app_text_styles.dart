import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Plus Jakarta Sans for Headlines
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.02,
  );

  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
  );

  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.02,
  );

  static TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  // Manrope for Body and Labels
  static TextStyle get titleMedium => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get bodyLarge => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyMedium => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodySmall => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get labelLarge => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
