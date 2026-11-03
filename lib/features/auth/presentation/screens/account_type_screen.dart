import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
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
        backgroundColor: const Color(0xFFFCFCFC),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 60.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SoftDrop(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 8.h),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF3F3F3),
                          width: 0.8,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SoftSlideStart(
                          child: Text(
                            context.tr('choose_account'),
                            textAlign: TextAlign.start,
                            style: TextStyles.bold24(color: AppColors.text),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SoftSlideStart(
                          delay: const Duration(milliseconds: 70),
                          child: Text(
                            context.tr('choose_account_sub'),
                            textAlign: TextAlign.start,
                            style: TextStyles.regular14(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                SoftSlideStart(
                  delay: const Duration(milliseconds: 120),
                  child: _TypeCard(
                    title: context.tr('company_type'),
                    subtitle: context.tr('company_type_sub'),
                    imageAsset: ImgAssets.accountCompany,
                    iconDelay: const Duration(milliseconds: 220),
                    onTap: () => context
                        .read<SelectAccountTypeCubit>()
                        .select(AccountRole.company),
                  ),
                ),
                SizedBox(height: 16.h),
                SoftSlideStart(
                  delay: const Duration(milliseconds: 220),
                  child: _TypeCard(
                    title: context.tr('engineer_type'),
                    subtitle: context.tr('engineer_type_sub'),
                    imageAsset: ImgAssets.accountEngineer,
                    iconDelay: const Duration(milliseconds: 320),
                    onTap: () => context
                        .read<SelectAccountTypeCubit>()
                        .select(AccountRole.engineer),
                  ),
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
    required this.imageAsset,
    required this.iconDelay,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String imageAsset;
  final Duration iconDelay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return TapScale(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  ZoomIn(
                    delay: iconDelay,
                    duration: const Duration(milliseconds: 520),
                    curve: Curves.easeOutBack,
                    child: FloatingMotion(
                      offset: 5,
                      child: Container(
                        width: 64.r,
                        height: 64.r,
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Image.asset(
                          imageAsset,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.start,
                          style: TextStyles.bold18(color: AppColors.primary),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          textAlign: TextAlign.start,
                          style: TextStyles.regular12(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  FadeIn(
                    delay: iconDelay,
                    child: AppSvg(
                      rtl ? SvgAssets.arrowBack : SvgAssets.arrowForward,
                      size: 18.r,
                      color: AppColors.textSecondary,
                    ),
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
