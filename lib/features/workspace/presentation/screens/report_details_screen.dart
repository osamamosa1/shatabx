import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../cubit/get_report_details_cubit.dart';

class ReportDetailsScreen extends StatefulWidget {
  const ReportDetailsScreen({super.key, required this.id});

  final String id;

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetReportDetailsCubit>().load(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<GetReportDetailsCubit, GetReportDetailsState>(
          builder: (context, state) {
            if (state is GetReportDetailsLoading || state is GetReportDetailsInitial) {
              return const LoadingView();
            }
            if (state is GetReportDetailsError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<GetReportDetailsCubit>().load(widget.id),
              );
            }
            if (state is! GetReportDetailsLoaded) return const SizedBox.shrink();
            final report = state.report;
            return ListView(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              children: [
                const AppBackButton(),
                SizedBox(height: 16.h),
                Text(report.title.tr(context), textAlign: TextAlign.start, style: TextStyles.bold22()),
                SizedBox(height: 8.h),
                Text(report.projectName.tr(context), textAlign: TextAlign.start, style: TextStyles.medium16(color: AppColors.primary)),
                SizedBox(height: 6.h),
                Text(report.dateLabel.tr(context), textAlign: TextAlign.start, style: TextStyles.regular14(color: AppColors.hint)),
                SizedBox(height: 16.h),
                Text(report.notes.tr(context), textAlign: TextAlign.start, style: TextStyles.regular16(color: AppColors.textSecondary)),
                SizedBox(height: 24.h),
                MyDefaultButton(
                  text: context.tr('approve_report'),
                  onPressed: () => AppSnackBar.show(context, context.tr('report_approved')),
                ),
                SizedBox(height: 10.h),
                MyDefaultButton(
                  text: context.tr('request_reinspect'),
                  color: AppColors.primarySoft,
                  textColor: AppColors.primary,
                  onPressed: () => AppSnackBar.show(context, context.tr('reinspect_sent')),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
