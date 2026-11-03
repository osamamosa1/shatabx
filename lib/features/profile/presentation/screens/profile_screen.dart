import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return SoftZoom(
          child: Dialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56.r,
                  height: 56.r,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.statusErrorLight,
                    shape: BoxShape.circle,
                  ),
                  child: AppSvg(
                    SvgAssets.logout,
                    size: 26.r,
                    color: AppColors.error,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  context.tr('logout_confirm_title'),
                  style: TextStyles.bold18(color: AppColors.text),
                ),
                SizedBox(height: 6.h),
                Text(
                  context.tr('logout_confirm_sub'),
                  textAlign: TextAlign.center,
                  style: TextStyles.regular14(color: AppColors.textSecondary),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size.fromHeight(44.h),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          context.tr('cancel'),
                          style: TextStyles.medium14(color: AppColors.text),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await context.read<SessionCubit>().logout();
                          if (context.mounted) {
                            context.go(AppRoutes.accountType);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          minimumSize: Size.fromHeight(44.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          context.tr('logout'),
                          style: TextStyles.medium14(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ),
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

    final primaryGroup = isEngineer
        ? <_MenuItem>[
            _MenuItem(
              title: context.tr('personal_profile'),
              icon: SvgAssets.profile,
              onTap: () => context.push(AppRoutes.personalProfile),
            ),
          ]
        : <_MenuItem>[
            _MenuItem(
              title: context.tr('complete_profile_short'),
              icon: SvgAssets.profile,
              onTap: () => context.push(AppRoutes.completeProfile),
            ),
            _MenuItem(
              title: context.tr('manage_engineers'),
              icon: SvgAssets.engineer,
              onTap: () => context.push(AppRoutes.engineers),
            ),
            _MenuItem(
              title: context.tr('subscriptions'),
              icon: SvgAssets.company,
              onTap: () => context.push(AppRoutes.subscriptions),
            ),
            _MenuItem(
              title: context.tr('templates'),
              icon: SvgAssets.templates,
              onTap: () => context.push(AppRoutes.templates),
            ),
            _MenuItem(
              title: context.tr('manage_clients'),
              icon: SvgAssets.profile,
              onTap: () => context.push(AppRoutes.clients),
            ),
          ];

    final secondaryGroup = <_MenuItem>[
      _MenuItem(
        title: context.tr('settings'),
        icon: SvgAssets.settings,
        onTap: () => context.push(AppRoutes.settings),
      ),
      _MenuItem(
        title: context.tr('about_app'),
        icon: SvgAssets.aboutApp,
        onTap: () => context.push(AppRoutes.aboutApp),
      ),
      _MenuItem(
        title: context.tr('faq'),
        icon: SvgAssets.faq,
        onTap: () => context.push(AppRoutes.faq),
      ),
      _MenuItem(
        title: context.tr('terms'),
        icon: SvgAssets.terms,
        onTap: () => context.push(AppRoutes.terms),
      ),
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
                  context.tr('profile'),
                  textAlign: TextAlign.center,
                  style: TextStyles.bold18(color: AppColors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              children: [
                SoftRise(
                  delay: const Duration(milliseconds: 40),
                  child: _MenuSection(items: primaryGroup),
                ),
                SizedBox(height: 12.h),
                SoftRise(
                  delay: const Duration(milliseconds: 90),
                  child: _MenuSection(items: secondaryGroup),
                ),
                SizedBox(height: 12.h),
                SoftRise(
                  delay: const Duration(milliseconds: 140),
                  child: _MenuSection(
                    items: [
                      _MenuItem(
                        title: context.tr('logout'),
                        icon: SvgAssets.logout,
                        danger: true,
                        onTap: () => _confirmLogout(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.danger = false,
  });

  final String title;
  final String icon;
  final VoidCallback onTap;
  final bool danger;
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: Color(0x0A000000), blurRadius: 15),
        ],
      ),
          child: Column(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final color = item.danger
                  ? const Color(0xFFFF3B30)
                  : AppColors.text;
              return SoftSlideStart(
                delay: Duration(milliseconds: 50 + (i * 55)),
                child: Column(
                  children: [
                    TapScale(
                      child: InkWell(
                        onTap: item.onTap,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          child: Row(
                            children: [
                              AppSvg(item.icon, size: 20.r, color: color),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyles.medium14(color: color),
                                ),
                              ),
                              Container(
                                width: 32.r,
                                height: 32.r,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x0F000000),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: AppSvg(
                                  rtl
                                      ? SvgAssets.arrowBack
                                      : SvgAssets.arrowForward,
                                  size: 14.r,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (i < items.length - 1)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: const Divider(
                          height: 1,
                          color: Color(0xFFF3F3F3),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
    );
  }
}
