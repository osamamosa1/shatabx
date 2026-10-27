import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/params/auth_params.dart';
import '../../domain/usecases/auth_use_cases.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.useCase) : super(LoginInitial());

  final LoginUseCase useCase;

  Future<void> login(LoginParams params) async {
    emit(LoginLoading());
    final result = await useCase(params);
    result.fold(
      (failure) => emit(LoginError(failure.message ?? 'err_login')),
      (user) => emit(LoginSuccess(user)),
    );
  }
}

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  const LoginSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class LoginError extends LoginState {
  const LoginError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
