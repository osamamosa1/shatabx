import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/values/app_colors.dart';

ThemeData getAppTheme(Locale locale) {
  final textTheme = locale.languageCode == 'en'
      ? GoogleFonts.dmSansTextTheme()
      : GoogleFonts.cairoTextTheme();
  final family = textTheme.bodyMedium?.fontFamily;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: family,
    textTheme: textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      error: AppColors.error,
      surface: AppColors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      foregroundColor: AppColors.text,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(color: AppColors.primary, width: 1.4),
    ),
    dividerColor: AppColors.border,
  );
}
