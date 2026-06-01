import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/stagger.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/intro_choreography.dart';
import '../widgets/brand_lockup.dart';
import '../widgets/claim_gift_card_tile.dart';
import '../widgets/confetti_layer.dart';
import '../widgets/feature_list.dart';
import '../widgets/halftone_background.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/wallet_badge.dart';
import '../widgets/watermark_text.dart';

/// The Blinkit Money intro screen - the deliverable that recreates the
/// reference video.
///
/// ## Animation architecture
/// Three tickers, each with a single clear responsibility:
///  1. [_intro]    – the one-shot master timeline. Every entrance is an
///     [IntervalSegment] of this (see [IntroChoreography]). One controller →
///     everything stays frame-locked and there is a single rebuild source.
///  2. [_confetti] – the one-shot particle burst (its own pacing, longer tail).
///  3. [_ambient]  – a looping ticker driving the wallet's perpetual breathing.
///
/// Heavy layers ([ConfettiLayer], [HalftoneBackground]) sit behind
/// [RepaintBoundary]s so their painting never invalidates the rest of the tree.
/// All controllers are disposed in [dispose]. "Reduce motion" is honoured by
/// snapping the timeline to its end state.
class BlinkitMoneyScreen extends StatefulWidget {
  const BlinkitMoneyScreen({super.key});

  @override
  State<BlinkitMoneyScreen> createState() => _BlinkitMoneyScreenState();
}

class _BlinkitMoneyScreenState extends State<BlinkitMoneyScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: AppDurations.intro,
  );
  late final AnimationController _confetti = AnimationController(
    vsync: this,
    duration: AppDurations.confetti,
  );
  late final AnimationController _ambient = AnimationController(
    vsync: this,
    duration: AppDurations.walletIdle,
  );

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    // Decide here (not initState) so MediaQuery — and the user's reduce-motion
    // preference — is available.
    if (context.reduceMotion) {
      _intro.value = 1;
      _ambient.value = 0.5; // neutral resting pose
    } else {
      _intro.forward();
      _confetti.forward();
      _ambient.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    _confetti.dispose();
    _ambient.dispose();
    super.dispose();
  }

  void _noop() {}

  @override
  Widget build(BuildContext context) {
    final List<IntervalSegment> cardSegments = IntroChoreography.cards;
    final double walletSize = context.isCompactHeight ? 120 : 136;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 1. Static cinematic backdrop (cached layer).
          const Positioned.fill(child: HalftoneBackground()),

          // 2. Faint depth watermark bleeding off the bottom edge.
          Positioned(
            left: 0,
            right: 0,
            bottom: -6,
            child: FadeSlideIn(
              animation: _intro,
              segment: IntroChoreography.watermark,
              beginOffset: const Offset(0, 30),
              child: const WatermarkText(),
            ),
          ),

          // 3. Foreground content.
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  HomeTopBar(
                    intro: _intro,
                    settingsSegment: IntroChoreography.topBar,
                    onBack: _noop,
                    onSettings: _noop,
                  ),
                  Expanded(
                    child: _IntroContent(
                      intro: _intro,
                      ambient: _ambient,
                      walletSize: walletSize,
                      cardSegments: cardSegments,
                      onAddMoney: _noop,
                      onClaimGift: _noop,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Confetti burst — on top so it reads as falling in front of the
          //    hero, exactly as in the reference. Isolated + non-interactive.
          ConfettiLayer(progress: _confetti),
        ],
      ),
    );
  }
}

/// The vertically-choreographed body: the hero promotes from centre toward the
/// top while the cards / CTA cascade into the space it opens up.
///
/// Split into its own widget so the promote rebuild is scoped tightly and the
/// [Scaffold] above never rebuilds during the animation.
class _IntroContent extends StatelessWidget {
  const _IntroContent({
    required this.intro,
    required this.ambient,
    required this.walletSize,
    required this.cardSegments,
    required this.onAddMoney,
    required this.onClaimGift,
  });

  final Animation<double> intro;
  final Animation<double> ambient;
  final double walletSize;
  final List<IntervalSegment> cardSegments;
  final VoidCallback onAddMoney;
  final VoidCallback onClaimGift;

  @override
  Widget build(BuildContext context) {
    final Animation<double> promote = IntroChoreography.promote.drive(intro);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Space that vertically centres the hero before it promotes upward.
        final double heroBlock = walletSize + 110;
        final double centreSpacer =
            ((constraints.maxHeight - heroBlock) / 2 - 24).clamp(0.0, constraints.maxHeight);
        const double topSpacer = AppSpacing.sm;

        // The hero + brand never change during the cascade, so build them once
        // and hand them to the AnimatedBuilder as a cached `child`.
        final Widget hero = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            WalletBadge(
              intro: intro,
              ambient: ambient,
              segment: IntroChoreography.wallet,
              size: walletSize,
            ),
            const SizedBox(height: AppSpacing.md),
            BrandLockup(
              intro: intro,
              wordmarkSegment: IntroChoreography.wordmark,
              moneySegment: IntroChoreography.money,
            ),
          ],
        );

        final Widget lowerContent = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: AppSpacing.md),
            FeatureList(intro: intro, segments: cardSegments),
            const SizedBox(height: AppSpacing.lg),
            FadeSlideIn(
              animation: intro,
              segment: IntroChoreography.addMoney,
              beginOffset: const Offset(0, 24),
              beginScale: 0.96,
              child: PrimaryButton(label: 'Add Money', onTap: onAddMoney),
            ),
            const SizedBox(height: AppSpacing.md),
            FadeSlideIn(
              animation: intro,
              segment: IntroChoreography.giftTile,
              beginOffset: const Offset(0, 22),
              child: ClaimGiftCardTile(onTap: onClaimGift),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        );

        return AnimatedBuilder(
          animation: promote,
          child: hero,
          builder: (BuildContext context, Widget? heroChild) {
            final double spacer = ui.lerpDouble(centreSpacer, topSpacer, promote.value)!;
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                  SizedBox(height: spacer),
                  heroChild!,
                  lowerContent,
                ],
              ),
            );
          },
        );
      },
    );
  }
}
