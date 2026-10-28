import 'package:flutter/material.dart';

import '../utils/values/assets.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 34, this.dark = true});

  final double size;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      dark ? ImgAssets.logo : ImgAssets.logoDark,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
