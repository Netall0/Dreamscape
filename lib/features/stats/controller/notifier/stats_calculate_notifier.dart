import 'package:dreamscape/features/stats/repository/stats_repository.dart';
import 'package:flutter/material.dart';

final class StatsCalculateNotifier extends ChangeNotifier {
  final StatsRepository _statsRepository;

  StatsCalculateNotifier({required StatsRepository statsRepository})
    : _statsRepository = statsRepository;

  double get totalSleepHours => _totalSleepHours;
  double get averageSleepHours => _averageSleepHours;
  int get sessionsCount => _sessionsCount;

  double _totalSleepHours = 0;
  double _averageSleepHours = 0.0;
  int _sessionsCount = 0;

  Future<void> setStats() async {
    _totalSleepHours = await _statsRepository.getTotalSleepHours();
    _averageSleepHours = await _statsRepository.getAverageSleepHours();
    _sessionsCount = await _statsRepository.getSessionsCount();
    notifyListeners();
  }
}
