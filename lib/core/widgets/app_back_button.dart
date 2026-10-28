import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/values/app_colors.dart';
import '../utils/values/svg_manager.dart';
import 'app_svg.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: InkWell(
        onTap: onTap ?? () => Navigator.of(context).maybePop(),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 36.r,
          height: 36.r,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: AppSvg(
            rtl ? SvgAssets.arrowForward : SvgAssets.arrowBack,
            size: 18.r,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
