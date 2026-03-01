import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/database/database.dart';
import '../../../core/util/logger/logger.dart';
import '../model/stats_model.dart';
import 'i_stats_repository.dart';

final class StatsRepository with LoggerMixin implements IStatsRepository {
  StatsRepository({required AppDatabase appDatabase}) : _appDatabase = appDatabase;
  final AppDatabase _appDatabase;

  //health

  final _health = Health();

  static final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];
  //stats methods

  @override
  Future<double> getTotalSleepHours() async {
    try {
      final List<SleepInfoTableData> allModels = await _appDatabase.sleepDao.getAllSleepInfo();

      if (allModels.isEmpty) {
        return 0.0;
      }

      var total = 0.0;
      for (final model in allModels) {
        final sleepModel = StatsModel.fromDriftRow(model);
        final double hours = sleepModel.sleepTime.hour + (sleepModel.sleepTime.minute / 60.0);
        total += hours;
      }

      logger.info('Total sleep hours calculated: $total');
      return total;
    } on Object catch (e, st) {
      logger.error('Error calculating total sleep hours: $e', stackTrace: st);
      return 0.0;
    }
  }

  @override
  Future<double> getAverageSleepHours() async {
    try {
      final List<SleepInfoTableData> allModels = await _appDatabase.sleepDao.getAllSleepInfo();

      if (allModels.isEmpty) {
        return 0.0;
      }

      var total = 0.0;
      for (final model in allModels) {
        final sleepModel = StatsModel.fromDriftRow(model);
        final double hours = sleepModel.sleepTime.hour + (sleepModel.sleepTime.minute / 60.0);
        total += hours;
      }

      final double average = total / allModels.length;
      logger.info('Average sleep hours calculated: $average');
      return average;
    } on Object catch (e, st) {
      logger.error('Error calculating average sleep hours: $e', stackTrace: st);
      return 0.0;
    }
  }

  @override
  Future<List<StatsModel>> getSleepModel() async {
    try {
      final List<SleepInfoTableData> listSleepModels = await _appDatabase.sleepDao
          .getAllSleepInfo();
      logger.debug('Fetched ${listSleepModels.length} sleep models');
      return listSleepModels.map((e) => StatsModel.fromDriftRow(e)).toList();
    } on Object catch (e, st) {
      logger.error('Error getting sleep models: $e', stackTrace: st);
      return [];
    }
  }

  @override
  Future<void> addSleepModel(StatsModel sleepModel) async {
    try {
      if (sleepModel.id == null) {
        await _appDatabase.sleepDao.insertSleepInfo(
          sleepModel.toSleepInfoTableCompanion(sleepModel),
        );
      } else {
        await _updateSleepModel(sleepModel);
      }

      logger.info('Sleep model added successfully');
    } on Object catch (e, st) {
      logger.error('Error adding sleep model: $e', stackTrace: st);
    }
  }

  Future<void> _updateSleepModel(StatsModel sleepModel) async {
    try {
      await _appDatabase.sleepDao.updateSleepInfo(sleepModel.toSleepInfoTableCompanion(sleepModel));
      logger.info('Sleep model updated successfully');
    } on Object catch (e, st) {
      logger.error('Error updating sleep model: $e', stackTrace: st);
    }
  }

  @override
  Future<void> deleteSleepModel(int id) async {
    try {
      await _appDatabase.sleepDao.deleteSleepInfo(id);
      logger.info('Sleep model deleted successfully');
    } on Object catch (e, st) {
      logger.error('Error deleting sleep model: $e', stackTrace: st);
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _appDatabase.sleepDao.clearAll();
      logger.info('All sleep models cleared successfully');
    } on Object catch (e, st) {
      logger.error('Error clearing all sleep models: $e', stackTrace: st);
    }
  }

  @override
  Future<void> addFromHealth() async {
    try {
      final now = tz.TZDateTime.now(tz.local);
      final midnight = tz.TZDateTime(tz.local, now.year, now.month, now.day);

      final List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: _types,
      );

      final List<HealthDataPoint> unique = _health.removeDuplicates(data);

      final int steps = unique
          .where((p) => p.type == HealthDataType.STEPS)
          .fold<int>(0, (sum, p) => sum + (p.value as NumericHealthValue).numericValue.toInt());

      final double calories = unique
          .where((p) => p.type == HealthDataType.ACTIVE_ENERGY_BURNED)
          .fold<double>(
            0,
            (sum, p) => sum + (p.value as NumericHealthValue).numericValue.toDouble(),
          );

      final List<double> heartRates = unique
          .where((p) => p.type == HealthDataType.HEART_RATE)
          .map((p) => (p.value as NumericHealthValue).numericValue.toDouble())
          .toList();

      final double avgHeartRate = heartRates.isNotEmpty
          ? heartRates.reduce((a, b) => a + b) / heartRates.length
          : 0.0;

      final int sleepMinutes = unique
          .where((p) => p.type == HealthDataType.SLEEP_ASLEEP)
          .fold<int>(0, (sum, p) => sum + p.dateTo.difference(p.dateFrom).inMinutes);

      final int wakeMinutes = unique
          .where((p) => p.type == HealthDataType.SLEEP_AWAKE)
          .fold<int>(0, (sum, p) => sum + p.dateTo.difference(p.dateFrom).inMinutes);

      final int sleepData = midnight.millisecondsSinceEpoch;

      final sleepModel = StatsModel(
        sleepData: DateTime.fromMillisecondsSinceEpoch(sleepData),
        sleepQuality: SleepQuality.normal,
        sleepTime: TimeOfDay(hour: sleepMinutes ~/ 60, minute: sleepMinutes % 60),
        bedTime: TimeOfDay(hour: midnight.hour, minute: midnight.minute),
        riseTime: TimeOfDay(hour: now.hour, minute: now.minute),

        sleepNotes:
            'Imported from Health app - Steps: $steps, Calories: ${calories.toStringAsFixed(2)}, Avg Heart Rate: ${avgHeartRate.toStringAsFixed(2)} bpm, Sleep Duration: ${sleepMinutes ~/ 60}h ${sleepMinutes % 60}m, Awake Duration: ${wakeMinutes ~/ 60}h ${wakeMinutes % 60}m',
      );

      final today = DateTime.now();

      final SleepInfoTableData? existingData = await _appDatabase.sleepDao.getSleepInfoByDate(
        today,
      );

      if (existingData != null) {
        await _updateSleepModel(sleepModel);
        return;
      }

      await addSleepModel(sleepModel);

      logger.info('Data added from Health successfully');
    } on Object catch (e, st) {
      logger.error('Error adding data from health: $e', stackTrace: st);
    }
  }

  @override
  Future<void> healthRequestPermission() async {
    try {
      await _health.configure();
      await _health.requestAuthorization(_types);
    } on Object catch (e, st) {
      logger.error('Error requesting health permissions: $e', stackTrace: st);
    }
  }
}



//TODO mock mock mock repository for testing