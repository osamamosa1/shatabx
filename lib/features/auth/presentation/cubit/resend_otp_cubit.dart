import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/auth_use_cases.dart';

class ResendOtpCubit extends Cubit<ResendOtpState> {
  ResendOtpCubit(this.useCase) : super(ResendOtpInitial());

  final ResendOtpUseCase useCase;

  Future<void> resend(String email) async {
    emit(ResendOtpLoading());
    final result = await useCase(email);
    result.fold(
      (failure) => emit(ResendOtpError(failure.message ?? 'err_resend')),
      (message) => emit(ResendOtpSuccess(message)),
    );
  }
}

sealed class ResendOtpState extends Equatable {
  const ResendOtpState();

  @override
  List<Object?> get props => [];
}

class ResendOtpInitial extends ResendOtpState {}

class ResendOtpLoading extends ResendOtpState {}

class ResendOtpSuccess extends ResendOtpState {
  const ResendOtpSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ResendOtpError extends ResendOtpState {
  const ResendOtpError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
