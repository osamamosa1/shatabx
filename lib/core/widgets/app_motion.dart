import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

/// Rich, sleek motion presets powered by `animate_do` + smooth tweens.
abstract final class AppMotion {
  static const enter = Duration(milliseconds: 420);
  static const rise = Duration(milliseconds: 520);
  static const exit = Duration(milliseconds: 240);
  static const curve = Curves.easeOutCubic;
  static const springCurve = Curves.easeOutBack;
  static const distance = 22.0;
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
  const SoftRise({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.from = AppMotion.distance,
  });

  final Widget child;
  final Duration delay;
  final double from;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: AppMotion.rise,
      delay: delay,
      from: from,
      curve: AppMotion.curve,
      child: child,
    );
  }
}

class SoftDrop extends StatelessWidget {
  const SoftDrop({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.from = 16.0,
  });

  final Widget child;
  final Duration delay;
  final double from;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: AppMotion.enter,
      delay: delay,
      from: from,
      curve: AppMotion.curve,
      child: child,
    );
  }
}

class SoftZoom extends StatelessWidget {
  const SoftZoom({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.from = 0.88,
  });

  final Widget child;
  final Duration delay;
  final double from;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: AppMotion.enter,
      delay: delay,
      child: ZoomIn(
        duration: AppMotion.rise,
        delay: delay,
        from: from,
        curve: AppMotion.springCurve,
        child: child,
      ),
    );
  }
}

class SoftElastic extends StatelessWidget {
  const SoftElastic({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return ElasticIn(
      duration: const Duration(milliseconds: 680),
      delay: delay,
      child: child,
    );
  }
}

class SoftSlideStart extends StatelessWidget {
  const SoftSlideStart({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.from = 24.0,
  });

  final Widget child;
  final Duration delay;
  final double from;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return rtl
        ? FadeInRight(
            duration: AppMotion.rise,
            delay: delay,
            from: from,
            curve: AppMotion.curve,
            child: child,
          )
        : FadeInLeft(
            duration: AppMotion.rise,
            delay: delay,
            from: from,
            curve: AppMotion.curve,
            child: child,
          );
  }
}

class SoftSlideEnd extends StatelessWidget {
  const SoftSlideEnd({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.from = 24.0,
  });

  final Widget child;
  final Duration delay;
  final double from;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return rtl
        ? FadeInLeft(
            duration: AppMotion.rise,
            delay: delay,
            from: from,
            curve: AppMotion.curve,
            child: child,
          )
        : FadeInRight(
            duration: AppMotion.rise,
            delay: delay,
            from: from,
            curve: AppMotion.curve,
            child: child,
          );
  }
}

/// Gentle continuous floating motion for hero illustrations and badges.
class FloatingMotion extends StatefulWidget {
  const FloatingMotion({
    super.key,
    required this.child,
    this.offset = 7.0,
    this.duration = const Duration(milliseconds: 2400),
  });

  final Widget child;
  final double offset;
  final Duration duration;

  @override
  State<FloatingMotion> createState() => _FloatingMotionState();
}

class _FloatingMotionState extends State<FloatingMotion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dy =
            Curves.easeInOutSine.transform(_controller.value) * widget.offset -
            (widget.offset / 2);
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: widget.child,
    );
  }
}

/// Interactive press scale feedback for cards and buttons.
class TapScale extends StatefulWidget {
  const TapScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.965,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        if (!_pressed) setState(() => _pressed = true);
      },
      onPointerUp: (_) {
        if (_pressed) setState(() => _pressed = false);
      },
      onPointerCancel: (_) {
        if (_pressed) setState(() => _pressed = false);
      },
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: widget.onTap == null
            ? widget.child
            : GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: widget.onTap,
                child: widget.child,
              ),
      ),
    );
  }
}

/// Animated integer counter for dashboard statistics.
class AnimatedCount extends StatelessWidget {
  const AnimatedCount({
    super.key,
    required this.value,
    required this.style,
    this.suffix = '',
    this.duration = const Duration(milliseconds: 950),
  });

  final int value;
  final TextStyle style;
  final String suffix;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, current, _) {
        return Text('${current.round()}$suffix', style: style);
      },
    );
  }
}

/// Smoothly fills a progress bar from 0 to [value] on mount or update.
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.backgroundColor = const Color(0xFFF3F3F3),
    this.height = 8.0,
    this.duration = const Duration(milliseconds: 900),
  });

  final double value;
  final Color color;
  final Color backgroundColor;
  final double height;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: value.clamp(0.03, 1.0)),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: animatedValue,
            minHeight: height,
            backgroundColor: backgroundColor,
            color: color,
          ),
        );
      },
    );
  }
}
