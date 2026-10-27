import 'package:animate_do/animate_do.dart';
import 'package:flutter/widgets.dart';

/// Short, quiet motion. Defaults stay under a third of a second and move
/// only a few pixels so screens don't bounce.
abstract final class AppMotion {
  static const enter = Duration(milliseconds: 260);
  static const rise = Duration(milliseconds: 320);
  static const exit = Duration(milliseconds: 180);
  static const curve = Curves.easeOutCubic;
  static const distance = 10.0;
}

class SoftFade extends StatelessWidget {
  const SoftFade({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: AppMotion.enter,
      delay: delay,
      curve: AppMotion.curve,
      child: child,
    );
  }
}

class SoftRise extends StatelessWidget {
  const SoftRise({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: AppMotion.rise,
      delay: delay,
      from: AppMotion.distance,
      curve: AppMotion.curve,
      child: child,
    );
  }
}

class SoftDrop extends StatelessWidget {
  const SoftDrop({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: AppMotion.enter,
      delay: delay,
      from: 8,
      curve: AppMotion.curve,
      child: child,
    );
  }
}
