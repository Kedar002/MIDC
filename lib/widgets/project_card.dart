import 'package:flutter/material.dart';
import '../models/project.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.getCategoryColor(project.category),
                          AppTheme.getCategoryColor(project.category).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.getCategoryColor(project.category).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Category ${project.category}',
                      style: AppTextStyles.captionSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textInverse,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.getStatusColor(project.status).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(
                        color: AppTheme.getStatusColor(project.status).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.getStatusColor(project.status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          project.status,
                          style: AppTextStyles.captionSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.getStatusColor(project.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.xxs),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.getCategoryColor(project.category).withOpacity(0.1),
                          AppTheme.getCategoryColor(project.category).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: AppTheme.getCategoryColor(project.category).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${project.srNo}',
                        style: AppTextStyles.h6.copyWith(
                          color: AppTheme.getCategoryColor(project.category),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: AppTextStyles.h6,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (project.description != null) ...[
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            project.description!,
                            style: AppTextStyles.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          project.categoryName,
                          style: AppTextStyles.captionSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Progress',
                          style: AppTextStyles.captionSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                                child: LinearProgressIndicator(
                                  value: project.overallProgress / 100,
                                  backgroundColor: AppTheme.getCategoryColor(project.category).withOpacity(0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.getCategoryColor(project.category),
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '${project.overallProgress}%',
                              style: AppTextStyles.captionSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
