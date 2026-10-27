import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/auth/domain/entities/user_entity.dart';

abstract class AppSharedPreferences {
  bool get onboardingSeen;
  Future<void> setOnboardingSeen(bool value);

  UserEntity? get user;
  Future<void> saveUser(UserEntity user);
  Future<void> clearUser();

  String get languageCode;
  Future<void> saveLanguageCode(String code);
}

class AppSharedPreferencesImpl implements AppSharedPreferences {
  AppSharedPreferencesImpl(this.instance);

  final SharedPreferences instance;

  static const _onboarding = 'onboarding_seen';
  static const _user = 'user';
  static const _language = 'language_code';

  @override
  bool get onboardingSeen => instance.getBool(_onboarding) ?? false;

  @override
  Future<void> setOnboardingSeen(bool value) =>
      instance.setBool(_onboarding, value);

  @override
  UserEntity? get user {
    final raw = instance.getString(_user);
    if (raw == null || raw.isEmpty) return null;
    return UserEntity.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> saveUser(UserEntity user) =>
      instance.setString(_user, jsonEncode(user.toJson()));

  @override
  Future<void> clearUser() => instance.remove(_user);

  @override
  String get languageCode => instance.getString(_language) ?? 'ar';

  @override
  Future<void> saveLanguageCode(String code) =>
      instance.setString(_language, code);
}
