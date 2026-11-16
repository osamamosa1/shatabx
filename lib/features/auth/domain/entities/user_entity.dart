import 'package:equatable/equatable.dart';

enum AccountRole { company, engineer }

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.username,
    this.companyName,
    this.address,
    this.logo,
    this.seal,
    this.commercialRegister,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final AccountRole role;
  final String? username;
  final String? companyName;
  final String? address;
  final String? logo;
  final String? seal;
  final String? commercialRegister;

  String get displayName =>
      role == AccountRole.company ? (companyName ?? name) : name;

  UserEntity copyWith({
    String? name,
    String? phone,
    String? companyName,
    String? address,
    String? logo,
    String? seal,
    String? commercialRegister,
    String? username,
  }) {
    return UserEntity(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      role: role,
      username: username ?? this.username,
      companyName: companyName ?? this.companyName,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      seal: seal ?? this.seal,
      commercialRegister: commercialRegister ?? this.commercialRegister,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role.name,
        'username': username,
        'companyName': companyName,
        'address': address,
        'logo': logo,
        'seal': seal,
        'commercialRegister': commercialRegister,
      };

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    final roleRaw = json['role']?.toString();
    final role = AccountRole.values.firstWhere(
      (item) => item.name == roleRaw,
      orElse: () => AccountRole.company,
    );
    return UserEntity(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ??
          json['owner_company_name'] as String? ??
          json['username'] as String? ??
          '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: role,
      username: json['username'] as String?,
      companyName:
          json['companyName'] as String? ?? json['company_name'] as String?,
      address: json['address'] as String?,
      logo: json['logo'] as String?,
      seal: json['seal'] as String?,
      commercialRegister: json['commercialRegister'] as String? ??
          json['commercial_register'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        role,
        username,
        companyName,
        address,
        logo,
        seal,
        commercialRegister,
      ];
}
