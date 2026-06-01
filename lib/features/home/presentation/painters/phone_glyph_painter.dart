import 'package:flutter/material.dart';

import '../models/money_feature.dart';

/// Hand-draws the three little gold phone illustrations shown on the feature
/// tiles (tap-to-pay, signal/contactless, refund). Vector-drawn so the tiles
/// need no image assets and stay crisp.
class PhoneGlyphPainter extends CustomPainter {
  const PhoneGlyphPainter(this.glyph);

  final FeatureGlyph glyph;

  static const Color _gold = Color(0xFFF2C24B);
  static const Color _ink = Color(0xFF0C0C0E);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Phone body — a rounded gold handset, tilted slightly for life.
    canvas.save();
    canvas.translate(w * 0.5, h * 0.52);
    canvas.rotate(-0.12);

    final Rect phone = Rect.fromCenter(
      center: Offset.zero,
      width: w * 0.42,
      height: h * 0.62,
    );
    final RRect phoneR = RRect.fromRectAndRadius(phone, Radius.circular(w * 0.07));
    canvas.drawRRect(phoneR, Paint()..color = _gold);
    // Screen inset.
    canvas.drawRRect(
      RRect.fromRectAndRadius(phone.deflate(w * 0.03), Radius.circular(w * 0.05)),
      Paint()..color = _ink.withValues(alpha: 0.85),
    );
    canvas.restore();

    final Paint stroke = Paint()
      ..color = _gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.035
      ..strokeCap = StrokeCap.round;

    switch (glyph) {
      case FeatureGlyph.tap:
        // A tapping finger: a small filled disc with a downward stem.
        final Offset tip = Offset(w * 0.58, h * 0.46);
        canvas.drawCircle(tip, w * 0.07, Paint()..color = Colors.white);
        canvas.drawLine(tip, tip + Offset(w * 0.08, h * 0.16), stroke);
        // Tap ripples.
        for (int i = 1; i <= 2; i++) {
          canvas.drawArc(
            Rect.fromCircle(center: tip, radius: w * 0.11 * i),
            -1.2,
            1.0,
            false,
            stroke..color = _gold.withValues(alpha: 0.9 - i * 0.25),
          );
        }
      case FeatureGlyph.signal:
        // Contactless waves emanating from the handset.
        final Offset src = Offset(w * 0.42, h * 0.5);
        for (int i = 1; i <= 3; i++) {
          canvas.drawArc(
            Rect.fromCircle(center: src, radius: w * 0.1 * i),
            -0.9,
            1.8,
            false,
            stroke..color = _gold.withValues(alpha: 1 - i * 0.22),
          );
        }
      case FeatureGlyph.refund:
        // A circular refund arrow over the phone.
        final Rect r = Rect.fromCircle(center: Offset(w * 0.5, h * 0.5), radius: w * 0.16);
        canvas.drawArc(r, -0.4, 4.6, false, stroke..color = Colors.white);
        // Arrow head.
        final Offset head = Offset(w * 0.5 + w * 0.16, h * 0.5);
        final Path arrow = Path()
          ..moveTo(head.dx - w * 0.05, head.dy - w * 0.02)
          ..lineTo(head.dx, head.dy + w * 0.06)
          ..lineTo(head.dx + w * 0.06, head.dy - w * 0.02);
        canvas.drawPath(arrow, Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.035
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(covariant PhoneGlyphPainter oldDelegate) => oldDelegate.glyph != glyph;
}
