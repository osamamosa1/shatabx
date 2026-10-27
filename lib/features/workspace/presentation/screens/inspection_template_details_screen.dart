import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../cubit/get_inspection_template_details_cubit.dart';

class InspectionTemplateDetailsScreen extends StatefulWidget {
  const InspectionTemplateDetailsScreen({super.key, required this.id});

  final String id;

  @override
  State<InspectionTemplateDetailsScreen> createState() =>
      _InspectionTemplateDetailsScreenState();
}

class _InspectionTemplateDetailsScreenState extends State<InspectionTemplateDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetInspectionTemplateDetailsCubit>().load(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<GetInspectionTemplateDetailsCubit, GetInspectionTemplateDetailsState>(
          builder: (context, state) {
            if (state is GetInspectionTemplateDetailsLoading ||
                state is GetInspectionTemplateDetailsInitial) {
              return const LoadingView();
            }
            if (state is GetInspectionTemplateDetailsError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<GetInspectionTemplateDetailsCubit>().load(widget.id),
              );
            }
            if (state is! GetInspectionTemplateDetailsLoaded) return const SizedBox.shrink();
            final template = state.template;
            return ListView(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              children: [
                const AppBackButton(),
                SizedBox(height: 12.h),
                Text(template.name.tr(context), textAlign: TextAlign.start, style: TextStyles.bold22()),
                SizedBox(height: 6.h),
                Text(template.category.tr(context), textAlign: TextAlign.start, style: TextStyles.medium14(color: AppColors.primary)),
                SizedBox(height: 16.h),
                ...template.items.map(
                  (item) => Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(item.tr(context), textAlign: TextAlign.start, style: TextStyles.regular16()),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
