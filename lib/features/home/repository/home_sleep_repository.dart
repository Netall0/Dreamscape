import 'package:dreamscape/core/database/database.dart';
import 'package:dreamscape/core/util/extension/time_of_day_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/home/model/sleep_model.dart';
import 'package:dreamscape/features/home/repository/i_home_sleep_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class HomeSleepRepository
    with LoggerMixin
    implements IHomeSleepRepository {
  final AppDatabase _appDatabase;
  final SharedPreferences _sharedPreferences;

  HomeSleepRepository({
    required AppDatabase appDatabase,
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences,
       _appDatabase = appDatabase;

  @override
  Future<List<SleepModel>> getSleepModel() async {
    try {
      final listSleepModels = await _appDatabase.sleepDao.getAllSleepInfo();
      logger.debug('Fetched ${listSleepModels.length} sleep models');
      return listSleepModels.map((e) => SleepModel.fromDriftRow(e)).toList();
    } on Object catch (e, st) {
      logger.error('Error getting sleep models: $e', stackTrace: st);
      return [];
    }
  }

  @override
  Future<void> addSleepModel(SleepModel sleepModel) async {
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

  Future<void> _updateSleepModel(SleepModel sleepModel) async {
    try {
      await _appDatabase.sleepDao.updateSleepInfo(
        sleepModel.toSleepInfoTableCompanion(sleepModel),
      );
      logger.info('Sleep model updated successfully');
    } on Object catch (e, st) {
      logger.error('Error updating sleep model: $e', stackTrace: st);
    }
  }

  @override
  Future<void> deleteSleepModel(SleepModel sleepModel) async {
    try {
      await _appDatabase.sleepDao.deleteSleepInfo(sleepModel.id!);
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

  // temp data

  static const String _bedTimeKey = 'bed_time';
  static const String _riseTimeKey = 'rise_time';

  @override
  Future<void> clearTempData() async {
    try {
      await _sharedPreferences.remove(_bedTimeKey);
      await _sharedPreferences.remove(_riseTimeKey);
      logger.info('Temporary sleep data cleared successfully');
    } on Object catch (e, st) {
      logger.error('Error clearing temp data: $e', stackTrace: st);
    }
  }

  @override
  Future<TimeOfDay?> getBedTime() async {
    try {
      final minutes = _sharedPreferences.getInt(_bedTimeKey);
      if (minutes == null) return null;
      return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    } on Object catch (e, st) {
      logger.error('Error getting bed time: $e', stackTrace: st);
      return null;
    }
  }

  @override
  Future<TimeOfDay?> getRiseTime() async {
    try {
      final minutes = _sharedPreferences.getInt(_riseTimeKey);
      if (minutes == null) return null;
      return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    } on Object catch (e, st) {
      logger.error('Error getting rise time: $e', stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> saveBedTime(TimeOfDay bedTime) async {
    try {
      final minutes = bedTime.hour * 60 + bedTime.minute;
      _sharedPreferences.setInt(_bedTimeKey, minutes);
      logger.info('Bed time saved successfully');
    } on Object catch (e, st) {
      logger.error('Error saving bed time: $e', stackTrace: st);
    }
  }

  @override
  Future<void> saveRiseTime(TimeOfDay riseTime) async {
    try {
      final minutes = riseTime.hour * 60 + riseTime.minute;
      _sharedPreferences.setInt(_riseTimeKey, minutes);
      logger.info('Rise time saved successfully');
    } on Object catch (e, st) {
      logger.error('Error saving rise time: $e', stackTrace: st);
    }
  }

  @override
  Future<SleepModel?> createSleepModelFromTemp({
    SleepQuality quality = SleepQuality.normal,
    String notes = '',
  }) async {
    try {
      final bedTime = await getBedTime();
      final riseTime = await getRiseTime();

      if (bedTime == null || riseTime == null) {
        logger.error('Cannot create sleep model: missing bed or rise time');
        return null;
      }

      final sleepTime = bedTime.calculationSleepTime(riseTime);

      final sleepModel = SleepModel(
        bedTime: bedTime,
        riseTime: riseTime,
        sleepTime: sleepTime,
        sleepQuality: quality,
        sleepNotes: notes,
      );

      await addSleepModel(sleepModel);

      await clearTempData();

      logger.info('Sleep model created from temp data successfully');

      return sleepModel;
    } on Object catch (e, st) {
      logger.error(
        'Error creating sleep model from temp data: $e',
        stackTrace: st,
      );
      rethrow;
    }
  }

  @override
  Stream<List<SleepModel>> watchSleepModel() {
    try {
      return _appDatabase.sleepDao.watchAllSleepInfo().map(
        (rows) => rows.map((e) => SleepModel.fromDriftRow(e)).toList(),
      );
    } on Object catch (e, st) {
      logger.error('Error watching sleep models: $e', stackTrace: st);
      return Stream.value([]);
    }
  }
}
