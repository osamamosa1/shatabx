import 'package:flutter/widgets.dart';

import '../../config/locale/app_localizations.dart';

String resolveErrorMessage(BuildContext context, String? message) {
  if (message == null || message.trim().isEmpty) {
    return context.tr('unexpected_error');
  }
  final key = message.trim();
  final translated = context.tr(key);
  if (translated != key) return translated;
  return key;
}
