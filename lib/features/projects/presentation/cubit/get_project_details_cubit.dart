import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/project_use_cases.dart';

class GetProjectDetailsCubit extends Cubit<GetProjectDetailsState> {
  GetProjectDetailsCubit(this.useCase) : super(GetProjectDetailsInitial());

  final GetProjectDetailsUseCase useCase;

  Future<void> load(String id) async {
    emit(GetProjectDetailsLoading());
    final result = await useCase(id);
    result.fold(
      (failure) => emit(GetProjectDetailsError(failure.message ?? 'err_project')),
      (project) => emit(GetProjectDetailsLoaded(project)),
    );
  }
}

sealed class GetProjectDetailsState extends Equatable {
  const GetProjectDetailsState();

  @override
  List<Object?> get props => [];
}

class GetProjectDetailsInitial extends GetProjectDetailsState {}

class GetProjectDetailsLoading extends GetProjectDetailsState {}

class GetProjectDetailsLoaded extends GetProjectDetailsState {
  const GetProjectDetailsLoaded(this.project);

  final ProjectEntity project;

  @override
  List<Object?> get props => [project];
}

class GetProjectDetailsError extends GetProjectDetailsState {
  const GetProjectDetailsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
