import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/project_entity.dart';
import '../params/create_project_params.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUseCase extends UseCase<List<ProjectEntity>, NoParams> {
  GetProjectsUseCase(this.repository);

  final ProjectsRepository repository;

  @override
  Future<Either<Failure, List<ProjectEntity>>> call(NoParams params) {
    return repository.getProjects();
  }
}

class GetProjectDetailsUseCase extends UseCase<ProjectEntity, String> {
  GetProjectDetailsUseCase(this.repository);

  final ProjectsRepository repository;

  @override
  Future<Either<Failure, ProjectEntity>> call(String params) {
    return repository.getProject(params);
  }
}

class CreateProjectUseCase
    extends UseCase<ProjectEntity, CreateProjectParams> {
  CreateProjectUseCase(this.repository);

  final ProjectsRepository repository;

  @override
  Future<Either<Failure, ProjectEntity>> call(CreateProjectParams params) {
    return repository.createProject(params);
  }
}
