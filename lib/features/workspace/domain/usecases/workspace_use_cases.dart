import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/workspace_entities.dart';
import '../repositories/workspace_repository.dart';

class GetNotificationsUseCase extends UseCase<List<NotificationEntity>, NoParams> {
  GetNotificationsUseCase(this.repository);
  final WorkspaceRepository repository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(NoParams params) {
    return repository.getNotifications();
  }
}

class GetReportsUseCase extends UseCase<List<ReportEntity>, NoParams> {
  GetReportsUseCase(this.repository);
  final WorkspaceRepository repository;

  @override
  Future<Either<Failure, List<ReportEntity>>> call(NoParams params) {
    return repository.getReports();
  }
}

class GetReportDetailsUseCase extends UseCase<ReportEntity, String> {
  GetReportDetailsUseCase(this.repository);
  final WorkspaceRepository repository;

  @override
  Future<Either<Failure, ReportEntity>> call(String params) {
    return repository.getReport(params);
  }
}

class GetInspectionTemplatesUseCase
    extends UseCase<List<InspectionTemplateEntity>, NoParams> {
  GetInspectionTemplatesUseCase(this.repository);
  final WorkspaceRepository repository;

  @override
  Future<Either<Failure, List<InspectionTemplateEntity>>> call(NoParams params) {
    return repository.getTemplates();
  }
}

class GetInspectionTemplateDetailsUseCase
    extends UseCase<InspectionTemplateEntity, String> {
  GetInspectionTemplateDetailsUseCase(this.repository);
  final WorkspaceRepository repository;

  @override
  Future<Either<Failure, InspectionTemplateEntity>> call(String params) {
    return repository.getTemplate(params);
  }
}
