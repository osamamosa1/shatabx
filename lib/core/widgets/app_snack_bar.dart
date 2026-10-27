import 'package:flutter/material.dart';

import '../utils/values/app_colors.dart';
import '../utils/values/text_styles.dart';

abstract class AppSnackBar {
  static void show(BuildContext context, String message, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyles.medium14(color: AppColors.white),
          ),
          backgroundColor: error ? AppColors.error : AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
