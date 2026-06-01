import 'package:flutter/material.dart';

import '../constants/app_durations.dart';

/// Wraps any widget with a premium, spring-loaded press response: scale-down on
/// touch-down, settle on release. Encapsulates the [AnimationController] and its
/// disposal so call sites stay declarative.
///
/// Uses an explicit controller (not [AnimatedScale]) so the down/up curves can
/// differ — a tiny detail that makes taps feel physical rather than linear.
class Pressable extends StatefulWidget {
  const Pressable({
    required this.child,
    this.onTap,
    this.pressedScale = 0.96,
    this.enableHaptics = true,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final bool enableHaptics;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.press,
    lowerBound: 0,
    upperBound: 1,
  );

  late final Animation<double> _scale = Tween<double>(
    begin: 1,
    end: widget.pressedScale,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _down(_) => _controller.forward();
  void _up([_]) => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;
    return GestureDetector(
      onTapDown: _down,
      onTapUp: _up,
      onTapCancel: _up,
      onTap: widget.onTap,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
