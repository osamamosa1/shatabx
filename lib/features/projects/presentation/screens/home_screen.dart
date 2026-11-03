import 'package:animate_do/animate_do.dart';
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
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../projects/domain/entities/project_entity.dart';
import '../../../projects/presentation/cubit/get_projects_cubit.dart';
import '../../../projects/presentation/widgets/project_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  ProjectStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    context.read<GetProjectsCubit>().load();
  }

  List<ProjectEntity> _filtered(List<ProjectEntity> items, BuildContext ctx) {
    return items.where((p) {
      if (_statusFilter != null && p.status != _statusFilter) return false;
      if (_query.trim().isEmpty) return true;
      final q = _query.trim().toLowerCase();
      return p.name.tr(ctx).toLowerCase().contains(q) ||
          p.location.tr(ctx).toLowerCase().contains(q);
    }).toList();
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                context.tr('sort_by'),
                style: TextStyles.bold18(color: AppColors.text),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _FilterChip(
                    label: context.tr('tab_all'),
                    selected: _statusFilter == null,
                    onTap: () {
                      setState(() => _statusFilter = null);
                      Navigator.pop(ctx);
                    },
                  ),
                  _FilterChip(
                    label: context.tr('status_started'),
                    selected: _statusFilter == ProjectStatus.started,
                    onTap: () {
                      setState(() => _statusFilter = ProjectStatus.started);
                      Navigator.pop(ctx);
                    },
                  ),
                  _FilterChip(
                    label: context.tr('status_progress'),
                    selected: _statusFilter == ProjectStatus.inProgress,
                    onTap: () {
                      setState(() => _statusFilter = ProjectStatus.inProgress);
                      Navigator.pop(ctx);
                    },
                  ),
                  _FilterChip(
                    label: context.tr('status_delayed'),
                    selected: _statusFilter == ProjectStatus.delayed,
                    onTap: () {
                      setState(() => _statusFilter = ProjectStatus.delayed);
                      Navigator.pop(ctx);
                    },
                  ),
                  _FilterChip(
                    label: context.tr('status_done'),
                    selected: _statusFilter == ProjectStatus.completed,
                    onTap: () {
                      setState(() => _statusFilter = ProjectStatus.completed);
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final user = session is SessionAuthenticated ? session.user : null;
    final isEngineer = user?.role == AccountRole.engineer;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: BlocBuilder<GetProjectsCubit, GetProjectsState>(
        builder: (context, state) {
          if (state is GetProjectsLoading || state is GetProjectsInitial) {
            return const LoadingView();
          }
          if (state is GetProjectsError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<GetProjectsCubit>().load(),
            );
          }
          final allProjects = state is GetProjectsLoaded
              ? state.projects
              : <ProjectEntity>[];
          final projects = _filtered(allProjects, context);

          if (isEngineer) {
            return _EngineerHomeBody(
              user: user,
              allProjects: allProjects,
              projects: projects,
              onSearchChanged: (v) => setState(() => _query = v),
              onFilterTap: () => _openFilterSheet(context),
            );
          }

          return _CompanyHomeBody(
            user: user,
            allProjects: allProjects,
            projects: projects,
            onSearchChanged: (v) => setState(() => _query = v),
            onFilterTap: () => _openFilterSheet(context),
          );
        },
      ),
    );
  }
}

class _CompanyHomeBody extends StatelessWidget {
  const _CompanyHomeBody({
    required this.user,
    required this.allProjects,
    required this.projects,
    required this.onSearchChanged,
    required this.onFilterTap,
  });

