import "package:alchemist/alchemist.dart";
import "package:flutter/material.dart";

Future<void> testExecutable(Future<void> Function() testMain) async {
  const isRunningInCI = bool.fromEnvironment('CI', defaultValue: false);

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig.current().copyWith(
      goldenTestTheme:
          GoldenTestTheme.standard().copyWith(backgroundColor: Colors.white)
              as GoldenTestTheme?,

      platformGoldensConfig: const PlatformGoldensConfig(
        enabled: !isRunningInCI,
      ),
    ),
    run: testMain,
    
  );
}
