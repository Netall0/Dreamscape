import 'package:dreamscape/feature/initialization/model/depend_container.dart';
import 'package:flutter/material.dart';

final class DependScope extends InheritedWidget {
  const DependScope({
    super.key,
    required super.child,
    required this.dependModel,
  });

  final DependContainer dependModel;

  static DependScope of(BuildContext context, {bool listen = false}) => listen
      ? context.dependOnInheritedWidgetOfExactType<DependScope>()!
      : context.getInheritedWidgetOfExactType<DependScope>()!;

  @override
  bool updateShouldNotify(covariant DependScope oldWidget) {
    return dependModel != oldWidget.dependModel;
  }
}
