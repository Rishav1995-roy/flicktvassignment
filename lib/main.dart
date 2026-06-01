import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'app/app.dart';

/// Application entry point.
///
/// Kept intentionally minimal: configure system chrome (edge-to-edge, dark
/// status-bar icons to match the cinematic backdrop) and hand off to
/// [RishavMoneyApp]. No business logic lives here.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Draw behind the status/navigation bars for a true full-bleed OTT canvas.
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0x00000000),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0x00000000),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // The hero choreography reads best in portrait.
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  runApp(const RishavMoneyApp());
}
