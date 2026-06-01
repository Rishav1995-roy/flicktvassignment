import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Reusable gradients for the cinematic dark backdrop and brand surfaces.
///
/// Declaring gradients as `const` once avoids re-allocating identical
/// [Gradient] objects on every build.
abstract final class AppGradients {
  const AppGradients._();

  /// Top-to-bottom page wash: warm gold haze melting into near-black.
  static const LinearGradient pageBackdrop = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: <double>[0.0, 0.28, 0.6, 1.0],
    colors: <Color>[
      AppColors.glowGoldSoft,
      Color(0xFF161410),
      AppColors.background,
      AppColors.background,
    ],
  );

  /// Radial warm glow seated behind the wallet near the top.
  static const RadialGradient topGlow = RadialGradient(
    center: Alignment(0, -0.75),
    radius: 0.9,
    colors: <Color>[AppColors.glowGold, Color(0x00000000)],
  );

  /// The "Add Money" CTA fill.
  static const LinearGradient cta = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.blinkitGreen, AppColors.blinkitGreenDark],
  );

  /// Gold body of the wallet.
  static const LinearGradient walletBody = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: <double>[0.0, 0.55, 1.0],
    colors: <Color>[
      AppColors.walletGoldLight,
      AppColors.walletGoldMid,
      AppColors.walletGoldDeep,
    ],
  );

  /// Green lining peeking from the top of the wallet.
  static const LinearGradient walletLining = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.walletLiningLight, AppColors.walletLiningDark],
  );
}
