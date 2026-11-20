import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/my_default_button.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final iconSize = 88.r.clamp(64.0, 96.0);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 16.h),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 16.h,
                      ),
                      child: Column(
                        children: [
                          SoftRise(
                            child: Container(
                              width: iconSize,
                              height: iconSize,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: AppColors.statusInfoLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.hourglass_top_rounded,
                                size: (iconSize * 0.48).clamp(28.0, 46.0),
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          SoftRise(
                            child: Text(
                              context.tr('pending_approval_title'),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyles.bold22(color: AppColors.text),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          SoftRise(
                            delay: const Duration(milliseconds: 60),
                            child: Text(
                              context.tr('pending_approval_sub'),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyles.regular14(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          if (email != null && email!.isNotEmpty) ...[
                            SizedBox(height: 16.h),
                            SoftRise(
                              delay: const Duration(milliseconds: 100),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(14.r),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Text(
                                  email!,
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: TextStyles.bold14(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h + bottomInset),
              child: MyDefaultButton(
                text: context.tr('go_to_login'),
                height: 48.h.clamp(44.0, 56.0),
                borderRadius: 16.r,
                onPressed: () => context.go(
                  '${AppRoutes.login}?role=company',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
