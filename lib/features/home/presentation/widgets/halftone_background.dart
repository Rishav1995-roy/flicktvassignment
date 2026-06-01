import 'package:flutter/material.dart';

import '../../../../core/theme/app_gradients.dart';
import '../painters/halftone_painter.dart';

/// The static, full-bleed cinematic backdrop: a dark vertical wash, a warm
/// radial glow up top, and a fading halftone dot field.
///
/// Everything here is constant for a given size, so the whole thing is wrapped
/// in a [RepaintBoundary] - it paints once and is then composited as a cached
/// layer, contributing **zero** cost to the per-frame animation budget.
class HalftoneBackground extends StatelessWidget {
  const HalftoneBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: AppGradients.pageBackdrop),
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: AppGradients.topGlow),
          child: SizedBox.expand(
            child: CustomPaint(painter: HalftonePainter()),
          ),
        ),
      ),
    );
  }
}
