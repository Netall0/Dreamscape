import 'package:dreamscape/features/initialization/model/depend_container.dart';
import 'package:dreamscape/features/initialization/model/platform_depend_container.dart';
import 'package:flutter/material.dart';

final class DependScope extends InheritedWidget {
  const DependScope({
    super.key,
    required super.child,
    required this.dependModel,
    required this.platformDependContainer,
  });

  final DependContainer dependModel;
  final PlatformDependContainer platformDependContainer;

  static DependScope of(BuildContext context, {bool listen = false}) => listen
      ? context.dependOnInheritedWidgetOfExactType<DependScope>()!
      : context.getInheritedWidgetOfExactType<DependScope>()!;

  @override
  bool updateShouldNotify(covariant DependScope oldWidget) {
    return dependModel != oldWidget.dependModel ||
        platformDependContainer != oldWidget.platformDependContainer;
  }
}
