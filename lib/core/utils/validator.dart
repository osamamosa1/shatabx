import 'package:flutter/widgets.dart';

import '../../config/locale/app_localizations.dart';

abstract class Validator {
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? requiredField(
    BuildContext context,
    String? value, {
    required String label,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$label ${context.tr('field_required')}';
    }
    return null;
  }

  static String? email(BuildContext context, String? value) {
    final requiredError = requiredField(context, value, label: context.tr('email'));
    if (requiredError != null) return requiredError;
    if (!_email.hasMatch(value!.trim())) return context.tr('invalid_email');
    return null;
  }

  static String? phone(BuildContext context, String? value) {
    final requiredError = requiredField(context, value, label: context.tr('phone'));
    if (requiredError != null) return requiredError;
    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) return context.tr('phone_short');
    return null;
  }

  static String? password(BuildContext context, String? value) {
    final requiredError = requiredField(
      context,
      value,
      label: context.tr('password'),
    );
    if (requiredError != null) return requiredError;
    if (value!.trim().length < 6) return context.tr('password_short');
    return null;
  }

  static String? confirmPassword(
    BuildContext context,
    String? value,
    String original,
  ) {
    final requiredError = requiredField(
      context,
      value,
      label: context.tr('confirm_password'),
    );
    if (requiredError != null) return requiredError;
    if (value!.trim() != original.trim()) return context.tr('password_mismatch');
    return null;
  }
}
