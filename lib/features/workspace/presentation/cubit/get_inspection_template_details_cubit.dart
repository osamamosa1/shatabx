import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/workspace_entities.dart';
import '../../domain/usecases/workspace_use_cases.dart';

class GetInspectionTemplateDetailsCubit
    extends Cubit<GetInspectionTemplateDetailsState> {
  GetInspectionTemplateDetailsCubit(this.useCase)
    : super(GetInspectionTemplateDetailsInitial());

  final GetInspectionTemplateDetailsUseCase useCase;

  Future<void> load(String id) async {
    emit(GetInspectionTemplateDetailsLoading());
    final result = await useCase(id);
    result.fold(
      (failure) => emit(
        GetInspectionTemplateDetailsError(failure.message ?? 'err_template'),
      ),
      (template) => emit(GetInspectionTemplateDetailsLoaded(template)),
    );
  }
}

sealed class GetInspectionTemplateDetailsState extends Equatable {
  const GetInspectionTemplateDetailsState();
  @override
  List<Object?> get props => [];
}

class GetInspectionTemplateDetailsInitial extends GetInspectionTemplateDetailsState {}

class GetInspectionTemplateDetailsLoading extends GetInspectionTemplateDetailsState {}

class GetInspectionTemplateDetailsLoaded extends GetInspectionTemplateDetailsState {
  const GetInspectionTemplateDetailsLoaded(this.template);
  final InspectionTemplateEntity template;
  @override
  List<Object?> get props => [template];
}

class GetInspectionTemplateDetailsError extends GetInspectionTemplateDetailsState {
  const GetInspectionTemplateDetailsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
