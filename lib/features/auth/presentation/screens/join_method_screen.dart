import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../domain/params/auth_params.dart';
import '../cubit/select_join_method_cubit.dart';

class JoinMethodScreen extends StatelessWidget {
  const JoinMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.join,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBackButton(onTap: () => context.pop()),
                const Spacer(),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: context.tr('join_title'),
                        style: TextStyles.bold22(color: AppColors.white),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            'Shatab X',
                            style: TextStyles.poppins(size: 14, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Text(
                  context.tr('join_sub'),
                  textAlign: TextAlign.center,
                  style: TextStyles.regular14(color: AppColors.joinText),
                ),
                SizedBox(height: 22.h),
                BlocBuilder<SelectJoinMethodCubit, SelectJoinMethodState>(
                  builder: (context, state) {
                    final selected = state is JoinMethodSelected
                        ? state.method
                        : JoinMethod.newCompany;
                    return Column(
                      children: [
                        _JoinCard(
                          title: context.tr('new_company'),
                          lines: [
                            context.tr('new_company_l1'),
                            context.tr('new_company_l2'),
                          ],
                          selected: selected == JoinMethod.newCompany,
                          onTap: () {
                            context
                                .read<SelectJoinMethodCubit>()
                                .select(JoinMethod.newCompany);
                            context.push(AppRoutes.register);
                          },
                        ),
                        SizedBox(height: 12.h),
                        _JoinCard(
                          title: context.tr('registered_company'),
                          lines: [
                            context.tr('registered_company_l1'),
                            context.tr('registered_company_l2'),
                          ],
                          selected: selected == JoinMethod.registeredCompany,
                          onTap: () {
                            context
                                .read<SelectJoinMethodCubit>()
                                .select(JoinMethod.registeredCompany);
                            context.push('${AppRoutes.login}?role=company');
                          },
                        ),
                      ],
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JoinCard extends StatelessWidget {
  const _JoinCard({
    required this.title,
    required this.lines,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final List<String> lines;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.joinCardSelected : AppColors.joinCard,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: selected ? AppColors.joinLine : AppColors.joinLineIdle,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52.r,
                height: 52.r,
                decoration: BoxDecoration(
                  color: AppColors.joinIconWell,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.apartment_rounded, color: AppColors.joinIcon, size: 26.r),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyles.bold18(color: AppColors.white)),
                        if (selected) ...[
                          SizedBox(width: 6.w),
                          Icon(Icons.check_circle, color: AppColors.joinIcon, size: 16.r),
                        ],
                      ],
                    ),
                    ...lines.map(
                      (line) => Text(
                        '• $line',
                        textAlign: TextAlign.start,
                        style: TextStyles.regular12(color: AppColors.joinText),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
