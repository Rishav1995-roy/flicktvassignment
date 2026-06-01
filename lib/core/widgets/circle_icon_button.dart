import 'package:flutter/material.dart';

import '../animations/pressable.dart';
import '../theme/app_colors.dart';

/// The frosted circular control used for the top-bar back / settings affordances
/// in the reference. A small, reusable building block — not a screen concern.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    required this.icon,
    this.onTap,
    this.size = 44,
    this.iconSize = 22,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.circleButton,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.circleButtonBorder),
        ),
        child: Icon(icon, size: iconSize, color: AppColors.textPrimary),
      ),
    );
  }
}
