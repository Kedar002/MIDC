# Flutter UI System - Claude.ai Design Language

## 🎯 Purpose
This is a **UI design system** based on Claude.ai's clean, professional aesthetic. Use these components to build **ANY** Flutter application with Claude's visual style - whether it's a todo app, e-commerce app, productivity tool, or anything else.

---

## 📋 Design Philosophy

### Core Principles
1. **Minimalism** - Clean, uncluttered interfaces
2. **Readability** - High contrast, clear typography
3. **Consistency** - Uniform spacing, colors, and components
4. **Professionalism** - Sophisticated monochrome palette
5. **Simplicity** - Intuitive, self-explanatory UI

### Visual Identity
- **Color Palette**: Monochrome (black, white, grays)
- **Typography**: System fonts, clear hierarchy
- **Spacing**: 8px grid system
- **Borders**: Subtle, 1px lines
- **Shadows**: Minimal to none
- **Corners**: Gentle radius (6-12px)

---

## 🎨 1. COLOR SYSTEM

```dart
// lib/core/theme/app_colors.dart
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
```

---

## 🔤 2. TYPOGRAPHY SYSTEM

```dart
// lib/core/theme/app_text_styles.dart
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
```

---

## 📐 3. SPACING SYSTEM

```dart
// lib/core/theme/app_spacing.dart
class AppSpacing {
  // ============ SPACING SCALE (8px base) ============
  static const double none = 0.0;
  static const double xxs = 2.0;   // 2px
  static const double xs = 4.0;    // 4px
  static const double sm = 8.0;    // 8px
  static const double md = 12.0;   // 12px
  static const double lg = 16.0;   // 16px
  static const double xl = 24.0;   // 24px
  static const double xxl = 32.0;  // 32px
  static const double xxxl = 48.0; // 48px
  static const double huge = 64.0; // 64px
  
  // ============ COMPONENT HEIGHTS ============
  static const double buttonHeight = 40.0;
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightLarge = 48.0;
  static const double inputHeight = 40.0;
  static const double inputHeightLarge = 48.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 60.0;
  static const double listItemHeight = 56.0;
  
  // ============ BORDER RADIUS ============
  static const double radiusNone = 0.0;
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusFull = 9999.0; // Pill shape
  
  // ============ ICON SIZES ============
  static const double iconXs = 14.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  static const double iconXxl = 48.0;
  
  // ============ CONTAINER MAX WIDTHS ============
  static const double containerSm = 640.0;
  static const double containerMd = 768.0;
  static const double containerLg = 1024.0;
  static const double containerXl = 1280.0;
  
  // ============ SHADOWS/ELEVATION ============
  static const double elevationNone = 0.0;
  static const double elevationSm = 1.0;
  static const double elevationMd = 2.0;
  static const double elevationLg = 4.0;
}
```

---

