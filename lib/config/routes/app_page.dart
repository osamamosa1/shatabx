import 'package:animate_do/animate_do.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_motion.dart';

CustomTransitionPage<void> fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: AppMotion.enter,
    reverseTransitionDuration: AppMotion.exit,
    child: FadeInUp(
      duration: AppMotion.enter,
      from: 14,
      curve: AppMotion.curve,
      child: child,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, pageChild) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: AppMotion.curve,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.985, end: 1.0).animate(curved),
          child: pageChild,
        ),
      );
    },
  );
}
