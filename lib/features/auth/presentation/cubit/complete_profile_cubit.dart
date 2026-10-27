import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/params/auth_params.dart';
import '../../domain/usecases/auth_use_cases.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  CompleteProfileCubit(this.useCase) : super(CompleteProfileInitial());

  final CompleteProfileUseCase useCase;

  Future<void> save(CompleteProfileParams params) async {
    emit(CompleteProfileLoading());
    final result = await useCase(params);
    result.fold(
      (failure) => emit(CompleteProfileError(failure.message ?? 'err_save')),
      (user) => emit(CompleteProfileSuccess(user)),
    );
  }
}

sealed class CompleteProfileState extends Equatable {
  const CompleteProfileState();

  @override
  List<Object?> get props => [];
}

class CompleteProfileInitial extends CompleteProfileState {}

class CompleteProfileLoading extends CompleteProfileState {}

class CompleteProfileSuccess extends CompleteProfileState {
  const CompleteProfileSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class CompleteProfileError extends CompleteProfileState {
  const CompleteProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
