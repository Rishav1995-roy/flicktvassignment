import 'package:flutter/widgets.dart';

/// Ergonomic, allocation-free accessors for the most common `BuildContext`
/// lookups. These cut boilerplate at call sites without hiding what they do.
extension BuildContextX on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Safe-area insets (status bar / home indicator).
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  /// `true` on compact phones — used to gently scale the hero down.
  bool get isCompactHeight => MediaQuery.sizeOf(this).height < 700;

  /// Honour the user's "reduce motion" accessibility setting. Long, looping
  /// flourishes should be suppressed when this is `true`.
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);
}
