import '../../domain/entities/user_entity.dart';

class UserModel {
  const UserModel._();

  static UserEntity fromAuthPayload(
    Map<String, dynamic> payload, {
    AccountRole? fallbackRole,
  }) {
    final nested = payload['data'];
    final userMap = nested is Map
        ? Map<String, dynamic>.from(nested)
        : Map<String, dynamic>.from(payload);

    final type = userMap['type']?.toString().toLowerCase();
    final role = switch (type) {
      'engineer' => AccountRole.engineer,
      'company' => AccountRole.company,
      _ => fallbackRole ?? AccountRole.company,
    };

    return UserEntity(
      id: userMap['id']?.toString() ?? '',
      username: userMap['username']?.toString(),
      name: userMap['owner_company_name']?.toString() ??
          userMap['name']?.toString() ??
          userMap['username']?.toString() ??
          '',
      email: userMap['email']?.toString() ?? '',
      phone: userMap['phone']?.toString() ?? '',
      role: role,
      companyName: userMap['company_name']?.toString(),
      address: userMap['address']?.toString(),
      logo: userMap['logo']?.toString(),
      seal: userMap['seal']?.toString(),
      commercialRegister: userMap['commercial_register']?.toString(),
    );
  }

  static String? tokenOf(Map<String, dynamic> payload) {
    final direct = payload['token']?.toString();
    if (direct != null && direct.isNotEmpty) return direct;
    final nested = payload['data'];
    if (nested is Map && nested['token'] != null) {
      return nested['token'].toString();
    }
    return null;
  }
}
