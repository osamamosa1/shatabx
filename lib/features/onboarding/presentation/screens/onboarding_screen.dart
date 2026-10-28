import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const _pages = <_OnboardingPageData>[
    _OnboardingPageData(
      showLogo: true,
      lead: 'onb1_lead',
      highlight: 'onb1_highlight',
      body: 'onb1_body',
      button: 'next',
      art: _Art.projects,
    ),
    _OnboardingPageData(
      showLogo: false,
      lead: 'onb2_lead',
      highlight: 'onb2_highlight',
      body: 'onb2_body',
      button: 'next',
      art: _Art.tracking,
    ),
    _OnboardingPageData(
      showLogo: false,
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
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 18.h),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () => context.read<OnboardingCubit>().skip(),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.highlight,
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(context.tr('skip'), style: TextStyles.medium14(color: AppColors.primary)),
                    ),
                  ),
                  if (page.showLogo) ...[
                    SizedBox(height: 12.h),
                    const BrandLogo(size: 34),
                  ],
                  SizedBox(height: 18.h),
                  Expanded(child: _OnboardingArt(kind: page.art)),
                  SizedBox(height: 12.h),
                  _Title(lead: context.tr(page.lead), highlight: context.tr(page.highlight)),
                  SizedBox(height: 12.h),
                  Text(
                    context.tr(page.body),
                    textAlign: TextAlign.center,
                    style: TextStyles.regular14(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 18.h),
                  _Dots(count: _pages.length, index: index),
                  SizedBox(height: 18.h),
                  MyDefaultButton(
                    text: context.tr(page.button),
                    onPressed: () => context.read<OnboardingCubit>().next(_pages.length),
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
        Text(lead, style: TextStyles.bold22(color: AppColors.text)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: AppColors.highlight,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(highlight, style: TextStyles.bold22(color: AppColors.text)),
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
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: active ? 18.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.dotIdle,
            borderRadius: BorderRadius.circular(8.r),
          ),
        );
      }),
    );
  }
}

enum _Art { projects, tracking, quality }

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.showLogo,
    required this.lead,
    required this.highlight,
    required this.body,
    required this.button,
    required this.art,
  });

  final bool showLogo;
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppGradients.wash,
        borderRadius: BorderRadius.circular(28.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

