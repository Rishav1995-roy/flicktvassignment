import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/confetti_particle.dart';
import '../painters/confetti_painter.dart';

/// Full-bleed confetti burst.
///
/// The particle set is generated **once** (in [initState], seeded for
/// reproducibility) and the painter only interpolates per frame. A
/// [RepaintBoundary] isolates the heavy per-frame repaint to this layer so it
/// never invalidates the rest of the tree. [IgnorePointer] keeps it
/// non-interactive.
class ConfettiLayer extends StatefulWidget {
  const ConfettiLayer({required this.progress, this.count = 90, super.key});

  /// 0..1 one-shot burst progress.
  final Animation<double> progress;
  final int count;

  @override
  State<ConfettiLayer> createState() => _ConfettiLayerState();
}

class _ConfettiLayerState extends State<ConfettiLayer> {
  late final List<ConfettiParticle> _particles = ConfettiParticle.burst(
    count: widget.count,
    palette: AppColors.confetti,
  );

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: ConfettiPainter(particles: _particles, progress: widget.progress),
          ),
        ),
      ),
    );
  }
}
