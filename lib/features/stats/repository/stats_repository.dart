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

  static final List<HealthDataType> _optionalTypes = [
    HealthDataType.SLEEP_IN_BED,
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

      List<HealthDataPoint> data;
      try {
        data = await _health.getHealthDataFromTypes(
          startTime: midnight,
          endTime: now,
          types: [..._types, ..._optionalTypes],
        );
      } on Object catch (e) {
        logger.error('Health optional types not available, retrying without: $e');
        data = await _health.getHealthDataFromTypes(
          startTime: midnight,
          endTime: now,
          types: _types,
        );
      }

      final List<HealthDataPoint> unique = _health
          .removeDuplicates(data)
          .fold<Map<String, HealthDataPoint>>(<String, HealthDataPoint>{}, (acc, p) {
            final key =
                '${p.type.name}_${p.dateFrom.millisecondsSinceEpoch}_${p.dateTo.millisecondsSinceEpoch}_${p.value}';
            acc.putIfAbsent(key, () => p);
            return acc;
          })
          .values
          .toList(growable: false);

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

      final int sleepAsleepMinutes = unique
          .where((p) => p.type == HealthDataType.SLEEP_ASLEEP)
          .fold<int>(0, (sum, p) => sum + p.dateTo.difference(p.dateFrom).inMinutes);

      final int sleepInBedMinutes = unique
          .where((p) => p.type == HealthDataType.SLEEP_IN_BED)
          .fold<int>(0, (sum, p) => sum + p.dateTo.difference(p.dateFrom).inMinutes);

      final int sleepMinutes = sleepAsleepMinutes > 0 ? sleepAsleepMinutes : sleepInBedMinutes;

      final int wakeMinutes = unique
          .where((p) => p.type == HealthDataType.SLEEP_AWAKE)
          .fold<int>(0, (sum, p) => sum + p.dateTo.difference(p.dateFrom).inMinutes);

      final List<HealthDataPoint> sleepPoints = unique
          .where(
            (p) =>
                p.type == HealthDataType.SLEEP_ASLEEP ||
                p.type == HealthDataType.SLEEP_AWAKE ||
                p.type == HealthDataType.SLEEP_IN_BED,
          )
          .toList(growable: false);

      DateTime sleepStart = midnight;
      DateTime sleepEnd = now;

      if (sleepPoints.isNotEmpty) {
        sleepStart = sleepPoints.first.dateFrom;
        sleepEnd = sleepPoints.first.dateTo;
        for (final p in sleepPoints) {
          if (p.dateFrom.isBefore(sleepStart)) {
            sleepStart = p.dateFrom;
          }
          if (p.dateTo.isAfter(sleepEnd)) {
            sleepEnd = p.dateTo;
          }
        }
      }

      final int sleepData = DateTime(
        sleepStart.year,
        sleepStart.month,
        sleepStart.day,
      ).millisecondsSinceEpoch;

      final int sleepHours = (sleepMinutes ~/ 60).clamp(0, 23);
      final int sleepMins = (sleepMinutes % 60).clamp(0, 59);

      final sleepModel = StatsModel(
        sleepDate: DateTime.fromMillisecondsSinceEpoch(sleepData),
        sleepQuality: SleepQuality.normal,
        sleepTime: TimeOfDay(hour: sleepHours, minute: sleepMins),
        bedTime: TimeOfDay(hour: sleepStart.hour, minute: sleepStart.minute),
        riseTime: TimeOfDay(hour: sleepEnd.hour, minute: sleepEnd.minute),

        sleepNotes:
            'Imported from Health app - Steps: $steps, Calories: ${calories.toStringAsFixed(2)}, Avg Heart Rate: ${avgHeartRate.toStringAsFixed(2)} bpm, Sleep Duration: ${sleepMinutes ~/ 60}h ${sleepMinutes % 60}m, Awake Duration: ${wakeMinutes ~/ 60}h ${wakeMinutes % 60}m',
      );

      final SleepInfoTableData? existingData = await _appDatabase.sleepDao.getSleepInfoByDate(
        DateTime.fromMillisecondsSinceEpoch(sleepData),
      );

      if (existingData != null) {
        await _updateSleepModel(sleepModel.copyWith(id: existingData.id));
        return;
      }

      await addSleepModel(sleepModel);

      logger.info('Data added from Health successfully');
    } on Object catch (e, st) {
      logger.error('Error adding data from health: $e', stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> healthRequestPermission() async {
    try {
      await _health.configure();
      try {
        await _health.requestAuthorization([..._types, ..._optionalTypes]);
      } on Object catch (e) {
        logger.error('Optional health types not available, retrying base types: $e');
        await _health.requestAuthorization(_types);
      }
    } on Object catch (e, st) {
      logger.error('Error requesting health permissions: $e', stackTrace: st);
      rethrow;
    }
  }
}

//TODO mock mock mock repository for testing
