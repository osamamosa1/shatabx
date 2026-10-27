import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/params/auth_params.dart';
import '../../domain/usecases/auth_use_cases.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this.useCase) : super(ResetPasswordInitial());

  final ResetPasswordUseCase useCase;

  Future<void> submit(ResetPasswordParams params) async {
    emit(ResetPasswordLoading());
    final result = await useCase(params);
    result.fold(
      (failure) => emit(ResetPasswordError(failure.message ?? 'err_reset')),
      (message) => emit(ResetPasswordSuccess(message)),
    );
  }
}

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  const ResetPasswordSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ResetPasswordError extends ResetPasswordState {
  const ResetPasswordError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
