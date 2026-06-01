// TEMPORARY visual-capture harness (deleted after review).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rishavdebroy/features/home/presentation/screens/blinkit_money_screen.dart';

Future<void> _pump(WidgetTester tester, Duration d) async {
  for (int e = 0; e < d.inMilliseconds; e += 16) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

void main() {
  testWidgets('tall device final', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1290, 2796);
    tester.view.devicePixelRatio = 3.0;
    tester.view.viewPadding = const FakeViewPadding(top: 177, bottom: 102);
    tester.view.padding = const FakeViewPadding(top: 177, bottom: 102);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: BlinkitMoneyScreen()));
    await _pump(tester, const Duration(milliseconds: 3500));
    await expectLater(
      find.byType(BlinkitMoneyScreen),
      matchesGoldenFile('goldens/tall.png'),
    );
  });
}
