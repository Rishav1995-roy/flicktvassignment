import 'package:flutter/material.dart';

/// Centralised, semantic colour palette derived from the Blinkit Money
/// reference.
///
/// Colours are intentionally named by *role* (surface, onSurface, brand…) as
/// well as by their concrete identity (walletGold, blinkitGreen). Widgets
/// should reference roles where possible so a future re-theme touches one file.
abstract final class AppColors {
  const AppColors._();

  // Base / surfaces
  /// Deepest background — the screen fades to near-black at the bottom.
  static const Color background = Color(0xFF0B0B0D);
  static const Color backgroundElevated = Color(0xFF141417);

  /// Warm gold haze that bleeds from the top of the screen.
  static const Color glowGold = Color(0xFF6E5A12);
  static const Color glowGoldSoft = Color(0xFF2A2410);

  /// Translucent card surface used by the feature list.
  static const Color card = Color(0xFF26262A);
  static const Color cardBorder = Color(0xFF3A3A40);
  static const Color iconTile = Color(0xFF101012);

  //  Foreground / text
  static const Color textPrimary = Color(0xFFF6F6F7);
  static const Color textSecondary = Color(0xFF9B9BA1);
  static const Color textTertiary = Color(0xFF6E6E74);

  //  Brand -
  /// Blinkit signature green (the "Add Money" CTA, wallet lining).
  static const Color blinkitGreen = Color(0xFF1BA94C);
  static const Color blinkitGreenDark = Color(0xFF0F7D36);
  static const Color blinkitGreenDeep = Color(0xFF114D24);

  //  Wallet (3D illustration) --
  static const Color walletGoldLight = Color(0xFFF7CE4B);
  static const Color walletGoldMid = Color(0xFFE3A91D);
  static const Color walletGoldDeep = Color(0xFFB07E12);
  static const Color walletGoldShade = Color(0xFF8A6310);
  static const Color walletLiningLight = Color(0xFF3C9A3F);
  static const Color walletLiningDark = Color(0xFF1E5E20);
  static const Color rupeeBadge = Color(0xFFFDFDF8);
  static const Color rupeeGlyph = Color(0xFFE0A526);

  //  Confetti -
  static const List<Color> confetti = <Color>[
    Color(0xFFFF4D6D), // pink
    Color(0xFF2E7BE5), // blue
    Color(0xFFFFC93C), // yellow
    Color(0xFF3DDC84), // green
    Color(0xFF9B5DE5), // purple
    Color(0xFFFF7A2F), // orange
    Color(0xFF00C2C7), // teal
  ];

  //  Misc --
  static const Color scrim = Color(0x66000000);
  static const Color circleButton = Color(0x33000000);
  static const Color circleButtonBorder = Color(0x22FFFFFF);
}
