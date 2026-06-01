import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/utils/app_curves.dart';
import '../../../../core/utils/stagger.dart';
import '../painters/wallet_painter.dart';

/// The hero wallet: a vector illustration that **tumbles** into place from
/// above (damped-spring rotation + overshoot scale) and then **breathes** with a
/// continuous float + micro-wobble.
///
/// Two animations feed one [AnimatedBuilder]:
///  • [intro]   - the master one-shot timeline (drives the entrance).
///  • [ambient] - a looping 0..1 triangle (drives the idle life).
/// The [CustomPaint] child is built once and reused; only the cheap [Transform]
/// shell is rebuilt each frame.
class WalletBadge extends StatelessWidget {
  WalletBadge({
    required this.intro,
    required this.ambient,
    required this.segment,
    this.size = 150,
    super.key,
  });

  final Animation<double> intro;
  final Animation<double> ambient;
  final IntervalSegment segment;
  final double size;

  /// Resting tilt of the wallet (radians) — matches the reference's lean.
  static const double _restAngle = -0.14;

  // Pre-built easing views over the master timeline (lazy, no listeners → no
  // disposal needed).
  late final Animation<double> _appear = segment.drive(intro);
  late final Animation<double> _spin = CurvedAnimation(
    parent: intro,
    curve: Interval(segment.begin, segment.end, curve: const DampedWobbleCurve()),
  );
  late final Animation<double> _scale = CurvedAnimation(
    parent: intro,
    curve: Interval(segment.begin, segment.end, curve: AppCurves.overshoot),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[intro, ambient]),
      child: SizedBox.square(
        dimension: size,
        child: const CustomPaint(painter: WalletPainter()),
      ),
      builder: (BuildContext context, Widget? child) {
        final double appear = _appear.value; // 0..1 entrance progress
        final double settle = _spin.value; // damped 0..1 (overshoots)
        final double bob = (ambient.value - 0.5) * 2; // -1..1 triangle

        // Entrance: drop from above + extra tilt that springs out.
        final double dropY = (1 - appear) * -size * 0.85;
        final double entranceTilt = (1 - settle) * -0.7;

        // Idle life (only meaningful once it has arrived → scaled by `appear`).
        final double floatY = math.sin(bob * math.pi) * 6 * appear;
        final double idleTilt = bob * 0.05 * appear;

        final double scale = 0.5 + 0.5 * _scale.value;
        final double angle = _restAngle + entranceTilt + idleTilt;

        return Opacity(
          opacity: appear.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, dropY + floatY),
            child: Transform.rotate(
              angle: angle,
              child: Transform.scale(scale: scale, child: child),
            ),
          ),
        );
      },
    );
  }
}
