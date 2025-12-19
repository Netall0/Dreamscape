import 'package:flutter/material.dart';

final class CustomRoundMusicBarPainter extends CustomPainter {
  final double animationValue;

  CustomRoundMusicBarPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final baseRadius = size.width / 2;
    final scale = 1.0 + (animationValue * 0.15);
    final radius = baseRadius * scale;

    final opacity = 0.3 + (animationValue * 0.3);

    final paint = Paint()
      ..color = const Color(0xFF6B5B95).withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomRoundMusicBarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
