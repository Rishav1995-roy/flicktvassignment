import 'package:flutter/material.dart';

import '../animations/pressable.dart';
import '../constants/app_spacing.dart';
import '../theme/app_gradients.dart';
import '../theme/app_text_styles.dart';

/// A reusable, full-width gradient CTA with tactile press feedback and a soft
/// brand-coloured glow. Used for "Add Money"; generic enough for any primary
/// action.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    this.onTap,
    this.gradient = AppGradients.cta,
    this.height = 56,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final Gradient gradient;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x4D1BA94C),
              blurRadius: 24,
              spreadRadius: -4,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}
