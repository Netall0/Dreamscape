import 'dart:math';

import 'package:flutter/material.dart';

final class GradientBackgroundPainter extends CustomPainter {
  final double t;
  final Color primaryA;
  final Color primaryB;
  final Color surfaceA;
  final Color surfaceB;

  GradientBackgroundPainter({
    super.repaint,
    required this.t,
    required this.primaryA,
    required this.primaryB,
    required this.surfaceA,
    required this.surfaceB,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final wave = sin(t * 2 * pi);
    final gradient = LinearGradient(
      begin: Alignment(-wave, -1),
      end: Alignment(wave, 1),
      colors: [
        Color.lerp(primaryA, primaryB, t)!,
        Color.lerp(surfaceA, surfaceB, t)!,
      ],
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant GradientBackgroundPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.primaryA != primaryA ||
        oldDelegate.primaryB != primaryB ||
        oldDelegate.surfaceA != surfaceA ||
        oldDelegate.surfaceB != surfaceB;
  }
}
