import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<GetReportsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(context.tr('reports'), style: TextStyles.bold20()),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: BlocBuilder<GetReportsCubit, GetReportsState>(
        builder: (context, state) {
          if (state is GetReportsLoading || state is GetReportsInitial) {
            return const LoadingView();
          }
          if (state is GetReportsError) {
            return ErrorView(message: state.message, onRetry: () => context.read<GetReportsCubit>().load());
          }
          final items = state is GetReportsLoaded ? state.items : <ReportEntity>[];
          return ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: items.length,
            separatorBuilder: (_, _) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final report = items[index];
              return Material(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
                child: InkWell(
                  onTap: () => context.push('/reports/${report.id}'),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding: EdgeInsets.all(14.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(report.title.tr(context), style: TextStyles.bold18()),
                        SizedBox(height: 4.h),
                        Text(report.projectName.tr(context), style: TextStyles.regular14(color: AppColors.textSecondary)),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(report.dateLabel.tr(context), style: TextStyles.regular12(color: AppColors.hint)),
                            const Spacer(),
                            Text(report.status.tr(context), style: TextStyles.medium14(color: AppColors.primary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
