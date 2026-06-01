import 'package:flutter/widgets.dart';

/// Centralised motion timings.
///
/// Keeping every duration in one place makes the *rhythm* of the product
/// tunable from a single file and guarantees that independent widgets share a
/// consistent motion language (a hallmark of a cohesive OTT experience).
abstract final class AppDurations {
  const AppDurations._();

  /// Master timeline for the one-shot intro choreography (wallet → brand →
  /// cards → CTA). Every entrance is expressed as an [Interval] of this.
  static const Duration intro = Duration(milliseconds: 3400);

  /// One-shot confetti burst. Slightly longer than [intro] so the last
  /// particles are still drifting as the UI settles.
  static const Duration confetti = Duration(milliseconds: 3200);

  /// Looping ambient "breathing" of the wallet (float + micro-wobble).
  static const Duration walletIdle = Duration(milliseconds: 2600);

  /// Standard tactile feedback for pressable surfaces.
  static const Duration press = Duration(milliseconds: 120);

  /// Generic implicit-animation duration for state changes.
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
}
