import 'package:flutter/material.dart';

import '../../repository/i_stats_repository.dart';

final class StatsCalculateNotifier extends ChangeNotifier {
  StatsCalculateNotifier({required IStatsRepository statsRepository})
    : _statsRepository = statsRepository;
  final IStatsRepository _statsRepository;

  double get totalSleepHours => _totalSleepHours;
  double get averageSleepHours => _averageSleepHours;

  double _totalSleepHours = 0;
  double _averageSleepHours = 0.0;

  Future<void> setStats() async {
    _totalSleepHours = await _statsRepository.getTotalSleepHours();
    _averageSleepHours = await _statsRepository.getAverageSleepHours();
    notifyListeners();
  }
}
