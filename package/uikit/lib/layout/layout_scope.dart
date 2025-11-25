import 'package:flutter/material.dart';
import 'package:uikit/layout/app_size.dart';

class LayoutInherited extends InheritedWidget {
  final int columns;
  final EdgeInsets padding;
  final double spacing;
  final double fontSize;
  const LayoutInherited({
    super.key,
    required this.columns,
    required super.child,
    required this.padding,
    required this.spacing,
    required this.fontSize,
  });

  static LayoutInherited of(BuildContext context, {bool listen = true}) {
    return listen
        ? context.dependOnInheritedWidgetOfExactType<LayoutInherited>()!
        : context
                  .getElementForInheritedWidgetOfExactType<LayoutInherited>()!
                  .widget
              as LayoutInherited;
  }

  @override
  bool updateShouldNotify(LayoutInherited oldWidget) => false;
}

class LayoutScope extends StatelessWidget {
  final Widget child;
  const LayoutScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int columns;
        final EdgeInsets sizes;
        final double spacing;
        if (width > 1024) {
          columns = 4;
          spacing = AppSizes.double20;
          sizes = EdgeInsets.all(AppSizes.double20);
        } else if (width > 768) {
          spacing = AppSizes.double16;
          columns = 3;
          sizes = EdgeInsets.all(AppSizes.double16);
        } else {
          columns = 2;
          spacing = AppSizes.double12;
          sizes = EdgeInsets.all(AppSizes.double12);
        }
        return LayoutInherited(
          padding: sizes,
          spacing: spacing,
          columns: columns,
          fontSize: 12,
          child: child,
        );
      },
    );
  }
}
