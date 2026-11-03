import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/my_default_button.dart';

class InspectionRunScreen extends StatefulWidget {
  const InspectionRunScreen({
    super.key,
    required this.projectName,
    required this.phaseName,
  });

  final String projectName;
  final String phaseName;

  @override
  State<InspectionRunScreen> createState() => _InspectionRunScreenState();
}

class _InspectionRunScreenState extends State<InspectionRunScreen> {
  final List<bool> _compliant = [false, true, true];
  final TextEditingController _note = TextEditingController(
    text: 'يوجد تمديد يحتاج تعديل في زاوية الممر',
  );

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      context.isArabic
          ? 'تركيب المواسير الكهربائية'
          : 'Electrical conduit installation',
      context.isArabic
          ? 'جودة التمديدات الكهربائية'
          : 'Electrical wiring quality',
      context.isArabic
          ? 'تأريض اللوحات الكهربائية'
          : 'Electrical panel earthing',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      children: [
                        const AppBackButton(),
                        Expanded(
                          child: Text(
                            context.tr('start_inspection'),
                            textAlign: TextAlign.center,
                            style: TextStyles.bold16(color: AppColors.text),
                          ),
                        ),
                        SizedBox(width: 36.w),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    color: AppColors.statusInfoLight,
                    child: Text(
                      widget.projectName.isEmpty
                          ? (context.isArabic
                                ? 'فحص ميداني مباشر ورفع ملاحظات المهندس'
                                : 'Live site inspection & engineer notes')
                          : '${widget.projectName} • ${widget.phaseName}',
                      textAlign: TextAlign.center,
                      style: TextStyles.medium12(color: AppColors.statusInfo),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final ok = _compliant[index];
                return SoftRise(
                  delay: Duration(milliseconds: 40 + (index * 45)),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          items[index],
                          style: TextStyles.bold14(color: AppColors.text),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    setState(() => _compliant[index] = true),
                                borderRadius: BorderRadius.circular(10.r),
                                child: Container(
                                  height: 36.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: ok
                                        ? AppColors.statusSuccessLight
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: ok
                                          ? AppColors.statusSuccess
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Text(
                                    context.tr('compliant'),
                                    style: TextStyles.bold12(
                                      color: ok
                                          ? AppColors.statusSuccess
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    setState(() => _compliant[index] = false),
                                borderRadius: BorderRadius.circular(10.r),
                                child: Container(
                                  height: 36.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: !ok
                                        ? AppColors.statusErrorLight
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: !ok
                                          ? AppColors.statusError
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Text(
                                    context.tr('non_compliant'),
                                    style: TextStyles.bold12(
                                      color: !ok
                                          ? AppColors.statusError
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!ok) ...[
                          SizedBox(height: 10.h),
                          TextField(
                            controller: index == 0 ? _note : null,
                            style: TextStyles.regular12(color: AppColors.text),
                            decoration: InputDecoration(
                              hintText: context.isArabic
                                  ? 'اكتب ملاحظة الفحص...'
                                  : 'Enter inspection note...',
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              ImgAssets.loginCompanyHero,
                              ImgAssets.projectThumb2,
                              ImgAssets.projectThumb3,
                            ].map((asset) {
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Image.asset(
                                      asset,
                                      height: 68.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              top: false,
              child: MyDefaultButton(
                text: context.tr('submit_inspection'),
                height: 48.h,
                borderRadius: 16.r,
                onPressed: () {
                  AppSnackBar.show(context, context.tr('inspection_submitted'));
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
