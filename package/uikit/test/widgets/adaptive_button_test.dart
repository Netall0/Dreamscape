import 'package:alchemist/alchemist.dart';

import 'package:flutter/material.dart';

import 'package:uikit/widget/button.dart';

import '../flutter_test_config.dart';

void main() {
  testExecutable(() async {
    goldenTest(
      '$AdaptiveButton',
      fileName: 'adaptive_button',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'primary',
            child: Padding(
              padding: EdgeInsets.all(16),
              child: AdaptiveButton.primary(
                onPressed: () {},
                child: Text('primary'),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
