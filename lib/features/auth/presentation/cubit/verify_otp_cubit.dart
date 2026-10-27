import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/params/auth_params.dart';
import '../../domain/usecases/auth_use_cases.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit(this.verifyOtpUseCase) : super(const VerifyOtpReady(36));

  final VerifyOtpUseCase verifyOtpUseCase;
  Timer? _timer;

  void startTimer() {
    _timer?.cancel();
    emit(const VerifyOtpReady(36));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = state;
      final seconds = current is VerifyOtpReady
          ? current.secondsLeft
          : current is VerifyOtpError
          ? current.secondsLeft
          : 0;
      if (seconds <= 1) {
        timer.cancel();
        emit(const VerifyOtpReady(0));
        return;
      }
      emit(VerifyOtpReady(seconds - 1));
    });
  }

  Future<void> verify({required String email, required String code}) async {
    final seconds = _seconds;
    emit(VerifyOtpLoading(seconds));
    final result = await verifyOtpUseCase(VerifyOtpParams(email: email, code: code));
    result.fold(
      (failure) => emit(VerifyOtpError(failure.message ?? 'invalid_otp', seconds)),
      (message) => emit(VerifyOtpSuccess(message)),
    );
  }

  int get _seconds {
    final current = state;
    if (current is VerifyOtpReady) return current.secondsLeft;
    if (current is VerifyOtpLoading) return current.secondsLeft;
    if (current is VerifyOtpError) return current.secondsLeft;
    return 0;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

sealed class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object?> get props => [];
}

class VerifyOtpReady extends VerifyOtpState {
  const VerifyOtpReady(this.secondsLeft);

  final int secondsLeft;

  @override
  List<Object?> get props => [secondsLeft];
}

class VerifyOtpLoading extends VerifyOtpState {
  const VerifyOtpLoading(this.secondsLeft);

  final int secondsLeft;

  @override
  List<Object?> get props => [secondsLeft];
}

class VerifyOtpSuccess extends VerifyOtpState {
  const VerifyOtpSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class VerifyOtpError extends VerifyOtpState {
  const VerifyOtpError(this.message, this.secondsLeft);

  final String message;
  final int secondsLeft;

  @override
  List<Object?> get props => [message, secondsLeft];
}
