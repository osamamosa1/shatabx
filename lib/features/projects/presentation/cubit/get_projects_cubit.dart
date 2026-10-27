import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/project_use_cases.dart';

class GetProjectsCubit extends Cubit<GetProjectsState> {
  GetProjectsCubit(this.useCase) : super(GetProjectsInitial());

  final GetProjectsUseCase useCase;

  Future<void> load() async {
    emit(GetProjectsLoading());
    final result = await useCase(const NoParams());
    result.fold(
      (failure) => emit(GetProjectsError(failure.message ?? 'err_projects')),
      (projects) => emit(GetProjectsLoaded(projects)),
    );
  }
}

sealed class GetProjectsState extends Equatable {
  const GetProjectsState();

  @override
  List<Object?> get props => [];
}

class GetProjectsInitial extends GetProjectsState {}

class GetProjectsLoading extends GetProjectsState {}

class GetProjectsLoaded extends GetProjectsState {
  const GetProjectsLoaded(this.projects);

  final List<ProjectEntity> projects;

  @override
  List<Object?> get props => [projects];
}

class GetProjectsError extends GetProjectsState {
  const GetProjectsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
