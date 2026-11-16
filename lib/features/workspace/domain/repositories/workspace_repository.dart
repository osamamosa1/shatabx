import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/workspace_entities.dart';
// Unit comes from dartz.

abstract class WorkspaceRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, List<ReportEntity>>> getReports();
  Future<Either<Failure, ReportEntity>> getReport(String id);
  Future<Either<Failure, List<InspectionTemplateEntity>>> getTemplates();
  Future<Either<Failure, InspectionTemplateEntity>> getTemplate(String id);
  Future<Either<Failure, InspectionTemplateEntity>> createTemplate({
    required String name,
    required String category,
  });
  Future<Either<Failure, Unit>> clearNotifications();
  Future<Either<Failure, Unit>> markNotificationRead(String id);
  Future<Either<Failure, Unit>> submitInspectionNote(String note);
}
