import 'dart:math' as math;
import 'dart:ui';

/// A single piece of confetti.
///
/// Pre-computed, immutable physics parameters. Generating the whole burst once
/// (with a *seeded* RNG for reproducible screen recordings) and only
/// interpolating per frame keeps the hot animation path allocation-free.
class ConfettiParticle {
  const ConfettiParticle({
    required this.startX,
    required this.startY,
    required this.driftX,
    required this.fall,
    required this.swayAmp,
    required this.swayFreq,
    required this.spinTurns,
    required this.flutterFreq,
    required this.width,
    required this.height,
    required this.color,
    required this.delay,
  });

  /// Normalised launch position (fractions of the paint size).
  final double startX;
  final double startY;

  /// Horizontal drift across the whole fall (normalised by width).
  final double driftX;

  /// Vertical travel across the whole fall (normalised by height).
  final double fall;

  /// Lateral sway (the fluttering "leaf" wobble).
  final double swayAmp;
  final double swayFreq;

  /// Full Z rotations performed over the life of the particle.
  final double spinTurns;

  /// How fast the paper "flips" toward/away from the viewer (scaleY pulse).
  final double flutterFreq;

  /// Strip size in logical pixels.
  final double width;
  final double height;

  final Color color;

  /// Fraction of the timeline to wait before launching (0..~0.25).
  final double delay;

  /// Builds a deterministic burst of [count] particles.
  static List<ConfettiParticle> burst({
    required int count,
    required List<Color> palette,
    int seed = 7,
  }) {
    final math.Random rng = math.Random(seed);
    return List<ConfettiParticle>.generate(count, (int i) {
      // Concentrate the launch around the upper area, biased to the centre top
      // (matching the reference, where confetti erupts from behind the wallet).
      final double centreBias = (rng.nextDouble() - 0.5) * 1.4;
      return ConfettiParticle(
        startX: (0.5 + centreBias * 0.5).clamp(0.02, 0.98),
        startY: -0.05 + rng.nextDouble() * 0.18,
        driftX: (rng.nextDouble() - 0.5) * 0.5,
        fall: 0.65 + rng.nextDouble() * 0.5,
        swayAmp: 0.02 + rng.nextDouble() * 0.05,
        swayFreq: 1.5 + rng.nextDouble() * 2.5,
        spinTurns: 1.0 + rng.nextDouble() * 3.0,
        flutterFreq: 2.0 + rng.nextDouble() * 3.0,
        width: 6 + rng.nextDouble() * 6,
        height: 9 + rng.nextDouble() * 8,
        color: palette[i % palette.length],
        delay: rng.nextDouble() * 0.22,
      );
    });
  }
}
