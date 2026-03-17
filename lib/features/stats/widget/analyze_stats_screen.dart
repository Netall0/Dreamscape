import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uikit/theme/app_theme.dart';
import 'package:uikit/widget/card.dart';

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
  late final AiSleepController _controller;
  bool _analysisStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = AiScope.of(context);
    if (!_analysisStarted) {
      _analysisStarted = true;
      _startAnalysis();
    }
  }

  void _startAnalysis() {
    _controller.analyzeSleepHistoryStream(widget.sleepHistory).drain<void>();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Анализ сна')),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              switch (_controller) {
                final AiSleepController c when c.error != null => AdaptiveCard.outlined(
                  child: Text(c.error!),
                ),

                final AiSleepController c when c.isLoading && c.buffer.isEmpty => const Center(
                  child: CircularProgressIndicator(),
                ),

                final AiSleepController c when c.buffer.isNotEmpty => AdaptiveCard.outlined(
                  child: Padding(
                    padding: const .all(16),
                    child: Text(c.buffer + (c.isDone ? '' : ' ▍'), style: theme.typography.h3),
                  ),
                ),

                _ => const Center(child: Text('Подготовка анализа...')),
              },
            ],
          ),
        ),
      ),
    );
  }
}
