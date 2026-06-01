// Smoke + behaviour tests for the Blinkit Money intro screen.
//
// These verify the screen boots, renders its key brand/CTA copy, and reaches
// its finished state. Note: the wallet's *ambient* breathing loops forever, so
// `pumpAndSettle` would never return — we advance the clock with fixed frames
// instead, which is also closer to how the screen runs in production.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rishavdebroy/app/app.dart';
import 'package:rishavdebroy/features/home/presentation/screens/blinkit_money_screen.dart';

/// Advances [duration] in discrete 16ms (~60fps) frames — safe with looping
/// animations where `pumpAndSettle` cannot converge.
Future<void> _pumpFrames(
  WidgetTester tester, {
  Duration duration = const Duration(seconds: 4),
}) async {
  const Duration frame = Duration(milliseconds: 16);
  for (int elapsed = 0; elapsed < duration.inMilliseconds; elapsed += frame.inMilliseconds) {
    await tester.pump(frame);
  }
}

void main() {
  testWidgets('App boots and shows the Blinkit Money hero', (WidgetTester tester) async {
    await tester.pumpWidget(const RishavMoneyApp());
    await _pumpFrames(tester);

    expect(find.text('blinkit'), findsOneWidget);
    expect(find.text('MONEY'), findsOneWidget);
    expect(find.text('Add Money'), findsOneWidget);
    expect(find.text('Claim Gift Card'), findsOneWidget);
  });

  testWidgets('All three benefit cards render', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BlinkitMoneyScreen()));
    await _pumpFrames(tester);

    expect(find.text('Single tap payments'), findsOneWidget);
    expect(find.text('Zero failures'), findsOneWidget);
    expect(find.text('Real-time refunds'), findsOneWidget);
  });
}
