import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

/// The faint "Enjoy seamless one tap payments" watermark bleeding off the
/// bottom edge - pure depth/atmosphere, kept very low contrast and
/// non-interactive so it never competes with the foreground.
class WatermarkText extends StatelessWidget {
  const WatermarkText({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Text(
        'Enjoy seamless\none tap payments',
        textAlign: TextAlign.center,
        style: AppTextStyles.watermark.copyWith(
          color: AppTextStyles.watermark.color?.withValues(alpha: 0.09),
        ),
      ),
    );
  }
}
