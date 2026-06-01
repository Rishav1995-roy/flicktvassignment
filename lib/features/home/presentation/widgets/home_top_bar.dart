import 'package:flutter/material.dart';

import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/utils/stagger.dart';
import '../../../../core/widgets/circle_icon_button.dart';

/// The floating top bar: a back affordance (present from the first frame) and a
/// settings gear that fades in once the hero has landed - mirroring the
/// reference, where settings appears only after the intro settles.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    required this.intro,
    required this.settingsSegment,
    this.onBack,
    this.onSettings,
    super.key,
  });

  final Animation<double> intro;
  final IntervalSegment settingsSegment;
  final VoidCallback? onBack;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CircleIconButton(icon: Icons.arrow_back_ios_new, iconSize: 18, onTap: onBack),
        FadeSlideIn(
          animation: intro,
          segment: settingsSegment,
          beginOffset: const Offset(0, 0),
          beginScale: 0.7,
          child: CircleIconButton(
            icon: Icons.settings_outlined,
            onTap: onSettings,
          ),
        ),
      ],
    );
  }
}
