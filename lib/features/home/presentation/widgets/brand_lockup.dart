import 'package:flutter/material.dart';

import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/stagger.dart';

/// The "blinkit / MONEY" wordmark.
///
/// "blinkit" rises first, then "MONEY" fades up with a one-pass light **shimmer**
/// swept across the glyphs via [ShaderMask] - a premium touch achieved purely
/// with the SDK.
class BrandLockup extends StatelessWidget {
  const BrandLockup({
    required this.intro,
    required this.wordmarkSegment,
    required this.moneySegment,
    super.key,
  });

  final Animation<double> intro;
  final IntervalSegment wordmarkSegment;
  final IntervalSegment moneySegment;

  @override
  Widget build(BuildContext context) {
    final Animation<double> moneyAppear = moneySegment.drive(intro);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FadeSlideIn(
          animation: intro,
          segment: wordmarkSegment,
          beginOffset: const Offset(0, 14),
          child: const Text('blinkit', style: AppTextStyles.wordmark),
        ),
        const SizedBox(height: 6),
        FadeSlideIn(
          animation: intro,
          segment: moneySegment,
          beginOffset: const Offset(0, 18),
          beginScale: 0.92,
          child: AnimatedBuilder(
            animation: moneyAppear,
            child: const Text('MONEY', style: AppTextStyles.moneyDisplay),
            builder: (BuildContext context, Widget? child) {
              return ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (Rect bounds) => _shimmer(bounds, moneyAppear.value),
                child: child,
              );
            },
          ),
        ),
      ],
    );
  }

  /// A narrow bright band swept left→right exactly once as the word appears.
  /// The base glyph colour is a soft white; a pure-white streak rides over it.
  Shader _shimmer(Rect bounds, double t) {
    const Color base = Color(0xFFDDDDE0);
    const Color streak = Colors.white;
    final double pos = (t * 1.6) - 0.3; // travels from off-left to off-right
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: const <Color>[base, base, streak, base, base],
      stops: <double>[
        (pos - 0.25).clamp(0.0, 1.0),
        (pos - 0.08).clamp(0.0, 1.0),
        pos.clamp(0.0, 1.0),
        (pos + 0.08).clamp(0.0, 1.0),
        (pos + 0.25).clamp(0.0, 1.0),
      ],
    ).createShader(bounds);
  }
}
