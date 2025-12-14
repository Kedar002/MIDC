import 'package:flutter/material.dart';

class AppColors {
  // ============ PRIMARY COLORS ============
  static const Color primary = Color(0xFF3F3F46);        // Dark grey
  static const Color primaryLight = Color(0xFF52525B);   // Medium-dark grey
  static const Color primaryDark = Color(0xFF27272A);    // Very dark grey

  // ============ BACKGROUND COLORS ============
  static const Color background = Color(0xFFFFFFFF);     // Pure white
  static const Color backgroundAlt = Color(0xFFFAFAFA);  // Off-white
  static const Color surface = Color(0xFFF8FAFC);        // Slightly blue-tinted
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Light blue-gray

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
  static const Color hover = Color(0xFFF1F5F9);          // Hover background
  static const Color active = Color(0xFFE4E4E7);         // Active/selected (grey tint)
  static const Color pressed = Color(0xFFD4D4D8);        // Pressed state
  static const Color focus = Color(0xFF3F3F46);          // Focus ring (dark grey)

  // ============ SEMANTIC COLORS ============
  // Success (Emerald Green)
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF047857);

  // Error (Red)
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFDC2626);

  // Warning (Amber)
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFD97706);

  // Info (Grey)
  static const Color info = Color(0xFF52525B);
  static const Color infoLight = Color(0xFFE4E4E7);
  static const Color infoDark = Color(0xFF3F3F46);

  // ============ ACCENT COLORS ============
  static const Color accent = Color(0xFF52525B);         // Dark grey accent
  static const Color accentLight = Color(0xFFE4E4E7);
  static const Color accentDark = Color(0xFF3F3F46);

  // ============ CATEGORY COLORS (Vibrant) ============
  static const Color categoryA = Color(0xFF8B5CF6);      // Purple
  static const Color categoryB = Color(0xFF06B6D4);      // Cyan
  static const Color categoryC = Color(0xFFEC4899);      // Pink
  static const Color categoryD = Color(0xFFF59E0B);      // Amber
  static const Color categoryE = Color(0xFF10B981);      // Emerald
  static const Color categoryDefault = Color(0xFF71717A); // Gray

  // ============ ADDITIONAL ACCENT PALETTE ============
  static const Color accentGrey = Color(0xFF52525B);     // Grey
  static const Color accentPurple = Color(0xFF8B5CF6);   // Purple
  static const Color accentPink = Color(0xFFEC4899);     // Pink
  static const Color accentCyan = Color(0xFF06B6D4);     // Cyan
  static const Color accentEmerald = Color(0xFF10B981);  // Emerald
  static const Color accentAmber = Color(0xFFF59E0B);    // Amber

  // ============ SPECIAL ============
  static const Color disabled = Color(0xFFA1A1AA);
  static const Color overlay = Color(0x1A000000);        // 10% black
  static const Color shadow = Color(0x0D000000);         // 5% black
  static const Color surfaceHover = Color(0xFFE4E4E7);
}
