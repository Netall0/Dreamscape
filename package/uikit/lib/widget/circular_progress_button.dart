// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uikit/layout/app_size.dart';
import 'package:uikit/theme/app_theme.dart';



class CircularProgressButton extends StatefulWidget {
  int value;
  final int maxValue;
  final double size;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  CircularProgressButton({
    super.key,
    required this.value,
    this.maxValue = 100,
    this.size = 64,
    this.progressColor = Colors.white,
    this.backgroundColor = const Color(0xFF2A2A2A),
    this.strokeWidth = AppSizes.double2,
  });

  @override
  State<CircularProgressButton> createState() => _CircularProgressButtonState();
}

class _CircularProgressButtonState extends State<CircularProgressButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _conrtoller;

  @override
  void initState() {
    super.initState();
    _conrtoller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () => setState(() {
              widget.value == 100 ? widget.value = 0 : widget.value += 1;
              print(widget.value);
            }),
            child: RepaintBoundary(
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: CircularProgressPainter(
                  progress: widget.value / widget.maxValue,
                  progressColor: widget.progressColor,
                  backgroundColor: widget.backgroundColor,
                  strokeWidth: widget.strokeWidth,
                ),
              ),
            ),
          ),
          // Текст в центре
          Text('${widget.value}', style: theme.typography.h3),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress; // От 0.0 до 1.0 (например, 0.14 = 14%)
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    //TODO туту жесть

    final progressPaint2 = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),

      -pi / 2,

      sweepAngle,

      false,

      progressPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 + sweepAngle,
      2 * pi - sweepAngle,
      false,
      progressPaint2,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
