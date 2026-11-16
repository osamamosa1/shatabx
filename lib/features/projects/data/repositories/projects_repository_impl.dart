import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/params/create_project_params.dart';
import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_remote_data_source.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  ProjectsRepositoryImpl(this.remote);

  final ProjectsRemoteDataSource remote;

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    try {
      return Right(await remote.getProjects());
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProject(String id) async {
    try {
      return Right(await remote.getProject(id));
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> createProject(
    CreateProjectParams params,
  ) async {
    try {
      return Right(await remote.createProject(params));
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }
}
