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

          // 2. Foreground content. Honour the bottom inset so nothing clips
          //    behind the gesture/nav bar. The faint watermark lives at the
          //    foot of this content flow (below the gift-card row), not as a
          //    floating layer, so the gift card always sits clearly above it.
          SafeArea(
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

          // 3. Confetti burst — on top so it reads as falling in front of the
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
    // Hero (wallet + wordmark). Its entrance is self-driven by its own
    // segments, so it's a plain const-ish subtree here.
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
      ],
    );

    // Distribute the free vertical space with flex spacers so the composition
    // fills the screen on ANY device height (no dead space dumped at the
    // bottom). The largest share sits *between* the hero and the cards — the
    // OTT "room opens as the cards arrive" feel — with smaller top/bottom
    // margins.
    //
    // The IntrinsicHeight + min-height ConstrainedBox + scroll view is the
    // canonical "fill the viewport, but fall back to scrolling if the content
    // is genuinely taller than the screen" pattern — so the flex layout looks
    // perfect on normal devices yet can never overflow on very short screens or
    // at large accessibility text sizes.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Spacer(flex: 3),
                  hero,
                  const Spacer(flex: 6),
                  lowerContent,
                  const Spacer(flex: 2),
                  // Faint watermark sits at the foot of the flow — always
                  // below the gift-card row, never overlapping it.
                  FadeSlideIn(
                    animation: intro,
                    segment: IntroChoreography.watermark,
                    beginOffset: const Offset(0, 24),
                    child: const WatermarkText(),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
