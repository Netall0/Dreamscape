import 'package:dreamscape/features/stats/repository/stats_repository.dart';
import 'package:flutter/material.dart';

final class StatsNotifier extends ChangeNotifier {
  final StatsRepository _statsRepository;

  StatsNotifier({required StatsRepository statsRepository})
    : _statsRepository = statsRepository;

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
