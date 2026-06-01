import 'package:flutter/widgets.dart';

/// Small numeric helpers used by the animation utilities and painters.
extension DoubleX on double {
  /// Linear interpolation from `this` to [to] by [t] (unclamped).
  double lerp(double to, double t) => this + (to - this) * t;

  /// Re-maps a value from one range to another, clamping the input.
  double mapRange(double inMin, double inMax, double outMin, double outMax) {
    final double clamped = clamp(inMin, inMax).toDouble();
    if (inMax == inMin) return outMin;
    return outMin + (clamped - inMin) * (outMax - outMin) / (inMax - inMin);
  }
}

/// Sugar for building `SizedBox` gaps from a spacing constant: `16.gapH`.
extension GapX on num {
  Widget get gapH => SizedBox(height: toDouble());
  Widget get gapW => SizedBox(width: toDouble());
}
