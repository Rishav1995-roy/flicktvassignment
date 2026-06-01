import 'package:flutter/material.dart';

import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/stagger.dart';
import '../models/money_feature.dart';
import 'feature_card.dart';

/// Renders the benefit cards with a staggered cascade.
///
/// The list owns the *mapping* of features → animation slices; each card is a
/// dumb presentational widget wrapped in a shared [FadeSlideIn]. Adding a
/// feature is a one-line content edit ([MoneyFeature.all]); the stagger
/// re-balances automatically.
class FeatureList extends StatelessWidget {
  const FeatureList({
    required this.intro,
    required this.segments,
    this.features = MoneyFeature.all,
    super.key,
  });

  final Animation<double> intro;
  final List<IntervalSegment> segments;
  final List<MoneyFeature> features;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < features.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          FadeSlideIn(
            animation: intro,
            segment: segments[i % segments.length],
            beginOffset: const Offset(0, 28),
            child: FeatureCard(feature: features[i]),
          ),
        ],
      ],
    );
  }
}
