/// 8-point spacing scale.
///
/// A single source of truth for gaps and paddings keeps vertical rhythm
/// consistent and makes the layout trivially re-tunable for different device
/// classes. Use these instead of magic numbers.
abstract final class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;

  /// Default horizontal page gutter.
  static const double pageGutter = 20;

  /// Corner radii.
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusPill = 999;
}
