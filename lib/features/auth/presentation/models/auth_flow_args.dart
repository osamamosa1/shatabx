class OtpArgs {
  const OtpArgs({
    required this.email,
    required this.purpose,
    this.pendingUser,
    this.role,
  });

  final String email;
  final OtpPurpose purpose;
  final dynamic pendingUser;
  final String? role;
}

enum OtpPurpose { register, resetPassword }
