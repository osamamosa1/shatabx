import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/workspace_entities.dart';
import '../../domain/usecases/workspace_use_cases.dart';

class GetReportsCubit extends Cubit<GetReportsState> {
  GetReportsCubit(this.useCase) : super(GetReportsInitial());

  final GetReportsUseCase useCase;

  Future<void> load() async {
    emit(GetReportsLoading());
    final result = await useCase(const NoParams());
    result.fold(
      (failure) => emit(GetReportsError(failure.message ?? 'err_reports')),
      (items) => emit(GetReportsLoaded(items)),
    );
  }
}

sealed class GetReportsState extends Equatable {
  const GetReportsState();
  @override
  List<Object?> get props => [];
}

class GetReportsInitial extends GetReportsState {}

class GetReportsLoading extends GetReportsState {}

class GetReportsLoaded extends GetReportsState {
  const GetReportsLoaded(this.items);
  final List<ReportEntity> items;
  @override
  List<Object?> get props => [items];
}

class GetReportsError extends GetReportsState {
  const GetReportsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
