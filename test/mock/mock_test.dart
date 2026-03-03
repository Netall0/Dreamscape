import 'package:dreamscape/features/stats/model/stats_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'data/mock_stats_repository.dart';

void main() {
  late MockStatsRepository mockRepository;
  test('mock test', () {
    mockRepository = MockStatsRepository();

    when(() => mockRepository.getSleepModel()).thenAnswer(
      (_) async => [
        StatsModel(
          sleepDate: DateTime.now(),
          sleepQuality: SleepQuality.good,
          sleepTime: const TimeOfDay(hour: 8, minute: 0),
          bedTime: const TimeOfDay(hour: 22, minute: 0),
          riseTime: const TimeOfDay(hour: 6, minute: 0),
          sleepNotes:
              'Imported from Health app - Steps: 11101, Calories: 2222  , Avg Heart Rate: 88 bpm, 40 m',
        ),
      ],
    );
  });
}
