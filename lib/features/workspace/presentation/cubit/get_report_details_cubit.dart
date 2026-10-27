import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/workspace_entities.dart';
import '../../domain/usecases/workspace_use_cases.dart';

class GetReportDetailsCubit extends Cubit<GetReportDetailsState> {
  GetReportDetailsCubit(this.useCase) : super(GetReportDetailsInitial());

  final GetReportDetailsUseCase useCase;

  Future<void> load(String id) async {
    emit(GetReportDetailsLoading());
    final result = await useCase(id);
    result.fold(
      (failure) => emit(GetReportDetailsError(failure.message ?? 'err_report')),
      (report) => emit(GetReportDetailsLoaded(report)),
    );
  }
}

sealed class GetReportDetailsState extends Equatable {
  const GetReportDetailsState();
  @override
  List<Object?> get props => [];
}

class GetReportDetailsInitial extends GetReportDetailsState {}

class GetReportDetailsLoading extends GetReportDetailsState {}

class GetReportDetailsLoaded extends GetReportDetailsState {
  const GetReportDetailsLoaded(this.report);
  final ReportEntity report;
  @override
  List<Object?> get props => [report];
}

class GetReportDetailsError extends GetReportDetailsState {
  const GetReportDetailsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
