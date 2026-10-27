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
  });

  final String companyName;
  final String ownerName;
  final String phone;
  final String email;
  final String password;
  final bool acceptedTerms;

  @override
  List<Object?> get props => [
    companyName,
    ownerName,
    phone,
    email,
    password,
    acceptedTerms,
  ];
}

class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
    required this.role,
  });

  final String email;
  final String password;
  final AccountRole role;

  @override
  List<Object?> get props => [email, password, role];
}

class VerifyOtpParams extends Equatable {
  const VerifyOtpParams({required this.email, required this.code});

  final String email;
  final String code;

  @override
  List<Object?> get props => [email, code];
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
  });

  final String address;
  final String? companyImageName;
  final String? stampName;

  @override
  List<Object?> get props => [address, companyImageName, stampName];
}
