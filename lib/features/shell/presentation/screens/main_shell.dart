import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../cubit/bottom_nav_cubit.dart';

class _TabTransition extends StatefulWidget {
  const _TabTransition({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_TabTransition> createState() => _TabTransitionState();
}

class _TabTransitionState extends State<_TabTransition> {
  AnimationController? _controller;
  var _armed = false;

  @override
  void didUpdateWidget(covariant _TabTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _controller?.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: AppMotion.enter,
      from: 12,
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

  static const _labels = ['home', 'projects', 'reports', 'profile_tab'];

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final isEngineer =
        session is SessionAuthenticated &&
        session.user.role == AccountRole.engineer;

    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return Scaffold(
          body: _TabTransition(
            index: navigationShell.currentIndex,
            child: navigationShell,
          ),
          bottomNavigationBar: FadeInUp(
            duration: const Duration(milliseconds: 450),
            from: 24,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: List.generate(_icons.length, (index) {
                      final selected = navigationShell.currentIndex == index;
                      final isProfileTab = index == 3;
                      return Expanded(
                        child: TapScale(
                          child: InkWell(
                            onTap: () {
                              context.read<BottomNavCubit>().select(index);
                              navigationShell.goBranch(
                                index,
                                initialLocation:
                                    index == navigationShell.currentIndex,
                              );
                            },
                            borderRadius: BorderRadius.circular(16.r),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOutBack,
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.statusInfoLight
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16.r),
                                border: selected
                                    ? Border.all(
                                        color: const Color(0xFFF0F4F8),
                                      )
                                    : null,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedScale(
                                    scale: selected ? 1.12 : 1.0,
                                    duration: const Duration(milliseconds: 260),
                                    curve: Curves.easeOutBack,
                                    child: isProfileTab
                                        ? Container(
                                            width: 24.r,
                                            height: 24.r,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: selected
                                                    ? AppColors.primary
                                                    : AppColors.border,
                                                width: 1.2,
                                              ),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: Image.asset(
                                              isEngineer
                                                  ? ImgAssets.engineerAvatar
                                                  : ImgAssets.companyAvatar,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : AppSvg(
                                            _icons[index],
                                            size: 24.r,
                                            color: selected
                                                ? AppColors.primary
                                                : const Color(0xFF555555),
                                          ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    context.tr(_labels[index]),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.medium12(
                                      color: selected
                                          ? AppColors.primary
                                          : const Color(0xFF555555),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
