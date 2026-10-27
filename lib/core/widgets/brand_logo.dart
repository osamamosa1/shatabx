import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/values/app_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 34, this.dark = true});

  final double size;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final color = dark ? AppColors.navy : AppColors.white;
    final style = GoogleFonts.poppins(
      fontSize: size,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.6,
      color: color,
    );
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Shatab', style: style),
          TextSpan(text: 'X', style: style.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}
