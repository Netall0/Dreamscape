import 'package:dreamscape/core/database/database.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/stats/model/stats_model.dart';
import 'package:dreamscape/features/stats/repository/i_stats_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class StatsRepository with LoggerMixin implements IStatsRepository {
  final AppDatabase _appDatabase;

  StatsRepository({
    required AppDatabase appDatabase,
    required SharedPreferences sharedPreferences,
  }) : _appDatabase = appDatabase;

  @override
  Future<List<StatsModel>> getSleepModel() async {
    try {
      final listSleepModels = await _appDatabase.sleepDao.getAllSleepInfo();
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
      await _appDatabase.sleepDao.updateSleepInfo(
        sleepModel.toSleepInfoTableCompanion(sleepModel),
      );
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

  // temp data

  @override
  Stream<List<StatsModel>> watchSleepModel() {
    try {
      final stream = _appDatabase.sleepDao.watchAllSleepInfo().map(
        (rows) => rows.map((e) => StatsModel.fromDriftRow(e)).toList(),
      );
      return stream;
    } on Object catch (e, st) {
      logger.error('Error watching sleep models: $e', stackTrace: st);
      return Stream.value([]);
    }
  }
}
