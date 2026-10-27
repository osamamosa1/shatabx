import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../domain/entities/project_entity.dart';
import '../cubit/get_projects_cubit.dart';
import '../widgets/project_card.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<GetProjectsCubit>();
    if (cubit.state is GetProjectsInitial) cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(context.tr('projects'), style: TextStyles.bold20()),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: BlocBuilder<GetProjectsCubit, GetProjectsState>(
        builder: (context, state) {
          if (state is GetProjectsLoading || state is GetProjectsInitial) {
            return const LoadingView();
          }
          if (state is GetProjectsError) {
            return ErrorView(message: state.message, onRetry: () => context.read<GetProjectsCubit>().load());
          }
          final projects = state is GetProjectsLoaded ? state.projects : <ProjectEntity>[];
          return ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: projects.length,
            separatorBuilder: (_, _) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final project = projects[index];
              return ProjectCard(
                project: project,
                onTap: () => context.push('/projects/${project.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
