import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../../data/repositories/workspace_repository_impl.dart';
import '../../domain/entities/workspace_entities.dart';
import '../cubit/get_inspection_templates_cubit.dart';

class InspectionTemplatesScreen extends StatefulWidget {
  const InspectionTemplatesScreen({super.key});

  @override
  State<InspectionTemplatesScreen> createState() =>
      _InspectionTemplatesScreenState();
}

class _InspectionTemplatesScreenState extends State<InspectionTemplatesScreen> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<GetInspectionTemplatesCubit>().load();
  }

  void _showCreateTemplateSheet(BuildContext context) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            16.h,
            20.w,
            MediaQuery.of(ctx).viewInsets.bottom + 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.tr('create_template'),
                style: TextStyles.bold18(color: AppColors.text),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: context.isArabic
                      ? 'اسم القالب (مثال: الكود المصري - فيلا)'
                      : 'Template name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  hintText: context.isArabic ? 'التصنيف (تشطيبات)' : 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              MyDefaultButton(
                text: context.tr('save_data'),
                onPressed: () {
                  final title = nameController.text.trim();
                  if (title.isEmpty) return;
                  WorkspaceRepositoryImpl.addTemplate(
                    InspectionTemplateEntity(
                      id: 't${DateTime.now().millisecondsSinceEpoch}',
                      name: L10n(title, title),
                      itemsCount: 10,
                      phasesCount: 4,
                      inspectionsCount: 6,
                      category: L10n(
                        categoryController.text.trim().isEmpty
                            ? 'تشطيبات'
                            : categoryController.text.trim(),
                        categoryController.text.trim().isEmpty
                            ? 'Finishes'
                            : categoryController.text.trim(),
                      ),
                      dateLabel: const L10n(
                        'تاريخ الإنشاء: اليوم',
                        'Created: Today',
                      ),
                      items: const [
                        L10n(
                          'مطابقة الأعمال للمخططات المعتمدة',
                          'Works match approved blueprints',
                        ),
                        L10n(
                          'فحص جودة التنفيذ والخامات',
                          'Execution & material quality check',
                        ),
                      ],
                    ),
                  );
                  Navigator.pop(ctx);
                  context.read<GetInspectionTemplatesCubit>().load();
                  AppSnackBar.show(context, context.tr('save_data'));
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
                      context.tr('templates'),
                      textAlign: TextAlign.center,
                      style: TextStyles.bold18(color: AppColors.text),
                    ),
                  ),
                  SizedBox(width: 36.w),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<
                GetInspectionTemplatesCubit,
                GetInspectionTemplatesState
              >(
                builder: (context, state) {
                  if (state is GetInspectionTemplatesLoading ||
                      state is GetInspectionTemplatesInitial) {
                    return const LoadingView();
                  }
                  if (state is GetInspectionTemplatesError) {
                    return ErrorView(
                      message: state.message,
                      onRetry: () =>
                          context.read<GetInspectionTemplatesCubit>().load(),
                    );
                  }
                  final raw = state is GetInspectionTemplatesLoaded
                      ? state.items
                      : <InspectionTemplateEntity>[];
                  final items = raw.where((t) {
                    if (_query.trim().isEmpty) return true;
                    return t.name
                        .tr(context)
                        .toLowerCase()
                        .contains(_query.trim().toLowerCase());
                  }).toList();

                  return ListView(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                    children: [
                      SoftRise(
                        child: Container(
                          height: 42.h,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: TextField(
                            onChanged: (v) => setState(() => _query = v),
                            style: TextStyles.regular12(color: AppColors.text),
                            decoration: InputDecoration(
                              hintText: context.tr('search_template'),
                              hintStyle: TextStyles.regular12(
                                color: const Color(0xFF666C6B),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(11.r),
                                child: AppSvg(SvgAssets.search, size: 18.r),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ...List.generate(items.length, (index) {
                        final item = items[index];
                        return SoftRise(
                          delay: Duration(milliseconds: 50 + (index * 45)),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: InkWell(
                              onTap: () =>
                                  context.push('/templates/${item.id}'),
                              borderRadius: BorderRadius.circular(16.r),
                              child: Container(
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(color: AppColors.border),
                                  boxShadow: AppColors.cardShadow,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          child: Image.asset(
                                            ImgAssets.onboardingFolder,
                                            width: 44.r,
                                            height: 44.r,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name.tr(context),
                                                style: TextStyles.bold14(
                                                  color: AppColors.text,
                                                ),
                                              ),
                                              SizedBox(height: 2.h),
                                              Text(
                                                item.dateLabel?.tr(context) ??
                                                    item.category.tr(context),
                                                style: TextStyles.regular12(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.more_vert_rounded,
                                          size: 20.r,
                                          color: AppColors.textSecondary,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      child: const Divider(
                                        height: 1,
                                        color: AppColors.border,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _TemplateStat(
                                          icon: Icons.layers_outlined,
                                          value: '${item.phasesCount}',
                                          label: context.tr('phases_word'),
                                        ),
                                        _TemplateStat(
                                          icon: Icons.fact_check_outlined,
                                          value: '${item.inspectionsCount}',
                                          label: context.tr('inspections_word'),
                                        ),
                                        _TemplateStat(
                                          icon: Icons
                                              .format_list_bulleted_rounded,
                                          value: '${item.itemsCount}',
                                          label: context.tr('items_word'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: MyDefaultButton(
                text: context.tr('create_template'),
                height: 48.h,
                borderRadius: 16.r,
                onPressed: () => _showCreateTemplateSheet(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateStat extends StatelessWidget {
  const _TemplateStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: AppColors.primary),
        SizedBox(width: 4.w),
        Text(value, style: TextStyles.bold12(color: AppColors.text)),
        SizedBox(width: 3.w),
        Text(
          label,
          style: TextStyles.regular12(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
