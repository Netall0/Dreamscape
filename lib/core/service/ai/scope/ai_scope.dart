import 'package:flutter/material.dart';

import '../controller/ai_controller.dart';

final class AiScope extends InheritedWidget {
  const AiScope({required super.child, required AiSleepController aiSleepController})
    : _aiSleepController = aiSleepController,
      super(key: const Key('AiScope'));

  final AiSleepController _aiSleepController;

  static AiSleepController of(BuildContext context) {
    final AiScope? result = context.dependOnInheritedWidgetOfExactType<AiScope>();
    assert(result != null, 'No AiScope found in context');
    return result!._aiSleepController;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
