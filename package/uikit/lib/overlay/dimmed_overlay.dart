import 'package:flutter/material.dart';
import 'package:uikit/overlay/dimmed_overlay_level.dart';

class DimmedOverlay extends StatelessWidget {
  const DimmedOverlay(this.level, {super.key});

  final DimLevel level;

  double _getOpacity(DimLevel level) {
    switch (level) {
      case DimLevel.light:
        return 0.2;
      case DimLevel.medium:
        return 0.4;
      case DimLevel.strong:
        return 0.6;
      case DimLevel.none:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: AnimatedOpacity(
        curve: Curves.bounceIn,
        opacity: _getOpacity(level),
        duration: Duration(seconds: 5),
        child: Container(color: Colors.black.withValues(alpha: 0.4)),
      ),
    );
  }
}
