import 'dart:ui';

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
import '../../domain/params/auth_params.dart';
import '../cubit/select_join_method_cubit.dart';

class JoinMethodScreen extends StatelessWidget {
  const JoinMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ZoomIn(
            duration: const Duration(milliseconds: 900),
            from: 1.06,
            child: Image.asset(
              ImgAssets.joinBg,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.18),
                  const Color(0x9910133F),
                  const Color(0xBF10133F),
                ],
                stops: const [0.15, 0.45, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SoftDrop(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TapScale(
                        child: InkWell(
                          onTap: () => context.pop(),
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            width: 34.r,
                            height: 34.r,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.24),
                              ),
                            ),
                            child: AppSvg(
                              rtl
                                  ? SvgAssets.arrowForward
                                  : SvgAssets.arrowBack,
                              size: 16.r,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 90.h),
                  SoftSlideStart(
                    delay: const Duration(milliseconds: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8.w,
                          runSpacing: 6.h,
                          children: [
                            Text(
                              context.tr('join_title'),
                              style: TextStyles.bold24(color: AppColors.white),
                            ),
                            ElasticIn(
                              delay: const Duration(milliseconds: 220),
                              duration: const Duration(milliseconds: 700),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.brand2,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12.r),
                                    bottomLeft: Radius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  'Shatab X',
                                  style: TextStyles.poppins(
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          context.tr('join_sub'),
                          textAlign: TextAlign.start,
                          style: TextStyles.medium14(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  BlocBuilder<SelectJoinMethodCubit, SelectJoinMethodState>(
                    builder: (context, state) {
                      final selected = state is JoinMethodSelected
                          ? state.method
                          : JoinMethod.newCompany;
                      return Column(
                        children: [
                          SoftRise(
                            delay: const Duration(milliseconds: 140),
                            child: _JoinCard(
                              title: context.tr('new_company'),
                              lines: [
                                context.tr('new_company_l1'),
                                context.tr('new_company_l2'),
                              ],
                              imageAsset: ImgAssets.joinNewCompany,
                              selected: selected == JoinMethod.newCompany,
                              onTap: () {
                                context
                                    .read<SelectJoinMethodCubit>()
                                    .select(JoinMethod.newCompany);
                                context.push(AppRoutes.register);
                              },
                            ),
                          ),
                          SizedBox(height: 16.h),
                          SoftRise(
                            delay: const Duration(milliseconds: 240),
                            child: _JoinCard(
                              title: context.tr('registered_company'),
                              lines: [
                                context.tr('registered_company_l1'),
                                context.tr('registered_company_l2'),
                              ],
                              imageAsset: ImgAssets.joinRegisteredCompany,
                              selected:
                                  selected == JoinMethod.registeredCompany,
                              onTap: () {
                                context
                                    .read<SelectJoinMethodCubit>()
                                    .select(JoinMethod.registeredCompany);
                                context.push('${AppRoutes.login}?role=company');
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JoinCard extends StatelessWidget {
  const _JoinCard({
    required this.title,
    required this.lines,
    required this.imageAsset,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final List<String> lines;
  final String imageAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: selected ? 0.14 : 0.18),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: selected ? AppColors.primary : const Color(0xFFE9EBF1),
                width: 2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(24.r),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          FloatingMotion(
                            offset: 5,
                            child: Container(
                              width: 72.r,
                              height: 72.r,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.22),
                                    Colors.white.withValues(alpha: 0.10),
                                  ],
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                imageAsset,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyles.bold18(
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 6.h),
                                      child: Container(
                                        width: 4.r,
                                        height: 4.r,
                                        decoration: const BoxDecoration(
                                          color: AppColors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      child: Text(
                                        lines.join('\n'),
                                        textAlign: TextAlign.start,
                                        style: TextStyles.regular12(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (selected)
                        PositionedDirectional(
                          top: 0,
                          end: 0,
                          child: ZoomIn(
                            duration: const Duration(milliseconds: 320),
                            child: Icon(
                              Icons.verified_rounded,
                              color: AppColors.primaryLift,
                              size: 20.r,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
