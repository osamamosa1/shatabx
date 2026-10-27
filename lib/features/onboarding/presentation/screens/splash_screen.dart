import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
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
      child: const Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: BrandLogo(size: 40)),
      ),
    );
  }
}
