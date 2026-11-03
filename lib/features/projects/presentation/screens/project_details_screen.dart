import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../domain/entities/project_entity.dart';
import '../cubit/get_project_details_cubit.dart';
import '../widgets/project_card.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key, required this.id});

  final String id;

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<GetProjectDetailsCubit>().load(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final session = context.watch<SessionCubit>().state;
    final isEngineer =
        session is SessionAuthenticated &&
        session.user.role == AccountRole.engineer;

    final tabs = [
      context.tr('tab_overview'),
      context.tr('tab_phases'),
      context.tr('tab_issues'),
      context.tr('tab_media'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: BlocBuilder<GetProjectDetailsCubit, GetProjectDetailsState>(
        builder: (context, state) {
          if (state is GetProjectDetailsLoading ||
              state is GetProjectDetailsInitial) {
            return const LoadingView();
          }
          if (state is GetProjectDetailsError) {
            return ErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<GetProjectDetailsCubit>().load(widget.id),
            );
          }
          if (state is! GetProjectDetailsLoaded) return const SizedBox.shrink();
          final project = state.project;

          return Column(
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
                          project.name.tr(context),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.bold18(color: AppColors.white),
                        ),
                      ),
                      SizedBox(width: 34.w),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
                  children: [
                    SoftRise(
                      child: ProjectCard(
                        project: project,
                        isEngineerView: isEngineer,
                        onTap: () {},
                      ),
                    ),
                    SizedBox(height: 14.h),
                    SoftRise(
                      delay: const Duration(milliseconds: 50),
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: List.generate(tabs.length, (i) {
                            final active = _tabIndex == i;
                            return Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _tabIndex = i),
                                borderRadius: BorderRadius.circular(12.r),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: EdgeInsets.all(4.r),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: active
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    tabs[i],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.bold12(
                                      color: active
                                          ? AppColors.white
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      transitionBuilder: (child, anim) {
                        return FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.04),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        );
                      },
                      child: _tabIndex == 0
                          ? _OverviewTab(project: project)
                          : _tabIndex == 1
                          ? _PhasesTab(
                              project: project,
                              isEngineer: isEngineer,
                            )
                          : _tabIndex == 2
                          ? _IssuesTab(project: project)
                          : const _MediaTab(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.project});

  final ProjectEntity project;

  @override
  Widget build(BuildContext context) {
    return SoftRise(
      key: const ValueKey('tab-overview'),
      child: Column(
        children: [
          _SectionCard(
            title: context.tr('project_info'),
            icon: SvgAssets.company,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _KeyValueRow(
                  label: context.tr('client_owner'),
                  value:
                      project.clientName?.tr(context) ??
                      (context.isArabic
                          ? 'شركة أزور للمقاولات'
                          : 'Azure Contracting'),
                ),
                SizedBox(height: 8.h),
                Text(
                  context.isArabic
                      ? 'متابعة أعمال التشطيبات والفحص الهندسي الميداني وفق الكود المعتمد.'
                      : 'Following up finishing works and field inspection according to the approved code.',
                  style: TextStyles.regular12(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _DateBox(
                  label: context.tr('start_date'),
                  value: project.startDate ?? '8-4-2026',
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _DateBox(
                  label: context.tr('end_date'),
                  value: project.endDate ?? '19-1-2027',
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _SectionCard(
            title: context.tr('assigned_engineers'),
            icon: SvgAssets.engineer,
            child: Column(
              children: [
                _EngineerRow(
                  name: project.engineer.tr(context),
                  role: context.isArabic
                      ? 'مدير المشروع الفني'
                      : 'Technical Project Lead',
                  avatar: ImgAssets.engineerAvatar,
                ),
                SizedBox(height: 10.h),
                _EngineerRow(
                  name: context.isArabic ? 'م. أحمد عادل' : 'Eng. Ahmed Adel',
                  role: context.isArabic
                      ? 'مشرف البناء الخرساني'
                      : 'Concrete Supervisor',
                  avatar: ImgAssets.companyAvatar,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          _SectionCard(
            title: context.tr('site_details'),
            icon: SvgAssets.location,
            child: Column(
              children: [
                _KeyValueRow(
                  label: context.tr('execution_location'),
                  value: project.location.tr(context),
                ),
                SizedBox(height: 8.h),
                _KeyValueRow(
                  label: context.tr('unit_area'),
                  value: project.unitArea?.tr(context) ?? '120 م²',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhasesTab extends StatelessWidget {
  const _PhasesTab({required this.project, required this.isEngineer});

  final ProjectEntity project;
  final bool isEngineer;

  @override
  Widget build(BuildContext context) {
    final phases = project.phases;
    return SoftRise(
      key: const ValueKey('tab-phases'),
      child: Column(
                  children: List.generate(phases.length, (index) {
          final item = phases[index];
          final percentInt = (item.progress * 100).round();
          return SoftRise(
            delay: Duration(milliseconds: 50 + (index * 80)),
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SoftZoom(
                        delay: Duration(milliseconds: 110 + (index * 80)),
                        child: Container(
                          width: 36.r,
                          height: 36.r,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: item.completed
                                ? AppColors.statusSuccessLight
                                : AppColors.statusInfoLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: item.completed
                                  ? AppColors.statusSuccess
                                  : AppColors.primary,
                            ),
                          ),
                          child: item.completed
                              ? Icon(
                                  Icons.check_rounded,
                                  color: AppColors.statusSuccess,
                                  size: 20.r,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: TextStyles.bold14(
                                    color: AppColors.primary,
                                  ),
                                ),
                        ),
                      ),
                      if (index < phases.length - 1)
                        Container(
                          width: 2,
                          height: 100.h,
                          color: AppColors.border,
                        ),
                    ],
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TapScale(
                      child: InkWell(
                        onTap: () => context.push(
                          isEngineer
                              ? '${AppRoutes.inspectionRun}?project=${Uri.encodeComponent(project.name.tr(context))}&phase=${Uri.encodeComponent(item.title.tr(context))}'
                              : '${AppRoutes.reports}/r1',
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title.tr(context),
                                      style: TextStyles.bold14(
                                        color: AppColors.text,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item.completed
                                          ? AppColors.statusSuccessLight
                                          : AppColors.statusInfoLight,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      item.statusLabel.tr(context),
                                      style: TextStyles.bold12(
                                        color: item.completed
                                            ? AppColors.statusSuccess
                                            : AppColors.primary,
                                      ).copyWith(fontSize: 10.sp),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item.lastCheckLabel.tr(context),
                                style: TextStyles.regular12(
                                  color: AppColors.textSecondary,
                                ).copyWith(fontSize: 11.sp),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Text(
                                    '${item.itemsCount} ${context.tr('items_word')}',
                                    style: TextStyles.medium12(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const Spacer(),
                                  AnimatedCount(
                                    value: percentInt,
                                    suffix: '%',
                                    style: TextStyles.bold12(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              AnimatedProgressBar(
                                value: item.progress,
                                height: 7.h,
                                color: AppColors.progressBlue,
                              ),
                              if (isEngineer) ...[
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      context.tr('start_inspection'),
                                      style: TextStyles.bold12(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.fact_check_outlined,
                                      size: 16.r,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _IssuesTab extends StatelessWidget {
  const _IssuesTab({required this.project});

  final ProjectEntity project;

  @override
  Widget build(BuildContext context) {
    final issues = [
      (
        title: context.isArabic
            ? 'فراغات في ترابط شبكة الحديد عند زاوية المحور ج-12'
            : 'Gaps in steel mesh bonding at axis C-12',
        phase: context.isArabic ? 'الهيكل الإنشائي' : 'Structural frame',
        severity: context.isArabic ? 'أولوية عالية' : 'High priority',
        color: AppColors.statusError,
      ),
      (
        title: context.isArabic
            ? 'تعديل مسار مواسير الكهرباء في الممر الفرعي'
            : 'Adjust electrical conduit path in sub-corridor',
        phase: context.isArabic ? 'التمديدات والكهرباء' : 'Wiring & electrical',
        severity: context.isArabic ? 'متوسطة' : 'Medium',
        color: AppColors.statusWarning,
      ),
    ];

    return SoftRise(
      key: const ValueKey('tab-issues'),
      child: Column(
        children: issues.map((issue) {
          return Container(
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
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: issue.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        issue.severity,
                        style: TextStyles.bold12(color: issue.color),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      issue.phase,
                      style: TextStyles.regular12(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  issue.title,
                  style: TextStyles.bold14(color: AppColors.text),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MediaTab extends StatelessWidget {
  const _MediaTab();

  static const _photos = [
    ImgAssets.loginCompanyHero,
    ImgAssets.projectThumb2,
    ImgAssets.projectThumb3,
    ImgAssets.projectThumb4,
    ImgAssets.projectEg,
    ImgAssets.projectSa,
  ];

  @override
  Widget build(BuildContext context) {
    return SoftRise(
      key: const ValueKey('tab-media'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.tr('field_photos'),
            style: TextStyles.bold16(color: AppColors.text),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _photos.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 8.w,
                  ),
                  itemBuilder: (context, index) {
                    return SoftZoom(
                      delay: Duration(milliseconds: 60 + (index * 55)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.asset(
                          _photos[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 14.h),
                InkWell(
                  onTap: () => AppSnackBar.show(
                    context,
                    context.tr('upload_photo'),
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    height: 46.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFB0CEDB)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppSvg(
                          SvgAssets.upload,
                          size: 18.r,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          context.tr('upload_photo'),
                          style: TextStyles.medium14(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            context.tr('technical_links'),
            style: TextStyles.bold16(color: AppColors.text),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const _LinkRow(url: 'https://drive.shatabx.com/blueprints-v1'),
                SizedBox(height: 8.h),
                const _LinkRow(url: 'https://drive.shatabx.com/mep-layout-v2'),
                SizedBox(height: 12.h),
                InkWell(
                  onTap: () =>
                      AppSnackBar.show(context, context.tr('add_link')),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.link_rounded,
                          size: 18.r,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          context.tr('add_link'),
                          style: TextStyles.medium14(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final String icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 30.r,
                height: 30.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AppSvg(icon, size: 16.r, color: AppColors.primary),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyles.bold14(color: AppColors.text),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Divider(height: 1, color: AppColors.border),
          ),
          child,
        ],
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyles.regular12(color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(value, style: TextStyles.bold14(color: AppColors.text)),
      ],
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyles.regular12(color: AppColors.textSecondary),
          ),
          SizedBox(height: 4.h),
          Text(value, style: TextStyles.bold14(color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _EngineerRow extends StatelessWidget {
  const _EngineerRow({
    required this.name,
    required this.role,
    required this.avatar,
  });

  final String name;
  final String role;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            avatar,
            width: 32.r,
            height: 32.r,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(name, style: TextStyles.medium14(color: AppColors.text)),
        ),
        Text(
          role,
          style: TextStyles.regular12(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.regular12(color: AppColors.primary),
            ),
          ),
          Icon(Icons.copy_rounded, size: 16.r, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
