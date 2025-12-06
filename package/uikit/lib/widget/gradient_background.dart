import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uikit/painter/gradient_background_painter.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (_, _) {
            return CustomPaint(
              painter: GradientBackgroundPainter(t: _animationController.value,dayTime: DayTime.day),
              child: const SizedBox.expand(),
            );
          },
        ),

        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            color: Colors.black.withValues(alpha: 0.1),
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        widget.child,
      ],
    );
  }
}
