import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/workspace_entities.dart';
import '../../domain/usecases/workspace_use_cases.dart';

class GetInspectionTemplatesCubit extends Cubit<GetInspectionTemplatesState> {
  GetInspectionTemplatesCubit(this.useCase) : super(GetInspectionTemplatesInitial());

  final GetInspectionTemplatesUseCase useCase;

  Future<void> load() async {
    emit(GetInspectionTemplatesLoading());
    final result = await useCase(const NoParams());
    result.fold(
      (failure) => emit(
        GetInspectionTemplatesError(failure.message ?? 'err_templates'),
      ),
      (items) => emit(GetInspectionTemplatesLoaded(items)),
    );
  }
}

sealed class GetInspectionTemplatesState extends Equatable {
  const GetInspectionTemplatesState();
  @override
  List<Object?> get props => [];
}

class GetInspectionTemplatesInitial extends GetInspectionTemplatesState {}

class GetInspectionTemplatesLoading extends GetInspectionTemplatesState {}

class GetInspectionTemplatesLoaded extends GetInspectionTemplatesState {
  const GetInspectionTemplatesLoaded(this.items);
  final List<InspectionTemplateEntity> items;
  @override
  List<Object?> get props => [items];
}

class GetInspectionTemplatesError extends GetInspectionTemplatesState {
  const GetInspectionTemplatesError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
