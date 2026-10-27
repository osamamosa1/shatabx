import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../params/auth_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> registerCompany(RegisterCompanyParams params);
  Future<Either<Failure, UserEntity>> login(LoginParams params);
  Future<Either<Failure, String>> verifyOtp(VerifyOtpParams params);
  Future<Either<Failure, String>> resendOtp(String email);
  Future<Either<Failure, String>> resetPassword(ResetPasswordParams params);
  Future<Either<Failure, UserEntity>> completeProfile(CompleteProfileParams params);
}
