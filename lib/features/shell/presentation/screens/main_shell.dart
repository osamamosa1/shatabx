import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_svg.dart';
import '../cubit/bottom_nav_cubit.dart';

class _TabFade extends StatefulWidget {
  const _TabFade({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_TabFade> createState() => _TabFadeState();
}

class _TabFadeState extends State<_TabFade> {
  AnimationController? _controller;
  var _armed = false;

  @override
  void didUpdateWidget(covariant _TabFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _controller?.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: AppMotion.enter,
      curve: AppMotion.curve,
      manualTrigger: true,
      controller: (controller) {
        _controller = controller;
        if (_armed) return;
        _armed = true;
        controller.value = 1;
      },
      child: widget.child,
    );
  }
}

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _icons = <String>[
    SvgAssets.home,
    SvgAssets.projects,
    SvgAssets.reports,
    SvgAssets.profile,
  ];

  static const _labels = ['home', 'projects', 'reports', 'profile'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return Scaffold(
          body: _TabFade(
            index: navigationShell.currentIndex,
            child: navigationShell,
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 64.h,
                child: Row(
                  children: List.generate(_icons.length, (index) {
                    final selected = navigationShell.currentIndex == index;
                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          context.read<BottomNavCubit>().select(index);
                          navigationShell.goBranch(
                            index,
                            initialLocation: index == navigationShell.currentIndex,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppSvg(
                              _icons[index],
                              size: 24.r,
                              color: selected ? AppColors.primary : AppColors.hint,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              context.tr(_labels[index]),
                              style: TextStyles.regular12(
                                color: selected ? AppColors.primary : AppColors.hint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
