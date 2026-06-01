import 'package:flutter/foundation.dart';

/// Which hand-drawn phone illustration a feature card shows.
enum FeatureGlyph { tap, signal, refund }

/// Immutable view-model for a single "why Blinkit Money" feature card.
///
/// Pure data - no widgets, no behaviour. The screen maps a list of these to
/// [FeatureCard]s, so adding/removing a benefit is a one-line content change.
@immutable
class MoneyFeature {
  const MoneyFeature({
    required this.title,
    required this.subtitle,
    required this.glyph,
  });

  final String title;
  final String subtitle;
  final FeatureGlyph glyph;

  /// The exact copy from the reference, kept as static content (a real app
  /// would source this from a repository / remote config).
  static const List<MoneyFeature> all = <MoneyFeature>[
    MoneyFeature(
      title: 'Single tap payments',
      subtitle: 'Enjoy seamless payments without the wait for OTPs',
      glyph: FeatureGlyph.tap,
    ),
    MoneyFeature(
      title: 'Zero failures',
      subtitle: 'Zero payment failures ensure you never miss an order',
      glyph: FeatureGlyph.signal,
    ),
    MoneyFeature(
      title: 'Real-time refunds',
      subtitle: 'No need to wait for refunds. Blinkit Money refunds are instant!',
      glyph: FeatureGlyph.refund,
    ),
  ];
}
