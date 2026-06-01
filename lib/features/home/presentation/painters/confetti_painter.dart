import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../models/confetti_particle.dart';

/// Renders the falling-confetti burst.
///
/// Performance notes:
/// • The particle list is generated once and only *read* here — no per-frame
///   allocation beyond the unavoidable [Paint].
/// • Off-screen / not-yet-launched / fully-faded particles are skipped early.
/// • Lives under a [RepaintBoundary] so only this layer repaints each frame.
class ConfettiPainter extends CustomPainter {
  ConfettiPainter({required this.particles, required this.progress})
    : super(repaint: progress);

  final List<ConfettiParticle> particles;

  /// 0..1 burst progress.
  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double p = progress.value;
    if (p <= 0) return;
    final Paint paint = Paint()..style = PaintingStyle.fill;

    for (final ConfettiParticle c in particles) {
      // Re-base time so each particle respects its launch delay.
      final double span = 1 - c.delay;
      if (span <= 0) continue;
      final double local = ((p - c.delay) / span);
      if (local <= 0 || local >= 1) continue;

      // Gravity-style easing: accelerate downward over time.
      final double fallT = local * local * 0.6 + local * 0.4;
      final double dx =
          c.startX + c.driftX * local + c.swayAmp * math.sin(local * c.swayFreq * math.pi * 2);
      final double dy = c.startY + c.fall * fallT;

      final double px = dx * size.width;
      final double py = dy * size.height;
      if (py < -20 || py > size.height + 20) continue;

      // Quick fade-in, long hold, fade-out over the last 30%.
      final double opacity = local < 0.08
          ? local / 0.08
          : local > 0.7
          ? (1 - (local - 0.7) / 0.3).clamp(0.0, 1.0)
          : 1.0;

      final double rotation = c.spinTurns * local * math.pi * 2;
      // "Paper flip" - vertical foreshortening as the strip tumbles.
      final double flutter = math.cos(local * c.flutterFreq * math.pi * 2);

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(rotation);
      canvas.scale(1, flutter.abs().clamp(0.25, 1.0));
      paint.color = c.color.withValues(alpha: opacity);
      final Rect rect = Rect.fromCenter(
        center: Offset.zero,
        width: c.width,
        height: c.height,
      );
      canvas.drawRRect(RRect.fromRectXY(rect, 1.5, 1.5), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) =>
      oldDelegate.particles != particles; // progress drives repaint via `super.repaint`.
}
