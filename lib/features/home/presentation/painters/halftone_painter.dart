import 'package:flutter/rendering.dart';

import '../../../../core/theme/app_colors.dart';

/// Paints the warm "halftone" dot field that fades in from the top of the
/// screen — the subtle texture that gives the dark backdrop depth.
///
/// Static (size-only) paint → cached behind a [RepaintBoundary] and never
/// repainted during the animation, so it costs nothing per frame.
class HalftonePainter extends CustomPainter {
  const HalftonePainter({this.spacing = 18, this.fadeEnd = 0.34});

  /// Grid pitch in logical pixels.
  final double spacing;

  /// Fraction of the height over which the dots fade to nothing.
  final double fadeEnd;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = AppColors.glowGold;
    final double fadeHeight = size.height * fadeEnd;

    for (double y = spacing; y < fadeHeight; y += spacing) {
      // 0 at top → 1 at fadeHeight. Dots shrink and dim as they descend.
      final double t = (y / fadeHeight).clamp(0.0, 1.0);
      final double alpha = (1 - t) * 0.5;
      if (alpha <= 0.01) continue;
      final double radius = (1 - t) * 1.6 + 0.4;
      // Offset alternate rows for an organic, screen-printed feel.
      final bool odd = ((y / spacing).round()).isOdd;
      final double xOffset = odd ? spacing / 2 : 0;
      paint.color = AppColors.glowGold.withValues(alpha: alpha);
      for (double x = xOffset; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HalftonePainter oldDelegate) =>
      oldDelegate.spacing != spacing || oldDelegate.fadeEnd != fadeEnd;
}
