import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uikit/theme/app_theme.dart';

import '../../../core/service/ai/controller/ai_controller.dart';
import '../../../core/service/ai/scope/ai_scope.dart';
import '../../../core/util/extension/app_context_extension.dart';
import '../model/stats_model.dart';

class AnalyzeStatsScreen extends StatefulWidget {
  const AnalyzeStatsScreen({super.key, required this.sleepHistory});

  final List<StatsModel> sleepHistory;

  @override
  State<AnalyzeStatsScreen> createState() => _AnalyzeStatsScreenState();
}

class _AnalyzeStatsScreenState extends State<AnalyzeStatsScreen> {
  late final StreamSubscription<String>? sub;
  late final AiSleepController _controller;

  @override
  void initState() {
    _controller = AiScope.of(context);

    _startAnalysis();
    super.initState(); //TOD
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  void _startAnalysis() {
    sub = _controller.analyzeSleepHistoryStream(widget.sleepHistory).listen((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Анализ сна')),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              if (_controller.isLoading || _controller.buffer.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (_controller.error != null)
                Center(child: Text(_controller.error!))
              else if (_controller.isDone) ...[
                Text(_controller.buffer, style: theme.typography.h3),
              ] else
                Text(
                  _controller.buffer + (_controller.isDone ? '' : ' ▍'),
                  style: theme.typography.h3,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
