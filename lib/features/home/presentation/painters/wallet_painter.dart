import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';

/// Hand-paints the stylised 3D "Blinkit Money" wallet — gold pouch, green
/// lining peeking from the top, and a white ₹ badge.
///
/// The whole illustration is vector-drawn (no image asset) so it stays crisp at
/// any size and ships zero binary weight. The painter is *static*: the tumble,
/// float and wobble are applied by a [Transform] in the widget layer, so
/// [shouldRepaint] is `false` and this paints only once per size.
class WalletPainter extends CustomPainter {
  const WalletPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    //  Geometry (fractions of the box)
    final RRect body = RRect.fromLTRBR(
      0.13 * w,
      0.26 * h,
      0.87 * w,
      0.84 * h,
      Radius.circular(0.15 * w),
    );
    final RRect lining = RRect.fromLTRBR(
      0.19 * w,
      0.13 * h,
      0.81 * w,
      0.42 * h,
      Radius.circular(0.10 * w),
    );

    //  1. Contact shadow on the (virtual) ground --
    final Paint shadow = Paint()
      ..color = const Color(0x55000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0.5 * w, 0.9 * h), width: 0.6 * w, height: 0.12 * h),
      shadow,
    );

    //  2. Green lining (sits behind the gold body)
    final Paint liningPaint = Paint()
      ..shader = AppGradients.walletLining.createShader(lining.outerRect);
    canvas.drawRRect(lining, liningPaint);
    // Inner shade where the pouch overlaps the lining → sense of depth.
    canvas.drawRRect(
      RRect.fromLTRBR(0.21 * w, 0.30 * h, 0.79 * w, 0.42 * h, const Radius.circular(6)),
      Paint()..color = AppColors.walletLiningDark.withValues(alpha: 0.6),
    );

    //  3. Bottom "thickness" face (3D extrusion) --
    canvas.drawRRect(
      body.shift(const Offset(0, 6)),
      Paint()..color = AppColors.walletGoldShade,
    );

    //  4. Gold front body -
    final Paint bodyPaint = Paint()
      ..shader = AppGradients.walletBody.createShader(body.outerRect);
    canvas.drawRRect(body, bodyPaint);

    // Soft top highlight to read as a glossy surface.
    canvas.drawRRect(
      RRect.fromLTRBR(0.13 * w, 0.26 * h, 0.87 * w, 0.5 * h, Radius.circular(0.15 * w)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0x33FFFFFF), Color(0x00FFFFFF)],
        ).createShader(body.outerRect),
    );

    //  5. White ₹ badge
    final double badge = 0.34 * w;
    final RRect badgeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(0.5 * w, 0.58 * h), width: badge, height: badge),
      Radius.circular(0.1 * w),
    );
    canvas.drawRRect(
      badgeRect.shift(const Offset(0, 3)),
      Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawRRect(badgeRect, Paint()..color = AppColors.rupeeBadge);

    _paintRupee(canvas, Offset(0.5 * w, 0.58 * h), badge * 0.74);
  }

  /// Draws the ₹ glyph centred at [center], sized to [glyphSize].
  void _paintRupee(Canvas canvas, Offset center, double glyphSize) {
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: '₹',
        style: TextStyle(
          fontSize: glyphSize,
          height: 1.0,
          fontWeight: FontWeight.w800,
          color: AppColors.rupeeGlyph,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant WalletPainter oldDelegate) => false;
}
