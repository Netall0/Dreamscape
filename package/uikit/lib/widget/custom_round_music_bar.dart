import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uikit/painter/custom_round_music_bar_painter.dart';

class CustomRoundMusicBar extends StatefulWidget {
  const CustomRoundMusicBar({
    super.key,
    required this.isPlaying,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  final Duration animationDuration;

  final Stream<bool> isPlaying;

  @override
  State<CustomRoundMusicBar> createState() => _CustomRoundMusicBarState();
}

class _CustomRoundMusicBarState extends State<CustomRoundMusicBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  StreamSubscription<bool>? _subscription;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    super.initState();

    _subscription = widget.isPlaying.listen((isPLaying) {
      if (mounted) {
        if (isPLaying) {
          _animationController.repeat(reverse: true);
        } else {
          _animationController.stop();
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => CustomPaint(
        painter: CustomRoundMusicBarPainter(
          animationValue: _animationController.value,
        ),
      ),
    );
  }
}
