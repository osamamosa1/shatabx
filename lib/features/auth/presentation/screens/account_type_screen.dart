import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/select_account_type_cubit.dart';

class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectAccountTypeCubit, SelectAccountTypeState>(
      listener: (context, state) {
        if (state is! AccountTypeSelected) return;
        if (state.role == AccountRole.company) {
          context.push(AppRoutes.joinMethod);
        } else {
          context.push('${AppRoutes.login}?role=engineer');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 48.h, 24.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.tr('choose_account'),
                  textAlign: TextAlign.center,
                  style: TextStyles.bold24(color: AppColors.text),
                ),
                SizedBox(height: 8.h),
                Text(
                  context.tr('choose_account_sub'),
                  textAlign: TextAlign.center,
                  style: TextStyles.regular14(color: AppColors.textSecondary),
                ),
                SizedBox(height: 36.h),
                _TypeCard(
                  title: context.tr('company_type'),
                  subtitle: context.tr('company_type_sub'),
                  icon: SvgAssets.company,
                  onTap: () => context
                      .read<SelectAccountTypeCubit>()
                      .select(AccountRole.company),
                ),
                SizedBox(height: 14.h),
                _TypeCard(
                  title: context.tr('engineer_type'),
                  subtitle: context.tr('engineer_type_sub'),
                  icon: SvgAssets.engineer,
                  onTap: () => context
                      .read<SelectAccountTypeCubit>()
                      .select(AccountRole.engineer),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AppSvg(icon, color: AppColors.primary, size: 30.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyles.bold18(color: AppColors.primary)),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      textAlign: TextAlign.start,
                      style: TextStyles.regular12(color: AppColors.textSecondary),
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
