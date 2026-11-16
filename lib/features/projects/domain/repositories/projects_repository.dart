import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/project_entity.dart';
import '../params/create_project_params.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();
  Future<Either<Failure, ProjectEntity>> getProject(String id);
  Future<Either<Failure, ProjectEntity>> createProject(CreateProjectParams params);
}
