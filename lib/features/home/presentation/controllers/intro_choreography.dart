import 'package:flutter/animation.dart';

import '../../../../core/utils/app_curves.dart';
import '../../../../core/utils/stagger.dart';

/// The single source of truth for the screen's entrance *timing*.
///
/// Every element's slice of the master timeline lives here as data, not buried
/// in widgets. This is what makes the choreography readable and re-tunable: you
/// can re-time the whole sequence by editing one file, and the relationship
/// between elements (overlap, cascade, lead/lag) is visible at a glance.
///
/// All values are fractions (0..1) of [AppDurations.intro].
abstract final class IntroChoreography {
  const IntroChoreography._();

  /// Hero wallet drops & tumbles in first.
  static const IntervalSegment wallet =
      IntervalSegment(0.00, 0.42, curve: AppCurves.silk);

  /// "blinkit" wordmark.
  static const IntervalSegment wordmark =
      IntervalSegment(0.30, 0.46, curve: AppCurves.silk);

  /// "MONEY" display + shimmer.
  static const IntervalSegment money =
      IntervalSegment(0.36, 0.56, curve: AppCurves.silk);

  /// Top-bar affordances (back already visible; settings fades in).
  static const IntervalSegment topBar =
      IntervalSegment(0.60, 0.78, curve: Curves.easeOut);

  /// The three benefit cards cascade in.
  static List<IntervalSegment> get cards => staggered(
    count: 3,
    start: 0.50,
    end: 0.86,
    itemFraction: 0.62,
    curve: AppCurves.silk,
  );

  /// "Add Money" CTA.
  static const IntervalSegment addMoney =
      IntervalSegment(0.78, 0.92, curve: AppCurves.overshoot);

  /// "Claim Gift Card" row.
  static const IntervalSegment giftTile =
      IntervalSegment(0.84, 0.96, curve: AppCurves.silk);

  /// Background watermark settles in last.
  static const IntervalSegment watermark =
      IntervalSegment(0.86, 1.00, curve: Curves.easeOut);
}
