import 'dart:math' as math;

import 'package:flutter/animation.dart';

/// Bespoke easing curves that give the product its signature "premium" feel.
///
/// Stock [Curves] are perfectly fine, but a couple of hand-built curves let the
/// hero land with a touch of personality (a controlled overshoot, a damped
/// settle) without reaching for a third-party physics package.
abstract final class AppCurves {
  const AppCurves._();

  /// Snappy entrance with a gentle, controlled overshoot — used for the
  /// wallet's "pop" and the CTA. Less aggressive than [Curves.elasticOut].
  static const Curve overshoot = Cubic(0.16, 1.16, 0.3, 1.0);

  /// Smooth, expensive-feeling deceleration for text and cards.
  static const Curve silk = Cubic(0.22, 1.0, 0.36, 1.0);

  /// Emphasised ease used when the hero promotes from centre to the top.
  static const Curve emphasised = Cubic(0.2, 0.0, 0.0, 1.0);
}

/// A critically-damped spring-style settle expressed as a [Curve].
///
/// Drives the wallet's "tumble in, then quiver to rest" motion. Implemented by
/// hand so we stay 100% SDK-only while still getting believable physics.
class DampedWobbleCurve extends Curve {
  const DampedWobbleCurve({this.oscillations = 3, this.damping = 6});

  /// Number of half-swings before coming to rest.
  final int oscillations;

  /// Higher → the wobble dies out faster.
  final double damping;

  @override
  double transformInternal(double t) {
    final double decay = math.exp(-damping * t);
    return 1 - decay * math.cos(oscillations * math.pi * t);
  }
}
