import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/project_entity.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();
  Future<Either<Failure, ProjectEntity>> getProject(String id);
}
