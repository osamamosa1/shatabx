import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          children: [
            const AppBackButton(),
            SizedBox(height: 12.h),
            Text(
              context.tr('terms'),
              textAlign: TextAlign.center,
              style: TextStyles.bold22(color: AppColors.text),
            ),
            SizedBox(height: 16.h),
            Text(
              context.tr('terms_body'),
              textAlign: TextAlign.start,
              style: TextStyles.regular16(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
