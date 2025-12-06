import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uikit/colors/color_constant.dart';

enum DayTime {
  night('night'),
  day('day');

  final String value;
  const DayTime(this.value);
}

final class GradientBackgroundPainter extends CustomPainter {
  final double t;
  final DayTime dayTime;

  GradientBackgroundPainter({
    super.repaint,
    required this.t,
    required this.dayTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final wave = sin(t * 2 * pi);
    final gradient = LinearGradient(
      begin: Alignment(-wave, -1),
      end: Alignment(wave, 1),
      colors: [
        Color.lerp(ColorConstants.duskPurple, ColorConstants.nightViolet, t)!,
        Color.lerp(
          ColorConstants.pastelLavender,
          ColorConstants.pastelPurple,
          t,
        )!,
      ],
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant GradientBackgroundPainter oldDelegate) {
    return oldDelegate.t != t;
  }
}
