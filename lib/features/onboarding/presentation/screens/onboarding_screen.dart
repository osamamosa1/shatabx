import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const _pages = <_OnboardingPageData>[
    _OnboardingPageData(
      lead: 'onb1_lead',
      highlight: 'onb1_highlight',
      body: 'onb1_body',
      button: 'next',
      art: _Art.projects,
    ),
    _OnboardingPageData(
      lead: 'onb2_lead',
      highlight: 'onb2_highlight',
      body: 'onb2_body',
      button: 'next',
      art: _Art.tracking,
    ),
    _OnboardingPageData(
      lead: 'onb3_lead',
      highlight: 'onb3_highlight',
      body: 'onb3_body',
      button: 'start_now',
      art: _Art.quality,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingFinished) context.go(AppRoutes.accountType);
      },
      builder: (context, state) {
        final index = state is OnboardingPage ? state.index : 0;
        final page = _pages[index];
        return Scaffold(
          backgroundColor: const Color(0xFFFCFCFC),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              child: Column(
                children: [
                  SoftDrop(
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TapScale(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(100.r),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0F000000),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () =>
                                context.read<OnboardingCubit>().skip(),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 7.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                            ),
                            child: Text(
                              context.tr('skip'),
                              style: TextStyles.medium12(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: ZoomIn(
                      key: ValueKey('art-$index'),
                      duration: const Duration(milliseconds: 560),
                      from: 0.86,
                      curve: Curves.easeOutBack,
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        from: 24,
                        child: FloatingMotion(
                          offset: 10,
                          child: _OnboardingArt(kind: page.art),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SoftSlideStart(
                    key: ValueKey('title-$index'),
                    delay: const Duration(milliseconds: 80),
                    child: _Title(
                      lead: context.tr(page.lead),
                      highlight: context.tr(page.highlight),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  FadeInUp(
                    key: ValueKey('body-$index'),
                    delay: const Duration(milliseconds: 160),
                    duration: const Duration(milliseconds: 480),
                    from: 18,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        context.tr(page.body),
                        textAlign: TextAlign.center,
                        style: TextStyles.regular14(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 22.h),
                  _Dots(count: _pages.length, index: index),
                  SizedBox(height: 20.h),
                  FadeInUp(
                    key: ValueKey('btn-$index'),
                    delay: const Duration(milliseconds: 220),
                    duration: const Duration(milliseconds: 480),
                    from: 18,
                    child: MyDefaultButton(
                      text: context.tr(page.button),
                      borderRadius: 16.r,
                      height: 48.h,
                      onPressed: () =>
                          context.read<OnboardingCubit>().next(_pages.length),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.lead, required this.highlight});

  final String lead;
  final String highlight;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6.w,
      children: [
        Text(lead, style: TextStyles.bold24(color: AppColors.text)),
        ElasticIn(
          delay: const Duration(milliseconds: 180),
          duration: const Duration(milliseconds: 680),
          child: Transform.rotate(
            angle: -4.06 * math.pi / 180,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.brand2,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                highlight,
                style: TextStyles.bold22(color: AppColors.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: active ? 20.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.brand2,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}

enum _Art { projects, tracking, quality }

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.lead,
    required this.highlight,
    required this.body,
    required this.button,
    required this.art,
  });

  final String lead;
  final String highlight;
  final String body;
  final String button;
  final _Art art;
}

class _OnboardingArt extends StatelessWidget {
  const _OnboardingArt({required this.kind});

  final _Art kind;

  @override
  Widget build(BuildContext context) {
    final asset = switch (kind) {
      _Art.projects => ImgAssets.onboarding1,
      _Art.tracking => ImgAssets.onboarding2,
      _Art.quality => ImgAssets.onboarding3,
    };
    return SizedBox(
      width: double.infinity,
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
