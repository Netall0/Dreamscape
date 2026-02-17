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
    final bool isDark = appTheme.colors.background.computeLuminance() < 0.5;
    final Color overlayColor = isDark ? Colors.black : Colors.white;
    final Color primaryA = Color.lerp(
      appTheme.colors.primary,
      appTheme.colors.surface,
      isDark ? 0.25 : 0.45,
    )!;
    final Color primaryB = Color.lerp(
      appTheme.colors.secondary,
      appTheme.colors.background,
      isDark ? 0.3 : 0.5,
    )!;
    final Color surfaceA = Color.lerp(
      appTheme.colors.surface,
      appTheme.colors.background,
      isDark ? 0.2 : 0.4,
    )!;
    final Color surfaceB = Color.lerp(
      appTheme.colors.background,
      appTheme.colors.surface,
      isDark ? 0.2 : 0.35,
    )!;

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (_, _) {
            return CustomPaint(
              painter: GradientBackgroundPainter(
                t: _animationController.value,
                primaryA: primaryA,
                primaryB: primaryB,
                surfaceA: surfaceA,
                surfaceB: surfaceB,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),

        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            color: overlayColor.withValues(alpha: isDark ? 0.16 : 0.1),
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        widget.child,
      ],
    );
  }
}
