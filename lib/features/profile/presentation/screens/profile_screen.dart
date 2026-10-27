import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../language/presentation/cubit/locale_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final user = session is SessionAuthenticated ? session.user : null;
    final locale = context.watch<LocaleCubit>().state.locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
          children: [
            Text(context.tr('profile'), textAlign: TextAlign.center, style: TextStyles.bold22()),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32.r,
                    backgroundColor: AppColors.primarySoft,
                    child: Icon(Icons.person, color: AppColors.primary, size: 30.r),
                  ),
                  SizedBox(height: 8.h),
                  Text(user?.displayName ?? context.tr('visitor'), style: TextStyles.bold18()),
                  Text(user?.email ?? '', style: TextStyles.regular14(color: AppColors.textSecondary)),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            _Tile(
              title: context.tr('complete_profile_short'),
              onTap: () => context.push(AppRoutes.completeProfile),
            ),
            _Tile(
              title: context.tr('templates'),
              onTap: () => context.push(AppRoutes.templates),
            ),
            _Tile(
              title: context.tr('notifications'),
              onTap: () => context.push(AppRoutes.notifications),
            ),
            _Tile(
              title: context.tr('terms'),
              onTap: () => context.push(AppRoutes.terms),
            ),
            _Tile(
              title: '${context.tr('language')}: ${locale == 'ar' ? context.tr('arabic') : context.tr('english')}',
              onTap: () => context.read<LocaleCubit>().setLocale(locale == 'ar' ? 'en' : 'ar'),
            ),
            _Tile(
              title: context.tr('logout'),
              danger: true,
              onTap: () async {
                await context.read<SessionCubit>().logout();
                if (context.mounted) context.go(AppRoutes.accountType);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.title, required this.onTap, this.danger = false});

  final String title;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: TextStyles.medium16(color: danger ? AppColors.error : AppColors.text),
                  ),
                ),
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  size: 20.r,
                  color: AppColors.hint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
