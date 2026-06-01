import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Material 3 dark theme for the app.
///
/// The reference is a dark, cinematic OTT surface, so we ship a single,
/// hand-tuned dark [ThemeData]. Building it from a [ColorScheme] (rather than
/// scattering colours through widgets) gives every Material component sensible
/// defaults and keeps the brand swappable from one place.
abstract final class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    const ColorScheme scheme = ColorScheme.dark(
      primary: AppColors.blinkitGreen,
      onPrimary: Colors.white,
      secondary: AppColors.walletGoldMid,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTextStyles.fontFamily,
      // The intro screen owns its own motion; disable the default page
      // transition shimmer so nothing competes with the choreography.
      splashFactory: NoSplash.splashFactory,
      textTheme: const TextTheme(
        titleLarge: AppTextStyles.cardTitle,
        bodyMedium: AppTextStyles.cardSubtitle,
        labelLarge: AppTextStyles.button,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
