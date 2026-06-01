import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/money_feature.dart';
import '../painters/phone_glyph_painter.dart';

/// A single "why Blinkit Money" benefit card: a hand-drawn phone glyph tile, a
/// title and a supporting line. Pure presentation - it receives a
/// [MoneyFeature] and renders it; the entrance animation is applied by the
/// parent via [FadeSlideIn], keeping this widget rebuild-free.
class FeatureCard extends StatelessWidget {
  const FeatureCard({required this.feature, super.key});

  final MoneyFeature feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _GlyphTile(glyph: feature.glyph),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(feature.title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(feature.subtitle, style: AppTextStyles.cardSubtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlyphTile extends StatelessWidget {
  const _GlyphTile({required this.glyph});

  final FeatureGlyph glyph;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.iconTile,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: RepaintBoundary(
        child: CustomPaint(painter: PhoneGlyphPainter(glyph)),
      ),
    );
  }
}
