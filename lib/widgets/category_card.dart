import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

class CategoryCard extends StatelessWidget {
  final String categoryCode;
  final String categoryName;
  final int projectCount;
  final VoidCallback onTap;
  final Color? customColor;
  final IconData? customIcon;

  const CategoryCard({
    super.key,
    required this.categoryCode,
    required this.categoryName,
    required this.projectCount,
    required this.onTap,
    this.customColor,
    this.customIcon,
  });

  Color _getCategoryColor() {
    if (customColor != null) return customColor!;

    switch (categoryCode) {
      case 'A':
        return const Color(0xFF6366F1); // Indigo
      case 'B':
        return const Color(0xFF8B5CF6); // Purple
      case 'C':
        return const Color(0xFF06B6D4); // Cyan
      case 'D':
        return const Color(0xFF10B981); // Green
      case 'E':
        return const Color(0xFFF59E0B); // Amber
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon() {
    if (customIcon != null) return customIcon!;

    switch (categoryCode) {
      case 'A':
        return Icons.festival_outlined;
      case 'B':
        return Icons.account_balance_outlined;
      case 'C':
        return Icons.location_city_outlined;
      case 'D':
        return Icons.route_outlined;
      case 'E':
        return Icons.work_outline;
      default:
        return Icons.folder_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: categoryColor,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(),
                      color: categoryColor,
                      size: 32,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: categoryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      categoryCode,
                      style: AppTextStyles.h5.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      categoryName,
                      style: AppTextStyles.h5.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$projectCount ${projectCount == 1 ? 'project' : 'projects'}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward_outlined,
                    color: categoryColor,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
