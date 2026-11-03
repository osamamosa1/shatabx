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
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../domain/entities/project_entity.dart';
import '../cubit/get_projects_cubit.dart';
import '../widgets/project_card.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _query = '';
  bool _latestFirst = true;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<GetProjectsCubit>();
    if (cubit.state is GetProjectsInitial) cubit.load();
  }

  List<ProjectEntity> _filtered(List<ProjectEntity> items, BuildContext ctx) {
    final list = items.where((p) {
      if (_query.trim().isEmpty) return true;
      final q = _query.trim().toLowerCase();
      return p.name.tr(ctx).toLowerCase().contains(q) ||
          p.location.tr(ctx).toLowerCase().contains(q);
    }).toList();
    return _latestFirst ? list : list.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final isEngineer =
        session is SessionAuthenticated &&
        session.user.role == AccountRole.engineer;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: isEngineer
          ? null
          : SoftZoom(
              child: SizedBox(
                width: 56.r,
                height: 56.r,
                child: FloatingActionButton(
                  onPressed: () async {
                    await context.push(AppRoutes.createProject);
                    if (context.mounted) {
                      context.read<GetProjectsCubit>().load();
                    }
                  },
                  backgroundColor: AppColors.primary,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: AppColors.white,
                    size: 28.r,
                  ),
                ),
              ),
            ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(18.r),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: SoftDrop(
                child: Text(
                  context.tr('projects'),
                  textAlign: TextAlign.center,
                  style: TextStyles.bold18(color: AppColors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<GetProjectsCubit, GetProjectsState>(
              builder: (context, state) {
                if (state is GetProjectsLoading ||
                    state is GetProjectsInitial) {
                  return const LoadingView();
                }
                if (state is GetProjectsError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () => context.read<GetProjectsCubit>().load(),
                  );
                }
                final raw = state is GetProjectsLoaded
                    ? state.projects
                    : <ProjectEntity>[];
                final projects = _filtered(raw, context);

                return ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 90.h),
                  children: [
                    SoftRise(
                      delay: const Duration(milliseconds: 40),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 42.h,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: TextField(
                                onChanged: (v) => setState(() => _query = v),
                                style: TextStyles.regular12(
                                  color: AppColors.text,
                                ),
                                decoration: InputDecoration(
                                  hintText: context.tr('search_project'),
                                  hintStyle: TextStyles.regular12(
                                    color: const Color(0xFF666C6B),
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(11.r),
                                    child: AppSvg(
                                      SvgAssets.search,
                                      size: 18.r,
                                    ),
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
                            onTap: () =>
                                setState(() => _latestFirst = !_latestFirst),
                            borderRadius: BorderRadius.circular(32.r),
                            child: Container(
                              width: 40.r,
                              height: 40.r,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.purpleLight),
                              ),
                              child: AppSvg(SvgAssets.filter, size: 20.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    SoftRise(
                      delay: const Duration(milliseconds: 70),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () =>
                                setState(() => _latestFirst = !_latestFirst),
                            child: Row(
                              children: [
                                Text(
                                  '${context.tr('sort_by')} ',
                                  style: TextStyles.regular12(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  _latestFirst
                                      ? context.tr('latest')
                                      : context.tr('oldest'),
                                  style: TextStyles.bold12(
                                    color: AppColors.text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${projects.length} ${context.tr('projects_added_count')}',
                            style: TextStyles.regular12(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...List.generate(projects.length, (index) {
                      final project = projects[index];
                      return SoftRise(
                        delay: Duration(milliseconds: 90 + (index * 45)),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: ProjectCard(
                            project: project,
                            isEngineerView: isEngineer,
                            onTap: () => context.push('/projects/${project.id}'),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
