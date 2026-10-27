import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../params/auth_params.dart';
import '../repositories/auth_repository.dart';

class RegisterCompanyUseCase
    extends UseCase<UserEntity, RegisterCompanyParams> {
  RegisterCompanyUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserEntity>> call(RegisterCompanyParams params) {
    return repository.registerCompany(params);
  }
}

class LoginUseCase extends UseCase<UserEntity, LoginParams> {
  LoginUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.login(params);
  }
}

class VerifyOtpUseCase extends UseCase<String, VerifyOtpParams> {
  VerifyOtpUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, String>> call(VerifyOtpParams params) {
    return repository.verifyOtp(params);
  }
}

class ResendOtpUseCase extends UseCase<String, String> {
  ResendOtpUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, String>> call(String params) {
    return repository.resendOtp(params);
  }
}

class ResetPasswordUseCase extends UseCase<String, ResetPasswordParams> {
  ResetPasswordUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, String>> call(ResetPasswordParams params) {
    return repository.resetPassword(params);
  }
}

class CompleteProfileUseCase
    extends UseCase<UserEntity, CompleteProfileParams> {
  CompleteProfileUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserEntity>> call(CompleteProfileParams params) {
    return repository.completeProfile(params);
  }
}
