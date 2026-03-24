import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveAction extends StatelessWidget {
  const AdaptiveAction({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return switch (Platform.isIOS) {
      true => CupertinoDialogAction(onPressed: onPressed, child: child),
      false => TextButton(onPressed: onPressed, child: child),
    };
  }
}
