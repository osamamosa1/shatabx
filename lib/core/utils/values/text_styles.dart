import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {
  static TextStyle style({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
    String? family,
  }) {
    return TextStyle(
      fontSize: size.sp,
      fontWeight: weight,
      color: color,
      height: height,
      fontFamily: family,
    );
  }

  static TextStyle poppins({
    double size = 28,
    FontWeight weight = FontWeight.w700,
    Color? color,
  }) {
    return GoogleFonts.poppins(
      fontSize: size.sp,
      fontWeight: weight,
      color: color,
      letterSpacing: -0.4,
    );
  }

  static TextStyle regular12({Color? color}) =>
      style(size: 12, color: color, height: 1.45);

  static TextStyle regular14({Color? color}) =>
      style(size: 14, color: color, height: 1.55);

  static TextStyle regular16({Color? color}) =>
      style(size: 16, color: color, height: 1.5);

  static TextStyle medium14({Color? color}) =>
      style(size: 14, weight: FontWeight.w600, color: color);

  static TextStyle medium16({Color? color}) =>
      style(size: 16, weight: FontWeight.w600, color: color);

  static TextStyle semiBold16({Color? color}) =>
      style(size: 16, weight: FontWeight.w600, color: color);

  static TextStyle semiBold18({Color? color}) =>
      style(size: 18, weight: FontWeight.w600, color: color);

  static TextStyle bold18({Color? color}) =>
      style(size: 18, weight: FontWeight.w700, color: color, height: 1.35);

  static TextStyle bold20({Color? color}) =>
      style(size: 20, weight: FontWeight.w700, color: color, height: 1.35);

  static TextStyle bold22({Color? color}) =>
      style(size: 22, weight: FontWeight.w700, color: color, height: 1.3);

  static TextStyle bold24({Color? color}) =>
      style(size: 24, weight: FontWeight.w700, color: color, height: 1.3);
}
