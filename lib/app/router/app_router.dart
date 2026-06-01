import 'package:flutter/material.dart';

import '../../features/home/presentation/screens/blinkit_money_screen.dart';
import 'app_routes.dart';

/// Single source of truth for route → screen wiring.
///
/// Uses `onGenerateRoute` (SDK-native) rather than a routing package. A custom
/// [PageRouteBuilder] gives us a cinematic cross-fade between screens that fits
/// the OTT aesthetic, while staying dependency-free.
abstract final class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      AppRoutes.home => const BlinkitMoneyScreen(),
      _ => const _UnknownRoute(),
    };
    return _fadeThrough(page, settings);
  }

  /// A subtle fade-through transition — premium, low-distraction.
  static PageRouteBuilder<dynamic> _fadeThrough(Widget page, RouteSettings settings) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, Animation<double> animation, _, Widget child) {
        final Animation<double> curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: Transform.scale(
            scale: Tween<double>(begin: 1.02, end: 1.0).evaluate(curved),
            child: child,
          ),
        );
      },
    );
  }
}

class _UnknownRoute extends StatelessWidget {
  const _UnknownRoute();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Route not found')));
}
