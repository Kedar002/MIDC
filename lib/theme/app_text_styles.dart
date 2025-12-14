import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // ============ FONT CONFIGURATION ============
  static const String fontFamily = '-apple-system'; // System font

  // ============ DISPLAY (Extra Large Headlines) ============
  static TextStyle get display1 => const TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -1.0,
  );

  static TextStyle get display2 => const TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.8,
  );

  // ============ HEADINGS ============
  static TextStyle get h1 => const TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.5,
  );

  static TextStyle get h2 => const TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.4,
  );

  static TextStyle get h3 => const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: -0.3,
  );

  static TextStyle get h4 => const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: -0.2,
  );

  static TextStyle get h5 => const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get h6 => const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ============ BODY TEXT ============
  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static TextStyle get body => const TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // ============ LABELS ============
  static TextStyle get label => const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  // ============ CAPTIONS ============
  static TextStyle get caption => const TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle get captionSmall => const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ============ OVERLINE (Small Uppercase Text) ============
  static TextStyle get overline => const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.3,
    letterSpacing: 1.2,
  );

  // ============ BUTTON TEXT ============
  static TextStyle get button => const TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.2,
  );

  static TextStyle get buttonSmall => const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.2,
  );

  // ============ LINK TEXT ============
  static TextStyle get link => const TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.6,
    decoration: TextDecoration.underline,
  );

  // ============ CODE/MONOSPACE ============
  static TextStyle get code => const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'monospace',
    color: AppColors.textPrimary,
    height: 1.5,
  );
}
