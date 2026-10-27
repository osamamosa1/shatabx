import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/local_storage/app_shared_preferences.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/params/auth_params.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.preferences);

  final AppSharedPreferences preferences;

  static const demoOtp = '5555';

  @override
  Future<Either<Failure, UserEntity>> registerCompany(
    RegisterCompanyParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!params.acceptedTerms) {
      return const Left(ValidationFailure(message: 'must_accept_terms'));
    }
    final user = UserEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: params.ownerName.trim(),
      email: params.email.trim(),
      phone: params.phone.trim(),
      role: AccountRole.company,
      companyName: params.companyName.trim(),
    );
    return Right(user);
  }

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (params.password.trim().length < 6) {
      return const Left(ValidationFailure(message: 'invalid_credentials'));
    }
    final existing = preferences.user;
    final english = preferences.languageCode == 'en';
    final user = UserEntity(
      id: existing?.id ?? 'user-1',
      name: existing?.name ??
          (params.role == AccountRole.engineer
              ? (english ? 'Eng. Abdullah Alharbi' : 'م. عبدالله الحربي')
              : (english ? 'Abdullah Alharbi' : 'عبدالله الحربي')),
      email: params.email.trim(),
      phone: existing?.phone ?? '10102548963',
      role: params.role,
      companyName: existing?.companyName ??
          (params.role == AccountRole.company
              ? (english ? 'Al Itqan Contracting' : 'شركة الإتقان للمقاولات')
              : null),
      address: existing?.address,
    );
    await preferences.saveUser(user);
    return Right(user);
  }

  @override
  Future<Either<Failure, String>> verifyOtp(VerifyOtpParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (params.code.trim() != demoOtp) {
      return const Left(ValidationFailure(message: 'invalid_otp'));
    }
    return const Right('otp_verified');
  }

  @override
  Future<Either<Failure, String>> resendOtp(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const Right('otp_resent');
  }

  @override
  Future<Either<Failure, String>> resetPassword(
    ResetPasswordParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const Right('password_updated');
  }

  @override
  Future<Either<Failure, UserEntity>> completeProfile(
    CompleteProfileParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final current = preferences.user;
    if (current == null) {
      return const Left(CacheFailure(message: 'no_session'));
    }
    final updated = current.copyWith(address: params.address.trim());
    await preferences.saveUser(updated);
    return Right(updated);
  }
}
