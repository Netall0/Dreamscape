import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uikit/uikit.dart';

void main() {
  group('AdaptiveButtonsGroup', () {
    testWidgets('enables', (tester) async {
      Widget wrapper(Widget child) => MaterialApp(
        home: Center(
          child: RepaintBoundary(
            child: SizedBox(
              width: 200,
              height: 100,
              child: Center(child: child),
            ),
          ),
        ),
      );
      await tester.pumpWidget(
        wrapper(
          AdaptiveButton.primary(onPressed: () {}, child: Text('enables')),
        ),
      );

      
      await expectLater(
        find.byType(RepaintBoundary).first,
        matchesGoldenFile('screens/adaptive_button_primary.png'),
      );
    });
  });
}
