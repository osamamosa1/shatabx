import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<GetProjectsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final name = session is SessionAuthenticated ? session.user.displayName : context.tr('guest');

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: BlocBuilder<GetProjectsCubit, GetProjectsState>(
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
            final projects = state is GetProjectsLoaded ? state.projects : <ProjectEntity>[];
            return ListView(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
              children: [
                SoftDrop(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.tr('hello'), style: TextStyles.regular14(color: AppColors.textSecondary)),
                            Text(name, style: TextStyles.bold18(color: AppColors.text)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push(AppRoutes.notifications),
                        icon: AppSvg(SvgAssets.notification, size: 24, color: AppColors.text),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                SoftRise(
                  delay: const Duration(milliseconds: 40),
                  child: Row(
                    children: [
                      Expanded(child: _Stat(context.tr('projects'), '${projects.length}', SvgAssets.projects)),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _Stat(
                          context.tr('in_progress'),
                          '${projects.where((p) => p.status == ProjectStatus.inProgress).length}',
                          SvgAssets.templates,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                SoftRise(
                  delay: const Duration(milliseconds: 80),
                  child: _Shortcut(
                    title: context.tr('templates'),
                    subtitle: context.tr('templates_sub'),
                    onTap: () => context.push(AppRoutes.templates),
                  ),
                ),
                SizedBox(height: 18.h),
                SoftRise(
                  delay: const Duration(milliseconds: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(context.tr('your_projects'), textAlign: TextAlign.start, style: TextStyles.bold18()),
                      SizedBox(height: 10.h),
                      ...projects.map(
                        (project) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: ProjectCard(
                            project: project,
                            onTap: () => context.push('/projects/${project.id}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, this.icon);

  final String label;
  final String value;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          AppSvg(icon, color: AppColors.primary, size: 22.r),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyles.bold22(color: AppColors.primary)),
                Text(label, style: TextStyles.regular12(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.r),
      child: Ink(
        decoration: BoxDecoration(
          gradient: AppGradients.primary,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: AppColors.cardShadow,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyles.bold18(color: AppColors.white)),
                      Text(subtitle, style: TextStyles.regular12(color: AppColors.onPrimaryMuted)),
                    ],
                  ),
                ),
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
