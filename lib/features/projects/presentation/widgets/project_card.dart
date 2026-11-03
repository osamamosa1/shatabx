import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../domain/entities/project_entity.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.isEngineerView = false,
  });

  final ProjectEntity project;
  final VoidCallback onTap;
  final bool isEngineerView;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final (statusLabel, badgeBg, badgeBorder) = switch (project.status) {
      ProjectStatus.started => (
        context.tr('status_started'),
        AppColors.statusInfoLight,
        AppColors.statusInfo,
      ),
      ProjectStatus.inProgress => (
        context.tr('status_progress'),
        AppColors.statusWarningLight,
        AppColors.statusWarning,
      ),
      ProjectStatus.delayed => (
        context.tr('status_delayed'),
        AppColors.statusErrorLight,
        AppColors.statusError,
      ),
      ProjectStatus.completed => (
        context.tr('status_done'),
        AppColors.statusSuccessLight,
        AppColors.statusSuccess,
      ),
      ProjectStatus.onHold => (
        context.tr('status_hold'),
        AppColors.statusWarningLight,
        AppColors.statusWarning,
      ),
    };

    final percentageInt = (project.progress * 100).round();
    final thumbAsset = project.imageAsset ?? ImgAssets.projectSa;
    final lastUpdatedText =
        project.lastUpdated?.tr(context) ??
        (context.isArabic ? 'آخر تحديث قبل 3 أيام' : 'Updated 3 days ago');

    return TapScale(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFF3F3F3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(14.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ZoomIn(
                        duration: const Duration(milliseconds: 460),
                        from: 0.9,
                        child: Container(
                          width: 64.r,
                          height: 64.r,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFFE9E9E9)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            thumbAsset,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    project.name.tr(context),
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.bold14(
                                      color: AppColors.text,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                ZoomIn(
                                  delay: const Duration(milliseconds: 120),
                                  duration: const Duration(milliseconds: 420),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: badgeBg,
                                      borderRadius: BorderRadius.circular(
                                        100.r,
                                      ),
                                      border: Border.all(color: badgeBorder),
                                    ),
                                    child: Text(
                                      statusLabel,
                                      style: TextStyles.bold12(
                                        color: badgeBorder,
                                      ).copyWith(fontSize: 10.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                AppSvg(
                                  SvgAssets.location,
                                  size: 13.r,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    project.location.tr(context),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.regular12(
                                      color: AppColors.textSecondary,
                                    ).copyWith(fontSize: 11.sp),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                AppSvg(
                                  isEngineerView
                                      ? SvgAssets.projects
                                      : SvgAssets.engineer,
                                  size: 13.r,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    isEngineerView
                                        ? '${context.tr('phase')} ${project.phase.tr(context)}'
                                        : '${context.tr('responsible')} ${project.engineer.tr(context)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.regular12(
                                      color: AppColors.textSecondary,
                                    ).copyWith(fontSize: 10.sp),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                AppSvg(
                                  SvgAssets.clock,
                                  size: 12.r,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  lastUpdatedText,
                                  style: TextStyles.regular12(
                                    color: AppColors.textSecondary,
                                  ).copyWith(fontSize: 10.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: const Divider(height: 1, color: Color(0xFFE9E9E9)),
                  ),
                  Row(
                    children: [
                      AppSvg(
                        SvgAssets.templates,
                        size: 14.r,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          project.phase.tr(context),
                          style: TextStyles.medium12(
                            color: const Color(0xFF595659),
                          ).copyWith(fontSize: 11.sp),
                        ),
                      ),
                      AnimatedCount(
                        value: percentageInt,
                        suffix: '%',
                        style: TextStyles.bold12(color: AppColors.primary),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  AnimatedProgressBar(
                    value: project.progress,
                    height: 8.h,
                    color: AppColors.progressBlue,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Text(
                        context.tr('view_details'),
                        style: TextStyles.medium12(color: AppColors.text),
                      ),
                      const Spacer(),
                      AppSvg(
                        rtl ? SvgAssets.arrowBack : SvgAssets.arrowForward,
                        size: 16.r,
                        color: AppColors.text,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
