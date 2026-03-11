import 'package:flutter/material.dart';

import '../../../util/logger/logger.dart';
import '../controller/ai_controller.dart';
import '../data/ai_sleep_service.dart';
import 'ai_scope.dart';

class AiScopeWrapper extends StatefulWidget {
  const AiScopeWrapper({super.key, required this.aiSleepService, required this.child});

  @override
  State<AiScopeWrapper> createState() => _AiScopeWrapperState();

  final AiSleepService aiSleepService;
  final Widget child;
}

class _AiScopeWrapperState extends State<AiScopeWrapper> with LoggerMixin {
  late final AiSleepController _controller;

  @override
  void initState() {
    _controller = AiSleepController(aiSleepService: widget.aiSleepService);
    logger.info('AiScopeWrapper initialized');
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    logger.info('AiScopeWrapper disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      AiScope(aiSleepController: _controller, child: widget.child);
}
