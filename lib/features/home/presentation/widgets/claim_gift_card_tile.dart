import 'package:flutter/material.dart';

import '../../../../core/animations/pressable.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The secondary "Claim Gift Card" row beneath the CTA. A compact, reusable
/// list tile with a leading gift glyph and a trailing chevron.
class ClaimGiftCardTile extends StatelessWidget {
  const ClaimGiftCardTile({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          // Opaque so the faint watermark band beneath never bleeds through it.
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[Color(0xFFB5651D), Color(0xFF7A3E12)],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(Icons.card_giftcard, size: 20, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Claim Gift Card', style: AppTextStyles.tileTitle),
                  SizedBox(height: 2),
                  Text(
                    'Enter gift card details to claim your gift card',
                    style: AppTextStyles.tileSubtitle,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