  final UserEntity? user;
  final List<ProjectEntity> allProjects;
  final List<ProjectEntity> projects;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final companyName =
        user?.companyName ??
        (context.isArabic ? 'شركة الإتقان' : 'Al Itqan Company');
    final locationText =
        user?.address ??
        (context.isArabic ? 'المنصورة، الدقهلية' : 'Mansoura, Dakahlia');

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        children: [
          SoftDrop(
            child: Row(
              children: [
                Container(
                  width: 46.r,
                  height: 46.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFDDE1F3)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    ImgAssets.companyAvatar,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName,
                        style: TextStyles.bold18(color: AppColors.text),
                      ),
                      Row(
                        children: [
                          AppSvg(
                            SvgAssets.location,
                            size: 14.r,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              locationText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.medium12(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16.r,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _NotificationIconButton(
                  onTap: () => context.push(AppRoutes.notifications),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          SoftZoom(
            delay: const Duration(milliseconds: 50),
            child: _CompanyProBanner(
              onTap: () => context.push(AppRoutes.subscriptions),
            ),
          ),
          SizedBox(height: 14.h),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SoftSlideStart(
                      delay: const Duration(milliseconds: 110),
                      child: _CompanyStatCard(
                        icon: SvgAssets.chartSquare,
                        value: allProjects.length,
                        label: context.tr('projects'),
                        onTap: () => context.go(AppRoutes.projects),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: SoftSlideEnd(
                      delay: const Duration(milliseconds: 160),
                      child: _CompanyStatCard(
                        icon: SvgAssets.engineerStat,
                        value: 12,
                        label: context.tr('engineers_stat'),
                        onTap: () => context.push(AppRoutes.engineers),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: SoftSlideStart(
                      delay: const Duration(milliseconds: 210),
                      child: _CompanyStatCard(
                        icon: SvgAssets.buildingDone,
                        value: 14,
                        label: context.tr('completed_projects_stat'),
                        onTap: () => context.go(AppRoutes.projects),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: SoftSlideEnd(
                      delay: const Duration(milliseconds: 260),
                      child: _CompanyStatCard(
                        icon: SvgAssets.clock,
                        value: 3,
                        label: context.tr('pending_reports_stat'),
                        onTap: () => context.go(AppRoutes.reports),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 18.h),
          SoftRise(
            delay: const Duration(milliseconds: 110),
            child: _SearchAndFilterBar(
              hint: context.tr('search_project'),
              onChanged: onSearchChanged,
              onFilterTap: onFilterTap,
            ),
          ),
          SizedBox(height: 16.h),
          SoftRise(
            delay: const Duration(milliseconds: 140),
            child: _SectionHeader(
              title: context.tr('your_projects'),
              actionLabel: context.tr('view_all'),
              onAction: () => context.go(AppRoutes.projects),
            ),
          ),
          SizedBox(height: 12.h),
          if (projects.isEmpty)
            SoftZoom(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Column(
                  children: [
                    AppSvg(SvgAssets.emptyProjectsWorker, size: 110.r),
                    SizedBox(height: 12.h),
                    Text(
                      context.tr('no_projects_yet'),
                      style: TextStyles.bold16(color: AppColors.text),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      context.tr('no_projects_sub'),
                      style: TextStyles.regular12(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...List.generate(projects.length, (i) {
              final project = projects[i];
              return SoftRise(
                delay: Duration(milliseconds: 160 + (i * 40)),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: ProjectCard(
                    project: project,
                    isEngineerView: false,
                    onTap: () => context.push('/projects/${project.id}'),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _EngineerHomeBody extends StatelessWidget {
  const _EngineerHomeBody({
    required this.user,
    required this.allProjects,
    required this.projects,
    required this.onSearchChanged,
    required this.onFilterTap,
  });

  final UserEntity? user;
  final List<ProjectEntity> allProjects;
  final List<ProjectEntity> projects;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final engineerName =
        user?.name ??
        (context.isArabic ? 'م. خالد العتيبي' : 'Eng. Khalid Al-Otaibi');

    return ListView(
      padding: EdgeInsets.only(bottom: 24.h),
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 168.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24.r),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
                  child: SoftDrop(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 46.r,
                          height: 46.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            ImgAssets.engineerAvatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('hello'),
                                style: TextStyles.bold18(
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                engineerName,
                                style: TextStyles.medium14(
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _NotificationIconButton(
                          onTap: () => context.push(AppRoutes.notifications),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 122.h, 16.w, 0),
              child: Row(
                children: [
                  Expanded(
                    child: SoftZoom(
                      delay: const Duration(milliseconds: 80),
                      child: _EngineerStatCard(
                        icon: SvgAssets.buildingDone,
                        value: 14,
                        label: context.tr('completed_projects_stat'),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: SoftZoom(
                      delay: const Duration(milliseconds: 150),
                      child: _EngineerStatCard(
                        icon: SvgAssets.reports,
                        value: 3,
                        label: context.tr('new_projects_stat'),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: SoftZoom(
                      delay: const Duration(milliseconds: 220),
                      child: _EngineerStatCard(
                        icon: SvgAssets.clock,
                        value: 3,
                        label: context.tr('in_progress_projects_stat'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
          child: Column(
            children: [
              SoftRise(
                delay: const Duration(milliseconds: 90),
                child: _SearchAndFilterBar(
                  hint: context.tr('search_project'),
                  onChanged: onSearchChanged,
                  onFilterTap: onFilterTap,
                ),
              ),
              SizedBox(height: 16.h),
              SoftRise(
                delay: const Duration(milliseconds: 120),
                child: _SectionHeader(
                  title: context.tr('your_projects'),
                  actionLabel: context.tr('view_all'),
                  onAction: () => context.go(AppRoutes.projects),
                ),
              ),
              SizedBox(height: 12.h),
              ...List.generate(projects.length, (i) {
                final project = projects[i];
                return SoftRise(
                  delay: Duration(milliseconds: 140 + (i * 40)),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: ProjectCard(
                      project: project,
                      isEngineerView: true,
                      onTap: () => context.push('/projects/${project.id}'),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotificationIconButton extends StatelessWidget {
  const _NotificationIconButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Swing(
      delay: const Duration(milliseconds: 450),
      duration: const Duration(milliseconds: 700),
      child: TapScale(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100.r),
          child: Container(
            width: 36.r,
            height: 36.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Color(0x14000000), blurRadius: 12),
              ],
            ),
            child: AppSvg(
              SvgAssets.notification,
              size: 18.r,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _CompanyProBanner extends StatelessWidget {
  const _CompanyProBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 143.h,
      decoration: BoxDecoration(
        color: AppColors.proBannerDark,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24101828),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: 0.22,
                child: Image.asset(
                  ImgAssets.loginEngineer,
                  fit: BoxFit.cover,
                ),
              ),
              PositionedDirectional(
                end: -30.w,
                top: -40.h,
                child: Container(
                  width: 150.r,
                  height: 150.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.progressBlue.withValues(alpha: 0.28),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(18.r),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.workspace_premium_rounded,
                                  color: const Color(0xFFFBBF24),
                                  size: 14.r,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  context.tr('pro_package_badge'),
                                  style: TextStyles.bold12(
                                    color: AppColors.white,
                                  ).copyWith(fontSize: 11.sp),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            context.tr('pro_banner_title'),
                            style: TextStyles.bold16(color: AppColors.white),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            context.tr('pro_banner_sub'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.regular12(
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Pulse(
                      infinite: true,
                      duration: const Duration(milliseconds: 1800),
                      child: Container(
                        width: 40.r,
                        height: 40.r,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.north_west_rounded,
                          color: AppColors.text,
                          size: 20.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyStatCard extends StatelessWidget {
  const _CompanyStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final int value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE6EFF3)),
          boxShadow: const [
            BoxShadow(color: Color(0x0F000000), blurRadius: 20),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppSvg(icon, size: 28.r),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedCount(
                        value: value,
                        style: TextStyles.bold22(color: AppColors.text),
                      ),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.medium12(color: AppColors.text),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EngineerStatCard extends StatelessWidget {
  const _EngineerStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final String icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFF3F3F3)),
          boxShadow: const [
            BoxShadow(color: Color(0x12000000), blurRadius: 18),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSvg(icon, size: 22.r, color: AppColors.primary),
            SizedBox(height: 6.h),
            AnimatedCount(
              value: value,
              style: TextStyles.bold20(color: AppColors.text),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.medium12(
                color: AppColors.text,
              ).copyWith(fontSize: 11.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchAndFilterBar extends StatelessWidget {
  const _SearchAndFilterBar({
    required this.hint,
    required this.onChanged,
    required this.onFilterTap,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 0.8),
              boxShadow: const [
                BoxShadow(color: Color(0x0D000000), blurRadius: 12),
              ],
            ),
            child: TextField(
              onChanged: onChanged,
              style: TextStyles.regular12(color: AppColors.text),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyles.regular12(color: const Color(0xFF666C6B)),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(11.r),
                  child: AppSvg(SvgAssets.search, size: 18.r),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(32.r),
          child: Container(
            width: 40.r,
            height: 40.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.purpleLight),
              boxShadow: const [
                BoxShadow(color: Color(0x0F000000), blurRadius: 14),
              ],
            ),
            child: AppSvg(SvgAssets.filter, size: 20.r),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Row(
      children: [
        Text(title, style: TextStyles.bold16(color: AppColors.text)),
        const Spacer(),
        InkWell(
          onTap: onAction,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                Text(
                  actionLabel,
                  style: TextStyles.medium12(color: AppColors.primary),
                ),
                SizedBox(width: 4.w),
                AppSvg(
                  rtl ? SvgAssets.arrowBack : SvgAssets.arrowForward,
                  size: 14.r,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyles.medium12(
          color: selected ? AppColors.white : AppColors.text,
        ),
      ),
      selected: selected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      onSelected: (_) => onTap(),
    );
  }
}
