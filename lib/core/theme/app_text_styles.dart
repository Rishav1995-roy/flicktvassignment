import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typographic scale for the app.
///
/// Centralising text styles keeps typography consistent and makes swapping the
/// brand font a one-line change ([fontFamily]). We default to the platform
/// sans (null family → Roboto on Android) to keep the APK lean; see
/// `pubspec.yaml` for how to bundle a pixel-matching face.
abstract final class AppTextStyles {
  const AppTextStyles._();

  /// Set to a bundled family (e.g. 'Okra') to pixel-match the reference.
  static const String? fontFamily = null;

  /// "blinkit" wordmark — small, bold, tight.
  static const TextStyle wordmark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    height: 1.0,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  /// "MONEY" — large, wide-tracked display.
  static const TextStyle moneyDisplay = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    height: 1.0,
    fontWeight: FontWeight.w800,
    letterSpacing: 10,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5,
    height: 1.35,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle tileTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle tileSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Faint background watermark at the foot of the screen.
  static const TextStyle watermark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    height: 1.05,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );
}
