import 'package:flutter/material.dart';

import '../../model/stats_model.dart';
import '../../repository/stats_repository.dart';

final class StatsCalculateNotifier extends ChangeNotifier {

  StatsCalculateNotifier({required StatsRepository statsRepository})
    : _statsRepository = statsRepository;
  final StatsRepository _statsRepository;

  double get totalSleepHours => _totalSleepHours;
  double get averageSleepHours => _averageSleepHours;
  int get sessionCount => _sessionCount;
  double get shortestSleepHours => _shortestSleepHours;
  double get longestSleepHours => _longestSleepHours;

  double _totalSleepHours = 0;
  double _averageSleepHours = 0.0;
  int _sessionCount = 0;
  double _shortestSleepHours = 0.0;
  double _longestSleepHours = 0.0;

  Future<void> setStats() async {
    _totalSleepHours = await _statsRepository.getTotalSleepHours();
    _averageSleepHours = await _statsRepository.getAverageSleepHours();
    final List<StatsModel> sleepModels = await _statsRepository.getSleepModel();
    _sessionCount = sleepModels.length;

    if (sleepModels.isEmpty) {
      _shortestSleepHours = 0.0;
      _longestSleepHours = 0.0;
    } else {
      final List<double> durations = sleepModels
          .map((model) => model.sleepTime.hour + model.sleepTime.minute / 60.0)
          .toList();
      durations.sort();
      _shortestSleepHours = durations.first;
      _longestSleepHours = durations.last;
    }

    notifyListeners();
  }
}
