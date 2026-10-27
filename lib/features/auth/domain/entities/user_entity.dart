import 'package:equatable/equatable.dart';

enum AccountRole { company, engineer }

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.companyName,
    this.address,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final AccountRole role;
  final String? companyName;
  final String? address;

  String get displayName =>
      role == AccountRole.company ? (companyName ?? name) : name;

  UserEntity copyWith({
    String? name,
    String? phone,
    String? companyName,
    String? address,
  }) {
    return UserEntity(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      role: role,
      companyName: companyName ?? this.companyName,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role.name,
    'companyName': companyName,
    'address': address,
  };

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: AccountRole.values.byName(json['role'] as String),
      companyName: json['companyName'] as String?,
      address: json['address'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, role, companyName, address];
}
