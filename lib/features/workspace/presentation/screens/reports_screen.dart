import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../domain/entities/workspace_entities.dart';
import '../cubit/get_reports_cubit.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _query = '';
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<GetReportsCubit>().load();
  }

  List<ReportEntity> _filtered(List<ReportEntity> items, BuildContext ctx) {
    return items.where((r) {
      if (_tabIndex == 1 && r.statusType != ReportStatusType.approved) {
        return false;
      }
      if (_tabIndex == 2 && r.statusType != ReportStatusType.pendingReview) {
        return false;
      }
      if (_tabIndex == 3 && r.statusType != ReportStatusType.reinspect) {
        return false;
      }
      if (_query.trim().isEmpty) return true;
      final q = _query.trim().toLowerCase();
      return r.title.tr(ctx).toLowerCase().contains(q) ||
          r.projectName.tr(ctx).toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      context.tr('tab_all'),
      context.tr('tab_approved'),
      context.tr('tab_pending'),
      context.tr('tab_reinspect'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(18.r),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: SoftDrop(
                child: Text(
                  context.tr('reports'),
                  textAlign: TextAlign.center,
                  style: TextStyles.bold18(color: AppColors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<GetReportsCubit, GetReportsState>(
              builder: (context, state) {
                if (state is GetReportsLoading || state is GetReportsInitial) {
                  return const LoadingView();
                }
                if (state is GetReportsError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () => context.read<GetReportsCubit>().load(),
                  );
                }
                final raw = state is GetReportsLoaded
                    ? state.items
                    : <ReportEntity>[];
                final items = _filtered(raw, context);

                return ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  children: [
                    SoftRise(
                      delay: const Duration(milliseconds: 40),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 42.h,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: TextField(
                                onChanged: (v) => setState(() => _query = v),
                                style: TextStyles.regular12(
                                  color: AppColors.text,
                                ),
                                decoration: InputDecoration(
                                  hintText: context.tr('search_report'),
                                  hintStyle: TextStyles.regular12(
                                    color: const Color(0xFF666C6B),
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(11.r),
                                    child: AppSvg(SvgAssets.search, size: 18.r),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 40.r,
                            height: 40.r,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.purpleLight),
                            ),
                            child: AppSvg(SvgAssets.filter, size: 20.r),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    SoftRise(
                      delay: const Duration(milliseconds: 70),
                      child: Container(
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: List.generate(tabs.length, (i) {
                            final selected = _tabIndex == i;
                            return Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _tabIndex = i),
                                borderRadius: BorderRadius.circular(10.r),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: EdgeInsets.all(4.r),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    tabs[i],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.bold12(
                                      color: selected
                                          ? AppColors.white
                                          : AppColors.textSecondary,
                                    ).copyWith(fontSize: 11.sp),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    ...List.generate(items.length, (index) {
                      final report = items[index];
                      return SoftRise(
                        delay: Duration(milliseconds: 100 + (index * 45)),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _ReportCard(
                            report: report,
                            onTap: () => context.push('/reports/${report.id}'),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report, required this.onTap});

  final ReportEntity report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final (badgeBg, badgeBorder) = switch (report.statusType) {
      ReportStatusType.approved => (
        AppColors.statusSuccessLight,
        AppColors.statusSuccess,
      ),
      ReportStatusType.pendingReview => (
        AppColors.statusWarningLight,
        AppColors.statusWarning,
      ),
      ReportStatusType.reinspect => (
        AppColors.statusErrorLight,
        AppColors.statusError,
      ),
    };

    return TapScale(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38.r,
                      height: 38.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: AppSvg(
                        SvgAssets.reports,
                        size: 20.r,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.title.tr(context),
                            style: TextStyles.bold14(color: AppColors.text),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            report.projectName.tr(context),
                            style: TextStyles.regular12(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(color: badgeBorder),
                      ),
                      child: Text(
                        report.status.tr(context),
                        style: TextStyles.bold12(
                          color: badgeBorder,
                        ).copyWith(fontSize: 10.sp),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: const Divider(height: 1, color: AppColors.border),
                ),
                Row(
                  children: [
                    AppSvg(
                      SvgAssets.engineer,
                      size: 14.r,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      report.engineerName?.tr(context) ?? '',
                      style: TextStyles.regular12(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    AppSvg(
                      SvgAssets.clock,
                      size: 13.r,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      report.dateLabel.tr(context),
                      style: TextStyles.regular12(color: AppColors.hint),
                    ),
                    SizedBox(width: 8.w),
                    AppSvg(
                      rtl ? SvgAssets.arrowBack : SvgAssets.arrowForward,
                      size: 14.r,
                      color: AppColors.primary,
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
