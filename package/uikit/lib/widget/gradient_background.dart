import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uikit/painter/gradient_background_painter.dart';
import 'package:uikit/theme/app_theme.dart';

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
    final AppTheme appTheme = Theme.of(context).extension<AppTheme>() ?? AppTheme.dark;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color overlayColor = isDark ? Colors.black : Colors.white;

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (_, _) {
            return CustomPaint(
              painter: GradientBackgroundPainter(
                t: _animationController.value,
                primaryA: appTheme.colors.primary,
                primaryB: appTheme.colors.secondary,
                surfaceA: appTheme.colors.surface,
                surfaceB: appTheme.colors.background,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),

        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            color: overlayColor.withValues(alpha: isDark ? 0.16 : 0.08),
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        widget.child,
      ],
    );
  }
}
