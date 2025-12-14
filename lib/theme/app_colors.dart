import 'package:flutter/material.dart';

class AppColors {
  // ============ PRIMARY COLORS ============
  static const Color primary = Color(0xFF18181B);        // Almost black
  static const Color primaryLight = Color(0xFF27272A);   // Dark gray
  static const Color primaryDark = Color(0xFF09090B);    // Pure black

  // ============ BACKGROUND COLORS ============
  static const Color background = Color(0xFFFFFFFF);     // Pure white
  static const Color backgroundAlt = Color(0xFFFAFAFA);  // Off-white
  static const Color surface = Color(0xFFF4F4F5);        // Light gray surface
  static const Color surfaceVariant = Color(0xFFE4E4E7); // Medium gray surface

  // ============ TEXT COLORS ============
  static const Color textPrimary = Color(0xFF18181B);    // Main text
  static const Color textSecondary = Color(0xFF71717A);  // Secondary text
  static const Color textTertiary = Color(0xFFA1A1AA);   // Placeholder/disabled
  static const Color textInverse = Color(0xFFFFFFFF);    // White text

  // ============ BORDER & DIVIDER ============
  static const Color border = Color(0xFFE4E4E7);         // Standard border
  static const Color borderStrong = Color(0xFFD4D4D8);   // Emphasized border
  static const Color borderLight = Color(0xFFF4F4F5);    // Subtle border
  static const Color divider = Color(0xFFE4E4E7);        // Divider lines

  // ============ INTERACTIVE STATES ============
  static const Color hover = Color(0xFFF4F4F5);          // Hover background
  static const Color active = Color(0xFFE4E4E7);         // Active/selected
  static const Color pressed = Color(0xFFD4D4D8);        // Pressed state
  static const Color focus = Color(0xFF18181B);          // Focus ring

  // ============ SEMANTIC COLORS ============
  // Success (Green)
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF047857);

  // Error (Red)
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFDC2626);

  // Warning (Orange/Yellow)
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFD97706);

  // Info (Blue)
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF2563EB);

  // ============ ACCENT (OPTIONAL) ============
  static const Color accent = Color(0xFFD97706);         // Claude orange
  static const Color accentLight = Color(0xFFFED7AA);
  static const Color accentDark = Color(0xFFC2410C);

  // ============ SPECIAL ============
  static const Color disabled = Color(0xFFA1A1AA);
  static const Color overlay = Color(0x1A000000);        // 10% black
  static const Color shadow = Color(0x0D000000);         // 5% black
}
