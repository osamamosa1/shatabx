import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/values/app_colors.dart';
import '../utils/values/text_styles.dart';
import 'app_motion.dart';

class MyDefaultButton extends StatelessWidget {
  const MyDefaultButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.color,
    this.textColor,
    this.height,
    this.borderRadius,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final active = enabled && !isLoading && onPressed != null;
    return TapScale(
      scale: active ? 0.96 : 1.0,
      child: SizedBox(
        width: double.infinity,
        height: height ?? 52.h,
        child: ElevatedButton(
          onPressed: active ? onPressed : null,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: color ?? AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.45),
            foregroundColor: textColor ?? AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: isLoading
                ? SizedBox(
                    key: const ValueKey('loading'),
                    width: 22.r,
                    height: 22.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: AppColors.white,
                    ),
                  )
                : Text(
                    text,
                    key: ValueKey(text),
                    style: TextStyles.medium16(
                      color: textColor ?? AppColors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
