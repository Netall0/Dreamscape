import 'package:dreamscape/features/home/model/sleep_model.dart';
import 'package:flutter/material.dart';

abstract interface class IHomeSleepRepository {
  Future<List<SleepModel>> getSleepModel();
  Future<void> addSleepModel(SleepModel sleepModel);
  Future<void> deleteSleepModel(SleepModel sleepModel);
  Future<void> clearAll();

  // temp

  Future<void> saveBedTime(TimeOfDay bedTime);
  Future<TimeOfDay?> getBedTime();
  Future<void> saveRiseTime(TimeOfDay riseTime);
  Future<TimeOfDay?> getRiseTime();
  Future<void> clearTempData();

  // createSleepModelFromTemp

  Future<SleepModel?> createSleepModelFromTemp({
    required SleepQuality quality,
    String notes = '',
  });
}
