import 'package:dio/dio.dart';

import '../../../../core/api/api_response.dart';
import '../../../../core/api/dio_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/params/auth_params.dart';
import '../models/user_model.dart';

class AuthSessionResult {
  const AuthSessionResult({required this.user, this.token});

  final UserEntity user;
  final String? token;
}

abstract class AuthRemoteDataSource {
  Future<AuthSessionResult> login(LoginParams params);
  Future<UserEntity> registerCompany(RegisterCompanyParams params);
  Future<String> verifyOtp(VerifyOtpParams params);
  Future<String> resendOtp(String email);
  Future<String> resetPasswordRequest(String email);
  Future<String> changePassword(ResetPasswordParams params);
  Future<String> updatePassword(UpdatePasswordParams params);
  Future<UserEntity> updateEmail(UpdateEmailParams params);
  Future<void> setNotificationsEnabled(bool enabled);
  Future<void> deleteAccount();
  Future<UserEntity> getProfile({AccountRole? fallbackRole});
  Future<UserEntity> editProfile(CompleteProfileParams params);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this.client);

  final DioConsumer client;

  @override
  Future<AuthSessionResult> login(LoginParams params) async {
    final raw = await client.post(
      EndPoints.login,
      body: <String, dynamic>{
        'username': params.username.trim(),
        'password': params.password,
        if (params.fcmToken != null && params.fcmToken!.isNotEmpty)
          'fcm_token': params.fcmToken,
      },
    );
    final response = ApiResponse.from(raw);
    final payload = response.dataMap ?? <String, dynamic>{};
    final user = UserModel.fromAuthPayload(
      payload,
      fallbackRole: params.role,
    );
    return AuthSessionResult(user: user, token: UserModel.tokenOf(payload));
  }

  @override
  Future<UserEntity> registerCompany(RegisterCompanyParams params) async {
    final raw = await client.post(
      EndPoints.register,
      body: <String, dynamic>{
        'username': params.resolvedUsername,
        'email': params.email.trim(),
        'phone': params.phone.trim(),
        'password': params.password,
        'password_confirmation': params.password,
        'company_name': params.companyName.trim(),
        'owner_company_name': params.ownerName.trim(),
        'package_id': params.packageId,
        'type': params.type,
      },
    );
    final response = ApiResponse.from(raw);
    final map = response.dataMap ?? <String, dynamic>{};
    return UserModel.fromAuthPayload(map, fallbackRole: AccountRole.company);
  }

  @override
  Future<String> verifyOtp(VerifyOtpParams params) async {
    final raw = await client.post(
      EndPoints.verifyOtp,
      body: <String, dynamic>{
        'email': params.email.trim(),
        'code': params.code.trim(),
        'purpose': params.purpose,
      },
    );
    return ApiResponse.from(raw).message ?? 'otp_verified';
  }

  @override
  Future<String> resendOtp(String email) async {
    final raw = await client.post(
      EndPoints.resendOtp,
      body: <String, dynamic>{'email': email.trim()},
    );
    return ApiResponse.from(raw).message ?? 'otp_resent';
  }

  @override
  Future<String> resetPasswordRequest(String email) async {
    final raw = await client.post(
      EndPoints.resetPassword,
      body: <String, dynamic>{'email': email.trim()},
    );
    return ApiResponse.from(raw).message ?? 'otp_sent';
  }

  @override
  Future<String> changePassword(ResetPasswordParams params) async {
    final raw = await client.post(
      EndPoints.changePassword,
      body: <String, dynamic>{
        'email': params.email.trim(),
        'password': params.password,
        'password_confirmation': params.password,
      },
    );
    return ApiResponse.from(raw).message ?? 'password_updated';
  }

  @override
  Future<String> updatePassword(UpdatePasswordParams params) async {
    try {
      final raw = await client.post(
        EndPoints.appChangePassword,
        body: <String, dynamic>{
          if (params.oldPassword != null && params.oldPassword!.isNotEmpty)
            'old_password': params.oldPassword,
          'password': params.password,
          'password_confirmation': params.password,
        },
      );
      return ApiResponse.from(raw).message ?? 'password_updated';
    } catch (_) {
      final raw = await client.post(
        EndPoints.changePassword,
        body: <String, dynamic>{
          'email': params.email.trim(),
          'password': params.password,
          'password_confirmation': params.password,
        },
      );
      return ApiResponse.from(raw).message ?? 'password_updated';
    }
  }

  @override
  Future<UserEntity> updateEmail(UpdateEmailParams params) async {
    try {
      final raw = await client.post(
        EndPoints.appChangeEmail,
        body: <String, dynamic>{
          'email': params.email.trim(),
          if (params.password != null && params.password!.isNotEmpty)
            'password': params.password,
        },
      );
      final map = ApiResponse.from(raw).dataMap;
      if (map != null) return UserModel.fromAuthPayload(map);
    } catch (_) {}
    return editProfile(
      CompleteProfileParams(
        address: '',
        email: params.email.trim(),
      ),
    );
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      await client.post(
        EndPoints.appChangeNotification,
        body: <String, dynamic>{
          'avaliable_notification': enabled ? 1 : 0,
          'available_notification': enabled ? 1 : 0,
        },
      );
    } catch (_) {
      // Live Dashboard may not expose this App route yet.
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await client.post(EndPoints.appDeleteAccount);
      return;
    } catch (_) {}
    throw const ServerException(
      message: 'حذف الحساب غير متاح على السيرفر الحالي',
    );
  }

  @override
  Future<UserEntity> getProfile({AccountRole? fallbackRole}) async {
    try {
      final raw = await client.get(EndPoints.getProfile);
      final response = ApiResponse.from(raw);
      final map = response.dataMap ?? <String, dynamic>{};
      return UserModel.fromAuthPayload(map, fallbackRole: fallbackRole);
    } catch (_) {
      final raw = await client.get(EndPoints.appProfile);
      final response = ApiResponse.from(raw);
      final map = response.dataMap ?? <String, dynamic>{};
      return UserModel.fromAuthPayload(map, fallbackRole: fallbackRole);
    }
  }

  @override
  Future<UserEntity> editProfile(CompleteProfileParams params) async {
    final map = <String, dynamic>{
      if (params.address.trim().isNotEmpty) 'address': params.address.trim(),
      if (params.companyName != null) 'company_name': params.companyName,
      if (params.ownerName != null) 'owner_company_name': params.ownerName,
      if (params.phone != null) 'phone': params.phone,
      if (params.email != null) 'email': params.email,
      if (params.username != null) 'username': params.username,
      if (params.lat != null) 'lat': params.lat,
      if (params.lng != null) 'lng': params.lng,
      if (params.commercialRegister != null)
        'commercial_register': params.commercialRegister,
    };
    try {
      final raw = await client.post(
        EndPoints.editProfile,
        formData: FormData.fromMap(map),
      );
      final response = ApiResponse.from(raw);
      final data = response.dataMap ?? <String, dynamic>{};
      if (data.isNotEmpty) {
        return UserModel.fromAuthPayload(data);
      }
    } catch (_) {}
    final raw = await client.post(
      EndPoints.appEditProfile,
      formData: FormData.fromMap(map),
    );
    final response = ApiResponse.from(raw);
    final data = response.dataMap ?? <String, dynamic>{};
    if (data.isEmpty) {
      throw const ServerException(message: 'تعذر تحديث الملف الشخصي');
    }
    return UserModel.fromAuthPayload(data);
  }

  @override
  Future<void> logout() async {
    await client.post(EndPoints.logout);
  }
}
