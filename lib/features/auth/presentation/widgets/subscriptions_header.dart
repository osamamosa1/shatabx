import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class SubscriptionsHeader extends StatelessWidget {
  const SubscriptionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final backSize = 36.r.clamp(32.0, 40.0);
    return Container(
      width: double.infinity,
      color: AppColors.primaryDark,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56.h.clamp(48.0, 64.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  },
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    width: backSize,
                    height: backSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: AppSvg(
                      Directionality.of(context) == TextDirection.rtl
                          ? SvgAssets.arrowForward
                          : SvgAssets.arrowBack,
                      size: 18.r.clamp(16.0, 20.0),
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    context.tr('subscriptions'),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bold16(color: AppColors.white),
                  ),
                ),
                SizedBox(width: backSize + 8.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
