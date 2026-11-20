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

class GetProfileUseCase extends UseCase<UserEntity, NoParams> {
  GetProfileUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.getProfile();
  }
}

class LogoutUseCase extends UseCase<Unit, NoParams> {
  LogoutUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.logout();
  }
}

class UpdatePasswordUseCase extends UseCase<String, UpdatePasswordParams> {
  UpdatePasswordUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, String>> call(UpdatePasswordParams params) {
    return repository.updatePassword(params);
  }
}

class UpdateEmailUseCase extends UseCase<UserEntity, UpdateEmailParams> {
  UpdateEmailUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserEntity>> call(UpdateEmailParams params) {
    return repository.updateEmail(params);
  }
}

class SetNotificationsEnabledUseCase extends UseCase<Unit, bool> {
  SetNotificationsEnabledUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, Unit>> call(bool params) {
    return repository.setNotificationsEnabled(params);
  }
}

class DeleteAccountUseCase extends UseCase<Unit, NoParams> {
  DeleteAccountUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.deleteAccount();
  }
}
