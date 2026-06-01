import 'package:flutter/material.dart';

import '../utils/stagger.dart';

/// A reusable, controller-driven entrance: fade + vertical slide (+ optional
/// scale), all derived from one slice of a shared timeline.
///
/// Why a single shared parent instead of an implicit widget per element?
/// • One ticker for the whole screen → predictable, 60fps, no drift.
/// • The animation is *driven* (deterministic for screen-recording), not
///   triggered on mount.
///
/// The [child] is built **once** and passed into [AnimatedBuilder] so it is not
/// rebuilt every frame — only the cheap [Transform]/[Opacity] wrappers are.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    required this.animation,
    required this.segment,
    required this.child,
    this.beginOffset = const Offset(0, 24),
    this.beginScale = 1.0,
    super.key,
  });

  /// The shared master timeline (typically an [AnimationController]).
  final Animation<double> animation;

  /// When/how this element animates inside the master timeline.
  final IntervalSegment segment;

  /// Pixel offset the child travels from (dy > 0 → slides up into place).
  final Offset beginOffset;

  /// Optional starting scale for a subtle "rise" (1.0 disables it).
  final double beginScale;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Animation<double> t = segment.drive(animation);
    return AnimatedBuilder(
      animation: t,
      // `child` is captured once and reused — the closure only rebuilds the
      // lightweight Opacity/Transform shells.
      child: child,
      builder: (BuildContext context, Widget? child) {
        final double v = t.value;
        final Offset offset = Offset(beginOffset.dx * (1 - v), beginOffset.dy * (1 - v));
        final double scale = beginScale + (1 - beginScale) * v;
        return Opacity(
          opacity: v.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: offset,
            child: scale == 1.0 ? child : Transform.scale(scale: scale, child: child),
          ),
        );
      },
    );
  }
}
