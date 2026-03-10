import 'package:flutter/material.dart';

import '../../initialization/widget/depend_scope.dart';
import '../model/stats_model.dart';

class AnalyzeStatsScreen extends StatefulWidget {
  const AnalyzeStatsScreen({super.key, required this.sleepHistory});

  final List<StatsModel> sleepHistory;

  @override
  State<AnalyzeStatsScreen> createState() => _AnalyzeStatsScreenState();
}

class _AnalyzeStatsScreenState extends State<AnalyzeStatsScreen> {
  @override
  void initState() {
    DependScope.of(
      context,
    ).dependModel.aiSleepController.analyzeSleepHistoryStream(widget.sleepHistory);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      



    );
  }
}
