import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../data/repositories/projects_repository_impl.dart';
import '../../domain/entities/project_entity.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _client = TextEditingController();
  final _location = TextEditingController(text: 'الرياض - حي النرجس');
  final _engineer = TextEditingController(text: 'م. خالد العتيبي');
  final _area = TextEditingController(text: '250 م²');
  final _startDate = TextEditingController(text: '10-11-2026');
  final _endDate = TextEditingController(text: '10-05-2027');

  @override
  void dispose() {
    _name.dispose();
    _client.dispose();
    _location.dispose();
    _engineer.dispose();
    _area.dispose();
    _startDate.dispose();
    _endDate.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final title = _name.text.trim();
    final loc = _location.text.trim();
    final eng = _engineer.text.trim();

    ProjectsRepositoryImpl.addProject(
      ProjectEntity(
        id: 'p${DateTime.now().millisecondsSinceEpoch}',
        name: L10n(title, title),
        location: L10n(loc, loc),
        progress: 0.05,
        status: ProjectStatus.started,
        phase: const L10n('الأعمال التحضيرية', 'Preparatory works'),
        engineer: L10n(eng, eng),
        imageAsset: ImgAssets.saveProject,
        lastUpdated: const L10n('الآن', 'Just now'),
        clientName: L10n(_client.text.trim(), _client.text.trim()),
        startDate: _startDate.text.trim(),
        endDate: _endDate.text.trim(),
        unitArea: L10n(_area.text.trim(), _area.text.trim()),
        phases: ProjectsRepositoryImpl.items.first.phases,
      ),
    );

    AppSnackBar.show(context, context.tr('project_created'));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 18.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(18.r),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      width: 34.r,
                      height: 34.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: AppSvg(
                        rtl ? SvgAssets.arrowForward : SvgAssets.arrowBack,
                        size: 16.r,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      context.tr('create_project'),
                      textAlign: TextAlign.center,
                      style: TextStyles.bold18(color: AppColors.white),
                    ),
                  ),
                  SizedBox(width: 34.w),
                ],
              ),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                children: [
                  SoftZoom(
                    child: Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 82.r,
                            height: 82.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              ImgAssets.saveProject,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.progressBlue,
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            child: Text(
                              context.isArabic
                                  ? 'صورة المشروع (اختياري)'
                                  : 'Project photo (optional)',
                              style: TextStyles.bold12(color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SoftRise(
                    delay: const Duration(milliseconds: 50),
                    child: Column(
                      children: [
                        MyTextFormField(
                          controller: _name,
                          label: context.tr('project_name'),
                          hint: context.tr('project_name_hint'),
                          validator: (v) => Validator.requiredField(
                            context,
                            v,
                            label: context.tr('project_name'),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        MyTextFormField(
                          controller: _client,
                          label: context.tr('client_name'),
                          hint: context.tr('client_name_hint'),
                          validator: (v) => Validator.requiredField(
                            context,
                            v,
                            label: context.tr('client_name'),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        MyTextFormField(
                          controller: _location,
                          label: context.tr('execution_location'),
                          hint: context.tr('address_hint'),
                        ),
                        SizedBox(height: 12.h),
                        MyTextFormField(
                          controller: _engineer,
                          label: context.tr('engineer'),
                          hint: 'م. خالد العتيبي',
                        ),
                        SizedBox(height: 12.h),
                        MyTextFormField(
                          controller: _area,
                          label: context.tr('unit_area'),
                          hint: '250 م²',
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: MyTextFormField(
                                controller: _startDate,
                                label: context.tr('start_date'),
                                hint: '10-11-2026',
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: MyTextFormField(
                                controller: _endDate,
                                label: context.tr('end_date'),
                                hint: '10-05-2027',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SoftRise(
                    delay: const Duration(milliseconds: 100),
                    child: Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              AppSvg(
                                SvgAssets.templates,
                                size: 20.r,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  context.tr('template_auto_title'),
                                  style: TextStyles.bold14(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            context.tr('template_used'),
                            style: TextStyles.bold12(color: AppColors.text),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            context.tr('template_auto_desc'),
                            style: TextStyles.regular12(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 22.h),
                  MyDefaultButton(
                    text: context.tr('create_project'),
                    height: 48.h,
                    borderRadius: 16.r,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
