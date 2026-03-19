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
  late AiSleepController
  _controller; //delete "final" becose it will be initialized in didChangeDependencies
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

  Map<String, String> _parseSections(String buffer) {
    final sections = <String, String>{};

    final pattern = {
      'score': RegExp(r'Оценка сна[:\s]+(.+?)(?=Что вижу|$)', dotAll: true),
      'data': RegExp(r'Что вижу по данным[:\s]*\n(.+?)(?=Риски|$)', dotAll: true),
      'risks': RegExp(r'Риски[:\s]*\n(.+?)(?=Что делать|$)', dotAll: true),
      'actions': RegExp(r'Что делать дальше[:\s]*\n(.+?)$', dotAll: true),
    };

    for (final MapEntry<String, RegExp> e in pattern.entries) {
      final Match? match = e.value.firstMatch(buffer);
      if (match != null) {
        sections[e.key] = match.group(1) ?? '';
      }
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.analyzeTitle)),
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

                final AiSleepController c when c.buffer.isNotEmpty => AdaptiveCard(
                  backgroundColor: Colors.transparent.withOpacity(0.1),
                  child: Padding(
                    padding: const .all(16),
                    child: Text(c.buffer + (c.isDone ? '' : ' ▍'), style: theme.typography.h3),
                  ),
                ),

                _ => Center(child: Text(context.l10n.analyzePreparing)),
              },
            ],
          ),
        ),
      ),
    );
  }
}
