import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFF00608B);
  static const Color primaryDark = Color(0xFF004E72);
  static const Color primarySoft = Color(0xFFE6F2F7);
  static const Color highlight = Color(0xFFF2F4F7);
  static const Color text = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF667085);
  static const Color hint = Color(0xFF98A2B3);
  static const Color border = Color(0xFFE4E7EC);
  static const Color fieldFill = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color canvas = Color(0xFFE7EEF2);
  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD92D20);
  static const Color success = Color(0xFF067647);
  static const Color warning = Color(0xFFB54708);
  static const Color navy = Color(0xFF12324A);
  static const Color joinStart = Color(0xFF0B2744);
  static const Color joinMid = Color(0xFF14385C);
  static const Color joinCard = Color(0xCC17385C);
  static const Color joinCardSelected = Color(0xFF1B4C82);
  static const Color primaryLift = Color(0xFF0A7AAD);
  static const Color dotIdle = Color(0xFFD5D9DE);
  static const Color onPrimaryMuted = Color(0xFFD6E8F2);
  static const Color joinText = Color(0xFFD5E2EE);
  static const Color joinLine = Color(0xFF8FB6E8);
  static const Color joinLineIdle = Color(0xFF31598A);
  static const Color joinIcon = Color(0xFF8EC5FF);
  static const Color joinIconWell = Color(0xFF16345C);
  static const Color heroWarm = Color(0xFF8C5A3C);
  static const Color heroMid = Color(0xFF1E3A5F);
  static const Color heroDeep = Color(0xFF0E2744);
  static const Color wash = Color(0xFFF4F9FC);

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0F101828),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}

abstract class AppGradients {
  static const primary = LinearGradient(
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
    colors: [AppColors.primary, AppColors.primaryLift],
  );

  static const join = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.joinStart, AppColors.joinMid, AppColors.joinStart],
  );

  static const loginHero = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [AppColors.heroWarm, AppColors.heroMid, AppColors.heroDeep],
    stops: [0, 0.45, 1],
  );

  static const wash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.wash, AppColors.white],
  );
}
