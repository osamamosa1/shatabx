import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../cubit/get_project_details_cubit.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key, required this.id});

  final String id;

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetProjectDetailsCubit>().load(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<GetProjectDetailsCubit, GetProjectDetailsState>(
          builder: (context, state) {
            if (state is GetProjectDetailsLoading || state is GetProjectDetailsInitial) {
              return const LoadingView();
            }
            if (state is GetProjectDetailsError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<GetProjectDetailsCubit>().load(widget.id),
              );
            }
            if (state is! GetProjectDetailsLoaded) return const SizedBox.shrink();
            final project = state.project;
            return ListView(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              children: [
                const AppBackButton(),
                SizedBox(height: 16.h),
                Text(project.name.tr(context), textAlign: TextAlign.start, style: TextStyles.bold24()),
                SizedBox(height: 6.h),
                Text(project.location.tr(context), textAlign: TextAlign.start, style: TextStyles.regular14(color: AppColors.textSecondary)),
                SizedBox(height: 18.h),
                _RowInfo(context.tr('phase'), project.phase.tr(context)),
                _RowInfo(context.tr('engineer'), project.engineer.tr(context)),
                _RowInfo(
                  context.tr('progress'),
                  '${(project.progress * 100).round()}${context.isArabic ? '٪' : '%'}',
                ),
                SizedBox(height: 20.h),
                MyDefaultButton(
                  text: context.tr('view_reports'),
                  onPressed: () => context.go(AppRoutes.reports),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RowInfo extends StatelessWidget {
  const _RowInfo(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Text(value, style: TextStyles.medium16(color: AppColors.text)),
          const Spacer(),
          Text(label, style: TextStyles.regular14(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
