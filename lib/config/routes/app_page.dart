import 'package:animate_do/animate_do.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_motion.dart';

CustomTransitionPage<void> fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: AppMotion.enter,
    reverseTransitionDuration: AppMotion.exit,
    child: FadeIn(
      duration: AppMotion.enter,
      curve: AppMotion.curve,
      child: child,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, pageChild) {
      if (animation.status != AnimationStatus.reverse) return pageChild;
      return FadeTransition(opacity: animation, child: pageChild);
    },
  );
}
