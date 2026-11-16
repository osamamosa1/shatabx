import 'package:dartz/dartz.dart';

import '../../../../core/api/dio_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/workspace_entities.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../datasources/workspace_remote_data_source.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  WorkspaceRepositoryImpl(this.remote, this.client);

  final WorkspaceRemoteDataSource remote;
  final DioConsumer client;

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      return Right(await remote.getNotifications());
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getReports() async {
    try {
      return Right(await remote.getReports());
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, ReportEntity>> getReport(String id) async {
    try {
      return Right(await remote.getReport(id));
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, List<InspectionTemplateEntity>>> getTemplates() async {
    try {
      return Right(await remote.getTemplates());
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, InspectionTemplateEntity>> getTemplate(
    String id,
  ) async {
    try {
      return Right(await remote.getTemplate(id));
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, InspectionTemplateEntity>> createTemplate({
    required String name,
    required String category,
  }) async {
    try {
      return Right(
        await remote.createTemplate(name: name, category: category),
      );
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearNotifications() async {
    try {
      final notes = await remote.getNotifications();
      for (final note in notes) {
        try {
          await client.delete(EndPoints.note(note.id));
        } catch (_) {}
      }
      return const Right(unit);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> markNotificationRead(String id) async {
    try {
      await client.post(EndPoints.noteChange(id));
      return const Right(unit);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitInspectionNote(String note) async {
    try {
      await remote.submitInspectionNote(note);
      return const Right(unit);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }
}
