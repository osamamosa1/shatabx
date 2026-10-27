import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/params/auth_params.dart';
import '../../domain/usecases/auth_use_cases.dart';

class RegisterCompanyCubit extends Cubit<RegisterCompanyState> {
  RegisterCompanyCubit(this.useCase) : super(RegisterCompanyInitial());

  final RegisterCompanyUseCase useCase;

  Future<void> submit(RegisterCompanyParams params) async {
    emit(RegisterCompanyLoading());
    final result = await useCase(params);
    result.fold(
      (failure) => emit(RegisterCompanyError(failure.message ?? 'err_register')),
      (user) => emit(RegisterCompanySuccess(user)),
    );
  }
}

sealed class RegisterCompanyState extends Equatable {
  const RegisterCompanyState();

  @override
  List<Object?> get props => [];
}

class RegisterCompanyInitial extends RegisterCompanyState {}

class RegisterCompanyLoading extends RegisterCompanyState {}

class RegisterCompanySuccess extends RegisterCompanyState {
  const RegisterCompanySuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class RegisterCompanyError extends RegisterCompanyState {
  const RegisterCompanyError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