## 🎨 4. THEME CONFIGURATION

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    
    // ============ COLOR SCHEME ============
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.textSecondary,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
      onPrimary: AppColors.textInverse,
      onSecondary: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
      onError: AppColors.textInverse,
    ),
    
    scaffoldBackgroundColor: AppColors.background,
    
    // ============ APP BAR ============
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.h5,
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppSpacing.iconLg,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      surfaceTintColor: Colors.transparent,
    ),
    
    // ============ ELEVATED BUTTON (PRIMARY) ============
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        textStyle: AppTextStyles.button,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
      ),
    ),
    
    // ============ OUTLINED BUTTON (SECONDARY) ============
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        foregroundColor: AppColors.textPrimary,
        textStyle: AppTextStyles.button,
        side: const BorderSide(color: AppColors.border, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
      ),
    ),
    
    // ============ TEXT BUTTON (TERTIARY) ============
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    ),
    
    // ============ INPUT DECORATION ============
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.focus, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      hintStyle: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
      labelStyle: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
    ),
    
    // ============ CARD ============
    cardTheme: CardTheme(
      color: AppColors.background,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    
    // ============ DIVIDER ============
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    
    // ============ ICON THEME ============
    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: AppSpacing.iconMd,
    ),
    
    // ============ DIALOG ============
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.background,
      elevation: AppSpacing.elevationLg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      titleTextStyle: AppTextStyles.h4,
      contentTextStyle: AppTextStyles.body,
    ),
    
    // ============ BOTTOM SHEET ============
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.background,
      elevation: AppSpacing.elevationLg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
    ),
    
    // ============ SNACK BAR ============
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primary,
      contentTextStyle: AppTextStyles.body.copyWith(
        color: AppColors.textInverse,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
    ),
  );
}
```

---

## 🧩 5. REUSABLE COMPONENTS

### 5.1 Buttons

```dart
// lib/core/widgets/primary_button.dart
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final bool isSmall;

  const PrimaryButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: isSmall
          ? ElevatedButton.styleFrom(
              minimumSize: const Size(0, AppSpacing.buttonHeightSmall),
            )
          : null,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppSpacing.iconMd),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(label),
              ],
            ),
    );

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

// lib/core/widgets/secondary_button.dart
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final IconData? icon;
  final bool isSmall;

  const SecondaryButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.isFullWidth = false,
    this.icon,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button = OutlinedButton(
      onPressed: onPressed,
      style: isSmall
          ? OutlinedButton.styleFrom(
              minimumSize: const Size(0, AppSpacing.buttonHeightSmall),
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSpacing.iconMd),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(label),
        ],
      ),
    );

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
```

### 5.2 Text Input

```dart
// lib/core/widgets/app_text_field.dart
import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;

  const AppTextField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
```

### 5.3 Card

```dart
// lib/core/widgets/app_card.dart
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const AppCard({
    Key? key,
    this.title,
    required this.child,
    this.padding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(title!, style: AppTextStyles.h5),
            const SizedBox(height: AppSpacing.md),
          ],
          child,
        ],
      ),
    );

    if (onTap != null) {
      return Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: cardContent,
        ),
      );
    }

    return Card(child: cardContent);
  }
}
```

### 5.4 Drawer

```dart
// lib/core/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppDrawer extends StatelessWidget {
  final String? header;
  final List<DrawerItem> items;
  final List<DrawerItem>? bottomItems;

  const AppDrawer({
    Key? key,
    this.header,
    required this.items,
    this.bottomItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundAlt,
      child: Column(
        children: [
          // Header
          if (header != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  bottom: BorderSide(color: AppColors.divider, width: 1),
                ),
              ),
              child: Text(header!, style: AppTextStyles.h4),
            ),
          
          // Main Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              children: items.map((item) => _buildDrawerItem(item)).toList(),
            ),
          ),
          
          // Bottom Items
          if (bottomItems != null) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                children: bottomItems!.map((item) => _buildDrawerItem(item)).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDrawerItem(DrawerItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: item.isActive ? AppColors.active : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: AppSpacing.iconMd,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    item.title,
                    style: AppTextStyles.label,
                  ),
                ),
                if (item.trailing != null) item.trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  final Widget? trailing;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isActive = false,
    this.trailing,
  });
}
```

### 5.5 Alert Banners

```dart
// lib/core/widgets/alert_banner.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum AlertType { success, error, warning, info }

class AlertBanner extends StatelessWidget {
  final String message;
  final AlertType type;
  final VoidCallback? onDismiss;

  const AlertBanner({
    Key? key,
    required this.message,
    required this.type,
    this.onDismiss,
  }) : super(key: key);

  Color get backgroundColor {
    switch (type) {
      case AlertType.success:
        return AppColors.successLight;
      case AlertType.error:
        return AppColors.errorLight;
      case AlertType.warning:
        return AppColors.warningLight;
      case AlertType.info:
        return AppColors.infoLight;
    }
  }

