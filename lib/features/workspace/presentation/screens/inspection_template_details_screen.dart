import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_motion.dart';
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

class _InspectionTemplateDetailsScreenState
    extends State<InspectionTemplateDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetInspectionTemplateDetailsCubit>().load(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: BlocBuilder<
          GetInspectionTemplateDetailsCubit,
          GetInspectionTemplateDetailsState
        >(
          builder: (context, state) {
            if (state is GetInspectionTemplateDetailsLoading ||
                state is GetInspectionTemplateDetailsInitial) {
              return const LoadingView();
            }
            if (state is GetInspectionTemplateDetailsError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context
                    .read<GetInspectionTemplateDetailsCubit>()
                    .load(widget.id),
              );
            }
            if (state is! GetInspectionTemplateDetailsLoaded) {
              return const SizedBox.shrink();
            }
            final template = state.template;
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24.r),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14B8B8B8),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const AppBackButton(),
                      Expanded(
                        child: Text(
                          template.name.tr(context),
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
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
                    children: [
                      SoftDrop(
                        child: Container(
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.category_outlined,
                                color: AppColors.primary,
                                size: 20.r,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                template.category.tr(context),
                                style: TextStyles.bold14(
                                  color: AppColors.primary,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${template.items.length} ${context.tr('items_word')}',
                                style: TextStyles.medium12(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ...List.generate(template.items.length, (index) {
                        final item = template.items[index];
                        return SoftRise(
                          delay: Duration(milliseconds: 50 + (index * 40)),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.all(14.r),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: AppColors.border),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28.r,
                                  height: 28.r,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primarySoft,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyles.bold12(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    item.tr(context),
                                    style: TextStyles.medium14(
                                      color: AppColors.text,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: AppColors.statusSuccess,
                                  size: 20.r,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
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
