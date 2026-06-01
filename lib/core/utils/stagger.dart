import 'package:flutter/widgets.dart';

/// A declarative slice of a master timeline.
///
/// The entire intro is choreographed from a **single** [AnimationController]
/// (one ticker, one rebuild source). Each UI element owns an [IntervalSegment]
/// describing *when* inside the master timeline it animates and *how* it eases.
/// This keeps everything frame-perfectly in sync and avoids the cost and drift
/// of juggling many controllers.
@immutable
class IntervalSegment {
  const IntervalSegment(this.begin, this.end, {this.curve = Curves.easeOut})
    : assert(begin >= 0 && end <= 1 && begin < end, 'Invalid 0..1 interval');

  /// Fractional start within the master timeline (0..1).
  final double begin;

  /// Fractional end within the master timeline (0..1).
  final double end;

  /// Easing applied within this slice.
  final Curve curve;

  /// Derives a `0..1` progress [Animation] for this slice from the [parent]
  /// controller. The returned animation is cheap to create and safe to rebuild.
  Animation<double> drive(Animation<double> parent) {
    return CurvedAnimation(parent: parent, curve: Interval(begin, end, curve: curve));
  }

  /// Convenience: the eased scalar value of this slice at the parent's value.
  double evaluate(Animation<double> parent) =>
      Interval(begin, end, curve: curve).transform(parent.value);
}

/// Builds an evenly distributed list of [IntervalSegment]s for a list of N
/// items — the canonical "cards cascade in" stagger.
///
/// [start]/[end] bound the region of the master timeline the whole cascade
/// occupies; [itemFraction] is how much of that region a single item's own
/// animation lasts (overlap = visually smoother cascade).
List<IntervalSegment> staggered({
  required int count,
  double start = 0,
  double end = 1,
  double itemFraction = 0.6,
  Curve curve = Curves.easeOutCubic,
}) {
  if (count <= 0) return const <IntervalSegment>[];
  final double span = end - start;
  // Spacing between successive item start times.
  final double step = count == 1 ? 0 : (span * (1 - itemFraction)) / (count - 1);
  final double itemSpan = span * itemFraction;
  return List<IntervalSegment>.generate(count, (int i) {
    final double b = start + step * i;
    return IntervalSegment(b, (b + itemSpan).clamp(0.0, 1.0), curve: curve);
  });
}
