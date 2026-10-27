import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../domain/entities/project_entity.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, required this.onTap});

  final ProjectEntity project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = switch (project.status) {
      ProjectStatus.inProgress => context.tr('status_progress'),
      ProjectStatus.completed => context.tr('status_done'),
      ProjectStatus.onHold => context.tr('status_hold'),
    };
    final statusColor = switch (project.status) {
      ProjectStatus.inProgress => AppColors.primary,
      ProjectStatus.completed => AppColors.success,
      ProjectStatus.onHold => AppColors.warning,
    };
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.name.tr(context),
                      textAlign: TextAlign.start,
                      style: TextStyles.bold18(color: AppColors.text),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(status, style: TextStyles.regular12(color: statusColor)),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                project.location.tr(context),
                textAlign: TextAlign.start,
                style: TextStyles.regular12(color: AppColors.textSecondary),
              ),
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: LinearProgressIndicator(
                  value: project.progress,
                  minHeight: 8.h,
                  backgroundColor: AppColors.surface,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '${(project.progress * 100).round()}${context.isArabic ? '٪' : '%'}  •  ${project.phase.tr(context)}',
                textAlign: TextAlign.start,
                style: TextStyles.regular12(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
