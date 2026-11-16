import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/error_message.dart';
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
import '../../../../injection_container.dart';
import '../../../content/data/datasources/content_remote_data_source.dart';
import '../../domain/params/create_project_params.dart';
import '../../domain/usecases/project_use_cases.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _location = TextEditingController();
  final _area = TextEditingController();
  final _startDate = TextEditingController();
  final _endDate = TextEditingController();

  List<Map<String, dynamic>> _customers = const [];
  List<Map<String, dynamic>> _engineers = const [];
  String? _customerId;
  String? _engineerId;
  bool _loadingLookups = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadLookups();
  }

  Future<void> _loadLookups() async {
    try {
      final content = ServiceLocator.instance<ContentRemoteDataSource>();
      final results = await Future.wait([
        content.getCustomers(),
        content.getEngineers(),
      ]);
      if (!mounted) return;
      setState(() {
        _customers = results[0];
        _engineers = results[1];
        _customerId = _customers.isNotEmpty
            ? _customers.first['id']?.toString()
            : null;
        _engineerId = _engineers.isNotEmpty
            ? _engineers.first['id']?.toString()
            : null;
        _loadingLookups = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingLookups = false);
    }
  }

  String _labelOf(Map<String, dynamic> item) {
    final name = item['name']?.toString().trim() ?? '';
    if (name.isNotEmpty) return name;
    final phone = item['phone']?.toString().trim() ?? '';
    if (phone.isNotEmpty) return phone;
    return item['id']?.toString() ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
    _area.dispose();
    _startDate.dispose();
    _endDate.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_customerId == null) {
      AppSnackBar.show(
        context,
        context.isArabic ? 'اختر عميلاً أولاً' : 'Select a client first',
        error: true,
      );
      return;
    }
    setState(() => _saving = true);

    String clientName = '';
    for (final c in _customers) {
      if (c['id']?.toString() == _customerId) {
        clientName = _labelOf(c);
        break;
      }
    }
    String engineerName = '';
    for (final e in _engineers) {
      if (e['id']?.toString() == _engineerId) {
        engineerName = _labelOf(e);
        break;
      }
    }

    final result = await ServiceLocator.instance<CreateProjectUseCase>()(
      CreateProjectParams(
        name: _name.text.trim(),
        clientName: clientName,
        location: _location.text.trim(),
        engineerName: engineerName,
        area: _area.text.trim(),
        startDate: _startDate.text.trim().isEmpty
            ? null
            : _startDate.text.trim(),
        endDate: _endDate.text.trim().isEmpty ? null : _endDate.text.trim(),
        customerId: _customerId,
        engineerId: _engineerId,
      ),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    result.fold(
      (failure) {
        AppSnackBar.show(
          context,
          resolveErrorMessage(context, failure.message),
          error: true,
        );
      },
      (_) {
        AppSnackBar.show(context, context.tr('project_created'));
        context.pop(true);
      },
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<Map<String, dynamic>> items,
    required ValueChanged<String?> onChanged,
    required String emptyHint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: TextStyles.bold12(color: AppColors.text)),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: Text(
                emptyHint,
                style: TextStyles.regular12(color: AppColors.textSecondary),
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item['id']?.toString(),
                      child: Text(
                        _labelOf(item),
                        style: TextStyles.regular14(color: AppColors.text),
                      ),
                    ),
                  )
                  .toList(growable: false),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
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
                        if (_loadingLookups)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else ...[
                          _dropdown(
                            label: context.tr('client_name'),
                            value: _customerId,
                            items: _customers,
                            emptyHint: context.isArabic
                                ? 'لا يوجد عملاء'
                                : 'No clients',
                            onChanged: (v) => setState(() => _customerId = v),
                          ),
                          SizedBox(height: 12.h),
                          _dropdown(
                            label: context.tr('engineer'),
                            value: _engineerId,
                            items: _engineers,
                            emptyHint: context.isArabic
                                ? 'لا يوجد مهندسون'
                                : 'No engineers',
                            onChanged: (v) => setState(() => _engineerId = v),
                          ),
                        ],
                        SizedBox(height: 12.h),
                        MyTextFormField(
                          controller: _location,
                          label: context.tr('execution_location'),
                          hint: context.tr('address_hint'),
                        ),
                        SizedBox(height: 12.h),
                        MyTextFormField(
                          controller: _area,
                          label: context.tr('unit_area'),
                          hint: '250 م²',
                          validator: (v) => Validator.requiredField(
                            context,
                            v,
                            label: context.tr('unit_area'),
                          ),
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
                    isLoading: _saving,
                    onPressed: _saving || _loadingLookups ? null : _submit,
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
