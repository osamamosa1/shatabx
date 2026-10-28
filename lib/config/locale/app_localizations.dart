import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class L10n {
  const L10n(this.ar, this.en);

  final String ar;
  final String en;

  String tr(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return code == 'en' ? en : ar;
  }
}

class AppLocalizations {
  AppLocalizations(this.languageCode);

  final String languageCode;
  Map<String, String> _strings = const {};

  static final Map<String, Map<String, String>> _cache = {};

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations(Localizations.localeOf(context).languageCode)
      .._strings = _cache[Localizations.localeOf(context).languageCode] ??
          _cache['ar'] ??
          const {};
  }

  static Future<void> load(String languageCode) async {
    if (_cache.containsKey(languageCode)) return;
    final raw = await rootBundle.loadString('lang/$languageCode.json');
    final map = json.decode(raw) as Map<String, dynamic>;
    _cache[languageCode] = map.map((key, value) => MapEntry(key, value.toString()));
  }

  static Future<void> ensureLoaded() async {
    await Future.wait([load('ar'), load('en')]);
  }

  String t(String key) {
    return _strings[key] ??
        _cache['ar']?[key] ??
        _cache['en']?[key] ??
        key;
  }
}

extension AppTr on BuildContext {
  String tr(String key) => AppLocalizations.of(this).t(key);

  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}
