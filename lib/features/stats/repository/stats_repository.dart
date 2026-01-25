import 'package:dreamscape/core/database/database.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/stats/model/stats_model.dart';
import 'package:dreamscape/features/stats/repository/i_stats_repository.dart';

final class StatsRepository with LoggerMixin implements IStatsRepository {
  final AppDatabase _appDatabase;

  StatsRepository({required AppDatabase appDatabase})
    : _appDatabase = appDatabase;

  //stats methods


  @override
  Future<double> getTotalSleepHours() async {
    try {
      final allModels = await _appDatabase.sleepDao.getAllSleepInfo();

      if (allModels.isEmpty) return 0.0;

      double total = 0.0;
      for (var model in allModels) {
        final sleepModel = StatsModel.fromDriftRow(model);
        final hours =
            sleepModel.sleepTime.hour + (sleepModel.sleepTime.minute / 60.0);
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
      final allModels = await _appDatabase.sleepDao.getAllSleepInfo();

      if (allModels.isEmpty) return 0.0;

      double total = 0.0;
      for (var model in allModels) {
        final sleepModel = StatsModel.fromDriftRow(model);
        final hours =
            sleepModel.sleepTime.hour + (sleepModel.sleepTime.minute / 60.0);
        total += hours;
      }

      final average = total / allModels.length;
      logger.info('Average sleep hours calculated: $average');
      return average;
    } on Object catch (e, st) {
      logger.error('Error calculating average sleep hours: $e', stackTrace: st);
      return 0.0;
    }
  }

  @override
  Future<int> getSessionsCount() async {
    try {
      final allModels = await _appDatabase.sleepDao.getAllSleepInfo();
      logger.info('Sessions count: ${allModels.length}');
      return allModels.length;
    } on Object catch (e, st) {
      logger.error('Error getting sessions count: $e', stackTrace: st);
      return 0;
    }
  }

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
}
