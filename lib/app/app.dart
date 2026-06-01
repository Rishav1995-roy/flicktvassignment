import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router/app_router.dart';
import 'router/app_routes.dart';

/// Root application widget.
///
/// Deliberately thin: it owns global concerns (theme, routing, semantics) and
/// nothing else. Feature screens are reached exclusively through [AppRouter].
class RishavMoneyApp extends StatelessWidget {
  const RishavMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rishav Deb Roy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
      // Clamp text scaling so the cinematic layout never breaks on devices with
      // very large accessibility font sizes, while still respecting moderate
      // user preferences.
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData mq = MediaQuery.of(context);
        final TextScaler clamped = mq.textScaler.clamp(
          minScaleFactor: 0.9,
          maxScaleFactor: 1.2,
        );
        return MediaQuery(
          data: mq.copyWith(textScaler: clamped),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
