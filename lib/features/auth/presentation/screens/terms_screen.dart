import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_svg.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                      context.tr('terms'),
                      textAlign: TextAlign.center,
                      style: TextStyles.bold18(color: AppColors.text),
                    ),
                  ),
                  SizedBox(width: 36.w),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
                children: [
                  SoftZoom(
                    child: Center(
                      child: Image.asset(
                        ImgAssets.onboardingReport,
                        height: 96.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SoftRise(
                    delay: const Duration(milliseconds: 50),
                    child: Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              AppSvg(
                                SvgAssets.terms,
                                size: 20.r,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  context.tr('terms_header'),
                                  style: TextStyles.bold16(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          const Divider(color: AppColors.border, height: 1),
                          SizedBox(height: 14.h),
                          Text(
                            context.tr('terms_body'),
                            textAlign: TextAlign.start,
                            style: TextStyles.regular14(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
