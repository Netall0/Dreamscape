import 'package:flutter/material.dart';

import '../model/stats_model.dart';
import 'i_stats_repository.dart';

final class FakeStatsRepository implements IStatsRepository {
  final List<StatsModel> _sleepModelsList = <StatsModel>[
    StatsModel(
      sleepDate: DateTime.now(),
      sleepQuality: SleepQuality.bad,
      sleepTime: const TimeOfDay(hour: 8, minute: 0),
      bedTime: const TimeOfDay(hour: 22, minute: 0),
      riseTime: const TimeOfDay(hour: 6, minute: 0),
      sleepNotes:
          'Imported from Health app - Steps: 11101, Calories: 2222  , Avg Heart Rate: 88 bpm, 40 m',
    ),
    StatsModel(
      sleepDate: DateTime.now(),
      sleepQuality: SleepQuality.bad,
      sleepTime: const TimeOfDay(hour: 8, minute: 0),
      bedTime: const TimeOfDay(hour: 22, minute: 0),
      riseTime: const TimeOfDay(hour: 6, minute: 0),
      sleepNotes:
          'Imported from Health app - Steps: 11101, Calories: 2222  , Avg Heart Rate: 88 bpm, 40 m',
    ),
  ];

  @override
  Future<void> addFromHealth() async {
    addSleepModel(
      StatsModel(
        sleepDate: DateTime.now(),
        sleepQuality: SleepQuality.bad,
        sleepTime: const TimeOfDay(hour: 8, minute: 0),
        bedTime: const TimeOfDay(hour: 22, minute: 0),
        riseTime: const TimeOfDay(hour: 6, minute: 0),
        sleepNotes:
            'Imported from Health app - Steps: 11101, Calories: 2222  , Avg Heart Rate: 88 bpm, 40 m',
      ),
    );
  }

  @override
  Future<void> addSleepModel(StatsModel sleepModel) async {
    _sleepModelsList.add(
      StatsModel(
        sleepDate: DateTime.now(),
        sleepQuality: SleepQuality.bad,
        sleepTime: const TimeOfDay(hour: 8, minute: 0),
        bedTime: const TimeOfDay(hour: 22, minute: 0),
        riseTime: const TimeOfDay(hour: 6, minute: 0),
        sleepNotes:
            'Imported from Health app - Steps: 11101, Calories: 2222  , Avg Heart Rate: 88 bpm, 40 m',
      ),
    );
  }

  @override
  Future<void> clearAll() async {
    _sleepModelsList.clear();
  }

  @override
  Future<void> deleteSleepModel(int id) async {
    _sleepModelsList.removeWhere((element) => element.id == id);
  }

  @override
  Future<double> getAverageSleepHours() async => 0.0;

  @override
  Future<List<StatsModel>> getSleepModel() async => _sleepModelsList;

  @override
  Future<double> getTotalSleepHours() async => 0.0;

  @override
  Future<void> healthRequestPermission() async {}
}
