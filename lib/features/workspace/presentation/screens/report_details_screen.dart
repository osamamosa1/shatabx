import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../domain/entities/workspace_entities.dart';
import '../cubit/get_report_details_cubit.dart';

class ReportDetailsScreen extends StatefulWidget {
  const ReportDetailsScreen({super.key, required this.id});

  final String id;

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  final Map<int, String> _replies = {};

  @override
  void initState() {
    super.initState();
    context.read<GetReportDetailsCubit>().load(widget.id);
  }

  void _showReplySheet(BuildContext context, int index) {
    final controller = TextEditingController(text: _replies[index] ?? '');
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            16.h,
            20.w,
            MediaQuery.of(ctx).viewInsets.bottom + 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.tr('add_reply'),
                style: TextStyles.bold18(color: AppColors.text),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: context.tr('add_reply'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              MyDefaultButton(
                text: context.tr('confirm'),
                onPressed: () {
                  setState(() => _replies[index] = controller.text.trim());
                  Navigator.pop(ctx);
                  AppSnackBar.show(context, context.tr('reply_sent'));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final isEngineer =
        session is SessionAuthenticated &&
        session.user.role == AccountRole.engineer;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: BlocBuilder<GetReportDetailsCubit, GetReportDetailsState>(
        builder: (context, state) {
          if (state is GetReportDetailsLoading ||
              state is GetReportDetailsInitial) {
            return const LoadingView();
          }
          if (state is GetReportDetailsError) {
            return ErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<GetReportDetailsCubit>().load(widget.id),
            );
          }
          if (state is! GetReportDetailsLoaded) return const SizedBox.shrink();
          final report = state.report;

          final (bannerColor, bannerBorder, bannerText) = switch (
            report.statusType
          ) {
            ReportStatusType.approved => (
              AppColors.statusSuccessLight,
              AppColors.statusSuccess,
              report.notes.tr(context),
            ),
            ReportStatusType.pendingReview => (
              AppColors.statusWarningLight,
              AppColors.statusWarning,
              report.notes.tr(context),
            ),
            ReportStatusType.reinspect => (
              AppColors.statusErrorLight,
              AppColors.statusError,
              report.notes.tr(context),
            ),
          };

          return Column(
            children: [
              Container(
                color: AppColors.white,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          children: [
                            const AppBackButton(),
                            Expanded(
                              child: Text(
                                report.title.tr(context),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.bold16(color: AppColors.text),
                              ),
                            ),
                            SizedBox(width: 36.w),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        color: bannerColor,
                        child: Text(
                          bannerText,
                          textAlign: TextAlign.center,
                          style: TextStyles.medium12(color: bannerBorder),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  children: [
                    SoftRise(
                      child: Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              report.projectName.tr(context),
                              style: TextStyles.bold16(
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Text(
                                  report.engineerName?.tr(context) ?? '',
                                  style: TextStyles.medium12(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  report.dateLabel.tr(context),
                                  style: TextStyles.regular12(
                                    color: AppColors.hint,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      context.tr('handover_items'),
                      style: TextStyles.bold16(color: AppColors.text),
                    ),
                    SizedBox(height: 10.h),
                    ...List.generate(report.checklist.length, (i) {
                      final item = report.checklist[i];
                      final customReply = _replies[i];
                      final replyText = customReply ?? item.reply?.tr(context);

                      return SoftRise(
                        delay: Duration(milliseconds: 50 + (i * 40)),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                item.title.tr(context),
                                style: TextStyles.bold14(color: AppColors.text),
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                height: 34.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: item.compliant
                                      ? AppColors.statusSuccessLight
                                      : AppColors.statusErrorLight,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: item.compliant
                                        ? AppColors.statusSuccess
                                        : AppColors.statusError,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      item.compliant
                                          ? Icons.check_circle_outline_rounded
                                          : Icons.cancel_outlined,
                                      size: 18.r,
                                      color: item.compliant
                                          ? AppColors.statusSuccess
                                          : AppColors.statusError,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      item.compliant
                                          ? context.tr('compliant')
                                          : context.tr('non_compliant'),
                                      style: TextStyles.bold12(
                                        color: item.compliant
                                            ? AppColors.statusSuccess
                                            : AppColors.statusError,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (item.note != null) ...[
                                SizedBox(height: 10.h),
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    item.note!.tr(context),
                                    style: TextStyles.regular12(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                              if (item.images.isNotEmpty) ...[
                                SizedBox(height: 10.h),
                                Row(
                                  children: item.images.map((img) {
                                    return Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4.w,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          child: Image.asset(
                                            img,
                                            height: 76.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                              if (replyText != null && replyText.isNotEmpty) ...[
                                SizedBox(height: 10.h),
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySoft,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.tr('add_reply'),
                                        style: TextStyles.bold12(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        replyText,
                                        style: TextStyles.regular12(
                                          color: AppColors.text,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              if (!item.compliant) ...[
                                SizedBox(height: 10.h),
                                OutlinedButton.icon(
                                  onPressed: () => _showReplySheet(context, i),
                                  icon: Icon(
                                    Icons.add_comment_outlined,
                                    size: 16.r,
                                    color: AppColors.primary,
                                  ),
                                  label: Text(
                                    context.tr('add_reply'),
                                    style: TextStyles.medium12(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: SafeArea(
                  top: false,
                  child: isEngineer
                      ? MyDefaultButton(
                          text: context.tr('start_inspection'),
                          height: 48.h,
                          borderRadius: 16.r,
                          onPressed: () => context.push(
                            '${AppRoutes.inspectionRun}?project=${Uri.encodeComponent(report.projectName.tr(context))}&phase=${Uri.encodeComponent(report.phaseName?.tr(context) ?? '')}',
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: MyDefaultButton(
                                text: context.tr('approve_report'),
                                height: 48.h,
                                borderRadius: 14.r,
                                onPressed: () => AppSnackBar.show(
                                  context,
                                  context.tr('report_approved'),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: MyDefaultButton(
                                text: context.tr('request_reinspect'),
                                height: 48.h,
                                borderRadius: 14.r,
                                color: AppColors.statusErrorLight,
                                textColor: AppColors.statusError,
                                onPressed: () => AppSnackBar.show(
                                  context,
                                  context.tr('reinspect_sent'),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
