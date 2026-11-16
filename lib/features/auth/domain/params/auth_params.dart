import 'package:equatable/equatable.dart';

import '../entities/user_entity.dart';

enum JoinMethod { newCompany, registeredCompany }

class RegisterCompanyParams extends Equatable {
  const RegisterCompanyParams({
    required this.companyName,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.password,
    required this.acceptedTerms,
    this.username,
    this.packageId = 3,
    this.type = 'company',
  });

  final String companyName;
  final String ownerName;
  final String phone;
  final String email;
  final String password;
  final bool acceptedTerms;
  final String? username;
  final int packageId;
  final String type;

  String get resolvedUsername {
    final custom = username?.trim();
    if (custom != null && custom.isNotEmpty) return custom;
    final local = email.trim().split('@').first;
    return local.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
  }

  @override
  List<Object?> get props => [
        companyName,
        ownerName,
        phone,
        email,
        password,
        acceptedTerms,
        username,
        packageId,
        type,
      ];
}

class LoginParams extends Equatable {
  const LoginParams({
    required this.username,
    required this.password,
    required this.role,
    this.fcmToken,
  });

  final String username;
  final String password;
  final AccountRole role;
  final String? fcmToken;

  @override
  List<Object?> get props => [username, password, role, fcmToken];
}

class VerifyOtpParams extends Equatable {
  const VerifyOtpParams({
    required this.email,
    required this.code,
    this.purpose = 'verify_join',
  });

  final String email;
  final String code;
  final String purpose;

  @override
  List<Object?> get props => [email, code, purpose];
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class CompleteProfileParams extends Equatable {
  const CompleteProfileParams({
    required this.address,
    this.companyImageName,
    this.stampName,
    this.companyName,
    this.ownerName,
    this.phone,
    this.lat,
    this.lng,
    this.commercialRegister,
  });

  final String address;
  final String? companyImageName;
  final String? stampName;
  final String? companyName;
  final String? ownerName;
  final String? phone;
  final String? lat;
  final String? lng;
  final String? commercialRegister;

  @override
  List<Object?> get props => [
        address,
        companyImageName,
        stampName,
        companyName,
        ownerName,
        phone,
        lat,
        lng,
        commercialRegister,
      ];
}
