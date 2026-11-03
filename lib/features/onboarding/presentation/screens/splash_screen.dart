import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().decide();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashGoOnboarding) {
          context.go(AppRoutes.onboarding);
        } else if (state is SplashGoAccountType) {
          context.go(AppRoutes.accountType);
        } else if (state is SplashGoHome) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFF),
        body: Center(
          child: FadeIn(
            duration: const Duration(milliseconds: 520),
            curve: Curves.easeOutCubic,
            child: ZoomIn(
              duration: const Duration(milliseconds: 620),
              from: 0.85,
              curve: Curves.easeOutBack,
              child: BrandLogo(size: 56.h),
            ),
          ),
        ),
      ),
    );
  }
}
