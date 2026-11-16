import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/local_storage/app_shared_preferences.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/params/auth_params.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.remote, this.preferences);

  final AuthRemoteDataSource remote;
  final AppSharedPreferences preferences;

  @override
  Future<Either<Failure, UserEntity>> registerCompany(
    RegisterCompanyParams params,
  ) async {
    try {
      if (!params.acceptedTerms) {
        return const Left(ValidationFailure(message: 'must_accept_terms'));
      }
      final user = await remote.registerCompany(params);
      return Right(user);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) async {
    try {
      final session = await remote.login(params);
      if (session.token != null && session.token!.isNotEmpty) {
        await preferences.saveToken(session.token!);
      }
      await preferences.saveUser(session.user);
      return Right(session.user);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp(VerifyOtpParams params) async {
    try {
      return Right(await remote.verifyOtp(params));
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, String>> resendOtp(String email) async {
    try {
      return Right(await remote.resendOtp(email));
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword(
    ResetPasswordParams params,
  ) async {
    try {
      await remote.resetPasswordRequest(params.email);
      return Right(await remote.changePassword(params));
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> completeProfile(
    CompleteProfileParams params,
  ) async {
    try {
      final current = preferences.user;
      final enriched = CompleteProfileParams(
        address: params.address,
        companyImageName: params.companyImageName,
        stampName: params.stampName,
        companyName: params.companyName ?? current?.companyName,
        ownerName: params.ownerName ?? current?.name,
        phone: params.phone ?? current?.phone,
        lat: params.lat,
        lng: params.lng,
        commercialRegister: params.commercialRegister,
      );
      final user = await remote.editProfile(enriched);
      await preferences.saveUser(user);
      return Right(user);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final user = await remote.getProfile(
        fallbackRole: preferences.user?.role,
      );
      await preferences.saveUser(user);
      return Right(user);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      if (preferences.token != null) {
        try {
          await remote.logout();
        } catch (_) {}
      }
      await preferences.clearSession();
      return const Right(unit);
    } catch (error) {
      await preferences.clearSession();
      return Left(mapExceptionToFailure(error));
    }
  }
}