  Color get textColor {
    switch (type) {
      case AlertType.success:
        return AppColors.successDark;
      case AlertType.error:
        return AppColors.errorDark;
      case AlertType.warning:
        return AppColors.warningDark;
      case AlertType.info:
        return AppColors.infoDark;
    }
  }

  IconData get icon {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body.copyWith(color: textColor),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: AppSpacing.md),
            IconButton(
              icon: const Icon(Icons.close),
              iconSize: AppSpacing.iconMd,
              color: textColor,
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}
```

### 5.6 List Items

```dart
// lib/core/widgets/list_item.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ListItem({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                Icon(leading, size: AppSpacing.iconLg, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(subtitle!, style: AppTextStyles.caption),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.md),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

### 5.7 Empty State

```dart
// lib/core/widgets/empty_state.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Widget? action;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                description!,
                style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
```

### 5.8 Loading Indicator

```dart
// lib/core/widgets/loading_indicator.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;

  const LoadingIndicator({
    Key? key,
    this.size,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 24,
        height: size ?? 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}
```

---

## 📱 6. LAYOUT TEMPLATES

### 6.1 App Scaffold with Drawer

```dart
// lib/core/widgets/app_scaffold.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;

  const AppScaffold({
    Key? key,
    this.title,
    required this.body,
    this.drawer,
    this.floatingActionButton,
    this.actions,
    this.showBackButton = true,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              actions: actions,
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
              bottom: bottom,
            )
          : null,
      drawer: drawer,
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
```

### 6.2 Responsive Container

```dart
// lib/core/widgets/responsive_container.dart
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.maxWidth = AppSpacing.containerLg,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          child: child,
        ),
      ),
    );
  }
}
```

---

## 📋 7. USAGE EXAMPLES

### Example 1: Simple Screen

```dart
import 'package:flutter/material.dart';
import '../core/widgets/app_scaffold.dart';
import '../core/widgets/primary_button.dart';
import '../core/widgets/app_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Home',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppCard(
              title: 'Welcome',
              child: Text('This uses Claude UI design system'),
            ),
            SizedBox(height: 16),
            PrimaryButton(
              label: 'Get Started',
              icon: Icons.arrow_forward,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
```

### Example 2: Form Screen

```dart
import 'package:flutter/material.dart';
import '../core/widgets/app_scaffold.dart';
import '../core/widgets/app_text_field.dart';
import '../core/widgets/primary_button.dart';
import '../core/theme/app_spacing.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Create Account',
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            AppTextField(
              label: 'Email',
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Password',
              hint: 'Enter password',
              obscureText: true,
            ),
            SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Sign Up',
              isFullWidth: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ✅ IMPLEMENTATION CHECKLIST

When building any app with this system:

- [ ] Import theme files in `main.dart`
- [ ] Apply `AppTheme.lightTheme` to MaterialApp
- [ ] Use `AppColors` for all colors
- [ ] Use `AppTextStyles` for all text
- [ ] Use `AppSpacing` for all spacing/sizing
- [ ] Use provided widgets (buttons, cards, etc.)
- [ ] Follow 8px spacing grid
- [ ] Keep borders subtle (1px, light gray)
- [ ] Maintain clean, minimal aesthetic
- [ ] Test on mobile and desktop

---

## 🎯 DESIGN PRINCIPLES SUMMARY

1. **Monochrome First** - Black/white/gray palette
2. **Subtle Borders** - 1px, light gray (#E4E4E7)
3. **Minimal Shadows** - Little to no elevation
4. **Clear Typography** - High contrast, readable
5. **Consistent Spacing** - 8px grid system
6. **Gentle Radius** - 6-12px rounded corners
7. **Clean Layout** - Lots of whitespace
8. **Professional Feel** - Sophisticated, not playful

This system gives you Claude.ai's clean aesthetic for **any app** - todo lists, e-commerce, dashboards, social media, etc.